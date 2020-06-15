//
//  XYClipTaskBackgroundImage.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/15.
//

#import "XYClipTaskBackgroundImage.h"
#import "XYClipEditRatioService.h"

@implementation XYClipTaskBackgroundImage

- (BOOL)isReload {
    return NO;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (void)engineOperate {
    self.operationCode = XYCommonEngineOperationCodeUpdateEffect;
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXiaoYingEffect *effect = [self.storyboard getEffectByClipIndex:obj.clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM];
        NSString *effectStr = [self.storyboard getEffectPath:effect];
        if (XYCommonEngineBackgroundImage != obj.clipPropertyData.effectType) {
            obj.clipPropertyData.effectType = XYCommonEngineBackgroundImage;
            [self switchEffectWithEffectType:obj.clipPropertyData.effectType clipModel:obj skipSetProperty:NO];
        } else {
            BOOL needSwitch = NO;
            if (obj.clipPropertyData.backgroundBlurValue >= 10 && effectStr && ![[XYCommonEngineGlobalData data].configModel.effectXytEFilePath isEqualToString:effectStr]) {
                needSwitch = YES;
                obj.clipPropertyData.effectType = XYCommonEngineBackgroundImage;
            } else if (obj.clipPropertyData.backgroundBlurValue < 10 && effectStr && ![[XYCommonEngineGlobalData data].configModel.effectXytFFilePath isEqualToString:effectStr]) {
                needSwitch = YES;
                obj.clipPropertyData.effectType = XYCommonEngineBackgroundImage;
            }
            if (needSwitch) {
                [self switchEffectWithEffectType:obj.clipPropertyData.effectType clipModel:obj skipSetProperty:NO];
            }
        }
        CGFloat scale = obj.clipPropertyData.scale;
        if (obj.clipPropertyData.isMirror) {
            scale = -scale;
        }
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:1 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:2 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [self.storyboard setEffectVideoBackImageWidthPhotoPath:obj.clipPropertyData.backImagePath clipIndex:obj.clipIndex];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:6 value:obj.clipPropertyData.backgroundBlurValue clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:7 value:obj.clipPropertyData.backgroundBlurValue clipIndex:obj.clipIndex storyBoard:self.storyboard];
        if (XYCommonEngineOperationCodeUpdateEffect == self.operationCode && !self.pEffect) {
            self.pEffect = [obj.pClip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM EffectIndex:0];
            self.pClip = obj.pClip;
        }
    }];
    if (self.clipModels.count > 1) {
        self.operationCode = XYCommonEngineOperationCodeUpdateAllClipAllEffect;//fix
        self.pClip = nil;
    }
}

@end
