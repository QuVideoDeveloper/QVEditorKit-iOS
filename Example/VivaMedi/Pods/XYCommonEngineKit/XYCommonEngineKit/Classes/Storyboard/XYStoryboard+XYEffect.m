//
//  XYStoryboard+XYEffect.m
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/12.
//

#import "XYStoryboard+XYEffect.h"
#import "XYStoryboard+XYClip.h"
#import "XYEditUtils.h"

@implementation XYStoryboard (XYEffect)

#pragma mark - 视频效果相关
- (void)moveEffect:(CXiaoYingEffect *)effect newPosition:(MDWord)newPosition {
	CXiaoYingClip *pStbClip = nil;
	pStbClip = [self.cXiaoYingStoryBoardSession getDataClip];
	if (effect && pStbClip) {
		[self setModified:YES];
		MRESULT res = [pStbClip moveEffect:effect NewPosition:newPosition];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard removeEffect err=0x%lx", res);
		}
	}
}

- (void)removeEffect:(CXiaoYingEffect *)effect {
	CXiaoYingClip *pStbClip = nil;
	pStbClip = [self.cXiaoYingStoryBoardSession getDataClip];
	if (effect && pStbClip) {
		[self setModified:YES];
		MRESULT res = [pStbClip removeEffect:effect];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard removeEffect err=0x%lx", res);
		}
	}
}

- (CXiaoYingEffect *)getStoryboardEffectByTime:(MDWord)timeStamp dwTrackType:(MDWord)dwTrackType groupId:(MDWord)groupId {
	NSArray *effectArray = [self getStoryboardEffectsByTime:timeStamp dwTrackType:dwTrackType groupId:groupId];
	if (!effectArray || [effectArray count] == 0) {
		return nil;
	}
	return [effectArray objectAtIndex:0];
}

- (CXiaoYingEffect *)getStoryboardEffectOnTopByTime:(MDWord)timeStamp touchPoint:(MPOINT)touchPoint {
    NSArray <NSNumber *>*groupIds = @[@GROUP_TEXT_FRAME,@GROUP_ANIMATED_FRAME,@GROUP_STICKER,@GROUP_ID_MOSAIC,@GROUP_ID_COLLAGE,@GROUP_ID_WATERMARK];
    NSArray <CXiaoYingEffect *> *allVideoEffects = [self getStoryboardEffectsByTime:timeStamp touchPoint:touchPoint trackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupIds:groupIds];
    if ([allVideoEffects count] > 0) {
        return allVideoEffects[0];
    }
    return nil;
}

- (NSArray <CXiaoYingEffect *> *)getStoryboardEffectsByTime:(MDWord)timeStamp
                                                 touchPoint:(MPOINT)touchPoint
                                                  trackType:(MDWord)trackType
                                                   groupIds:(NSArray<NSNumber *> *)groupIds {
    NSMutableArray <CXiaoYingEffect *> *allVideoEffects = [NSMutableArray array];
    [groupIds enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        MDWord groupId = [obj integerValue];
        NSArray *effects = [self getStoryboardEffectsByTime:timeStamp touchPoint:touchPoint dwTrackType:trackType groupId:groupId];
        if (effects && [effects count] > 0) {
            [allVideoEffects addObjectsFromArray:effects];
        }
    }];
    
    [allVideoEffects sortUsingComparator:^NSComparisonResult(CXiaoYingEffect * _Nonnull effect1, CXiaoYingEffect * _Nonnull effect2) {
        CGFloat layerId2 = [self getEffectLayerId:effect2];
        CGFloat layerId1 = [self getEffectLayerId:effect1];
        return [@(layerId2) compare:@(layerId1)];
    }];
    return allVideoEffects;
}

- (NSDictionary *)getStoryboardEffectsDictByTime:(MDWord)timeStamp
                                      touchPoint:(MPOINT)touchPoint
                                       trackType:(MDWord)trackType
                                        groupIds:(NSArray<NSNumber *> *)groupIds {
	NSMutableDictionary *allVideoEffectsDict = [NSMutableDictionary dictionary];
	if (!groupIds || [groupIds count] == 0) {
		return allVideoEffectsDict;
	}
	[groupIds enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
	  MDWord groupId = [obj integerValue];
	  MDWord effectIndex;
	  NSArray *effects = [self getStoryboardEffectsByTime:timeStamp touchPoint:touchPoint dwTrackType:trackType groupId:groupId];
	  if (effects && [effects count] > 0) {
		  [allVideoEffectsDict setValue:effects forKey:[@(groupId) stringValue]];
	  }
	}];

	return allVideoEffectsDict;
}

- (NSArray *)getStoryboardEffectsByTime:(MDWord)timeStamp dwTrackType:(MDWord)dwTrackType groupId:(MDWord)groupId {
	MPOINT mpt = {-1, -1};
	return [self getStoryboardEffectsByTime:timeStamp touchPoint:mpt dwTrackType:dwTrackType groupId:groupId];
}

- (NSArray *)getStoryboardEffectsByTime:(MDWord)timeStamp touchPoint:(MPOINT)touchPoint dwTrackType:(MDWord)dwTrackType groupId:(MDWord)groupId {
	if (!self.cXiaoYingStoryBoardSession) {
		return nil;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	if (!pStbDataClip) {
		return nil;
	}
	NSMutableArray *effectArray = [[NSMutableArray alloc] init];
	MDWord duration = [self.cXiaoYingStoryBoardSession getDuration];
	MRESULT res = MERR_NONE;
	int count = [pStbDataClip getEffectCount:dwTrackType GroupID:groupId];
	for (int i = 0; i < count; i++) {
		CXiaoYingEffect *effect = [pStbDataClip getEffect:dwTrackType GroupID:groupId EffectIndex:i];
		if (effect) {
			AMVE_POSITION_RANGE_TYPE range = {0};
			MBool isReadOnly = MFalse;
			MRECT effectRatio = {0, 0, 10000, 10000};
			MFloat fRotateAngle = 0;
			MPOINT ptRotateCenter = {0};
			res = [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&range];
			QVET_CHECK_VALID_GOTO(res);
			res = [effect getProperty:AMVE_PROP_EFFECT_IS_READ_ONLY PropertyData:&isReadOnly];
			QVET_CHECK_VALID_GOTO(res);

			BOOL isPointInRotatedRect = YES;
			if (AMVE_EFFECT_TRACK_TYPE_VIDEO && touchPoint.x >= 0 && touchPoint.y >= 0) {
				res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&effectRatio];
				QVET_CHECK_VALID_GOTO(res);
				//Get rotate angle
				if (groupId == GROUP_TEXT_FRAME) { //Get rotate angle from bubble for text now.
					//TODO: We need to do this like sticker
					AMVE_MEDIA_SOURCE_TYPE mediaSource = {0};
					AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = [XYEditUtils allocBubbleSource];
					mediaSource.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_BUBBLETEXT;
					mediaSource.pSource = pBubbleSource;
					res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSource];
					QVET_CHECK_VALID_GOTO(res);
					fRotateAngle = pBubbleSource->fRotateAngle;
					[XYEditUtils freeBubbleSource:pBubbleSource];
				} else if (groupId == GROUP_STICKER || groupId == GROUP_ID_COLLAGE || groupId == GROUP_ID_MOSAIC) {
					res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
					QVET_CHECK_VALID_GOTO(res)
				}
				ptRotateCenter.x = effectRatio.right / 2 + effectRatio.left / 2;
				ptRotateCenter.y = effectRatio.bottom / 2 + effectRatio.top / 2;
				isPointInRotatedRect = [XYEditUtils isPointInRotatedRect:touchPoint angle:360.0f - fRotateAngle center:ptRotateCenter rect:effectRatio];
                
                //关键帧类型
                if ([self hasKeyFrameWithTimeStamp:timeStamp effect:effect groupId:groupId]) {
                    isPointInRotatedRect = [self checkKeyFrameTouchPointIsInRotatedRect:touchPoint timeStamp:timeStamp effect:effect groupId:groupId];
                }
                
			}

			//TimeStamp==1001 Effect1[0~1001),Effect2[1001~2001), return Effect1
			MDWord startPos = range.dwPos;
			MDWord endPos = range.dwPos + range.dwLen;
			if (range.dwLen > duration || range.dwPos + range.dwLen > duration) {
				endPos = duration;
			}
			if (timeStamp >= startPos && timeStamp < endPos && isReadOnly == MFalse && isPointInRotatedRect) {
				[effectArray addObject:effect];
			}
		}
	}
	return effectArray;
FUN_EXIT:
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getStoryboardEffectByTime err=0x%lx", res);
	}
	return nil;
}

- (CXiaoYingEffect *)getStoryboardEffectByTime:(MDWord)timeStamp
                                    touchPoint:(MPOINT)touchPoint
                                   dwTrackType:(MDWord)dwTrackType
                                       groupId:(MDWord)groupId
                                   effectIndex:(MDWord *)effectIndex {
	if (!self.cXiaoYingStoryBoardSession) {
		return nil;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	if (!pStbDataClip) {
		return nil;
	}
	MRESULT res = MERR_NONE;
	int count = [pStbDataClip getEffectCount:dwTrackType GroupID:groupId];

	for (int i = count - 1; i >= 0; i--) {
		CXiaoYingEffect *effect = [pStbDataClip getEffect:dwTrackType GroupID:groupId EffectIndex:i];
		if (effect) {
			AMVE_POSITION_RANGE_TYPE range = {0};
			MBool isReadOnly = MFalse;
			MRECT effectRatio = {0};
			MFloat fRotateAngle = 0;
			MPOINT ptRotateCenter = {0};
			res = [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&range];
			QVET_CHECK_VALID_GOTO(res);
			res = [effect getProperty:AMVE_PROP_EFFECT_IS_READ_ONLY PropertyData:&isReadOnly];
			QVET_CHECK_VALID_GOTO(res);
			res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&effectRatio];
			QVET_CHECK_VALID_GOTO(res);

			//Get rotate angle
			if (groupId == GROUP_TEXT_FRAME) { //Get rotate angle from bubble for text now.
				//TODO: We need to do this like sticker
				AMVE_MEDIA_SOURCE_TYPE mediaSource = {0};
				AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = [XYEditUtils allocBubbleSource];
				mediaSource.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_BUBBLETEXT;
				mediaSource.pSource = pBubbleSource;
				res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSource];
				QVET_CHECK_VALID_GOTO(res);
				fRotateAngle = pBubbleSource->fRotateAngle;
				[XYEditUtils freeBubbleSource:pBubbleSource];
			} else if (groupId == GROUP_STICKER) {
				res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
				QVET_CHECK_VALID_GOTO(res);

			} else if (groupId == GROUP_ID_COLLAGE) {
				res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
				QVET_CHECK_VALID_GOTO(res);
            }else if (groupId == GROUP_ID_MOSAIC) {
                res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
                QVET_CHECK_VALID_GOTO(res);
            }
			ptRotateCenter.x = effectRatio.right / 2 + effectRatio.left / 2;
			ptRotateCenter.y = effectRatio.bottom / 2 + effectRatio.top / 2;
			BOOL isPointInRotatedRect = [XYEditUtils isPointInRotatedRect:touchPoint angle:360.0f - fRotateAngle center:ptRotateCenter rect:effectRatio];
            
            //关键帧类型
            if ([self hasKeyFrameWithTimeStamp:timeStamp effect:effect groupId:groupId]) {
                isPointInRotatedRect = [self checkKeyFrameTouchPointIsInRotatedRect:touchPoint timeStamp:timeStamp effect:effect groupId:groupId];
            }

			//TimeStamp==1001 Effect1[0~1001),Effect2[1001~2001), return Effect1
			if (timeStamp >= range.dwPos && timeStamp < range.dwPos + range.dwLen && isReadOnly == MFalse && isPointInRotatedRect) {
				*effectIndex = i;
				return effect;
			}
		}
	}
FUN_EXIT:
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getStoryboardEffectByTime err=0x%lx", res);
	}
	return nil;
}

- (CXiaoYingEffect *)getStoryboardEffectByIndex:(MDWord)dwIndex dwTrackType:(MDWord)dwTrackType groupId:(MDWord)groupId {
	if (!self.cXiaoYingStoryBoardSession) {
		return nil;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	if (!pStbDataClip) {
		return nil;
	}
	int count = [pStbDataClip getEffectCount:dwTrackType GroupID:groupId];
	if (dwIndex < count) {
		CXiaoYingEffect *effect = [pStbDataClip getEffect:dwTrackType GroupID:groupId EffectIndex:dwIndex];
		return effect;
	}
	return nil;
}

- (MDWord)getStoryboardEffectIndexByEffect:(CXiaoYingEffect *)effect trackType:(MDWord)trackType groupId:(MDWord)groupId {
	if (!self.cXiaoYingStoryBoardSession) {
		return 0;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	if (!pStbDataClip) {
		return 0;
	}
	NSMutableArray *effectArray = [[NSMutableArray alloc] init];
	MDWord duration = [self.cXiaoYingStoryBoardSession getDuration];
	int count = [pStbDataClip getEffectCount:trackType GroupID:groupId];
	for (int i = 0; i < count; i++) {
		CXiaoYingEffect *tmpEffect = [pStbDataClip getEffect:trackType GroupID:groupId EffectIndex:i];
		if (tmpEffect.hEffect == effect.hEffect) {
			return i;
		}
	}
	return 0;
}

- (MDWord)getEffectCount:(MDWord)dwTrackType groupId:(MDWord)groupId {
	if (!self.cXiaoYingStoryBoardSession) {
		return 0;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	MDWord count = [pStbDataClip getEffectCount:dwTrackType GroupID:groupId];
	return count;
}

- (MDWord)getAllClipEffectCount:(MDWord)dwTrackType groupId:(MDWord)groupId {
	if (!self.cXiaoYingStoryBoardSession) {
		return 0;
	}
	MDWord effectCount = 0;
	MDWord clipCount = [self getClipCount];
	for (int i = 0; i < clipCount; i++) {
		CXiaoYingClip *clip = [self getClipByIndex:i];
		if (clip) {
			effectCount += [clip getEffectCount:dwTrackType GroupID:groupId];
		}
	}
	return effectCount;
}

- (AMVE_POSITION_RANGE_TYPE)getEffectRange:(CXiaoYingEffect *)effect {
	AMVE_POSITION_RANGE_TYPE range = {0};
	MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&range];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getEffectRange err=0x%lx", res);
	}
	return range;
}

- (MRESULT)setEffectRange:(CXiaoYingEffect *)effect startPos:(MDWord)startPos duration:(MDWord)duration {
	NSLog(@"[ENGINE]XYStoryboard setEffectRange startPos=%ld duration=%ld", startPos, duration);
	MRESULT res = 0;
	if (effect) {
		AMVE_POSITION_RANGE_TYPE range = {0};
		range.dwPos = startPos;
		range.dwLen = duration;
		MRESULT res = [effect setProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&range];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard setEffectRange err=0x%lx", res);
		}
		[self setModified:YES];
	}
	return res;
}

- (MDWord)getEffectGroupId:(CXiaoYingEffect *)effect {
	MDWord groupId = GROUP_ID_DEFAULT;
	MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_GROUP PropertyData:&groupId];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getEffectGroupId err=0x%lx", res);
	}
	return groupId;
}

- (float)getEffectLayerId:(CXiaoYingEffect *)effect {
	float layerId = LAYER_ID_DEFAULT;
	MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_LAYER PropertyData:&layerId];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getEffectLayerId err=0x%lx", res);
	}
	return layerId;
}

- (void)setEffectLayerId:(CXiaoYingEffect *)effect layerId:(float)layerId {
	MRESULT res = [effect setProperty:AMVE_PROP_EFFECT_LAYER PropertyData:&layerId];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard setEffectLayerId err=0x%lx", res);
	}
}

- (NSString *)getEffectPath:(CXiaoYingEffect *)effect {
	if (effect) {
		char *cfilename = (char *)malloc(AMVE_MAXPATH);
		MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_IE_SOURCE PropertyData:cfilename];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard getEffectPath err=0x%lx", res);
		}
		NSString *effect = [NSString stringWithUTF8String:cfilename];
		free(cfilename);
		return effect;
	}
	return nil;
}

- (int)getEffectCountInSpecificTime:(MDWord)timeStamp dwTrackType:(MDWord)dwTrackType dwGroupId:(MDWord)dwGroupId {
	int specificTimeEffectCount = 0;
	if (!self.cXiaoYingStoryBoardSession) {
		return specificTimeEffectCount;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	if (!pStbDataClip) {
		return specificTimeEffectCount;
	}
	MRESULT res = MERR_NONE;
	int count = [pStbDataClip getEffectCount:dwTrackType GroupID:dwGroupId];

	for (int i = count - 1; i >= 0; i--) {
		CXiaoYingEffect *effect = [pStbDataClip getEffect:dwTrackType GroupID:dwGroupId EffectIndex:i];
		if (effect) {
			AMVE_POSITION_RANGE_TYPE range = {0};
			MBool isReadOnly = MFalse;
			res = [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&range];
			if (res) {
				NSLog(@"[ENGINE]XYStoryboard getEffectCountInSpecificTime AMVE_PROP_EFFECT_RANGE err=0x%lx", res);
			}
			res = [effect getProperty:AMVE_PROP_EFFECT_IS_READ_ONLY PropertyData:&isReadOnly];
			if (res) {
				NSLog(@"[ENGINE]XYStoryboard getEffectCountInSpecificTime AMVE_PROP_EFFECT_IS_READ_ONLY err=0x%lx", res);
			}

			//TimeStamp==1001 Effect1[0~1001),Effect2[1001~2001), return Effect1
			if (timeStamp >= range.dwPos && timeStamp < range.dwPos + range.dwLen && isReadOnly == MFalse) {
				specificTimeEffectCount++;
			}
		}
	}
	return specificTimeEffectCount;
}

- (float)getEffectMaxLayerIdByTrackType:(MDWord)dwTrackType groupId:(MDWord)dwGroupId {
	if (!self.cXiaoYingStoryBoardSession) {
		return LAYER_ID_DEFAULT;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	int count = [pStbDataClip getEffectCount:dwTrackType GroupID:dwGroupId];
	if (count == 0) {
		return LAYER_ID_DEFAULT;
	}
	float maxLayerId = LAYER_ID_DEFAULT;
	for (int i = count - 1; i >= 0; i--) {
		CXiaoYingEffect *effect = [pStbDataClip getEffect:dwTrackType GroupID:dwGroupId EffectIndex:i];
		float layerId = [self getEffectLayerId:effect];
		maxLayerId = MAX(layerId, maxLayerId);
	}
	return maxLayerId;
}

#pragma mark - 关键帧相关
- (BOOL)hasKeyFrameWithTimeStamp:(MWord)timeStamp effect:(CXiaoYingEffect *)effect groupId:(MDWord)groupId {
    if (groupId == GROUP_STICKER || groupId == GROUP_ID_COLLAGE || groupId == GROUP_TEXT_FRAME || groupId == GROUP_ID_MOSAIC) { //需要检查是否点击在关键帧上
        CXiaoYingKeyFrameTransformValue *value = [self getEffectKeyFrameTransformValue:effect timeStamp:timeStamp];
        if (value) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

- (BOOL)checkKeyFrameTouchPointIsInRotatedRect:(MPOINT)touchPoint timeStamp:(MWord)timeStamp effect:(CXiaoYingEffect *)effect groupId:(MDWord)groupId {
    BOOL isPointInRotatedRect = NO;
    CXiaoYingKeyFrameTransformValue *value = [self getEffectKeyFrameTransformValue:effect timeStamp:timeStamp];
    if (value) {
        MLong baseWidth = [self geteEffectKeyframeBaseWidthWithEffect:effect];
        MLong baseHeight = [self geteEffectKeyframeBaseHeightWithEffect:effect];
        
        MLong realwidth = baseWidth * value->widthRatio;
        MLong realHeight = baseHeight * value->heightRatio;
        
        MRECT rect = {value->position.x - realwidth / 2,value->position.y - realHeight / 2,value->position.x + realwidth / 2,value->position.y + realHeight / 2};
        
        isPointInRotatedRect = [XYEditUtils isPointInRotatedRect:touchPoint angle:360.0f - value->rotation center:value->position rect:rect];
    }
    
    return isPointInRotatedRect;
}

- (CXiaoYingKeyFrameTransformValue *)getEffectKeyFrameTransformValue:(CXiaoYingEffect *)effect timeStamp:(MDWord)timeStamp {
    
    AMVE_POSITION_RANGE_TYPE effectRange = {0};
    MRESULT ret = [effect getProperty:AMVE_PROP_EFFECT_RANGE
                         PropertyData:(MVoid *)&effectRange];
    if (ret) {
        return nil;
    }
    
    MDWord kfTime = 0;
    if (timeStamp < effectRange.dwPos) {
        kfTime = 0;
    }else if (timeStamp > effectRange.dwPos + effectRange.dwLen) {
        kfTime = effectRange.dwLen;
    }else {
        kfTime = timeStamp - effectRange.dwPos;
    }
    
    CXiaoYingKeyFrameTransformValue* value = [effect getKeyFrameTransformValue:kfTime];
    
    if (value) {
        return value;
    }else {
        return nil;
    }
}
    
- (NSString *)getClipEffectPath:(int)dwClipIndex
{
    CXiaoYingClip *pClip = [self getClipByIndex:dwClipIndex];
    return [self getClipEffectPathByClip:pClip];
}
    
- (NSString *)getClipEffectPath:(int)dwClipIndex groupId:(MDWord)groupId
{
    CXiaoYingClip *pClip = [self getClipByIndex:dwClipIndex];
    return [self getClipEffectPathByClip:pClip groupId:groupId];
}
    
- (NSString *)getClipEffectPathByClip:(CXiaoYingClip *)pClip
{
    return [self getClipEffectPathByClip:pClip groupId:GROUP_IMAGING_EFFECT];
}
    
- (NSString *)getClipEffectPathByClip:(CXiaoYingClip *)pClip groupId:(MDWord)groupId
{
    CXiaoYingEffect *xyeffect = [pClip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:groupId EffectIndex:0];
    return [self getEffectPath:xyeffect];
}

- (AMVE_POSITION_RANGE_TYPE)getEffectSourceRange:(CXiaoYingEffect *)effect {
    NSInteger groupId = [self getEffectGroupId:effect];
    AMVE_POSITION_RANGE_TYPE range = {0};
    MRESULT res = 0;
    if (groupId == GROUP_ID_RECORD
        || groupId == GROUP_ID_BGMUSIC
        || groupId == GROUP_ID_DUBBING) {
        res = [effect getProperty:AMVE_PROP_EFFECT_AV_SRC_RANGE PropertyData:&range];
    } else if (groupId == GROUP_ID_COLLAGE) {
        res = [effect getProperty:AMVE_PROP_EFFECT_VIDEOFRAME_SRCRANGE PropertyData:&range];
    }
    
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getEffectRange err=0x%lx", res);
    }
    return range;
}

- (void)setEffectSourceRange:(CXiaoYingEffect *)effect
                       dwPos:(MDWord)dwPos
                       dwLen:(MDWord)dwLen {
    if (effect) {
        MRESULT res = 0;
        AMVE_POSITION_RANGE_TYPE SrcRange;
        SrcRange.dwPos = dwPos;
        SrcRange.dwLen = dwLen;
        
        NSInteger groupId = [self getEffectGroupId:effect];
        
        if (groupId == GROUP_ID_RECORD
            || groupId == GROUP_ID_BGMUSIC
            || groupId == GROUP_ID_DUBBING) {
            res = [effect setProperty:AMVE_PROP_EFFECT_AV_SRC_RANGE PropertyData:(MVoid *)&SrcRange];
        } else if (groupId == GROUP_ID_COLLAGE) {
            res = [effect setProperty:AMVE_PROP_EFFECT_VIDEOFRAME_SRCRANGE PropertyData:(MVoid *)&SrcRange];
        }
        
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard AMVE_PROP_EFFECT_ORIGINAL_RANGE err=0x%lx", res);
        }
    }
}

- (AMVE_POSITION_RANGE_TYPE)getEffectTrimRange:(CXiaoYingEffect *)effect {
    NSInteger groupId = [self getEffectGroupId:effect];
    AMVE_POSITION_RANGE_TYPE range = {0};
    MRESULT res = 0;
    if (groupId == GROUP_ID_RECORD
        || groupId == GROUP_ID_BGMUSIC
        || groupId == GROUP_ID_DUBBING) {
        res = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE PropertyData:&range];
    } else if (groupId == GROUP_ID_COLLAGE) {
        res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_RANGE PropertyData:&range];
    }
    
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getEffectTrimRange err=0x%lx", res);
    }
    return range;
}

- (void)setEffectTrimRange:(CXiaoYingEffect *)effect
                     dwPos:(MDWord)dwPos
                     dwLen:(MDWord)dwLen {
    if (effect) {
        MRESULT res = 0;
        AMVE_POSITION_RANGE_TYPE range;
        range.dwPos = dwPos;
        range.dwLen = dwLen;
        
        NSInteger groupId = [self getEffectGroupId:effect];
        
        if (groupId == GROUP_ID_RECORD
            || groupId == GROUP_ID_BGMUSIC
            || groupId == GROUP_ID_DUBBING) {
            res = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE PropertyData:(MVoid *)&range];
        } else if (groupId == GROUP_ID_COLLAGE) {
            res = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_RANGE PropertyData:(MVoid *)&range];
        }
        
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard setEffectTrimRange err=0x%lx", res);
        }
    }
}


- (void)updateAudioTrimRange:(CXiaoYingEffect *)effect
           audioTrimStartPos:(MDWord)audioTrimStartPos
             audioTrimLength:(MDWord)audioTrimLength {
    if (effect) {
        AMVE_POSITION_RANGE_TYPE SrcRange;
        SrcRange.dwPos = audioTrimStartPos;
        SrcRange.dwLen = audioTrimLength;
        MRESULT res = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE
                             PropertyData:(MVoid *)&SrcRange];
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard setClipAudioRange AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE err=0x%lx", res);
        }
    }
    [self setModified:YES];
}


- (MRESULT)setEffectIdentifier:(CXiaoYingEffect *)effect identifier:(NSString *)identifier {
    MRESULT res = MERR_NONE;
    const MTChar *identifierChar = [identifier UTF8String];
    res = [effect setProperty:AMVE_PROP_EFFECT_UNIQUE_IDENTIFIER PropertyData:(MVoid *)identifierChar];
    return res;
}

- (NSString *)getEffectIdentifier:(CXiaoYingEffect *)effect {
    if (effect) {
        char *identifierChar = (char *)malloc(AMVE_MAXPATH);
        MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_UNIQUE_IDENTIFIER
                             PropertyData:identifierChar];
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard getEffectIdentifier err=0x%lx", res);
            free(identifierChar);
            return nil;
        }
        NSString *identifier = (identifierChar == MNull) ? @"" : [NSString stringWithUTF8String:identifierChar];
        free(identifierChar);
        return identifier;
    }
    return nil;
}

- (MRESULT)setEffectUserData:(CXiaoYingEffect *)effect effectUserData:(NSString *)effectUserData {
    MDWord length = [effectUserData lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    MByte *tmpData = (MByte *)[effectUserData cStringUsingEncoding:NSUTF8StringEncoding];
    AMVE_USER_DATA_TYPE amveUserData = {tmpData, length + 1};
    
    MRESULT res = [effect setProperty:AMVE_PROP_EFFECT_USERDATA PropertyData:&amveUserData];
    return res;
}

- (NSString *)getEffectUserData:(CXiaoYingEffect *)effect {
    AMVE_USER_DATA_TYPE tmpAmveUserData = {MNull, 0};
    
    MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_USERDATA PropertyData:&tmpAmveUserData];
    
    if (res || tmpAmveUserData.dwUserDataLen == 0) {
        return nil;
    }
    MByte *pbyUserData = (MByte *)MMemAlloc(MNull, tmpAmveUserData.dwUserDataLen);
    MMemSet(pbyUserData, 0, tmpAmveUserData.dwUserDataLen);
    AMVE_USER_DATA_TYPE amveUserData = {pbyUserData, 0};
    res = [effect getProperty:AMVE_PROP_EFFECT_USERDATA PropertyData:&amveUserData];
    if (res) {
        free(pbyUserData);
        return nil;
    }
    NSString *strUserData = [NSString stringWithUTF8String:(char *)amveUserData.pbyUserData];
    free(pbyUserData);
    return strUserData;
}

- (void)updateEffectGroupID:(CXiaoYingEffect *)pEffect groupID:(MDWord)groupID {
    MRESULT res = [pEffect setProperty:AVME_PROP_EFFECT_UPDATE_GROUP_ID PropertyData:&groupID];
}

@end
