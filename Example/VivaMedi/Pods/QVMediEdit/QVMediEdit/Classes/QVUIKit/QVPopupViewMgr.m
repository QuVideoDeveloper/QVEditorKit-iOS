//
//  QVPopupViewMgr.m
//  QVEditor_Example
//
//  Created by chaojie zheng on 2020/4/10.
//  Copyright © 2020 Sunshine. All rights reserved.
//

#import "QVPopupViewMgr.h"

@interface QVPopupViewMgr ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, assign) BOOL enableTouchToHide;

@property (nonatomic, assign) CGRect customViewRect;

@property (nonatomic, strong) UIWindow *overlayWindow;

@end

@implementation QVPopupViewMgr

+ (QVPopupViewMgr *)sharedInstance {
    static QVPopupViewMgr *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[QVPopupViewMgr alloc] init];
    });
    return sharedInstance;
}


- (void)dismiss {
    if(self.backgroundView) {
        NSArray *subViewArray = [self.backgroundView subviews];
        NSMutableArray *subViewMutaArray = [NSMutableArray arrayWithArray:subViewArray];
        if ( subViewArray.count > 0 ) {
            [subViewMutaArray removeObjectAtIndex:subViewArray.count - 1];
            [[subViewArray lastObject]removeFromSuperview];
            subViewArray = [self.backgroundView subviews];
            __block UIVisualEffectView *blurView;
            [subViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[UIVisualEffectView class]]) {
                    blurView = obj;
                }
            }];
            
            [blurView removeFromSuperview];
            subViewArray = [self.backgroundView subviews];
            
            if ( subViewArray.count == 0 ) {
                [self.backgroundView removeFromSuperview];
                self.backgroundView = nil;
            }
        }else {
            [self.backgroundView removeFromSuperview];
            self.backgroundView = nil;
        }
    }
    
    [_overlayWindow removeFromSuperview];
    _overlayWindow = nil;
    
}


- (UIVisualEffectView *)qvAddBlurViewWithBlurEffectStyle:(UIBlurEffectStyle)blurEffectStyle
                                         blurViewBgColor:(UIColor *)blurViewBgColor
                                           blurViewAlpha:(CGFloat)blurViewAlpha
                                                    view:(UIView *)view {
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:blurEffectStyle];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = view.bounds;
    visualEffectView.backgroundColor = blurViewBgColor;
    visualEffectView.alpha = blurViewAlpha;
    [view addSubview:visualEffectView];
    [view sendSubviewToBack:visualEffectView];
    return visualEffectView;
}

+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}


- (void)bgSingleTap:(UITapGestureRecognizer *)recognizer {
    if(self.enableTouchToHide) {
        CGPoint point = [recognizer locationInView:self.backgroundView];
        if ([self qv_getIsTouchInBackGroundViewWithPoint:point] == NO) {
            return;
        }
        [self dismiss];
    }
}


- (void)show:(UIView *)customView enableTouchToHide:(BOOL)touchToHide background:(float)alpha pointInBottom:(BOOL)pointInBottom {
    self.enableTouchToHide = touchToHide;
    if (self.backgroundView != nil){
        return;
    }
    if(!self.backgroundView){
        self.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        if(touchToHide){
            UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(bgSingleTap:)];
            [self.backgroundView addGestureRecognizer:singleTap];
        }
    }
    if (!pointInBottom) {
        customView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
    }
    _customViewRect = customView.frame;
    [self.backgroundView addSubview:customView];
    [[UIApplication sharedApplication] keyWindow].backgroundColor = [UIColor clearColor];
    if (!_isPopOnVCThisTime) {
        if (_isPopWithNewWindowThisTime) {
            _isPopWithNewWindowThisTime = NO;
            [self.overlayWindow.rootViewController.view addSubview:self.backgroundView];
        }else{
            [[[UIApplication sharedApplication] keyWindow] addSubview:self.backgroundView];
        }
    }else{
        UIViewController *topVC = [self getVisibleViewControllerFrom:[UIApplication sharedApplication].keyWindow.rootViewController];
        [topVC.view addSubview:self.backgroundView];
        _isPopOnVCThisTime = NO;
    }
    [customView setAlpha:0.0];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self.backgroundView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:alpha]];
        [customView setAlpha:1.0];
    } completion:^(BOOL finished) {
        //code
    }];
}

- (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

- (BOOL)qv_getIsTouchInBackGroundViewWithPoint:(CGPoint)point {
    //水平
    BOOL planeInBackgroundView = point.x < _customViewRect.origin.x || point.x > _customViewRect.origin.x + _customViewRect.size.width;
    //竖直
    BOOL verticalInBackgroundView = point.y < _customViewRect.origin.y || point.y > _customViewRect.origin.y + _customViewRect.size.height;
    return planeInBackgroundView || verticalInBackgroundView;
}


- (UIWindow *)overlayWindow; {
    if(_overlayWindow == nil) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.windowLevel = UIWindowLevelAlert+1;
        _overlayWindow.rootViewController = [[UIViewController alloc] init];
        _overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
        [_overlayWindow setHidden:NO];
    }
    return _overlayWindow;
}

@end
