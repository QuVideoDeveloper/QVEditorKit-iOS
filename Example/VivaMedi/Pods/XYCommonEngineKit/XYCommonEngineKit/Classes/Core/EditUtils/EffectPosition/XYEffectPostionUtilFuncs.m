//
//  UtilFuncs.m
//  XiaoYing
//
//  Created by xuxinyuan on 1/13/14.
//  Copyright (c) 2014 XiaoYing Team. All rights reserved.
//

#import "XYEffectPostionUtilFuncs.h"
#import "XYEditUtils.h"
#import "XYStoryboardUtility.h"
#import "XYEffectPositionDataModel.h"
#import "XYStoryboard+XYEffect.h"
#import "XYStoryboard+XYClip.h"
#import "XYStoryboard.h"

@implementation XYEffectPostionUtilFuncs

+ (NSMutableArray *)getStoryboardEffectDataInfos:(CXiaoYingStoryBoardSession *)storyboard
                                       trackType:(MDWord)trackType
                                         groupId:(MDWord)groupId {
	MRESULT res = MERR_NONE;
	NSMutableArray *effectDataList = [[NSMutableArray alloc] init];
	if (!storyboard) {
		return effectDataList;
	}
	if (storyboard) {
		CXiaoYingClip *clip = [storyboard getDataClip];
		if (clip) {
			int effectCount = [clip getEffectCount:trackType GroupID:groupId];
			if (effectCount > 0) {
				for (int i = 0; i < effectCount; i++) {
					CXiaoYingEffect *effect = [clip getEffect:trackType GroupID:groupId EffectIndex:i];
					if (effect) {
						XYEffectPositionDataModel *model = [[XYEffectPositionDataModel alloc] init];
						model.mEffectIndex = i;
						AMVE_POSITION_RANGE_TYPE srcRange = {0};
						AMVE_POSITION_RANGE_TYPE destRange = {0};
						QVET_CLIP_POSITION clipPostion = {0};
						if (trackType == AMVE_EFFECT_TRACK_TYPE_AUDIO) {
							res = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE PropertyData:&srcRange];
							res = [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&destRange];
						} else if (trackType == AMVE_EFFECT_TRACK_TYPE_VIDEO) {
							res = [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&destRange];
						}
						[storyboard getClipPositionByTime:destRange.dwPos
						                      ClipPositon:&clipPostion];
						model.mClipPosition = clipPostion;
						model.mSrcRange = srcRange;
						model.mDestRange = destRange;

						if (model) {
							[effectDataList addObject:model];
						}
					}
				}
			}
		}
	}

	return effectDataList;
}

+ (BOOL)validateEffects:(CXiaoYingStoryBoardSession *)storyboard
         effectInfoList:(NSMutableArray *)effectInfoList
                groupId:(MDWord)groupId
    dwLasteffectedClipIndex:(MDWord)dwLasteffectedClipIndex {
	if (storyboard && effectInfoList && [effectInfoList count] > 0) {
		int clipCount = [storyboard getClipCount];
		NSMutableArray *mNeedDeleteBGMIndexList = [[NSMutableArray alloc] init];
		NSMutableArray *cacheEffectDataList = [NSMutableArray arrayWithArray:effectInfoList];
		if (clipCount > 0) {
			MDWord duration = [storyboard getDuration];
			NSArray *sortedArray = [cacheEffectDataList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
			  NSNumber *first = [NSNumber numberWithUnsignedLong:[(XYEffectPositionDataModel *)a mDestRange].dwPos];
			  NSNumber *second = [NSNumber numberWithUnsignedLong:[(XYEffectPositionDataModel *)b mDestRange].dwPos];
			  return [second compare:first];
			}];
			cacheEffectDataList = [NSMutableArray arrayWithArray:sortedArray];
			MDWord limitPosInStoryBoard = duration;
			MDWord limitPosInStoryBoardAfterAdjust = 0;
			// update
			for (XYEffectPositionDataModel *model in cacheEffectDataList) {
				MDWord posInStoryboard = 0;
				QVET_CLIP_POSITION clipPostion = model.mClipPosition;
				MRESULT res = [storyboard getTimeByClipPosition:&clipPostion Timestamp:&posInStoryboard];
				MDWord clipIndex = 0;
				[storyboard getIndexByClipPosition:&clipPostion ClipIndex:&clipIndex];

				AMVE_POSITION_RANGE_TYPE destRange = model.mDestRange;
				MDWord startPos = destRange.dwPos;
				MDWord len = destRange.dwLen;
				if (res) {
					if (destRange.dwPos >= limitPosInStoryBoard) {
						// TODO delete the bgm
						[mNeedDeleteBGMIndexList addObject:[NSNumber numberWithInt:model.mEffectIndex]];
					} else {

						if (destRange.dwPos + destRange.dwLen > limitPosInStoryBoard) {
							len = limitPosInStoryBoard - startPos;
							destRange.dwLen = len;
						}
						if (groupId == GROUP_ID_DUBBING) {
							[self updateDubEffectRange:storyboard effectIndex:model.mEffectIndex range:destRange];
						} else if (groupId == GROUP_ID_BGMUSIC) {
							BOOL isRepeat = len > model.mSrcRange.dwLen ? YES : NO;
							[self updateBGMusicRange:storyboard effectIndex:model.mEffectIndex range:destRange isRepeat:isRepeat];
						} else {
							CXiaoYingEffect *effect = [self getStoryBoardEffect:storyboard effectIndex:model.mEffectIndex groupId:groupId];
							[self updateEffectRange:effect range:destRange];
                            [self updateEffectKeyFrameWithEffect:effect groupId:groupId];
						}
						limitPosInStoryBoard = destRange.dwPos;
						if (clipIndex <= dwLasteffectedClipIndex && limitPosInStoryBoardAfterAdjust < (destRange.dwPos + destRange.dwLen)) {
							limitPosInStoryBoardAfterAdjust = (destRange.dwPos + destRange.dwLen);
						}
					}
				} else {
					startPos = posInStoryboard;
					if (startPos >= limitPosInStoryBoard) {
						if (startPos + len < limitPosInStoryBoardAfterAdjust || limitPosInStoryBoardAfterAdjust >= duration) {
							[mNeedDeleteBGMIndexList addObject:[NSNumber numberWithInt:model.mEffectIndex]];
						} else {
							if (startPos < limitPosInStoryBoardAfterAdjust) {
								startPos = limitPosInStoryBoardAfterAdjust;
							}
							if (duration - startPos < len) {
								len = duration - startPos;
							}
							destRange.dwPos = startPos;
							destRange.dwLen = len;

							if (groupId == GROUP_ID_DUBBING) {
								[self updateDubEffectRange:storyboard effectIndex:model.mEffectIndex range:destRange];
							} else if (groupId == GROUP_ID_BGMUSIC) {
								BOOL isRepeat = len > model.mSrcRange.dwLen ? YES : NO;
								[self updateBGMusicRange:storyboard effectIndex:model.mEffectIndex range:destRange isRepeat:isRepeat];
							} else {
								CXiaoYingEffect *effect = [self getStoryBoardEffect:storyboard effectIndex:model.mEffectIndex groupId:groupId];
								[self updateEffectRange:effect range:destRange];
                                [self updateEffectKeyFrameWithEffect:effect groupId:groupId];
							}

							if (clipIndex <= dwLasteffectedClipIndex && limitPosInStoryBoardAfterAdjust < (destRange.dwPos + destRange.dwLen)) {
								limitPosInStoryBoardAfterAdjust = (destRange.dwPos + destRange.dwLen);
							}
						}
					} else {
						if (startPos + len > limitPosInStoryBoard) {
							len = limitPosInStoryBoard - startPos;
						}
						destRange.dwPos = startPos;
						destRange.dwLen = len;
						if (groupId == GROUP_ID_DUBBING) {
							[self updateDubEffectRange:storyboard effectIndex:model.mEffectIndex range:destRange];
						} else if (groupId == GROUP_ID_BGMUSIC) {
							BOOL isRepeat = len > model.mSrcRange.dwLen ? YES : NO;
							[self updateBGMusicRange:storyboard effectIndex:model.mEffectIndex range:destRange isRepeat:isRepeat];
						} else {
							CXiaoYingEffect *effect = [self getStoryBoardEffect:storyboard effectIndex:model.mEffectIndex groupId:groupId];
							[self updateEffectRange:effect range:destRange];
                            [self updateEffectKeyFrameWithEffect:effect groupId:groupId];
						}
						limitPosInStoryBoard = destRange.dwPos;
						if (clipIndex <= dwLasteffectedClipIndex && limitPosInStoryBoardAfterAdjust < (destRange.dwPos + destRange.dwLen)) {
							limitPosInStoryBoardAfterAdjust = (destRange.dwPos + destRange.dwLen);
						}
					}
				}
			}
		} else {
			// delete all bgm. delete should from big index to small index.
			for (XYEffectPositionDataModel *model in cacheEffectDataList) {
				[mNeedDeleteBGMIndexList addObject:[NSNumber numberWithInt:model.mEffectIndex]];
			}
		}

		NSArray *sortedArray = [mNeedDeleteBGMIndexList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		  NSNumber *first = a;
		  NSNumber *second = b;
		  return [second compare:first];
		}];
		mNeedDeleteBGMIndexList = [NSMutableArray arrayWithArray:sortedArray];

		for (NSNumber *effectIndex in mNeedDeleteBGMIndexList) {
			if (groupId == GROUP_ID_DUBBING) {
				[self delDunbi:storyboard clipIndex:0 dunbiIndex:[effectIndex intValue] isEffectInStoryboard:YES];
			} else if (groupId == GROUP_ID_BGMUSIC) {
				[self delStoryboardBGMusic:storyboard bgmEffectIndex:[effectIndex intValue]];
			} else {
				[self delStoryboardEffect:storyboard effectIndex:[effectIndex intValue] groupID:groupId];
			}
		}
		return YES;
	}

	return NO;
}

/**
 * <p>
 * 逻辑上可以允许字幕重叠。
 * </p>
 * @param effectInfoList
 * @param storyboard
 * @param groupId
 * @param effectedLastClipIndex
 * @return
 */
+ (BOOL)validateSubtitleEffects2:(CXiaoYingStoryBoardSession *)storyboard
                  effectInfoList:(NSMutableArray *)effectInfoList
                         groupId:(MDWord)groupId
         dwLasteffectedClipIndex:(MDWord)dwLasteffectedClipIndex {
	if (storyboard && effectInfoList && [effectInfoList count] > 0) {
		int clipCount = [storyboard getClipCount];
		NSMutableArray *mNeedDeleteBGMIndexList = [[NSMutableArray alloc] init];
		NSMutableArray *cacheEffectDataList = [NSMutableArray arrayWithArray:effectInfoList];
		if (clipCount > 0) {
			int duration = [storyboard getDuration];
			// check from right position on the old timeline.
			NSArray *sortedArray = [cacheEffectDataList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
			  NSNumber *first = [NSNumber numberWithUnsignedLong:[(XYEffectPositionDataModel *)a mDestRange].dwPos];
			  NSNumber *second = [NSNumber numberWithUnsignedLong:[(XYEffectPositionDataModel *)b mDestRange].dwPos];
			  return [second compare:first];
			}];
			cacheEffectDataList = [NSMutableArray arrayWithArray:sortedArray];
			// update
			for (XYEffectPositionDataModel *model in cacheEffectDataList) {
				MDWord posInStoryboard = 0;
				QVET_CLIP_POSITION clipPostion = model.mClipPosition;
				MRESULT res = [storyboard getTimeByClipPosition:&clipPostion Timestamp:&posInStoryboard];
				AMVE_POSITION_RANGE_TYPE destRange = model.mDestRange;
				MDWord startPos = destRange.dwPos;
				MDWord len = destRange.dwLen;
				if (res) {
					if (destRange.dwPos >= duration) {
						// delete the effect
						[mNeedDeleteBGMIndexList addObject:@(model.mEffectIndex)];
					} else {
						if (destRange.dwPos + destRange.dwLen > duration) {
							len = duration - startPos;
							destRange.dwLen = len;
						}
						CXiaoYingEffect *effect = [self getStoryBoardEffect:storyboard effectIndex:model.mEffectIndex groupId:groupId];
						[self updateEffectRange:effect range:destRange];
                        [self updateEffectKeyFrameWithEffect:effect groupId:groupId];
					}
				} else {
					startPos = posInStoryboard;
					if (startPos >= duration) {
						[mNeedDeleteBGMIndexList addObject:@(model.mEffectIndex)];
					} else {
						if (startPos + len > duration) {
							len = duration - startPos;
						}
						destRange.dwPos = startPos;
						destRange.dwLen = len;
						CXiaoYingEffect *effect = [self getStoryBoardEffect:storyboard effectIndex:model.mEffectIndex groupId:groupId];
						[self updateEffectRange:effect range:destRange];
                        [self updateEffectKeyFrameWithEffect:effect groupId:groupId];
					}
				}
			}
		} else {
			// delete all bgm. delete should from big index to small index.
			for (XYEffectPositionDataModel *model in cacheEffectDataList) {
				[mNeedDeleteBGMIndexList addObject:[NSNumber numberWithInt:model.mEffectIndex]];
			}
		}

		NSArray *sortedArray = [mNeedDeleteBGMIndexList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
		  NSNumber *first = a;
		  NSNumber *second = b;
		  return [second compare:first];
		}];
		mNeedDeleteBGMIndexList = [NSMutableArray arrayWithArray:sortedArray];

		for (NSNumber *effectIndex in mNeedDeleteBGMIndexList) {
			[self delStoryboardEffect:storyboard effectIndex:[effectIndex intValue] groupID:groupId];
		}
		return YES;
	}

	return NO;
}


#pragma mark - KeyFrame关键帧
//根据当前effect的range重新设置effect上的关键帧
+ (void)updateEffectKeyFrameWithEffect:(CXiaoYingEffect *)effect groupId:(MDWord)groupID {
    if (groupID == GROUP_TEXT_FRAME || groupID == GROUP_STICKER || groupID == GROUP_ID_MOSAIC || groupID == GROUP_ID_COLLAGE) {
        CXiaoYingKeyFrameTransformData *otr_data = [effect getKeyFrameTransformData];
        if (otr_data && otr_data.values.count > 0) { //effect上有关键帧
            int keyFrameCount = otr_data.values.count;
            NSMutableArray *cArray = [NSMutableArray new];
//            [copyArray enumerateObjectsUsingBlock:^(XYVivaFramebarKeyFrameImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (obj.model.keyFrameTS < self.currentEffectModel.range.dwPos) {
//                    [self.keyFramesArray removeObject:obj];
//                }
//                if (obj.model.keyFrameTS > self.currentEffectModel.range.dwPos + self.currentEffectModel.range.dwLen) {
//                    [self.keyFramesArray removeObject:obj];
//                }
//            }];
//            if (keyFrameCount != self.keyFramesArray.count) {
//                [self updateKeyFrameInfoToStoryBoard];
//            }
            
            AMVE_POSITION_RANGE_TYPE range = {0};
            [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&range];
            
            [otr_data.values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CXiaoYingKeyFrameTransformValue *value = (CXiaoYingKeyFrameTransformValue *)obj;
                
                MDWord curLeyFrameTS = value->ts + range.dwPos;
                if (curLeyFrameTS > range.dwPos && curLeyFrameTS < range.dwPos + range.dwLen) {
                    [cArray addObject:value];
                }
            }];
            
            CXiaoYingKeyFrameTransformData* tr_data = [[CXiaoYingKeyFrameTransformData alloc] init];
            
            tr_data.values = [cArray copy];
            
            MRESULT res = [effect setKeyFrameTransformData:tr_data];
        }
    }
}

#pragma mark - BGM related
+ (BOOL)delStoryboardBGMusic:(CXiaoYingStoryBoardSession *)storyboard
              bgmEffectIndex:(int)bgmEffectIndex {
	if (storyboard) {
		CXiaoYingClip *clip = [storyboard getDataClip];
		if (clip) {
			MDWord bgmCount = [clip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC];
			if (bgmCount > 0 && bgmEffectIndex >= 0 && bgmEffectIndex < bgmCount) {
				CXiaoYingEffect *oldEffect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC EffectIndex:bgmEffectIndex];

				if (oldEffect) {
					MRESULT ires = [clip removeEffect:oldEffect];
					if (ires == QVET_ERR_NONE) {
						[oldEffect Destory];
					}
				}
			}
		}
	}
	return YES;
}

+ (BOOL)updateBGMusicRange:(CXiaoYingStoryBoardSession *)storyboard
               effectIndex:(int)effectIndex
                     range:(AMVE_POSITION_RANGE_TYPE)range
                  isRepeat:(BOOL)isRepeat {
	if (storyboard) {
		CXiaoYingClip *clip = [storyboard getDataClip];
		if (clip) {
			int bgmCount = [clip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC];
			if (bgmCount > 0 && effectIndex >= 0 && effectIndex < bgmCount) {
				CXiaoYingEffect *oldEffect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC EffectIndex:effectIndex];
				if (oldEffect) {
					AMVE_POSITION_RANGE_TYPE qrange = {range.dwPos,
					                                   range.dwLen};
					MRESULT res = [oldEffect setProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&qrange];
					if (res != MERR_NONE) {
						return NO;
					}

					//修改bgm range后，需要设置对齐方式为QVET_TIME_POSITION_ALIGNMENT_MODE_START
					MDWord align = QVET_TIME_POSITION_ALIGNMENT_MODE_START;
					res = [oldEffect setProperty:AMVE_PROP_EFFECT_POSITION_ALIGNMENT PropertyData:&align];

					MDWord iRepeatMode = isRepeat ? AMVE_AUDIO_FRAME_MODE_REPEAT
					                              : AMVE_AUDIO_FRAME_MODE_NORMAL;
					res = [oldEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_REPEAT_MODE PropertyData:&iRepeatMode];
					//                    if (res != MERR_NONE) {
					//                        return NO;
					//                    }

					MDWord fadeDuration = 0;

					if (range.dwLen > 1000 && range.dwLen <= 3000) {
						fadeDuration = 500;
					}
					if (range.dwLen > 3000) {
						fadeDuration = 1000;
					}

					res = [self setBGMEffectFadeProp:oldEffect fadeDuration:fadeDuration];
					if (res != QVET_ERR_NONE) {
						[clip removeEffect:oldEffect];
						[oldEffect Destory];
						return NO;
					}
					return YES;
				}
			}
		}
	}
	return NO;
}

+ (MDWord)setBGMEffectFadeProp:(CXiaoYingEffect *)audioEffect
                  fadeDuration:(MDWord)fadeDuration {
	MDWord iRes = 0;
	AMVE_FADE_PARAM_TYPE fadeIn = {0};
	fadeIn.dwStartPercent = 0;
	fadeIn.dwEndPercent = 100;
	fadeIn.dwDuration = fadeDuration;
	iRes = [audioEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_FADEIN PropertyData:&fadeIn];
	if (iRes != QVET_ERR_NONE) {
		return QVET_ERR_APP_FAIL;
	}

	AMVE_FADE_PARAM_TYPE fadeOut = {0};
	fadeOut.dwStartPercent = 100;
	fadeOut.dwEndPercent = 0;
	fadeOut.dwDuration = fadeDuration;
	iRes = [audioEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_FADEOUT PropertyData:&fadeOut];
	if (iRes != QVET_ERR_NONE) {
		return QVET_ERR_APP_FAIL;
	}

	return QVET_ERR_NONE;
}

+ (BOOL)updateEffectInfo:(CXiaoYingStoryBoardSession *)storyboard
          effectInfoList:(NSMutableArray *)effectInfoList
           trimClipIndex:(int)trimClipIndex
               posOffset:(int)posOffset {
	if (storyboard && effectInfoList && [effectInfoList count] > 0 && trimClipIndex >= 0) {
		for (XYEffectPositionDataModel *model in effectInfoList) {
			MDWord clipIndex = 0;
			QVET_CLIP_POSITION clipPostion = model.mClipPosition;
			[storyboard getIndexByClipPosition:&clipPostion ClipIndex:&clipIndex];
			if (trimClipIndex == clipIndex) {
				QVET_CLIP_POSITION clipPos = model.mClipPosition;
				if (posOffset > clipPos.dwPosition) {
					clipPos.dwPosition = 0;
				} else {
					clipPos.dwPosition = clipPos.dwPosition - posOffset;
				}
				model.mClipPosition = clipPos;
			}
		}
	}
	return NO;
}

+ (BOOL)updateEffectInfo:(CXiaoYingStoryBoardSession *)storyboard
          effectInfoList:(NSMutableArray *)effectInfoList
           trimClipIndex:(int)trimClipIndex
                oldScale:(float)oldScale
               timeScale:(float)timeScale {
	if (storyboard && effectInfoList && [effectInfoList count] > 0 && trimClipIndex >= 0) {
		for (XYEffectPositionDataModel *model in effectInfoList) {
			QVET_CLIP_POSITION clipPosition = model.mClipPosition;
			MDWord clipIndex = 0;
			MRESULT res = [storyboard getIndexByClipPosition:&clipPosition ClipIndex:&clipIndex];
			if (trimClipIndex == clipIndex) {
				MDWord rawPos = [XYEditUtils timeScaledDurationToOriginalDuration:clipPosition.dwPosition timeScale:oldScale];
				clipPosition.dwPosition = [XYEditUtils originalDurationToTimeScaledDuration:rawPos timeScale:timeScale];
				model.mClipPosition = clipPosition;
			}
		}
	}
	return NO;
}

+ (BOOL)adjustBGMRange:(CXiaoYingStoryBoardSession *)storyboard {
	if (!storyboard) {
		return NO;
	}
	CXiaoYingClip *clip = [storyboard getDataClip];
	if (!clip)
		return NO;
	MDWord bgmCount = [clip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC];
	if (bgmCount != 1)
		return NO;
	MDWord startPos = 0;
	MDWord endPos = [storyboard getDuration];
	if ([XYStoryboardUtility isThemeApplyed:storyboard]) {
		if ([self isFrontCoverExist:storyboard]) {
			CXiaoYingCover *frontCover = [[XYStoryboard sharedXYStoryboard] getCover:AMVE_PROP_STORYBOARD_THEME_COVER];
			if (frontCover && [self isCoverHasAudio:frontCover]) {
				//cover时长不能简单和transition时长相加。改为第一个镜头开始显示时间
				AMVE_POSITION_RANGE_TYPE clipRange = [[XYStoryboard sharedXYStoryboard] getClipTrimRangeByIndex:1];
				startPos = clipRange.dwPos;
			}
		}

		if ([self isBackCoverExist:storyboard]) {
			CXiaoYingCover *backCover = [[XYStoryboard sharedXYStoryboard] getCover:AMVE_PROP_STORYBOARD_THEME_BACK_COVER];
			if (backCover && [self isCoverHasAudio:backCover]) {
				MDWord clipCount = [XYStoryboardUtility getUnRealClipCount:[XYStoryboard sharedXYStoryboard]];
				if (clipCount > 1) {
					AMVE_POSITION_RANGE_TYPE clipRange = [[XYStoryboard sharedXYStoryboard] getClipTrimRangeByIndex:clipCount - 2];
					MDWord dwPos = clipRange.dwPos;
					MDWord dwLen = clipRange.dwLen;
					endPos = dwPos + dwLen;
				}
			}
		}
	}

	if (endPos < 0x7fffffff && startPos < 0x7fffffff && endPos > startPos) {
		CXiaoYingEffect *effect = [[XYStoryboard sharedXYStoryboard] getStoryboardEffectByIndex:0 dwTrackType:AMVE_EFFECT_TRACK_TYPE_AUDIO groupId:GROUP_ID_BGMUSIC];
		MBool bAddByTheme = MFalse;
		[effect getProperty:AMVE_PROP_EFFECT_ADDEDBYTHEME PropertyData:&bAddByTheme];
		if (bAddByTheme == MTrue) {
			return NO;
		}
		AMVE_POSITION_RANGE_TYPE range = {startPos, endPos - startPos};
		[self updateBGMusicRange:storyboard effectIndex:0 range:range isRepeat:YES];
	}
	return YES;
}

#pragma mark - Dub related
+ (MDWord)updateDubEffectRange:(CXiaoYingStoryBoardSession *)storyboard
                   effectIndex:(int)effectIndex
                         range:(AMVE_POSITION_RANGE_TYPE)range {
	if (storyboard && effectIndex >= 0) {
		CXiaoYingClip *clip = [storyboard getDataClip];
		if (clip) {
			CXiaoYingEffect *dunbiEffect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_DUBBING EffectIndex:effectIndex];
			AMVE_POSITION_RANGE_TYPE destRange = {range.dwPos,
			                                      range.dwLen};
			if (dunbiEffect) {
				MDWord iRes = [dunbiEffect setProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&destRange];
				if (iRes != QVET_ERR_NONE) {
					return QVET_ERR_APP_FAIL;
				}
				return QVET_ERR_NONE;
			}
		}
	}
	return QVET_ERR_APP_FAIL;
}

+ (MDWord)delDunbi:(CXiaoYingStoryBoardSession *)storyboard
               clipIndex:(int)clipIndex
              dunbiIndex:(int)dunbiIndex
    isEffectInStoryboard:(BOOL)isEffectInStoryboard {
	CXiaoYingClip *clip;
	if (isEffectInStoryboard) {
		clip = [storyboard getDataClip];
	} else {
		clip = [self getUnRealClip:storyboard iIndex:clipIndex];
	}
	if (clip) {
		int totalDunbi = [self getClipDunbiCount:clip];
		if (dunbiIndex < totalDunbi && dunbiIndex >= 0) {

			CXiaoYingEffect *oldEffect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_DUBBING EffectIndex:dunbiIndex];

			if (oldEffect) {
				MRESULT ires = [clip removeEffect:oldEffect];
				if (ires == QVET_ERR_NONE) {
					[oldEffect Destory];
					return QVET_ERR_NONE;
				}
			}
		}
	}
	return QVET_ERR_APP_FAIL;
}

+ (MDWord)getClipDunbiCount:(CXiaoYingClip *)clip {
	if (clip) {
		return [clip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_DUBBING];
	}
	return 0;
}

#pragma mark - Utils
+ (CXiaoYingClip *)getUnRealClip:(CXiaoYingStoryBoardSession *)storyboard
                          iIndex:(int)iIndex {
	if (storyboard) {
		MDWord clipCount = [storyboard getClipCount];
		if ([XYStoryboardUtility isThemeApplyed:storyboard]) {
			if ([self isFrontCoverExist:storyboard] && 0 == iIndex) {
				return [[XYStoryboard sharedXYStoryboard] getCover:AMVE_PROP_STORYBOARD_THEME_COVER];
			} else if ([self isBackCoverExist:storyboard] && iIndex > clipCount) {
				return [[XYStoryboard sharedXYStoryboard] getCover:AMVE_PROP_STORYBOARD_THEME_BACK_COVER];
			} else {
				int index = iIndex;
				if ([self isFrontCoverExist:storyboard])
					index--;
				return [storyboard getClip:index];
			}
		} else if (iIndex >= 0 && iIndex < clipCount) {
			return [storyboard getClip:iIndex];
		}
	}
	return nil;
}

+ (BOOL)isFrontCoverExist:(CXiaoYingStoryBoardSession *)storyboard {
	if (storyboard) {
		MHandle hClip = MNull;
		[storyboard getProperty:AMVE_PROP_STORYBOARD_THEME_COVER Value:&hClip];
		if (hClip != MNull) {
			return YES;
		}
	}
	return NO;
}

+ (BOOL)isBackCoverExist:(CXiaoYingStoryBoardSession *)storyboard {
	if (storyboard) {
		MHandle hClip = MNull;
		[storyboard getProperty:AMVE_PROP_STORYBOARD_THEME_COVER Value:&hClip];
		if (hClip != MNull) {
			return YES;
		}
	}
	return NO;
}

+ (BOOL)isCoverHasAudio:(CXiaoYingClip *)clip {
	if (clip) {
		AMVE_VIDEO_INFO_TYPE videoinfo = {0};
		MRESULT res = [clip getProperty:AMVE_PROP_CLIP_SOURCE_INFO PropertyData:(MVoid *)&videoinfo];
		MDWord type = 0;
		[clip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&type];

		MDWord duration = videoinfo.dwAudioDuration;
		return duration > 0 && type == AMVE_VIDEO_CLIP;
	}
	return NO;
}

+ (MDWord)updateEffectRange:(CXiaoYingEffect *)effect
                      range:(AMVE_POSITION_RANGE_TYPE)range {
	AMVE_POSITION_RANGE_TYPE destRange = {range.dwPos,
	                                      range.dwLen};
	if (effect) {
		MDWord iRes = [effect setProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&destRange];
		if (iRes != QVET_ERR_NONE) {
			return QVET_ERR_APP_FAIL;
		}
	}
    
	return QVET_ERR_NONE;
}

+ (CXiaoYingEffect *)getStoryBoardEffect:(CXiaoYingStoryBoardSession *)storyboard
                             effectIndex:(int)effectIndex
                                 groupId:(int)groupId {
	if (storyboard) {
		CXiaoYingClip *clip = [storyboard getDataClip];
		if (clip) {
			CXiaoYingEffect *effect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:groupId EffectIndex:effectIndex];
			return effect;
		}
	}
	return nil;
}

+ (BOOL)delStoryboardEffect:(CXiaoYingStoryBoardSession *)storyboard
                effectIndex:(int)effectIndex
                    groupID:(MDWord)groupID {
	if (storyboard) {
		CXiaoYingClip *clip = [storyboard getDataClip];
		if (clip) {
			MDWord iRes = [self delClipEffect:clip index:effectIndex groupID:groupID];
			if (iRes != QVET_ERR_NONE) {
				return NO;
			}
			return YES;
		}
	}
	return NO;
}

+ (MDWord)delClipEffect:(CXiaoYingClip *)clip
                  index:(int)index
                groupID:(MDWord)groupID {
	CXiaoYingEffect *effect = [self getClipEffect:clip index:index groupID:groupID];
	if (effect) {
		[clip removeEffect:effect];
		[effect Destory];
	}
	return QVET_ERR_NONE;
}

+ (CXiaoYingEffect *)getClipEffect:(CXiaoYingClip *)clip
                             index:(int)index
                           groupID:(MDWord)groupID {
	if (!clip || index < 0)
		return nil;
	CXiaoYingEffect *effect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:groupID EffectIndex:index];
	return effect;
}

+ (MDWord)getRealVideoDuration:(CXiaoYingClip *)clip {
	MDWord duration = 0;
	AMVE_VIDEO_INFO_TYPE videoinfo = {0};
	[clip getProperty:AMVE_PROP_CLIP_SOURCE_INFO
	     PropertyData:(MVoid *)&videoinfo];

	float timescale = 0;
	[clip getProperty:AMVE_PROP_CLIP_TIME_SCALE PropertyData:&timescale];

	MDWord orgduration = videoinfo.dwVideoDuration;
	duration = orgduration * timescale;

	return duration;
}

@end
