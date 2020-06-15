//
//  XYBaseClipTaskProperty.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/14.
//

#import "XYBaseClipTaskProperty.h"
#import "XYClipEditRatioService.h"

@implementation XYBaseClipTaskProperty

- (void)switchEffectWithEffectType:(XYCommonEnginebackgroundType)effectType clipModel:(XYClipModel *)clipModel skipSetProperty:(BOOL)skipSetProperty {
    CXiaoYingEffect *pEffect = [clipModel.pClip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM EffectIndex:0];
    XYEffectPropertyData *propertyData = clipModel.clipPropertyData;
    [XYClipEditRatioService setEffect:clipModel storyBoard:self.storyboard];
    CGFloat scale = clipModel.clipPropertyData.scale;
    CGFloat angleZ = clipModel.clipPropertyData.angleZ;
    if (clipModel.clipPropertyData.isMirror) {
        scale = -scale;
        angleZ = -angleZ;
    }
    if (!skipSetProperty) {
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:1 value:scale clipIndex:clipModel.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:2 value:scale clipIndex:clipModel.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:3 value:angleZ clipIndex:clipModel.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:4 value:propertyData.shiftX clipIndex:clipModel.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:5 value:propertyData.shiftY clipIndex:clipModel.clipIndex storyBoard:self.storyboard];
    }
    if (self.clipModels.count > 1) {
        self.operationCode = XYCommonEngineOperationCodeUpdateAllClipAllEffect;
    } else {
        if (!pEffect) {
            [clipModel.pClip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM EffectIndex:0];
            self.operationCode = XYCommonEngineOperationCodeUpdateAllClipAllEffect;
        } else {
            self.operationCode = XYCommonEngineOperationCodeUpdateEffect;
            self.pEffect = pEffect;
            self.pClip = clipModel.pClip;
        }
    }
}


@end
