//
//  QVMediAudioRecorderClient.h
//  QVMediVivaEditor
//
//  Created by qichao.ma on 2019/10/25.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QVMediAudioRecorderClient : NSObject

@property (nonatomic, strong, readonly) AVAudioRecorder *audioRecorder;

/// audioFilePath: 录制前必须先配置录制文件的路径
- (void)prepareToRecordWithAudioFilePath:(NSString *)audioFilePath;

/// 开始录制
- (void)record;

/// 暂停
- (void)pause;

/// 停止录制, flag: YES，非打断终止；NO，打断性终止
- (void)stop:(void(^)(BOOL flag))handler;

+ (void)requestRecordPermission:(void(^)(void))successHandler
                 failureHandler:(void(^)(void))failureHandler
             doubleCheckHandler:(void(^)(void))doubleCheckHandler;


@end

NS_ASSUME_NONNULL_END
