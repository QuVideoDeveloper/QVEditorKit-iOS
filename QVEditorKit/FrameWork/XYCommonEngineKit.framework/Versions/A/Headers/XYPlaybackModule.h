//
//  PlaybackModule.h
//  XiaoYing
//
//  Created by xuxinyuan on 13-5-28.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <XYCommonEngine/CXiaoYingInc.h>

typedef NS_ENUM(NSInteger, XYPlayerState) {
    XYPlayerStateNone = AMVE_PROCESS_STATUS_NONE,
    XYPlayerStateReady = AMVE_PROCESS_STATUS_READY,
    XYPlayerStateRunning = AMVE_PROCESS_STATUS_RUNNING,
    XYPlayerStatePaused = AMVE_PROCESS_STATUS_PAUSED,
    XYPlayerStateStopped = AMVE_PROCESS_STATUS_STOPPED,
    XYPlayerStateInitializing = AMVE_PROCESS_STATUS_INITIALIZING,
};

@class XYStoryboard;

@interface XYPlayerCallBackData : NSObject

/// 播放状态
@property XYPlayerState state;

/// 视频的总时长
@property NSInteger duration;

/// 当前播放的时间点
@property NSInteger position;

/// 播放错误吗
@property NSInteger errCode;

@end

@protocol PlaybackModuleDelegate <NSObject>

@optional

- (void)playbackStateCallBack:(XYPlayerCallBackData *)playbackData;

@end

@interface XYPlaybackModule : NSObject <AMVESessionStateDelegate>

@property (nonatomic) NSInteger totalDuration;
@property (nonatomic, assign, getter=isDisablePlayAndSeek) BOOL disablePlayAndSeek;//禁止手动播放和Seek操作

- (id)init:(CXiaoYingStream *)stream
initPosition:(int)position
displayContext:(QVET_RENDER_CONTEXT_TYPE *)displayContext
playbackModuleDelegate:(id<PlaybackModuleDelegate>)playbackModuleDelegate;

- (void)unInit;

- (void)finishOpengl;

- (void)enterForeground;

- (void)enterBackground;

- (NSInteger)activeStream:(CXiaoYingStream *)stream Position:(NSInteger)position;

- (NSInteger)deactiveStream;

- (void)playWithOutShowLayer;

- (void)play;

- (void)pause;

- (void)pause:(BOOL)force;

- (void)stop;

- (void)seekTo:(NSInteger)iTime force:(BOOL)force;

- (void)seekTo:(NSInteger)iTime force:(BOOL)force async:(BOOL)async;

- (void)seekTo:(NSInteger)iTime force:(BOOL)force async:(BOOL)async block:(void (^)(void))block;

- (BOOL)isPlaying;

- (BOOL)isReady;

- (BOOL)isInBackground;

- (void)setVolumn:(NSInteger)volumn;

- (void)setPlayRange:(NSInteger)startPos
              endPos:(NSInteger)endPos;

- (void)showLayer:(MFloat)fLayerID
          IsShown:(MBool)bIsShown
   RefreshDisplay:(MBool)bRefreshDisplay;

- (void)showLayer:(MFloat)fLayerID
          IsShown:(MBool)bIsShown
   RefreshDisplay:(MBool)bRefreshDisplay
       storyboard:(XYStoryboard *)storyboard;

- (void)getViewport:(MRECT *)prcViewport;

- (void)setDisplayContext:(QVET_RENDER_CONTEXT_TYPE *)displayContext;

- (void)displayRefresh;

- (void)displayRefreshCurrentThead;

- (void)refreshEffect:(CXiaoYingClip *)clip
               OpCode:(MDWord)opCode
               Effect:(CXiaoYingEffect *)effect;

- (void)refreshEffect:(CXiaoYingClip *)clip
               OpCode:(MDWord)opCode
               Effect:(CXiaoYingEffect *)effect
                async:(BOOL)async;

- (void)rebuildStream;

- (void)setFrameSizeWidth:(MDWord)width height:(MDWord)height;

- (void)refreshAudio;



#pragma mark - 8.0.0整理
/// 播放
/// @param async 是否异步播放
- (void)playAsync:(BOOL)async;

/// Seek接口
/// @param seekPosition seek时间点，单位毫秒
/// @param async YES异步执行seek操作，NO同步执行该seek操作
- (void)seekToPosition:(NSInteger)seekPosition async:(BOOL)async;

///开始调整effect前先锁定该effect下的图层
- (NSInteger)lockStuffUnderEffect:(CXiaoYingEffect *)effect async:(BOOL)async;

///调整完effect后解锁该effect下的图层
- (NSInteger)unlockStuffUnderEffect:(CXiaoYingEffect *)effect async:(BOOL)async;


/// 刷新播放器区域
/// @param async 是否异步刷新
- (void)displayRefreshAsync:(BOOL)async;


/// 设置播放时间区域
/// @param startPos 起始点
/// @param endPos 结束点
/// @param async 是否异步
- (void)setPlayRange:(MDWord)startPos
              endPos:(MDWord)endPos
               async:(BOOL)async;

- (void)forcePause;
@end
