//
//  XYClipTaskCut.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/12.
//

#import "XYClipTaskCut.h"
#import "XYAdjustEffectValueModel.h"
#import "XYEngineWorkspace.h"
#import "XYClipOperationMgr.h"

@implementation XYClipTaskCut

- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineAll;
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

- (BOOL)isNeedSetAdjustEffectValue {
    if ([XYEngineWorkspace isTempWorkspace]) {
        return NO;
    } else {
        return YES;
    }
}

- (XYCommonEngineOperationCode)operationCode {
    if ([XYEngineWorkspace space].isPrebackWorkspace) {
        return XYCommonEngineOperationCodeNone;
    } else {
        return XYCommonEngineOperationCodeReOpen;
    }
}

- (void)engineOperate {
   __block XYClipModel *currentClipModel = self.clipModels.firstObject;
    if (currentClipModel.isTempWorkspace) {
        __block NSInteger clipCount = [self.storyboard getClipCount];
        
        if (clipCount > currentClipModel.clipModels.count) {
            for (int i = currentClipModel.clipModels.count; i < clipCount; i ++) {
                [self.storyboard deleteClip:i];
            }
        }
        
        [currentClipModel.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.clipIndex = idx;
            if (idx < clipCount) {
             CXiaoYingClip *clip = [self.storyboard getClipByIndex:idx];
             [self.storyboard setClipIdentifier:clip identifier:obj.identifier];
              [self.storyboard setClipTrimRange:idx startPos:obj.trimVeRange.dwPos endPos:obj.trimVeRange.dwPos + obj.trimVeRange.dwLen];
            } else {
                CXiaoYingClip *duplicatedClip = [self.storyboard duplicateClip:currentClipModel.clipIndex];
                [self.storyboard setClipIdentifier:duplicatedClip identifier:obj.identifier];
                NSInteger newIndex = idx++;
                if (duplicatedClip) {
                    [self.storyboard insertClip:duplicatedClip Position:newIndex];
                    [self.storyboard setClipTrimRange:newIndex startPos:obj.trimVeRange.dwPos endPos:obj.trimVeRange.dwPos + obj.trimVeRange.dwLen];
                }
            }
        }];

    } else {
        __block NSMutableArray *cutRangeModels = [NSMutableArray array];
        [currentClipModel.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [cutRangeModels addObject:obj.trimVeRange];
        }];
        //给adjustModel 赋值 用于效果重新计算
        currentClipModel.adjustEffectValueModel.adjustType = XYAdjustEffectTypeCut;
        currentClipModel.adjustEffectValueModel.rangeModels = cutRangeModels;
        AMVE_POSITION_RANGE_TYPE preTrimRange = [self.storyboard getClipTrimRange:currentClipModel.clipIndex];
        //给adjustModel 赋值 用于效果重新计算
        XYVeRangeModel *preRangeModel = [XYVeRangeModel VeRangeModelWithPosition:preTrimRange.dwPos length:preTrimRange.dwLen];//cut 之前的range
        currentClipModel.adjustEffectValueModel.clipIdentifier = currentClipModel.identifier;
        currentClipModel.adjustEffectValueModel.preTrimModel = preRangeModel;
        XYClipModel *trimModel = currentClipModel.clipModels.firstObject;
        [self.storyboard setClipTrimRange:currentClipModel.clipIndex startPos:trimModel.trimVeRange.dwPos endPos:trimModel.trimVeRange.dwPos + trimModel.trimVeRange.dwLen];
        //删除转场
        [self.storyboard setClipTransition:[XYCommonEngineGlobalData data].configModel.effectDefaultTransFilePath configureIndex:currentClipModel.clipEffectModel.effectConfigIndex == 0 ? 0 : rand() % currentClipModel.clipEffectModel.effectConfigIndex pClip:currentClipModel.pClip];
        for (int i = 1; i < currentClipModel.clipModels.count; i ++) {
            XYClipModel *cutModel = [currentClipModel.clipModels objectAtIndex:i];
            CXiaoYingClip *duplicatedClip = [self.storyboard duplicateClip:currentClipModel.clipIndex];
            [self.storyboard setClipIdentifier:duplicatedClip identifier:cutModel.identifier];
            NSInteger newIndex = currentClipModel.clipIndex + i;
            if (duplicatedClip) {
                [self.storyboard insertClip:duplicatedClip Position:newIndex];
                [self.storyboard setClipTrimRange:newIndex startPos:cutModel.trimVeRange.dwPos endPos:cutModel.trimVeRange.dwPos + cutModel.trimVeRange.dwLen];
                //删除转场
                [self.storyboard setClipTransition:[XYCommonEngineGlobalData data].configModel.effectDefaultTransFilePath configureIndex:currentClipModel.clipEffectModel.effectConfigIndex == 0 ? 0 : rand() % currentClipModel.clipEffectModel.effectConfigIndex pClip:duplicatedClip];
            }
        }
    }
}

@end
