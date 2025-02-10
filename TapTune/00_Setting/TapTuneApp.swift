// 入口文件

import SwiftUI

class TapTuneApp: NSObject, NSApplicationDelegate {
    public let soundManager = SoundManager()
    public let menuBarManager: MenuBarManager
    private var mainWindow: NSWindow?
    
    // 初始化器
    required override init() {
        print("TapTuneApp - 开始初始化")
        self.menuBarManager = MenuBarManager(soundManager: soundManager)
        super.init()
        print("TapTuneApp - 初始化完成")
    }
    
    // 应用启动时调用
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("TapTuneApp - applicationDidFinishLaunching 被调用")
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
