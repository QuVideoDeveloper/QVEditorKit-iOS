//
//  XYVideoToolbarOperateView.m
//  Pods-XYToolbarKit_Example
//
//  Created by chaojie zheng on 2020/4/16.
//

#import "QVMediVideoToolbarOperateView.h"
#import "QVMediVideoEditToolbar.h"
#import "QVMediScrollToolbarSelectView.h"
#import <XYCategory/XYCategory.h>
#import <Masonry/Masonry.h>
#import "QVMediButton.h"
#import "QVMediSlider.h"
#import "YYKeyboardManager.h"
#import "QVMediToolbarTool.h"
#import <XYCommonEngineKit/XYCommonEngineKit.h>
#import "QVMediToolbarManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <XYTemplateDataMgr/XYTemplateDataMgr.h>
#import <QVMediTools/UIImage+QVMedi.h>

@interface QVMediVideoToolbarOperateView () <QVMediSliderDelegate, YYKeyboardObserver, UITextFieldDelegate>

@property (nonatomic,   copy) QVMediVideoToolbarOperateBlock changeBlock;

@property (nonatomic,   copy) QVMediVideoToolbarOperateBlock finishBlock;

@property (nonatomic, strong) NSMutableDictionary *sliderValueChangeDic;

@property (nonatomic, strong) NSMutableDictionary *finishEditParamsDic;

@property (nonatomic, strong) NSNumber *toobarType;

@property (nonatomic, strong) UIView *xyInputView;

@property (nonatomic, strong) UITextField *inputSubtitleTextField;

@property (nonatomic, strong) UIButton *inputFinishButton;

@property (nonatomic, assign) BOOL recordButtonIsShow;

@property (nonatomic, strong) UIView *itemBgView;

@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger totalMS;

@property (nonatomic, assign)  QVMediVideoEditToolbarType eidtToolbarType;


@end

@implementation QVMediVideoToolbarOperateView

- (void)creatOperateViewWithItemInfo:(NSDictionary *)itemInfo changeValue:(QVMediVideoToolbarOperateBlock)changeValue finish:(QVMediVideoToolbarOperateBlock)finish {
    self.eidtToolbarType = itemInfo[@"type"];
    self.changeBlock = changeValue;
    self.finishBlock = finish;
    self.recordButtonIsShow = NO;
    self.sliderValueChangeDic = [NSMutableDictionary new];
    self.finishEditParamsDic = [NSMutableDictionary new];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSString *actionName = itemInfo[@"action"];
    self.toobarType = itemInfo[@"type"];
    if (actionName && actionName.length) {
        SEL sel = NSSelectorFromString(actionName);
        if ([self canPerformAction:sel withSender:nil]) {
            IMP imp = [self methodForSelector:sel];
            ((id(*)(id, SEL, NSDictionary *))imp)(self, sel, itemInfo);
        }
        [self addTitleAndFinishButtton:itemInfo];
    }
}

#pragma mark- 主编辑工具栏 -- begin

- (void)xy_videoEditToolbarTypeAudioAction:(NSDictionary *)infoDic {
    UIView *bgView = [UIView new];
    [self addSubview:bgView];
    self.itemBgView = bgView;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(70);
        make.centerX.equalTo(self);
    }];
    QVMediButton *musicBtn = [QVMediButton qvmedi_buttonWithVivaButtonType:QVMediButtonStyleUpImageBelowTitle];
    [musicBtn setImage:[UIImage qvmedi_imageWithName:@"qv_videoEditToolbarTypeAudio_icon_music" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
    musicBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    [musicBtn setTitleColor:[UIColor xy_colorWithHEX:0xE6E6E6] forState:UIControlStateNormal];
    [musicBtn addTarget:self action:@selector(musicAction:) forControlEvents:UIControlEventTouchUpInside];
    [musicBtn setTitle:NSLocalizedString(@"mn_edit_title_bgm",@"") forState:UIControlStateNormal];
    [bgView addSubview:musicBtn];
    
    QVMediButton *soundEffectsBtn = [QVMediButton qvmedi_buttonWithVivaButtonType:QVMediButtonStyleUpImageBelowTitle];
    [soundEffectsBtn setImage:[UIImage qvmedi_imageWithName:@"qv_videoEditToolbarTypeAudio_icon_soundEffects" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
    soundEffectsBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [soundEffectsBtn addTarget:self action:@selector(soundEffectsAction:) forControlEvents:UIControlEventTouchUpInside];
    [soundEffectsBtn setTitleColor:[UIColor xy_colorWithHEX:0xE6E6E6] forState:UIControlStateNormal];
    [soundEffectsBtn setTitle:NSLocalizedString(@"mn_edit_title_dubbing",@"") forState:UIControlStateNormal];
    [bgView addSubview:soundEffectsBtn];
    
    
    QVMediButton *recordingBtn = [QVMediButton qvmedi_buttonWithVivaButtonType:QVMediButtonStyleUpImageBelowTitle];
    [recordingBtn setImage:[UIImage qvmedi_imageWithName:@"qv_videoEditToolbarTypeAudio_icon_record" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
    recordingBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    [recordingBtn addTarget:self action:@selector(recordingAction:) forControlEvents:UIControlEventTouchUpInside];
    [recordingBtn setTitleColor:[UIColor xy_colorWithHEX:0xE6E6E6] forState:UIControlStateNormal];
    [recordingBtn setTitle:NSLocalizedString(@"mn_edit_title_dub_record",@"") forState:UIControlStateNormal];
    [bgView addSubview:recordingBtn];
    
    [musicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.offset(64);
        make.height.offset(42);
    }];
    
    [soundEffectsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.size.equalTo(musicBtn);
        make.left.mas_equalTo(musicBtn.mas_right).offset(16);
    }];
    
    [recordingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.size.equalTo(musicBtn);
        make.left.mas_equalTo(soundEffectsBtn.mas_right).offset(16);
    }];
}

- (void)musicAction:(QVMediButton *)target {
    if (self.changeBlock) {
        self.changeBlock(self.toobarType, @(VideoEditToolbarTypeAudioTypeSong));
    }
}

- (void)soundEffectsAction:(QVMediButton *)target {
    if (self.changeBlock) {
        self.changeBlock(self.toobarType, @(VideoEditToolbarTypeAudioTypeSoundEffects));
    }
}

- (void)recordingAction:(QVMediButton *)target {
    if (self.changeBlock) {
        self.changeBlock(self.toobarType, @(VideoEditToolbarTypeAudioTypeRrecording));
    }
    self.itemBgView.hidden = YES;
    self.recordButtonIsShow = YES;
    [self.timeLabel removeFromSuperview];
    self.timeLabel = nil;
    [self.recordButton removeFromSuperview];
    self.recordButton = nil;
    if (!self.recordButton) {
        QVMediButton *recordBtn = [QVMediButton qvmedi_buttonWithVivaButtonType:QVMediButtonStyleNormal];
        [recordBtn setImage:[UIImage qvmedi_imageWithName:@"qv_videoEditToolbarTypeAudio_icon_recording" bundleName:@"QVMediToolbarKit"] forState:UIControlStateSelected];
        [recordBtn setImage:[UIImage qvmedi_imageWithName:@"qv_videoEditToolbarTypeAudio_icon_recordStop" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
        recordBtn.xy_parameter = target.xy_parameter;
        recordBtn.titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        [recordBtn setTitleColor:[UIColor xy_colorWithHEX:0xE6E6E6] forState:UIControlStateNormal];
        [recordBtn addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:recordBtn];
        self.recordButton = recordBtn;
        [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(72, 72));
            make.top.offset(90);
            make.centerX.equalTo(self);
        }];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.hidden = YES;
        self.timeLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(recordBtn);
            make.bottom.mas_equalTo(recordBtn.mas_top).offset(-30);
        }];
        
    }
//    if (self.changeBlock) {
//        self.changeBlock(self.toobarType, @(VideoEditToolbarTypeAudioTypeRrecording));
//    }
}

- (void)recordAction:(QVMediButton *)target {
    target.selected = !target.selected;
    self.timeLabel.hidden = NO;
    self.timeLabel.text = @"00:00";
    self.timeLabel.textColor = target.selected ? [UIColor xy_colorWithHEX:0xF94141] : UIColor.whiteColor;
    if (self.changeBlock) {
        if (!target.selected) {
            self.changeBlock(self.toobarType,  @(self.totalMS));
            [self.timer invalidate];
            self.timer = nil;

        } else {
            self.changeBlock(self.toobarType,  @(VideoEditToolbarTypeAudioTypeRrecording));
            self.totalMS = 0;
            [self.timer fire];
        }
    }
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1/1000.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
    

}

- (void)timerAction {
    self.totalMS++;
    NSInteger time = self.totalMS / 1000.0;
    int seconds = time % 60;
    int minutes = (time / 60) % 60;
    int hours = time / 3600;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    if (self.totalMS >= [XYEngineWorkspace clipMgr].clipsTotalDuration) {
        self.changeBlock(self.toobarType,  @(self.totalMS));
        [self.timer invalidate];
        self.timer = nil;
        self.recordButton.selected = NO;
    }
}

#pragma mark- 主编辑工具栏 -- end

#pragma mark- 字幕工具栏 -- begin

- (void)xy_videoEditToolbarTypeSubtitle_toobarTypeTrimAction:(NSDictionary *)infoDic {
    [self xy_videoEditToolbarTypeSticker_toobarTypeTrimAction:infoDic];
}

- (void)xy_videoEditToolbarTypeSubtitle_toobarTypeEditAction:(NSDictionary *)infoDic {
    [self.inputSubtitleTextField becomeFirstResponder];
}

- (void)xy_videoEditToolbarTypeSubtitle_toobarTypeOpacityAction:(NSDictionary *)infoDic {
    [self xy_videoEditToolbarTypeSticker_toobarTypeOpacityAction:infoDic];
}

- (void)xy_videoEditToolbarTypeSubtitle_toobarTypeZoomAction:(NSDictionary *)infoDic {
    [self xy_videoEditToolbarTypeSticker_toobarTypeZoomAction:infoDic];
}

#pragma mark- 字幕工具栏 -- end






#pragma mark- 贴纸工具栏 -- begin
- (void)xy_videoEditToolbarTypeSticker_toobarTypeModifyStyleAction:(NSDictionary *)infoDic {
    
}

- (void)xy_videoEditToolbarTypeSticker_toobarTypeTrimAction:(NSDictionary *)infoDic {
    [self xy_videoEditToolbarTypeEdit_toobarTypeTrimAction:infoDic];
}

- (void)xy_videoEditToolbarTypeSticker_toobarTypeVolumeAction:(NSDictionary *)infoDic {
    QVMediSlider *videoVolumeSlider = [self createOperateSliderMintValue:0 maxValue:100];
    videoVolumeSlider.hideCurValueLabel = NO;
    videoVolumeSlider.tintColorBetweenHandles = UIColor.whiteColor;
    [videoVolumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.left.offset(25);
        make.right.offset(-25);
    }];
}

- (void)xy_videoEditToolbarTypeSticker_toobarTypeOpacityAction:(NSDictionary *)infoDic {
    CGFloat videoVolumeValue = [infoDic[VideoVolumeValue] floatValue];
    QVMediSlider *stickerOpacitySlider = [self createOperateSliderMintValue:0 maxValue:100];
    stickerOpacitySlider.selectedValue = videoVolumeValue;
    stickerOpacitySlider.hideCurValueLabel = NO;
    stickerOpacitySlider.tintColorBetweenHandles = UIColor.whiteColor;
    [stickerOpacitySlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.left.offset(25);
        make.right.offset(-25);
    }];
}

- (void)xy_videoEditToolbarTypeSticker_toobarTypeZoomAction:(NSDictionary *)infoDic {
    UIView *bgView = [UIView new];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(70);
        make.centerX.equalTo(self);
    }];
    QVMediButton *zoomSmallBtn = [QVMediButton qvmedi_buttonWithVivaButtonType:QVMediButtonStyleUpImageBelowTitle];
    [zoomSmallBtn setImage:[UIImage qvmedi_imageWithName:@"qv_videoEditToolbarTypeSticker_toobarTypeZoom_icon_small" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
    zoomSmallBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [zoomSmallBtn setTitleColor:[UIColor xy_colorWithHEX:0xE6E6E6] forState:UIControlStateNormal];
    [zoomSmallBtn addTarget:self action:@selector(zoomOutAction:) forControlEvents:UIControlEventTouchUpInside];
    [zoomSmallBtn setTitle:NSLocalizedString(@"mn_edit_zoom_out",@"") forState:UIControlStateNormal];
    [bgView addSubview:zoomSmallBtn];
    
    QVMediButton *zoomBigBtn = [QVMediButton qvmedi_buttonWithVivaButtonType:QVMediButtonStyleUpImageBelowTitle];
    [zoomBigBtn setImage:[UIImage qvmedi_imageWithName:@"qv_videoEditToolbarTypeSticker_toobarTypeZoom_icon_big" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
    zoomBigBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [zoomBigBtn addTarget:self action:@selector(zoomAction:) forControlEvents:UIControlEventTouchUpInside];
    [zoomBigBtn setTitleColor:[UIColor xy_colorWithHEX:0xE6E6E6] forState:UIControlStateNormal];
    [zoomBigBtn setTitle:NSLocalizedString(@"mn_edit_zoom_in",@"") forState:UIControlStateNormal];
    [bgView addSubview:zoomBigBtn];
    
    [zoomSmallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.offset(76);
        make.height.offset(48);
    }];
    
    [zoomBigBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.offset(0);
        make.size.equalTo(zoomSmallBtn);
        make.left.mas_equalTo(zoomSmallBtn.mas_right).offset(60);
    }];

}

- (void)zoomOutAction:(QVMediButton *)target {
    if (self.changeBlock) {
        self.changeBlock(self.toobarType, @"zoomIn");
    }
}

- (void)zoomAction:(QVMediButton *)target {
    if (self.changeBlock) {
        self.changeBlock(self.toobarType, @"zoomOut");
    }
}

#pragma mark- 贴纸工具栏 -- end







#pragma mark- 编辑工具栏 -- begin
- (void)xy_videoEditToolbarTypeEdit_toobarTypeTrimAction:(NSDictionary *)infoDic {
    // TODO: begin
    UILabel *leftTitleLabelBegin = [self creatLeftTitleLabel:NSLocalizedString(@"mn_edit_title_start",@"")];
    [leftTitleLabelBegin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(80);
    }];
    
    NSInteger videoTotalDuration = [infoDic[VideoTotalDuration] integerValue];
    QVMediSlider *videoTrimBeginSlider = [self createOperateSliderMintValue:0 maxValue:videoTotalDuration/2/1000];
    videoTrimBeginSlider.selectedValue = 0;
    videoTrimBeginSlider.minLabelString = @"00:00";
    videoTrimBeginSlider.maxLabelString = [self getMMSSFromSS:videoTotalDuration/2/1000];
    videoTrimBeginSlider.step = 1;
    __weak typeof(self) weakSelf = self;
    videoTrimBeginSlider.didChangeSelectedValueBlock = ^(QVMediSlider * _Nonnull slider, float selectedValue) {
        [weakSelf.finishEditParamsDic setObject:@((int)selectedValue * 1000) forKey:VideoTrimBeginDuration];
    };
    [videoTrimBeginSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftTitleLabelBegin);
        make.left.mas_equalTo(leftTitleLabelBegin.mas_right).offset(12);
        make.right.offset(-25);
    }];
    
    // TODO: end
    UILabel *leftTitleLabelEnd = [self creatLeftTitleLabel:NSLocalizedString(@"mn_edit_title_end",@"")];
    [leftTitleLabelEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.mas_equalTo(leftTitleLabelBegin.mas_bottom).offset(40);
    }];
    QVMediSlider *videoTrimEndSlider = [self createOperateSliderMintValue:videoTotalDuration/2/1000 maxValue:videoTotalDuration/1000];
    videoTrimEndSlider.selectedValue = videoTotalDuration/1000;
    videoTrimEndSlider.step = 1;
    videoTrimEndSlider.minLabelString = videoTrimBeginSlider.maxLabelString;
    videoTrimEndSlider.maxLabelString = [self getMMSSFromSS:videoTotalDuration/1000];
    videoTrimEndSlider.didChangeSelectedValueBlock = ^(QVMediSlider * _Nonnull slider, float selectedValue) {
        [weakSelf.finishEditParamsDic setObject:@((int)selectedValue * 1000) forKey:VideoTrimEndDuration];
    };
    [videoTrimEndSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftTitleLabelEnd);
        make.left.mas_equalTo(leftTitleLabelEnd.mas_right).offset(12);
        make.right.offset(-25);
        make.height.offset(30);
    }];
}

- (void)xy_videoEditToolbarTypeEdit_toobarTypeSplitAction:(NSDictionary *)infoDic {
    // TODO: Split point
    UILabel *leftTitleLabelSplit = [self creatLeftTitleLabel:@"分割点"];
    [leftTitleLabelSplit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(120);
    }];
    NSInteger videoTotalDuration = [infoDic[VideoTotalDuration] integerValue]/1000;
    QVMediSlider *videoSplitSlider = [self createOperateSliderMintValue:0 maxValue:videoTotalDuration];
    videoSplitSlider.minLabelString = @"00:00";
    videoSplitSlider.selectedValue = 0;
    videoSplitSlider.maxLabelString = [self getMMSSFromSS:videoTotalDuration];
    __weak typeof(self) weakSelf = self;
    videoSplitSlider.didChangeSelectedValueBlock = ^(QVMediSlider * _Nonnull slider, float selectedValue) {
        [weakSelf.finishEditParamsDic setObject:@((int)selectedValue * 1000) forKey:VideoCutDuration];
    };
    [videoSplitSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftTitleLabelSplit);
        make.left.mas_equalTo(leftTitleLabelSplit.mas_right).offset(12);
        make.right.offset(-25);
    }];
}

- (void)xy_videoEditToolbarTypeEdit_toobarTypeVolumeAction:(NSDictionary *)infoDic {
    // TODO: Volume
    CGFloat videoVolumeValue = [infoDic[VideoVolumeValue] floatValue];
    UILabel *leftTitleLabelVolume = [self creatLeftTitleLabel:NSLocalizedString(@"xy_videoEditToolbarTypeSticker_toobarTypeTrim_volume",@"")];
    [leftTitleLabelVolume mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(120);
    }];
    QVMediSlider *videoVolumeSlider = [self createOperateSliderMintValue:0 maxValue:100];
    videoVolumeSlider.hideCurValueLabel = NO;
    __weak typeof(self) weakSelf = self;
    videoVolumeSlider.didChangeSelectedValueBlock = ^(QVMediSlider * _Nonnull slider, float selectedValue) {
        [weakSelf.finishEditParamsDic setObject:@((CGFloat)selectedValue) forKey:VideoVolumeValue];
    };
    videoVolumeSlider.selectedValue = videoVolumeValue;
    [videoVolumeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftTitleLabelVolume);
        make.left.mas_equalTo(leftTitleLabelVolume.mas_right).offset(12);
        make.right.offset(-25);
    }];
}

- (void)xy_videoEditToolbarTypeEdit_toobarTypeVoiceChangeAction:(NSDictionary *)infoDic {
    CGFloat videoVoiceChangeValue = [infoDic[VideoVoiceChangeValue] floatValue];
    QVMediSlider *videoVoiceChangeSlider = [self createOperateSliderMintValue:-50 maxValue:50];
    videoVoiceChangeSlider.hideCurValueLabel = NO;
    __weak typeof(self) weakSelf = self;
    videoVoiceChangeSlider.didChangeSelectedValueBlock = ^(QVMediSlider * _Nonnull slider, float selectedValue) {
        [weakSelf.finishEditParamsDic setObject:@((CGFloat)selectedValue) forKey:VideoVoiceChangeValue];
    };
    videoVoiceChangeSlider.selectedValue = videoVoiceChangeValue;
    [videoVoiceChangeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.left.offset(27);
        make.right.offset(-25);
    }];
}

- (void)xy_videoEditToolbarTypeEdit_toobarTypeVariableSpeedAction:(NSDictionary *)infoDic {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.maximumFractionDigits = 2;
    CGFloat videoSpeedValue = [infoDic[VideoSpeedChangeValue] floatValue];

    QVMediSlider *videoSplitSlider = [self createOperateSliderMintValue:0.25 maxValue:4];
    videoSplitSlider.step = 0.01;
    videoSplitSlider.minLabelString = @"0.25x";
    videoSplitSlider.maxLabelString = @"4x";
    videoSplitSlider.hideCurValueLabel = NO;
    __weak typeof(self) weakSelf = self;
    videoSplitSlider.didChangeSelectedValueBlock = ^(QVMediSlider * _Nonnull slider, float selectedValue) {
        [weakSelf.finishEditParamsDic setObject:@((CGFloat)selectedValue) forKey:VideoSpeedChangeValue];
    };
    videoSplitSlider.selectedValue = videoSpeedValue;
    videoSplitSlider.numberFormatterOverride = numberFormatter;
    [videoSplitSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(100);
        make.left.offset(27);
        make.right.offset(-25);
    }];
}

/*
if ([effectPropertyItem.nameLocale isEqualToString:@"%brightness%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeBrightness;
} else if ([effectPropertyItem.nameLocale isEqualToString:@"%contrast%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeContrast;
} else if ([effectPropertyItem.nameLocale isEqualToString:@"%sharpen%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeSharpen;
} else if ([effectPropertyItem.nameLocale isEqualToString:@"%saturation%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeSaturation;
} else if ([effectPropertyItem.nameLocale isEqualToString:@"%temperature%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeTemperature;
} else if ([effectPropertyItem.nameLocale isEqualToString:@"%vignette%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeVignette;
} else if ([effectPropertyItem.nameLocale isEqualToString:@"%hue%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeHue;
} else if ([effectPropertyItem.nameLocale isEqualToString:@"%fade%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeFade;
} else if ([effectPropertyItem.nameLocale isEqualToString:@"%shadow%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeShadow;
} else if ([effectPropertyItem.nameLocale isEqualToString:@"%highlight%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeHighlight;
} else if ([effectPropertyItem.nameLocale isEqualToString:@"%noise%"]) {
    effectPropertyItem.adjustType = XYCommonEngineAdjustTypeNoise;
}
*/
/*
 XYCommonEngineAdjustTypeBrightness,//亮度
 XYCommonEngineAdjustTypeContrast,//对比度
 XYCommonEngineAdjustTypeSaturation,//饱和度
 XYCommonEngineAdjustTypeSharpen,//锐度
 XYCommonEngineAdjustTypeTemperature,//色温
 XYCommonEngineAdjustTypeVignette,//暗角
 XYCommonEngineAdjustTypeHue,//色调
 XYCommonEngineAdjustTypeShadow,//阴影
 XYCommonEngineAdjustTypeHighlight,//高光
 XYCommonEngineAdjustTypeFade,//褪色
 XYCommonEngineAdjustTypeNoise,//噪点
 */

- (void)xy_videoEditToolbarTypeEdit_toobarTypeParameterAdjustmentAction:(NSDictionary *)infoDic {
    NSArray *itemInfoAry = @[
        @{@"title":@"亮度",@"paramName":@"%brightness%"},
        @{@"title":@"对比度",@"paramName":@"%contrast%"},
        @{@"title":@"饱和度",@"paramName":@"%saturation%"},
        @{@"title":@"锐度",@"paramName":@"%sharpen%"},
        @{@"title":@"色温",@"paramName":@"%hue%"},
        @{@"title":@"暗角",@"paramName":@"%vignette%"},
        @{@"title":@"阴影",@"paramName":@"%shadow%"},
        @{@"title":@"色调",@"paramName":@"%hue%"},
        @{@"title":@"高光",@"paramName":@"%highlight%"},
        @{@"title":@"褪色",@"paramName":@"%fade%"},
        @{@"title":@"噪点",@"paramName":@"%noise%"}
    ];
    NSMutableDictionary *parameterAdjustmentDic = infoDic[VideoParameterAdjustment];
    UIScrollView *sliderBackScrollView = [UIScrollView new];
    sliderBackScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:sliderBackScrollView];
    [sliderBackScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    __block MASViewAttribute *topViewAttribute = sliderBackScrollView.mas_top;
    [itemInfoAry enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull objDic, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *paramItemDic = [parameterAdjustmentDic objectForKey:objDic[@"paramName"]];
        CGFloat curParamValue = [paramItemDic[@"paramValue"] floatValue];
        UILabel *leftTitleLabel = [self creatLeftTitleLabel:objDic[@"title"]];
        [leftTitleLabel sizeToFit];
        [sliderBackScrollView addSubview:leftTitleLabel];

        QVMediSlider *paramSlider = [self createOperateSliderMintValue:-50 maxValue:50];
        paramSlider.xy_parameter = objDic[@"paramName"];
        paramSlider.selectedHandleDiameterMultiplier = 1.1;
        paramSlider.didChangeSelectedValueBlock = ^(QVMediSlider * _Nonnull slider, float selectedValue) {
            [parameterAdjustmentDic setObject:@{@"paramValue":@((int)selectedValue),@"paramName":slider.xy_parameter} forKey:slider.xy_parameter];
        };
        paramSlider.selectedValue = curParamValue;
        [sliderBackScrollView addSubview:paramSlider];
        
        [leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topViewAttribute).offset(30);
            make.left.offset(20);
            make.width.offset(35);
        }];
        [paramSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftTitleLabel);
            make.left.mas_equalTo(leftTitleLabel.mas_right).offset(12);
            make.right.mas_equalTo(self).offset(-25);
            make.height.offset(30);
        }];
        topViewAttribute = leftTitleLabel.mas_bottom;
    }];
    [self.finishEditParamsDic setObject:parameterAdjustmentDic forKey:VideoParameterAdjustment];
    [sliderBackScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topViewAttribute).offset(40);
    }];
}

- (void)xy_videoEditToolbarTypeEdit_toobarTypeTransitionAction:(NSDictionary *)infoDic {
    [self createOperateScrollSelectView:infoDic];
}

- (void)xy_videoEditToolbarTypeEdit_toobarTypeFilterAction:(NSDictionary *)infoDic {
    [self createOperateScrollSelectView:infoDic];
}

#pragma mark- 编辑工具栏 -- end







#pragma mark- 创建UI
- (void)addTitleAndFinishButtton:(NSDictionary *)infoDic {
    UIView *bottomActionView = [UIView new];
    bottomActionView.backgroundColor = [UIColor xy_colorWithHEX:0x000102];
    [self addSubview:bottomActionView];
    [bottomActionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(45);
        make.left.right.bottom.equalTo(self);
    }];
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = NSLocalizedString(infoDic[@"icon&title"], @"");
    if (infoDic[@"title"]) {
        tipLabel.text = NSLocalizedString(infoDic[@"title"], @"");
    }
    tipLabel.textColor = [UIColor xy_colorWithHEX:0xE6E6E6];
    tipLabel.font = [UIFont systemFontOfSize:14];
    [bottomActionView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bottomActionView);
    }];
    
    UIButton *finishButton = [UIButton new];
    [finishButton setImage:[UIImage qvmedi_imageWithName:@"qv_selectToolbarItem_selectFinish" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishSelect) forControlEvents:UIControlEventTouchUpInside];
    [bottomActionView addSubview:finishButton];
    [finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipLabel);
        make.left.offset([UIScreen mainScreen].bounds.size.width - 48);
    }];
}

- (UILabel *)creatLeftTitleLabel:(NSString *)title {
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor xy_colorWithHEX:0xE6E6E6];
    titleLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    [self addSubview:titleLabel];
    return titleLabel;
}

- (QVMediSlider *)createOperateSliderMintValue:(float)minValue maxValue:(float)maxValue {
    QVMediSlider *operateSlider = [[QVMediSlider alloc] initWithMinValue:minValue maxValue:maxValue selectValue:(maxValue + minValue)/2];
    operateSlider.delegate = self;
    operateSlider.xy_parameter = @((minValue + maxValue)/2);
    operateSlider.handleColor = UIColor.whiteColor;
    operateSlider.hideMinMaxValueLabel = NO;
    operateSlider.curValueLabelFont = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    operateSlider.hideCurValueLabel = YES;
    operateSlider.tintColorBetweenHandles = UIColor.clearColor;
    [self addSubview:operateSlider];
    return operateSlider;
}

- (QVMediScrollToolbarSelectView *)createOperateScrollSelectView:(NSDictionary *)infoDic {
    QVMediScrollToolbarSelectView *scrollToolbar = [[QVMediScrollToolbarSelectView alloc] init];
    __weak typeof(self) weakSelf = self;
    NSMutableArray *testDataAry = [NSMutableArray arrayWithCapacity:10];
    NSInteger type = [[infoDic valueForKeyPath:@"type"] integerValue];
    QVMediScrollToolbarType toolbarType = QVMediScrollToolbarFilter;
    if (QVMediVideoEditToolbarTypeEdit_toobarTypeTransition == type) {
        toolbarType = QVMediScrollToolbarVideoEditTransition;
    }
    [scrollToolbar createScrollToolbarWithData:testDataAry toolbarType:toolbarType changeSelect:^(id  _Nonnull targetResource) {
        __strong typeof(weakSelf) self = weakSelf;
        {
            NSDictionary * dic = targetResource;
            NSDictionary *info = [dic valueForKeyPath:@"info"];
            XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:[QVMediToolbarManager manager].clipSeletedIdx];
            if (QVMediScrollToolbarFilter == toolbarType) {
                clipModel.groupID = XYCommonEngineGroupIDFXFilter;
                clipModel.taskID = XYCommonEngineTaskIDClipFilterAdd;
                clipModel.clipEffectModel.fxFilterFilePath = [info valueForKey:@"filePath"];
                if (0 == [dic[@"index"] integerValue]) {
                    clipModel.clipEffectModel.fxFilterFilePath = [[XYTemplateDataMgr sharedInstance] getPathByID:QVET_THEME_NONE_TEMPLATE_ID];
                }
            } else {
                clipModel.clipEffectModel.fxFilterFilePath = [info valueForKey:@"filePath"];
                if (0 == [dic[@"index"] integerValue]) {
                    clipModel.taskID = XYCommonEngineTaskIDClipTransition;
                    clipModel.clipEffectModel.effectTransFilePath = nil;
                } else {
                    if ([QVMediToolbarManager manager].clipSeletedIdx == [XYEngineWorkspace clipMgr].clipModels.count - 1) {
                                       [SVProgressHUD showImage:nil status:@"最后一个不能添加转场"];
                                       return;
                                   }
                                   XYClipModel *nextClip = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:[QVMediToolbarManager manager].clipSeletedIdx + 1];
                                   if(clipModel.trimVeRange.dwLen < 1000||
                                      nextClip.trimVeRange.dwLen < 1000) {
                                       [SVProgressHUD showImage:nil status:@"时长不够，不能添加"];
                                       return;
                                   }
                                   XYClipEffectModel *effectModel  = [[XYClipEffectModel alloc]init];
                                   effectModel.effectTransFilePath = [info valueForKey:@"filePath"];
                                   if (0 == [dic[@"index"] integerValue]) {
                                       clipModel.clipEffectModel.fxFilterFilePath = [[XYTemplateDataMgr sharedInstance] getPathByID:QVET_TRANSITION_NONE_TEMPLATE_ID];
                                   }
                                   clipModel.clipEffectModel  = effectModel ;
                                   clipModel.taskID = XYCommonEngineTaskIDClipTransition;
                               }
                }
               
            [[XYEngineWorkspace clipMgr] runTask:clipModel];

        }
    } action:[infoDic valueForKey:@"action"] selectFinish:^(id  _Nonnull targetResource) {
        
    }];
    [self addSubview:scrollToolbar];
    [scrollToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(108);
        make.bottom.offset(-65);
    }];
    return scrollToolbar;
}

- (UIView *)xyInputView {
    if (!_xyInputView) {
        _xyInputView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 50)];
        _xyInputView.backgroundColor = [UIColor xy_colorWithHEX:0x000102];
        [[UIApplication sharedApplication].keyWindow addSubview:_xyInputView];
    }
    return _xyInputView;
}

- (UITextField *)inputSubtitleTextField {
    if (!_inputSubtitleTextField) {
        _inputSubtitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 78, 34)];
        _inputSubtitleTextField.borderStyle = UITextBorderStyleNone;
        _inputSubtitleTextField.backgroundColor = [UIColor lightGrayColor];
        _inputSubtitleTextField.layer.cornerRadius = 10;
        _inputSubtitleTextField.tintColor = [UIColor xy_colorWithHEX:0x101112];
        _inputSubtitleTextField.delegate = self;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 34)];
        _inputSubtitleTextField.leftView = leftView;
        _inputSubtitleTextField.leftViewMode = UITextFieldViewModeAlways;
        [[YYKeyboardManager defaultManager] addObserver:self];
        [self.xyInputView addSubview:_inputSubtitleTextField];
        [_inputSubtitleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.centerY.equalTo(self.xyInputView);
            make.right.mas_equalTo(self.inputFinishButton.mas_left).offset(-5);
            make.height.offset(34);
            make.width.offset([UIScreen mainScreen].bounds.size.width - 78);
        }];
    }
    return _inputSubtitleTextField;
}

- (UIButton *)inputFinishButton {
    if (!_inputFinishButton) {
        _inputFinishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        [_inputFinishButton setImage:[UIImage qvmedi_imageWithName:@"qv_videoEdit_inputSubtitle_finish_icon" bundleName:@"QVMediToolbarKit"] forState:UIControlStateNormal];
        [_inputFinishButton addTarget:self action:@selector(inputSubtitleFinishAction) forControlEvents:UIControlEventTouchUpInside];
        [self.xyInputView addSubview:_inputFinishButton];
        [_inputFinishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.inputSubtitleTextField.mas_right).offset(5);
            make.size.mas_equalTo(CGSizeMake(34, 34));
            make.centerY.equalTo(self.inputSubtitleTextField);
        }];
    }
    return _inputFinishButton;
}


#pragma mark- XYSliderDelegate
- (void)rangeSlider:(QVMediSlider *)sender didChangeSelectedValue:(float)selectedValue {

}

- (void)didEndTouchesInRangeSlider:(QVMediSlider *)sender {
    sender.hideCurValueLabel = YES;
    if (self.changeBlock) {
        [self.finishEditParamsDic setValue:@(sender.selectedValue) forKey:VideoVolumeValue];
        self.changeBlock(self.toobarType, self.finishEditParamsDic);
    }
}

- (void)didStartTouchesInRangeSlider:(QVMediSlider *)sender {
    sender.hideCurValueLabel = NO;
}



#pragma mark- YYKeyboardObserver
- (void)keyboardChangedWithTransition:(YYKeyboardTransition)transition {
    ///用此方法获取键盘的rect
    CGRect kbFrame = [[YYKeyboardManager defaultManager] convertRect:transition.toFrame toView:[UIApplication sharedApplication].keyWindow];
    if (kbFrame.origin.y == CGRectGetHeight([UIApplication sharedApplication].keyWindow.frame)) {
        CGRect textframe = self.xyInputView.frame;
        textframe.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.xyInputView.frame = textframe;
    }else{
        ///从新计算tf的位置并赋值
        CGRect textframe = self.xyInputView.frame;
        textframe.origin.y = kbFrame.origin.y - textframe.size.height;
        self.xyInputView.frame = textframe;
    }
}

#pragma mark- UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.changeBlock) {
        self.changeBlock(self.toobarType, textField.text);
    }
}


#pragma mark- tool action
- (NSString *)getMMSSFromSS:(NSInteger)totalTime {
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",totalTime/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",totalTime%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

#pragma mark- action

- (void)finishSelect {
    if (self.recordButtonIsShow) {
        self.recordButtonIsShow = NO;
        self.itemBgView.hidden = NO;
        self.recordButton.hidden = YES;
        self.timeLabel.hidden = YES;
        return;
    }
    if (self.finishBlock) {
        self.finishBlock(self.toobarType, self.finishEditParamsDic);
    }
}

- (void)inputSubtitleFinishAction {
    self.hidden = YES;
    [self.inputSubtitleTextField resignFirstResponder];
    if (self.finishBlock) {
        self.finishBlock(self.toobarType, self.inputSubtitleTextField.text);
    }
}

#pragma mark- set get lazy

- (void)dealloc {
    [[YYKeyboardManager defaultManager] removeObserver:self];
}

@end
