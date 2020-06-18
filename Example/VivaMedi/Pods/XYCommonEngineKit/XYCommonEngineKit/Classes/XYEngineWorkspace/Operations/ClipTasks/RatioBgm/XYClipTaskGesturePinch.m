//
//  XYClipTaskGesturePinch.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/15.
//

#import "XYClipTaskGesturePinch.h"
#import "XYClipEditRatioService.h"
#import "XYEngineWorkspace.h"

@implementation XYClipTaskGesturePinch

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
        CGFloat scale = obj.clipPropertyData.scale;
        if (obj.clipPropertyData.isMirror) {
            scale = -scale;
        }
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:1 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:2 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
    }];
    if ([XYEngineWorkspace space].isPrebackWorkspace) {
        self.operationCode = XYCommonEngineOperationCodeNone;
    }
}


@end