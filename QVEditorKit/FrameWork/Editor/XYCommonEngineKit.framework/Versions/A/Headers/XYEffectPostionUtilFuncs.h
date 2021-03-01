//
//  UtilFuncs.h
//  XiaoYing
//
//  Created by xuxinyuan on 1/13/14.
//  Copyright (c) 2014 XiaoYing Team. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 效果类模版（字幕，贴纸，特效，配乐，配音，画中画等）位置计算辅助类
 */
@interface XYEffectPostionUtilFuncs : NSObject

+ (NSMutableArray *)getStoryboardEffectDataInfos:(CXiaoYingStoryBoardSession *)storyboard
                                       trackType:(MDWord)trackType
                                         groupId:(MDWord)groupId;
+ (BOOL)validateEffects:(CXiaoYingStoryBoardSession *)storyboard
         effectInfoList:(NSMutableArray *)effectInfoList
                groupId:(MDWord)groupId
    dwLasteffectedClipIndex:(MDWord)dwLasteffectedClipIndex;
+ (BOOL)validateSubtitleEffects2:(CXiaoYingStoryBoardSession *)storyboard
                  effectInfoList:(NSMutableArray *)effectInfoList
                         groupId:(MDWord)groupId
         dwLasteffectedClipIndex:(MDWord)dwLasteffectedClipIndex;
+ (BOOL)updateBGMusicRange:(CXiaoYingStoryBoardSession *)storyboard
               effectIndex:(int)effectIndex
                     range:(AMVE_POSITION_RANGE_TYPE)range
                  isRepeat:(BOOL)isRepeat;
+ (MDWord)setBGMEffectFadeProp:(CXiaoYingEffect *)audioEffect
                  fadeDuration:(MDWord)fadeDuration;
+ (BOOL)updateEffectInfo:(CXiaoYingStoryBoardSession *)storyboard
          effectInfoList:(NSMutableArray *)effectInfoList
           trimClipIndex:(int)trimClipIndex
               posOffset:(int)posOffset;
+ (BOOL)updateEffectInfo:(CXiaoYingStoryBoardSession *)storyboard
          effectInfoList:(NSMutableArray *)effectInfoList
           trimClipIndex:(int)trimClipIndex
                oldScale:(float)oldScale
               timeScale:(float)timeScale;
+ (BOOL)adjustBGMRange:(CXiaoYingStoryBoardSession *)storyboard;
+ (MDWord)getRealVideoDuration:(CXiaoYingClip *)clip;
@end
