//
//  XYEffectTaskAudioFadeOut.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/31.
//

#import "XYEffectTaskAudioFadeOut.h"
#import "XYEffectAudioModel.h"

@implementation XYEffectTaskAudioFadeOut

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    XYEffectAudioModel *audioModel = self.effectModel;
    CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectByIndex:self.effectModel.indexInStoryboard dwTrackType:self.trackType groupId:self.groupID];
    [self.storyboard setBGMFadeIsfadeInElseFadeOut:NO closeFade:!audioModel.isFadeOutON pEffect:effect fadeDuration:audioModel.fadeDuration dwLength:self.destLen];
}

@end
