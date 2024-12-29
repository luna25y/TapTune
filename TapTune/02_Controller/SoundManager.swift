//
//  SoundManager.swift
//  TapTune
//
//  Created by luna on 2024-12-29.
//

// 声音管理器

import Foundation
import AVFoundation
import Combine
import UniformTypeIdentifiers
import AppKit

// 自定义声音结构
struct CustomSound: Codable, Identifiable {
    let id: UUID
    let name: String
    let urlString: String // 使用字符串存储 URL
    
    var url: URL? {
        URL(string: urlString)
    }
    
    init(id: UUID = UUID(), name: String, url: URL) {
        self.id = id
        self.name = name
        self.urlString = url.absoluteString
    }
}

extension Notification.Name {
    static let settingsChanged = Notification.Name("settingsChanged")
}

class SoundManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioPlayers: [AVAudioPlayer] = []
    @Published var customSounds: [CustomSound] = []
    @Published var customSoundName: String {
        didSet {
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
        }
    }
    @Published var volume: Double {
        didSet {
            updateVolume()
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
        }
    }
    @Published var currentSoundType: SoundType {
        didSet {
            NotificationCenter.default.post(name: .settingsChanged, object: nil)
        }
    }
    private var currentCustomSound: CustomSound?
    
    override init() {
        // 从保存的设置中加载
        let settings = AppSettings.loadSettings()
        self.volume = settings.volume
        self.currentSoundType = settings.soundType
        self.customSoundName = settings.customSoundName ?? ""
        
        super.init()
        
        // 加载自定义声音
        loadCustomSounds()
        
        // 如果当前是自定义声音类型，尝试恢复上次选择的自定义声音
        if currentSoundType == .custom,
           let soundName = settings.customSoundName,
           let sound = customSounds.first(where: { $0.name == soundName }) {
            selectCustomSound(sound)
        }
    }
    
    /// 加载自定义声音
    private func loadCustomSounds() {
        if let data = UserDefaults.standard.data(forKey: "CustomSounds"),
           let sounds = try? JSONDecoder().decode([CustomSound].self, from: data) {
            self.customSounds = sounds.filter { $0.url != nil } // 只保留有效的 URL
        }
    }
    
    /// 保存自定义声音列表
    private func saveCustomSounds() {
        if let data = try? JSONEncoder().encode(customSounds) {
            UserDefaults.standard.set(data, forKey: "CustomSounds")
        }
    }
    
    /// 选择自定义声音
    func selectCustomSound(_ sound: CustomSound) {
        currentCustomSound = sound
        customSoundName = sound.name
        currentSoundType = .custom
        NotificationCenter.default.post(name: .settingsChanged, object: nil)
    }
    
    /// 导入自定义声音
    func importCustomSound() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType.audio]
        panel.allowsMultipleSelection = false
        
        panel.begin { [weak self] response in
            guard let self = self else { return }
            
            if response == .OK, let url = panel.url {
                if let audioPlayer = try? AVAudioPlayer(contentsOf: url) {
                    if audioPlayer.duration > 2.0 {
                        self.showAlert(message: LanguageManager.shared.localizedString(.soundTooLong))
                        return
                    }
                    
                    self.showNameInputDialog { name in
                        if let name = name {
                            // 创建新的自定义声音
                            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let destinationURL = documentsPath.appendingPathComponent("\(UUID().uuidString).mp3")
                            
                            try? FileManager.default.copyItem(at: url, to: destinationURL)
                            
                            let customSound = CustomSound(name: name, url: destinationURL)
                            self.customSounds.append(customSound)
                            self.saveCustomSounds()
                            
                            // 自动选择新添加的声音
                            self.selectCustomSound(customSound)
                            self.playTestSounds(type: .custom, times: 5)
                        }
                    }
                } else {
                    self.showAlert(message: LanguageManager.shared.localizedString(.cantReadSound))
                }
            }
        }
    }
    
    /// 播放指定类型的声音
    func playSound(type: SoundType) {
        let soundURL: URL?
        
        switch type {
        case .custom:
            soundURL = currentCustomSound?.url
        case .tofu, .clicky:
            soundURL = Bundle.main.url(forResource: type.rawValue, withExtension: "mp3")
        }
        
        guard let url = soundURL else {
            print("找不到声音文件")
            return
        }
        
        do {
            // 创建新的播放器实例
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = Float(volume)
            player.prepareToPlay()
            player.play()
            
            // 清理已经完成播放的播放器
            cleanupFinishedPlayers()
            
            // 添加新的播放器到数组
            audioPlayers.append(player)
            
            // 设置播放完成后的回调
            player.delegate = self
            
        } catch {
            print("播放声音失败: \(error)")
        }
    }
    
    /// 清理已经完成播放的播放器
    private func cleanupFinishedPlayers() {
        audioPlayers = audioPlayers.filter { player in
            // 只保留正在播放或者刚刚开始播放的播放器
            player.isPlaying || player.currentTime < 0.1
        }
    }
    
    /// 更新所有正在播放的声音的音量
    private func updateVolume() {
        audioPlayers.forEach { player in
            player.volume = Float(volume)
        }
    }
    
    /// 显示命名对话框
    private func showNameInputDialog(completion: @escaping (String?) -> Void) {
        let alert = NSAlert()
        alert.messageText = LanguageManager.shared.localizedString(.nameCustomSound)
        alert.informativeText = LanguageManager.shared.localizedString(.enterSoundName)
        
        let textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        textField.stringValue = customSoundName
        alert.accessoryView = textField
        
        alert.addButton(withTitle: LanguageManager.shared.localizedString(.ok))
        alert.addButton(withTitle: LanguageManager.shared.localizedString(.cancel))
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            completion(textField.stringValue)
        } else {
            completion(nil)
        }
    }
    
    /// 显示错误提示
    private func showAlert(message: String) {
        let alert = NSAlert()
        alert.messageText = LanguageManager.shared.localizedString(.error)
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: LanguageManager.shared.localizedString(.ok))
        alert.runModal()
    }
    
    /// 连续播放指定次数的声音
    /// - Parameters:
    ///   - type: 声音类型
    ///   - times: 播放次数
    func playTestSounds(type: SoundType, times: Int) {
        // 创建个串行队列来按顺序播放声音
        let queue = DispatchQueue(label: "com.taptune.soundqueue")
        
        for i in 0..<times {
            queue.asyncAfter(deadline: .now() + Double(i) * 0.2) { [weak self] in
                self?.playSound(type: type)
            }
        }
    }
    
    /// 获取当前声音类型的显示名称
    func getCurrentSoundName() -> String {
        switch currentSoundType {
        case .tofu:
            return LanguageManager.shared.localizedString(.tofu)
        case .clicky:
            return LanguageManager.shared.localizedString(.clicky)
        case .custom:
            return customSoundName
        }
    }
}

// 直接实现代理方法，不需要重复声明协议
extension SoundManager {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // 播放完成后从数组中移除
        if let index = audioPlayers.firstIndex(of: player) {
            audioPlayers.remove(at: index)
        }
    }
}
