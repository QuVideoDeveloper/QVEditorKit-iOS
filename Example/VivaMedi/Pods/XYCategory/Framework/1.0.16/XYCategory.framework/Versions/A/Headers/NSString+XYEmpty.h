//
//  NSString+XYEmpty.h
//  XYCategory
//
//  Created by robbin on 2019/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XYEmpty)

@property (readonly) BOOL xy_isNotEmpty;

+ (BOOL)xy_isEmpty:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
