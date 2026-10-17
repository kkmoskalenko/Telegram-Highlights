//
//  UIKitUtils.h
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

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

double animationDurationFactorImpl();

NSObject * _Nullable makeBlurFilter();
NSObject * _Nullable makeVariableBlurFilter();
NSObject * _Nullable makeLuminanceToAlphaFilter();
NSObject * _Nullable makeColorInvertFilter();
NSObject * _Nullable makeMonochromeFilter();
NSObject * _Nullable makeDisplacementMapFilter();
NSObject * _Nullable makeColorMatrixFilter();
