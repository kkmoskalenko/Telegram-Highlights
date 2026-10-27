//
//  UIViewController+Navigation.h
//  TelegramHighlights
//
//  This source file is derived from Telegram iOS:
//  https://github.com/TelegramMessenger/Telegram-iOS
//
//  Modified for this package on 28.10.2026.
//
//  Distributed under the terms of the GNU General Public License,
//  version 2 or any later version. See the LICENSE file for details.
//

#import <UIKit/UIKit.h>

@interface EffectSettingsContainerView : UIView

@property (nonatomic) double lumaMin;
@property (nonatomic) double lumaMax;
@property (nonatomic) double glassBlurRadius;

+ (void)applyGlassBlurRadius:(double)radius toLayerTree:(CALayer * _Nonnull)layer depth:(int)depth;

@property (class, nonatomic) double morphGlassBlurRadius;

@end
