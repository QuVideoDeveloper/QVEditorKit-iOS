//
//  QVMediCameraRecordParamMaker.h
//
//  Created by 徐新元 on 2020/4/14.
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

@class QVMediCameraRecordParamMakerParam;

@interface QVMediCameraRecordParamMaker : NSObject

@property (nonatomic, strong, readonly) QVMediCameraRecordParamMakerParam *param;

@property (nonatomic, copy, readonly) QVMediCameraRecordParamMaker *(^ clipFilePath)(NSString *clipFilePath);

@property (nonatomic, copy, readonly) QVMediCameraRecordParamMaker *(^ watermarkCode)(NSString *watermarkCode);

@property (nonatomic, copy, readonly) QVMediCameraRecordParamMaker *(^ PCMSampleRate)(NSInteger PCMSampleRate);

@property (nonatomic, copy, readonly) QVMediCameraRecordParamMaker *(^ PCMChannels)(NSInteger PCMChannels);

@property (nonatomic, copy, readonly) QVMediCameraRecordParamMaker *(^ maxFrameRate)(NSInteger maxFrameRate);

@property (nonatomic, copy, readonly) QVMediCameraRecordParamMaker *(^ exportUnitCount)(NSInteger exportUnitCount);

@property (nonatomic, copy, readonly) QVMediCameraRecordParamMaker *(^ hasAudioTrack)(BOOL hasAudioTrack);

@end


@interface QVMediCameraRecordParamMakerParam : NSObject

@property (nonatomic, copy) NSString *clipFilePath;

@property (nonatomic, copy) NSString *watermarkCode;

@property (nonatomic, assign) NSInteger PCMSampleRate;

@property (nonatomic, assign) NSInteger PCMChannels;

@property (nonatomic, assign) NSInteger maxFrameRate;

@property (nonatomic, assign) NSInteger exportUnitCount;

@property (nonatomic, assign) BOOL hasAudioTrack;

@end
