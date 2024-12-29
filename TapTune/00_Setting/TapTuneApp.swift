//
//  TapTuneApp.swift
//  TapTune
//
//  Created by luna on 2024-12-27.
//
// 入口文件

import SwiftUI

class TapTuneApp: NSObject, NSApplicationDelegate {
    public let soundManager = SoundManager()
    public let menuBarManager: MenuBarManager
    
    // 初始化器
    required override init() {
        self.menuBarManager = MenuBarManager(soundManager: soundManager)
        super.init()
    }
    
    // 应用启动时调用
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 初始化操作
    }
}

// 创建一个新的入口点结构体
@main
struct TapTuneAppEntry {
    static func main() {
        let app = TapTuneApp()
        NSApplication.shared.delegate = app
        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }
}

// App 协议的实现
extension TapTuneApp: App {
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
