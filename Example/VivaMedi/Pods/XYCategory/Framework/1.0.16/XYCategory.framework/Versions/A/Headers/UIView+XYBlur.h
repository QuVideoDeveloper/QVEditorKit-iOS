//
//  UIView+XYBlur.h
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XYBlur)

+ (UIVisualEffectView *)xy_blurViewWithStyle:(UIBlurEffectStyle)style
                             backgroundColor:(UIColor *)backgroundColor
                                       alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
