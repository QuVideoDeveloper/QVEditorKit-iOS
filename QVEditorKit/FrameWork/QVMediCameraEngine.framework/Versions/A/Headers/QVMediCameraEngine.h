//
//  QVMediCameraEngine.h
//  QVMediCameraEngine
//
//  Created by 徐新元 on 2020/4/14.
//

#import <Foundation/Foundation.h>
#import "QVMediCameraEngineParamMaker.h"
#import "QVMediCameraRecordParamMaker.h"
#import "QVMediCameraEngineStateModel.h"
#import "QVMediCameraClipModel.h"
#import "QVMediCameraFaceBeatyModel.h"
#import "QVMediCameraDeviceProtocol.h"
@class QVMediCameraEnginePreviewView;

NS_ASSUME_NONNULL_BEGIN


@protocol QVMediCameraEngineProtocol <NSObject>
@optional
/// CameraEngine的状态回调
/// @param stateModel CameraEngine当前状态Model
- (void)onCameraEngineStateUpdate:(QVMediCameraEngineStateModel *)stateModel;

@end


@interface QVMediCameraEngine : NSObject <QVMediCameraDeviceProtocol>

/// Camera当前状态相关引擎参数
@property (nonatomic, strong, readonly) QVMediCameraEngineStateModel *stateModel;

/// 当前已录制的镜头数据
@property (nonatomic, strong, readonly) NSMutableArray <QVMediCameraClipModel *> *cameraClipModels;

/// Camera美颜相关数据
@property (nonatomic, strong, readonly) QVMediCameraFaceBeatyModel *faceBeautyModel;

/// Zoom [1.0, 4.0]
@property (nonatomic, assign) float zoomLevel;

/// 开启美颜功能
@property (nonatomic, assign) BOOL enableFaceBeauty;

/// 美颜程度 [0, 1]
@property (nonatomic, assign) float faceBeautyLevel;

/// Camera Engine的各种回调
@property (nonatomic, weak) id<QVMediCameraEngineProtocol> cameraEngineDelegate;


#pragma mark - 初始化
/// 初始化Camera引擎
- (void)initCameraEngineWithParamMaker:(void(^)(QVMediCameraEngineParamMaker *paramMaker))paramMakerBlock;

/// 销毁Camera引擎, 退出Camera时必须调用，不然会引起内存泄漏
- (void)uninitCameraEngine;

/// 更新Camera的分辨率，方向
- (void)updateDisplayContextWithParamMaker:(void(^)(QVMediCameraEngineParamMaker *paramMaker))paramMakerBlock;

#pragma mark - 录制相关
/// 开始录制
- (void)startRecordWithParamMaker:(void(^)(QVMediCameraRecordParamMaker *paramMaker))paramMakerBlock;

/// 停止录制
- (void)stopRecord;

/// 暂停录制
- (void)pauseRecord;

/// 继续录制
- (void)resumeRecord;

#pragma mark - 拍照相关
/// 拍照（分辨率等于录制视频的分辨率，也就是outPutResolution）
/// @param filePath 拍照文件保存地址
/// @param isOriginal 是否原始图像，不包括效果（滤镜，美颜等效果）
- (void)captureWithFilePath:(NSString *)filePath isOriginal:(BOOL)isOriginal;

#pragma mark - Clip相关
/// 准备删除最后一个镜头
- (void)prepareToDeleteCameraClip;

/// 删除最后一个镜头
- (void)deleteCameraClip;

/// 取消删除最后一个镜头
- (void)cancelDeleteCameraClip;

///替换所有镜头数据
- (void)replaceAllCameraClips:(NSArray <QVMediCameraClipModel *> *)cameraClipModels;

#pragma mark - 滤镜相关
/// 设置滤镜模版
/// @param templateFilePath 模版文件地址
- (void)setFilterTemplate:(NSString *)templateFilePath;

/// 判断设备是否支持激光雷达的深度信息
+ (BOOL)deviceIsSceneDepthSupported;

/// 判断设备是否支持双摄
+ (BOOL)deviceIsDepthDataDeliverySupported;
@end

NS_ASSUME_NONNULL_END
