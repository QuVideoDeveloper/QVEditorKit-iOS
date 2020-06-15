//
//  UIView+XYLevel.m
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import "UIView+XYLevel.h"

@implementation UIView (XYLevel)

- (UIViewController *)xy_viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - Getter
- (NSUInteger)xy_viewIndex {
    return [self.superview.subviews indexOfObject:self];
}

- (BOOL)xy_isInFront {
    return ([self.superview.subviews lastObject]==self);
}

- (BOOL)xy_isAtBack {
    return ([self.superview.subviews objectAtIndex:0]==self);
}

#pragma mark - Funs

- (void)xy_bringToFront {
    [self.superview bringSubviewToFront:self];
}

- (void)xy_sendToBack {
    [self.superview sendSubviewToBack:self];
}

- (void)xy_bringOneLevelUp {
    NSUInteger currentIndex = self.xy_viewIndex;
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex + 1];
}

- (void)xy_sendOneLevelDown {
    NSUInteger currentIndex = self.xy_viewIndex;
    [self.superview exchangeSubviewAtIndex:currentIndex withSubviewAtIndex:currentIndex - 1];
}

- (BOOL)xy_isInFrontOfView:(UIView *)view {
    return self.xy_viewIndex > view.xy_viewIndex;
}

- (BOOL)xy_isAtBackOfView:(UIView *)view {
    return self.xy_viewIndex < view.xy_viewIndex;
}

- (void)xy_swapDepthsWithView:(UIView*)swapView {
    [self.superview exchangeSubviewAtIndex:self.xy_viewIndex withSubviewAtIndex:swapView.xy_viewIndex];
}

- (void)xy_bringSelfUpToView:(UIView *)bottomView {
    while (self.xy_viewIndex < bottomView.xy_viewIndex) {
        [self xy_bringOneLevelUp];
    }
}

- (void)xy_sendSelfDownToView:(UIView *)upView {
    while (self.xy_viewIndex > upView.xy_viewIndex) {
        [self xy_sendOneLevelDown];
    }
}

- (void)xy_removeAllSubviews {
    while (self.subviews.count) {
        UIView * child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end
