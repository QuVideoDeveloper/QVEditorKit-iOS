//
//  XYClipTaskDuplicate.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import "XYClipTaskDuplicate.h"

@implementation XYClipTaskDuplicate

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
        CXiaoYingClip *duplicatedClip = [self.storyboard duplicateClip:obj.clipIndex];
        [self.storyboard setClipIdentifier:duplicatedClip identifier:obj.duplicateClipModel.identifier];
        //删除转场
        [self.storyboard setClipTransition:[XYCommonEngineGlobalData data].configModel.effectDefaultTransFilePath configureIndex:obj.clipEffectModel.effectConfigIndex == 0 ? 0 : rand() % obj.clipEffectModel.effectConfigIndex pClip:duplicatedClip];

        if(duplicatedClip){
            int newIndex = (int)obj.clipIndex + 1;
            [self.storyboard insertClip:duplicatedClip Position:newIndex];
        }
    }];
   
}


@end
