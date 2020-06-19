//
//  XYSceneClipMgr.h
//  XiaoYingSDK
//
//  Created by xuxinyuan on 11/13/14.
//  Copyright (c) 2014 XiaoYing. All rights reserved.
//

#import "CXiaoYingSceneClip.h"
#import <Foundation/Foundation.h>

/**
 Editor真正的画中画镜头相关处理类，目前(2018.7.12)没有用到 
 */
@interface XYSceneClipMgr : NSObject

- (MRECT)getElementRegion:(MInt64)llTemplateID dwSourceIndex:(MDWord)dwSourceIndex;
+ (CXiaoYingStoryBoardSession *)createCXiaoYingStoryBoardSession;
+ (CXiaoYingSceneClip *)createSceneClip:(MInt64)llTemplateID
                             resolution:(CGSize)resolution
                          dwSourceIndex:(MDWord)dwSourceIndex
                          subStoryboard:(CXiaoYingStoryBoardSession *)subStoryboard;

- (void)setCurrentSceneClip:(CXiaoYingSceneClip *)sceneClip;
- (void)createSceneClip:(MInt64)llTemplateID
          dwSourceIndex:(MDWord)dwSourceIndex
          subStoryboard:()subStoryboard;
- (void)calculateMinDuration;
- (void)setSubStoryboardsTrimRangeSameAsDuration;
- (void)saveToMainStoryboard;

+ (CGSize)getStreamSizeWithLayoutFlag:(UInt64)templateLayoutFlag isHD:(BOOL)isHD;
+ (CGSize)getFitOutSize:(CGSize)srcSize destSize:(CGSize)destSize;
+ (CGSize)getFitInSize:(CGSize)srcSize destSize:(CGSize)destSize;

- (MDWord)getNormalClipCount;

@end
