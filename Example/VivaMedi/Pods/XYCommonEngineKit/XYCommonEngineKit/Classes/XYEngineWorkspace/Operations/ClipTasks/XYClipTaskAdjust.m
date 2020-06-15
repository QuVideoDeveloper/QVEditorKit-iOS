//
//  XYClipTaskAdjust.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/5.
//

#import "XYClipTaskAdjust.h"
#import "XYCommonEngineGlobalData.h"

@implementation XYClipTaskAdjust

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeUpdateAllClipAllEffect;
}


- (void)engineOperate {
    
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXiaoYingEffect *adjustParamEffect = [self getClipAdjustParamEffectByClipIndex:obj.clipIndex];
        if (adjustParamEffect) {
             [obj.adjustItems enumerateObjectsUsingBlock:^(XYAdjustItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 QVET_EFFECT_PROPDATA propData = {obj.dwID,obj.dwCurrentValue};
                 [adjustParamEffect setProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&propData];
             }];
        }
    }];
}

- (CXiaoYingEffect *)getClipAdjustParamEffectByClipIndex:(int)clipIndex {
    CXiaoYingEffect *adjustParamEffect;
    CXiaoYingClip *clip = [self.storyboard getClipByIndex:clipIndex];
    adjustParamEffect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:GROUP_ID_VIDEO_PARAM_ADJUST_EFFECT EffectIndex:0];
    if (!adjustParamEffect) {
        [self.storyboard setClipEffect:[XYCommonEngineGlobalData data].configModel.adjustEffectPath
        effectConfigIndex:0
              dwClipIndex:clipIndex
                  groupId:GROUP_ID_VIDEO_PARAM_ADJUST_EFFECT
                  layerId:LAYER_ID_VIDEO_PARAM_ADJUST_EFFECT];
    }
    adjustParamEffect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:GROUP_ID_VIDEO_PARAM_ADJUST_EFFECT EffectIndex:0];
    return adjustParamEffect;
}


@end
