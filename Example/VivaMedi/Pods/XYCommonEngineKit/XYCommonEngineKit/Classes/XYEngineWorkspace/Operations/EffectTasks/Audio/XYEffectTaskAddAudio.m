//
//  XYEffectTaskAddMusic.m
//  AWSCore
//
//  Created by 夏澄 on 2019/10/23.
//

#import "XYEffectTaskAddAudio.h"

@implementation XYEffectTaskAddAudio

- (BOOL)isReload {
    return YES;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeAddEffect;
}

- (void)engineOperate {
    self.effectModel.pEffect = [self.storyboard setEffectAudio:self.filePath audioTrimStartPos:self.trimPos audioTrimLength:self.trimLen storyBoardStartPos:self.destPos storyBoardLength:self.destLen groupID:self.groupID layerID:self.layerID mixPercent:50 dwRepeatMode:self.repeatMode audioTitle:self.title identifier:self.effectModel.identifier];
    [self.storyboard setEffectSourceRange:self.effectModel.pEffect dwPos:self.effectModel.sourceVeRange.dwPos dwLen:self.effectModel.sourceVeRange.dwLen];
    self.pEffect = self.effectModel.pEffect;
    [self.effectModel updateRelativeClipInfo];
}


@end
