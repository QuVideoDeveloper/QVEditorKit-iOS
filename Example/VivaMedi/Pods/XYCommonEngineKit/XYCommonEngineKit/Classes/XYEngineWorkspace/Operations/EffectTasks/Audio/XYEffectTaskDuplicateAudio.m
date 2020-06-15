//
//  XYEffectTaskDuplicateAudio.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/28.
//

#import "XYEffectTaskDuplicateAudio.h"
#import "XYEffectAudioModel.h"

@implementation XYEffectTaskDuplicateAudio

- (BOOL)isReload {
    return YES;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeAddEffect;
}

- (void)engineOperate {
    CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectByIndex:self.indexInStoryboard dwTrackType:self.trackType groupId:self.groupID];
    CXiaoYingEffect *duplicateEffect = [effect duplicate];
    CXiaoYingClip *pStbDataClip = [self.storyboard.cXiaoYingStoryBoardSession getDataClip];
    [pStbDataClip insertEffect:duplicateEffect];
    self.pEffect = duplicateEffect;
    [self.storyboard setEffectIdentifier:duplicateEffect identifier:self.effectModel.duplicateEffectModel.identifier];
    [self.storyboard setAudioRepeatEffect:duplicateEffect isRepeatON:((XYEffectAudioModel *)self.effectModel.duplicateEffectModel).isRepeatON];
    [self.storyboard setEffectRange:duplicateEffect startPos:self.effectModel.duplicateEffectModel.destVeRange.dwPos duration:self.effectModel.duplicateEffectModel.destVeRange.dwLen];
    self.effectModel.duplicateEffectModel = nil;
}

@end
