//
//  XYEffectTaskAudioUpdateSourceRange.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/11.
//

#import "XYEffectTaskAudioUpdateSourceRange.h"

@implementation XYEffectTaskAudioUpdateSourceRange

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeUpdateEffect;
}

- (void)engineOperate {
    CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectByIndex:self.effectModel.indexInStoryboard dwTrackType:self.trackType groupId:self.groupID];
    [self.storyboard setEffectSourceRange:effect dwPos:self.effectModel.sourceVeRange.dwPos dwLen:self.effectModel.sourceVeRange.dwLen];
    [self.storyboard setEffectRange:effect startPos:self.destPos duration:self.destLen];
    [self.effectModel updateRelativeClipInfo];
    [self.effectModel reload];
}


@end
