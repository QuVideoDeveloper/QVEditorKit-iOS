//
//  XYClipTaskAudioVolumeStates.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/30.
//

#import "XYClipTaskMute.h"

@implementation XYClipTaskMute

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
        CXiaoYingClip *clip = [self.storyboard getClipByIndex:obj.clipIndex];
        if (obj.isMute != [self.storyboard isClipPrimalAudioDisabled:clip]) {
            [self.storyboard disableClipPrimalAudio:clip disable:obj.isMute];
        }
    }];
}

@end
