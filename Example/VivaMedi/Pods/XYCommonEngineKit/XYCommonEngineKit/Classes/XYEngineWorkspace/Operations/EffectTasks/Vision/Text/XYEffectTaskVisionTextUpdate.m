//
//  XYEffectTaskVisionTextUpdate.m
//  XYCommonEngineKit
//
//  Created by 徐新元 on 2019/11/20.
//

#import "XYEffectTaskVisionTextUpdate.h"
#import "XYEffectVisionTextModel.h"
#import <XYCategory/XYCategory.h>
#import "XYCommonEngineGlobalData.h"

@implementation XYEffectTaskVisionTextUpdate

- (XYCommonEngineOperationCode)operationCode {
    XYEffectVisionTextModel *effectVisionTextModel = self.effectModel;
    if (effectVisionTextModel.isInstantRefresh) {
        return XYCommonEngineOperationCodeStartInstantUpdateVisionEffect;
    } else {
        return XYCommonEngineOperationCodeUpdateEffect;
    }
}

- (void)engineOperate {
    XYEffectVisionTextModel *effectVisionTextModel = self.effectModel;
    if (!effectVisionTextModel.pEffect) {
        return;
    }
    
    BOOL isInstantRefresh = effectVisionTextModel.isInstantRefresh;
    
    if (!isInstantRefresh) {
        XYMultiTextInfo *currentTextInfo = [self.storyboard getStoryboardTextInfo:effectVisionTextModel.pEffect viewFrame:[XYCommonEngineGlobalData data].playbackViewFrame];
        
        if (![currentTextInfo.textTemplateFilePath isEqualToString:effectVisionTextModel.filePath]) {
            //模版换过了，需要根据模版更新一下model里的部分属性
            [self updateEffectVisionTextModelByTemplate:self.filePath effectVisionTextModel:effectVisionTextModel fullLanguage:[self.storyboard fetchLanguageCode]];
        }
    }
    
    [self updateTextSizeInEffectVisionTextModel:effectVisionTextModel];
    
    XYMultiTextInfo *textInfo = [self mapToTextInfo:effectVisionTextModel];
    
    //非立即刷新，先设置关键帧，后面设区effectregion的时候要用
    if (!isInstantRefresh) {
        [self setKeyFrames:effectVisionTextModel.keyFrames effectVisionModel:effectVisionTextModel];
    }
    if ([NSString xy_isEmpty:effectVisionTextModel.filePath]) {
        return;
    }
    [self.storyboard setTextEffect:textInfo effect:effectVisionTextModel.pEffect];
    self.isInstantRefresh = effectVisionTextModel.isInstantRefresh;
    //立即刷新，关键帧设空
    if (isInstantRefresh) {
        [self setKeyFrames:nil effectVisionModel:effectVisionTextModel];
    }
    
    if (effectVisionTextModel.isResetLayerID) {
        self.isReload = YES;
        float layerID = [self newEffectLayerId];
        [self.storyboard setEffectLayerId:self.pEffect layerId:layerID];
        effectVisionTextModel.isResetLayerID = NO;
    }
    
    if (!isInstantRefresh) {
        [self.effectModel reload];
    }
    [self.effectModel updateRelativeClipInfo];
}

@end
