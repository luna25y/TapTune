//
//  VolumeSliderView.swift
//  TapTune
//
//  Created by luna on 2024-12-29.
//

import SwiftUI

struct VolumeSliderView: View {
    @Binding var volume: Double
    var onVolumeChanged: () -> Void
    @StateObject private var languageManager = LanguageManager.shared
    
    var body: some View {
        HStack(spacing: 15) {
            // 音量标签
            Text(languageManager.localizedString(.volume))
                .font(.body)
            
            Slider(value: $volume, in: 0...1) { isDragging in
                if !isDragging {
                    onVolumeChanged()
                }
            }
            .frame(width: 135)
            
            Spacer()
        }
    }
}
