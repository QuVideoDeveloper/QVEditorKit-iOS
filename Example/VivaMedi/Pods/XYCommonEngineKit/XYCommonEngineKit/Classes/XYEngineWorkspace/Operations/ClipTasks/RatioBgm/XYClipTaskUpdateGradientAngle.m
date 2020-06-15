//
//  XYClipTaskUpdateGradientAngle.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/18.
//

#import "XYClipTaskUpdateGradientAngle.h"
#import "XYClipEditRatioService.h"

@implementation XYClipTaskUpdateGradientAngle

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
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:12 value:obj.clipPropertyData.linearGradientAngle clipIndex:obj.clipIndex storyBoard:self.storyboard];
    }];
}

@end
