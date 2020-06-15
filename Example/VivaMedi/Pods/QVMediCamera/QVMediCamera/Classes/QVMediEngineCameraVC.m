//
//  QVMediEngineCameraVC.m
//  QVMediMediCamera
//
//  Created by 徐新元 on 2020/4/16.
//

#import "QVMediEngineCameraVC.h"
#import <QVMediCameraKit/QVMediCameraDevice.h>
#import <QVMediCameraKit/QVMediCameraPreviewView.h>
#import <QVMediCameraEngine/QVMediCameraEngine.h>
#import <QVMediCameraEngine/QVMediCameraEnginePreviewView.h>
#import <XYTemplateDataMgr/XYTemplateDataMgr.h>
#import <QVMediToolbarKit/QVMediCameraToolbar.h>
#import <QVMediToolbarKit/QVMediToolbarManager.h>
#import <XYCategory/XYCategory.h>
#import <XYCommonEngineKit/XYCommonEngineKit.h>
#import "UIImage+QVMediCamera.h"
#import <Masonry/Masonry.h>

@interface QVMediEngineCameraVC () <QVMediCameraEngineProtocol>

//Camera全屏预览view
@property (nonatomic, strong) QVMediCameraEnginePreviewView *fullSceenPreviewView;
//Camera工具栏
@property (nonatomic, strong) QVMediCameraToolbar *toolbar;
//Camera录制按钮
@property (nonatomic, strong) UIButton *recordBtn;
//Camera拍照按钮
@property (nonatomic, strong) UIButton *captureBtn;
//完成按钮
@property (nonatomic, strong) UIButton *finishBtn;
//退出按钮
@property (nonatomic, strong) UIButton *exitBtn;
//删除镜头按钮
@property (nonatomic, strong) UIButton *deleteBtn;
//选择音乐按钮
@property (nonatomic, strong) UIButton *musicSelectBtn;
//录制时长Label
@property (nonatomic, strong) UILabel *durationLabel;

//系统Camera相关管理类
@property (nonatomic, strong) QVMediCameraDevice *cameraDevice;
//Camera引擎相关管理类
@property (nonatomic, strong) QVMediCameraEngine *cameraEngine;
//Camera引擎相关当前状态
@property (nonatomic, strong) QVMediCameraEngineStateModel *cameraEngineStateModel;
//录制出来的文件保存路径
@property (nonatomic, copy) NSString *videoClipFilePath;
//当前Zoom值
@property (nonatomic, assign) CGFloat currentZoomScale;
//最后一次Zoom值
@property (nonatomic, assign) CGFloat lastZoomScale;
//XYAudioPlayer
@property (nonatomic, strong) XYAudioPlayer *audioPlayer;

@end

@implementation QVMediEngineCameraVC

#pragma mark - VC生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self layoutUI];
    [self initCameraDevice];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
//    [self layoutUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self initCameraEngine];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraDevice startSession];//启动CameraSession，成功后可看到画面
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)dealloc {
    NSLog(@"XYEngineCameraVC dealloc");
    [_cameraEngine uninitCameraEngine];
    [[XYEngineWorkspace clipMgr] removeObserver:self observerID:XYCommonEngineTaskIDClipAddClip];
    [[XYEngineWorkspace projectMgr] removeObserver:self observerID:XYCommonEngineTaskIDQProjectCreate];
}

#pragma mark - UI初始化
- (void)initUI {
    [self.view addSubview:self.fullSceenPreviewView];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.captureBtn];
    [self.view addSubview:self.finishBtn];
    [self.view addSubview:self.exitBtn];
    [self.view addSubview:self.deleteBtn];
    [self.view addSubview:self.musicSelectBtn];
    [self.view addSubview:self.durationLabel];
}

- (void)layoutUI {
    [self.fullSceenPreviewView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];

    [self.toolbar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        } else {
            make.top.equalTo(self.view.mas_top).offset(50);
        }
    }];
    
    [self.recordBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(68);
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        }
    }];
    
    [self.captureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(67);
        make.centerY.equalTo(self.recordBtn);
        make.left.equalTo(self.view).offset(20);
    }];
    
    [self.finishBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(56);
        make.right.equalTo(self.view).offset(-20);
        make.centerY.equalTo(self.recordBtn);
    }];
    
    [self.exitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.left.equalTo(self.view).offset(20);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view).offset(20);
        }
    }];
    
    [self.deleteBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(31);
        make.height.mas_equalTo(30);
        make.left.greaterThanOrEqualTo(self.captureBtn.mas_right).offset(8).priorityHigh();
        make.right.equalTo(self.recordBtn.mas_left).offset(-100).priorityMedium();
        make.centerY.equalTo(self.recordBtn);
    }];
    
    [self.musicSelectBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.musicSelectBtn.width + 50);
        make.height.mas_equalTo(28);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.exitBtn);
    }];
    
    [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(16);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.recordBtn.mas_top).offset(-20);
    }];
}

#pragma mark - 初始化CameraDevice
- (void)initCameraDevice {
    if (self.cameraDevice) {
        return;
    }
    self.cameraDevice = [QVMediCameraDevice new];
    
    [self.cameraDevice initCameraDeviceWithParamMaker:^(QVMediCameraDeviceParamMaker * _Nonnull paramMaker) {
        paramMaker.captureSessionPreset(AVCaptureSessionPreset1280x720);//设置分辨率
        paramMaker.devicePosition(AVCaptureDevicePositionBack);//设置初始镜头方向
    }];
}

#pragma mark - 初始化CameraEngine
- (void)initCameraEngine {
    if (self.cameraEngine) {
        return;
    }
    self.cameraEngine = [QVMediCameraEngine new];
    
    NSString *licensePath = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"txt"];
    
    [self.cameraEngine initCameraEngineWithParamMaker:^(QVMediCameraEngineParamMaker * _Nonnull paramMaker) {
        paramMaker.cXiaoYingEngine([[XYEngine sharedXYEngine] getCXiaoYingEngine]);//传入CXiaoYingEngine
        paramMaker.enableMetal(YES);//是否启用Metal
        paramMaker.previewView(self.fullSceenPreviewView);//预览用的view
        paramMaker.inputResolutionSize(CGSizeMake(1280, 720)).outputResolutionSize(CGSizeMake(1280, 720));//设置输入输入的分辨率
        paramMaker.renderRegionRect(self.fullSceenPreviewView.bounds);//用于在预览view上渲染的区域
        paramMaker.deviceOrientation(UIDeviceOrientationPortrait);//设备方向
        paramMaker.templateAdapter([XYTemplateDataMgr sharedInstance]);//用于处理模版相关的回调
        paramMaker.fbTemplateFilepath([[XYTemplateDataMgr sharedInstance] getByID:0x4400000000180001].strPath);//美颜模版的路径
        paramMaker.fbTemplateID(0x4400000000180001);//美颜模版的ID
        paramMaker.licensePath(licensePath);//License路径
    }];
    self.cameraDevice.cameraDeviceDelegate = self.cameraEngine;//SampleBuffer的delegate由CameraEngine来处理
    self.cameraEngine.cameraEngineDelegate = self;//CameraEngine的回调处理
}

#pragma mark - CameraEngine的状态回调
- (void)onCameraEngineStateUpdate:(QVMediCameraEngineStateModel *)stateModel {
    self.cameraEngineStateModel = stateModel;
    [self updateDurationLabelWithStateModel:stateModel];
    [self updateRecordBtnWithStateModel:stateModel];
}

#pragma mark - 更新UI
- (void)updateDurationLabelWithStateModel:(QVMediCameraEngineStateModel *)stateModel {
    NSInteger totalMilliseconds = stateModel.totalDuration;
    long long milliseconds = (totalMilliseconds % 1000 )/100;
    long long seconds = totalMilliseconds / 1000 % 60;
    long long minutes = (totalMilliseconds / 1000 / 60) % 60;
    NSString *text = [NSString stringWithFormat:@"%01lli:%02lli.%01lli", minutes, seconds, milliseconds];
    self.durationLabel.text = text;
    self.finishBtn.hidden = (totalMilliseconds == 0);
}

- (void)updateRecordBtnWithStateModel:(QVMediCameraEngineStateModel *)stateModel {
    if (stateModel.recordState == QVMediCameraEngineRecordStateRecording) {
        UIImage *image = [UIImage QVMediCameraImageNamed:@"medi_camera_stop_record_btn"];
        [self.recordBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.recordBtn setTitle:nil forState:UIControlStateNormal];
        self.deleteBtn.hidden = YES;
        self.musicSelectBtn.hidden = YES;
        self.toolbar.hidden = YES;
    } else {
        UIImage *image = [UIImage QVMediCameraImageNamed:@"medi_camera_start_record_btn"];
        [self.recordBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.recordBtn setTitle:[@([self.cameraEngine.cameraClipModels count]) stringValue] forState:UIControlStateNormal];
        self.deleteBtn.hidden = NO;
        self.musicSelectBtn.hidden = NO;
        self.toolbar.hidden = NO;
    }
}

#pragma mark - 点击录制按钮
- (void)onRecordBtnClick {
    if (self.cameraEngine.stateModel.recordState == QVMediCameraEngineRecordStateRecording) {
        [self.audioPlayer pause];
        [self.cameraEngine pauseRecord];
    } else if (self.cameraEngine.stateModel.recordState == QVMediCameraEngineRecordStatePausing) {
        [self.audioPlayer seek:self.cameraEngineStateModel.totalDuration];
        [self.cameraEngine resumeRecord];
    } else {
        [self.audioPlayer seek:self.cameraEngineStateModel.totalDuration];
        [self.cameraEngine startRecordWithParamMaker:^(QVMediCameraRecordParamMaker * _Nonnull paramMaker) {
            paramMaker.clipFilePath(self.videoClipFilePath);//录制文件保存路径
            paramMaker.hasAudioTrack(YES);//录制文件是否包含音轨
            paramMaker.PCMSampleRate(44100);//音频采样率
            paramMaker.PCMChannels(2);//音频声道数
            paramMaker.maxFrameRate(30);//最大帧率
        }];
    }
}

#pragma mark - 点击拍照按钮
- (void)onCaptureBtnClick {
    [self.cameraEngine captureWithFilePath:[self imageClipFilePath] isOriginal:YES];
}

#pragma mark - 点击完成按钮
- (void)onFinishBtnClick {
    [self.audioPlayer pause];
    [self.cameraEngine stopRecord];
    if ([XYEngineWorkspace clipMgr].clipModels.count > 0) {
        NSInteger index = [XYEngineWorkspace clipMgr].clipModels.count;
        [self insertClips:self.cameraEngine.cameraClipModels index:index];
    } else {
        XYQprojectModel *newProject = [[XYQprojectModel alloc] init];
        newProject.taskID = XYCommonEngineTaskIDQProjectCreate;
        [[XYEngineWorkspace projectMgr] runTask:newProject];
        __weak typeof(self) weakSelf = self;
        [[XYEngineWorkspace projectMgr] addObserver:self observerID:XYCommonEngineTaskIDQProjectCreate block:^(id  _Nonnull obj) {
            [weakSelf insertClips:weakSelf.cameraEngine.cameraClipModels index:0];
        }];
    }
}

- (void)insertClips:(NSArray<QVMediCameraClipModel *> *)cameraClipModels index:(NSInteger)index {
    NSMutableArray<XYClipModel *> *clipModels = [NSMutableArray array];
    [cameraClipModels enumerateObjectsUsingBlock:^(QVMediCameraClipModel * _Nonnull cameraClipModel, NSUInteger idx, BOOL * _Nonnull stop) {
        XYClipModel *clipModel = [[XYClipModel alloc] init];
        clipModel.sourceVeRange.dwPos = cameraClipModel.startPos;
        clipModel.sourceVeRange.dwLen = cameraClipModel.endPos - cameraClipModel.startPos;
        clipModel.clipFilePath = cameraClipModel.clipFilePath;
        clipModel.rotation = cameraClipModel.rotation;
        clipModel.clipIndex = index + idx;
        [clipModels addObject:clipModel];
    }];
    
    XYClipModel *taskModel = [[XYClipModel alloc] init];
    taskModel.taskID = XYCommonEngineTaskIDClipAddClip;
    taskModel.clipModels = clipModels;
    [[XYEngineWorkspace clipMgr] runTask:taskModel];
    __weak typeof(self) weakSelf = self;
    [[XYEngineWorkspace clipMgr] addObserver:self observerID:XYCommonEngineTaskIDClipAddClip block:^(id  _Nonnull obj) {
        UIViewController *videoEditVC = [NSClassFromString(@"QVVideoEditViewController") new];
        [weakSelf.navigationController pushViewController:videoEditVC animated:YES];
    }];
}

#pragma mark - 点击退出按钮
- (void)onExitBtnClick {
    [self.cameraEngine stopRecord];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击删除镜头按钮
- (void)onDeleteBtnClick {
    [self.cameraEngine prepareToDeleteCameraClip];
    [self.cameraEngine deleteCameraClip];
    [self.recordBtn setTitle:[@([self.cameraEngine.cameraClipModels count]) stringValue] forState:UIControlStateNormal];
}

#pragma mark - 点击选择音乐按钮
- (void)onMusicSelectBtnClick {
    if (!self.audioPlayer) {
        NSBundle *bundle = [NSBundle xy_bundleWithBundleName:@"XYMediCamera"];
        NSURL *musicUrl = [bundle URLForResource:@"unravel" withExtension:@"mp3"];
        AVPlayerItem *currentItem = [AVPlayerItem playerItemWithURL:musicUrl];
        self.audioPlayer = [XYAudioPlayer new];
        [self.audioPlayer initPlayerWithPlayerItem:currentItem];
        [self.musicSelectBtn setTitle:@"测试音乐" forState:UIControlStateNormal];
    } else {
        [self.audioPlayer uninitPlayer];
        self.audioPlayer = nil;
        [self.musicSelectBtn setTitle:@"选择音乐" forState:UIControlStateNormal];
    }
    [self.musicSelectBtn sizeToFit];
}

#pragma mark - 美颜程度调节
- (void)onFaceBeautyLevelChanged:(float)level {
    self.cameraEngine.enableFaceBeauty = level>0;
    self.cameraEngine.faceBeautyLevel = level;
}

#pragma mark - 调节曝光程度
- (void)onExposureBiasChanged:(float)level {
    self.cameraDevice.exposureBias = level;//调节范围[-2.0, 2.0]
}

#pragma mark - 切换前后摄像头
- (void)onSwapCameraBtnClick {
    if (self.cameraDevice.firstCameraParam.devicePosition == AVCaptureDevicePositionFront) {
        [self.cameraDevice swapCamera:AVCaptureDevicePositionBack];
    } else {
        [self.cameraDevice swapCamera:AVCaptureDevicePositionFront];
    }
}

#pragma mark - 开关闪光灯
- (void)onFlashBtnClick {
    if (self.cameraDevice.torchMode == AVCaptureTorchModeOff) {
        self.cameraDevice.torchMode = AVCaptureTorchModeOn;
    } else {
        self.cameraDevice.torchMode = AVCaptureTorchModeOff;
    }
}

#pragma mark - 调节比例
- (void)onRatioBtnClick:(QVMediCameraScaleType)scaleType {
    [self.cameraEngine updateDisplayContextWithParamMaker:^(QVMediCameraEngineParamMaker * _Nonnull paramMaker) {
        CGRect previewRect = self.fullSceenPreviewView.frame;
        if (scaleType == QVMediCameraScaleTypeDefault) {
            paramMaker.outputResolutionSize(CGSizeMake(1280, 720));
            paramMaker.renderRegionRect(CGRectMake(0, 0, previewRect.size.width, previewRect.size.height));
        } else if (scaleType == QVMediCameraScaleType_1_1) {
            paramMaker.outputResolutionSize(CGSizeMake(720, 720));
            paramMaker.renderRegionRect(CGRectMake(0, CGRectGetMidY(previewRect) - previewRect.size.width/2.0, previewRect.size.width, previewRect.size.width));
        } else if (scaleType == QVMediCameraScaleType_3_4) {
            paramMaker.outputResolutionSize(CGSizeMake(960, 720));
            paramMaker.renderRegionRect(CGRectMake(0, CGRectGetMidY(previewRect) - previewRect.size.width*4.0/3.0/2.0, previewRect.size.width, previewRect.size.width*4.0/3.0));
        }
    }];
}

#pragma mark - 设置滤镜
- (void)onFilterBtnClick:(NSInteger)templateID {
    XYTemplateItemData *item = [[XYTemplateDataMgr sharedInstance] getByID:templateID];
    [self.cameraEngine setFilterTemplate:item.strPath];
}

#pragma mark - 手势调节焦距
- (void)onPinchGesture:(UIPinchGestureRecognizer *)gesture {
    UIGestureRecognizerState state = gesture.state;
    float scale = gesture.scale;
    
    if(state == UIGestureRecognizerStateBegan){
        //SHOW ZOOM
        self.lastZoomScale = self.currentZoomScale;
    }else if(state == UIGestureRecognizerStateEnded){
        self.cameraEngine.zoomLevel = self.currentZoomScale;
    }else{
        self.currentZoomScale = self.lastZoomScale * scale;
        if(self.currentZoomScale <1.0){
            self.currentZoomScale = 1.0;
        }else if(self.currentZoomScale > 4.0){
            self.currentZoomScale = 4.0;
        }
        self.cameraEngine.zoomLevel = self.currentZoomScale;
    }
}

#pragma mark - 滑动调节焦距
- (void)onZoomValueChanged:(float)value {
    self.currentZoomScale = value;
    self.cameraEngine.zoomLevel = value;
}

#pragma mark - 点击屏幕对焦
- (void)onTapGesture:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:[gesture view]];
    CGRect previewAreaRect = self.fullSceenPreviewView.frame;
    BOOL isTouchInThePreviewArea = CGRectContainsPoint(previewAreaRect, touchPoint);
    if (!isTouchInThePreviewArea) {//没有点在预览区域，忽略该点击
        return;
    }
    [self.cameraDevice setFocusPointWithTouchPoint:touchPoint previewAreaRect:previewAreaRect];
}

#pragma mark - 懒加载
- (QVMediCameraEnginePreviewView *)fullSceenPreviewView {
    if (!_fullSceenPreviewView) {
        [QVMediCameraEnginePreviewView enableMetal:YES];//⚠️需要在初始化XYCameraEnginePreviewView之前设置是否支持Metal
        _fullSceenPreviewView = [[QVMediCameraEnginePreviewView alloc] initWithFrame:CGRectZero];
        _fullSceenPreviewView.backgroundColor = [UIColor blackColor];
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinchGesture:)];
        [_fullSceenPreviewView addGestureRecognizer:pinchGesture];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
        [_fullSceenPreviewView addGestureRecognizer:tapGesture];
    }
    return _fullSceenPreviewView;
}

- (QVMediCameraToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[QVMediCameraToolbar alloc] initWithFrame:CGRectZero];
        [_toolbar initCameraToolbar];
        __weak typeof(self) weakSelf = self;
        [_toolbar setToolbarClickBlock:^(QVMediCameraToolbarType toolbarType) {
            switch (toolbarType) {
                case QVMediCameraToolbarTypeSwitch:
                    [weakSelf onSwapCameraBtnClick];
                    break;
                case QVMediCameraToolbarTypeFillLight:
                    [weakSelf onFlashBtnClick];
                    break;
                default:
                    break;
            }
        }];
        
        [_toolbar setToolbarRatioClickBlock:^(QVMediCameraToolbarType toolbarType, QVMediCameraScaleType scaleType) {
            [weakSelf onRatioBtnClick:scaleType];
        }];
        
        [_toolbar setToolbarFilterClickBlock:^(id  _Nonnull targetResource) {
            NSDictionary *info = targetResource[@"info"];
            NSInteger templateID = [info[@"templateID"] integerValue];
            [weakSelf onFilterBtnClick:templateID];
        }];
        
        [_toolbar setRangSliderSelectValueFinish:^(float value, QVMediCameraToolbarType toolbarType) {
            if (toolbarType == QVMediCameraToolbarTypeBeauty) {
                [weakSelf onFaceBeautyLevelChanged:value/100.0];
            } else if (toolbarType == QVMediCameraToolbarTypeExposure) {
                [weakSelf onExposureBiasChanged:value*2.0];
            } else if (toolbarType == QVMediCameraToolbarTypeFocus) {
                [weakSelf onZoomValueChanged:value];
            }
        }];
    }
    return _toolbar;
}

- (UIButton *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_recordBtn setBackgroundImage:[UIImage QVMediCameraImageNamed:@"medi_camera_start_record_btn"] forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(onRecordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

- (UIButton *)captureBtn {
    if (!_captureBtn) {
        _captureBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_captureBtn setBackgroundImage:[UIImage QVMediCameraImageNamed:@"medi_camera_capture_btn"] forState:UIControlStateNormal];
        [_captureBtn addTarget:self action:@selector(onCaptureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureBtn;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_finishBtn setBackgroundImage:[UIImage QVMediCameraImageNamed:@"medi_camera_finish_btn"] forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(onFinishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_exitBtn setImage:[UIImage QVMediCameraImageNamed:@"medi_camera_exit_btn"] forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(onExitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_deleteBtn setBackgroundImage:[UIImage QVMediCameraImageNamed:@"medi_camera_delete_btn"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(onDeleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIButton *)musicSelectBtn {
    if (!_musicSelectBtn) {
        _musicSelectBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_musicSelectBtn setBackgroundImage:[UIImage QVMediCameraImageNamed:@"medi_camera_music_select_btn"] forState:UIControlStateNormal];
        [_musicSelectBtn setTitle:NSLocalizedString(@"mn_cam_func_add_bgm", @"添加音乐") forState:UIControlStateNormal];
        [_musicSelectBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_musicSelectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [_musicSelectBtn addTarget:self action:@selector(onMusicSelectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_musicSelectBtn sizeToFit];
    }
    return _musicSelectBtn;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_durationLabel setFont:[UIFont systemFontOfSize:16]];
        [_durationLabel setTextColor:[UIColor whiteColor]];
        [_durationLabel setText:@"00:00"];
        [_durationLabel setTextAlignment:NSTextAlignmentCenter];
        [_durationLabel setShadowOffset:CGSizeMake(1, 1)];
    }
    return _durationLabel;
}

- (NSString *)videoClipFilePath {
    if (!_videoClipFilePath) {
        NSString *cameraFolder = [NSString stringWithFormat:@"%@/public/camera",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]];
        [NSFileManager xy_createFolderWithPath:cameraFolder];
        NSString *timestamp = [NSString stringWithFormat:@"%.0lf", [[NSDate date] timeIntervalSince1970]];
        _videoClipFilePath = [NSString stringWithFormat:@"%@/%@.mp4",cameraFolder,timestamp];
    }
    return _videoClipFilePath;
}

- (NSString *)imageClipFilePath {
    NSString *cameraFolder = [NSString stringWithFormat:@"%@/public/camera",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]];
    [NSFileManager xy_createFolderWithPath:cameraFolder];
    NSString *timestamp = [NSString stringWithFormat:@"%.0lf", [[NSDate date] timeIntervalSince1970]];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg",cameraFolder,timestamp];
    return filePath;
}


@end
