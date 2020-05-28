//
//  EffectPositionManager.h
//  XiaoYing
//
//  Created by xuxinyuan on 1/10/14.
//  Copyright (c) 2014 XiaoYing Team. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 效果类模版（字幕，贴纸，特效，配乐，配音，画中画等）位置计算类
 */
@interface XYEffectPositionMgr : NSObject

+ (XYEffectPositionMgr *)sharedInstance;

- (void)prepare;

//isAdvBgm表示是否进过高级配乐
- (void)adjustEffects:(BOOL)isAdvBgm;

- (void)adjustEffects:(UInt32)dwLasteffectedClipIndex
             isAdvBgm:(BOOL)isAdvBgm;

- (void)adjustEffectsAfterTrim:(int)trimClipIndex
                     posOffset:(int)posOffset
                      isAdvBgm:(BOOL)isAdvBgm;

- (void)adjustEffectsAfterAdjustedSpeed:(int)clipIndex
                           oldTimeScale:(float)oldTimeScale
                           newTimeScale:(float)newTimeScale
                               isAdvBgm:(BOOL)isAdvBgm;

- (BOOL)checkEffects:(BOOL)bExceptBGM;

- (BOOL)checkEffects:(BOOL)bExceptBGM dwLasteffectedClipIndex:(UInt32)dwLasteffectedClipIndex;

- (BOOL)updateEffectInfoAfterTrim:(int)trimClipIndex
                        posOffset:(int)posOffset
                       bExceptBGM:(BOOL)bExceptBGM;

- (BOOL)updateEffectInfoAfterSpeedAdjust:(int)trimClipIndex
                                oldScale:(float)oldScale
                               timeScale:(float)timeScale
                              bExceptBGM:(BOOL)bExceptBGM;
@end
