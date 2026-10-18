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

public extension UIColor {
    convenience init(rgb: UInt32) {
        self.init(red: CGFloat((rgb >> 16) & 0xff) / 255.0, green: CGFloat((rgb >> 8) & 0xff) / 255.0, blue: CGFloat(rgb & 0xff) / 255.0, alpha: 1.0)
    }

    func mixedWith(_ other: UIColor, alpha: CGFloat) -> UIColor {
        let alpha = min(1.0, max(0.0, alpha))
        let oneMinusAlpha = 1.0 - alpha
        
        var r1: CGFloat = 0.0
        var r2: CGFloat = 0.0
        var g1: CGFloat = 0.0
        var g2: CGFloat = 0.0
        var b1: CGFloat = 0.0
        var b2: CGFloat = 0.0
        var a1: CGFloat = 0.0
        var a2: CGFloat = 0.0
        if self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) &&
            other.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        {
            let r = r1 * oneMinusAlpha + r2 * alpha
            let g = g1 * oneMinusAlpha + g2 * alpha
            let b = b1 * oneMinusAlpha + b2 * alpha
            let a = a1 * oneMinusAlpha + a2 * alpha
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
        return self
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

public extension UIView {
    func setMonochromaticEffect(tintColor: UIColor?) {
        var overrideUserInterfaceStyle: UIUserInterfaceStyle = .unspecified
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        if let tintColor {
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                if red == 0.0 && green == 0.0 && blue == 0.0 && alpha == 1.0 {
                    overrideUserInterfaceStyle = .light
                }
            } else {
                if red == 1.0 && green == 1.0 && blue == 1.0 && alpha == 1.0 {
                    overrideUserInterfaceStyle = .dark
                }
            }
        }
        
        if self.overrideUserInterfaceStyle != overrideUserInterfaceStyle {
            self.overrideUserInterfaceStyle = overrideUserInterfaceStyle
            setMonochromaticEffectImpl(self, overrideUserInterfaceStyle != .unspecified)
        }
    }
}
