//
//  UIColor+XYInit.h
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (QVMediInit)

+ (UIColor *)qvmedi_colorWithHEX:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor *)qvmedi_colorWithHEX:(NSInteger)hexValue;


@end

NS_ASSUME_NONNULL_END
