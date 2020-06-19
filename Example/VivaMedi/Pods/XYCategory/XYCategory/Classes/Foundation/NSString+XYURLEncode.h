//
//  NSString+XYURLEncode.h
//  XYCategory
//
//  Created by robbin on 2019/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XYURLEncode)

- (NSString *)xy_stringByURLEncode;

- (NSString *)xy_stringByURLDecode;

@end

NS_ASSUME_NONNULL_END
