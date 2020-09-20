//
//  NSString+XYEmpty.h
//  XYCategory
//
//  Created by robbin on 2019/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (QVEmpty)

@property (readonly) BOOL qv_isNotEmpty;

+ (BOOL)qv_isEmpty:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
