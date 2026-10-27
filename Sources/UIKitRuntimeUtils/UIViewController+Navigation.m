//
//  UIViewController+Navigation.m
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

#import "UIViewController+Navigation.h"

#import <objc/runtime.h>

static NSString *TGEncodeText(NSString *string, int key) {
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (int i = 0; i < (int)[string length]; i++) {
        unichar c = [string characterAtIndex:i];
        c += key;
        [result appendString:[NSString stringWithCharacters:&c length:1]];
    }
    
    return result;
}

static char glassBlurRadiusKey;
static NSString *glassBackgroundFilterName = nil;
static NSString *inputBlurRadiusKey = nil;
static NSString *morphContainerClassSuffix = nil;

static void (*original_backdropSetFilters)(CALayer *, SEL, NSArray *) = NULL;
static double morphGlassBlurRadius = 0.0;

static double glassBlurRadiusForView(UIView *view) {
    UIView *current = view;
    for (int i = 0; current != nil && i < 12; i++) {
        if ([current isKindOfClass:[EffectSettingsContainerView class]]) {
            return ((EffectSettingsContainerView *)current).glassBlurRadius;
        }
        if (morphGlassBlurRadius > 0.0 && [NSStringFromClass([current class]) hasSuffix:morphContainerClassSuffix]) {
            return morphGlassBlurRadius;
        }
        current = current.superview;
    }
    return 0.0;
}

static void replacement_backdropSetFilters(CALayer *self, SEL selector, NSArray *filters) {
    id delegate = self.delegate;
    if (filters.count != 0 && [delegate isKindOfClass:[UIView class]]) {
        double radius = glassBlurRadiusForView((UIView *)delegate);
        if (radius > 0.0) {
            for (id filter in filters) {
                if ([[filter valueForKey:@"name"] isEqual:glassBackgroundFilterName]) {
                    objc_setAssociatedObject(filter, &glassBlurRadiusKey, @(radius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    [filter setValue:@(radius) forKey:inputBlurRadiusKey];
                }
            }
        }
    }
    original_backdropSetFilters(self, selector, filters);
}

static void applyGlassBlurRadiusToBackdropLayer(double radius, CALayer *layer) {
    NSArray *filters = layer.filters;
    for (id filter in filters) {
        if (![[filter valueForKey:@"name"] isEqual:glassBackgroundFilterName]) {
            continue;
        }
        objc_setAssociatedObject(filter, &glassBlurRadiusKey, radius > 0.0 ? @(radius) : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (radius <= 0.0) {
            return;
        }
        NSNumber *current = [filter valueForKey:inputBlurRadiusKey];
        if (current == nil || current.doubleValue != radius) {
            layer.filters = @[];
            [filter setValue:@(radius) forKey:inputBlurRadiusKey];
            layer.filters = filters;
        }
        return;
    }
}

static void (*original_backdropViewDidMoveToWindow)(UIView *, SEL) = NULL;
static void replacement_backdropViewDidMoveToWindow(UIView *self, SEL selector) {
    original_backdropViewDidMoveToWindow(self, selector);
    if (self.window != nil) {
        double radius = glassBlurRadiusForView(self);
        if (radius > 0.0) {
            applyGlassBlurRadiusToBackdropLayer(radius, self.layer);
        }
    }
}

static void (*original_filterSetValueForKey)(NSObject *, SEL, id, NSString *) = NULL;
static void replacement_filterSetValueForKey(NSObject *self, SEL selector, id value, NSString *key) {
    if ([key isEqualToString:inputBlurRadiusKey]) {
        NSNumber *radius = objc_getAssociatedObject(self, &glassBlurRadiusKey);
        if (radius != nil) {
            value = radius;
        }
    }
    original_filterSetValueForKey(self, selector, value, key);
}

static void registerEffectViewOverrides(void) {
    glassBackgroundFilterName = TGEncodeText(@"hmbttCbdlhspvoe", -1);
    inputBlurRadiusKey = TGEncodeText(@"joqvuCmvsSbejvt", -1);
    morphContainerClassSuffix = TGEncodeText(@"NpsqiBojnbujpoDpoubjofsWjfx", -1);
    Class filterClass = NSClassFromString(TGEncodeText(@"DBGjmufs", -1));
    if (filterClass != nil) {
        Method m = class_getInstanceMethod(filterClass, @selector(setValue:forKey:));
        if (m) {
            original_filterSetValueForKey = (void (*)(NSObject *, SEL, id, NSString *))method_getImplementation(m);
            class_replaceMethod(filterClass, @selector(setValue:forKey:), (IMP)&replacement_filterSetValueForKey, method_getTypeEncoding(m));
        }
    }
    Class backdropClass = NSClassFromString(TGEncodeText(@"DBCbdlespqMbzfs", -1));
    if (backdropClass != nil) {
        Method filtersMethod = class_getInstanceMethod(backdropClass, @selector(setFilters:));
        if (filtersMethod) {
            original_backdropSetFilters = (void (*)(CALayer *, SEL, NSArray *))method_getImplementation(filtersMethod);
            class_replaceMethod(backdropClass, @selector(setFilters:), (IMP)&replacement_backdropSetFilters, method_getTypeEncoding(filtersMethod));
        }
    }

    NSMutableArray<NSString *> *nameList = [[NSMutableArray alloc] init];
    [nameList addObject:TGEncodeText(@"_TtC5UIKitP33_ACD4A08F4BE9D00246F2A9C24A80CA8817UISDFBackdropView", 0)];
    Class backdropViewClass = NSClassFromString(nameList.firstObject);
    if (backdropViewClass != nil) {
        Method moveMethod = class_getInstanceMethod(backdropViewClass, @selector(didMoveToWindow));
        if (moveMethod) {
            original_backdropViewDidMoveToWindow = (void (*)(UIView *, SEL))method_getImplementation(moveMethod);
            class_replaceMethod(backdropViewClass, @selector(didMoveToWindow), (IMP)&replacement_backdropViewDidMoveToWindow, method_getTypeEncoding(moveMethod));
        }
    }
}

@implementation EffectSettingsContainerView

+ (void)load
{
    if (@available(iOS 26.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            registerEffectViewOverrides();
        });
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        _lumaMin = 0.0;
        _lumaMax = 0.0;
    }
    return self;
}

+ (double)morphGlassBlurRadius {
    return morphGlassBlurRadius;
}

+ (void)setMorphGlassBlurRadius:(double)radius {
    morphGlassBlurRadius = radius;
}

+ (void)applyGlassBlurRadius:(double)radius toLayerTree:(CALayer *)layer depth:(int)depth {
    if (depth > 12) {
        return;
    }
    applyGlassBlurRadiusToBackdropLayer(radius, layer);
    for (CALayer *sublayer in layer.sublayers) {
        [self applyGlassBlurRadius:radius toLayerTree:sublayer depth:depth + 1];
    }
}


@end
