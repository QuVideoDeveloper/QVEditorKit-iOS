//
//  XYEffectTaskUpdateAudioVolume.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/30.
//

#import "XYEffectTaskUpdateAudioVolume.h"
#import "XYEffectAudioModel.h"

@implementation XYEffectTaskUpdateAudioVolume

- (BOOL)preRunTaskPlayerNeedPause {
    return NO;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeRefreshAudio;
}

- (void)engineOperate {
    [self.storyboard updateAudioVolumeEffectIndex:self.indexInStoryboard trackType:self.trackType groupID:self.groupID volumeValue:((XYEffectAudioModel *)self.effectModel).volumeValue];
}

@end
