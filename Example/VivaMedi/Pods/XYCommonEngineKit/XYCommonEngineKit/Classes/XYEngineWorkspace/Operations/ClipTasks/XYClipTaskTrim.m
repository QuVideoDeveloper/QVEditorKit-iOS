//
//  XYClipTaskTrim.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/12.
//

#import "XYClipTaskTrim.h"
#import "XYAdjustEffectValueModel.h"
#import "XYEngineWorkspace.h"

@implementation XYClipTaskTrim

- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}

- (BOOL)isNeedSetAdjustEffectValue {
   return YES;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineAll;
}

- (BOOL)isReload {
    return YES;
}

- (BOOL)isNeedCheckTrans {
    return YES;
}

- (BOOL)needRebuildThumbnailManager {
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
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AMVE_POSITION_RANGE_TYPE preTrimRange = [self.storyboard getClipTrimRange:obj.clipIndex];
        //给adjustModel 赋值 用于效果重新计算
        XYVeRangeModel *preRangeModel = [XYVeRangeModel VeRangeModelWithPosition:preTrimRange.dwPos length:preTrimRange.dwLen];//trim 之前的range
        XYVeRangeModel *rangeModel = [XYVeRangeModel VeRangeModelWithPosition:obj.trimVeRange.dwPos length:obj.trimVeRange.dwLen];
        obj.adjustEffectValueModel.preTrimModel = preRangeModel;
        obj.adjustEffectValueModel.rangeModels = @[rangeModel];
        obj.adjustEffectValueModel.adjustType = XYAdjustEffectTypeTrim;
        //修改trim
        [self.storyboard setClipTrimRange:obj.clipIndex startPos:obj.trimVeRange.dwPos endPos:obj.trimVeRange.dwPos + obj.trimVeRange.dwLen];
    }];
}

@end
