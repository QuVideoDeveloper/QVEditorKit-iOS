//
//  XYClipTaskGestureRotation.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/15.
//

#import "XYClipTaskGestureRotation.h"
#import "XYClipEditRatioService.h"
#import "XYEngineWorkspace.h"

@implementation XYClipTaskGestureRotation

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
        CGFloat angleZ = obj.clipPropertyData.angleZ;
        if (obj.clipPropertyData.isMirror) {
            angleZ = -angleZ;
        }
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:3 value:angleZ clipIndex:obj.clipIndex storyBoard:self.storyboard];
    }];
    if ([XYEngineWorkspace space].isPrebackWorkspace) {
        self.operationCode = XYCommonEngineOperationCodeNone;
    }
}

@end
