//
//  XYEffectTaskAudioFadeIn.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/31.
//

#import "XYEffectTaskAudioFadeIn.h"
#import "XYEffectAudioModel.h"

@implementation XYEffectTaskAudioFadeIn

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectByIndex:self.effectModel.indexInStoryboard dwTrackType:self.trackType groupId:self.groupID];
    [self.storyboard setBGMFadeIsfadeInElseFadeOut:YES closeFade:!((XYEffectAudioModel *)self.effectModel).isFadeInON pEffect:effect fadeDuration:((XYEffectAudioModel *)self.effectModel).fadeDuration dwLength:self.destLen];
}

@end
