//
//  UIView+XYLevel.h
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XYLevel)

@property (nullable, readonly) UIViewController * xy_viewController;
@property (readonly) NSUInteger xy_viewIndex;
@property (readonly) BOOL xy_isInFront;
@property (readonly) BOOL xy_isAtBack;

- (void)xy_bringToFront;
- (void)xy_sendToBack;
- (void)xy_bringOneLevelUp;
- (void)xy_sendOneLevelDown;

- (BOOL)xy_isInFrontOfView:(UIView *)view;
- (BOOL)xy_isAtBackOfView:(UIView *)view;
- (void)xy_swapDepthsWithView:(UIView*)swapView;
- (void)xy_bringSelfUpToView:(UIView *)bottomView;
- (void)xy_sendSelfDownToView:(UIView *)upView;

- (void)xy_removeAllSubviews;

@end

NS_ASSUME_NONNULL_END
