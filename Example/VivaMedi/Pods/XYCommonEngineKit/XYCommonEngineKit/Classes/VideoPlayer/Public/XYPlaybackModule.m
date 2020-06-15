//
//  PlaybackModule.m
//  XiaoYing
//
//  Created by xuxinyuan on 13-5-28.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//

#import "XYPlaybackModule.h"
#import "XYStoryboardUtility.h"
#import "XYEngine.h"
#import "XYStoryboard.h"
#import <XYToolKit/XYToolKit.h>

MDWord const kPlayerCallbackDelta = 16;//播放器回调频率，每16ms回调一次

@implementation XYPlayerCallBackData

@synthesize state;
@synthesize duration;
@synthesize position;
@synthesize errCode;

@end

@interface XYPlaybackModule ()

@property (nonatomic, weak) id<PlaybackModuleDelegate> mplaybackModuleDelegate;
@property (nonatomic, weak) CXiaoYingEffect *lockedEffect;
@property (nonatomic, strong) NSMutableArray *seekPositionList;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, assign) NSInteger lastSeekPosition;

@end

@implementation XYPlaybackModule {
    int lastPlayerStatus;
    int lastPlayerTime;
    CXiaoYingStream *mStream;
    CXiaoYingPlayerSession *mPlayer;
    XYPlayerCallBackData *playBackData;
    dispatch_queue_t playbackQueue;
    BOOL isRefreshing;
    BOOL isReady;
    BOOL isInBackground;
    AMVE_VIDEO_INFO_TYPE videoInfo;
    MDWord totalDuration;
}

- (MDWord)totalDuration {
    return totalDuration;
}

- (id)init:(CXiaoYingStream *)stream
initPosition:(int)position
displayContext:(QVET_RENDER_CONTEXT_TYPE *)displayContext
playbackModuleDelegate:(id<PlaybackModuleDelegate>)playbackModuleDelegate {
    NSLog(@"PlaybackModule init<--");
    if (self = [super init]) {
        [self internalInitWithStream:stream initPosition:position displayContext:displayContext playbackModuleDelegate:playbackModuleDelegate];
    }
    NSLog(@"PlaybackModule init-->");
    return self;
}

- (void)internalInitWithStream:(CXiaoYingStream *)stream
                  initPosition:(int)position
                displayContext:(QVET_RENDER_CONTEXT_TYPE *)displayContext
        playbackModuleDelegate:(id<PlaybackModuleDelegate>)playbackModuleDelegate {
    playbackQueue = dispatch_queue_create("com.quvideo.xiaoying.playbackQueue", DISPATCH_QUEUE_SERIAL);
    playBackData = [[XYPlayerCallBackData alloc] init];
    mStream = stream;
    self.mplaybackModuleDelegate = playbackModuleDelegate;
    
    __block QVET_RENDER_CONTEXT_TYPE displayContextCopy = {0};
    MMemCpy(&displayContextCopy, displayContext, sizeof(QVET_RENDER_CONTEXT_TYPE));
    
    dispatch_sync(playbackQueue, ^{
        //Create player
        if (!mPlayer) {
            mPlayer = [[CXiaoYingPlayerSession alloc] init];
        }
        NSLog(@"Player init<--");
        __block MRESULT res = [mPlayer Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] SessionStateHandler:self];
        NSLog(@"Player init--> res=0x%x", res);
        //Set stream to player
        
        dispatch_sync_on_main_queue(^{
            NSLog(@"Player ActiveStream<--");
            res = [mPlayer setDisplayContext:&displayContextCopy];
            res = [mPlayer ActiveStream:mStream Position:position SeekFlag:MFalse];
            res = [mPlayer setProperty:AMVE_PROP_PLAYER_CALLBACK_DELTA Value:&kPlayerCallbackDelta];
            NSLog(@"Player ActiveStream--> res=0x%x", res);
        });
        
        
        //需要在ActiveStream完之后再设置
        
    });
    
    [self setVolumn:100];
}

- (void)unInit {
    NSLog(@"PlaybackModule unInit<--");
    dispatch_sync(playbackQueue, ^{
        isReady = NO;
        
        self.mplaybackModuleDelegate = nil;
        if (mPlayer) {
            NSLog(@"PlaybackModule unInit-->1");
            [mPlayer Pause];
            NSLog(@"PlaybackModule unInit-->2");
            [mPlayer DeActiveStream];
            NSLog(@"PlaybackModule unInit-->3");
            [mPlayer UnInit];
            NSLog(@"PlaybackModule unInit-->4");
            mPlayer = nil;
        }
        [self releaseStream];
    });
    NSLog(@"PlaybackModule unInit-->5");
    lastPlayerStatus = AMVE_PROCESS_STATUS_NONE;
    lastPlayerTime = 0;
}

- (void)finishOpengl {
    dispatch_sync(playbackQueue, ^{
        if (mPlayer) {
            MRESULT res = [mPlayer FinishOpenGL];
            if (res) {
                NSLog(@"FinishOpenGL error=0x%x", res);
            }
        }
    });
}

- (void)enterForeground {
    dispatch_sync(playbackQueue, ^{
        isInBackground = NO;
        //为了修复长时间停在后台（1分钟以上），再回到前台，画面不动问题
        if (self.lastSeekPosition >= 0) {
            [mPlayer SeekTo:self.lastSeekPosition+1];
            [mPlayer SeekTo:self.lastSeekPosition];
        }
    });
}

- (void)enterBackground {
    dispatch_sync(playbackQueue, ^{
        isInBackground = YES;
    });
}

- (SInt32)activeStream:(CXiaoYingStream *)stream Position:(int)position {
    __block MRESULT res = MERR_NONE;
    dispatch_async(playbackQueue, ^{
        isReady = YES;
        mStream = stream;
        res = [mPlayer ActiveStream:stream Position:position SeekFlag:MFalse];
        if (res) {
            NSLog(@"[ENGINE]XYPlaybackModule ActiveStream err=0x%x", res);
        }
        //需要在ActiveStream完之后再设置
        res = [mPlayer setProperty:AMVE_PROP_PLAYER_CALLBACK_DELTA Value:&kPlayerCallbackDelta];
    });
    return res;
}

- (SInt32)deactiveStream {
    __block MRESULT res = MERR_NONE;
    dispatch_async(playbackQueue, ^{
        isReady = NO;
        if (mPlayer) {
            int res = [mPlayer DeActiveStream];
            if (res) {
                NSLog(@"[ENGINE]XYPlaybackModule DeActiveStream err=0x%x", res);
            }
        }
    });
    return res;
}

- (void)releaseStream {
    if (mStream) {
        [mStream Close];
        mStream = nil;
    }
}

- (void)playWithOutShowLayer {
    if ([self isPlaying]) {
        return;
    }
    dispatch_async(playbackQueue, ^{
        if (!isReady) {
            return;
        }
        if (isInBackground) {
            return;
        }
        
        NSLog(@"==play");
        if (mPlayer) {
            [mPlayer Play];
        }
    });
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)play {
    if ([self isPlaying]) {
        return;
    }
    dispatch_async(playbackQueue, ^{
        if (!isReady) {
            return;
        }
        if (isInBackground) {
            return;
        }
        
        NSLog(@"==play");
        [mPlayer Play];
    });
    [self showLayer:-1
            IsShown:MTrue
     RefreshDisplay:MFalse];
    
    dispatch_async_on_main_queue(^{
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    });
}

/// 播放
/// @param async 是否异步播放
- (void)playAsync:(BOOL)async {
    if (async) {
        dispatch_async(playbackQueue, ^{
            [self innerPlay];
        });
    } else {
        dispatch_sync(playbackQueue, ^{
            [self innerPlay];
        });
    }
    
    dispatch_async_on_main_queue(^{
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    });
}

- (void)innerPlay {
    if (!isReady) {
        return;
    }
    if (isInBackground) {
        return;
    }
    
    if ([self isPlaying]) {
        return;
    }
    
    if (self.isDisablePlayAndSeek) {
        return;
    }
    
    NSLog(@"==play");
    [mPlayer Play];
}

- (void)pause {
    [self pause:NO];
}

- (void)pause:(BOOL)force {
    if (![self isPlaying] && !force) {
        return;
    }
    dispatch_sync(playbackQueue, ^{
        if (!isReady) {
            return;
        }
        if (isInBackground) {
            return;
        }
        NSLog(@"pause<--");
        
        if (mPlayer) {
            [mPlayer Pause];
        }
        NSLog(@"pause-->");
    });
    
    dispatch_async_on_main_queue(^{
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    });
}

- (void)stop {
    dispatch_async(playbackQueue, ^{
        if (!isReady) {
            return;
        }
        if (isInBackground) {
            return;
        }
        if (mPlayer) {
            [mPlayer Stop];
        }
    });
    dispatch_async_on_main_queue(^{
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    });
}

- (void)seekTo:(UInt32)iTime force:(BOOL)force {
    if (force) {
        [self seekTo:iTime force:YES async:NO];
    } else {
        [self seekTo:iTime force:NO async:YES];
    }
}

- (void)addToSeekPositionList:(NSInteger)seekPosition {
    [self.lock lock];
    [self.seekPositionList insertObject:@(seekPosition) atIndex:0];
    [self.lock unlock];
}

- (void)clearSeekPositionlist {
    [self.lock lock];
    [self.seekPositionList removeAllObjects];
    [self.lock unlock];
}

- (void)innerSeekTo {
    if (!isReady) {
        return;
    }
    if (isInBackground) {
        return;
    }
    if (self.isDisablePlayAndSeek) {
        return;
    }
    if (mPlayer) {
        if ([self.seekPositionList count]>0) {
            NSInteger seekPosition = [self.seekPositionList[0] integerValue];
            [self clearSeekPositionlist];
            if (self.lastSeekPosition == seekPosition) {
                return;
            }
            MRESULT res = [mPlayer SeekTo:seekPosition]; //SeekTo非关键帧seek，速度慢，但更精确; SyncSeekTo关键帧seek，速度快，但不精确
            NSLog(@"[ENGINE]XYPlaybackModule SeekTo %d err=0x%x", (unsigned int)seekPosition, res);
        }
       
    }
}

- (void)seekTo:(UInt32)iTime force:(BOOL)force async:(BOOL)async {
    [self seekTo:iTime force:force async:async block:nil];
}

- (void)seekTo:(UInt32)iTime force:(BOOL)force async:(BOOL)async block:(void (^)(void))block {
    if ([self isPlaying]) {
        return;
    }
    
    [self addToSeekPositionList:iTime];
    
    if (async) {
        dispatch_async(playbackQueue, ^{
            [self innerSeekTo];
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
        });
    } else {
        dispatch_async(playbackQueue, ^{
            [self innerSeekTo];
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
        });
    }
}

- (void)seekToPosition:(NSInteger)seekPosition async:(BOOL)async {
    if ([self isPlaying]) {
        return;
    }
    [self addToSeekPositionList:seekPosition];
    if (async) {
        dispatch_async(playbackQueue, ^{
            [self innerSeekTo];
        });
    } else {
        dispatch_sync(playbackQueue, ^{
            [self innerSeekTo];
        });
    }
}

- (BOOL)isPlaying {
    return lastPlayerStatus == AMVE_PROCESS_STATUS_RUNNING;
}

- (BOOL)isReady {
    return isReady;
}

- (BOOL)isInBackground {
    return isInBackground;
}

- (void)setVolumn:(MDWord)volumn {
    dispatch_async(playbackQueue, ^{
        if (mPlayer) {
            [mPlayer setVolume:volumn];
        }
    });
}

- (void)setPlayRange:(MDWord)startPos
              endPos:(MDWord)endPos
               async:(BOOL)async {
    if (async) {
        dispatch_async(playbackQueue, ^{
            [self innerSetPlayRange:startPos endPos:endPos];
        });
    } else {
        dispatch_sync(playbackQueue, ^{
            [self innerSetPlayRange:startPos endPos:endPos];
        });
    }
}

- (void)setPlayRange:(MDWord)startPos
              endPos:(MDWord)endPos {
    [self setPlayRange:startPos endPos:endPos async:YES];
}

- (void)innerSetPlayRange:(MDWord)startPos
                   endPos:(MDWord)endPos{
    if (mPlayer) {
        AMVE_POSITION_RANGE_TYPE playRange = {0};
        playRange.dwPos = startPos;
        playRange.dwLen = endPos - startPos;
        
        AMVE_POSITION_RANGE_TYPE oldPlayRange = {0};
        MRESULT res = [mPlayer getProperty:AMVE_PROP_PLAYER_RANGE Value:&oldPlayRange];
        
        if (oldPlayRange.dwPos != playRange.dwPos || oldPlayRange.dwLen != playRange.dwLen) {
            res = [mPlayer setProperty:AMVE_PROP_PLAYER_RANGE Value:&playRange];
            self.lastSeekPosition = -1;
            if (res) {
                NSLog(@"setPlayRange res=0x%x", res);
            }
        }
    }
}

- (void)showLayer:(MFloat)fLayerID
          IsShown:(MBool)bIsShown
   RefreshDisplay:(MBool)bRefreshDisplay {
    [self showLayer:fLayerID IsShown:bIsShown RefreshDisplay:bRefreshDisplay storyboard:[XYStoryboard sharedXYStoryboard]];
}

- (void)showLayer:(MFloat)fLayerID
          IsShown:(MBool)bIsShown
   RefreshDisplay:(MBool)bRefreshDisplay
       storyboard:(XYStoryboard *)storyboard {
    [XYStoryboardUtility showLayer:fLayerID IsShown:bIsShown storyboard:storyboard];
    if (bRefreshDisplay) {
        dispatch_async(playbackQueue, ^{
            if (isInBackground) {
                return;
            }
            [mPlayer displayRefresh];
        });
    }
}

- (void)getViewport:(MRECT *)prcViewport {
    [mPlayer getViewport:prcViewport];
}

- (void)setDisplayContext:(QVET_RENDER_CONTEXT_TYPE *)displayContext {
    __block QVET_RENDER_CONTEXT_TYPE displayContextCopy = {0};
    MMemCpy(&displayContextCopy, displayContext, sizeof(QVET_RENDER_CONTEXT_TYPE));
    
    dispatch_async(playbackQueue, ^{
        if (mPlayer) {
            if (isInBackground) {
                return;
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                MRESULT res = [mPlayer setDisplayContext:&displayContextCopy];
                if (res) {
                    NSLog(@"PlaybackModule setDisplayContext failed, res=0x%x", res);
                }
            });
        }
    });
}

- (void)displayRefresh {
    [self displayRefreshAsync:YES];
}

- (void)displayRefreshAsync:(BOOL)async {
    if (isRefreshing && async) {
        return;
    }
    if (async) {
        dispatch_async(playbackQueue, ^{
            [self innerDisplayRefresh:async];
        });
    } else {
        dispatch_sync(playbackQueue, ^{
            [self innerDisplayRefresh:async];
        });
    }
}

- (void)innerDisplayRefresh:(BOOL)async {
    if (mPlayer) {
        if (isInBackground) {
            return;
        }
        NSLog(@"Refresh Region");
        isRefreshing = YES;
        [mPlayer displayRefresh];
        isRefreshing = NO;
    }
}

- (void)refreshEffect:(CXiaoYingClip *)clip
               OpCode:(MDWord)opCode
               Effect:(CXiaoYingEffect *)effect
                async:(BOOL)async {
    if (async) {
        dispatch_async(playbackQueue, ^{
            if (isInBackground) {
                return;
            }
            [mPlayer RefreshStream:clip.hClip OpCode:opCode Effect:effect];
        });
    } else {
        dispatch_sync(playbackQueue, ^{
            if (isInBackground) {
                return;
            }
            [mPlayer RefreshStream:clip.hClip OpCode:opCode Effect:effect];
        });
    }
}

- (void)refreshEffect:(CXiaoYingClip *)clip
               OpCode:(MDWord)opCode
               Effect:(CXiaoYingEffect *)effect {
    [self refreshEffect:clip OpCode:opCode Effect:effect async:YES];
}

- (void)rebuildStream {
    dispatch_sync(playbackQueue, ^{
        if (isInBackground) {
            return;
        }
        MRESULT res = [mPlayer RefreshStream:nil OpCode:QVET_REFRESH_STREAM_OPCODE_REOPEN Effect:nil];
        if (res) {
            NSLog(@"PlaybackModule rebuildStream failed, res=0x%x", res);
        }
        self.lastSeekPosition = -1;
    });
}

- (void)setFrameSizeWidth:(MDWord)width height:(MDWord)height {
    dispatch_async(playbackQueue, ^{
        if (isInBackground) {
            return;
        }
        MSIZE frameSize = {width, height};
        [mPlayer setProperty:AMVE_PROP_PLAYER_STREAM_FRAME_SIZE Value:&frameSize];
    });
}

#pragma mark - AMVESessionStateDelegate
- (MDWord)AMVESessionStateCallBack:(AMVE_CBDATA_TYPE *)pCBData {
    NSLog(@"PlaybackModule AMVESessionStateCallBack %u errCode=0x%x time=%u", pCBData->dwStatus, pCBData->dwErrorCode, pCBData->dwCurTime);
    if (pCBData->hStream != (MHandle)mStream.hStream) {
        return 0;
    }
    
    if (!isReady) {
        isReady = (pCBData->dwStatus == AMVE_PROCESS_STATUS_READY);
    }
    
    if (playBackData.state == pCBData->dwStatus && playBackData.position == pCBData->dwCurTime && playBackData.duration == pCBData->dwDuration && playBackData.position == pCBData->dwDuration) {
        //Ignore the last same callback
        return 0;
    }
    
    lastPlayerStatus = pCBData->dwStatus;
    playBackData.state = lastPlayerStatus;
    playBackData.position = pCBData->dwCurTime;
    playBackData.duration = pCBData->dwDuration;
    playBackData.errCode = pCBData->dwErrorCode;
    self.lastSeekPosition = playBackData.position;
    
    if (self.mplaybackModuleDelegate) {
        [self.mplaybackModuleDelegate playbackStateCallBack:playBackData];
    }
    return 0;
}

- (void)refreshAudio {
    dispatch_async(playbackQueue, ^{
        [mPlayer performOperation:AMVE_PS_OP_REFRESH_AUDIO_EX param:nil];
    });
}

- (void)refreshAudioEffect {
    dispatch_async(playbackQueue, ^{
        [mPlayer performOperation:AMVE_PS_OP_REFRESH_AUDIO_EX param:nil];
    });
}


- (void)lockStuffUnderEffect:(CXiaoYingEffect *)effect async:(BOOL)async {
    if (async) {
        dispatch_async(playbackQueue, ^{
            [self innerLockStuffUnderEffect:effect];
        });
    } else {
        dispatch_sync(playbackQueue, ^{
            [self innerLockStuffUnderEffect:effect];
        });
    }
}

- (void)innerLockStuffUnderEffect:(CXiaoYingEffect *)effect {
    if (isInBackground) {
        return;
    }
    if (self.lockedEffect == effect) {
        return;
    }
    self.lockedEffect = effect;
    [mPlayer lockStuffUnderEffect:effect];
}

- (void)unlockStuffUnderEffect:(CXiaoYingEffect *)effect async:(BOOL)async{
    if (async) {
        dispatch_async(playbackQueue, ^{
            [self innerUnlockStuffUnderEffect:effect];
        });
    } else {
        dispatch_sync(playbackQueue, ^{
            [self innerUnlockStuffUnderEffect:effect];
        });
    }
}

- (void)innerUnlockStuffUnderEffect:(CXiaoYingEffect *)effect {
    if (isInBackground) {
        return;
    }
    if (self.lockedEffect) {
        [mPlayer unlockStuffUnderEffect:effect];
    }
    self.lockedEffect = nil;
}

- (NSMutableArray *)seekPositionList {
    if (!_seekPositionList) {
        _seekPositionList = [NSMutableArray array];
    }
    return _seekPositionList;
}

- (NSRecursiveLock *)lock {
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

@end
