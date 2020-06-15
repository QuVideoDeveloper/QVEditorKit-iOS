//
//  XYClipTaskFilterAdd.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/2.
//

#import "XYClipTaskFilterAdd.h"

@implementation XYClipTaskFilterAdd

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
        CGFloat effectFilterAlpha = -1;
        NSString *effectFilterFilePath;
        if (XYCommonEngineGroupIDThemeFilter == obj.groupID) {
            
            effectFilterFilePath = obj.clipEffectModel.themeFilterFilePath;
            
        } else if(XYCommonEngineGroupIDColorFilter == obj.groupID) {
            
            effectFilterFilePath = obj.clipEffectModel.colorFilterFilePath;
            
        } else if (XYCommonEngineGroupIDFXFilter == obj.groupID) {
            
            effectFilterFilePath = obj.clipEffectModel.fxFilterFilePath;
            
        }
        MFloat layerID = LAYER_ID_EFFECT;
        if (XYCommonEngineGroupIDFXFilter == obj.groupID) {
            layerID = LAYER_ID_FX_EFFECT;
        }
        
        if (obj.pClip) {
            [self.storyboard setClipEffect:effectFilterFilePath effectAlpha:effectFilterAlpha effectConfigIndex:(obj.clipEffectModel.effectConfigIndex == 0 ? 0 : rand()%obj.clipEffectModel.effectConfigIndex) pClip:obj.pClip trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupId:obj.groupID layerId:layerID];
        } else {
            [self.storyboard setClipEffect:effectFilterFilePath effectAlpha:effectFilterAlpha effectConfigIndex:(obj.clipEffectModel.effectConfigIndex == 0 ? 0 : rand()%obj.clipEffectModel.effectConfigIndex) dwClipIndex:(XYCommonEngineGroupIDThemeFilter == obj.groupID ?  -100 : obj.clipIndex) groupId:obj.groupID layerId:layerID];
        }

        [obj reloadFilterData];
        if (XYCommonEngineGroupIDThemeFilter == obj.groupID) {
            *stop = YES;
        }
    }];
}

@end
