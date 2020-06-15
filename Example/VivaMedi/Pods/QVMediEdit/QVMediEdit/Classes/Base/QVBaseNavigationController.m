//
//  QVBaseNavigationController.m
//  VivaMedi
//
//  Created by chaojie zheng on 2020/4/20.
//  Copyright © 2020 QuVideo. All rights reserved.
//

#import "QVBaseNavigationController.h"

@interface QVBaseNavigationController ()

@end

@implementation QVBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]}];
    [self setNavigationBarHidden:YES animated:NO];
    [self.navigationBar setTranslucent:NO];
}

UIViewController * recursiveFindCurrentShowViewControllerFromViewController(UIViewController *fromVC) {
    if ([fromVC isKindOfClass:[UINavigationController class]]) {
        return recursiveFindCurrentShowViewControllerFromViewController([((UINavigationController *)fromVC) visibleViewController]);
    } else if ([fromVC isKindOfClass:[UITabBarController class]]) {
        return recursiveFindCurrentShowViewControllerFromViewController([((UITabBarController *)fromVC) selectedViewController]);
    } else {
        if (fromVC.presentedViewController) {
            return recursiveFindCurrentShowViewControllerFromViewController(fromVC.presentedViewController);
        } else {
            return fromVC;
        }
    }
}

UIViewController * getCurrentViewController(void) {
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    return recursiveFindCurrentShowViewControllerFromViewController(rootVC);;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
