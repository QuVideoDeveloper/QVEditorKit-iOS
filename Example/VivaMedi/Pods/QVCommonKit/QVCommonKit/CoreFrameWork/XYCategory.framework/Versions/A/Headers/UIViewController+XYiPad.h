//
//  UIViewController+XYiPad.h
//  XYBase
//
//  Created by robbin on 2019/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XYiPad)

/**
 兼容iPad的presentViewController,fromView参数是指iPad气泡框从哪里弹出来，一般是点击的那个控件

 @param viewControllerToPresent viewControllerToPresent
 @param fromView fromView
 @param flag flag
 @param completion completion
 */
- (void)xy_presentViewControllerWithCompatibleiPad:(UIViewController *)viewControllerToPresent
                                          fromView:(UIView *)fromView
                                          animated:(BOOL)flag
                                        completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
