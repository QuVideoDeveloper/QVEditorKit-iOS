//
//  QVMediCameraPreviewView.h
//  QVMediCameraKit
//
//  Created by 徐新元 on 2020/4/14.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

NS_ASSUME_NONNULL_BEGIN

@interface QVMediCameraPreviewView : UIView

@property (nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic) AVCaptureSession *session;

@end

NS_ASSUME_NONNULL_END
