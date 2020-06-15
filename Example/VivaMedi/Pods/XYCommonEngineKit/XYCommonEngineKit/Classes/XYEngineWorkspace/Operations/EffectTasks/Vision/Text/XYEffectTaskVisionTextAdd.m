//
//  XYEffectTaskVisionTextAdd.m
//  XYCommonEngineKit
//
//  Created by 徐新元 on 2019/11/20.
//

#import "XYEffectTaskVisionTextAdd.h"
#import "XYEffectVisionTextModel.h"
#import <XYCategory/XYCategory.h>
#import "XYCommonEngineGlobalData.h"

@implementation XYEffectTaskVisionTextAdd

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeAddEffect;
}

- (BOOL)isReload {
    return YES;
}

- (void)engineOperate {
    XYEffectVisionTextModel *effectVisionTextModel = self.effectModel;
    if (![self isTemplateFilePath:self.filePath]) {
        return;
    }
    
    CGFloat newestLayerID = [self newEffectLayerId];
    [self updateEffectVisionTextModelByTemplate:self.filePath effectVisionTextModel:effectVisionTextModel fullLanguage:[self.storyboard fetchLanguageCode]];
    [self updateTextSizeInEffectVisionTextModel:effectVisionTextModel];
    
    XYMultiTextInfo *multiTextInfo = [self mapToTextInfo:effectVisionTextModel];
    if ([NSString xy_isEmpty:effectVisionTextModel.filePath]) {
        return;
    }
    effectVisionTextModel.pEffect = [self.storyboard setTextEffect:multiTextInfo layerId:newestLayerID];
}

@end
