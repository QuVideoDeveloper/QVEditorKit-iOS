//
//  XYStoryboard+XYEffect.h
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/12.
//

#import "XYStoryboard.h"

@interface XYStoryboard (XYEffect)

#pragma mark - 视频效果相关

/**
 删除效果

 @param effect 需要删除的效果
 */
- (void)removeEffect:(CXiaoYingEffect *)effect;

/**
 移动效果到指定位置

 @param effect 需要移动的效果
 @param newPosition 新的位置
 */
- (void)moveEffect:(CXiaoYingEffect *)effect newPosition:(MDWord)newPosition;


/// 获取某一时间点，某一trackType，groupId对应的CXiaoYingEffect
/// @param timeStamp 时间点（毫秒）
/// @param touchPoint 点击点
- (CXiaoYingEffect *)getStoryboardEffectOnTopByTime:(MDWord)timeStamp touchPoint:(MPOINT)touchPoint;

/**
 获取某一时间点，某一trackType，groupId对应的CXiaoYingEffect数组

 @param timeStamp 时间点（毫秒）
 @param dwTrackType TrackType
 @param groupId GroupID
 @return CXiaoYingEffect数组
 */
- (NSArray *)getStoryboardEffectsByTime:(MDWord)timeStamp dwTrackType:(MDWord)dwTrackType groupId:(MDWord)groupId;

/**
 获取某一时间点，某一位置，某一trackType，groupId对应的CXiaoYingEffect数组

 @param timeStamp 时间点（毫秒）
 @param touchPoint 位置
 @param dwTrackType TrackType
 @param groupId GroupID
 @return CXiaoYingEffect数组
 */
- (NSArray *)getStoryboardEffectsByTime:(MDWord)timeStamp touchPoint:(MPOINT)touchPoint dwTrackType:(MDWord)dwTrackType groupId:(MDWord)groupId;

/**
 获取某一时间点，某一位置，某一trackType, 某些groupId，对应的CXiaoYingEffect数组

 @param timeStamp 时间点（毫秒）
 @param touchPoint 位置
 @param trackType TrackType
 @param groupIds GroupID数组
 @return CXiaoYingEffect数组
 */
- (NSDictionary *)getStoryboardEffectsDictByTime:(MDWord)timeStamp
                                      touchPoint:(MPOINT)touchPoint
                                       trackType:(MDWord)trackType
                                        groupIds:(NSArray<NSNumber *> *)groupIds;

/**
 获取某一时间点，某一trackType，groupId对应的第一个CXiaoYingEffect
 
 @param timeStamp 时间点（毫秒）
 @param dwTrackType TrackType
 @param groupId GroupID
 @return 找到的第一个CXiaoYingEffect
 */
- (CXiaoYingEffect *)getStoryboardEffectByTime:(MDWord)timeStamp dwTrackType:(MDWord)dwTrackType groupId:(MDWord)groupId;

/**
 获取某一时间点，某一trackType，groupId对应的第一个CXiaoYingEffect

 @param timeStamp 时间点（毫秒）
 @param touchPoint 位置
 @param trackType TrackType
 @param groupIds GroupID
 @param effectIndex effectIndex的地址，等函数运行后，会计算出effectIndex的值
 @return 找到的第一个CXiaoYingEffect
 */
- (CXiaoYingEffect *)getStoryboardEffectByTime:(MDWord)timeStamp
                                    touchPoint:(MPOINT)touchPoint
                                   dwTrackType:(MDWord)dwTrackType
                                       groupId:(MDWord)groupId
                                   effectIndex:(MDWord *)effectIndex;

/**
 根据在Storyboard中的Index，及trackType，groupId获取对应的CXiaoYingEffect

 @param dwIndex Effect在Storyboard中的Index
 @param dwTrackType TrackType
 @param groupId GroupID
 @return CXiaoYingEffect
 */
- (CXiaoYingEffect *)getStoryboardEffectByIndex:(MDWord)dwIndex dwTrackType:(MDWord)dwTrackType groupId:(MDWord)groupId;

/**
 根据Effect，及trackType，groupId获取该Effect在Storyboard中的Index

 @param effect CXiaoYingEffect
 @param trackType TrackType
 @param groupId GroupID
 @return Effect在Storyboard中的Index
 */
- (MDWord)getStoryboardEffectIndexByEffect:(CXiaoYingEffect *)effect trackType:(MDWord)trackType groupId:(MDWord)groupId;

/**
 获取trackType，groupId对应的在Storyboard上的CXiaoYingEffect个数

 @param dwTrackType TrackType
 @param groupId GroupID
 @return CXiaoYingEffect个数
 */
- (MDWord)getEffectCount:(MDWord)dwTrackType groupId:(MDWord)groupId;

/**
 获取trackType，groupId对应的在每个Clip上的CXiaoYingEffect之和

 @param dwTrackType TrackType
 @param groupId GroupID
 @return CXiaoYingEffect个数
 */
- (MDWord)getAllClipEffectCount:(MDWord)dwTrackType groupId:(MDWord)groupId;

/**
 获取Effect的range

 @param effect 需要获取Range的effet
 @return Effect的range
 */
- (AMVE_POSITION_RANGE_TYPE)getEffectRange:(CXiaoYingEffect *)effect;

/**
 设置Effect的range

 @param effect 需要设置Range的effet
 @param startPos range的起点
 @param duration range的长度
 @return 设置成功返回0，失败返回具体errorCode
 */
- (MRESULT)setEffectRange:(CXiaoYingEffect *)effect startPos:(MDWord)startPos duration:(MDWord)duration;

/**
 获取Effect的groupId

 @param effect 需要获取GroupId的effet
 @return Effect对应的GroupId
 */
- (MDWord)getEffectGroupId:(CXiaoYingEffect *)effect;

/**
 获取Effect的LayerId
 
 @param effect 需要获取LayerId的effet
 @return Effect对应的LayerId
 */
- (float)getEffectLayerId:(CXiaoYingEffect *)effect;

/**
 设置Effect的LayerId

 @param effect 需要设置LayerId的effet
 @param layerId 设进去的LayerId
 */
- (void)setEffectLayerId:(CXiaoYingEffect *)effect layerId:(float)layerId;

/**
 获取Effect对应的的模版文件路径

 @param effect
 @return 模版文件路径
 */
- (NSString *)getEffectPath:(CXiaoYingEffect *)effect;

/**
 获取某个时间点上，某个trackType，groupId对应的Effect个数

 @param timeStamp 时间点（毫秒）
 @param dwTrackType TrackType
 @param dwGroupId GroupId
 @return Effect个数
 */
- (int)getEffectCountInSpecificTime:(MDWord)timeStamp dwTrackType:(MDWord)dwTrackType dwGroupId:(MDWord)dwGroupId;

/**
 获取某个TrackType，GroupId对应的所有Effect中最大的那个LayerId

 @param dwTrackType TrackType
 @param dwGroupId GroupId
 @return LayerId
 */
- (float)getEffectMaxLayerIdByTrackType:(MDWord)dwTrackType groupId:(MDWord)dwGroupId;

- (CXiaoYingKeyFrameTransformValue *)getEffectKeyFrameTransformValue:(CXiaoYingEffect *)effect timeStamp:(MDWord)timeStamp;

- (NSString *)getClipEffectPath:(int)dwClipIndex;
    
- (NSString *)getClipEffectPath:(int)dwClipIndex groupId:(MDWord)groupId;
    
- (NSString *)getClipEffectPathByClip:(CXiaoYingClip *)pClip;
    
- (NSString *)getClipEffectPathByClip:(CXiaoYingClip *)pClip groupId:(MDWord)groupId;

- (MRESULT)setEffectIdentifier:(CXiaoYingEffect *)effect identifier:(NSString *)identifier;

- (NSString *)getEffectIdentifier:(CXiaoYingEffect *)effect;

- (MRESULT)setEffectUserData:(CXiaoYingEffect *)effect effectUserData:(NSString *)effectUserData;

- (NSString *)getEffectUserData:(CXiaoYingEffect *)effect;

- (AMVE_POSITION_RANGE_TYPE)getEffectSourceRange:(CXiaoYingEffect *)effect;//效果的原range 如加的是音乐 就是0 和 音乐的总时长

- (void)setEffectSourceRange:(CXiaoYingEffect *)effect
                       dwPos:(MDWord)dwPos
                       dwLen:(MDWord)dwLen;

- (AMVE_POSITION_RANGE_TYPE)getEffectTrimRange:(CXiaoYingEffect *)effect;

- (void)setEffectTrimRange:(CXiaoYingEffect *)effect
                     dwPos:(MDWord)dwPos
                     dwLen:(MDWord)dwLen;

- (AMVE_POSITION_RANGE_TYPE)getEffectOrginalRange:(CXiaoYingEffect *)effect;//效果的原range 如加的是音乐 就是0 和 音乐的总时长

- (void)updateAudioTrimRange:(CXiaoYingEffect *)effect
           audioTrimStartPos:(MDWord)audioTrimStartPos
             audioTrimLength:(MDWord)audioTrimLength;

- (void)updateEffectGroupID:(CXiaoYingEffect *)pEffect groupID:(MDWord)groupID;

//效果变声
- (MRESULT )updateAuioPicthEffect:(int)index tracktype:(MDWord)dwTrackType groupID:(MDWord)groupID volumeValue:(MFloat)picthValue;

- (MFloat)audioPitchEffectIndex:(int)index trackType:(MDWord)dwTrackType groupID:(MDWord)groupID;

- (NSString *)getEffectExternalSource:(CXiaoYingEffect *)pEffect;
- (void)setEffectExternalSource:(CXiaoYingEffect *)pEffect filePath:(NSString *)filePath;

- (MRESULT)setTextBgColor:(UIColor *)color effect:(CXiaoYingEffect *)effect;
- (CXiaoYingEffect *)addClipEffect:(NSString *)effectPath
                       effectAlpha:(MFloat)effectAlpha
                 effectConfigIndex:(MDWord)effectConfigIndex
                             pClip:(CXiaoYingClip *)pClip
                         trackType:(MDWord)dwTrackType
                           groupId:(MDWord)groupId
                           layerId:(MFloat)layerId;
@end
