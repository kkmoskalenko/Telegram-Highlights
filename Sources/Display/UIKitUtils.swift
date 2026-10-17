//
//  UIKitUtils.swift
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

import UIKit
import UIKitRuntimeUtils

public extension UIView {
    static func animationDurationFactor() -> Double {
        return animationDurationFactorImpl()
    }
}

public extension CALayer {
    static func blur() -> NSObject? {
        return makeBlurFilter()
    }
    
    static func variableBlur() -> NSObject? {
        return makeVariableBlurFilter()
    }
    
    static func luminanceToAlpha() -> NSObject? {
        return makeLuminanceToAlphaFilter()
    }
    
    static func colorInvert() -> NSObject? {
        return makeColorInvertFilter()
    }
    
    static func monochrome() -> NSObject? {
        return makeMonochromeFilter()
    }
    
    static func displacementMap() -> NSObject? {
        return makeDisplacementMapFilter()
    }
    
    static func colorMatrix() -> NSObject? {
        return makeColorMatrixFilter()
    }
}
