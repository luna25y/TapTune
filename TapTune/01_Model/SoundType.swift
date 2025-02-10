// 声音类型

import Foundation

enum SoundType: String, CaseIterable, Identifiable {
    case clicky = "clicky"    // 青轴
    case tofu = "tofu"      // 豆腐
    case custom = "custom"      // 自定义
    
    var id: String { rawValue }
}
