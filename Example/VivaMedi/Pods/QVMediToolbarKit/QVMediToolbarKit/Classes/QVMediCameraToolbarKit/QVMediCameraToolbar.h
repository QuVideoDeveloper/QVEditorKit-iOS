//
//  XYCameraToolbar.h
//  Pods-XYToolbarKit_Example
//
//  Created by chaojie zheng on 2020/4/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, QVMediCameraScaleType) {
    QVMediCameraScaleTypeDefault = 0,
    QVMediCameraScaleType_1_1 = 1,
    QVMediCameraScaleType_3_4 = 2
};

typedef NS_ENUM(NSUInteger, QVMediCameraToolbarType) {
    QVMediCameraToolbarTypeSwitch,
    QVMediCameraToolbarTypeFillLight,
    QVMediCameraToolbarTypeFocus,
    QVMediCameraToolbarTypeExposure,
    QVMediCameraToolbarTypeRatio,
    QVMediCameraToolbarTypeFilter,
    QVMediCameraToolbarTypeBeauty
};

/// Camera Recording interface toolbar
@interface QVMediCameraToolbar : UIView

/// click callback
@property (nonatomic, copy) void(^toolbarFillLightClickBlock)(BOOL selected);

/// click callback
@property (nonatomic, copy) void(^toolbarFilterClickBlock)(id targetResource);

/// click callback
@property (nonatomic, copy) void(^toolbarRatioClickBlock)(QVMediCameraToolbarType toolbarType, QVMediCameraScaleType scaleType);

/// click callback
@property (nonatomic, copy) void(^toolbarClickBlock)(QVMediCameraToolbarType toolbarType);

/// RangSlider changeValue block
@property (nonatomic, copy) void(^rangSliderSelectValueFinish)(float value, QVMediCameraToolbarType toolbarType);

/// Init
- (void)initCameraToolbar;

@end

NS_ASSUME_NONNULL_END
