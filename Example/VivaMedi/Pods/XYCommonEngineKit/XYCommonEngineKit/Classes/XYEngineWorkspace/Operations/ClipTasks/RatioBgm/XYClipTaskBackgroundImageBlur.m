//
//  XYClipTaskBackgroundImageBlur.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/2.
//

#import "XYClipTaskBackgroundImageBlur.h"
#import "XYClipEditRatioService.h"
#import "XYCommonEngineGlobalData.h"

@implementation XYClipTaskBackgroundImageBlur

- (BOOL)isReload {
    return NO;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (void)engineOperate {
    self.operationCode = XYCommonEngineOperationCodeDisplayRefresh;
    __block BOOL needSwitch = NO;
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (XYCommonEngineBackgroundImage != obj.clipPropertyData.effectType) {
            obj.clipPropertyData.effectType = XYCommonEngineBackgroundImage;
            [self switchEffectWithEffectType:obj.clipPropertyData.effectType clipModel:obj skipSetProperty:NO];
            [self.storyboard setEffectVideoBackImageWidthPhotoPath:obj.clipPropertyData.backImagePath clipIndex:obj.clipIndex];
        } else {
            CXiaoYingEffect *effect = [self.storyboard getEffectByClipIndex:obj.clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM];
            NSString *effectStr = [self.storyboard getEffectPath:effect];
            if (obj.clipPropertyData.backgroundBlurValue >= 10 && effectStr && ![[XYCommonEngineGlobalData data].configModel.effectXytEFilePath isEqualToString:effectStr]) {
                needSwitch = YES;
                obj.clipPropertyData.effectType = XYCommonEngineBackgroundImage;
            } else if (obj.clipPropertyData.backgroundBlurValue < 10 && effectStr && ![[XYCommonEngineGlobalData data].configModel.effectXytFFilePath isEqualToString:effectStr]) {
                needSwitch = YES;
                obj.clipPropertyData.effectType = XYCommonEngineBackgroundImage;
            }
            if (needSwitch) {
                [self switchEffectWithEffectType:obj.clipPropertyData.effectType clipModel:obj skipSetProperty:NO];
                [self.storyboard setEffectVideoBackImageWidthPhotoPath:obj.clipPropertyData.backImagePath clipIndex:obj.clipIndex];
            }
        }
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:6 value:obj.clipPropertyData.backgroundBlurValue clipIndex:obj.clipIndex storyBoard:self.storyboard];
              [XYClipEditRatioService setEffectPropertyWithDwPropertyID:7 value:obj.clipPropertyData.backgroundBlurValue clipIndex:obj.clipIndex storyBoard:self.storyboard];
    }];
    if (needSwitch) {
        if (self.clipModels.count == 1) {
            XYClipModel *clipModel = self.clipModels.firstObject;
            self.operationCode = XYCommonEngineOperationCodeUpdateEffect;
            self.pEffect = [self.storyboard getEffectByClipIndex:clipModel.clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM];
            self.pClip = [self.storyboard getClipByIndex:clipModel.clipIndex];
        } else {
            self.operationCode = XYCommonEngineOperationCodeUpdateAllClipAllEffect;
        }
    }
}

@end
