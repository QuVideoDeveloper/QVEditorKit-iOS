//
//  NSString+XYValidate.h
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XYValidate)

- (BOOL)xy_isEmailFormat;

- (BOOL)xy_isMobileFormat;

- (BOOL)xy_isQQFormat;

@end

NS_ASSUME_NONNULL_END
