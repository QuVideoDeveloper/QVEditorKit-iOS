//
//  XYClipTaskExchange.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/16.
//

#import "XYClipTaskExchange.h"

@implementation XYClipTaskExchange

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
           [self.storyboard moveClip:obj.sourceIndex dwDestIndex:obj.destinationIndex];
    }];
}

@end
