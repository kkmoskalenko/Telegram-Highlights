//
//  DeviceMetrics.swift
//  TelegramHighlights
//
//  This source file is derived from Telegram iOS:
//  https://github.com/TelegramMessenger/Telegram-iOS
//
//  Modified for this package on 17.10.2026.
//
//  Distributed under the terms of the GNU General Public License,
//  version 2 or any later version. See the LICENSE file for details.
//

import Darwin

public enum DeviceMetrics: CaseIterable, Equatable {
    public struct Performance {
        public let isGraphicallyCapable: Bool
        
        init() {
            var length: Int = 4
            var cpuCount: UInt32 = 0
            sysctlbyname("hw.ncpu", &cpuCount, &length, nil, 0)
            
            self.isGraphicallyCapable = cpuCount >= 4
        }
    }
    
    public static let performance = Performance()
}
