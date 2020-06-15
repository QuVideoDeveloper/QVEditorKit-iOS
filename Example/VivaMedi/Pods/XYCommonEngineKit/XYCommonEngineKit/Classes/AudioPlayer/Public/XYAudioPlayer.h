//
//  XYAudioPlayer.h
//  XiaoYingSDK
//
//  Created by xuxinyuan on 9/15/14.
//  Copyright (c) 2014 XiaoYing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVPlayerItem;

/**
 系统AVFoundation音频播放相关封装类
 */
@interface XYAudioPlayer : NSObject

+ (XYAudioPlayer *)sharedInstance;

- (void)initPlayer;

- (void)initPlayer:(NSURL *)url;

- (void)uninitPlayer;

- (void)play:(NSURL *)url playToTheEndBlock:(void (^)(void))playToTheEndBlock;

- (void)removeAllItems;

- (void)pause;

- (void)resume;

- (void)resume:(NSURL *)url progress:(CGFloat)progress;

- (void)seek:(CGFloat)progress;

- (void)seekWithOutAutoPlay:(CGFloat)progress;

- (void)seekZero;

- (BOOL)isPlaying;

- (void)addTimerBlock:(void (^)(void))timerBlock;

- (float)getXYAudioPlayerCurrentTime;

- (float)getXYAudioPlayerCurrentTimeScale;

- (void)initPlayerWithPlayerItem:(AVPlayerItem *)playerItem;

- (void)resumeWithPlayerItem:(AVPlayerItem *)playerItem progress:(CGFloat)progress;

@end
