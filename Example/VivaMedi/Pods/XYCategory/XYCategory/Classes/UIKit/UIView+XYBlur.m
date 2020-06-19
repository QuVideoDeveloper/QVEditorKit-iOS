//
//  UIView+XYBlur.m
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import "UIView+XYBlur.h"

@implementation UIView (XYBlur)

+ (UIVisualEffectView *)xy_blurViewWithStyle:(UIBlurEffectStyle)style
                             backgroundColor:(UIColor *)backgroundColor
                                       alpha:(CGFloat)alpha {
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.backgroundColor = backgroundColor;
    visualEffectView.alpha = alpha;
    return visualEffectView;
}

@end
