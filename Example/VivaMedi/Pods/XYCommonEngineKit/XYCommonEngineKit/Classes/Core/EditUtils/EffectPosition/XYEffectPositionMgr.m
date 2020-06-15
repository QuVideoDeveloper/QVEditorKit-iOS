//
//  EffectPositionManager.m
//  XiaoYing
//
//  Created by xuxinyuan on 1/10/14.
//  Copyright (c) 2014 XiaoYing Team. All rights reserved.
//

#import "XYEffectPositionMgr.h"
#import "XYEffectPostionUtilFuncs.h"
#import "XYStoryboard.h"

@interface XYEffectPositionMgr () {
	NSMutableArray *mBGMEffectInfoList;
	NSMutableArray *mDubEffectInfoList;
	NSMutableArray *mSubtitleEffectInfoList;
	NSMutableArray *mStickerEffectInfoList;
	NSMutableArray *mFXEffectInfoList;
	NSMutableArray *mCollageEffectInfoList;
    NSMutableArray *mMosaicEffectInfoList;
}

@end

@implementation XYEffectPositionMgr

+ (XYEffectPositionMgr *)sharedInstance {
	static XYEffectPositionMgr *effectPositionManager;
	static dispatch_once_t pred;
	dispatch_once(&pred, ^{
	  effectPositionManager = [[XYEffectPositionMgr alloc] init];
	});
	return effectPositionManager;
}

- (void)prepare {
	CXiaoYingStoryBoardSession *storyboard = [[XYStoryboard sharedXYStoryboard] getStoryboardSession];
	mBGMEffectInfoList = [XYEffectPostionUtilFuncs getStoryboardEffectDataInfos:storyboard trackType:AMVE_EFFECT_TRACK_TYPE_AUDIO groupId:GROUP_ID_BGMUSIC];
	mDubEffectInfoList = [XYEffectPostionUtilFuncs getStoryboardEffectDataInfos:storyboard trackType:AMVE_EFFECT_TRACK_TYPE_AUDIO groupId:GROUP_ID_DUBBING];
	mSubtitleEffectInfoList = [XYEffectPostionUtilFuncs getStoryboardEffectDataInfos:storyboard trackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_TEXT_FRAME];
	mStickerEffectInfoList = [XYEffectPostionUtilFuncs getStoryboardEffectDataInfos:storyboard trackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_STICKER];
	mFXEffectInfoList = [XYEffectPostionUtilFuncs getStoryboardEffectDataInfos:storyboard trackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_ANIMATED_FRAME];
	mCollageEffectInfoList = [XYEffectPostionUtilFuncs getStoryboardEffectDataInfos:storyboard trackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_ID_COLLAGE];
    mMosaicEffectInfoList = [XYEffectPostionUtilFuncs getStoryboardEffectDataInfos:storyboard trackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_ID_MOSAIC];
}

- (void)adjustEffects:(BOOL)isAdvBgm {
//	[self adjustEffects:INFINITY isAdvBgm:isAdvBgm];
}

- (void)adjustEffects:(UInt32)dwLasteffectedClipIndex isAdvBgm:(BOOL)isAdvBgm {
	CXiaoYingStoryBoardSession *storyboard = [[XYStoryboard sharedXYStoryboard] getStoryboardSession];

	if (!isAdvBgm) {
		[XYEffectPostionUtilFuncs adjustBGMRange:storyboard];
		[self checkEffects:YES dwLasteffectedClipIndex:dwLasteffectedClipIndex];
	} else {
		[self checkEffects:NO dwLasteffectedClipIndex:dwLasteffectedClipIndex];
	}
}

- (void)adjustEffectsAfterTrim:(int)trimClipIndex
                     posOffset:(int)posOffset
                      isAdvBgm:(BOOL)isAdvBgm {
	CXiaoYingStoryBoardSession *storyboard = [[XYStoryboard sharedXYStoryboard] getStoryboardSession];

	if (!isAdvBgm) {
		[XYEffectPostionUtilFuncs adjustBGMRange:storyboard];
		[self updateEffectInfoAfterTrim:trimClipIndex posOffset:posOffset bExceptBGM:YES];
		[self checkEffects:YES];
	} else {
		[self updateEffectInfoAfterTrim:trimClipIndex posOffset:posOffset bExceptBGM:NO];
		[self checkEffects:NO];
	}
}

- (void)adjustEffectsAfterAdjustedSpeed:(int)clipIndex
                           oldTimeScale:(float)oldTimeScale
                           newTimeScale:(float)newTimeScale
                               isAdvBgm:(BOOL)isAdvBgm {
	CXiaoYingStoryBoardSession *storyboard = [[XYStoryboard sharedXYStoryboard] getStoryboardSession];

	if (!isAdvBgm) {
		[XYEffectPostionUtilFuncs adjustBGMRange:storyboard];
		[self updateEffectInfoAfterSpeedAdjust:clipIndex oldScale:oldTimeScale timeScale:newTimeScale bExceptBGM:YES];
		[self checkEffects:YES];
	} else {
		[self updateEffectInfoAfterSpeedAdjust:clipIndex oldScale:oldTimeScale timeScale:newTimeScale bExceptBGM:NO];
		[self checkEffects:NO];
	}
}

- (BOOL)checkEffects:(BOOL)bExceptBGM {
	return [self checkEffects:bExceptBGM dwLasteffectedClipIndex:INFINITY];
}

- (BOOL)checkEffects:(BOOL)bExceptBGM dwLasteffectedClipIndex:(MDWord)dwLasteffectedClipIndex {
	CXiaoYingStoryBoardSession *storyboard = [[XYStoryboard sharedXYStoryboard] getStoryboardSession];
	if (!storyboard) {
		return NO;
	}
	BOOL result = NO;
	if (!bExceptBGM && mBGMEffectInfoList && [mBGMEffectInfoList count] > 0) {
		result = [XYEffectPostionUtilFuncs validateEffects:storyboard
		                                    effectInfoList:mBGMEffectInfoList
		                                           groupId:GROUP_ID_BGMUSIC
		                           dwLasteffectedClipIndex:dwLasteffectedClipIndex];
	}

	if (mDubEffectInfoList && [mDubEffectInfoList count] > 0) {
		result = result | [XYEffectPostionUtilFuncs validateEffects:storyboard
		                                             effectInfoList:mDubEffectInfoList
		                                                    groupId:GROUP_ID_DUBBING
		                                    dwLasteffectedClipIndex:dwLasteffectedClipIndex];
	}

	if (mSubtitleEffectInfoList && [mSubtitleEffectInfoList count] > 0) {
		result = result | [XYEffectPostionUtilFuncs validateSubtitleEffects2:storyboard
		                                                      effectInfoList:mSubtitleEffectInfoList
		                                                             groupId:GROUP_TEXT_FRAME
		                                             dwLasteffectedClipIndex:dwLasteffectedClipIndex];
	}

	if (mStickerEffectInfoList && [mStickerEffectInfoList count] > 0) {
		result = result | [XYEffectPostionUtilFuncs validateSubtitleEffects2:storyboard
		                                                      effectInfoList:mStickerEffectInfoList
		                                                             groupId:GROUP_STICKER
		                                             dwLasteffectedClipIndex:dwLasteffectedClipIndex];
	}

	if (mFXEffectInfoList && [mFXEffectInfoList count] > 0) {
		result = result | [XYEffectPostionUtilFuncs validateEffects:storyboard
		                                             effectInfoList:mFXEffectInfoList
		                                                    groupId:GROUP_ANIMATED_FRAME
		                                    dwLasteffectedClipIndex:dwLasteffectedClipIndex];
	}

	if (mCollageEffectInfoList && [mCollageEffectInfoList count] > 0) {
		result = result | [XYEffectPostionUtilFuncs validateSubtitleEffects2:storyboard
		                                                      effectInfoList:mCollageEffectInfoList
		                                                             groupId:GROUP_ID_COLLAGE
		                                             dwLasteffectedClipIndex:dwLasteffectedClipIndex];
	}
    
    if (mMosaicEffectInfoList && [mMosaicEffectInfoList count] > 0) {
        result = result | [XYEffectPostionUtilFuncs validateSubtitleEffects2:storyboard
                                                              effectInfoList:mMosaicEffectInfoList
                                                                     groupId:GROUP_ID_MOSAIC
                                                     dwLasteffectedClipIndex:dwLasteffectedClipIndex];
    }

	[self prepare];

	return result;
}

- (BOOL)updateEffectInfoAfterTrim:(int)trimClipIndex
                        posOffset:(int)posOffset
                       bExceptBGM:(BOOL)bExceptBGM {
	CXiaoYingStoryBoardSession *storyboard = [[XYStoryboard sharedXYStoryboard] getStoryboardSession];
	if (storyboard && trimClipIndex >= 0 && posOffset != 0) {
		if (!bExceptBGM && mBGMEffectInfoList && [mBGMEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard
			                            effectInfoList:mBGMEffectInfoList
			                             trimClipIndex:trimClipIndex
			                                 posOffset:posOffset];
		}

		if (mDubEffectInfoList && [mDubEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard
			                            effectInfoList:mDubEffectInfoList
			                             trimClipIndex:trimClipIndex
			                                 posOffset:posOffset];
		}

		if (mSubtitleEffectInfoList && [mSubtitleEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard
			                            effectInfoList:mSubtitleEffectInfoList
			                             trimClipIndex:trimClipIndex
			                                 posOffset:posOffset];
		}

		if (mStickerEffectInfoList && [mStickerEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard
			                            effectInfoList:mStickerEffectInfoList
			                             trimClipIndex:trimClipIndex
			                                 posOffset:posOffset];
		}

		if (mFXEffectInfoList && [mFXEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard
			                            effectInfoList:mFXEffectInfoList
			                             trimClipIndex:trimClipIndex
			                                 posOffset:posOffset];
		}

		if (mCollageEffectInfoList && [mCollageEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard
			                            effectInfoList:mCollageEffectInfoList
			                             trimClipIndex:trimClipIndex
			                                 posOffset:posOffset];
		}
        
        if (mMosaicEffectInfoList && [mMosaicEffectInfoList count] > 0) {
            [XYEffectPostionUtilFuncs updateEffectInfo:storyboard
                                        effectInfoList:mMosaicEffectInfoList
                                         trimClipIndex:trimClipIndex
                                             posOffset:posOffset];
        }

		return YES;
	}

	return NO;
}

- (BOOL)updateEffectInfoAfterSpeedAdjust:(int)trimClipIndex
                                oldScale:(float)oldScale
                               timeScale:(float)timeScale
                              bExceptBGM:(BOOL)bExceptBGM {
	CXiaoYingStoryBoardSession *storyboard = [[XYStoryboard sharedXYStoryboard] getStoryboardSession];
	if (storyboard && trimClipIndex >= 0) {
		if (!bExceptBGM && mBGMEffectInfoList && [mBGMEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard effectInfoList:mBGMEffectInfoList trimClipIndex:trimClipIndex oldScale:oldScale timeScale:timeScale];
		}

		if (mDubEffectInfoList && [mDubEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard effectInfoList:mDubEffectInfoList trimClipIndex:trimClipIndex oldScale:oldScale timeScale:timeScale];
		}

		if (mSubtitleEffectInfoList && [mSubtitleEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard effectInfoList:mSubtitleEffectInfoList trimClipIndex:trimClipIndex oldScale:oldScale timeScale:timeScale];
		}

		if (mStickerEffectInfoList && [mStickerEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard effectInfoList:mStickerEffectInfoList trimClipIndex:trimClipIndex oldScale:oldScale timeScale:timeScale];
		}

		if (mFXEffectInfoList && [mFXEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard effectInfoList:mFXEffectInfoList trimClipIndex:trimClipIndex oldScale:oldScale timeScale:timeScale];
		}

		if (mCollageEffectInfoList && [mCollageEffectInfoList count] > 0) {
			[XYEffectPostionUtilFuncs updateEffectInfo:storyboard effectInfoList:mCollageEffectInfoList trimClipIndex:trimClipIndex oldScale:oldScale timeScale:timeScale];
		}
        
        if (mMosaicEffectInfoList && [mMosaicEffectInfoList count] > 0) {
            [XYEffectPostionUtilFuncs updateEffectInfo:storyboard effectInfoList:mMosaicEffectInfoList trimClipIndex:trimClipIndex oldScale:oldScale timeScale:timeScale];
        }
        
		return YES;
	}

	return NO;
}

@end
