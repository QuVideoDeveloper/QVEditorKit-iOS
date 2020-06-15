//
//  XYClipTaskFilterUpdateAlpha.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/2.
//

#import "XYClipTaskFilterUpdateAlpha.h"
#import "XYEngineWorkspace.h"

@implementation XYClipTaskFilterUpdateAlpha

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (XYCommonEngineGroupID)groupID {
    return self.clipModels.firstObject.groupID;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeUpdateAllClipAllEffect;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MFloat effectAlpha;
        if (XYCommonEngineGroupIDThemeFilter == obj.groupID) {
            
            effectAlpha = obj.clipEffectModel.themeFilterAlpha;
            
        } else if(XYCommonEngineGroupIDColorFilter == obj.groupID) {
            
            effectAlpha = obj.clipEffectModel.colorFilterAlpha;
            
        } else if (XYCommonEngineGroupIDFXFilter == obj.groupID) {
            
            effectAlpha = obj.clipEffectModel.fxFilterAlpha;
            
        }
        MFloat layerID = LAYER_ID_EFFECT;
        if (XYCommonEngineGroupIDFXFilter == obj.groupID) {
            layerID = LAYER_ID_FX_EFFECT;
        }
        CXiaoYingEffect *pEffect;
        if (XYCommonEngineGroupIDThemeFilter == obj.groupID) {
            pEffect = [[[XYEngineWorkspace currentStoryboard] getDataClip] getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:obj.groupID EffectIndex:0];
        } else {
            pEffect = [self.storyboard getEffectByClipIndex:obj.clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:obj.groupID];
        }
        [pEffect setProperty:AMVE_PROP_EFFECT_BLEND_ALPHA PropertyData:&effectAlpha];
    }];
}

@end
