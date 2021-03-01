//
//  NSString+XYValidate.h
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (QVValidate)

- (BOOL)qv_isEmailFormat;

- (BOOL)qv_isMobileFormat;

- (BOOL)qv_isQQFormat;

@end

NS_ASSUME_NONNULL_END
