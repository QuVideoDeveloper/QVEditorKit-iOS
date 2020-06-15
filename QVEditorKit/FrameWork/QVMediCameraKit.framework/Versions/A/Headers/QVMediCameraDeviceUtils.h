//
//  QVMediCameraDeviceUtils.h
//  QVMediCameraKit
//
//  Created by 徐新元 on 2020/4/16.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QVMediCameraDeviceUtils : NSObject

+ (AVCaptureDevice *)deviceWithMediaType:(AVMediaType)mediaType
                      preferringPosition:(AVCaptureDevicePosition)position;

+ (CGPoint)convertTouchPointToDevicePoint:(CGPoint)touchPoint
                          previewAreaRect:(CGRect)previewAreaRect
                            isFrontCamera:(BOOL)isFrontCamera;

@end

NS_ASSUME_NONNULL_END
