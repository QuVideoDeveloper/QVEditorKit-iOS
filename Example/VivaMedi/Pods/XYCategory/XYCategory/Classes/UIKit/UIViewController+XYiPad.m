//
//  UIViewController+XYiPad.m
//  XYBase
//
//  Created by robbin on 2019/3/22.
//

#import "UIViewController+XYiPad.h"

@implementation UIViewController (XYiPad)

- (void)xy_presentViewControllerWithCompatibleiPad:(UIViewController *)viewControllerToPresent
                                          fromView:(UIView *)fromView
                                          animated:(BOOL)flag
                                        completion:(void (^)(void))completion {
    //if iPhone
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
    //if iPad
    else {
        UIPopoverPresentationController *popPresenter = [viewControllerToPresent popoverPresentationController];
        if (fromView) {
            popPresenter.sourceView = fromView;
            popPresenter.sourceRect = fromView.bounds;
        }else{
            popPresenter.sourceView = self.view;
            popPresenter.sourceRect = CGRectMake(self.view.frame.size.width/2-22, self.view.frame.size.height-80, 44, 44);
        }
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
        [self presentViewController:viewControllerToPresent animated:flag completion:completion];
    }
}
@end
