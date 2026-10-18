//
//  ASCGImageBuffer.h
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

//  Copyright (c) Pinterest, Inc.  All rights reserved.
//  Licensed under Apache 2.0: http://www.apache.org/licenses/LICENSE-2.0

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGDataProvider.h>

#if __has_attribute(objc_subclassing_restricted)
#define AS_SUBCLASSING_RESTRICTED __attribute__((objc_subclassing_restricted))
#else
#define AS_SUBCLASSING_RESTRICTED
#endif

NS_ASSUME_NONNULL_BEGIN

AS_SUBCLASSING_RESTRICTED
@interface ASCGImageBuffer : NSObject

/// Init a zero-filled buffer with the given length.
- (nullable instancetype)initWithLength:(NSUInteger)length;

@property (readonly) void *mutableBytes NS_RETURNS_INNER_POINTER;

/// Don't do any drawing or call any methods after calling this.
- (CGDataProviderRef)createDataProviderAndInvalidate CF_RETURNS_RETAINED;

@end

NS_ASSUME_NONNULL_END
