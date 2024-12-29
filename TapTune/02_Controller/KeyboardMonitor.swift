//
//  KeyboardMonitor.swift
//  TapTune
//
//  Created by luna on 2024-12-29.
//

// 键盘监听器

import Foundation
import AppKit

class KeyboardMonitor: ObservableObject {
    private var eventMonitor: Any?
    var onKeyPress: (() -> Void)?
    
    func startMonitoring() {
        eventMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: .keyDown
        ) { [weak self] event in
            self?.onKeyPress?()
        }
    }
    
    func stopMonitoring() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
    
    deinit {
        stopMonitoring()
    }
}
