//
//  XYCameraDeviceProtocol.h
//  XYCameraKit
//
//  Created by 徐新元 on 2020/4/20.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QVMediCameraDeviceProtocol <NSObject>
@optional
- (void)firstCameraVideoOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)firstCameraAudioOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)secondCameraVideoOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (void)secondCameraAudioOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end

NS_ASSUME_NONNULL_END
