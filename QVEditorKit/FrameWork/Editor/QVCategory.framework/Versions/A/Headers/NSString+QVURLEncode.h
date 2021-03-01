//
//  NSString+XYURLEncode.h
//  XYCategory
//
//  Created by robbin on 2019/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (QVURLEncode)

- (NSString *)qv_stringByURLEncode;

- (NSString *)qv_stringByURLDecode;

@end

NS_ASSUME_NONNULL_END
