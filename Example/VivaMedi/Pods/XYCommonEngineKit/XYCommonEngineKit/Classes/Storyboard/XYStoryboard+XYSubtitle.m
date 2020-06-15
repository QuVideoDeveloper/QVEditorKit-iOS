//
//  XYStoryboard+XYSubtitle.m
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/8/2.
//

#import "XYStoryboard+XYSubtitle.h"
#import "XYStoryboard+XYEffect.h"

@implementation XYStoryboard (XYSubtitle)

- (NSArray<NSString *> *)storyboardSubtitleAllTexts {
    NSMutableArray<NSString *> *texts = [NSMutableArray<NSString *> array];
    //普通字幕
    NSInteger count = [self getEffectCount:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_TEXT_FRAME];
    for (int i=0; i<count; i++) {
        CXiaoYingEffect *effect = [self getStoryboardEffectByIndex:i dwTrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_TEXT_FRAME];
        TextInfo *textInfo = [self getStoryboardTextInfo:effect viewFrame:CGRectZero];
        if (textInfo.text) {
            [texts addObject:textInfo.text];
        }
    }
    //主题上的各种文字
    NSMutableArray <TextInfo *> *themeTextInfos = [self getAllThemeTextInfosWithViewFrame:CGRectZero];
    [themeTextInfos enumerateObjectsUsingBlock:^(TextInfo * _Nonnull textInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        if (textInfo.text) {
            [texts addObject:textInfo.text];
        }
    }];
    return texts;
}

@end
