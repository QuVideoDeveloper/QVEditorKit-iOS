//
//  XYClipTaskDelete.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/16.
//

#import "XYClipTaskDelete.h"

@implementation XYClipTaskDelete

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

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.storyboard deleteClip:obj.clipIndex];
    }];
}

@end
