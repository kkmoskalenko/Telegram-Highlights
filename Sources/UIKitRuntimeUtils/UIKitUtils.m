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

static void setBoolField(NSObject *object, NSString *name, BOOL value) {
    SEL selector = NSSelectorFromString(name);
    NSMethodSignature *signature = [[object class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        return;
    }
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
    [inv setSelector:selector];
    [inv setArgument:&value atIndex:2];
    [inv setTarget:object];
    [inv invoke];
}

static void setLongLongField(NSObject *object, NSString *name, long long value) {
    SEL selector = NSSelectorFromString(name);
    NSMethodSignature *signature = [[object class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        return;
    }
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:signature];
    [inv setSelector:selector];
    [inv setArgument:&value atIndex:2];
    [inv setTarget:object];
    [inv invoke];
}

void setMonochromaticEffectImpl(UIView * _Nonnull view, bool isEnabled) {
    if (@available(iOS 26.0, *)) {
        static NSString *key1 = nil;
        static NSString *key2 = nil;
        static NSString *key3 = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            key1 = [[@"_" stringByAppendingString:@"setAllows"] stringByAppendingString:@"MonochromaticTreatment:"];
            key2 = [[@"_" stringByAppendingString:@"setEnable"] stringByAppendingString:@"MonochromaticTreatment:"];
            key3 = [[@"_" stringByAppendingString:@"set"] stringByAppendingString:@"MonochromaticTreatment:"];
        });
        
        if (isEnabled) {
            setBoolField(view, key1, true);
            setBoolField(view, key2, true);
            setLongLongField(view, key3, 2);
        } else {
            setBoolField(view, key1, false);
            setBoolField(view, key2, false);
            setLongLongField(view, key3, 0);
        }
    }
}
