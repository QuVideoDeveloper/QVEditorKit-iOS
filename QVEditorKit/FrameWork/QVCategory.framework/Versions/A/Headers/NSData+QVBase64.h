//
//  NSData+XYBase64.h
//  XYCategory
//
//  Created by robbin on 2019/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (QVBase64)

- (NSString *)qv_base64EncodedString;
+ (NSData *)qv_dataWithBase64EncodedString:(NSString *)base64EncodedString;

@end

NS_ASSUME_NONNULL_END
