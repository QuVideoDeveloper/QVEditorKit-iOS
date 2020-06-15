//
//  XYCameraToolbar.m
//  Pods-XYToolbarKit_Example
//
//  Created by chaojie zheng on 2020/4/14.
//

#import "QVMediCameraToolbar.h"
#import <XYCategory/XYCategory.h>
#import "QVMediScrollToolbarSelectView.h"
#import <Masonry/Masonry.h>
#import "QVMediButton.h"
#import "QVMediSlider.h"
#import <QVMediTools/UIImage+QVMedi.h>
#import <QVMediTools/UIColor+QVMediInit.h>

#define defaultWidth 30
#define defaultHeight 44

@interface QVMediCameraToolbar () <QVMediSliderDelegate>

@property (nonatomic, strong) NSArray *defaultToolbarDataSourceArray;

@property (nonatomic, assign) float focusValue;

@property (nonatomic, assign) float exposureValue;

@property (nonatomic, assign) float beautyValue;

@property (nonatomic, strong) QVMediSlider *beautyRangeSlider;

@property (nonatomic, strong) QVMediSlider *focusRangeSlider;

@property (nonatomic, strong) QVMediSlider *exposureRangeSlider;

@property (nonatomic, assign) QVMediCameraScaleType curScaleType;

@property (nonatomic, strong) QVMediScrollToolbarSelectView *filterScrollToolbar;

@property (nonatomic, strong) UILabel *toolbarActionTitleLabel;

@property (nonatomic, strong) NSNumberFormatter *numberFormatterOverride;


@end

@implementation QVMediCameraToolbar


#pragma mark- creat
- (void)initCameraToolbar {
    self.focusValue = 50;
    self.exposureValue = 0;
    self.curScaleType = QVMediCameraScaleTypeDefault;
    CGFloat defaultWidth_max = defaultWidth;
    CGFloat defaultHeight_max = self.defaultToolbarDataSourceArray.count * (defaultHeight + 15) - 15 + 20;

    UIScrollView *toolbarBackScrollView = [UIScrollView new];
    toolbarBackScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:toolbarBackScrollView];
    
    [toolbarBackScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.offset(defaultHeight_max);
    }];
    
    for (NSDictionary *objDic in self.defaultToolbarDataSourceArray) {
        QVMediButton *toolbarItem = [QVMediButton new];
        toolbarItem.qvmedi_ButtonType = QVMediButtonStyleUpImageBelowTitle;
        toolbarItem.xy_parameter = objDic;
        [toolbarItem setImage:[UIImage qvmedi_imageWithName:[NSString stringWithFormat:@"qv_QVUIKit_%@_normal",objDic[@"icon&title"]] bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
        [toolbarItem setTitle:NSLocalizedString(objDic[@"icon&title"], @"") forState:UIControlStateNormal];
        if (objDic[@"title"]) {
            [toolbarItem setTitle:NSLocalizedString(objDic[@"title"], @"") forState:UIControlStateNormal];
        }
        [toolbarItem setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        toolbarItem.titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        [toolbarItem addTarget:self action:@selector(toolbarClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarBackScrollView addSubview:toolbarItem];
        [toolbarItem.titleLabel sizeToFit];
        defaultWidth_max = CGRectGetWidth(toolbarItem.titleLabel.frame) > defaultWidth_max ? CGRectGetWidth(toolbarItem.titleLabel.frame) : defaultWidth_max;
    }
    
    [toolbarBackScrollView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:15 leadSpacing:10 tailSpacing:10];
    [toolbarBackScrollView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(defaultWidth_max);
        make.height.offset(defaultHeight);
        make.left.right.offset(0);
        make.centerX.equalTo(toolbarBackScrollView);
    }];
}

#pragma mark- action
- (void)toolbarClickAction:(QVMediButton *)target {
    [self superViewTapAction];
    QVMediCameraToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    NSString *actionName = target.xy_parameter[@"action"];
    if (actionName && actionName.length) {
        SEL sel = NSSelectorFromString(actionName);
        if ([self canPerformAction:sel withSender:nil]) {
            IMP imp = [self methodForSelector:sel];
            ((id(*)(id, SEL, QVMediButton *))imp)(self, sel, target);
        }
    }
    if (self.toolbarClickBlock) {
        self.toolbarClickBlock(toolbarType);
    }
    
}

- (void)xy_cameraToolbarTypeFillLightAction:(QVMediButton *)target {
    target.selected = !target.selected;
    [target setImage:[UIImage qvmedi_imageWithName:[NSString stringWithFormat:@"qv_QVUIKit_%@_%@",target.xy_parameter[@"icon&title"],target.selected?@"hight":@"normal"] bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
    if (self.toolbarFillLightClickBlock) {
        self.toolbarFillLightClickBlock(target.selected);
    }
}

- (void)xy_cameraToolbarTypeFocusAction:(QVMediButton *)target {
    self.focusRangeSlider.selectedValue = [self.focusRangeSlider.xy_parameter floatValue];
    self.numberFormatterOverride.maximumFractionDigits = 0;
    self.focusRangeSlider.numberFormatterOverride = self.numberFormatterOverride;
    self.toolbarActionTitleLabel.text = NSLocalizedString(@"mn_cam_func_zoom",@"");
    [self.toolbarActionTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.focusRangeSlider.mas_top).offset(-10);
    }];
    [UIView animateWithDuration:.5f animations:^{
        self.hidden = YES;
        self.focusRangeSlider.hidden = NO;
        self.toolbarActionTitleLabel.hidden = NO;
     }];
}

- (void)xy_cameraToolbarTypeExposureAction:(QVMediButton *)target {
    self.exposureRangeSlider.selectedValue = [self.exposureRangeSlider.xy_parameter floatValue];
    self.numberFormatterOverride.maximumFractionDigits = 1;
    self.exposureRangeSlider.numberFormatterOverride = self.numberFormatterOverride;
    self.toolbarActionTitleLabel.text = NSLocalizedString(@"mn_cam_func_exposure",@"");
    [self.toolbarActionTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.exposureRangeSlider.mas_top).offset(-10);
    }];
    [UIView animateWithDuration:.5f animations:^{
        self.hidden = YES;
        self.exposureRangeSlider.hidden = NO;
        self.toolbarActionTitleLabel.hidden = NO;
     }];
}

- (void)xy_cameraToolbarTypeRatioAction:(QVMediButton *)target {
    QVMediCameraToolbarType toolbarType = [[NSString stringWithFormat:@"%@",target.xy_parameter[@"type"]] integerValue];
    if (self.curScaleType == QVMediCameraScaleType_3_4) {
        self.curScaleType = QVMediCameraScaleTypeDefault;
    }else {
        self.curScaleType++;
    }
    NSArray *scaleTypesAry = target.xy_parameter[@"scaleTypes"];
    [target setImage:[UIImage qvmedi_imageWithName:scaleTypesAry[self.curScaleType][@"icon"] bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
    if (self.toolbarRatioClickBlock) {
        self.toolbarRatioClickBlock(toolbarType, self.curScaleType);
    }
}

- (void)xy_cameraToolbarTypeFilterAction:(QVMediButton *)target {
    [UIView animateWithDuration:.5f animations:^{
        self.hidden = YES;
        self.filterScrollToolbar.hidden = NO;
     }];
}

- (void)xy_cameraToolbarTypeBeautyAction:(QVMediButton *)target {
    self.beautyRangeSlider.selectedValue = [self.beautyRangeSlider.xy_parameter floatValue];
    self.numberFormatterOverride.maximumFractionDigits = 0;
    self.beautyRangeSlider.numberFormatterOverride = self.numberFormatterOverride;
    self.toolbarActionTitleLabel.text = NSLocalizedString(@"mn_cam_func_face_beauty",@"");
    [self.toolbarActionTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.beautyRangeSlider.mas_top).offset(-10);
    }];
    [UIView animateWithDuration:.5f animations:^{
        self.hidden = YES;
        self.beautyRangeSlider.hidden = NO;
        self.toolbarActionTitleLabel.hidden = NO;
     }];
}



#pragma mark- tap
- (void)superViewTapAction {
    [UIView animateWithDuration:.3f animations:^{
        self.focusRangeSlider.hidden = YES;
        self.beautyRangeSlider.hidden = YES;
        self.filterScrollToolbar.hidden = YES;
        self.exposureRangeSlider.hidden = YES;
        self.toolbarActionTitleLabel.hidden = YES;
        self.hidden = NO;
    }];
}

#pragma mark- XYRangeSliderDelegate

- (void)rangeSlider:(QVMediSlider *)sender didChangeSelectedValue:(float)selectedValue {
    sender.xy_parameter = @(selectedValue);
    if (self.rangSliderSelectValueFinish) {
        QVMediCameraToolbarType toolbarType = -1;
        if (sender == self.beautyRangeSlider) {
            toolbarType = QVMediCameraToolbarTypeBeauty;
        } else if (sender == self.exposureRangeSlider) {
            toolbarType = QVMediCameraToolbarTypeExposure;
        } else if (sender == self.focusRangeSlider) {
            toolbarType = QVMediCameraToolbarTypeFocus;
        }
        self.rangSliderSelectValueFinish(selectedValue, toolbarType);
    }
}

- (void)didEndTouchesInRangeSlider:(QVMediSlider *)sender {

}

- (void)didStartTouchesInRangeSlider:(QVMediSlider *)sender {

}



#pragma mark- get set lazy
- (UILabel *)toolbarActionTitleLabel {
    if (!_toolbarActionTitleLabel) {
        _toolbarActionTitleLabel = [[UILabel alloc] init];
        _toolbarActionTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _toolbarActionTitleLabel.textColor = UIColor.whiteColor;
        [self.superview addSubview:_toolbarActionTitleLabel];
        [_toolbarActionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.superview);
            make.bottom.mas_equalTo(self.focusRangeSlider.mas_top).offset(-10);
        }];
    }
    return _toolbarActionTitleLabel;
}

- (QVMediScrollToolbarSelectView *)filterScrollToolbar {
    if (!_filterScrollToolbar) {
        _filterScrollToolbar = [[QVMediScrollToolbarSelectView alloc] init];
        _filterScrollToolbar.hidden = YES;
        _filterScrollToolbar.backgroundColor = [UIColor qvmedi_colorWithHEX:0x313030 alpha:.8];
        __weak typeof(self) weakSelf = self;
        [_filterScrollToolbar createScrollToolbarWithData:@[
         @{@"title":@"卡点1",@"icon":@"qvsctoolbartestIcon",@"templateID":@(0x04000000000000E7)},
         @{@"title":@"卡点2",@"icon":@"qvsctoolbartestIcon",@"templateID":@(0x04000000000000E8)}]
                                              toolbarType:QVMediScrollToolbarFilter
                                             changeSelect:^(id  _Nonnull targetResource) {
            __strong typeof(weakSelf) self = weakSelf;
            if (self.toolbarFilterClickBlock) {
                self.toolbarFilterClickBlock(targetResource);
            }
        } action:nil selectFinish:^(id  _Nonnull targetResource) {
            NSLog(@"选择完成");
            __strong typeof(weakSelf) self = weakSelf;
            if (self.toolbarFilterClickBlock) {
                self.toolbarFilterClickBlock(targetResource);
            }
            self.filterScrollToolbar.hidden = YES;
            self.hidden = NO;
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(superViewTapAction)];
        [self.superview addGestureRecognizer:tap];
        [self.superview addSubview:_filterScrollToolbar];
        [_filterScrollToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.offset(0);
            make.height.offset(130);
        }];
    }
    return _filterScrollToolbar;
}

- (QVMediSlider *)focusRangeSlider {
    if (!_focusRangeSlider) {
        _focusRangeSlider = [[QVMediSlider alloc] initWithMinValue:1.0 maxValue:4.0 selectValue:1.0];
        _focusRangeSlider.hidden = YES;
        _focusRangeSlider.delegate = self;
        _focusRangeSlider.xy_parameter = @(1.0);
        _focusRangeSlider.handleColor = UIColor.whiteColor;
        _focusRangeSlider.tintColorBetweenHandles = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(superViewTapAction)];
        [self.superview addGestureRecognizer:tap];
        [self.superview addSubview:_focusRangeSlider];
        [_focusRangeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(60);
            make.right.offset(-60);
            make.bottom.offset(-144);
        }];
    }
    return _focusRangeSlider;
}

- (QVMediSlider *)beautyRangeSlider {
    if (!_beautyRangeSlider) {
        _beautyRangeSlider = [[QVMediSlider alloc] initWithMinValue:0 maxValue:100 selectValue:50];
        _beautyRangeSlider.hidden = YES;
        _beautyRangeSlider.delegate = self;
        _beautyRangeSlider.xy_parameter = @(50);
        _beautyRangeSlider.handleColor = UIColor.whiteColor;
        _beautyRangeSlider.tintColorBetweenHandles = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(superViewTapAction)];
        [self.superview addGestureRecognizer:tap];
        [self.superview addSubview:_beautyRangeSlider];
        [_beautyRangeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(60);
            make.right.offset(-60);
            make.bottom.offset(-144);
        }];
    }
    return _beautyRangeSlider;
}

- (QVMediSlider *)exposureRangeSlider {
    if (!_exposureRangeSlider) {
        _exposureRangeSlider = [[QVMediSlider alloc] initWithMinValue:-1 maxValue:1 selectValue:0];
        _exposureRangeSlider.hidden = YES;
        _exposureRangeSlider.delegate = self;
        _exposureRangeSlider.xy_parameter = @(0);
        _exposureRangeSlider.handleColor = UIColor.whiteColor;
        _exposureRangeSlider.tintColorBetweenHandles = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(superViewTapAction)];
        [self.superview addGestureRecognizer:tap];
        [self.superview addSubview:_exposureRangeSlider];
        [_exposureRangeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(60);
            make.right.offset(-60);
            make.bottom.offset(-144);
        }];
    }
    return _exposureRangeSlider;
}

- (NSNumberFormatter *)numberFormatterOverride {
    if (!_numberFormatterOverride){
        _numberFormatterOverride = [[NSNumberFormatter alloc] init];
        _numberFormatterOverride.numberStyle = NSNumberFormatterDecimalStyle;
        _numberFormatterOverride.maximumFractionDigits = 1;
    }
    return _numberFormatterOverride;
}

- (void)setRangSliderSelectValueFinish:(void (^)(float,QVMediCameraToolbarType))rangSliderSelectValueFinish {
    _rangSliderSelectValueFinish = rangSliderSelectValueFinish;
}

- (void)setToolbarRatioClickBlock:(void (^)(QVMediCameraToolbarType, QVMediCameraScaleType))toolbarRatioClickBlock {
    _toolbarRatioClickBlock = toolbarRatioClickBlock;
}

- (void)setToolbarFilterClickBlock:(void (^)(id _Nonnull))toolbarFilterClickBlock {
    _toolbarFilterClickBlock = toolbarFilterClickBlock;
}

- (void)setToolbarFillLightClickBlock:(void (^)(BOOL))toolbarFillLightClickBlock {
    _toolbarFillLightClickBlock = toolbarFillLightClickBlock;
}

- (NSArray *)defaultToolbarDataSourceArray {
    if (!_defaultToolbarDataSourceArray) {
        _defaultToolbarDataSourceArray = @[
            @{
                @"type":@(QVMediCameraToolbarTypeSwitch),
                @"icon&title":@"QVCameraToolbarTypeSwitch",
                @"title" : @"mn_cam_func_camera_id_switch",
                @"action":@""
            },
            @{
                @"type":@(QVMediCameraToolbarTypeFillLight),
                @"icon&title":@"QVCameraToolbarTypeFillLight",
                @"title" : @"mn_cam_func_flash",
                @"action":@"xy_cameraToolbarTypeFillLightAction:"
            },
            @{
                @"type":@(QVMediCameraToolbarTypeFocus),
                @"icon&title":@"QVCameraToolbarTypeFocus",
                @"title" : @"mn_cam_func_zoom",
                @"action":@"xy_cameraToolbarTypeFocusAction:"
            },
            @{
                @"type":@(QVMediCameraToolbarTypeExposure),
                @"icon&title":@"QVCameraToolbarTypeExposure",
                @"title" : @"mn_cam_func_exposure",
                @"action":@"xy_cameraToolbarTypeExposureAction:"
            },
            @{
                @"type":@(QVMediCameraToolbarTypeRatio),
                @"icon&title":@"QVCameraToolbarTypeRatio",
                @"title" : @"mn_edit_title_ratio",
                @"action":@"xy_cameraToolbarTypeRatioAction:",
                @"scaleTypes":@[
                        @{
                            @"icon":@"qv_QVUIKit_QVCameraToolbarTypeRatio_normal",
                            @"XYCameraScaleType":@(QVMediCameraScaleTypeDefault)
                        },
                        @{
                            @"icon":@"qv_QVUIKit_QVCameraToolbarTypeRatio_1_1_normal",
                            @"XYCameraScaleType":@(QVMediCameraScaleType_1_1)
                        },
                        @{
                            @"icon":@"qv_QVUIKit_QVCameraToolbarTypeRatio_3_4_normal",
                            @"XYCameraScaleType":@(QVMediCameraScaleType_3_4)
                        },
                ]
            },
            @{
                @"type":@(QVMediCameraToolbarTypeFilter),
                @"icon&title":@"QVCameraToolbarTypeFilter",
                @"title" : @"mn_edit_title_filter",
                @"action":@"xy_cameraToolbarTypeFilterAction:"
            },
            @{
                @"type":@(QVMediCameraToolbarTypeBeauty),
                @"icon&title":@"QVCameraToolbarTypeBeauty",
                @"title" : @"mn_cam_func_face_beauty",
                @"action":@"xy_cameraToolbarTypeBeautyAction:"
            }
        ];
    }
    return _defaultToolbarDataSourceArray;
}

@end
