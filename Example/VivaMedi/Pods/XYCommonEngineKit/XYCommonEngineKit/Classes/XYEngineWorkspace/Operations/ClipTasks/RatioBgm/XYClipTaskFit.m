//
//  XYClipTaskFit.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/11.
//

#import "XYClipTaskFit.h"
#import "XYClipEditRatioService.h"
#import "XYCommonEngineGlobalData.h"
#import "XYEngineWorkspace.h"
#import "XYStordboardOperationMgr.h"
#import "XYStoryboardModel.h"

@implementation XYClipTaskFit

- (BOOL)isReload {
    return NO;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (void)engineOperate {
    self.operationCode = XYCommonEngineOperationCodeDisplayRefresh;
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (XYCommonEngineBackgroundNormal == obj.clipPropertyData.effectType) {
            obj.clipPropertyData.effectType = XYCommonEngineBackgroundBlur;
            [self switchEffectWithEffectType:XYCommonEngineBackgroundBlur clipModel:obj skipSetProperty:NO];
        }
        if (XYCommonEngineRatioFitIn == obj.clipPropertyData.fitType) {
            obj.clipPropertyData.scale = 1.0;
        } else {
            float clipRatio = obj.clipSize.width / (float)obj.clipSize.height;
            obj.clipPropertyData.scale = [XYClipEditRatioService getFitoutScaleWithPlayViewSize:[XYCommonEngineGlobalData data].playbackViewFrame.size clipIndex:obj.clipIndex mRatio:[XYEngineWorkspace stordboardMgr].currentStbModel.ratioValue storyBoard:obj.storyboard rotation:obj.clipPropertyData.angleZ clipRotation:obj.rotation clipRatio:clipRatio];
        }
        CGFloat scale = obj.clipPropertyData.scale;
        CGFloat angleZ = obj.clipPropertyData.angleZ;
        if (obj.clipPropertyData.isMirror) {
            scale = -scale;
            angleZ = -angleZ;
        }
        obj.clipPropertyData.shiftX = 0;
        obj.clipPropertyData.shiftY = 0;
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:1 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:2 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:3 value:angleZ clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:4 value:obj.clipPropertyData.shiftX clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:5 value:obj.clipPropertyData.shiftY clipIndex:obj.clipIndex storyBoard:self.storyboard];
    }];
}

@end

