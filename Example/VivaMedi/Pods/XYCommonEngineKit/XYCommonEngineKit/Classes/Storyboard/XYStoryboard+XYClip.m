//
//  XYStoryboard+XYClip.m
//  XYCommonEngineKit
//
//  Created by lizitao on 2019/9/17.
//

#import "XYStoryboard+XYClip.h"
#import "XYEditUtils.h"
#import "XYCommonEngineUtility.h"
#import "XYBaseClipTaskProperty.h"
#import "XYClipEditRatioService.h"
#import <XYCategory/XYCategory.h>

@implementation XYStoryboard(Clip)

- (CXiaoYingClip *)createClip:(NSString *)clipFullPath srcRangeLen:(MDWord)srcRangeLen
{
    return [self createClip:clipFullPath srcRangePos:0 srcRangeLen:srcRangeLen trimRangePos:0 trimRangeLen:2000];
}
    
- (CXiaoYingClip *)createPhotoClip:(NSString *)filePath
                       srcRangeLen:(MDWord)srcRangeLen
                      trimRangeLen:(MDWord)trimRangeLen
{
    return [self createClip:filePath srcRangePos:0 srcRangeLen:srcRangeLen trimRangePos:0 trimRangeLen:trimRangeLen];
}
    
- (CXiaoYingClip *)createClip:(NSString *)clipFullPath
                  srcRangePos:(MDWord)srcRangePos
                  srcRangeLen:(MDWord)srcRangeLen
                 trimRangePos:(MDWord)trimRangePos
                 trimRangeLen:(MDWord)trimRangeLen
{
    CXiaoYingClip *cXiaoYingClip = [[CXiaoYingClip alloc] init];
    AMVE_MEDIA_SOURCE_TYPE mediaSource = {
        AMVE_MEDIA_SOURCE_TYPE_FILE,
        (MVoid *)[clipFullPath cStringUsingEncoding:NSUTF8StringEncoding],
        MFalse};
    MRESULT res = [cXiaoYingClip Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] MediaSource:&mediaSource];
    AMVE_POSITION_RANGE_TYPE srcRange = {0};
    AMVE_POSITION_RANGE_TYPE trimRange = {0};
    MDWord dwResampleMode = AMVE_RESAMPLE_MODE_UPSCALE_FITIN;
    QVET_CHECK_VALID_GOTO(res);
    
    srcRange.dwPos = srcRangePos;
    srcRange.dwLen = srcRangeLen;
    res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_SRC_RANGE PropertyData:&srcRange];
    QVET_CHECK_VALID_GOTO(res);
    
    trimRange.dwPos = trimRangePos;
    trimRange.dwLen = trimRangeLen;
    res = [self setClipTrimRange:cXiaoYingClip trimRange:trimRange];
    QVET_CHECK_VALID_GOTO(res)
    
    res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_RESAMPLE_MODE PropertyData:&dwResampleMode];
    QVET_CHECK_VALID_GOTO(res);
    
FUN_EXIT:
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createClip err=0x%lx", res);
    }
    return cXiaoYingClip;
}

- (MRESULT)insertClip:(CXiaoYingClip *)cXiaoYingClip
             Position:(MDWord)dwIndex
{
    if (!cXiaoYingClip || !self.cXiaoYingStoryBoardSession) {
        return QVET_ERR_APP_FAIL;
    }
    [self setModified:YES];
    MRESULT res = [self.cXiaoYingStoryBoardSession insertClip:cXiaoYingClip Position:dwIndex];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard insertClip1 err=0x%lx", res);
    }
    return res;
}
    
- (MRESULT)insertClipByClipDataItem:(XYClipDataItem *)clipDataItem Position:(MDWord)dwIndex
{
    [XYCommonEngineUtility xy_createFolder:[clipDataItem.clipFilePath stringByDeletingLastPathComponent]];
    NSString *clipFullPath = clipDataItem.clipFilePath;
    NSString *effectPath = clipDataItem.filterFilePath;
    MDWord effectConfigIndex = clipDataItem.filterConfigIndex;
    MDWord startPos = clipDataItem.startPos;
    MDWord endPos = clipDataItem.endPos;
    float timeScale = clipDataItem.timeScale;
    MRECT cropRect = {(MLong)CGRectGetMinX(clipDataItem.cropRect), (MLong)CGRectGetMinY(clipDataItem.cropRect), (MLong)CGRectGetMaxX(clipDataItem.cropRect), (MLong)CGRectGetMaxY(clipDataItem.cropRect)};
    MDWord rotation = clipDataItem.rotation;
    
    BOOL isLandScapeClip = NO;
    MBool setPanZoomDisabled = MFalse;
    [self setModified:YES];
    CXiaoYingClip *cXiaoYingClip = [[CXiaoYingClip alloc] init];
    AMVE_VIDEO_INFO_TYPE clipInfo = {0};
    MDWord dwClipType = AMVE_CLIP_TYPE_BASE;
    MDWord dwResampleMode = AMVE_RESAMPLE_MODE_UPSCALE_FITIN;
    AMVE_POSITION_RANGE_TYPE clipRange = {0};
    AMVE_MEDIA_SOURCE_TYPE mediaSource = {
        AMVE_MEDIA_SOURCE_TYPE_FILE,
        (MVoid *)[clipFullPath cStringUsingEncoding:NSUTF8StringEncoding],
        MFalse};
    MRESULT res = [cXiaoYingClip Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] MediaSource:&mediaSource];
    QVET_CHECK_VALID_GOTO(res);
    [self setClipIdentifier:cXiaoYingClip identifier:clipDataItem.identifier];
    //获取clip类型
    res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&dwClipType];
       QVET_CHECK_VALID_GOTO(res);
    
    clipRange.dwPos = startPos;
    clipRange.dwLen = endPos - startPos;
    
    //
    if (AMVE_IMAGE_CLIP == dwClipType) {
        clipRange.dwPos = 0;
        clipRange.dwLen = 3000;
    } else if (AMVE_GIF_CLIP == dwClipType) {
        AMVE_POSITION_RANGE_TYPE gifRange = [self getClipSourceRangeByClip:cXiaoYingClip];
        if (0 == gifRange.dwLen) {
            gifRange.dwLen = 3000;
        }
        clipRange.dwPos = gifRange.dwPos;
        clipRange.dwLen = gifRange.dwLen;
    } else if (0 == clipRange.dwLen) {
        clipRange = [self getClipSourceRangeByClip:cXiaoYingClip];
    }
    AMVE_POSITION_RANGE_TYPE trimRange = {0};
    trimRange.dwPos = clipDataItem.trimPos;
    trimRange.dwLen = clipDataItem.trimLen;
    if (0 != trimRange.dwLen) {
        res = [self setClipTrimRange:cXiaoYingClip trimRange:trimRange];
    }
    
    res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_SRC_RANGE PropertyData:&clipRange];
    QVET_CHECK_VALID_GOTO(res);
    
    // 将原先针对video的crop rotate设置开放给image
    if (YES || AMVE_VIDEO_CLIP == dwClipType) {
        res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_SOURCE_INFO PropertyData:&clipInfo];
        QVET_CHECK_VALID_GOTO(res);
        MLong left = cropRect.left * 10000 / clipInfo.dwFrameWidth;
        MLong top = cropRect.top * 10000 / clipInfo.dwFrameHeight;
        MLong right = cropRect.right * 10000 / clipInfo.dwFrameWidth;
        MLong bottom = cropRect.bottom * 10000 / clipInfo.dwFrameHeight;
        MRECT rectForEngine = {left, top, right, bottom};
        if (clipInfo.dwFrameWidth > clipInfo.dwFrameHeight) {
            isLandScapeClip = YES;
        } else {
            isLandScapeClip = NO;
        }
        if (right > 0 && bottom > 0) {
            if (cropRect.right - cropRect.left > cropRect.bottom - cropRect.top) {
                isLandScapeClip = YES;
            } else {
                isLandScapeClip = NO;
            }
            res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&rectForEngine];
            QVET_CHECK_VALID_GOTO(res)
        }
        
        if (rotation == 90 || rotation == 270) {
            isLandScapeClip = !isLandScapeClip;
        }
        res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_ROTATION PropertyData:&rotation];
        MDWord rotate;
        [cXiaoYingClip getProperty:AMVE_PROP_CLIP_ROTATION PropertyData:&rotate];
        
        QVET_CHECK_VALID_GOTO(res)
    }
    
    res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_RESAMPLE_MODE PropertyData:&dwResampleMode];
    QVET_CHECK_VALID_GOTO(res);
    
    res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_TIME_SCALE PropertyData:&timeScale];
    
    if (!isLandScapeClip) {
        if (AMVE_GIF_CLIP == dwClipType) {
            res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_PANZOOM_DISABLED PropertyData:&setPanZoomDisabled];
        }
    }
    
    res = [self.cXiaoYingStoryBoardSession insertClip:cXiaoYingClip Position:dwIndex];
    
    [self keepTone:dwIndex keep:YES];
    
    if (effectPath && !res) {
        [self setClipEffect:effectPath effectConfigIndex:effectConfigIndex dwClipIndex:dwIndex groupId:GROUP_IMAGING_EFFECT layerId:LAYER_ID_EFFECT];
    }
    {
        //TODO:sunshine 代码待整理
        XYBaseClipTaskProperty *taskProperty = [XYBaseClipTaskProperty new];
        taskProperty.storyboard = self;
        XYClipModel *model = [XYClipModel new];
        model.clipPropertyData.scale = 1;
        model.clipPropertyData.shiftX = 0;
        model.clipPropertyData.shiftY = 0;
        model.clipPropertyData.angleZ = 0;
        model.clipPropertyData.backgroundBlurValue = 50;
        model.clipPropertyData.isAnimationON = AMVE_IMAGE_CLIP == dwClipType;
        model.clipPropertyData.effectType = XYCommonEngineBackgroundBlur;
        model.clipIndex = dwIndex;
        [taskProperty switchEffectWithEffectType:XYCommonEngineBackgroundBlur clipModel:model skipSetProperty:NO];
    }
    QVET_CHECK_VALID_GOTO(res);
    //by gongjun: don't add code here any more...... code should be added before insertClip
    
FUN_EXIT:
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard insertClip3 err=0x%lx", res);
        if (cXiaoYingClip) {
            [cXiaoYingClip UnInit];
            cXiaoYingClip = nil;
        }
    }
    return res;
}

- (MRESULT)replaceClip:(CXiaoYingClip *)clip
          clipFullPath:(NSString *)clipFullPath
            videoRange:(AMVE_POSITION_RANGE_TYPE)videoRange
             trimRange:(AMVE_POSITION_RANGE_TYPE)trimRange {
    AMVE_MEDIA_SOURCE_TYPE mediaSource = {
                                    AMVE_MEDIA_SOURCE_TYPE_FILE,
                                    (MVoid *)[clipFullPath cStringUsingEncoding:NSUTF8StringEncoding],
                                    MFalse};
    MRESULT res = [clip ReplaceSource:&mediaSource SrcRange:videoRange TrimRange:trimRange];
    MBool setPanZoomDisabled = MTrue;
    res = [clip setProperty:AMVE_PROP_CLIP_PANZOOM_DISABLED PropertyData:&setPanZoomDisabled];
    return res;
}

- (void)setEffectPropertyWithPropertyID:(NSInteger)dwPropertyID
                                    value:(CGFloat)value
                                clipIndex:(NSInteger)idx {

    QVET_EFFECT_PROPDATA proData = {dwPropertyID, 0};
        switch (dwPropertyID) {
            case 1:
            case 2: //scarex scarey
                if (value == 1.0) {
                    value = value + 0.01;//fix 原比例时 scale ==1 会有漏出底部设置的背景颜色
                }
                proData.lValue = (MLong)((value + 10.0) * 5000);
                break;
            case 3: //angleZ
                proData.lValue = (MLong)value * 100;
                break;
            case 4:
                proData.lValue = (MLong)((value + 10.0) * 5000);
                break;
            case 5: //shiftX shiftY
                proData.lValue = (MLong)((value + 10.0) * 5000);
                if ([[XYEngine sharedXYEngine] getMetalEnable]) {
                    proData.lValue = (MLong)((10.0 - value) * 5000);
                }
                break;
            case 6:
            case 7:{
                proData.lValue = (MLong)value;
            }
                break;
            case 8: // start r g  b
            case 9:
            case 10:
            case 11: // end r g  b
            case 12: // linearGradientAngle
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
                proData.lValue = (MLong)value;
                break;
            default:
                break;
        }
        [self setEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:idx];
}

- (MRESULT)insertEmptyClip:(MDWord)dwIndex
                  duration:(MDWord)duration
{
    MBool setPanZoomDisabled = MTrue;
    [self setModified:YES];
    CXiaoYingClip *cXiaoYingClip = [[CXiaoYingClip alloc] init];
    MDWord dwClipType = AMVE_CLIP_TYPE_BASE;
    MDWord dwResampleMode = AMVE_RESAMPLE_MODE_UPSCALE_FITIN;
    AMVE_POSITION_RANGE_TYPE clipRange = {0};
    NSString *emptyImageFilePath = nil; //[[[NSBundle xy_xiaoyingBundle] resourcePath] stringByAppendingPathComponent:@"xiaoying_gallery_blank50_50@2x.png"]; -- todo
    AMVE_MEDIA_SOURCE_TYPE mediaSource = {
        AMVE_MEDIA_SOURCE_TYPE_FILE,
        (MVoid *)[emptyImageFilePath cStringUsingEncoding:NSUTF8StringEncoding],
        MFalse};
    MRESULT res = [cXiaoYingClip Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] MediaSource:&mediaSource];
    QVET_CHECK_VALID_GOTO(res);
    
    clipRange.dwPos = 0;
    clipRange.dwLen = duration;
    res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_SRC_RANGE PropertyData:&clipRange];
    QVET_CHECK_VALID_GOTO(res);
    
    res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&dwClipType];
    QVET_CHECK_VALID_GOTO(res);
    
    res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_RESAMPLE_MODE PropertyData:&dwResampleMode];
    QVET_CHECK_VALID_GOTO(res);
    
    res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_PANZOOM_DISABLED PropertyData:&setPanZoomDisabled];
    QVET_CHECK_VALID_GOTO(res);
    
    res = [self.cXiaoYingStoryBoardSession insertClip:cXiaoYingClip Position:dwIndex];
    QVET_CHECK_VALID_GOTO(res);
    
FUN_EXIT:
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard insertClip3 err=0x%lx", res);
        if (cXiaoYingClip) {
            [cXiaoYingClip UnInit];
            cXiaoYingClip = nil;
        }
    }
    return res;
}
    
- (MRESULT)moveClip:(MDWord)dwOriginalIndex dwDestIndex:(MDWord)dwDestIndex
{
    [self setModified:YES];
    CXiaoYingClip *cXiaoYingClip = [self getClipByIndex:dwOriginalIndex];
    MRESULT res = [self.cXiaoYingStoryBoardSession moveClip:cXiaoYingClip Position:dwDestIndex];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard moveClip err=0x%lx", res);
    }
    return res;
}
    
- (MRESULT)deleteClip:(MDWord)dwIndex
{
    [self setModified:YES];
    MRESULT res = MERR_NONE;
    CXiaoYingClip *xyClip = [self getClipByIndex:dwIndex];
    if (xyClip) {
        res = [self.cXiaoYingStoryBoardSession removeClip:xyClip];
    }
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard deleteClip err=0x%lx", res);
    }
    return res;
}
    
- (void)deleteClips:(NSArray<NSNumber *> *)indexArray
{
    if ([indexArray count] == 0) {
        return;
    }
    [self setModified:YES];
    NSMutableArray<CXiaoYingClip *> *clips = [NSMutableArray array];
    [indexArray enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        CXiaoYingClip *clip = [self getClipByIndex:[obj integerValue]];
        if (clip) {
            [clips addObject:clip];
        }
    }];
    [clips enumerateObjectsUsingBlock:^(CXiaoYingClip *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        MRESULT res = [self.cXiaoYingStoryBoardSession removeClip:obj];
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard deleteClips err=0x%lx", res);
        }
    }];
    return;
}
    
- (MRESULT)deleteAllClips
{
    MRESULT res = MERR_NONE;
    res = [self.cXiaoYingStoryBoardSession removeAllClip];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard deleteAllClips err=0x%lx", res);
    }
    return res;
}
    
- (CXiaoYingClip *)duplicateClip:(MDWord)dwIndex
{
    CXiaoYingClip *originalClip = [self getClipByIndex:dwIndex];
    return [self duplicateClipByClip:originalClip];
}
    
- (CXiaoYingClip *)duplicateClipByClip:(CXiaoYingClip *)originalClip
{
    [self setModified:YES];
    MRESULT res = MERR_NONE;
    CXiaoYingClip *duplicatedClip = [[CXiaoYingClip alloc] init];
    
    if (originalClip) {
        res = [duplicatedClip duplicate:originalClip];
    }
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard duplicateClip err=0x%lx", res);
    }
    return duplicatedClip;
}
    

- (MRESULT)splitClip:(MDWord)dwIndex splitOffsetPos:(MDWord)splitOffsetPos leftSplitLen:(MDWord)leftSplitLen rightSplitLen:(MDWord)rightSplitLen identifier:(NSString *)identifier backTransTime:(NSInteger)backTransTime {
    [self setModified:YES];
    MRESULT res = MERR_NONE;
    CXiaoYingClip *splittedClip = [[CXiaoYingClip alloc] init];
    CXiaoYingClip *originalClip = [self getClipByIndex:dwIndex];
    
    float timeScale = [self getClipTimeScale:dwIndex];
    
    //original clip ranges
    AMVE_POSITION_RANGE_TYPE originalClipTimeScaledSourceRange = [self getClipSourceRange:dwIndex];
    originalClipTimeScaledSourceRange.dwPos = [XYEditUtils originalDurationToTimeScaledDuration:originalClipTimeScaledSourceRange.dwPos timeScale:timeScale];
    originalClipTimeScaledSourceRange.dwLen = [XYEditUtils originalDurationToTimeScaledDuration:originalClipTimeScaledSourceRange.dwLen timeScale:timeScale];
    AMVE_POSITION_RANGE_TYPE originalClipTimeScaledTrimRange = [self getClipTrimRangeByIndex:dwIndex];
    
    //first splitted clip ranges
    AMVE_POSITION_RANGE_TYPE firstSplittedClipTimeScaledSourceRange = {originalClipTimeScaledSourceRange.dwPos + originalClipTimeScaledTrimRange.dwPos, leftSplitLen + splitOffsetPos};
    AMVE_POSITION_RANGE_TYPE firstSplittedClipTimeScaledTrimRange = {splitOffsetPos, leftSplitLen};
    MDWord dwPos = [XYEditUtils timeScaledDurationToOriginalDuration:firstSplittedClipTimeScaledSourceRange.dwPos timeScale:timeScale];
    MDWord dwLen = [XYEditUtils timeScaledDurationToOriginalDuration:firstSplittedClipTimeScaledSourceRange.dwLen timeScale:timeScale];
    AMVE_POSITION_RANGE_TYPE firstSplittedClipOriginalSourceRange = {dwPos, dwLen};
    
    //second splitted clip ranges
    AMVE_POSITION_RANGE_TYPE secondSplittedClipTimeScaledSourceRange = {firstSplittedClipTimeScaledSourceRange.dwPos + firstSplittedClipTimeScaledSourceRange.dwLen , originalClipTimeScaledSourceRange.dwLen - leftSplitLen};
    AMVE_POSITION_RANGE_TYPE secondSplittedClipTimeScaledTrimRange = {0, rightSplitLen};
    dwPos = [XYEditUtils timeScaledDurationToOriginalDuration:secondSplittedClipTimeScaledSourceRange.dwPos timeScale:timeScale];
    dwLen = [XYEditUtils timeScaledDurationToOriginalDuration:secondSplittedClipTimeScaledSourceRange.dwLen timeScale:timeScale];
    AMVE_POSITION_RANGE_TYPE secondSplittedClipOriginalSourceRange = {dwPos, dwLen};
    
    //duplicate from the original clip
    res = [splittedClip duplicate:originalClip];
    [self setClipIdentifier:splittedClip identifier:identifier];
    if (rightSplitLen < backTransTime) {
        [self setClipTransition:[XYCommonEngineGlobalData data].configModel.effectDefaultTransFilePath configureIndex:0 pClip:splittedClip];
      }
    //set splitted clip range
    //CAUTION:We need to set the original source range NOT the timescaled one to the engine !!!
    res = [self setClipSourceRange:splittedClip sourceRange:secondSplittedClipOriginalSourceRange];
    res = [self setClipTrimRange:splittedClip trimRange:secondSplittedClipTimeScaledTrimRange];
    //insert second splitted clip to storyboard
    res = [self insertClip:splittedClip Position:dwIndex + 1];
    //set original clip range
    //CAUTION:We need to set the original source range NOT the timescaled one to the engine !!!
    res = [self setClipSourceRange:originalClip sourceRange:firstSplittedClipOriginalSourceRange];
    res = [self setClipTrimRange:originalClip trimRange:firstSplittedClipTimeScaledTrimRange];
    
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard splitClip err=0x%lx", res);
    }
    return res;
}


- (MRESULT)splitClip:(MDWord)dwIndex splitPosition:(MDWord)splitPosition
{
    [self setModified:YES];
    MRESULT res = MERR_NONE;
    CXiaoYingClip *splittedClip = [[CXiaoYingClip alloc] init];
    CXiaoYingClip *originalClip = [self getClipByIndex:dwIndex];
    
    float timeScale = [self getClipTimeScale:dwIndex];
    
    //original clip ranges
    AMVE_POSITION_RANGE_TYPE originalClipTimeScaledSourceRange = [self getClipSourceRange:dwIndex];
    originalClipTimeScaledSourceRange.dwPos = [XYEditUtils originalDurationToTimeScaledDuration:originalClipTimeScaledSourceRange.dwPos timeScale:timeScale];
    originalClipTimeScaledSourceRange.dwLen = [XYEditUtils originalDurationToTimeScaledDuration:originalClipTimeScaledSourceRange.dwLen timeScale:timeScale];
    AMVE_POSITION_RANGE_TYPE originalClipTimeScaledTrimRange = [self getClipTrimRangeByIndex:dwIndex];
    
    //first splitted clip ranges
    AMVE_POSITION_RANGE_TYPE firstSplittedClipTimeScaledSourceRange = {originalClipTimeScaledSourceRange.dwPos, splitPosition};
    AMVE_POSITION_RANGE_TYPE firstSplittedClipTimeScaledTrimRange = {originalClipTimeScaledTrimRange.dwPos, splitPosition - originalClipTimeScaledTrimRange.dwPos};
    MDWord dwPos = [XYEditUtils timeScaledDurationToOriginalDuration:firstSplittedClipTimeScaledSourceRange.dwPos timeScale:timeScale];
    MDWord dwLen = [XYEditUtils timeScaledDurationToOriginalDuration:firstSplittedClipTimeScaledSourceRange.dwLen timeScale:timeScale];
    AMVE_POSITION_RANGE_TYPE firstSplittedClipOriginalSourceRange = {dwPos, dwLen};
    
    //second splitted clip ranges
    AMVE_POSITION_RANGE_TYPE secondSplittedClipTimeScaledSourceRange = {originalClipTimeScaledSourceRange.dwPos + splitPosition, originalClipTimeScaledSourceRange.dwLen - splitPosition};
    AMVE_POSITION_RANGE_TYPE secondSplittedClipTimeScaledTrimRange = {0, originalClipTimeScaledTrimRange.dwPos + originalClipTimeScaledTrimRange.dwLen - splitPosition};
    dwPos = [XYEditUtils timeScaledDurationToOriginalDuration:secondSplittedClipTimeScaledSourceRange.dwPos timeScale:timeScale];
    dwLen = [XYEditUtils timeScaledDurationToOriginalDuration:secondSplittedClipTimeScaledSourceRange.dwLen timeScale:timeScale];
    AMVE_POSITION_RANGE_TYPE secondSplittedClipOriginalSourceRange = {dwPos, dwLen};
    
    //duplicate from the original clip
    res = [splittedClip duplicate:originalClip];
    
    //set splitted clip range
    //CAUTION:We need to set the original source range NOT the timescaled one to the engine !!!
    res = [self setClipSourceRange:splittedClip sourceRange:secondSplittedClipOriginalSourceRange];
    res = [self setClipTrimRange:splittedClip trimRange:secondSplittedClipTimeScaledTrimRange];
    //insert second splitted clip to storyboard
    res = [self insertClip:splittedClip Position:dwIndex + 1];
    
    //set original clip range
    //CAUTION:We need to set the original source range NOT the timescaled one to the engine !!!
    res = [self setClipSourceRange:originalClip sourceRange:firstSplittedClipOriginalSourceRange];
    res = [self setClipTrimRange:originalClip trimRange:firstSplittedClipTimeScaledTrimRange];
    
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard splitClip err=0x%lx", res);
    }
    return res;
}
    
- (MRESULT)splitReverseClip:(MDWord)dwIndex splitPosition:(MDWord)splitPosition
{
    [self setModified:YES];
    MRESULT res = MERR_NONE;
    CXiaoYingClip *splittedClip = [[CXiaoYingClip alloc] init];
    CXiaoYingClip *originalClip = [self getClipByIndex:dwIndex];
    
    float timeScale = [self getClipTimeScale:dwIndex];
    
    //original clip ranges
    AMVE_POSITION_RANGE_TYPE originalClipTimeScaledSourceRange = [self getClipSourceRange:dwIndex];
    originalClipTimeScaledSourceRange.dwPos = [XYEditUtils originalDurationToTimeScaledDuration:originalClipTimeScaledSourceRange.dwPos timeScale:timeScale];
    originalClipTimeScaledSourceRange.dwLen = [XYEditUtils originalDurationToTimeScaledDuration:originalClipTimeScaledSourceRange.dwLen timeScale:timeScale];
    AMVE_POSITION_RANGE_TYPE originalClipTimeScaledTrimRange = [self getClipReverseTrimRange:dwIndex];
    
    BOOL splitPositionInCutLeft = NO;//分割点是否在 cut 的左边
    if (splitPosition <= originalClipTimeScaledTrimRange.dwPos) {//在 cut 左边
        splitPositionInCutLeft = YES;
    }else{
        splitPosition = (splitPosition - originalClipTimeScaledTrimRange.dwPos) + (originalClipTimeScaledTrimRange.dwPos + originalClipTimeScaledTrimRange.dwLen);
        splitPositionInCutLeft = NO;
    }
    //first splitted clip ranges 分割后左边的
    AMVE_POSITION_RANGE_TYPE firstSplittedClipTimeScaledSourceRange = {originalClipTimeScaledSourceRange.dwPos, splitPosition};
    AMVE_POSITION_RANGE_TYPE firstSplittedClipTimeScaledTrimRange = {0, splitPosition};
    MDWord dwPos = [XYEditUtils timeScaledDurationToOriginalDuration:firstSplittedClipTimeScaledSourceRange.dwPos timeScale:timeScale];
    MDWord dwLen = [XYEditUtils timeScaledDurationToOriginalDuration:firstSplittedClipTimeScaledSourceRange.dwLen timeScale:timeScale];
    AMVE_POSITION_RANGE_TYPE firstSplittedClipOriginalSourceRange = {dwPos, dwLen};
    
    //second splitted clip ranges
    AMVE_POSITION_RANGE_TYPE secondSplittedClipTimeScaledSourceRange = {splitPosition, originalClipTimeScaledSourceRange.dwLen - splitPosition};
    AMVE_POSITION_RANGE_TYPE secondSplittedClipTimeScaledTrimRange = {splitPosition, originalClipTimeScaledTrimRange.dwPos};//默认 在 cut 左分割
    if (!splitPositionInCutLeft) {//在cut 右边 分割
        secondSplittedClipTimeScaledTrimRange.dwPos = 0;
        secondSplittedClipTimeScaledTrimRange.dwLen = originalClipTimeScaledSourceRange.dwLen - splitPosition;
    }
    
    dwPos = [XYEditUtils timeScaledDurationToOriginalDuration:secondSplittedClipTimeScaledSourceRange.dwPos timeScale:timeScale];
    dwLen = [XYEditUtils timeScaledDurationToOriginalDuration:secondSplittedClipTimeScaledSourceRange.dwLen timeScale:timeScale];
    AMVE_POSITION_RANGE_TYPE secondSplittedClipOriginalSourceRange = {dwPos, dwLen};
    
    //duplicate from the original clip
    res = [splittedClip duplicate:originalClip];
    
    //set splitted clip range
    //CAUTION:We need to set the original source range NOT the timescaled one to the engine !!!
    MBool isReverseTrimMdoe = splitPositionInCutLeft;
    [splittedClip setProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&isReverseTrimMdoe];
    
    if (isReverseTrimMdoe) {
        res = [splittedClip setProperty:AMVE_PROP_CLIP_SRC_RANGE PropertyData:&secondSplittedClipOriginalSourceRange];
    } else {
        res = [splittedClip setProperty:AMVE_PROP_CLIP_SRC_RANGE PropertyData:&secondSplittedClipOriginalSourceRange];
    }
    //在 右边 分割
    res = [self setClipTrimRange:splittedClip trimRange:secondSplittedClipTimeScaledTrimRange];
    //insert second splitted clip to storyboard
    
    res = [self insertClip:splittedClip Position:dwIndex + 1];
    
    //set original clip range
    //CAUTION:We need to set the original source range NOT the timescaled one to the engine !!!
    res = [originalClip setProperty:AMVE_PROP_CLIP_SRC_RANGE PropertyData:&firstSplittedClipOriginalSourceRange];
    if (!splitPositionInCutLeft) {//在 cut 右边
        MBool isReverseTrimMdoe = MTrue;
        [originalClip setProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&isReverseTrimMdoe];
        res = [self setClipTrimRange:originalClip trimRange:originalClipTimeScaledTrimRange];
        
    }else{
        MBool isReverseTrimMdoe = MFalse;
        [originalClip setProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&isReverseTrimMdoe];
        res = [self setClipTrimRange:originalClip trimRange:firstSplittedClipTimeScaledTrimRange];
    }
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard splitClip err=0x%lx", res);
    }
    return res;
}
    
- (MDWord)getClipCount
{
    MDWord clipCount = [self.cXiaoYingStoryBoardSession getClipCount];
    return clipCount;
}
    
- (MDWord)getClipCountByType:(MDWord)clipType
{
    MDWord count = 0;
    MDWord clipCount = [self.cXiaoYingStoryBoardSession getClipCount];
    for (int i = 0; i < clipCount; i++) {
        CXiaoYingClip *clip = [self getClipByIndex:i];
        MDWord dwClipType = AMVE_CLIP_TYPE_BASE;
        MRESULT res = [clip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&dwClipType];
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard getClipType err=0x%lx", res);
        } else {
            if (dwClipType == clipType) {
                count++;
            }
        }
    }
    return count;
}
    
- (CXiaoYingClip *)getClipByIndex:(int)index
{
    if (index < 0) {
        return nil;
    }
    return [self.cXiaoYingStoryBoardSession getClip:index];
}
    
- (NSString *)getClipPathByIndex:(int)index
{
    if (index < 0) {
        return nil;
    }
    CXiaoYingClip *xyClip = [self.cXiaoYingStoryBoardSession getClip:index];
    return [self getClipPath:xyClip];
}
    
- (NSString *)getClipPath:(CXiaoYingClip *)xyClip
{
    if (xyClip) {
        AMVE_MEDIA_SOURCE_TYPE mediaSource = {
            AMVE_MEDIA_SOURCE_TYPE_FILE,
            (char *)malloc(MAX_PATH),
            MFalse};
        MRESULT res = [xyClip getProperty:AMVE_PROP_CLIP_SOURCE PropertyData:&mediaSource];
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard getClipPath err=0x%lx", res);
            free(mediaSource.pSource);
            return nil;
        }
        NSString *clipPath = [NSString stringWithUTF8String:(char *)mediaSource.pSource];
        free(mediaSource.pSource);
        return clipPath;
    } else {
        return nil;
    }
}

- (MRESULT)getFirstClipSize:(MSIZE *)pSize
{
    CXiaoYingClip *firstClip = [self getClipByIndex:0];
    return [self getClipSizeByClip:firstClip pSize:pSize];
}
    
- (MRESULT)getClipSizeByClip:(CXiaoYingClip *)cXiaoYingClip pSize:(MSIZE *)pSize
{
    if (!self.cXiaoYingStoryBoardSession || !pSize) {
        return QVET_ERR_APP_INVALID_PARAM;
    }
    
    MDWord dwClipCount = 0;
    MRESULT res = QVET_ERR_NONE;
    MRECT rectForEngine = {0};
    MRECT cropRect = {0};
    MDWord degree = 0;
    if (!cXiaoYingClip)
    return QVET_ERR_APP_FAIL;
    
    AMVE_VIDEO_INFO_TYPE videoInfo = {0};
    res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_SOURCE_INFO PropertyData:&videoInfo];
    QVET_CHECK_VALID_RET(res);
    
    res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&rectForEngine];
    QVET_CHECK_VALID_RET(res);
    
    res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_ROTATION PropertyData:&degree];
    QVET_CHECK_VALID_RET(res);
    
    cropRect.left = rectForEngine.left * videoInfo.dwFrameWidth / 10000;
    cropRect.top = rectForEngine.top * videoInfo.dwFrameHeight / 10000;
    cropRect.right = rectForEngine.right * videoInfo.dwFrameWidth / 10000;
    cropRect.bottom = rectForEngine.bottom * videoInfo.dwFrameHeight / 10000;
    
    if (0 == cropRect.right - cropRect.left || 0 == cropRect.bottom - cropRect.top) {
        pSize->cx = videoInfo.dwFrameWidth;
        pSize->cy = videoInfo.dwFrameHeight;
    } else {
        pSize->cx = cropRect.right - cropRect.left;
        pSize->cy = cropRect.bottom - cropRect.top;
    }
    
    if (degree == 90 || degree == 270) {
        MLong tmp = 0;
        tmp = pSize->cx;
        pSize->cx = pSize->cy;
        pSize->cy = tmp;
    }
    return res;
}
    
- (BOOL)isAllClipSameSize
{
    int clipCount = [self getClipCount];
    if (clipCount <= 1) {
        return YES;
    }
    MSIZE firstClipSize = {0};
    [self getFirstClipSize:&firstClipSize];
    
    for (int i = 1; i < clipCount; i++) {
        MSIZE size = {0};
        CXiaoYingClip *clip = [self getClipByIndex:i];
        [self getClipSizeByClip:clip pSize:&size];
        if (firstClipSize.cx != size.cx || firstClipSize.cy != size.cy) {
            return NO;
        }
    }
    return YES;
}
    
- (BOOL)isAllClipPicture
{
    int clipCount = [self getClipCount];
    
    for (int i = 0; i < clipCount; i++) {
        CXiaoYingClip *clip = [self getClipByIndex:i];
        if (![self isClipPicture:clip]) {
            return NO;
        }
    }
    return YES;
}
    
- (BOOL)isFirstClipPicture
{
    MBool bPictureMode = MFalse;
    [self isFirstClipPicture:&bPictureMode];
    return bPictureMode == MTrue;
}
    
- (MRESULT)isFirstClipPicture:(MBool *)pbPicture
{
    QVET_CHECK_POINTER_RET(pbPicture, QVET_ERR_APP_INVALID_PARAM);
    if (nil == self.cXiaoYingStoryBoardSession)
    return QVET_ERR_APP_INVALID_PARAM;
    
    MDWord dwClipCount = 0;
    dwClipCount = [self.cXiaoYingStoryBoardSession getClipCount];
    if (0 == dwClipCount)
    return QVET_ERR_APP_FAIL;
    
    CXiaoYingClip *pFirstClip = [self.cXiaoYingStoryBoardSession getClip:0];
    QVET_CHECK_POINTER_RET(pFirstClip, QVET_ERR_APP_FAIL);
    
    MDWord dwClipType = AMVE_CLIP_TYPE_BASE;
    MRESULT res = [pFirstClip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&dwClipType];
    QVET_CHECK_VALID_RET(res);
    
    if (AMVE_IMAGE_CLIP == dwClipType)
    *pbPicture = MTrue;
    else
    *pbPicture = MFalse;
    
    return QVET_ERR_NONE;
}
    
- (CXiaoYingClip *)getFirstPictureClip
{
    int clipCount = [self getClipCount];
    
    for (int i = 0; i < clipCount; i++) {
        CXiaoYingClip *clip = [self getClipByIndex:i];
        if ([self isClipPicture:clip]) {
            return clip;
        }
    }
    return nil;
}
    
- (BOOL)isClipPicture:(CXiaoYingClip *)clip
{
    MDWord dwClipType = AMVE_CLIP_TYPE_BASE;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&dwClipType];
    if (res) {
        NSLog(@"[ENGINE]isClipPicture err=0x%lx", res);
    }
    if (AMVE_IMAGE_CLIP == dwClipType)
    return YES;
    else
    return NO;
}
    
- (BOOL)isClipVideo:(CXiaoYingClip *)clip
{
    MDWord dwClipType = AMVE_CLIP_TYPE_BASE;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&dwClipType];
    if (res) {
        NSLog(@"[ENGINE]isClipVideo err=0x%lx", res);
    }
    if (AMVE_VIDEO_CLIP == dwClipType)
    return YES;
    else
    return NO;
}
    
- (BOOL)isClipGIF:(CXiaoYingClip *)clip
{
    MDWord dwClipType = AMVE_CLIP_TYPE_BASE;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&dwClipType];
    if (res) {
        NSLog(@"[ENGINE]isClipGIF err=0x%lx", res);
    }
    if (AMVE_GIF_CLIP == dwClipType)
    return YES;
    else
    return NO;
}
    
- (MRECT)getClipCropRect:(MDWord)dwClipIndex
{
    CXiaoYingClip *pClip = [self.cXiaoYingStoryBoardSession getClip:dwClipIndex];
    return [self getClipCropRectByClip:pClip];
}
    
- (MRECT)getClipCropRectByClip:(CXiaoYingClip *)cXiaoYingClip
{
    MRECT rectForEngine = {0};
    MRECT cropRect = {0};
    if (!self.cXiaoYingStoryBoardSession) {
        return cropRect;
    }
    if (!cXiaoYingClip) {
        return cropRect;
    }
    AMVE_VIDEO_INFO_TYPE videoInfo = {0};
    MRESULT res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_SOURCE_INFO PropertyData:&videoInfo];
    res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&rectForEngine];
    
    if (res == QVET_ERR_NONE) {
        cropRect.left = rectForEngine.left * videoInfo.dwFrameWidth / 10000;
        cropRect.top = rectForEngine.top * videoInfo.dwFrameHeight / 10000;
        cropRect.right = rectForEngine.right * videoInfo.dwFrameWidth / 10000;
        cropRect.bottom = rectForEngine.bottom * videoInfo.dwFrameHeight / 10000;
        return cropRect;
    } else {
        NSLog(@"[ENGINE]XYStoryboard getClipCropRect err=0x%lx", res);
        return cropRect;
    }
}
    
- (MRESULT)setClipCropRectByClip:(CXiaoYingClip *)cXiaoYingClip cropRect:(MRECT)cropRect
{
    AMVE_VIDEO_INFO_TYPE clipInfo = {0};
    MRESULT res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_SOURCE_INFO PropertyData:&clipInfo];
    MLong left = cropRect.left * 10000 / clipInfo.dwFrameWidth;
    MLong top = cropRect.top * 10000 / clipInfo.dwFrameHeight;
    MLong right = cropRect.right * 10000 / clipInfo.dwFrameWidth;
    MLong bottom = cropRect.bottom * 10000 / clipInfo.dwFrameHeight;
    MRECT rectForEngine = {left, top, right, bottom};
    res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&rectForEngine];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setClipCropRectByClip err=0x%lx", res);
    }
    return res;
}
    
- (MRESULT)setClipEngineCropRectByClip:(CXiaoYingClip *)cXiaoYingClip rectForEngine:(MRECT)rectForEngine
{
    MRESULT res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&rectForEngine];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setClipEngineCropRectByClip err=0x%lx", res);
    }
    return res;
}
    
- (MDWord)getClipRotationByClip:(CXiaoYingClip *)cXiaoYingClip
{
    MDWord degree = 0;
    MRESULT res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_ROTATION PropertyData:&degree];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getClipRotation err=0x%lx", res);
    }
    return degree;
}
    
- (MRESULT)setClipRotationByClip:(CXiaoYingClip *)cXiaoYingClip degree:(MDWord)degree
{
    MRESULT res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_ROTATION PropertyData:&degree];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setClipRotation err=0x%lx", res);
    }
    return res;
}
    
    //dwIndex, clip index, it includes cover and back cover
    //eg. If it has front cover, the first normal clip index should be 1
- (MDWord)getTimeByClipIndex:(MDWord)dwIndex dwPosition:(MDWord)dwPosition timeStamp:(MDWord *)timeStamp
{
    if (!self.cXiaoYingStoryBoardSession) {
        return 0;
    }
    QVET_CLIP_POSITION clipPostion = {0};
    MRESULT res = [self.cXiaoYingStoryBoardSession getClipPositionByIndex:dwIndex ClipPositon:&clipPostion];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getTimeByClipIndex getClipPositionByIndex err=0x%lx", res);
    }
    clipPostion.dwPosition = dwPosition;
    res = [self.cXiaoYingStoryBoardSession getTimeByClipPosition:&clipPostion Timestamp:timeStamp];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getTimeByClipIndex getTimeByClipPosition err=0x%lx", res);
    }
    return res;
}
    
- (MDWord)getClipIndexByTime:(MDWord)dwTime
{
    if (!self.cXiaoYingStoryBoardSession) {
        return 0;
    }
    QVET_CLIP_POSITION clipPostion = {0};
    MRESULT res = [self.cXiaoYingStoryBoardSession getClipPositionByTime:dwTime ClipPositon:&clipPostion];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getClipIndexByTime getClipPositionByTime err=0x%lx", res);
    }
    MDWord dwIndex;
    res = [self.cXiaoYingStoryBoardSession getIndexByClipPosition:&clipPostion ClipIndex:&dwIndex];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getClipIndexByTime getIndexByClipPosition err=0x%lx", res);
    }
    return dwIndex;
}
    
- (NSArray<NSNumber *> *)getClipIndexArrayByTime:(MDWord)dwTime
{
    if (!self.cXiaoYingStoryBoardSession) {
        return nil;
    }
    QVET_CLIP_POSITION clipPosArray[QVET_MAX_CLIP_POSITION_COUNT] = {0};
    MDWord dwClipPosCount = 0; //当前time实际对应的clip数量
    [self.cXiaoYingStoryBoardSession getClipPositionArrayByTime:dwTime
                                                    ClipPositon:clipPosArray
                                             ClipPositonInCount:QVET_MAX_CLIP_POSITION_COUNT
                                            ClipPositonOutCount:&dwClipPosCount];
    if (dwClipPosCount == 0) {
        return nil;
    }
    BOOL hasFrontCover = [self getCover:AMVE_PROP_STORYBOARD_THEME_COVER];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < dwClipPosCount; i++) {
        MDWord dwIndex;
        [self.cXiaoYingStoryBoardSession getIndexByClipPosition:&(clipPosArray[i]) ClipIndex:&dwIndex];
        if (hasFrontCover && dwIndex > 0) {
            dwIndex--;
        }
        [array addObject:@(dwIndex)];
    }
    return array;
}
    
- (QVET_CLIP_POSITION)getClipPositionByTime:(MDWord)dwTime
{
    QVET_CLIP_POSITION clipPostion = {0};
    if (!self.cXiaoYingStoryBoardSession) {
        return clipPostion;
    }
    MRESULT res = [self.cXiaoYingStoryBoardSession getClipPositionByTime:dwTime ClipPositon:&clipPostion];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getClipIndexByTime getClipPositionByTime err=0x%lx", res);
    }
    return clipPostion;
}
    
- (MDWord)getPhysicalClipTimeClipIndex:(MDWord)clipIndex
{
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    AMVE_POSITION_RANGE_TYPE clipTrimRange = [self getClipTrimRangeByClip:clip];
    return [self getPhysicalClipTimeClipIndex:clipIndex dwTrimPos:clipTrimRange.dwPos];
}
    
- (MDWord)getPhysicalClipTimeClipIndex:(MDWord)clipIndex dwTrimPos:(MDWord)dwTrimPos
{
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    AMVE_POSITION_RANGE_TYPE clipSourceRange = [self getClipSourceRangeByClip:clip];
    
    float timeScale;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_TIME_SCALE PropertyData:&timeScale];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getPhysicalClipTimeClipIndex AMVE_PROP_CLIP_TIME_SCALE err=0x%lx", res);
    }
    dwTrimPos = dwTrimPos * timeScale;
    MDWord finalTime = clipSourceRange.dwPos + dwTrimPos;
    return finalTime;
}
    
- (MDWord)getClipType:(MDWord)clipIndex
{
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    MDWord dwClipType = AMVE_CLIP_TYPE_BASE;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&dwClipType];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getClipType err=0x%lx", res);
    }
    return dwClipType;
}
    
- (MDWord)getClipTypeByClip:(CXiaoYingClip *)clip
{
    MDWord dwClipType = AMVE_CLIP_TYPE_BASE;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_TYPE PropertyData:&dwClipType];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getClipType err=0x%lx", res);
    }
    return dwClipType;
}
    
- (BOOL)isHDClip:(CXiaoYingClip *)clip
{
    return [self isClip:clip sizeLargerEqualTo:CGSizeMake(720, 720)];
}
    
- (BOOL)isClip:(CXiaoYingClip *)clip sizeLargerEqualTo:(CGSize)targetSize
{
    MRESULT res = MERR_NONE;
    MSIZE size = {0, 0};
    res = [self getClipSizeByClip:clip pSize:&size];
    if (size.cx >= targetSize.width && size.cy >= targetSize.height) {
        return YES;
    }
    return NO;
}
    
- (BOOL)isClipReversed:(CXiaoYingClip *)clip
{
    if (!clip) {
        return NO;
    }
    BOOL isVideo = [[XYStoryboard sharedXYStoryboard] isClipVideo:clip];
    if (!isVideo) {
        return NO;
    }
    MBool isReversed = MFalse;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&isReversed];
    if (res) {
        return NO;
    }
    return (isReversed == MTrue);
}
    
- (BOOL)hasReversedClip
{
    int clipCount = [self getClipCount];
    
    for (int i = 0; i < clipCount; i++) {
        CXiaoYingClip *clip = [self getClipByIndex:i];
        if ([self isClipReversed:clip]) {
            return YES;
        }
    }
    return NO;
}
    
#pragma mark Clip Range related
- (MDWord)getClipDuration:(MDWord)dwIndex
{
    CXiaoYingClip *clip = [self getClipByIndex:dwIndex];
    return [self getClipDurationByClip:clip];
}
    
- (MDWord)getClipDurationByClip:(CXiaoYingClip *)clip
{
    if (!clip) {
        return 0;
    }
    MRESULT res = MERR_NONE;
    MDWord duration = 0;
    AMVE_VIDEO_INFO_TYPE videoinfo = {0};
    res = [clip getProperty:AMVE_PROP_CLIP_SOURCE_INFO
               PropertyData:(MVoid *)&videoinfo];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getClipDuration AMVE_PROP_CLIP_SOURCE_INFO err=0x%lx", res);
    }
    float timescale = 1.0;
    res = [clip getProperty:AMVE_PROP_CLIP_TIME_SCALE PropertyData:&timescale];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getClipDuration AMVE_PROP_CLIP_TIME_SCALE err=0x%lx", res);
    }
    MDWord orgduration = videoinfo.dwVideoDuration;
    
    duration = [XYEditUtils originalDurationToTimeScaledDuration:orgduration timeScale:timescale];
    
    return duration;
}
    
- (MRESULT)setClipTrimRange:(MDWord)dwIndex
                   startPos:(MDWord)startPos
                     endPos:(MDWord)endPos
{
    //8.0.0不用
    CXiaoYingClip *cXiaoYingClip = [self getClipByIndex:dwIndex];
    return [self setClipTrimRangeByClip:cXiaoYingClip startPos:startPos endPos:endPos];
}
    
- (MRESULT)setClipTrimRangeByClip:(CXiaoYingClip *)cXiaoYingClip
                         startPos:(MDWord)startPos
                           endPos:(MDWord)endPos
{
    //8.0.0不用
    [self setModified:YES];
    AMVE_POSITION_RANGE_TYPE clipRange = {0};
    clipRange.dwPos = startPos;
    clipRange.dwLen = endPos - startPos;
    
    MRESULT res = [self setClipTrimRange:cXiaoYingClip trimRange:clipRange];
    
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setClipTrimRange err=0x%lx", res);
    }
    return res;
}
    
- (AMVE_POSITION_RANGE_TYPE)getClipReverseTrimRange:(MDWord)dwIndex
{
    AMVE_POSITION_RANGE_TYPE clipRange = [self getClipTrimRangeByIndex:dwIndex];
    return clipRange;
}
    
- (MBool)isReverseTrim:(MDWord)dwIndex
{
    CXiaoYingClip *cXiaoYingClip = [self getClipByIndex:dwIndex];
    
    MBool isReverseTrimMdoe = MFalse;
    
    MRESULT res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&isReverseTrimMdoe];
    
    return isReverseTrimMdoe;
}
    
- (MRESULT)setClipReverseTrimRange:(MDWord)dwIndex
                          startPos:(MDWord)startPos
                            endPos:(MDWord)endPos
{
    //8.0.0不用
    CXiaoYingClip *cXiaoYingClip = [self getClipByIndex:dwIndex];
    
    [self setModified:YES];
    
    AMVE_POSITION_RANGE_TYPE clipRange = {0};
    
    clipRange.dwPos = startPos;
    clipRange.dwLen = endPos - startPos;
    
    MRESULT res = [self setClipTrimRange:cXiaoYingClip trimRange:clipRange];
    
    return res;
}
    
- (AMVE_POSITION_RANGE_TYPE)getClipSourceRange:(MDWord)dwIndex
{
    CXiaoYingClip *cXiaoYingClip = [self getClipByIndex:dwIndex];
    return [self getClipSourceRangeByClip:cXiaoYingClip];
}
    
- (MRESULT)setClipSourceRangeByClip:(CXiaoYingClip *)cXiaoYingClip
                           startPos:(MDWord)startPos
                             endPos:(MDWord)endPos
{
    [self setModified:YES];
    AMVE_POSITION_RANGE_TYPE clipRange = {0};
    clipRange.dwPos = startPos;
    clipRange.dwLen = endPos - startPos;
    MRESULT res = [self setClipSourceRange:cXiaoYingClip sourceRange:clipRange];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setClipSourceRangeByClip setProperty AMVE_PROP_CLIP_SRC_RANGE err=0x%lx", res);
    }
    return res;
}
    
    //如果加了有cover的主题，clipindex是包括cover的，例如：封面index是0，第一个clip的index就是1
- (AMVE_POSITION_RANGE_TYPE)getClipTimeRange:(MDWord)clipIndex
{
    AMVE_POSITION_RANGE_TYPE range = {0};
    [self.cXiaoYingStoryBoardSession getClipTimeRange:clipIndex
                                            TimeRange:
     &range];
    return range;
}
    
#pragma mark Clip Effect related
- (MRESULT)setClipEffect:(NSString *)effectPath
             effectAlpha:(MFloat)effectAlpha
       effectConfigIndex:(MDWord)effectConfigIndex
             dwClipIndex:(int)dwClipIndex
                 groupId:(MDWord)groupId
                 layerId:(MFloat)layerId
{
    return [self setClipEffect:effectPath effectAlpha:effectAlpha effectConfigIndex:effectConfigIndex dwClipIndex:dwClipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupId:groupId layerId:layerId];
}
    
- (MRESULT)setClipEffect:(NSString *)effectPath
       effectConfigIndex:(MDWord)effectConfigIndex
             dwClipIndex:(int)dwClipIndex
                 groupId:(MDWord)groupId
                 layerId:(MFloat)layerId
{
    return [self setClipEffect:effectPath effectAlpha:-1 effectConfigIndex:effectConfigIndex dwClipIndex:dwClipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupId:groupId layerId:layerId];
}
    
- (MRESULT)setClipEffect:(NSString *)effectPath
       effectConfigIndex:(MDWord)effectConfigIndex
             dwClipIndex:(int)dwClipIndex
               trackType:(MDWord)dwTrackType
                 groupId:(MDWord)groupId
                 layerId:(MFloat)layerId
{
    return [self setClipEffect:effectPath effectAlpha:-1 effectConfigIndex:effectConfigIndex dwClipIndex:dwClipIndex trackType:dwTrackType groupId:groupId layerId:layerId];
}
    
#pragma mark Clip Effect related
- (MRESULT)setClipEffect:(NSString *)effectPath
             effectAlpha:(MFloat)effectAlpha
       effectConfigIndex:(MDWord)effectConfigIndex
             dwClipIndex:(int)dwClipIndex
               trackType:(MDWord)dwTrackType
                 groupId:(MDWord)groupId
                 layerId:(MFloat)layerId
{
//TOTO:为了还原主题上的滤镜 sunshine待整理 -100
    CXiaoYingClip *pClip;
    if (-100 == dwClipIndex) {
        pClip = [self getDataClip];
    } else {
        pClip = [self getClipByIndex:dwClipIndex];
    }
    
    return [self setClipEffect:effectPath effectAlpha:effectAlpha effectConfigIndex:effectConfigIndex pClip:pClip trackType:dwTrackType groupId:groupId layerId:layerId];
}
    
- (MRESULT)setClipEffect:(NSString *)effectPath
             effectAlpha:(MFloat)effectAlpha
       effectConfigIndex:(MDWord)effectConfigIndex
                   pClip:(CXiaoYingClip *)pClip
               trackType:(MDWord)dwTrackType
                 groupId:(MDWord)groupId
                 layerId:(MFloat)layerId {
    if (!pClip) {
        return -1;
    }
    
    if ([NSString xy_isEmpty:effectPath] || !pClip) {
        return MERR_INVALID_PARAM;
    }
    [self setModified:YES];
    MRESULT res = QVET_ERR_NONE;
    CXiaoYingEffect *pEffect = nil;
    pEffect = [pClip getEffect:dwTrackType GroupID:groupId EffectIndex:0];
    
    MBool bAddByTheme = MFalse;
    const char *cfilename = [effectPath UTF8String];
    AMVE_POSITION_RANGE_TYPE range;
    range.dwPos = 0;
    range.dwLen = -1;
    
    if (!pEffect) {
        pEffect = [[CXiaoYingEffect alloc] init];
        res = [pEffect Create:[[XYEngine sharedXYEngine] getCXiaoYingEngine] EffectType:AMVE_EFFECT_TYPE_VIDEO_IE TrackType:dwTrackType GroupID:groupId LayerID:(MFloat)layerId];
        QVET_CHECK_VALID_GOTO(res);
        
        res = [pEffect setProperty:AMVE_PROP_EFFECT_LAYER PropertyData:&layerId];
        QVET_CHECK_VALID_GOTO(res);
        
        res = [pClip insertEffect:pEffect];
        QVET_CHECK_VALID_GOTO(res)
    }
    
    res = [pEffect setProperty:AMVE_PROP_EFFECT_ADDEDBYTHEME PropertyData:&bAddByTheme];
    QVET_CHECK_VALID_GOTO(res);
    
    res = [pEffect setProperty:AMVE_PROP_EFFECT_VIDEO_IE_SOURCE PropertyData:(MVoid *)cfilename];
    QVET_CHECK_VALID_GOTO(res);
    
    res = [pEffect setProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&range];
    QVET_CHECK_VALID_GOTO(res);
    
    res = [pEffect setProperty:AMVE_PROP_EFFECT_VIDEO_IE_CONFIGURE PropertyData:&effectConfigIndex];
    QVET_CHECK_VALID_GOTO(res);
    
    if(effectAlpha >= 0.0 && effectAlpha <= 1.0)
    {
        res = [pEffect setProperty:AMVE_PROP_EFFECT_BLEND_ALPHA PropertyData:&effectAlpha];
        QVET_CHECK_VALID_GOTO(res);
    }
    
FUN_EXIT:
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setClipEffect err=0x%lx", res);
    }
    return res;
}

- (MFloat)getClipAlpha:(NSString *)effectPath dwClipIndex:(int)dwClipIndex trackType:(MDWord)dwTrackType groupId:(MDWord)groupId layerID:(MFloat)layerId
{
    CXiaoYingClip *pClip = [self getClipByIndex:dwClipIndex];
    
    CXiaoYingEffect *pEffect = [pClip getEffect:dwTrackType GroupID:groupId EffectIndex:0];
    
    MFloat effectAlpha;
    
    [pEffect getProperty:AMVE_PROP_EFFECT_BLEND_ALPHA PropertyData:&effectAlpha];
    
    return effectAlpha;
}
   
- (NSInteger)getClipEffectConfigIndexWithClipIndex:(int)dwClipIndex trackType:(MDWord)dwTrackType groupId:(MDWord)groupId layerID:(MFloat)layerId {
    CXiaoYingClip *pClip = [self getClipByIndex:dwClipIndex];
    
    CXiaoYingEffect *pEffect = [pClip getEffect:dwTrackType GroupID:groupId EffectIndex:0];
    
    NSInteger effectConfigIndex;
    
    [pEffect getProperty:AMVE_PROP_EFFECT_VIDEO_IE_CONFIGURE PropertyData:&effectConfigIndex];
    
    return effectConfigIndex;
}
    
#pragma mark Clip Transition related

- (MRESULT)setClipTransition:(NSString *)transPath configureIndex:(UInt32)configureIndex pClip:(CXiaoYingClip *)pClip
{
    if ([NSString xy_isEmpty:transPath] || !pClip) {
        return MERR_INVALID_PARAM;
    }
    [self setModified:YES];
    MRESULT res = QVET_ERR_NONE;
    
    AMVE_TRANSITION_TYPE trans = {
        (MVoid *)[transPath cStringUsingEncoding:NSUTF8StringEncoding],
        configureIndex,
        1000,
        QVET_TRANSITION_ANIMATED_CFG_TWO,
        MFalse};
    res = [pClip setProperty:AMVE_PROP_CLIP_TRANSITION PropertyData:&trans];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setClipTransition err=0x%lx", res);
    }
    return res;
}
    

- (MRESULT)setClipTransition:(NSString *)transPath configureIndex:(UInt32)configureIndex dwClipIndex:(int)dwClipIndex
{
    CXiaoYingClip *pClip = [self getClipByIndex:dwClipIndex];
    
    if (!transPath || !pClip) {
        return MERR_INVALID_PARAM;
    }
    [self setModified:YES];
    MRESULT res = QVET_ERR_NONE;
    
    AMVE_TRANSITION_TYPE trans = {
        (MVoid *)[transPath cStringUsingEncoding:NSUTF8StringEncoding],
        configureIndex,
        1000,
        QVET_TRANSITION_ANIMATED_CFG_TWO,
        MFalse};
    res = [pClip setProperty:AMVE_PROP_CLIP_TRANSITION PropertyData:&trans];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setClipTransition err=0x%lx", res);
    }
    return res;
}
    

- (MDWord)getClipTransitionDuration:(CXiaoYingClip *)cXiaoYingClip
{
    AMVE_TRANSITION_TYPE clipTransitionRange = {0};
    MDWord duration = 0;
    if (cXiaoYingClip) {
        MRESULT res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_TRANSITION PropertyData:&clipTransitionRange];
        if (res == MERR_NONE) {
            duration = clipTransitionRange.dwDuration;
        }
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard getClipTransitionDuration err=0x%lx", res);
        }
    }
    
    if (MNull != clipTransitionRange.pTemplate) {
        MMemFree(MNull, clipTransitionRange.pTemplate);
        clipTransitionRange.pTemplate = MNull;
    }
    
    return duration;
}
    
- (MDWord)getClipTransitionDurationByIndex:(MDWord)dwIndex
{
    CXiaoYingClip *cXiaoYingClip = [self getClipByIndex:dwIndex];
    return [self getClipTransitionDuration:cXiaoYingClip];
}
    
- (NSString *)getClipTransitionPath:(int)dwClipIndex
{
    CXiaoYingClip *pClip = [self getClipByIndex:dwClipIndex];
    return [self getClipTransitionPathByClip:pClip];
}
    
- (NSString *)getClipTransitionPathByClip:(CXiaoYingClip *)clip
{
    AMVE_TRANSITION_TYPE trans = {0};
    if (clip) {
        MRESULT res = [clip getProperty:AMVE_PROP_CLIP_TRANSITION PropertyData:&trans];
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard getClipTransitionPath err=0x%lx", res);
        }
        if (trans.pTemplate == NULL) {
            return nil;
        }
        NSString *filePath = [NSString stringWithUTF8String:(char *)trans.pTemplate];
        return filePath;
    }
    return nil;
}
    
    //如果加了有cover的主题，clipindex是包括cover的，例如：封面index是0，第一个clip的index就是1
- (AMVE_POSITION_RANGE_TYPE)getClipTransitionTimeRange:(MDWord)clipIndex
{
    AMVE_POSITION_RANGE_TYPE range = {0};
    [self.cXiaoYingStoryBoardSession getTransitionTimeRange:clipIndex
                                                  TimeRange:
     &range];
    return range;
}
    
#pragma mark Clip Pan Zoom related
- (MBool)isClipPanZoomDisabled:(MDWord)clipIndex
{
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    MBool isPanZoomDisabled = YES;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_PANZOOM_DISABLED PropertyData:&isPanZoomDisabled];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard isClipPanZoomDisabled err=0x%lx", res);
    }
    return isPanZoomDisabled;
}
    
- (MRESULT)setClipPanZoomDisabled:(MDWord)clipIndex disable:(MBool)disable
{
    [self setModified:YES];
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    MBool setPanZoomDisabled = disable;
    MRESULT res = [clip setProperty:AMVE_PROP_CLIP_PANZOOM_DISABLED PropertyData:&setPanZoomDisabled];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setClipPanZoomDisabled err=0x%lx", res);
    }
    return res;
}
    
#pragma mark Clip TimeScale related
- (MRESULT)setClipTimeScale:(MDWord)clipIndex timeScale:(float)timeScale
{
    [self setModified:YES];
    MRESULT res = MERR_NONE;
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    float result = (truncf(timeScale * pow(10,2)) / pow(10, 2));
    res = [clip setProperty:AMVE_PROP_CLIP_TIME_SCALE PropertyData:&result];
    
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setClipTimeScale err=0x%lx", res);
    }
    return res;
}
    
- (float)getClipTimeScale:(MDWord)clipIndex
{
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    return [self getClipTimeScaleByClip:clip];
}
    
- (float)getClipTimeScaleByClip:(CXiaoYingClip *)clip
{
    float timeScale = 1.0;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_TIME_SCALE PropertyData:&timeScale];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getClipTimeScale err=0x%lx", res);
    }
    return timeScale;
}
    
- (void)keepTone:(MDWord)clipIndex keep:(BOOL)keep
{
    [self setModified:YES];
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    float fDeltaPitch = 0.0f;
    float timeScale = [self getClipTimeScaleByClip:clip];
    if (!keep) { //不保持原调的情况，deltaPitch需要根据TimeScale值来计算
        fDeltaPitch = [CXiaoYingUtils getAudioDeltaPitch:timeScale];
    }
    MBool bUseASP = MTrue;
    if ([XYCommonEngineUtility isTwoFloatEqual:timeScale float2:1.0]) { //没有变速的情况,1倍速
        if (keep) {                                              //用户选了保持原调
            bUseASP = MTrue;                                     //asp设成true
        } else {                                                 //用户选了不保持原调
            bUseASP = MFalse;                                    //asp设成false
        }
    }
    MRESULT res = [clip setProperty:AMVE_PROP_CLIP_AUDIO_MODIFY_BY_ASP PropertyData:&bUseASP];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard  setProperty AMVE_PROP_CLIP_AUDIO_MODIFY_BY_ASP err=0x%lx", res);
    }
    res = [clip setProperty:AMVE_PROP_CLIP_AUDIO_PITCH_DELTA PropertyData:&fDeltaPitch];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard  setProperty AMVE_PROP_CLIP_AUDIO_PITCH_DELTA err=0x%lx", res);
    }
}
    
- (BOOL)isKeepTone:(MDWord)clipIndex
{
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    MBool bUseASP = MFalse;
    float fDeltaPitch = 0.0f;
    float timeScale = [self getClipTimeScaleByClip:clip];
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_AUDIO_MODIFY_BY_ASP PropertyData:&bUseASP];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard  getProperty AMVE_PROP_CLIP_AUDIO_MODIFY_BY_ASP err=0x%lx", res);
    }
    res = [clip getProperty:AMVE_PROP_CLIP_AUDIO_PITCH_DELTA PropertyData:&fDeltaPitch];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard  getProperty AMVE_PROP_CLIP_AUDIO_PITCH_DELTA err=0x%lx", res);
    }
    
    if ([XYCommonEngineUtility isTwoFloatEqual:timeScale float2:1.0]) { //没有变速的情况,1倍速
        if (bUseASP == MFalse) {
            return NO; //如果没有设过asp，不保持原调
        } else {
            return YES; //如果设过asp，保持原调
        }
    } else { //变速的情况,非1倍速
        if (fDeltaPitch == 0) {
            if (bUseASP == MFalse) {
                return NO; //fDeltaPitch等于0，并且没有设asp，不保持原调
            } else {
                return YES; //fDeltaPitch等于0，设了asp，保持原调
            }
        } else {
            return NO; //fDeltaPitch不等于0，不保持原调
        }
    }
}

- (MRESULT)setClipIdentifier:(CXiaoYingClip *)clip identifier:(NSString *)identifier {
    if (!identifier) {
        identifier = [XYStoryboard createIdentifier];
    }
    MRESULT res = MERR_NONE;
    const MTChar *identifierChar = [identifier UTF8String];
    res = [clip setProperty:AMVE_PROP_CLIP_UNIQUE_IDENTIFIER PropertyData:(MVoid *)identifierChar];
    return res;
    
}

- (NSString *)getClipIdentifier:(CXiaoYingClip *)clip {
    if (clip) {
        char *identifierChar = (char *)malloc(AMVE_MAXPATH);
        MRESULT res = [clip getProperty:AMVE_PROP_CLIP_UNIQUE_IDENTIFIER
                           PropertyData:identifierChar];
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard getClipIdentifier err=0x%lx", res);
            free(identifierChar);
            return nil;
        }
        NSString *identifier = (identifierChar == MNull) ? @"" : [NSString stringWithUTF8String:identifierChar];
        free(identifierChar);
        return identifier;
    } else {
        return nil;
    }
}
    
@end
