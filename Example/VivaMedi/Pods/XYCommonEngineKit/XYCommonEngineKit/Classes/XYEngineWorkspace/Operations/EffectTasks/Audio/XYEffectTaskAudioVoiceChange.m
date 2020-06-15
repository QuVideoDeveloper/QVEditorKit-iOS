//
//  XYEffectTaskAudioVoiceChange.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/5/14.
//

#import "XYEffectTaskAudioVoiceChange.h"

@implementation XYEffectTaskAudioVoiceChange

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeRefreshAudioEffect;
}

- (void)engineOperate {
    [self.storyboard setEffctVoiceChangeValueWithEffect:self.pEffect audioPitch:self.effectModel.voiceChangeValue];
}
@end
