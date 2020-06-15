//
//  NSString+QVTools.h
//  FMDB
//
//  Created by robbin on 2020/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (QVTools)

- (NSString *)qv_base64EncodedString;
- (NSString *)qv_MD5String;
+ (BOOL)qv_isEmpty:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
