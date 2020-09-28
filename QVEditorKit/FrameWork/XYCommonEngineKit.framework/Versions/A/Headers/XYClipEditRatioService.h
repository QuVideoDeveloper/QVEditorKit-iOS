//
//  XYClipEditRatioService.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/11.
//

#import <Foundation/Foundation.h>
#import "XYEffectPropertyData.h"

#define XY_ANIMATION_VALUE  100

@class XYStoryboard;

NS_ASSUME_NONNULL_BEGIN

typedef struct XYQRect {
    CGFloat left;
    CGFloat right;
    CGFloat top;
    CGFloat bottom;
}XYQRect;

@interface XYClipEditRatioService : NSObject
//set
+ (void)setEffect:(XYClipModel *)clipModel storyBoard:(XYStoryboard *)storyBoard;
+ (void)setEffectPropertyWithDwPropertyID:(NSInteger)dwPropertyID
                                    value:(CGFloat)value
                                clipIndex:(NSInteger)idx
                               storyBoard:(XYStoryboard *)storyBoard;
//get
//获取clip 的原始尺寸
+ (CGSize)getVideoInfoSizeWithClipIndex:(int)clipIndex storyBoard:(XYStoryboard *)storyBoard;
+ (NSString *)getProjectEffectPhotoPathWithClipIndex:(int)clipIndex storyBoard:(XYStoryboard *)storyBoard;
+ (float)getFitInScaleWithPlayViewSize:(CGSize)playViewSize clipIndex:(int)clipIndex;
+ (float)getFitoutScaleWithPlayViewSize:(CGSize)playViewSize clipIndex:(int)clipIndex mRatio:(float)mRatio storyBoard:(XYStoryboard *)storyBoard rotation:(NSInteger)rotation clipRotation:(NSInteger)clipRotation clipRatio:(float)clipRatio;
+ (BOOL)getOriginVideoRaitoIsEqualStoryBoardRatioWithClipIndex:(int)clipIndex storyBoard:(XYStoryboard *)storyBoard;

//动画属性（doAnim），控制是否启动动画 范围0-100， < 50无动画， >= 50 有动画
//C模板： prop id : 13
//D E F 003模板 prop id : 8
+ (void)setSingleClipAnimationWithClipIndex:(int)dwClipIndex
                                 effectType:(XYCommonEnginebackgroundType)effectType
                                     doAnim:(BOOL)doAnim
                                 storyBoard:(XYStoryboard *)storyBoard;

+ (void)setSingleClipAnimationWithClip:(CXiaoYingClip *)pClip
                                 effectType:(XYCommonEnginebackgroundType)effectType
                                     doAnim:(BOOL)doAnim
                            storyBoard:(XYStoryboard *)storyBoard;
@end

NS_ASSUME_NONNULL_END
