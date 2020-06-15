//
//  XYClipTaskCoverAdd.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/27.
//

#import "XYClipTaskCoverAdd.h"
#import "XYEngineModelBridgeUtility.h"
#import "XYEffectTaskVisionAdd.h"
#import "XYEffectVisionModel.h"
#import "XYEffectVisionTextModel.h"
#import "XYEffectTaskVisionTextAdd.h"

@implementation XYClipTaskCoverAdd

- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineAll;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (BOOL)isReload {
    return YES;
}

- (void)engineOperate {
    XYClipModel *currentClipModel = self.clipModels.firstObject;
    currentClipModel.clipIndex = [self.storyboard getClipCount];
    currentClipModel.sourceVeRange.dwPos = 0;
    currentClipModel.sourceVeRange.dwLen = 3000;
    currentClipModel.rotation = 0;
    XYClipDataItem *dataItem = [XYEngineModelBridgeUtility bridge:currentClipModel];
    dataItem.isGIF = NO;
    [self.storyboard insertClipByClipDataItem:dataItem Position:currentClipModel.clipIndex];
    CXiaoYingClip *pClip = [self.storyboard getClipByIndex:currentClipModel.clipIndex];
    
    [currentClipModel.clipEffectModel.backCoverVisionModels enumerateObjectsUsingBlock:^(XYEffectVisionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (XYCommonEngineGroupIDSticker == obj.groupID) {
            obj.pClip = pClip;
            XYEffectTaskVisionAdd *visionTask = [[XYEffectTaskVisionAdd alloc] init];
            visionTask.storyboard = self.storyboard;
            [visionTask updateEffectVisionStickerModelByTemplate:obj.filePath effectVisionModel:obj];
            obj.pEffect = [self.storyboard setSticker:[visionTask mapToStickerInfo:obj] layerID:80 + idx groupID:obj.groupID];
        } else if (XYCommonEngineGroupIDText == obj.groupID) {
            NSInteger textHeight = obj.height;
            obj.pClip = pClip;
            XYEffectTaskVisionTextAdd * textTask = [[XYEffectTaskVisionTextAdd alloc] init];
            textTask.storyboard = self.storyboard;
            [textTask updateEffectVisionTextModelByTemplate:obj.filePath effectVisionTextModel:obj fullLanguage:[self.storyboard fetchLanguageCode]];
            [textTask updateTextSizeInEffectVisionTextModel:obj];
            if (obj.width > obj.maxWidth && obj.maxWidth > 0) {
                obj.width = obj.maxWidth;
            }
            obj.height = textHeight;
            TextInfo *subTitleTextInfo = [textTask mapToTextInfo:obj];
            obj.pEffect = [self.storyboard setTextEffect:subTitleTextInfo layerId:80 + idx];
        }
    }];
}

@end
