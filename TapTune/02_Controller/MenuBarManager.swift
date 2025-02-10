// 菜单栏管理器

import SwiftUI

class MenuBarManager {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover
    private let soundManager: SoundManager
    
    init(soundManager: SoundManager) {
        print("MenuBarManager - 开始初始化")
        self.soundManager = soundManager
        
        // 配置 popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 240, height: 280)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(
            rootView: MenuBarView(soundManager: soundManager)
        )
        print("MenuBarManager - Popover 配置完成")
        
        // 创建状态栏图标
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            print("MenuBarManager - 开始配置状态栏按钮")
            button.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "Keyboard")
            
            // 打印按钮的当前状态
            print("MenuBarManager - 按钮target: \(String(describing: button.target))")
            print("MenuBarManager - 按钮action: \(String(describing: button.action))")
            
            button.target = self
            button.action = #selector(togglePopover)
            
            // 再次打印配置后的状态
            print("MenuBarManager - 配置后按钮target: \(String(describing: button.target))")
            print("MenuBarManager - 配置后按钮action: \(String(describing: button.action))")
            
            print("MenuBarManager - 状态栏按钮配置完成")
        } else {
            print("MenuBarManager - 错误：状态栏按钮创建失败")
        }
        
        print("MenuBarManager - 初始化完成")
        
        // 添加设置变更观察者
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSettingsChanged),
            name: .settingsChanged,
            object: nil
        )
    }
    
    @objc private func togglePopover() {
        print("MenuBarManager - togglePopover 被调用")
        if let button = statusItem?.button {
            if popover.isShown {
                print("MenuBarManager - 正在关闭 Popover")
                popover.performClose(nil)
            } else {
                print("MenuBarManager - 正在显示 Popover")
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        } else {
            print("MenuBarManager - 错误：无法获取状态栏按钮")
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
    
    // 添加 deinit 来检查实例是否被释放
    deinit {
        print("MenuBarManager - 被释放")
    }
}
