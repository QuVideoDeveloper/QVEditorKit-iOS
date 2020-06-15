//
//  QVMediAudioRecorderClient.m
//  QVMediVivaEditor
//
//  Created by qichao.ma on 2019/10/25.
//

#import "QVMediAudioRecorderClient.h"

@interface QVMediAudioRecorderClient()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, copy) void(^didFinishRecordingHandler)(BOOL flag);

@end

@implementation QVMediAudioRecorderClient

- (void)dealloc
{
    _audioRecorder = nil;
}

/// audioFilePath: 录制前必须先配置录制文件的路径
- (BOOL)prepareToRecordWithAudioFilePath:(NSString *)audioFilePath
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
    
    NSURL *outputFileURL = [NSURL fileURLWithPath:audioFilePath];
    NSDictionary *defaultSetting = [self.class defaultSetting];
    
    NSError *error;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:defaultSetting error:&error];
    
    if (error) {
        [NSException raise:@"ERROR FOUND" format:@"ERROR MESSAGE: %@ ", error.domain];
        
        return NO;
    }
    
    _audioRecorder.delegate = self;
    
    return [_audioRecorder prepareToRecord];
}

/// 开始录制
- (void)record
{
    if (!_audioRecorder.isRecording) {
        [self.audioRecorder record];
    }
}

/// 暂停
- (void)pause
{
    [self.audioRecorder pause];
}

/// 停止录制
- (void)stop:(void(^)(BOOL flag))handler
{
    _didFinishRecordingHandler = handler;
    [self.audioRecorder stop];
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    if (_didFinishRecordingHandler) {
        _didFinishRecordingHandler(flag);
    }
}

#pragma mark - Class Method
+ (NSDictionary<NSString *, id> *)defaultSetting
{
    NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    [setting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [setting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [setting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    return setting;
}

+ (BOOL)isAudioAuthorized
{
    AVAudioSessionRecordPermission recordPermission = [AVAudioSession sharedInstance].recordPermission;
    BOOL flag = (recordPermission == AVAudioSessionRecordPermissionGranted);
    
    return flag;
}

+ (void)requestRecordPermission:(void(^)(void))successHandler
                 failureHandler:(void(^)(void))failureHandler
             doubleCheckHandler:(void(^)(void))doubleCheckHandler
{
    AVAudioSessionRecordPermission recordPermission = [AVAudioSession sharedInstance].recordPermission;
    switch (recordPermission) {
        case AVAudioSessionRecordPermissionUndetermined:
        {
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                if (granted) {
                    if (successHandler) {
                        successHandler();
                    }
                } else {
                    if (failureHandler) {
                        failureHandler();
                    }
                }
            }];
        }
            break;
            
        case AVAudioSessionRecordPermissionDenied:
        {
            if (doubleCheckHandler) {
                doubleCheckHandler();
            }
        }
            break;
            
        case AVAudioSessionRecordPermissionGranted:
        {
            if (successHandler) {
                successHandler();
            }
        }
            break;
            
        default:
            break;
    }
}

@end
