//
//  XYClipTaskUpdateVolume.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/30.
//

#import "XYClipTaskUpdateVolume.h"

@implementation XYClipTaskUpdateVolume

- (BOOL)preRunTaskPlayerNeedPause {
    return NO;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeNone;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.storyboard updateClipVolume:obj.clipIndex volumeValue:obj.volumeValue];
    }];
}

@end
