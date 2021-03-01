//
//  QVMediCameraDeviceParamMaker.h
//
//  Created by 徐新元 on 2020/4/16.
//  
//

////链式参数传递工具类
///使用示例：
////如何使用传进来的参数
//- (void)doSomething:(void(^)(XYChainParamMaker *maker))block {
//    XYChainParamMaker *maker = [[XYChainParamMaker alloc] init];
//    if (block) {
//        block(maker);
//    }
//    NSString *demoStringParam = maker.param.demoStringParam;
//    NSInteger demoIntegerParam = maker.param.demoIntegerParam;
//    BOOL demoBOOLParam = maker.param.demoBOOLParam;
//    NSLog(@"demoStringParam = %@,demoIntegerParam = %@, demoBOOLParam=%@",demoStringParam,@(demoIntegerParam),@(demoBOOLParam));
//}
//
////如何传参数
//[self doSomething:^(XYChainParamMaker *maker) {
//    maker.demoIntegerParam(0).demoStringParam(@"ccc").demoBOOLParam(YES);
//}];

#import <AVFoundation/AVFoundation.h>
@class QVMediCameraDeviceParamMakerParam;


@interface QVMediCameraDeviceParamMaker : NSObject

@property (nonatomic, strong, readonly) QVMediCameraDeviceParamMakerParam *param;

/// 设备镜头方向
@property (nonatomic, copy, readonly) QVMediCameraDeviceParamMaker *(^ devicePosition)(AVCaptureDevicePosition devicePosition);

/// 分辨率设置
@property (nonatomic, copy, readonly) QVMediCameraDeviceParamMaker *(^ captureSessionPreset)(AVCaptureSessionPreset captureSessionPreset);

/// Camera预览Layer
@property (nonatomic, copy, readonly) QVMediCameraDeviceParamMaker *(^ videoPreviewLayer)(AVCaptureVideoPreviewLayer *videoPreviewLayer);

@end


@interface QVMediCameraDeviceParamMakerParam : NSObject


@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;

@property (nonatomic, copy) AVCaptureSessionPreset captureSessionPreset;

@property (nonatomic, weak) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end
