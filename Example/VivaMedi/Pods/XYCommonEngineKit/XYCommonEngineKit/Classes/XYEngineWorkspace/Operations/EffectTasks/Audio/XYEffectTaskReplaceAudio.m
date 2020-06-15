//
//  XYeffectTaskReplaceMusic.m
//  Pods
//
//  Created by 夏澄 on 2019/10/26.
//

#import "XYEffectTaskReplaceAudio.h"

@implementation XYEffectTaskReplaceAudio

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReplaceEffect;
}

- (void)engineOperate {
    NSInteger trimPos = self.trimPos;
    NSInteger trimLen = self.trimLen;
    
    NSInteger destPos = self.destPos;
    NSInteger destLen = self.destLen;
    MBool bEffectAddByTheme = MFalse;
    [self.pEffect getProperty:AMVE_PROP_EFFECT_ADDEDBYTHEME PropertyData:&bEffectAddByTheme];
    if (bEffectAddByTheme) {
        [self.storyboard removeEffect:self.pEffect];
        self.effectModel.pEffect = [self.storyboard setEffectAudio:self.effectModel.filePath audioTrimStartPos:trimPos audioTrimLength:trimLen storyBoardStartPos:destPos storyBoardLength:destLen groupID:self.groupID layerID:self.layerID mixPercent:50 dwRepeatMode:self.repeatMode  audioTitle:self.title identifier:self.effectModel.identifier];
    } else {
        [self.storyboard replaceAudioMusicFilePath:self.effectModel.filePath pEffect:self.effectModel.pEffect];
        [self.storyboard setAudioTitle:self.effectModel.pEffect audioTitle:self.effectModel.title];
        [self.storyboard updateAudioRawRangeStartPos:trimPos rawLength:trimLen pEffect:self.effectModel.pEffect];
    }
    [self.storyboard setEffectSourceRange:self.effectModel.pEffect dwPos:self.effectModel.sourceVeRange.dwPos dwLen:self.effectModel.sourceVeRange.dwLen];
    [self.storyboard setEffectRange:self.effectModel.pEffect startPos:self.destPos duration:self.destLen];
    [self.effectModel updateRelativeClipInfo];
    self.effectModel.isAddedByTheme = NO;
}


@end
