//
//  QVVideoEditContentView.m
//  VivaMedi
//
//  Created by chaojie zheng on 2020/4/21.
//  Copyright © 2020 QuVideo. All rights reserved.
//

#import "QVVideoEditContentView.h"
#import "QVMediVideoEditToolbar.h"
#import "QVMediVideoEditManager.h"
#import "QVMediSlider.h"
#import <XYCommonEngineKit/XYCommonEngineKit.h>
#import <XYTemplateDataMgr/XYTemplateDataMgr.h>
#import <XYCommonEngineKit/XYVideoThumbnailManager.h>
#import <XYCommonEngineKit/XYClipThumbnailManager.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <XYCommonEngineKit/XYEffectAudioModel.h>
#import <XYCommonEngineKit/XYBaseEffectAudioTask.h>
#import "QVMediVideoToolbarOperateView.h"
#import "QVMediToolbarTool.h"
#import "QVMediToolbarManager.h"
#import <AVFoundation/AVFoundation.h>
#import "QVPlayerViewController.h"
#import "QVBaseNavigationController.h"
#import "QVMediButton.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "NSObject+QVMediParameter.h"
#import "NSFileManager+QVMediOperate.h"
#import "UIColor+QVMediInit.h"
#import "QVMediAlbumMediaItem.h"
#import "UIImage+QVMediEdit.h"
#import "QVMediTools.h"

#define VIDEOEDITTOOLBARDEFAULTHEIGHT (239 + [QVMediTools qv_safeAreaBottom])

static CGFloat safeAreaTop() {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 0 ? [UIApplication sharedApplication].delegate.window.safeAreaInsets.top : 20;
    } else {
        return 0;
    }
}

@interface QVVideoEditContentView () <QVMediSliderDelegate, XYPlayerViewDelegate>

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton *exportButton;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) QVMediVideoEditToolbar *videoEditToolbar;

@property (nonatomic, assign) QVMediVideoEditToolbarType videoEditToolbarType;

@property (nonatomic,   copy) NSString *toolbarEditActionName;

@property (nonatomic, strong) XYPlayerView *editorPlayerView;

@property (nonatomic, strong) QVMediSlider *videoProgressSlider;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) BOOL startTouchesSlider;

@property (nonatomic, assign) BOOL playFinish;

@property (nonatomic, assign) BOOL deleteClip;

@property (nonatomic, assign) BOOL runTaskFinishRefresh;

@property (nonatomic, assign) NSInteger curSelectClipIndex;

@property (nonatomic, strong) NSArray <NSString *> *getDefaultTemplateCodeList;

@property (nonatomic, strong) NSArray <NSDictionary *> *getDefaultTemplateImageList;

@property (nonatomic, strong) NSDictionary *defaultTemplateCodeListDic;

@property (nonatomic, assign) CGSize playSize;

@property (nonatomic, strong) AVAudioSession *session;

@property (nonatomic, strong) AVAudioRecorder *recorder;//录音器

@property (nonatomic, strong) NSURL *recordFileUrl; //文件地址

@property (nonatomic, assign) CGFloat originRatio; //原比例

@end

@implementation QVVideoEditContentView {
    NSString *filePath;
}

- (CGSize)playSize {
    if (0 == _playSize.width) {
        _playSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - safeAreaTop() - VIDEOEDITTOOLBARDEFAULTHEIGHT - 54);
    }
    return _playSize;
}

- (instancetype)init {
    if (self = [super init]) {
        self.runTaskFinishRefresh = NO;
        [self addObserver];
        [self initPlayConfig];
        [self initUI];
    }
    return self;
}

- (void)addObserver {
    @weakify(self)
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskFinishDispatchMain block:^(id  _Nonnull obj) {
        @strongify(self)
        if ([obj isKindOfClass:[XYBaseEffectAudioTask class]]) {
            [self stopPlay];
            [self.editorPlayerView seekToPosition:0 async:NO];
            [self.editorPlayerView play];
            self.isPlaying = YES;
            self.playButton.selected = YES;
        }
//        [SVProgressHUD dismiss];
        if (self.runTaskFinishRefresh) {
            self.runTaskFinishRefresh = NO;
            [self refreshUI];
            [self refreshVideoTrimDuration];
        }
    }];
}

- (void)initUI {
    self.curSelectClipIndex = 0;
    @weakify(self)
    [self.videoEditToolbar defaultCreateToolbarClick:^(QVMediVideoEditToolbarType toolbarType, NSDictionary * _Nonnull toolbarTypeInfoDic, id  _Nonnull params, BOOL executionEvent) {
        @strongify(self)
        [self stopPlay];
        self.videoEditToolbarType = toolbarType;
        NSString *actionDetailName = toolbarTypeInfoDic[@"action"];
        self.toolbarEditActionName = actionDetailName;
        NSString *actionName = [NSString stringWithFormat:@"videoEditView_%@",actionDetailName];
        if (actionDetailName && actionDetailName.length && executionEvent) {
            SEL sel = NSSelectorFromString(actionName);
            if ([self canPerformAction:sel withSender:nil]) {
                IMP imp = [self methodForSelector:sel];
                ((id(*)(id, SEL, id))imp)(self, sel, params);
            }
        }
    }];
    
#pragma mark- select clip
    self.videoEditToolbar.selectClipActionBlock = ^(NSInteger curSelectIndex, BOOL autoRefresh) {
        if (autoRefresh) {
            @strongify(self)
            self.curSelectClipIndex = curSelectIndex;
            [QVMediToolbarManager manager].clipSeletedIdx = curSelectIndex;
            [self refreshVideoTrimDuration];
            [self stopPlay];
            XYClipModel *clipModel = [XYEngineWorkspace clipMgr].clipModels[curSelectIndex];
            [self.editorPlayerView seekToPosition:clipModel.destVeRange.dwPos async:NO];
        }
    };
    
#pragma mark- add clip
    self.videoEditToolbar.addClipActionBlock = ^(NSInteger curSelectIndex) {
        weak_self.runTaskFinishRefresh = YES;
        [weak_self.editorPlayerView pause];
        [[QVMediVideoEditManager sharedInstance] addClip:curSelectIndex finish:^{
//            [getCurrentViewController().navigationController popViewControllerAnimated:YES];
        }];
    };
#pragma mark- ---
    self.videoProgressSlider.minLabelString = @"00:00";
    [self refreshVideoTrimDuration];
    [self.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.exportButton addTarget:self action:@selector(exportAction) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setIsCardPoint:(BOOL)isCardPoint {
    _isCardPoint = isCardPoint;
    self.videoEditToolbar.hidden = isCardPoint;
}

- (void)refreshVideoTrimDuration {
    if (self.deleteClip && self.curSelectClipIndex > 0) {
        self.deleteClip = NO;
        self.curSelectClipIndex--;
    }
    if (![XYEngineWorkspace clipMgr].clipModels.count) {
        return;
    }
    switch (self.videoEditToolbarType) {
        case QVMediVideoEditToolbarTypeEdit: {
            [self refreshEditData];
            [self refreshUIWithClipModels];
        }
            break;
            
        case QVMediVideoEditToolbarTypeSubtitle:
            [self refreshSubtitleEditData];
            break;

    }
    [self refreshAll];
}

- (void)refreshEditData {
    // TODO: 刷新 XYVideoEditToolbarTypeEdit Value
    XYClipModel *clipModel = [XYEngineWorkspace clipMgr].clipModels[self.curSelectClipIndex];
    self.videoEditToolbar.volumeValue = clipModel.volumeValue;
    self.videoEditToolbar.voiceChangeValue = clipModel.voiceChangeValue;
    self.videoEditToolbar.voiceSpeedValue = clipModel.speedValue;
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:clipModel.adjustItems.count];
    [clipModel.adjustItems enumerateObjectsUsingBlock:^(XYAdjustItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [paramDic setObject:@{@"paramValue":@(obj.dwCurrentValue - 50),@"paramName":obj.nameLocale} forKey:obj.nameLocale];
    }];
    self.videoEditToolbar.parameterAdjustmentDic = paramDic;
}

- (void)refreshSubtitleEditData {
    // TODO: 刷新 XYVideoEditToolbarTypeSubtitle Value
}

- (void)refreshAll {
    XYClipModel *clipModel = [XYEngineWorkspace clipMgr].clipModels[self.curSelectClipIndex];
    self.videoEditToolbar.videoTotalDuration = clipModel.destVeRange.dwLen;
}

- (void)initPlayConfig {
    XYTemplateItemData *itemData = [[XYTemplateDataMgr sharedInstance] getByID:TEMPLATE_DEFAULT_TRANSITION];
    NSString *d = itemData.strPath;
    @weakify(self)
    [self.editorPlayerView refreshWithConfig:^XYPlayerViewConfiguration *(XYPlayerViewConfiguration *config) {
        @strongify(self)
        config = [XYPlayerViewConfiguration currentStoryboardSourceConfig];
        config.videoRatio = [XYEngineWorkspace stordboardMgr].currentStbModel.ratioValue;
        self.videoProgressSlider.maxLabelString = [self getMMSSFromSS:config.totalDuration/1000];
        self.videoProgressSlider.maxValue = config.totalDuration/1000;
        return config;
    }];
    [self refreshUIWithClipModels];
    if ([XYEngineWorkspace clipMgr].clipModels.count <= 0) {
        [getCurrentViewController().navigationController popToRootViewControllerAnimated:NO];
    }
    self.originRatio = [XYEngineWorkspace stordboardMgr].currentStbModel.ratioValue;
}

- (void)refreshUIWithClipModels {
    NSMutableArray *clipThumbImageArray = [NSMutableArray arrayWithCapacity:[XYEngineWorkspace clipMgr].clipModels.count];
    @weakify(self)
    [[XYEngineWorkspace clipMgr].clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[XYVideoThumbnailManager manager] fetchThumbnailsWithThumbnailSize:CGSizeMake(60, 60) seekPosition:obj.destVeRange.dwPos block:^(UIImage * _Nonnull image) {
            [clipThumbImageArray addObject:image];
            if (clipThumbImageArray.count == [XYEngineWorkspace clipMgr].clipModels.count) {
                weak_self.videoEditToolbar.imageArray = clipThumbImageArray;
            }
        }];
    }];
}

- (void)refreshUI {
    if (self.videoProgressSlider.maxValue != [XYEngineWorkspace stordboardMgr].currentStbModel.videoDuration/1000) {
        self.videoProgressSlider.maxLabelString = [self getMMSSFromSS:[XYEngineWorkspace stordboardMgr].currentStbModel.videoDuration/1000];
        self.videoProgressSlider.maxValue = [XYEngineWorkspace stordboardMgr].currentStbModel.videoDuration/1000;
    }
}


#pragma mark- QVSliderDelegate
- (void)rangeSlider:(QVMediSlider *)sender didChangeSelectedValue:(float)selectedValue {
    self.videoProgressSlider.minLabelString = [self getMMSSFromSS:selectedValue];
    if (self.startTouchesSlider) {
        [self.editorPlayerView seekToPosition:[self sliderValueToRealSeekTime:selectedValue/sender.maxValue] async:NO];
    }
}

- (void)didEndTouchesInRangeSlider:(QVMediSlider *)sender {
    self.startTouchesSlider = NO;
}

- (void)didStartTouchesInRangeSlider:(QVMediSlider *)sender {
    self.startTouchesSlider = YES;
    [self stopPlay];
}

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
- (void)closeAction {
    //保存工程
    NSString *projectFolder = [NSString stringWithFormat:@"%@/public/project",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]];
    [NSFileManager qvmedi_createFolderWithPath:projectFolder];
    
    NSString *projectFileName = @"video.prj";
    NSString *projectFileFullPath = [NSString stringWithFormat:@"%@/%@",projectFolder, projectFileName];
    [self stopPlay];
    XYQprojectModel *project = [XYEngineWorkspace projectMgr].currentProjectModel;
    project.taskID = XYCommonEngineTaskIDQProjectSaveProject;
    project.prjFilePath = projectFileFullPath;
    [[XYEngineWorkspace projectMgr] runTask:project];
    
    [[XYEngineWorkspace projectMgr] addObserver:self observerID:XYCommonEngineTaskIDQProjectSaveProject block:^(id  _Nonnull obj) {
        [getCurrentViewController().navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)exportAction {
    UIView *maskView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.rootViewController.view.frame];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.9;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:maskView];
    [self.editorPlayerView pause];
    NSLog(@"导出");
    XYProjectExportConfiguration *config = [[XYProjectExportConfiguration alloc] init];
    if (self.isCardPoint) {
        config.projectType = XYProjectTypeSlideShow;
      }
    config.expType = XYEngineExportType480;
    config.fps = 37;
    config.bitRate = 1.0;
    NSString *exportFolder = [NSString stringWithFormat:@"%@/public",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]];
    [NSFileManager qvmedi_createFolderWithPath:exportFolder];
    
    NSString *exportFileName = @"video.mp4";
    NSString *exportFileFullPath = [NSString stringWithFormat:@"%@/%@",exportFolder, exportFileName];
    config.exportingFilePath = exportFileFullPath;
    [[XYEngineWorkspace exportMgr] exportWithConfig:config start:^{
        
    } progress:^(NSInteger currentTime, NSInteger totalTime) {
        [SVProgressHUD showProgress:currentTime / (CGFloat)totalTime status:[NSString stringWithFormat:@"%ds/%@%ds",currentTime / 1000, NSLocalizedString(@"mn_edit_total_time", @""),totalTime / 1000]];
    } success:^{
        [SVProgressHUD dismiss];
        [maskView removeFromSuperview];
//        [SVProgressHUD showInfoWithStatus:@"导出成功"];
        QVPlayerViewController *palyVC = [[QVPlayerViewController alloc] init];
        palyVC.fileUrl = exportFileFullPath;
        [getCurrentViewController().navigationController pushViewController:palyVC animated:YES];
    } failure:^(XYProjectExportResultType result, NSInteger errorCode) {
        [maskView removeFromSuperview];
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"mn_edit_tips_cannot_operate", @"")];
    }];
}


- (void)playAction:(UIButton *)target {
    self.isPlaying?[self stopPlay]:[self beginPlay];
}

- (void)beginPlay {
    if (self.playFinish) {
        self.playFinish = NO;
        XYClipModel *clipModel = [XYEngineWorkspace clipMgr].clipModels[self.curSelectClipIndex];
        [self.editorPlayerView seekToPosition:clipModel.destVeRange.dwPos async:NO];
//        [self.editorPlayerView seekToPosition:0 async:NO];
    }
    [self.editorPlayerView play];
    self.isPlaying = YES;
    self.playButton.selected = YES;
}

- (void)stopPlay {
    [self.editorPlayerView pause];
    self.isPlaying = NO;
    self.playButton.selected = NO;
}

- (void)playing {
     if (self.videoProgressSlider.selectedValue < self.videoProgressSlider.maxValue) {
        self.videoProgressSlider.selectedValue++;
    }else {
        self.videoProgressSlider.selectedValue = 0;
        [self stopPlay];
    }
}

#pragma mark- 修改比例
- (void)videoEditView_xy_videoEditToolbarTypeScaleAction:(id)params {
    [SVProgressHUD show];
    QVMediVideoEditScaleType scale = [[NSString stringWithFormat:@"%@",params] integerValue];
    CGFloat ratioValue;
    switch (scale) {
        case QVMediVideoEditScaleTypeDefault: {
            ratioValue = self.originRatio;
        }
            break;
        case QVMediVideoEditScaleType_1_1: {
            ratioValue = 1;
        }
            break;
        case QVMediVideoEditScaleType_3_4: {
            ratioValue = 3.0/4.0;
        }
            break;
    }
    
    XYStoryboardModel *sbModel = [XYEngineWorkspace stordboardMgr].currentStbModel;
    sbModel.taskID = XYCommonEngineTaskIDStoryboardRatio;
    sbModel.ratioValue = ratioValue;
    [[XYEngineWorkspace stordboardMgr] runTask:sbModel];
}



#pragma mark- 修剪
- (void)videoEditView_xy_videoEditToolbarTypeSubtitle_toobarTypeTrimAction:(NSDictionary *)params {
    [self videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeTrimAction:params];
}

- (void)videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeTrimAction:(NSDictionary *)params {
    [SVProgressHUD show];
    self.runTaskFinishRefresh = YES;
    NSLog(@"begin-->%@\n end-->%@",params[VideoTrimBeginDuration], params[VideoTrimEndDuration]);
    NSNumber *position = params[VideoTrimBeginDuration];
    NSNumber *endPosition = params[VideoTrimEndDuration];
    NSInteger length = [endPosition integerValue] - [position integerValue];
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:self.curSelectClipIndex];
    XYVeRangeModel *rangeModel = [[XYVeRangeModel alloc] init];
    rangeModel.dwPos = [position integerValue];
    rangeModel.dwLen  = length;
    clipModel.trimVeRange = rangeModel;
    clipModel.taskID = XYCommonEngineTaskIDClipTrim;
    [[XYEngineWorkspace clipMgr] runTask:clipModel];
    [[XYEngineWorkspace clipMgr] addObserver:self observerID:XYCommonEngineTaskIDClipTrim block:^(id  _Nonnull obj) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark- 分割
- (void)videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeSplitAction:(NSDictionary *)params {
    [SVProgressHUD show];
    self.runTaskFinishRefresh = YES;
    NSLog(@"cut-->%@",params[VideoCutDuration]);
    CGFloat seekPosition = [params[VideoCutDuration] floatValue];
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:self.curSelectClipIndex];
    clipModel.splitClipPostion = seekPosition;
    clipModel.taskID = XYCommonEngineTaskIDClipSplit;
    [[XYEngineWorkspace clipMgr] runTask:clipModel];
}

#pragma mark- 删除

- (void)videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeDeleteAction:(NSDictionary *)params  {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wformat"

    if ([XYEngineWorkspace clipMgr].clipModels.count == 1) {
        [SVProgressHUD showImage:nil status:NSLocalizedString(@"xiaoying_str_edit_clip_delete_toast", nil)];
        [SVProgressHUD dismissWithDelay:1.5f];
        return;
    }
    self.deleteClip = YES;
    [SVProgressHUD show];
    self.runTaskFinishRefresh = YES;
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:self.curSelectClipIndex];
    clipModel.taskID = XYCommonEngineTaskIDClipDelete;
    NSInteger seekPosition;
    if(clipModel.clipIndex < [[XYEngineWorkspace clipMgr] clipModels].count - 1) {
        seekPosition = clipModel.destVeRange.dwLen + clipModel.destVeRange.dwPos + 1;
    }
    else {
        seekPosition = clipModel.destVeRange.dwPos - 1;
    }
    clipModel.seekPositionNumber = [NSNumber numberWithInteger:seekPosition];
    [[XYEngineWorkspace clipMgr] runTask:clipModel];
    
    #pragma clang diagnostic pop
}

#pragma mark- 音量
- (void)videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeVolumeAction:(NSDictionary *)params {
    CGFloat videoVolumeValue = [params[VideoVolumeValue] floatValue];
    NSLog(@"videoVolumeValue--->%f",videoVolumeValue);
    [SVProgressHUD show];
    self.runTaskFinishRefresh = YES;
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:self.curSelectClipIndex];
    clipModel.taskID = XYCommonEngineTaskIDClipUpdateVolume;
    clipModel.volumeValue = videoVolumeValue;
    /// 如果当前为静音，关闭静音
    if (clipModel.isMute) {
    }
    [[XYEngineWorkspace clipMgr] runTask:clipModel];
}

#pragma mark- 变声
- (void)videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeVoiceChangeAction:(NSDictionary *)params  {
    CGFloat videoVoiceChangeValue = [params[VideoVoiceChangeValue] floatValue];
    NSLog(@"videoVoiceChangeValue--->%f",videoVoiceChangeValue);
    [SVProgressHUD show];
    self.runTaskFinishRefresh = YES;
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:self.curSelectClipIndex];
    clipModel.taskID = XYCommonEngineTaskIDClipVoiceChange;
    clipModel.voiceChangeValue = videoVoiceChangeValue;
    [[XYEngineWorkspace clipMgr] runTask:clipModel];
}

#pragma mark- 变速
- (void)videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeVariableSpeedAction:(NSDictionary *)params  {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wformat"

    CGFloat videoSpeedChangeValue = [params[VideoSpeedChangeValue] floatValue];
    NSLog(@"videoSpeedChangeValue--->%f",videoSpeedChangeValue);
    [SVProgressHUD show];
    self.runTaskFinishRefresh = YES;
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:self.curSelectClipIndex];
    if (clipModel.sourceVeRange.dwLen/videoSpeedChangeValue < 100) {//时间太短
        [SVProgressHUD showImage:nil status:NSLocalizedString(@"xiaoying_str_edit_clip_delete_toast", nil)];
        [SVProgressHUD dismissWithDelay:1.5f];
        return;
    }
    clipModel.taskID = XYCommonEngineTaskIDClipSpeed;
    clipModel.speedValue = videoSpeedChangeValue;
    clipModel.iskeepTone = NO;

    [[XYEngineWorkspace clipMgr] runTask:clipModel];
    
    #pragma clang diagnostic pop
}

#pragma mark- 参数调节
- (void)videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeParameterAdjustmentAction:(NSDictionary *)params {
    NSMutableDictionary *paramDic = params[VideoParameterAdjustment];
    NSLog(@"paramDic--->%@",paramDic);
    [SVProgressHUD show];
    self.runTaskFinishRefresh = YES;
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:self.curSelectClipIndex];
    [clipModel.adjustItems enumerateObjectsUsingBlock:^(XYAdjustItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *paramInfo = paramDic[obj.nameLocale];
        NSLog(@"%f",[paramInfo[@"paramValue"] floatValue]);
        obj.dwCurrentValue = [paramInfo[@"paramValue"] floatValue] + 50;
    }];
    clipModel.taskID = XYCommonEngineTaskIDClipAdjustUpdate;
    [[XYEngineWorkspace clipMgr] runTask:clipModel];

}

#pragma mark- 镜像
- (void)videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeMirrorAction:(NSDictionary *)params {
    [SVProgressHUD show];
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:self.curSelectClipIndex];
    if (XYClipMirrorModeNormal == clipModel.mirrorMode) {
          clipModel.mirrorMode = XYClipMirrorModeY;
    } else {
        clipModel.mirrorMode = XYClipMirrorModeNormal;
    }
    clipModel.taskID = XYCommonEngineTaskIDClipMirror;
    [[XYEngineWorkspace clipMgr] runTask:clipModel];
}

#pragma mark- 倒放
- (void)videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeReverseAction:(NSDictionary *)params {
    [SVProgressHUD show];
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:self.curSelectClipIndex];
    clipModel.taskID = XYCommonEngineTaskIDClipReverse;
    [[XYEngineWorkspace clipMgr] runTask:clipModel];
}

#pragma mark- 旋转
- (void)videoEditView_xy_videoEditToolbarTypeEdit_toobarTypeRotateAction:(NSDictionary *)params {
    [SVProgressHUD show];
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelObjectAtIndex:self.curSelectClipIndex];
    CGFloat angleValue = clipModel.clipPropertyData.angleZ;
    if (angleValue < 360) {
        angleValue += 90;
    }else {
        angleValue = 90;
    }
    clipModel.clipPropertyData.angleZ = angleValue;
    clipModel.taskID = XYCommonEngineTaskIDClipGestureRotation;
    [[XYEngineWorkspace clipMgr] runTask:clipModel];
}

#pragma mark- 水印
- (void)videoEditView_xy_videoEditToolbarTypeWatermarkAction:(id)params {
    void (^getSpecialEffectsLogoBlock)(QVMediAlbumMediaItem *mediaInfo) = params;
    [self.editorPlayerView pause];
    [[QVMediVideoEditManager sharedInstance] selectImageFinish:^(QVMediAlbumMediaItem * _Nonnull mediaItem) {
        if (getSpecialEffectsLogoBlock) {
            getSpecialEffectsLogoBlock(mediaItem);
        }
        if (self.videoEditToolbar.isUpdate && [[XYEngineWorkspace effectMgr] effectModels:(XYCommonEngineGroupIDWatermark)].count > 0) {
            return;
        }
        XYEffectVisionModel *model = [[XYEffectVisionModel alloc]init];
        model.taskID = XYCommonEngineTaskIDEffectVisionAdd;
        model.filePath = mediaItem.filePath;
        model.groupID =  XYCommonEngineGroupIDWatermark;
        
        CGFloat playViewWidth = self.editorPlayerView.streamSize.width;
        CGFloat playViewHeight = self.editorPlayerView.streamSize.height;
        CGFloat pixelWidth = mediaItem.pixelWidth;
        CGFloat pixelHeight = mediaItem.pixelHeight;
                              
        CGFloat waterWidth = playViewWidth*0.15;
        CGFloat waterHeight = (waterWidth/pixelWidth)*pixelHeight;
        
        CGFloat shortWidth;
        shortWidth = playViewHeight;
               
        CGFloat centerX = playViewWidth - shortWidth*0.04 - waterWidth/2;
        CGFloat centerY = playViewHeight - shortWidth*0.04 - waterHeight/2;
        
        XYVeRangeModel *range = [[XYVeRangeModel alloc]init];
        range.dwPos = 0;
        range.dwLen = [XYEngineWorkspace clipMgr].clipsTotalDuration;
        model.destVeRange = range;
        model.width = waterWidth;
        model.height = waterHeight;
        model.centerPoint = CGPointMake(centerX, centerY);
        model.userDataModel.defaultCenterX = centerX;
        model.userDataModel.defaultCenterY = centerY;
        model.alpha = 1;
        [[XYEngineWorkspace effectMgr] runTask:model];
    }];
}

#pragma mark- 马赛克
- (void)videoEditView_xy_videoEditToolbarTypeMosaicAction:(id)params {
    NSLog(@"params--->%@",params);
    [self.editorPlayerView pause];
    [[QVMediVideoEditManager sharedInstance] selectImageFinish:^(QVMediAlbumMediaItem * _Nonnull mediaItem) {
        XYEffectVisionModel *visionModel = [[XYEffectVisionModel alloc] init];
        visionModel.groupID = XYCommonEngineGroupIDMosaic;
        visionModel.taskID = XYCommonEngineTaskIDEffectVisionAdd;
        XYVeRangeModel *veRangeModel = [XYVeRangeModel VeRangeModelWithPosition:0 length:[XYEngineWorkspace clipMgr].clipsTotalDuration];
        visionModel.filePath = mediaItem.filePath;
        visionModel.destVeRange = veRangeModel;
        visionModel.propData = 0.5;
        [[XYEngineWorkspace effectMgr] runTask:visionModel];
    }];
}

#pragma mark- 画中画
- (void)videoEditView_xy_videoEditToolbarTypePictureInPictureAction:(id)params {
    NSLog(@"params--->%@",params);
    void (^getSpecialEffectsLogoBlock)(QVMediAlbumMediaItem *mediaInfo) = params;
    [self.editorPlayerView pause];
    [[QVMediVideoEditManager sharedInstance] selectOneVideoFinish:^(QVMediAlbumMediaItem * _Nonnull mediaInfo) {
        if (getSpecialEffectsLogoBlock) {
            getSpecialEffectsLogoBlock(mediaInfo);
        }
    }];
}

#pragma mark- 特效
- (void)videoEditView_xy_videoEditToolbarTypeSpecialEffectsAction:(id)params {
    void (^getSpecialEffectsLogoBlock)(NSArray <NSDictionary *> *, void (^)(NSDictionary *)) = params;
    @weakify(self)
    void (^selectChangeBlock)(NSDictionary *) = ^(NSDictionary *infoDic){
        @strongify(self)
        [self stopPlay];
        UInt64 templateID;
        BOOL isDelete = NO;
        XYCommonEngineTaskID taskID = XYCommonEngineTaskIDEffectVisionAdd;
        NSInteger index = [infoDic[@"index"] integerValue];
        if (index > 0 && index <= [self getDefaultTemplateCodeList].count) {
            index = index - 1;
            NSString *tid = [[self getDefaultTemplateCodeList] objectAtIndex:index];
            templateID = [self xy_getLongLongFromString:tid];
        } else if ([self getDefaultTemplateCodeList].count > 0) {
            isDelete = YES;
        } else {
            return;
        }
        XYTemplateItemData *item = [[XYTemplateDataMgr sharedInstance] getByID:templateID];

        XYEffectVisionModel *visionModel = [XYEffectVisionModel new];
        visionModel.taskID = taskID;
        if ([[XYEngineWorkspace effectMgr] effectModels:(XYCommonEngineGroupIDAnimatedFrame)].count > 0) {
            visionModel = [[[XYEngineWorkspace effectMgr] effectModels:(XYCommonEngineGroupIDAnimatedFrame)] firstObject];
            if (isDelete) {
                visionModel.taskID = XYCommonEngineTaskIDEffectVisionDelete;
            } else {
                visionModel.taskID = XYCommonEngineTaskIDEffectVisionUpdate;
            }
        }
        visionModel.groupID = XYCommonEngineGroupIDAnimatedFrame;
        visionModel.filePath = item.strPath;
        visionModel.isStaticPicture = NO;
        if (!visionModel.userDataModel) {
            visionModel.userDataModel = [XYEffectUserDataModel new];
        }
        visionModel.userDataModel.thumbnailUrl = item.strLogo;
        NSInteger beginTime = self.editorPlayerView.playerConfig.seekPosition;
        NSInteger length = self.editorPlayerView.playerConfig.totalDuration;
        if (beginTime >= length) {
            beginTime = 0;
        }
        visionModel.destVeRange = [XYVeRangeModel VeRangeModelWithPosition:0 length:length];
        [[XYEngineWorkspace effectMgr] runTask:visionModel];
    };
    if (getSpecialEffectsLogoBlock) {
        getSpecialEffectsLogoBlock([self getDefaultTemplateImageList],selectChangeBlock);
    }
}


#pragma mark- 主题
- (void)videoEditView_xy_videoEditToolbarTypeThemeAction:(id)params {
    void (^getTemeLogoBlock)(NSArray <NSDictionary *> *, void (^)(NSDictionary *)) = params;
    @weakify(self)
    void (^selectChangeBlock)(NSDictionary *) = ^(NSDictionary *infoDic){
        @strongify(self)
        [self stopPlay];
        NSInteger index = [infoDic[@"index"] integerValue];
        UInt64 templateID;
        if (0 == index) {
            templateID = QVET_THEME_NONE_TEMPLATE_ID;
        } else {
          NSString *tid = [[self getDefaultTemplateCodeList] objectAtIndex:--index];
            templateID = [self xy_getLongLongFromString:tid];
        }
        XYTemplateItemData *item = [[XYTemplateDataMgr sharedInstance] getByID:templateID];

        MSIZE themeMSize = [[XYTemplateDataMgr sharedInstance] getThemeInnerBestSize:templateID];
        XYStoryboardModel *sbModel = [XYEngineWorkspace stordboardMgr].currentStbModel;
        CGFloat width = [XYEngineWorkspace outPutResolutionWidth];
        if (themeMSize.cy <= 0 && TEMPLATE_DEFAULT_THEME != templateID) {
            themeMSize.cx = width;
            themeMSize.cy = width / (16 / 9.0);
        }
        BOOL isThemeApplied = templateID > 0x100000000000000;
        MPOINT outSize = [XYCommonEngineRequest requestStoryboardSizeWithInputWidth:width inputScale:themeMSize isPhotoMV:NO isAppliedEffects:isThemeApplied];
        if (outSize.y > 0) {
            CGFloat height = (CGFloat)outSize.y;
            sbModel.ratioValue = outSize.x / height;
        }
        sbModel.isAutoplay = NO;
        sbModel.seekPositionNumber = @(0);
        sbModel.taskID = XYCommonEngineTaskIDStoryboardAddTheme;
        sbModel.themePath = item.strPath;
        [[XYEngineWorkspace stordboardMgr] runTask:sbModel];
    };
    if (getTemeLogoBlock) {
        getTemeLogoBlock([self getDefaultTemplateImageList],selectChangeBlock);
    }
    [[XYEngineWorkspace stordboardMgr] addObserver:self observerID:XYCommonEngineTaskIDStoryboardAddTheme block:^(id  _Nonnull obj) {
        XYStoryboardModel *storyboardModel = [XYEngineWorkspace stordboardMgr].currentStbModel;

        [storyboardModel.themeTextList enumerateObjectsUsingBlock:^(TextInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.text = @"修改字幕";
        }];
        [XYEngineWorkspace stordboardMgr].currentStbModel.taskID = XYCommonEngineTaskIDStoryboardUpdateThemeText;
        [[XYEngineWorkspace stordboardMgr] runTask:storyboardModel];
        
        
        [SVProgressHUD dismiss];
    }];
}

#pragma mark- 音频
- (void)videoEditView_xy_videoEditToolbarTypeAudioAction:(id)params {
    void (^getTemeLogoBlock)(NSArray <NSDictionary *> *, void (^)(NSDictionary *)) = params;
    NSArray *dataArray = @[@{@"icon":@"xiashan_icon",@"title":@"下山",@"path":@"kJQEAF3t8saAFZfRACp_ieCrn2g443"}];
    NSLog(@"params--->%@",params);
    @weakify(self)
    void (^selectChangeBlock)(NSDictionary *) = ^(NSDictionary *infoDic){
        @strongify(self)
        VideoEditToolbarTypeAudioType editType = [infoDic[@"type"] integerValue];
        switch (editType) {
            case VideoEditToolbarTypeAudioTypeSong:
            case VideoEditToolbarTypeAudioTypeSoundEffects: {
                [self videoEditToolbarTypeAudioTypeSongAndSoundEffects:infoDic];
            }
                break;
            case VideoEditToolbarTypeAudioTypeRrecording: {
                NSLog(@"开始录音");
                [self startRecord];
            }
                break;
           default:
                [self stopRecord:editType];
                break;
        }
    };
    if (getTemeLogoBlock) {
        getTemeLogoBlock(dataArray,selectChangeBlock);
    }
}

- (void)startRecord {
    AVAudioSession *session =[AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        NSLog(@"Error creating session: %@",[sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    self.session = session;
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [path stringByAppendingString:@"/1111RRecord.aac"];
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
    //设置参数
    NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    [setting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [setting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [setting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];

    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:setting error:nil];
    _recorder.delegate = self;
    if (_recorder) {
        [_recorder prepareToRecord];
        [_recorder record];
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
        
    }
}

- (void)stopRecord:(NSInteger)recordTime {
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    //需要设置 不然播放器声音会异常
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];

NSFileManager *manager = [NSFileManager defaultManager];
  if ([manager fileExistsAtPath:filePath]){
      
      XYEffectAudioModel *effectModel = [[XYEffectAudioModel alloc] init];
      effectModel.taskID = XYCommonEngineTaskIDEffectAudioAdd;
      effectModel.groupID = XYCommonEngineGroupIDRecord;
      effectModel.title = @"录音";
      effectModel.filePath = filePath;

      XYVeRangeModel *sourceVeRange = [XYVeRangeModel VeRangeModelWithPosition:0 length:5000];
      effectModel.sourceVeRange = sourceVeRange;

      XYVeRangeModel *trimVeRange = [XYVeRangeModel VeRangeModelWithPosition:0 length:5000];
      effectModel.trimVeRange = trimVeRange;

      NSInteger dwPos = 0;
      NSInteger dwLen = 5000;
      XYVeRangeModel *destVeRange = [XYVeRangeModel VeRangeModelWithPosition:dwPos length:dwLen];
      effectModel.destVeRange = destVeRange;

      [[XYEngineWorkspace effectMgr] runTask:effectModel];
  }
}

- (void)videoEditToolbarTypeAudioTypeSongAndSoundEffects:(NSDictionary *)infoDic {
    NSDictionary *dataInfoDic = infoDic[@"dataInfo"];
    VideoEditToolbarTypeAudioType editType = [infoDic[@"type"] integerValue];
    BOOL isNoneItem = [dataInfoDic[@"index"] integerValue] == 0;
    XYCommonEngineTaskID taskID;
    NSArray *bgmEffectModels;
    XYCommonEngineGroupID groupID;
    NSString *pathString = [[NSBundle mainBundle] pathForResource:dataInfoDic[@"info"][@"path"] ofType:@"mp3"];

    if (editType == VideoEditToolbarTypeAudioTypeSong) {
        groupID = XYCommonEngineGroupIDBgmMusic;
        bgmEffectModels = [[XYEngineWorkspace effectMgr] fetchEffectModel:groupID filePath:pathString];
    taskID = (isNoneItem) ? XYCommonEngineTaskIDEffectAudioDelete : XYCommonEngineTaskIDEffectAudioAdd;
    }else if(editType == VideoEditToolbarTypeAudioTypeSoundEffects) {
        groupID = XYCommonEngineGroupIDDubbing;
        bgmEffectModels = [[XYEngineWorkspace effectMgr] fetchEffectModel:groupID filePath:pathString];
        taskID = (isNoneItem) ? XYCommonEngineTaskIDEffectAudioDelete : XYCommonEngineTaskIDEffectAudioAdd;
    }
    
     XYEffectAudioModel *effectModel = [[XYEffectAudioModel alloc] init];
     effectModel.isAutoplay = NO;
     effectModel.taskID = taskID;
     effectModel.groupID = groupID;
     effectModel.title = dataInfoDic[@"info"][@"title"];
     effectModel.filePath = pathString;
     effectModel.isAddedByTheme = NO;
    
    
    
     XYVeRangeModel *sourceVeRange = [XYVeRangeModel VeRangeModelWithPosition:0 length:174000];
     effectModel.sourceVeRange = sourceVeRange;
     NSInteger trimStartPos = 0;
     NSInteger trimLength = 174000;
         
     XYVeRangeModel *trimVeRange = [XYVeRangeModel VeRangeModelWithPosition:trimStartPos length:trimLength];
         effectModel.trimVeRange = trimVeRange;
         NSInteger dwPos = 0;
         NSInteger dwLen = [XYEngineWorkspace stordboardMgr].currentStbModel.videoDuration;
         XYVeRangeModel *destVeRange = [XYVeRangeModel VeRangeModelWithPosition:dwPos length:dwLen];
         effectModel.isRepeatON = YES;
         effectModel.destVeRange = destVeRange;
     [[XYEngineWorkspace effectMgr] runTask:effectModel];
}

#pragma mark - 播放器的回调
- (void)playbackStateCallBack:(XYPlayerCallBackData *)playbackData {
    if ((playbackData.state == XYPlayerStatePaused
    || playbackData.state == XYPlayerStateStopped)) {
        [self stopPlay];
        if (playbackData.duration == playbackData.position) {
            self.playFinish = YES;
        }
    }
    if (!self.startTouchesSlider) {
        self.videoProgressSlider.selectedValue = playbackData.position/1000;
    }
}

//进度条值转换成引擎底层时间毫秒数
- (MDWord)sliderValueToRealSeekTime:(float)sliderValue {
    MDWord dwPos = (unsigned int)self.editorPlayerView.playerConfig.playbackRange.dwPos;
    MDWord dwLen = (unsigned int)self.editorPlayerView.playerConfig.playbackRange.dwLen;
    MDWord seekTime = dwPos+sliderValue*dwLen;
    return seekTime;
}


#pragma mark- lazy get set

- (XYPlayerView *)editorPlayerView {
    if (!_editorPlayerView) {
        CGFloat height = self.playSize.height;
        _editorPlayerView = [[XYPlayerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_editorPlayerView addPlayDelegate:self];
        _editorPlayerView.backgroundColor = [UIColor blackColor];
        [self addSubview:_editorPlayerView];
        [_editorPlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(20);
            make.width.equalTo(@(self.playSize.width));
            make.height.offset(height);
            make.top.offset(0);
        }];
    }
    return _editorPlayerView;
}



- (QVMediVideoEditToolbar *)videoEditToolbar {
    if (!_videoEditToolbar) {
        _videoEditToolbar = [[QVMediVideoEditToolbar alloc] init];
        [self addSubview:_videoEditToolbar];
        [_videoEditToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.offset(VIDEOEDITTOOLBARDEFAULTHEIGHT);
        }];
    }
    return _videoEditToolbar;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton new];
        [_closeButton setImage:[UIImage QVMediEditImageNamed:@"qvmedi_preview_icon_close_white"] forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.offset(20);
            make.width.height.offset(28);
        }];
    }
    return _closeButton;
}

- (UIButton *)exportButton {
    if (!_exportButton) {
        _exportButton = [[UIButton alloc] init];
        [_exportButton setTitle:NSLocalizedString(@"mn_edit_title_export", @"") forState:UIControlStateNormal];
        _exportButton.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _exportButton.backgroundColor = [UIColor qvmedi_colorWithHEX:0xF94141];
        _exportButton.layer.cornerRadius = 4;
        [self addSubview:_exportButton];
        [_exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.closeButton);
            make.right.offset(-20);
            make.width.offset(50);
            make.height.offset(26);
        }];
    }
    return _exportButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:[UIImage QVMediEditImageNamed:@"qvmedi_video_edit_play_icon"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage QVMediEditImageNamed:@"qvmedi_video_edit_stop_play_icon"] forState:UIControlStateSelected];
        [self addSubview:_playButton];
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.videoEditToolbar.mas_top).offset(-17);
            make.left.offset(34);
        }];
    }
    return _playButton;
}

- (QVMediSlider *)videoProgressSlider {
    if (!_videoProgressSlider) {
        _videoProgressSlider = [[QVMediSlider alloc] initWithMinValue:0 maxValue:0 selectValue:0];
        _videoProgressSlider.delegate = self;
        _videoProgressSlider.qvmedi_parameter = @(0);
        _videoProgressSlider.handleColor = UIColor.whiteColor;
        _videoProgressSlider.hideMinMaxValueLabel = NO;
        _videoProgressSlider.curValueLabelFont = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
        _videoProgressSlider.hideCurValueLabel = YES;
        _videoProgressSlider.tintColorBetweenHandles = UIColor.whiteColor;
        _videoProgressSlider.autoChangeTitleLabelW = NO;
        [self addSubview:_videoProgressSlider];
        [_videoProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.playButton);
            make.left.mas_equalTo(self.playButton.mas_right).offset(12);
            make.right.offset(-34);
            make.height.offset(30);
        }];
    }
    return _videoProgressSlider;
}

- (NSArray <NSString *> *)getDefaultTemplateCodeList {
    NSAssert(self.toolbarEditActionName && self.toolbarEditActionName.length, @"❌ toolbarEditActionName must Available string!");
    return self.defaultTemplateCodeListDic[self.toolbarEditActionName];
}

- (NSArray<NSDictionary *> *)getDefaultTemplateImageList {
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:[self getDefaultTemplateCodeList].count];
    for (NSString *tid in [self getDefaultTemplateCodeList]) {
        UInt64 templateID = [self xy_getLongLongFromString:tid];
        XYTemplateItemData *item = [[XYTemplateDataMgr sharedInstance] getByID:templateID];
        NSString *title = [[XYTemplateDataMgr sharedInstance] getTitle:item];
        UIImage *logoImage = [[XYTemplateDataMgr sharedInstance] getTemplateLogoImage:item];
        [imageArray addObject:@{@"icon":logoImage,@"title":title}];
    }
    return imageArray;
}

- (unsigned long long)xy_getLongLongFromString:(NSString *)strLongLong {
    NSScanner *scanner = [NSScanner scannerWithString:strLongLong];
    unsigned long long longlongTtid = 0;
    [scanner scanHexLongLong:&longlongTtid];
    return longlongTtid;
}

- (NSDictionary *)defaultTemplateCodeListDic {
    if (!_defaultTemplateCodeListDic) {
        _defaultTemplateCodeListDic = [QVMediToolbarTool getTemplateDic];
    }
    return _defaultTemplateCodeListDic;
}

- (void)dealloc {
    NSLog(@"QVVideoEditContentView dealloc");
    [XYEngineWorkspace removeObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskFinishDispatchMain];
    [XYEngineWorkspace cleanAllData];
    [[QVMediVideoEditManager sharedInstance] removeObserver];
}

@end

