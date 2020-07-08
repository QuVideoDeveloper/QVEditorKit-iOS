//
//  UIViewController+XYVisible.h
//  XYCategory
//
//  Created by robbin on 2019/8/6.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (XYVisible)

+ (UIViewController *)xy_topVisibleViewControllerOnKeyWindow;
+ (UIViewController *)xy_topVisibleViewControllerOnWindow:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
