//
//  XYClipTaskCoverUpdate.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/27.
//

#import "XYClipTaskCoverUpdate.h"
#import "XYBaseEffectTaskVision.h"
#import "XYEffectVisionTextModel.h"
#import "XYEffectVisionModel.h"
#import "XYEngineWorkspace.h"
#import "XYClipOperationMgr.h"

@implementation XYClipTaskCoverUpdate {
    BOOL _isHasCustomCover;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (XYCommonEngineOperationCode)operationCode {
    if (!_isHasCustomCover) {
        return XYCommonEngineOperationCodeNone;
    } else {
        return XYCommonEngineOperationCodeUpdateAllEffect;
    }
}

- (void)engineOperate {
    self.pClip = [[XYEngineWorkspace clipMgr] fetchClipModelWithIdentifier:XY_CUSTOM_COVER_BACK_IDENTIFIER].pClip;
    if (self.pClip) {
        _isHasCustomCover = YES;
        XYClipModel *currentClipModel = self.clipModels.firstObject;
        XYBaseEffectTaskVision *visionTask = [[XYBaseEffectTaskVision alloc] init];
        visionTask.storyboard = self.storyboard;
        [currentClipModel.clipEffectModel.backCoverVisionModels enumerateObjectsUsingBlock:^(XYEffectVisionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (XYCommonEngineGroupIDSticker == obj.groupID) {
                obj.pEffect = [self.pClip getEffect:XYCommonEngineTrackTypeVideo GroupID:XYCommonEngineGroupIDSticker EffectIndex:obj.indexInStoryboard];
                StickerInfo *stickerInfo = [self.storyboard getStoryboardStickerInfo:obj.pEffect];
                if (![stickerInfo.xytFilePath isEqualToString:obj.filePath]) {
                    
                    //模版换过了，需要根据模版更新一下model里的部分属性
                    [visionTask updateEffectVisionStickerModelByTemplate:obj.filePath effectVisionModel:obj];
                }
                [self.storyboard updateStickerInfo:[visionTask mapToStickerInfo:obj] toEffect:obj.pEffect];
            } else if (XYCommonEngineGroupIDText == obj.groupID) {
                obj.pEffect = [self.pClip getEffect:XYCommonEngineTrackTypeVideo GroupID:XYCommonEngineGroupIDText EffectIndex:obj.indexInStoryboard];
                XYEffectVisionTextModel *effectVisionTextModel = obj;
                NSInteger textHeight = obj.height;
                if (!obj.pEffect) {
                    return;
                }
                
                TextInfo *currentTextInfo = [self.storyboard getStoryboardTextInfo:effectVisionTextModel.pEffect viewFrame:[XYCommonEngineGlobalData data].playbackViewFrame];
                
                if (![currentTextInfo.textTemplateFilePath isEqualToString:effectVisionTextModel.filePath]) {
                    //模版换过了，需要根据模版更新一下model里的部分属性
                    [visionTask updateEffectVisionTextModelByTemplate:effectVisionTextModel.filePath effectVisionTextModel:effectVisionTextModel fullLanguage:[self.storyboard fetchLanguageCode]];
                }
                [visionTask updateTextSizeInEffectVisionTextModel:effectVisionTextModel];
                if (obj.width > obj.maxWidth && obj.maxWidth > 0) {
                    obj.width = obj.maxWidth;
                }
                effectVisionTextModel.height = textHeight;
                TextInfo *textInfo = [visionTask mapToTextInfo:effectVisionTextModel];
                
                [self.storyboard setTextEffect:textInfo effect:effectVisionTextModel.pEffect];
            }
        }];
    }
}

@end
