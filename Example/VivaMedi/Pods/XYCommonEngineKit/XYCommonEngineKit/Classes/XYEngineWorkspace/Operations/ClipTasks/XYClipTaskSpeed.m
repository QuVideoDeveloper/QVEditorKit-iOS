//
//  XYClipTaskSpeed.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/8.
//

#import "XYClipTaskSpeed.h"
#import "XYAdjustEffectValueModel.h"
#import "XYEngineWorkspace.h"

@implementation XYClipTaskSpeed

- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}


- (BOOL)isReload {
    return YES;
}
- (BOOL)needRebuildThumbnailManager {
    return YES;
}

- (BOOL)isNeedCheckTrans {
    return YES;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineAll;
}

- (BOOL)isNeedSetAdjustEffectValue {
    return YES;
}

- (XYCommonEngineOperationCode)operationCode {
    if ([XYEngineWorkspace space].isPrebackWorkspace) {
        return XYCommonEngineOperationCodeNone;
    } else {
        return XYCommonEngineOperationCodeReOpen;
    }
}

- (void)engineOperate {
    
    XYClipModel *model = [self.clipModels firstObject];
    if (!model.speedAdjustEffect) {
        self.adjustEffect = NO;
        model.speedAdjustEffect = YES;
    }
    
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.adjustEffectValueModel.adjustType = XYAdjustEffectTypeSpeed;
        obj.adjustEffectValueModel.preSpeedValue = 1 / [self.storyboard getClipTimeScale:obj.clipIndex];
        [self.storyboard setClipTimeScale:obj.clipIndex timeScale: 1 / obj.speedValue];
        [self.storyboard keepTone:obj.clipIndex keep:obj.iskeepTone];
    }];
}

@end
