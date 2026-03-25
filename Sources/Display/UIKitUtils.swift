//
//  UIKitUtils.swift
//  TelegramHighlights
//
//  This source file is derived from Telegram iOS:
//  https://github.com/TelegramMessenger/Telegram-iOS
//
//  Modified for this package on 24.03.2026.
//
//  Distributed under the terms of the GNU General Public License,
//  version 2 or any later version. See the LICENSE file for details.
//

import UIKit

#if targetEnvironment(simulator)
@_silgen_name("UIAnimationDragCoefficient") func UIAnimationDragCoefficient() -> Float
#endif

public extension UIView {
    static func animationDurationFactor() -> Double {
        #if targetEnvironment(simulator)
        return Double(UIAnimationDragCoefficient())
        #else
        return 1.0
        #endif
    }
}
