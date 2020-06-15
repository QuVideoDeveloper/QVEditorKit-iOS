//
//  XYClipTaskGesturePan.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/15.
//

#import "XYClipTaskGesturePan.h"
#import "XYClipEditRatioService.h"
#import "XYEngineWorkspace.h"

@implementation XYClipTaskGesturePan

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
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:4 value:obj.clipPropertyData.shiftX clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:5 value:obj.clipPropertyData.shiftY clipIndex:obj.clipIndex storyBoard:self.storyboard];
    }];
    if ([XYEngineWorkspace space].isPrebackWorkspace) {
        self.operationCode = XYCommonEngineOperationCodeNone;
    }
}

@end
