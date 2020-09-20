//
//  XYStoryboard+XYClip.h
//  XYCommonEngineKit
//
//  Created by lizitao on 2019/9/17.
//

#import "XYStoryboard.h"

@interface XYStoryboard (XYClip)
    
- (CXiaoYingClip *)createClip:(NSString *)clipFullPath srcRangeLen:(MDWord)srcRangeLen;
    
/**
 创建一个由图片生成的clip
 
 @param filePath 图片资源路径
 @param srcRangeLen 用户所能调节clip的最大范围
 @param trimRangeLen 实际生成时长
 @return CXiaoYingClip
 */
- (CXiaoYingClip *)createPhotoClip:(NSString *)filePath
                       srcRangeLen:(MDWord)srcRangeLen
                      trimRangeLen:(MDWord)trimRangeLen;
    
- (CXiaoYingClip *)createClip:(NSString *)clipFullPath
                  srcRangePos:(MDWord)srcRangePos
                  srcRangeLen:(MDWord)srcRangeLen
                 trimRangePos:(MDWord)trimRangePos
                 trimRangeLen:(MDWord)trimRangeLen;
    
- (MRESULT)insertClip:(CXiaoYingClip *)cXiaoYingClip
             Position:(MDWord)dwIndex;
    
- (MRESULT)insertClipByClipDataItem:(XYClipDataItem *)clipDataItem Position:(MDWord)dwIndex;
    
- (MRESULT)insertEmptyClip:(MDWord)dwIndex
                  duration:(MDWord)duration;

- (MRESULT)replaceClip:(CXiaoYingClip *)clip
          clipFullPath:(NSString *)clipFullPath
            videoRange:(AMVE_POSITION_RANGE_TYPE)videoRange
             trimRange:(AMVE_POSITION_RANGE_TYPE)trimRange;

- (MRESULT)moveClip:(MDWord)dwOriginalIndex dwDestIndex:(MDWord)dwDestIndex;

- (MRESULT)deleteClip:(MDWord)dwIndex;

- (void)deleteClips:(NSArray<NSNumber *> *)indexArray;

- (MRESULT)deleteAllClips;

- (CXiaoYingClip *)duplicateClip:(MDWord)dwIndex;

- (CXiaoYingClip *)duplicateClipByClip:(CXiaoYingClip *)originalClip;

- (MRESULT)splitClip:(MDWord)dwIndex splitPosition:(MDWord)splitPosition;

- (MRESULT)splitClip:(MDWord)dwIndex splitOffsetPos:(MDWord)splitOffsetPos leftSplitLen:(MDWord)leftSplitLen  rightSplitLen:(MDWord)rightSplitLen identifier:(NSString *)identifier backTransTime:(NSInteger)backTransTime;

- (MRESULT)splitReverseClip:(MDWord)dwIndex splitPosition:(MDWord)splitPosition;

- (MDWord)getClipDuration:(MDWord)dwIndex;

- (MDWord)getClipDurationByClip:(CXiaoYingClip *)clip;

- (MRESULT)setClipTrimRange:(MDWord)dwIndex
                   startPos:(MDWord)startPos
                     endPos:(MDWord)endPos;
    
- (MRESULT)setClipReverseTrimRange:(MDWord)dwIndex
                          startPos:(MDWord)startPos
                            endPos:(MDWord)endPos;
    
- (AMVE_POSITION_RANGE_TYPE)getClipReverseTrimRange:(MDWord)dwIndex;

- (MBool)isReverseTrim:(MDWord)dwIndex;
    
- (MRESULT)setClipTrimRangeByClip:(CXiaoYingClip *)cXiaoYingClip
                         startPos:(MDWord)startPos
                           endPos:(MDWord)endPos;

- (AMVE_POSITION_RANGE_TYPE)getClipSourceRange:(MDWord)dwIndex;

- (MRESULT)setClipSourceRangeByClip:(CXiaoYingClip *)cXiaoYingClip
                           startPos:(MDWord)startPos
                             endPos:(MDWord)endPos;

- (AMVE_POSITION_RANGE_TYPE)getClipTimeRange:(MDWord)clipIndex;//物理的range
    
//不包含片头片尾
- (MDWord)getClipCount;

- (MDWord)getClipCountByType:(MDWord)clipType;

- (CXiaoYingClip *)getClipByIndex:(int)index;

- (NSString *)getClipPathByIndex:(int)index;

- (NSString *)getClipPath:(CXiaoYingClip *)xyClip;

- (MRESULT)getFirstClipSize:(MSIZE *)pSize;
    
- (MRESULT)setClipEffect:(NSString *)effectPath
       effectConfigIndex:(MDWord)effectConfigIndex
             dwClipIndex:(int)dwClipIndex
                 groupId:(MDWord)groupId
                 layerId:(MFloat)layerId;
    
- (MRESULT)setClipEffect:(NSString *)effectPath
             effectAlpha:(MFloat)effectAlpha
       effectConfigIndex:(MDWord)effectConfigIndex
             dwClipIndex:(int)dwClipIndex
                 groupId:(MDWord)groupId
                 layerId:(MFloat)layerId;
    
- (MRESULT)setClipEffect:(NSString *)effectPath
       effectConfigIndex:(MDWord)effectConfigIndex
             dwClipIndex:(int)dwClipIndex
               trackType:(MDWord)dwTrackType
                 groupId:(MDWord)groupId
                 layerId:(MFloat)layerId;

- (MRESULT)setClipEffect:(NSString *)effectPath
             effectAlpha:(MFloat)effectAlpha
       effectConfigIndex:(MDWord)effectConfigIndex
                   pClip:(CXiaoYingClip *)pClip
               trackType:(MDWord)dwTrackType
                 groupId:(MDWord)groupId
                 layerId:(MFloat)layerId;
    
- (MFloat)getClipAlpha:(NSString *)effectPath dwClipIndex:(int)dwClipIndex trackType:(MDWord)dwTrackType groupId:(MDWord)groupId layerID:(MFloat)layerId;

- (NSInteger)getClipEffectConfigIndexWithClipIndex:(int)dwClipIndex trackType:(MDWord)dwTrackType groupId:(MDWord)groupId layerID:(MFloat)layerId;

- (MRESULT)setClipTransition:(NSString *)transPath configureIndex:(UInt32)configureIndex dwClipIndex:(int)dwClipIndex dwDuration:(NSInteger)dwDuration;

- (NSString *)getClipTransitionPath:(int)dwClipIndex;

- (MRESULT)setClipTransition:(NSString *)transPath configureIndex:(UInt32)configureIndex pClip:(CXiaoYingClip *)pClip dwDuration:(NSInteger)dwDuration;
- (NSString *)getClipTransitionPathByClip:(CXiaoYingClip *)clip;

- (BOOL)isAllClipPicture;

- (BOOL)isFirstClipPicture;

- (MRESULT)isFirstClipPicture:(MBool *)pbPicture;

- (CXiaoYingClip *)getFirstPictureClip;

- (BOOL)isClipPicture:(CXiaoYingClip *)clip;

- (BOOL)isClipVideo:(CXiaoYingClip *)clip;

- (BOOL)isClipGIF:(CXiaoYingClip *)clip;

- (MRECT)getClipCropRect:(MDWord)dwClipIndex;

- (MRECT)getClipCropRectByClip:(CXiaoYingClip *)cXiaoYingClip;

- (MRESULT)setClipCropRectByClip:(CXiaoYingClip *)cXiaoYingClip cropRect:(MRECT)cropRect;

- (MRESULT)setClipEngineCropRectByClip:(CXiaoYingClip *)cXiaoYingClip rectForEngine:(MRECT)rectForEngine;

- (MDWord)getClipRotationByClip:(CXiaoYingClip *)cXiaoYingClip;

- (MRESULT)setClipRotationByClip:(CXiaoYingClip *)cXiaoYingClip degree:(MDWord)degree;

- (MDWord)getTimeByClipIndex:(MDWord)dwIndex dwPosition:(MDWord)dwPosition timeStamp:(MDWord *)timeStamp;

- (MDWord)getClipIndexByTime:(MDWord)dwTime;

- (NSArray<NSNumber *> *)getClipIndexArrayByTime:(MDWord)dwTime;

//包含片头片尾
- (QVET_CLIP_POSITION)getClipPositionByTime:(MDWord)dwTime;

- (MDWord)getPhysicalClipTimeClipIndex:(MDWord)clipIndex;

- (MDWord)getPhysicalClipTimeClipIndex:(MDWord)clipIndex dwTrimPos:(MDWord)dwTrimPos;

- (MBool)isClipPanZoomDisabled:(MDWord)clipIndex;

- (MRESULT)setClipPanZoomDisabled:(MDWord)clipIndex disable:(MBool)disable;

- (MRESULT)setClipTimeScale:(MDWord)clipIndex timeScale:(float)timeScale;

- (float)getClipTimeScale:(MDWord)clipIndex;

- (float)getClipTimeScaleByClip:(CXiaoYingClip *)clip;

- (void)keepTone:(MDWord)clipIndex keep:(BOOL)keep;

- (BOOL)isKeepTone:(MDWord)clipIndex;

- (MDWord)getClipType:(MDWord)clipIndex;

- (MDWord)getClipTypeByClip:(CXiaoYingClip *)clip;

- (BOOL)isHDClip:(CXiaoYingClip *)clip;

- (BOOL)isClip:(CXiaoYingClip *)clip sizeLargerEqualTo:(CGSize)targetSize;

- (BOOL)isClipReversed:(CXiaoYingClip *)clip;

- (BOOL)hasReversedClip;
    
#pragma mark - Clip Transition related
- (MDWord)getClipTransitionDuration:(CXiaoYingClip *)cXiaoYingClip;

- (MDWord)getClipTransitionDurationByIndex:(MDWord)dwIndex;

- (AMVE_POSITION_RANGE_TYPE)getClipTransitionTimeRange:(MDWord)clipIndex;

- (void)setEffectPropertyWithPropertyID:(NSInteger)dwPropertyID
                                  value:(CGFloat)value
                              clipIndex:(NSInteger)idx;

- (MRESULT)setClipUserData:(NSDictionary *)userDataDic pClip:(CXiaoYingClip *)pClip;
- (NSDictionary *)getClipUserData:(CXiaoYingClip *)pClip;

- (QVET_CURVE_SPEED_VALUES)getClipCurveSpeed:(CXiaoYingClip *)pClip;

- (void)setClipCurveSpeed:(CXiaoYingClip *)pClip curveSpeed:(QVET_CURVE_SPEED_VALUES)curveSpeed;

@end

