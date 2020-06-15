//
//  XYClipTaskAudioNSX.m
//  XYCommonEngineKit
//
//  Created by 徐新元 on 2019/12/30.
//

#import "XYClipTaskAudioNSX.h"

@implementation XYClipTaskAudioNSX

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.storyboard setAudioNSX:obj.pClip on:obj.isAudioNSXOn];
    }];
}

@end
