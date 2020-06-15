//
//  QVHomeContentView.m
//  VivaMedi
//
//  Created by chaojie zheng on 2020/4/20.
//  Copyright © 2020 QuVideo. All rights reserved.
//

#import "QVHomeContentView.h"
#import "QVPreviewViewController.h"
#import "QVMediScrollToolbarSelectView.h"
#import "QVPopupViewMgr.h"
#import "QVVideoEditViewController.h"
#import <XYCommonEngineKit/XYCommonEngineKit.h>
#import "QVMediVideoEditManager.h"
#import <QVMediCamera/QVMediEngineCameraVC.h>
#import "QVMediButton.h"
#import "QVBaseNavigationController.h"
#import <Masonry/Masonry.h>
#import "UIImage+QVMediEdit.h"
#import "QVMediMacro.h"
#import "UIColor+QVMediInit.h"
#import <YYCategories/YYCategories.h>
#import "TZImagePickerController.h"
@import CoreServices;
@import Photos;

@interface QVHomeContentView ()

/// Background ImageView
@property (nonatomic, strong) UIImageView *bgImageView;

/// Item background view
@property (nonatomic, strong) UIView *bottomActionBgView;

/// Video recording
@property (nonatomic, strong) QVMediButton *videoRecordingButton;

/// Video edit
@property (nonatomic, strong) QVMediButton *videoEditButton;

/// Card point
@property (nonatomic, strong) QVMediButton *cardPointVideoButton;

@property (nonatomic, assign) NSInteger templateID;

@end

@implementation QVHomeContentView

- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.bgImageView.image = [UIImage QVMediEditImageNamed:@"qvmedi_home_icon_banner"];
    [self.videoRecordingButton addTarget:self action:@selector(videoRecording) forControlEvents:UIControlEventTouchUpInside];
    [self.videoEditButton addTarget:self action:@selector(videoEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.cardPointVideoButton addTarget:self action:@selector(cardPointVideo) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark- action

- (void)videoRecording {
    QVMediEngineCameraVC *cameraVC = [[QVMediEngineCameraVC alloc] init];
    [getCurrentViewController().navigationController pushViewController:cameraVC animated:YES];
}

- (void)videoEdit {
    [[QVMediVideoEditManager sharedInstance] selectVideoFinish:^{
        UINavigationController * navVC = getCurrentViewController().navigationController;
        if (![navVC.topViewController isKindOfClass:[QVVideoEditViewController class]]) {
            QVVideoEditViewController *videoEditVC = [QVVideoEditViewController new];
            [getCurrentViewController().navigationController pushViewController:videoEditVC animated:YES];
        }
    }];
}

- (void)showMediaPicker {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingMultipleVideo = YES;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        XYSlideShowConfiguration *config = [[XYSlideShowConfiguration alloc] init];
        [[XYSlideShowEditor sharedInstance] initializeWithConfig:config];
        __block NSMutableArray *medias = [NSMutableArray array];
        [assets enumerateObjectsUsingBlock:^(PHAsset * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            XYSlideShowMedia *mediaModel = [[XYSlideShowMedia alloc] initWithMediaPath:[QVMediVideoEditManager qvmedi_engineLocalIdentifier:obj] mediaTyp:(PHAssetMediaTypeImage == [obj mediaType] ? XYSlideShowMediaTypeImage : XYSlideShowMediaTypeVideo)];
            [medias addObject:mediaModel];
        }];
        [[XYSlideShowEditor sharedInstance] createProjectWithThemeId:self.templateID medias:medias complete:^(BOOL success) {
            QVVideoEditViewController *videoEditVC = [QVVideoEditViewController new];
            videoEditVC.isCardPoint = YES;
            [getCurrentViewController().navigationController pushViewController:videoEditVC animated:YES];
        }];
        
    }];
    [getCurrentViewController().navigationController presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)cardPointVideo {
    QVMediScrollToolbarSelectView *cardPointVideoScv = [[QVMediScrollToolbarSelectView alloc] initWithFrame:CGRectMake(0, QVMEDI_SCREEN_HEIGHT - 175, QVMEDI_SCREEN_WIDTH, 175)];
    cardPointVideoScv.backgroundColor = [UIColor qvmedi_colorWithHEX:0x101112];
    [cardPointVideoScv createScrollToolbarWithData:nil toolbarType:QVMediScrollToolbarCardPoint changeSelect:^(id  _Nonnull targetResource) {
        
    } action:nil selectFinish:^(id  _Nonnull targetResource) {
        NSInteger templateID = [targetResource[@"info"][@"templateID"] integerValue] ;
        self.templateID = templateID;
        [[QVPopupViewMgr sharedInstance] dismiss];
        
        [self showMediaPicker];
    }];
    [[QVPopupViewMgr sharedInstance] show:cardPointVideoScv enableTouchToHide:YES background:0.7 pointInBottom:YES];
}


#pragma mark- lazy
- (QVMediButton *)videoRecordingButton {
    if (!_videoRecordingButton) {
        _videoRecordingButton = [QVMediButton new];
        setAttributed(NSLocalizedString(@"mn_app_mode_camera", @""), @"qvmedi_home_icon_videoRecording", _videoRecordingButton);
        [self.bottomActionBgView addSubview:_videoRecordingButton];
        CGFloat btnWidth = (QVMEDI_SCREEN_WIDTH - 24*2 - 17)/2;
        CGFloat btnHeight = btnWidth * 183/155;
        [_videoRecordingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(24);
            make.top.offset(48);
            make.width.offset(btnWidth);
            make.height.offset(btnHeight);
            make.right.mas_equalTo(self.videoEditButton.mas_left).offset(-17);
        }];
        
    }
    return _videoRecordingButton;
}

- (QVMediButton *)videoEditButton {
    if (!_videoEditButton) {
        _videoEditButton = [QVMediButton new];
        setAttributed(NSLocalizedString(@"mn_app_mode_editor", @""), @"qvmedi_home_icon_videoedit", _videoEditButton);
        [self.bottomActionBgView addSubview:_videoEditButton];
        [_videoEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-24);
            make.top.offset(48);
            make.height.width.equalTo(self.videoRecordingButton);
            make.left.mas_equalTo(self.videoRecordingButton.mas_right).offset(17);
        }];
    }
    return _videoEditButton;
}

- (QVMediButton *)cardPointVideoButton {
    if (!_cardPointVideoButton) {
        _cardPointVideoButton = [QVMediButton new];
        setAttributed(NSLocalizedString(@"mn_app_mode_template", @""), @"qvmedi_home_icon_cardPointVideo", _cardPointVideoButton);
        _cardPointVideoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _cardPointVideoButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 37);
        [self.bottomActionBgView addSubview:_cardPointVideoButton];
        [_cardPointVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-24);
            make.left.offset(24);
            make.top.mas_equalTo(self.videoRecordingButton.mas_bottom).offset(15);
        }];
    }
    return _cardPointVideoButton;
}


- (UIView *)bottomActionBgView {
    if (!_bottomActionBgView) {
        _bottomActionBgView = [UIView new];
        _bottomActionBgView.backgroundColor = UIColor.whiteColor;
        _bottomActionBgView.layer.cornerRadius = 24;
        UILabel *tipLabel = [UILabel new];
        tipLabel.text = @"Design by QuVideo";
        tipLabel.font = [UIFont systemFontOfSize:8 weight:UIFontWeightSemibold];
        [_bottomActionBgView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomActionBgView);
            make.bottom.offset(-46);
        }];
        [self addSubview:_bottomActionBgView];
        [_bottomActionBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(227);
            make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(-24);
            make.left.right.offset(0);
            make.bottom.offset(24);
        }];
    }
    return _bottomActionBgView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.backgroundColor = UIColor.redColor;
        _bgImageView.userInteractionEnabled = YES;
        [self addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
        }];
    }
    return _bgImageView;
}


void setAttributed(NSString *title, NSString *imageName, QVMediButton *button) {
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    [button setBackgroundImage:[UIImage QVMediEditImageNamed:imageName] forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(60,0, 0, 0);
}


- (void)dealloc {
    [[XYEngineWorkspace projectMgr] removeObserver:self observerID:XYCommonEngineTaskIDQProjectCreate];
    [[XYEngineWorkspace clipMgr] removeObserver:self observerID:XYCommonEngineTaskIDClipAddClip];
}

@end
