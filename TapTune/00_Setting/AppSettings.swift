// 应用设置

import Foundation

struct AppSettings {
    var volume: Double
    var language: LanguageType
    var soundType: SoundType
    var customSoundName: String?
    
    static func saveSettings(volume: Double, language: LanguageType, soundType: SoundType, customSoundName: String? = nil) {
        let defaults = UserDefaults.standard
        defaults.set(volume, forKey: "Volume")
        defaults.set(language.rawValue, forKey: "Language")
        defaults.set(soundType.rawValue, forKey: "SoundType")
        defaults.set(customSoundName, forKey: "CustomSoundName")
    }
    
    static func loadSettings() -> AppSettings {
        let defaults = UserDefaults.standard
        return AppSettings(
            volume: defaults.double(forKey: "Volume"),
            language: LanguageType(rawValue: defaults.string(forKey: "Language") ?? "chinese") ?? .chinese,
            soundType: SoundType(rawValue: defaults.string(forKey: "SoundType") ?? "tofu") ?? .tofu,
            customSoundName: defaults.string(forKey: "CustomSoundName")
        )
    }
}
