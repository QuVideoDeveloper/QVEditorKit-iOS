//
//  XYCommonEngineUtility.m
//  XYCommonEngineKit
//
//  Created by lizitao on 2019/9/17.
//

#import "XYStoryboardUtility.h"
#import "XYStoryboard+XYClip.h"
#import "XYStoryboard+XYEffect.h"
#import "XYCommonEngineUtility.h"

@implementation XYStoryboardUtility
    
+ (BOOL)isThemeApplyed:(CXiaoYingStoryBoardSession *)storyboardSession
{
    if (!storyboardSession)
        return NO;
    MInt64 themeId = 0;
    [storyboardSession getProperty:AMVE_PROP_STORYBOARD_THEME_ID Value:&themeId];
    if (0x100000000000000 < themeId) {
        return YES;
    }
    return NO;
}

+ (BOOL)isCoverExsit:(MDWord)coverType storyboard:(XYStoryboard *)storyboard
{
    return ([storyboard getCover:coverType] != nil);
}

+ (MDWord)getUnRealClipCount:(XYStoryboard *)storyboard
{
    MDWord clipCount = [storyboard getClipCount];
    BOOL isFrontCoverExsit = ([storyboard getCover:AMVE_PROP_STORYBOARD_THEME_COVER] != nil);
    BOOL isBackCoverExsit = ([storyboard getCover:AMVE_PROP_STORYBOARD_THEME_BACK_COVER] != nil);
    if (isFrontCoverExsit) {
        clipCount++;
    }
    if (isBackCoverExsit) {
        clipCount++;
    }
    return clipCount;
}

+ (MDWord)getStoryboardFirstVideoTimestamp:(XYStoryboard *)storyboard
{
    if (!storyboard) {
        return 0;
    }
    CXiaoYingCover *frontCover = [storyboard getCover:AMVE_PROP_STORYBOARD_THEME_COVER];
    BOOL coverExist = (frontCover != nil);
    MDWord clipcount = [storyboard getClipCount];
    if (clipcount == 0) {
        return 0;
    }
    MDWord timePos = 0;
    for (MDWord i = 0; i < clipcount; i++) {
        MRESULT res = [[XYStoryboard sharedXYStoryboard] getTimeByClipIndex:i + (coverExist ? 1 : 0) dwPosition:0 timeStamp:&timePos];
        if (res) {
            timePos = 0;
        } else {
            break;
        }
    }
    if (coverExist) {
        MDWord frontTrans = [[XYStoryboard sharedXYStoryboard] getClipTransitionDuration:frontCover];
        if (timePos + frontTrans < [storyboard getDuration]) {
            timePos += frontTrans;
        }
    }
    if (timePos > [storyboard getDuration]) {
        timePos = 0;
    }

    return timePos;
}

+ (AMVE_POSITION_RANGE_TYPE)calcStoryboardPlayerRangeWithoutCover:(XYStoryboard *)storyboard
{
    AMVE_POSITION_RANGE_TYPE range = {0};
    if ([XYStoryboardUtility isThemeApplyed:[storyboard getStoryboardSession]] && [storyboard getClipCount] > 0) {
        MDWord firstClipIndex = 0;

        if ([XYStoryboardUtility isCoverExsit:AMVE_PROP_STORYBOARD_THEME_COVER storyboard:storyboard]) {
            firstClipIndex = 1;
        }
        // set range, except theme part.
        MDWord leftPos = 0;
        AMVE_POSITION_RANGE_TYPE firstClipRange = [storyboard getClipTimeRange:firstClipIndex];
        leftPos = firstClipRange.dwPos;

        MDWord rightPos = 0;
        if ([XYStoryboardUtility isCoverExsit:AMVE_PROP_STORYBOARD_THEME_BACK_COVER storyboard:storyboard]) {
            MDWord count = [XYStoryboardUtility getUnRealClipCount:storyboard];
            AMVE_POSITION_RANGE_TYPE lastClipRange = [storyboard getClipTimeRange:count - 2];
            rightPos = lastClipRange.dwPos + lastClipRange.dwLen;
        } else {
            rightPos = [storyboard getDuration];
        }

        if (rightPos > leftPos && rightPos <= [storyboard getDuration]) {
            range.dwPos = leftPos;
            range.dwLen = rightPos - leftPos;
        } else {
            range.dwPos = leftPos;
            range.dwLen = 1;
        }
    } else {
        range.dwPos = 0;
        range.dwLen = [storyboard getDuration];
    }
    return range;
}

+ (void)showLayer:(MFloat)fLayerID
          groupId:(MDWord)groupId
          IsShown:(MBool)bIsShown
       storyboard:(XYStoryboard *)storyboard
{
    MDWord count = [storyboard getEffectCount:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:groupId];
    for (MDWord index = 0; index < count; index++) {
        CXiaoYingEffect *effect = [storyboard getStoryboardEffectByIndex:index dwTrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:groupId];
        if (fLayerID == -1) {
            [effect setProperty:AMVE_PROP_EFFECT_VISIBILITY PropertyData:&bIsShown];
        } else {
            float lid = [storyboard getEffectLayerId:effect];
            if (fabs(fLayerID - lid) <= 0.0001) {
                [effect setProperty:AMVE_PROP_EFFECT_VISIBILITY PropertyData:&bIsShown];
            }
        }
    }
}

+ (void)showLayer:(MFloat)fLayerID
          IsShown:(MBool)bIsShown
       storyboard:(XYStoryboard *)storyboard
{
    [XYStoryboardUtility showLayer:fLayerID groupId:GROUP_TEXT_FRAME IsShown:bIsShown storyboard:storyboard];
    [XYStoryboardUtility showLayer:fLayerID groupId:GROUP_ANIMATED_FRAME IsShown:bIsShown storyboard:storyboard];
    [XYStoryboardUtility showLayer:fLayerID groupId:GROUP_STICKER IsShown:bIsShown storyboard:storyboard];
    [XYStoryboardUtility showLayer:fLayerID groupId:GROUP_ID_COLLAGE IsShown:bIsShown storyboard:storyboard];
    [XYStoryboardUtility showLayer:fLayerID groupId:GROUP_ID_MOSAIC IsShown:bIsShown storyboard:storyboard];

    CXiaoYingCover *frontCover = [[XYStoryboard sharedXYStoryboard] getCover:AMVE_PROP_STORYBOARD_THEME_COVER];
    MDWord frontCoverEffectCount = [frontCover getEffectCount:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:GROUP_COVER_TITLE];
    for (MDWord index = 0; index < frontCoverEffectCount; index++) {
        CXiaoYingEffect *effect = [frontCover getEffect:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:GROUP_COVER_TITLE EffectIndex:index];
        [effect setProperty:AMVE_PROP_EFFECT_VISIBILITY PropertyData:&bIsShown];
    }

    CXiaoYingCover *backCover = [[XYStoryboard sharedXYStoryboard] getCover:AMVE_PROP_STORYBOARD_THEME_BACK_COVER];
    MDWord backCoverEffectCount = [backCover getEffectCount:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:GROUP_COVER_TITLE];
    for (MDWord index = 0; index < backCoverEffectCount; index++) {
        CXiaoYingEffect *effect = [backCover getEffect:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:GROUP_COVER_TITLE EffectIndex:index];
        [effect setProperty:AMVE_PROP_EFFECT_VISIBILITY PropertyData:&bIsShown];
    }
}

+ (AMVE_VIDEO_INFO_TYPE)getVideoInfo:(NSString *)filePath
{
    AMVE_VIDEO_INFO_TYPE videoInfo = {0};
    if ([XYCommonEngineUtility xy_isFileExist:filePath]) {
        [CXiaoYingUtils getVideoInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine] FilePath:(MTChar *)[filePath UTF8String] VideoInfo:&videoInfo];
    }
    return videoInfo;
}

@end
