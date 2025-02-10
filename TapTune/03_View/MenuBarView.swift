// 菜单栏视图，负责显示和处理所有用户界面交互

import SwiftUI

struct MenuBarView: View {
    @ObservedObject var soundManager: SoundManager
    @StateObject private var languageManager = LanguageManager.shared
    @Environment(\.scenePhase) private var scenePhase
    
    init(soundManager: SoundManager) {
        self.soundManager = soundManager
    }
    
    // 添加一个用于切换语言的函数
    private func toggleLanguage() {
        switch languageManager.currentLanguage {
        case .chinese:
            languageManager.setLanguage(.english)
        case .english:
            languageManager.setLanguage(.japanese)
        case .japanese:
            languageManager.setLanguage(.chinese)
        }
    }
    
    var body: some View {
        VStack(spacing: 3) {
            // 添加一个顶部空白区域
            Color.clear
                .frame(height: 8)
            
            // 键盘类型选择和上传按钮的水平布局
            HStack(spacing: 2) {
                // 键盘类型选择（下拉列表）
                Menu {
                    // 预设声音选项
                    Button(action: {
                        soundManager.currentSoundType = .tofu
                        soundManager.playTestSounds(type: .tofu, times: 5)
                    }) {
                        HStack {
                            Text(languageManager.localizedString(.tofu))
                            if soundManager.currentSoundType == .tofu {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    Button(action: {
                        soundManager.currentSoundType = .clicky
                        soundManager.playTestSounds(type: .clicky, times: 5)
                    }) {
                        HStack {
                            Text(languageManager.localizedString(.clicky))
                            if soundManager.currentSoundType == .clicky {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                    
                    // 自定义声音选项
                    ForEach(soundManager.customSounds, id: \.name) { sound in
                        Button(action: {
                            soundManager.selectCustomSound(sound)
                            soundManager.playTestSounds(type: .custom, times: 5)
                        }) {
                            HStack {
                                Text(sound.name)
                                if soundManager.currentSoundType == .custom &&
                                   soundManager.customSoundName == sound.name {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(soundManager.getCurrentSoundName())
                            .font(.body)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .frame(width: 120) // 设置下拉列表的固定宽度
                
                // 上传自定义声音按钮
                Button(action: { soundManager.importCustomSound() }) {
                    HStack(spacing: 1) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 11))
                        Text(languageManager.localizedString(.add))
                            .font(.body)
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10) // 添加底部间距

            
            // 音量控制
            VolumeSliderView(volume: $soundManager.volume, onVolumeChanged: {
                soundManager.playTestSounds(type: soundManager.currentSoundType, times: 2)
            })
                .padding(.horizontal, 18)
                .padding(.bottom, 12) // 添加底部间距
            
            Divider()
                .padding(.horizontal, 16)
                .padding(.bottom, 10) // 添加底部间距
            
            // 底部区域：luna 标签、语言切换和退出按钮
            HStack {
                // luna 标签
                HStack(spacing: 4) {
                    Image(systemName: "heart")
                        .foregroundColor(.mint)
                    Text("luna")
                        .foregroundColor(.mint)
                }
                
                // 语言切换按钮
                Button(action: toggleLanguage) {
                    HStack(spacing: 4) {
                        Image(systemName: "globe")
                            .foregroundColor(.gray)
                        Text(languageManager.currentLanguage.displayText)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading, 8)
                
                Spacer()
                
                // 退出按钮
                Button(action: {
                    // 获取 MenuBarManager 实例并保存设置
                    if let appDelegate = (NSApplication.shared.delegate as? TapTuneApp) {
                        appDelegate.menuBarManager.saveSettings()
                    }
                    NSApplication.shared.terminate(nil)
                }) {
                    Text(languageManager.localizedString(.quit))
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(width: 240) // 减小整体宽度
        .padding(.vertical, 16)
    }
}

// 添加一个扩展来获取语言显示文本
extension LanguageType {
    var displayText: String {
        switch self {
        case .chinese:
            return "中文"
        case .english:
            return "En"
        case .japanese:
            return "日本語"
        }
    }
}
