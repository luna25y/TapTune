// 语言类型

import Foundation

enum LanguageType: String, CaseIterable, Identifiable {
    case chinese = "zh"
    case english = "en"
    case japanese = "ja"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .chinese: return "中文"
        case .english: return "English"
        case .japanese: return "日本語"
        }
    }
}
