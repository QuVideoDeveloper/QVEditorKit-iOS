//
//  XYEffectTaskAudioRepat.m
//  AWSCore
//
//  Created by 夏澄 on 2019/10/31.
//

#import "XYEffectTaskAudioRepeat.h"
#import "XYEffectAudioModel.h"

@implementation XYEffectTaskAudioRepeat

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;// sunshine 待确定是否需要reopen
}

- (void)engineOperate {
    CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectByIndex:self.indexInStoryboard dwTrackType:self.trackType groupId:self.groupID];
    [self.storyboard setAudioRepeatEffect:effect isRepeatON:((XYEffectAudioModel *)self.effectModel).isRepeatON];
    [self.storyboard setEffectRange:effect startPos:self.destPos duration:self.destLen];
    [self.effectModel reload];
    [self.effectModel updateRelativeClipInfo];
}

@end
