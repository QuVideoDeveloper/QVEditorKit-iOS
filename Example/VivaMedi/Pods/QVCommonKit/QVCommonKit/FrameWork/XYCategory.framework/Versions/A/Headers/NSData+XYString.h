//
//  NSData+XYString.h
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (XYString)

/**
 Returns string decoded in UTF8.
 */
- (nullable NSString *)xy_UTF8String;

@end

NS_ASSUME_NONNULL_END
