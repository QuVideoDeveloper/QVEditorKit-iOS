//
//  QVMediCameraDevice.h
//  QVMediCameraKit
//
//  Created by 徐新元 on 2020/4/14.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "QVMediCameraDeviceParamMaker.h"
#import "QVMediCameraDeviceProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface QVMediCameraDevice : NSObject


/// Camera Session
@property (nonatomic, strong, readonly) AVCaptureSession* session;

/// 锁定对焦点
@property (nonatomic, assign, readwrite) BOOL lockFocus;

/// 锁定曝光点
@property (nonatomic, assign, readwrite) BOOL lockExposure;

/// 曝光补偿数值
@property (nonatomic, assign, readwrite) float exposureBias;

/// 闪光灯常亮模式设置
@property (nonatomic, assign, readwrite) AVCaptureTorchMode torchMode;

/// Camera Sample Buffer回调
@property (nonatomic, weak) id<QVMediCameraDeviceProtocol> cameraDeviceDelegate;

//1号Camera相关设置参数
@property (nonatomic, strong, readonly) QVMediCameraDeviceParamMakerParam *firstCameraParam;

//2号Camera相关设置参数
@property (nonatomic, strong, readonly) QVMediCameraDeviceParamMakerParam *secondCameraParam;


/// 初始化CameraDevice
- (void)initCameraDeviceWithParamMaker:(void(^)(QVMediCameraDeviceParamMaker *paramMaker))paramMakerBlock;

/// 初始化CameraDevice，前后双镜头同时使用，iOS13开始支持
- (void)initDualCameraDeviceWithFirstCameraParamMaker:(void(^)(QVMediCameraDeviceParamMaker *paramMaker))firstParamMakerBlock
                               SecondCameraParamMaker:(nullable void(^)(QVMediCameraDeviceParamMaker *paramMaker))secondParamMakerBlock;

/// 启动CameraSession，此时开始会有buffer数据回调
- (void)startSession;

/// 停止CameraSession，buffer回调会停止
- (void)stopSession;

/// 切换前后摄像头
/// @param position AVCaptureDevicePosition 摄像头位置
- (void)swapCamera:(AVCaptureDevicePosition)position;

/// 点击屏幕设置对焦点
/// @param touchPoint 点击位置相对于预览区域的坐标
/// @param previewAreaRect 预览区域rect
- (void)setFocusPointWithTouchPoint:(CGPoint)touchPoint previewAreaRect:(CGRect)previewAreaRect;


@end

NS_ASSUME_NONNULL_END
