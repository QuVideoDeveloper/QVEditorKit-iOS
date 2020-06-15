//
//  XYClipTaskVoiceChange.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/2.
//

#import "XYClipTaskVoiceChange.h"

@implementation XYClipTaskVoiceChange

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeRefreshAudioEffect;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.storyboard setVoiceChangeValueWithClipIndex:obj.clipIndex audioPitch:obj.voiceChangeValue];
    }];
}

@end
