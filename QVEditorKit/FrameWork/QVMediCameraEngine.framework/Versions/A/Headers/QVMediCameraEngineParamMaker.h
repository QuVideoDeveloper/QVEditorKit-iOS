//
//  QVMediCameraEngineParamMaker.h
//
//  Created by 徐新元 on 2020/4/20.
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
//#import <XYCommonEngine/CXiaoYingInc.h>
#import "QVMediCameraEnginePreviewView.h"

@class QVMediCameraEngineParamMakerParam, CXiaoYingEngine;

@interface QVMediCameraEngineParamMaker : NSObject

@property (nonatomic, strong, readonly) QVMediCameraEngineParamMakerParam *param;

/// CXiaoYingEngine
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ cXiaoYingEngine)(CXiaoYingEngine *cXiaoYingEngine);

/// Camera引擎的预览View
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ previewView)(QVMediCameraEnginePreviewView *previewView);

/// 是否开启Metal
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ enableMetal)(BOOL enableMetal);

/// Camera引擎需要的模版路径ID转换方法 CXiaoYingTemplateAdapter
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ templateAdapter)(id templateAdapter);

/// Cam引擎输入尺寸(预览分辨率)，需要与Session preset尺寸相同
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ inputResolutionSize)(CGSize inputResolutionSize);

/// 输出尺寸（拍完的视频文件的分辨率），竖屏的视频尺寸也是宽大于高的，
/// 最后会结合orientation进行旋转
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ outputResolutionSize)(CGSize outputResolutionSize);

/// 在PreviewView上指定渲染区域
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ renderRegionRect)(CGRect renderRegionRect);

/// 设备当前方向
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ deviceOrientation)(UIDeviceOrientation deviceOrientation);

/// 美颜模版文件路径
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ fbTemplateFilepath)(NSString *fbTemplateFilepath);

/// 美颜模版ID
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ fbTemplateID)(NSInteger fbTemplateID);

/// License文件地址
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ licensePath)(NSString *licensePath);

/// 是否开启AR
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ enableAR)(BOOL enableAR);

/// 是否开启深度信息
@property (nonatomic, copy, readonly) QVMediCameraEngineParamMaker *(^ enableDepth)(BOOL enableDepth);

@end

@interface QVMediCameraEngineParamMakerParam : NSObject

@property (nonatomic, strong) CXiaoYingEngine *cXiaoYingEngine;

@property (nonatomic, weak) QVMediCameraEnginePreviewView *previewView;

@property (nonatomic, assign) BOOL enableMetal;

/// <CXiaoYingTemplateAdapter>
@property (nonatomic, weak) id templateAdapter;

@property (nonatomic, assign) CGSize inputResolutionSize;

@property (nonatomic, assign) CGSize outputResolutionSize;

@property (nonatomic, assign) CGRect renderRegionRect;

@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;

@property (nonatomic, copy) NSString *fbTemplateFilepath;

@property (nonatomic, assign) NSInteger fbTemplateID;

@property (nonatomic, copy) NSString *licensePath;

@property (nonatomic, assign) BOOL enableAR;

@property (nonatomic, assign) BOOL enableDepth;

@end
