//
//  NSString+XYBase64.h
//  XYCategory
//
//  Created by robbin on 2019/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XYBase64)

- (NSString *)xy_base64EncodedString;

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString;

@end

NS_ASSUME_NONNULL_END
