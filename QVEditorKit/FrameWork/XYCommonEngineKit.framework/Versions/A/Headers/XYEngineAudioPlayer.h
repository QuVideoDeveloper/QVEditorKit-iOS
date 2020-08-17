//
//  XYEngineAudioPlayer.h
//  XYVivaEditor
//
//  Created by yitezh on 2020/6/5.
//

#import <Foundation/Foundation.h>
#import <XYCommonEngineKit/XYEngine.h>
typedef NS_ENUM(NSInteger,XYEngineAudioPlayerPlayState) {
    XYEngineAudioPlayerPlayStateReady = AMVE_PROCESS_STATUS_READY,
    XYEngineAudioPlayerPlayStateRunning = AMVE_PROCESS_STATUS_RUNNING,
    XYEngineAudioPlayerPlayStatePause = AMVE_PROCESS_STATUS_PAUSED,
    XYEngineAudioPlayerPlayStateStopped  = AMVE_PROCESS_STATUS_STOPPED,
};


@protocol XYEngineAudioPlayerDelegate <NSObject>

@optional

- (void)engineAudioPlayerPlayCurrentTime:(CGFloat)current totaltime:(CGFloat)totalTime;

- (void)engineAudioPlayerPlayState:(XYEngineAudioPlayerPlayState)state;

@end

typedef void(^XYEngineAudioPlayerPlayTimeBlock)(NSInteger current,NSInteger totalTime);

typedef void(^XYEngineAudioPlayerPlayStateBlock)(XYEngineAudioPlayerPlayState state);


@interface XYEngineAudioPlayer : NSObject

@property (assign, nonatomic)CGFloat pitch;

@property (assign, nonatomic)CGFloat volume;

- (instancetype)initWithAudioPath:(NSString *)filePath;

@property (strong, nonatomic) XYEngineAudioPlayerPlayTimeBlock playTimeblock;

@property (strong, nonatomic) XYEngineAudioPlayerPlayStateBlock playStateblock;

@property (strong, nonatomic) XYEngineAudioPlayerPlayStateBlock stopBlock;

@property (weak, nonatomic) id<XYEngineAudioPlayerDelegate> delegate;

- (void)play;

- (void)pause;

- (void)stop;

- (void)destory;

- (void)seekToPosition:(NSInteger)seekTime autoPlay:(BOOL)autoPlay;


@end


