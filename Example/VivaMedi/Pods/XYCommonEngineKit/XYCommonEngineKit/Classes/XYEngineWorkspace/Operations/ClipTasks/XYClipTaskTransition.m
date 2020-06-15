//
//  XYClipTaskTransition.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/15.
//

#import "XYClipTaskTransition.h"
#import "XYAdjustEffectValueModel.h"
#import <XYCategory/XYCategory.h>

@implementation XYClipTaskTransition

- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineAll;
}

- (BOOL)isReload {
    return YES;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSString xy_isEmpty:obj.clipEffectModel.effectTransFilePath]) {
            obj.clipEffectModel.effectTransFilePath = [XYCommonEngineGlobalData data].configModel.effectDefaultTransFilePath;
        }
        [self.storyboard setClipTransition:obj.clipEffectModel.effectTransFilePath configureIndex:obj.clipEffectModel.effectConfigIndex == 0 ? 0 : rand() % obj.clipEffectModel.effectConfigIndex pClip:obj.pClip];
    }];
}

@end
