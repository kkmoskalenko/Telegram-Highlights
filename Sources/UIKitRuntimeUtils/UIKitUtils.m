//
//  UIKitUtils.m
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

#import "UIKitUtils.h"

#if TARGET_IPHONE_SIMULATOR
UIKIT_EXTERN float UIAnimationDragCoefficient();
#endif

double animationDurationFactorImpl() {
#if TARGET_IPHONE_SIMULATOR
    return (double)UIAnimationDragCoefficient();
#endif
    return 1.0f;
}

@protocol GraphicsFilterProtocol <NSObject>
    
- (NSObject * _Nullable)filterWithName:(NSString * _Nonnull)name;

@end

NSObject * _Nullable makeBlurFilter() {
    return [(id<GraphicsFilterProtocol>)NSClassFromString(@"CAFilter") filterWithName:@"gaussianBlur"];
}

NSObject * _Nullable makeVariableBlurFilter() {
    return [(id<GraphicsFilterProtocol>)NSClassFromString(@"CAFilter") filterWithName:@"variableBlur"];
}

NSObject * _Nullable makeLuminanceToAlphaFilter() {
    return [(id<GraphicsFilterProtocol>)NSClassFromString(@"CAFilter") filterWithName:@"luminanceToAlpha"];
}

NSObject * _Nullable makeColorInvertFilter() {
    return [(id<GraphicsFilterProtocol>)NSClassFromString(@"CAFilter") filterWithName:@"colorInvert"];
}

NSObject * _Nullable makeMonochromeFilter() {
    return [(id<GraphicsFilterProtocol>)NSClassFromString(@"CAFilter") filterWithName:@"colorMonochrome"];
}

NSObject * _Nullable makeDisplacementMapFilter() {
    if (@available(iOS 26.0, *)) {
        return [(id<GraphicsFilterProtocol>)NSClassFromString(@"CAFilter") filterWithName:@"displacementMap"];
    } else {
        return nil;
    }
}

NSObject * _Nullable makeColorMatrixFilter() {
    return [(id<GraphicsFilterProtocol>)NSClassFromString(@"CAFilter") filterWithName:@"colorMatrix"];
}
