//
//  XYNativeCameraVC.m
//  XYMediCamera
//
//  Created by 徐新元 on 2020/4/16.
//

#import "QVMediNativeCameraVC.h"
#import <QVMediCameraKit/QVMediCameraDevice.h>
#import <QVMediCameraKit/QVMediCameraPreviewView.h>
#import <QVMediToolbarKit/QVMediCameraToolbar.h>
#import <QVMediToolbarKit/QVMediToolbarManager.h>

#import <Masonry/Masonry.h>


@interface QVMediNativeCameraVC ()

//Camera小预览view
@property (nonatomic, strong) QVMediCameraPreviewView *smallPreviewView;
//Camera全屏预览view
@property (nonatomic, strong) QVMediCameraPreviewView *fullSceenPreviewView;
//Camera工具栏
@property (nonatomic, strong) QVMediCameraToolbar *toolbar;
//系统Camera相关管理类
@property (nonatomic, strong) QVMediCameraDevice *cameraDevice;

@end

@implementation QVMediNativeCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
//    [self.cameraDevice initCameraDeviceWithParamMaker:^(XYCameraDeviceParamMaker * _Nonnull paramMaker) {
//        paramMaker.captureSessionPreset(AVCaptureSessionPreset1920x1080)
//        .devicePosition(AVCaptureDevicePositionBack);
//    }];
    
    __weak typeof(self) weakSelf = self;
    [self.cameraDevice initDualCameraDeviceWithFirstCameraParamMaker:^(QVMediCameraDeviceParamMaker * _Nonnull paramMaker) {
        paramMaker.captureSessionPreset(AVCaptureSessionPreset1920x1080)
        .devicePosition(AVCaptureDevicePositionBack)
        .videoPreviewLayer(weakSelf.fullSceenPreviewView.videoPreviewLayer);
    } SecondCameraParamMaker:^(QVMediCameraDeviceParamMaker * _Nonnull paramMaker) {
        paramMaker.captureSessionPreset(AVCaptureSessionPreset1280x720)
        .devicePosition(AVCaptureDevicePositionFront)
        .videoPreviewLayer(weakSelf.smallPreviewView.videoPreviewLayer);
    }];
    
    [self.fullSceenPreviewView.videoPreviewLayer setSessionWithNoConnection:self.cameraDevice.session];
    [self.smallPreviewView.videoPreviewLayer setSessionWithNoConnection:self.cameraDevice.session];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraDevice startSession];
}

- (void)initUI {
    [self.view addSubview:self.fullSceenPreviewView];
    [self.view addSubview:self.smallPreviewView];
    [self.view addSubview:self.toolbar];
}

- (void)layoutUI {
    [self.fullSceenPreviewView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
    [self.smallPreviewView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-100);
        make.bottom.equalTo(self.view).offset(-50);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(320);
    }];
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.top.offset(50);
    }];
}

- (void)onToolbarClick:(QVMediCameraToolbarType)toolbarType {
    switch (toolbarType) {
        case QVMediCameraToolbarTypeFocus:
            break;
        case QVMediCameraToolbarTypeRatio:
            break;
        case QVMediCameraToolbarTypeSwitch:
            
            [self.cameraDevice swapCamera:AVCaptureDevicePositionFront];
            break;
        case QVMediCameraToolbarTypeBeauty:
            break;
        case QVMediCameraToolbarTypeFilter:
            break;
        case QVMediCameraToolbarTypeExposure:
            break;
        case QVMediCameraToolbarTypeFillLight:
            break;
        default:
            break;
    }
}

#pragma mark - 懒加载
- (QVMediCameraPreviewView *)fullSceenPreviewView {
    if (!_fullSceenPreviewView) {
        _fullSceenPreviewView = [[QVMediCameraPreviewView alloc] initWithFrame:CGRectZero];
        _fullSceenPreviewView.backgroundColor = [UIColor blackColor];
    }
    return _fullSceenPreviewView;
}

- (QVMediCameraPreviewView *)smallPreviewView {
    if (!_smallPreviewView) {
        _smallPreviewView = [[QVMediCameraPreviewView alloc] initWithFrame:CGRectZero];
        _smallPreviewView.backgroundColor = [UIColor clearColor];
    }
    return _smallPreviewView;
}

- (QVMediCameraToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [QVMediToolbarManager createToolbarWithType:QVMediToolbarTypeCamera];
        _toolbar.toolbarClickBlock = ^(QVMediCameraToolbarType toolbarType) {
            //
        };
    }
    return _toolbar;
}

- (QVMediCameraDevice *)cameraDevice {
    if (!_cameraDevice) {
        _cameraDevice = [QVMediCameraDevice new];
    }
    return _cameraDevice;
}

@end
