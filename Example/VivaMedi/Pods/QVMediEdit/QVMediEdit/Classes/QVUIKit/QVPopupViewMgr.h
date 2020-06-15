//
//  QVPopupViewMgr.h
//  QVEditor_Example
//
//  Created by chaojie zheng on 2020/4/10.
//  Copyright © 2020 Sunshine. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QVPopupViewMgr : UIView

@property (nonatomic) BOOL isPopOnVCThisTime;
@property (nonatomic) BOOL isPopWithNewWindowThisTime;

+ (QVPopupViewMgr *)sharedInstance;

- (void)dismiss;
- (void)show:(UIView *)customView enableTouchToHide:(BOOL)touchToHide background:(float)alpha pointInBottom:(BOOL)pointInBottom;

@end

NS_ASSUME_NONNULL_END
