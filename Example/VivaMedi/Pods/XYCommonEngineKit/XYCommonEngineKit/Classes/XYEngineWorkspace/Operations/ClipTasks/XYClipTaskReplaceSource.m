//
//  XYClipTaskReplaceSource.m
//  Pods
//
//  Created by darren on 2020/3/4.
//

#import "XYClipTaskReplaceSource.h"

@implementation XYClipTaskReplaceSource

- (BOOL)dataClipReinitThumbnailManager {
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
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AMVE_POSITION_RANGE_TYPE sourceRange = {obj.sourceVeRange.dwPos, obj.sourceVeRange.dwLen};
        AMVE_POSITION_RANGE_TYPE trimRange = {obj.trimVeRange.dwPos, obj.trimVeRange.dwLen};
        [self.storyboard replaceClip:obj.pClip clipFullPath:obj.clipFilePath videoRange:sourceRange trimRange:trimRange];
    }];
}

@end
