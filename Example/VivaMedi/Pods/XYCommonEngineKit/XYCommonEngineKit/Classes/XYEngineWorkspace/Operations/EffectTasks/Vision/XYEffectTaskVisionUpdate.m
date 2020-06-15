//
//  XYEffectTaskVisionUpdate.m
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/11/19.
//

#import "XYEffectTaskVisionUpdate.h"
#import "XYEffectVisionModel.h"
#import <XYCategory/XYCategory.h>

@implementation XYEffectTaskVisionUpdate

- (XYCommonEngineOperationCode)operationCode {
    XYEffectVisionModel *effectVisionModel = self.effectModel;
    
    if (effectVisionModel.isInstantRefresh) {
        return XYCommonEngineOperationCodeStartInstantUpdateVisionEffect;
    } else {
        return XYCommonEngineOperationCodeUpdateEffect;
    }
}

- (void)engineOperate {
    XYEffectVisionModel *effectVisionModel = self.effectModel;
    
    StickerInfo *stickerInfo = [self.storyboard getStoryboardStickerInfo:effectVisionModel.pEffect];
    
    if (![stickerInfo.xytFilePath isEqualToString:effectVisionModel.filePath]) {
        //模版换过了，需要根据模版更新一下model里的部分属性
        [self updateEffectVisionStickerModelByTemplate:effectVisionModel.filePath effectVisionModel:effectVisionModel];
        
        //画中画更换文件，需要重新创建取缩略图用的Clip和ThumbnailManager
        if (effectVisionModel.groupID == XYCommonEngineGroupIDCollage) {
            self.needRebuildThumbnailManager = YES;
        }
    }
    
    //非立即刷新，先设置关键帧，后面设区effectregion的时候要用
    if (!effectVisionModel.isInstantRefresh) {
        [self setKeyFrames:effectVisionModel.keyFrames effectVisionModel:effectVisionModel];
    }
    if ([NSString xy_isEmpty:effectVisionModel.filePath]) {
        return;
    }
    [self.storyboard updateStickerInfo:[self mapToStickerInfo:effectVisionModel] toEffect:effectVisionModel.pEffect];
    self.isInstantRefresh = effectVisionModel.isInstantRefresh;
    //立即刷新，关键帧设空
    if (effectVisionModel.isInstantRefresh) {
        [self setKeyFrames:nil effectVisionModel:effectVisionModel];
    }

    if (effectVisionModel.isResetLayerID) {
        self.isReload = YES;
        float layerID = [self newEffectLayerId];
        [self.storyboard setEffectLayerId:self.pEffect layerId:layerID];
        effectVisionModel.isResetLayerID = NO;
    }
    
    if (!effectVisionModel.isInstantRefresh) {
        [self.effectModel reload];
    }
    [self.effectModel updateRelativeClipInfo];
}

@end
