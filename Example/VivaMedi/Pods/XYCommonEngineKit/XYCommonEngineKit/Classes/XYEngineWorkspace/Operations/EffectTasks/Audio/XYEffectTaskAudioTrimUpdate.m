//
//  XYEffectTaskAudioTrimAudioRange.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/13.
//

#import "XYEffectTaskAudioTrimUpdate.h"

@implementation XYEffectTaskAudioTrimUpdate

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeUpdateEffect;
}

- (void)engineOperate {
    CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectByIndex:self.effectModel.indexInStoryboard dwTrackType:self.trackType groupId:self.groupID];
    [self.storyboard updateAudioTrimRange:effect audioTrimStartPos:self.effectModel.trimVeRange.dwPos audioTrimLength:self.effectModel.trimVeRange.dwLen];
    [self.storyboard setEffectRange:effect startPos:self.destPos duration:self.destLen];
    [self.effectModel updateRelativeClipInfo];
}

@end
