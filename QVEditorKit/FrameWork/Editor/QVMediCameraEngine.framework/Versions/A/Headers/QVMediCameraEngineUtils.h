//
//  QVMediCameraEngineUtils.h
//  QVMediCameraEngine
//
//  Created by 徐新元 on 2020/4/21.
//

#import <Foundation/Foundation.h>
#import "QVMediCameraFaceBeatyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QVMediCameraEngineUtils : NSObject

+ (MRECT)ceDisplayPixelRectWithExportFrameSize:(MSIZE)ceExportFrameSize
                                    renderSize:(MSIZE)ceRenderSize
                                  renderOffset:(MSIZE)ceRenderOffset
                             deviceOrientation:(UIDeviceOrientation)deviceOrientation
                                   previewView:(UIView *)previewView;

+ (MRECT)ceWorkRectWithDeviceFrameSize:(MSIZE)ceDeviceFrameSize
                       exportFrameSize:(MSIZE)ceExportFrameSize
                     deviceOrientation:(UIDeviceOrientation)deviceOrientation;

+ (XYCE_PROCESS_RECT_INFO)ceDisplayRectInfoWithExportFrameSize:(MSIZE)ceExportFrameSize
                                                    renderSize:(MSIZE)ceRenderSize
                                             deviceOrientation:(UIDeviceOrientation)deviceOrientation;

+ (MSIZE)ceExportFrameSizeWithOutputResolutionSize:(CGSize)outputResolutionSize
                                 deviceOrientation:(UIDeviceOrientation)deviceOrientation;

+ (QVMediCameraFaceBeatyModel *)faceBeautyModelWithTemplatePath:(NSString *)templatePath
                                                 templateID:(NSInteger)templateID
                                            cXiaoYingEngine:(CXiaoYingEngine *)cXiaoYingEngine;

@end

NS_ASSUME_NONNULL_END
