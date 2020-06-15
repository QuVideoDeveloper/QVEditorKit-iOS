//
//  XYClipEditRatioService.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/11.
//

#import "XYClipEditRatioService.h"
#import "XYStoryboard.h"
#import "XYCommonEngineGlobalData.h"
#import "XYStoryboard+XYClip.h"
#import "XYStoryboard+XYEffect.h"
#import <XYCategory/XYCategory.h>
#import "XYClipModel.h"

@implementation XYClipEditRatioService

+ (float)getFitoutScaleWithPlayViewSize:(CGSize)playViewSize clipIndex:(int)clipIndex mRatio:(float)mRatio storyBoard:(XYStoryboard *)storyBoard rotation:(NSInteger)rotation clipRotation:(NSInteger)clipRotation clipRatio:(float)clipRatio {
    float fitRatio = 0;
    float playRatio = playViewSize.width / playViewSize.height;
    CGSize videoSize = [XYClipEditRatioService getVideoInfoSizeWithClipIndex:clipIndex storyBoard:storyBoard];
    float aspectRatio = videoSize.width / (float)videoSize.height;
    if (clipRatio != aspectRatio) {
        if (rotation % 360 == 90 || rotation % 360 == 270) {
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
        if (clipRotation % 360 == 90 || clipRotation % 360 == 270) {
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
    }
    if (aspectRatio < playRatio) {
        CGFloat chlidHeight = playViewSize.height;
        CGFloat chlidWidth = chlidHeight * aspectRatio;
        fitRatio = playViewSize.width / chlidWidth;
    } else if (aspectRatio > playRatio) {
        CGFloat chlidWidth = playViewSize.width;
        CGFloat chlidHeight = chlidWidth / aspectRatio;
        fitRatio = playViewSize.height / chlidHeight;
    } else {
        fitRatio = 1;
    }
    if (mRatio == -1) {
        return fitRatio;
    } else if (mRatio > 1) {//因为播放器的比例 和 算出的比例 存在误差 容错处理
        fitRatio = fitRatio * mRatio / playRatio + 0.01f;
    } else{
        fitRatio = fitRatio * playRatio / mRatio + 0.01f;
    }
    return fitRatio;
}

+ (float)getFitInScaleWithPlayViewSize:(CGSize)playViewSize clipIndex:(int)clipIndex {
    return 1;
}

//获取clip 的原始尺寸
+ (CGSize)getVideoInfoSizeWithClipIndex:(int)clipIndex storyBoard:(XYStoryboard *)storyBoard {
    CGSize videoSize = {0};
    CXiaoYingClip *clip = [storyBoard getClipByIndex:clipIndex];
    MRECT clipRect = [storyBoard getClipCropRectByClip:clip];
    if (clipRect.right > 0 && clipRect.bottom > 0) {
        videoSize.width = clipRect.right - clipRect.left;
        videoSize.height = clipRect.bottom - clipRect.top;
    }else{
        AMVE_VIDEO_INFO_TYPE videoInfo = [storyBoard getVideoInfoWithClipIndex:clipIndex];
        videoSize.width = videoInfo.dwFrameWidth;
        videoSize.height = videoInfo.dwFrameHeight;
    }
    return videoSize;
}

+ (NSMutableDictionary *)getProjectParamByClipIndex:(int)idx storyBoard:(XYStoryboard *)storyBoard {
    NSMutableDictionary *dic = [NSMutableDictionary new];
    //获取工程模板类型
    CXiaoYingEffect *effect = [storyBoard getEffectByClipIndex:idx trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM];
    NSString * effectC = [XYCommonEngineGlobalData data].configModel.effectXytCFilePath;
    NSString * effectD = [XYCommonEngineGlobalData data].configModel.effectXytDFilePath;
    NSString * effectE = [XYCommonEngineGlobalData data].configModel.effectXytEFilePath;
    NSString * effectF = [XYCommonEngineGlobalData data].configModel.effectXytFFilePath;

    NSString *effectStr = [storyBoard getEffectPath:effect];
    if (effectStr && [effectStr isEqualToString:effectC]) {
        [dic setValue:@"C" forKey:@"type"];
    }else if (effectStr && [effectStr isEqualToString:effectD]){
        [dic setValue:@"D" forKey:@"type"];
    }else if (effectStr && ([effectStr isEqualToString:effectE] || [effectStr isEqualToString:effectF])){
        if ([effectStr isEqualToString:effectE]) {
            [dic setValue:@"E" forKey:@"type"];
        }else{
            [dic setValue:@"F" forKey:@"type"];
        }
        NSString *photoPath = [XYClipEditRatioService getProjectEffectPhotoPathWithClipIndex:idx storyBoard:storyBoard];
        if (![NSString xy_isEmpty:photoPath]) {
            [dic setValue:photoPath forKey:@"photoPath"];
        }
    }
    for (int i = 1; i <= 12; i ++) {
        MLong lValue = 0;
        if (i== 1 || i == 2) {
            lValue = 1;
        }
        if ([NSString xy_isEmpty:[dic valueForKey:@"type"]]) {
            [dic setValue:@(lValue) forKey:[NSString stringWithFormat:@"%d",i]];
        }else if ([[dic valueForKey:@"type"] isEqualToString:@"C"]){
            QVET_EFFECT_PROPDATA proData = {i,lValue};
            [storyBoard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:idx];
            if (i== 1 || i == 2 || i== 4 || i == 5) {
                float value = proData.lValue / 5000.0 - 10;
                [dic setValue:@(value) forKey:[NSString stringWithFormat:@"%d",i]];
            }else{
                [dic setValue:@(proData.lValue) forKey:[NSString stringWithFormat:@"%d",i]];
            }
        }else{
            if (i <= 7) {
                QVET_EFFECT_PROPDATA proData = {i,lValue};
                [storyBoard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:idx];
                if (i == 1 || i == 2 || i== 4 || i == 5) {
                    float value = proData.lValue / 5000.0 - 10;
                    [dic setValue:@(value) forKey:[NSString stringWithFormat:@"%d",i]];
                }else{
                    [dic setValue:@(proData.lValue) forKey:[NSString stringWithFormat:@"%d",i]];
                }
            }else{
                [dic setValue:@(lValue) forKey:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    return dic;
}


#pragma mark - 引擎相关

+ (void)setEffect:(XYClipModel *)clipModel storyBoard:(XYStoryboard *)storyBoard {
    //:(XYCommonEnginebackgroundType)type doAnim:(BOOL)doAnim currentClipIndex:(int)currentClipIndex storyBoard:(XYStoryboard *)storyBoard {
    NSString * effectPath = @"";
    XYCommonEnginebackgroundType type = clipModel.clipPropertyData.effectType;
    if (XYCommonEngineBackgroundColor == type) {
        effectPath = [XYCommonEngineGlobalData data].configModel.effectXytCFilePath;
    } else if (XYCommonEngineBackgroundBlur == type) {
        effectPath = [XYCommonEngineGlobalData data].configModel.effectXytDFilePath;
    } else if (XYCommonEngineBackgroundImage == type) {
        if (clipModel.clipPropertyData.backgroundBlurValue < 10) {
            effectPath = [XYCommonEngineGlobalData data].configModel.effectXytFFilePath;
        } else {
            effectPath = [XYCommonEngineGlobalData data].configModel.effectXytEFilePath;
        }
    } else {
        return;
    }
    if ([NSString xy_isEmpty:effectPath]) {
        return;
    }
    //    设置模板
    [storyBoard setClipEffect:effectPath effectConfigIndex:0 dwClipIndex:clipModel.clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupId:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM layerId:LAYER_ID_PANZOOM];
    CXiaoYingClip *clip = [storyBoard getClipByIndex:clipModel.clipIndex];
    MBool bDisable = MTrue;
    [clip setProperty:AMVE_PROP_CLIP_PANZOOM_DISABLED PropertyData:&bDisable];
    MDWord dwClipType = AMVE_CLIP_TYPE_BASE;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&dwClipType];
    BOOL isVideo = AMVE_VIDEO_CLIP == dwClipType;
    //切换模板时设置当前clip的动画
    if (!isVideo) {
        [self setSingleClipAnimationWithClipIndex:clipModel.clipIndex effectType:type doAnim:clipModel.clipPropertyData.isAnimationON storyBoard:storyBoard];
    } else {
        [self setSingleClipAnimationWithClipIndex:clipModel.clipIndex effectType:type doAnim:NO storyBoard:storyBoard];
    }
}

+ (void)setSingleClipAnimationWithClipIndex:(int)dwClipIndex
                                 effectType:(XYCommonEnginebackgroundType)effectType
                                     doAnim:(BOOL)doAnim
                                 storyBoard:(XYStoryboard *)storyBoard
{//关掉视频的动画
    int animPropertyID = 8;
    MLong animLValue = 0.0;
    if (doAnim) {
        animLValue = XY_ANIMATION_VALUE;
    }
    MDWord trackType = AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO;
    MDWord groupID = GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM;
    if (XYCommonEngineBackgroundColor == effectType) {
        animPropertyID = 13;
    } else if (XYCommonEngineBackgroundNormal == effectType){
        trackType = AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO;
        groupID = GROUP_ID_VIDEO_PARAM_ANIM_PANZOOM;
    }
    QVET_EFFECT_PROPDATA proData = {animPropertyID, animLValue};
    [storyBoard setEffectPropertyWithPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:dwClipIndex trackType:trackType groupID:groupID];
}

+ (void)setEffectPropertyWithDwPropertyID:(NSInteger)dwPropertyID
                                    value:(CGFloat)value
                                clipIndex:(NSInteger)idx
                               storyBoard:(XYStoryboard *)storyBoard {

    [storyBoard setEffectPropertyWithPropertyID:dwPropertyID value:value clipIndex:idx];
}

+ (NSString *)getProjectEffectPhotoPathWithClipIndex:(int)clipIndex storyBoard:(XYStoryboard *)storyBoard {
    QVET_EFFECT_EXTERNAL_SOURCE effectSource = {0};
    
    AMVE_POSITION_RANGE_TYPE clipRange = {0};
    clipRange.dwPos = 0;
    clipRange.dwLen = -1;
    effectSource.dataRange = clipRange;
    
    AMVE_MEDIA_SOURCE_TYPE mediaSource = {
        AMVE_MEDIA_SOURCE_TYPE_FILE,
        (char *)malloc(MAX_PATH),
        MFalse};
    effectSource.pSource = &mediaSource;
    MRESULT res = [storyBoard getExternalSourceWithClipIndex:clipIndex source:&effectSource];
    if (res) {
        return nil;
    }else{
        AMVE_MEDIA_SOURCE_TYPE *mediaSource = effectSource.pSource;
        NSString *photoPath = [NSString stringWithUTF8String:(char *)mediaSource->pSource];
        return photoPath;
    }
}

+ (BOOL)getOriginVideoRaitoIsEqualStoryBoardRatioWithClipIndex:(int)clipIndex storyBoard:(XYStoryboard *)storyBoard {
    float storyBoardRatio = 0;
    MPOINT outPutResolution = {0,0};
    [storyBoard getOutputResolution:&outPutResolution];
    float outPutResolutionX = outPutResolution.x;
    float outPutResolutionY = outPutResolution.y;
    if (outPutResolutionY == 0) {
        storyBoardRatio = 0;
    }else{
        storyBoardRatio = outPutResolutionX / outPutResolutionY;
    }
    MSIZE videoSize = {0};
    CGSize videoSourceInfosize = [XYClipEditRatioService getVideoInfoSizeWithClipIndex:clipIndex storyBoard:storyBoard];
    float originRatio = 0;
    originRatio = videoSourceInfosize.width / (float)videoSourceInfosize.height;

    originRatio  = floor(originRatio * 100) / 100.0;
    storyBoardRatio  = floor(storyBoardRatio * 100) / 100.0;
    if (originRatio - 0.01 < storyBoardRatio && storyBoardRatio < originRatio + 0.01) {
        return YES;
    }else{
        return NO;
    }
}

@end
