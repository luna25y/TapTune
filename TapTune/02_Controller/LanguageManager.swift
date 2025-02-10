// 语言管理器

import Foundation

class LanguageManager: ObservableObject {
    @Published var currentLanguage: LanguageType {
        didSet {
            // 当语言改变时自动保存
            AppSettings.saveSettings(
                volume: SoundManager().volume,
                language: currentLanguage,
                soundType: SoundManager().currentSoundType
            )
        }
    }
    
    static let shared = LanguageManager()
    
    private init() {
        // 从保存的设置中加载语言
        let settings = AppSettings.loadSettings()
        self.currentLanguage = settings.language
    }
    
    func setLanguage(_ language: LanguageType) {
        currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "AppLanguage")
    }
    
    func localizedString(_ key: LocalizationKey) -> String {
        switch currentLanguage {
        case .chinese:
            return key.chinese
        case .english:
            return key.english
        case .japanese:
            return key.japanese
        }
    }
}

// 本地化键值
enum LocalizationKey {
    case keyboardType
    case volume
    case testSound
    case uploadCustomSound
    case tofu
    case clicky
    case custom
    case language
    case quit
    case customSoundName
    case nameCustomSound
    case enterSoundName
    case error
    case ok
    case cancel
    case soundTooLong
    case cantReadSound
    case add
    
    var chinese: String {
        switch self {
        case .keyboardType: return "键盘类型"
        case .volume: return "音量"
        case .testSound: return "测试声音"
        case .uploadCustomSound: return "上传自定义声音"
        case .tofu: return "豆腐"
        case .clicky: return "青轴"
        case .custom: return "自定义"
        case .language: return "语言"
        case .quit: return "退出"
        case .customSoundName: return "自定义声音"
        case .nameCustomSound: return "为自定义声音命名"
        case .enterSoundName: return "请输入声音名称："
        case .error: return "错误"
        case .ok: return "确定"
        case .cancel: return "取消"
        case .soundTooLong: return "声音文件长度必须在2秒以内"
        case .cantReadSound: return "无法读取声音文件"
        case .add: return "添加"
        }
    }
    
    var english: String {
        switch self {
        case .keyboardType: return "Keyboard Type"
        case .volume: return "Vol"
        case .testSound: return "Test Sound"
        case .uploadCustomSound: return "Upload Custom Sound"
        case .tofu: return "Tofu"
        case .clicky: return "Clicky"
        case .custom: return "Custom"
        case .language: return "Language"
        case .quit: return "Quit"
        case .customSoundName: return "Custom Sound"
        case .nameCustomSound: return "Name Custom Sound"
        case .enterSoundName: return "Please enter sound name:"
        case .error: return "Error"
        case .ok: return "OK"
        case .cancel: return "Cancel"
        case .soundTooLong: return "Sound file must be under 2 seconds"
        case .cantReadSound: return "Cannot read sound file"
        case .add: return "Add"
        }
    }
    
    var japanese: String {
        switch self {
        case .keyboardType: return "キーボードタイプ"
        case .volume: return "音量"
        case .testSound: return "テスト音"
        case .uploadCustomSound: return "カスタム音をアップロード"
        case .tofu: return "豆腐"
        case .clicky: return "青軸"
        case .custom: return "カスタム"
        case .language: return "言語"
        case .quit: return "終了"
        case .customSoundName: return "カスタムサウンド"
        case .nameCustomSound: return "カスタムサウンドの名前"
        case .enterSoundName: return "サウンド名を入力してください："
        case .error: return "エラー"
        case .ok: return "確認"
        case .cancel: return "キャンセル"
        case .soundTooLong: return "サウンドファイルは2秒以内である必要があります"
        case .cantReadSound: return "サウンドファイルを読み込めません"
        case .add: return "追加"
        }
    }
}

enum LocalizedKey: String {
    case language = "language"
    case keyboardType = "keyboardType"
    case volume = "volume"
    case testSound = "testSound"
    case quit = "quit"
    case clicky = "clicky"      // 青轴
    case tofu = "tofu"        // 豆腐
    case custom = "custom"        // 自定义
}

// 在本地化字典中更新对应的值
private let localizedStrings: [LanguageType: [LocalizedKey: String]] = [
    .chinese: [
        .language: "语言",
        .keyboardType: "键盘类型",
        .volume: "音量",
        .testSound: "测试声音",
        .quit: "退出",
        .clicky: "青轴",
        .tofu: "豆腐",
        .custom: "自定义"
    ],
    .english: [
        .language: "Language",
        .keyboardType: "Keyboard Type",
        .volume: "Volume",
        .testSound: "Test Sound",
        .quit: "Quit",
        .clicky: "Clicky",
        .tofu: "Tofu",
        .custom: "Custom"
    ]
]
