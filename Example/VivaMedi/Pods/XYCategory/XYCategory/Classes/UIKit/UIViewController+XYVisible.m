//
//  UIViewController+XYVisible.m
//  XYCategory
//
//  Created by robbin on 2019/8/6.
//

#import "UIViewController+XYVisible.h"

@implementation UIViewController (XYVisible)

+ (UIViewController *)xy_topVisibleViewControllerOnKeyWindow {
    return [self getTopVisibleViewControllerFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (UIViewController *)xy_topVisibleViewControllerOnWindow:(UIWindow *)window {
    return [self getTopVisibleViewControllerFromViewController:window.rootViewController];
}

+ (UIViewController *)getTopVisibleViewControllerFromViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getTopVisibleViewControllerFromViewController:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getTopVisibleViewControllerFromViewController:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getTopVisibleViewControllerFromViewController:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}


@end
