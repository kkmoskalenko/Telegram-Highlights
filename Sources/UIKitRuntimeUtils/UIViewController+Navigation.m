//
//  UIViewController+Navigation.m
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

#import "UIViewController+Navigation.h"

@implementation EffectSettingsContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        _lumaMin = 0.0;
        _lumaMax = 0.0;
    }
    return self;
}

@end
