//
//  XYClipTaskRatioBgmReset.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/19.
//

#import "XYClipTaskRatioBgmReset.h"
#import "XYClipEditRatioService.h"
#import "XYEngineWorkspace.h"
@implementation XYClipTaskRatioBgmReset

- (BOOL)isReload {
    return NO;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (void)engineOperate {
    self.operationCode = XYCommonEngineOperationCodeDisplayRefresh;
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (XYCommonEngineBackgroundColor != obj.clipPropertyData.effectType) {
            obj.clipPropertyData.effectType = XYCommonEngineBackgroundColor;
            [self switchEffectWithEffectType:XYCommonEngineBackgroundColor clipModel:obj skipSetProperty:NO];
        }
        XYEffectPropertyData *propertyData = obj.clipPropertyData;
        CGFloat scale = obj.clipPropertyData.scale;
        CGFloat angleZ = obj.clipPropertyData.angleZ;
        if (obj.clipPropertyData.isMirror) {
            scale = -scale;
            angleZ = -angleZ;
        }
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:1 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:2 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:3 value:angleZ clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:4 value:obj.clipPropertyData.shiftX clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:5 value:obj.clipPropertyData.shiftY clipIndex:obj.clipIndex storyBoard:self.storyboard];
        
    }];
    if ([XYEngineWorkspace space].isPrebackWorkspace) {
        self.operationCode = XYCommonEngineOperationCodeNone;
    }
}


@end
