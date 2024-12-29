//
//  MenuBarManager.swift
//  TapTune
//
//  Created by luna on 2024-12-29.
//

// 菜单栏管理器

import SwiftUI

class MenuBarManager {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover
    private let soundManager: SoundManager
    
    init(soundManager: SoundManager) {
        self.soundManager = soundManager
        
        popover = NSPopover()
        popover.contentSize = NSSize(width: 240, height: 280)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: MenuBarView(soundManager: soundManager)
        )
        
        // 创建状态栏图标
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "Keyboard")
            button.action = #selector(togglePopover)
            button.target = self
        }
        
        // 添加设置变更观察者
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSettingsChanged),
            name: .settingsChanged,
            object: nil
        )
    }
    
    @objc private func togglePopover() {
        if let button = statusItem?.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
    
    @objc private func handleSettingsChanged() {
        saveSettings()
    }
    
    // 定义保存设置的key
    private let settingsKey = "AppSettings"

    // 保存设置信息
    func saveSettings() {
        let currentVolume = soundManager.volume
        let currentSoundType = soundManager.currentSoundType
        let currentCustomSoundName = soundManager.customSoundName
        
        AppSettings.saveSettings(
            volume: currentVolume,
            language: LanguageManager.shared.currentLanguage,
            soundType: currentSoundType,
            customSoundName: currentCustomSoundName
        )
        
        // 保存后打印实际保存的值
        print("\n保存后 - 实际保存的值:")
        print("音量: \(currentVolume)")
        print("声音类型: \(currentSoundType)")
        print("自定义声音: \(currentCustomSoundName)")
    }
}
