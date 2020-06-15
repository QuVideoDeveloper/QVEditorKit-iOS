//
//  XYClipTaskBackgroundBlur.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/12.
//

#import "XYClipTaskBackgroundBlur.h"
#import "XYClipEditRatioService.h"
#import "XYCommonEngineGlobalData.h"
#import "XYEngineWorkspace.h"

@implementation XYClipTaskBackgroundBlur

- (BOOL)isReload {
    return NO;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (void)engineOperate {
    NSString *effectPath = [XYCommonEngineGlobalData data].configModel.effectXytDFilePath;
    NSAssert(effectPath != nil, @"effectXytDFilePath == nil");
    self.operationCode = XYCommonEngineOperationCodeDisplayRefresh;
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (XYCommonEngineBackgroundBlur != obj.clipPropertyData.effectType) {
            obj.clipPropertyData.effectType = XYCommonEngineBackgroundBlur;
            [self switchEffectWithEffectType:XYCommonEngineBackgroundBlur clipModel:obj skipSetProperty:NO];
        }
        CGFloat scale = obj.clipPropertyData.scale;
        if (obj.clipPropertyData.isMirror) {
            scale = -scale;
        }
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:1 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:2 value:scale clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:6 value:obj.clipPropertyData.backgroundBlurValue clipIndex:obj.clipIndex storyBoard:self.storyboard];
        [XYClipEditRatioService setEffectPropertyWithDwPropertyID:7 value:obj.clipPropertyData.backgroundBlurValue clipIndex:obj.clipIndex storyBoard:self.storyboard];
    }];
}

@end
