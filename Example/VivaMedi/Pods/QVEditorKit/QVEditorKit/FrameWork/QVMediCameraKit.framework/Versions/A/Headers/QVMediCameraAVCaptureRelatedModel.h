//
//  QVMediCameraAVCaptureRelatedModel.h
//  QVMediCameraKit
//
//  Created by 徐新元 on 2020/4/17.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QVMediCameraAVCaptureRelatedModel : NSObject

//Video
@property (nonatomic, strong, readwrite) AVCaptureDevice *videoDevice;

@property (nonatomic, strong, readwrite) AVCaptureDeviceInput* videoDeviceInput;

@property (nonatomic, strong, readwrite) AVCaptureVideoDataOutput *videoDataOutPut;

@property (nonatomic, strong, readwrite) AVCaptureConnection *videoDataOutPutConnection;

//Audio
@property (nonatomic, strong, readwrite) AVCaptureDevice *audioDevice;

@property (nonatomic, strong, readwrite) AVCaptureDeviceInput* audioDeviceInput;

@property (nonatomic, strong, readwrite) AVCaptureAudioDataOutput *audioDataOutPut;

@property (nonatomic, strong, readwrite) AVCaptureConnection *audioDataOutPutConnection;

@end

NS_ASSUME_NONNULL_END
