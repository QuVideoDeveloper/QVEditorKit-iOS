//
//  XYEffectTaskVisionAdd.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/8.
//

#import "XYEffectTaskVisionAdd.h"
#import "XYEffectVisionModel.h"
#import "XYEngineModelBridgeUtility.h"
#import <XYCategory/XYCategory.h>

@implementation XYEffectTaskVisionAdd

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeAddEffect;
}

- (BOOL)isReload {
    return YES;
}

- (void)engineOperate {
    XYEffectVisionModel *effectVisionModel = self.effectModel;
    if (![self isTemplateFilePath:self.filePath]) {
        return;
    }
    
    CGFloat newestStickerLayerID = [self newEffectLayerId];
    [self updateEffectVisionStickerModelByTemplate:self.filePath effectVisionModel:effectVisionModel];
    if ([NSString xy_isEmpty:effectVisionModel.filePath]) {
        return;
    }
    effectVisionModel.pEffect = [self.storyboard setSticker:[self mapToStickerInfo:effectVisionModel] layerID:newestStickerLayerID groupID:self.groupID];
}

@end
