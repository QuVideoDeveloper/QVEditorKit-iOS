//
//  XYClipTaskBackgroundColor.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/14.
//

#import "XYClipTaskBackgroundColor.h"
#import "XYClipEditRatioService.h"

@implementation XYClipTaskBackgroundColor

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (BOOL)isReload {
    return NO;
}

- (void)engineOperate {
    self.operationCode = XYCommonEngineOperationCodeDisplayRefresh;
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (XYCommonEngineBackgroundColor != obj.clipPropertyData.effectType) {
            obj.clipPropertyData.effectType = XYCommonEngineBackgroundColor;
            [self switchEffectWithEffectType:XYCommonEngineBackgroundColor clipModel:obj skipSetProperty:NO];
        }
        XYEffectPropertyData *propertyData = obj.clipPropertyData;
        NSInteger startHexValue = [propertyData.backgroundColorList.firstObject integerValue];
        float startR = ((float)((startHexValue & 0xFF0000) >> 16));
        float startG = ((float)((startHexValue & 0xFF00) >> 8));
        float startB = ((float)(startHexValue & 0xFF));
        
        float midR = -1;
        float midG = -1;
        float midB = -1;
        
        float endR = startR;
        float endG = startG;
        float endB = startB;
        NSInteger countValue = propertyData.backgroundColorList.count;
        if (3 == countValue) {
            NSInteger midHexValue = [propertyData.backgroundColorList[1] integerValue];
            midR = ((float)((midHexValue & 0xFF0000) >> 16));
            midG = ((float)((midHexValue & 0xFF00) >> 8));
            midB = ((float)(midHexValue & 0xFF));
            
            NSInteger endHexValue = [propertyData.backgroundColorList[2] integerValue];
            endR = ((float)((endHexValue & 0xFF0000) >> 16));
            endG = ((float)((endHexValue & 0xFF00) >> 8));
            endB = ((float)(endHexValue & 0xFF));
        } else if (2 == countValue) {
            NSInteger endHexValue = [propertyData.backgroundColorList[1] integerValue];
            endR = ((float)((endHexValue & 0xFF0000) >> 16));
            endG = ((float)((endHexValue & 0xFF00) >> 8));
            endB = ((float)(endHexValue & 0xFF));
        }
        CGFloat scale = obj.clipPropertyData.scale;
        if (obj.clipPropertyData.isMirror) {
            scale = -scale;
        }
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:1 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:2 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];

        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:6 value:startR clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:7 value:startG clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:8 value:startB clipIndex:obj.clipIndex storyBoard:self.storyboard];
        
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:14 value:midR clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:15 value:midG clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:16 value:midB clipIndex:obj.clipIndex storyBoard:self.storyboard];
        
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:9 value:endR clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:10 value:endG clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:11 value:endB clipIndex:obj.clipIndex storyBoard:self.storyboard];
        
        
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:15 value:obj.clipPropertyData.linearGradientAngle clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:17 value:countValue clipIndex:obj.clipIndex storyBoard:self.storyboard];
        
    }];
}

@end
