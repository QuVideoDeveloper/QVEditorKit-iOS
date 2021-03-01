//
//  QVMediCameraEngineStateModel.h
//  QVMediCameraEngine
//
//  Created by 徐新元 on 2020/4/14.
//

#import <Foundation/Foundation.h>
//#import <XYCommonEngine/QCamDef.h>

typedef NS_ENUM(NSInteger, QVMediCameraEngineRecordState) {
    QVMediCameraEngineRecordStateIdle,//预览中
    QVMediCameraEngineRecordStateRecording,//录制中
    QVMediCameraEngineRecordStatePausing,//暂停中
};

NS_ASSUME_NONNULL_BEGIN

@interface QVMediCameraEngineStateModel : NSObject

/// 当前CameraEngine的状态信息
@property (nonatomic) QVMediCameraEngineRecordState recordState;

/// 已录视频总时长
@property (nonatomic) NSInteger totalDuration;

@property (nonatomic) NSInteger rawStatus;
@property (nonatomic) NSInteger lastRecordedFrameTS;
@property (nonatomic) NSInteger maxDuration;
@property (nonatomic) NSInteger maxFileSize;
@property (nonatomic) BOOL needDisplayFaceDetectFailTip;//需要显示人脸检测失败提示

@end

NS_ASSUME_NONNULL_END
