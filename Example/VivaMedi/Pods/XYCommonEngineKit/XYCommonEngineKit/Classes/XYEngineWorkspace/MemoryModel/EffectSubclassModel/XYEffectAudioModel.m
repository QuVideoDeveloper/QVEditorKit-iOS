//
//  XYAudioEffectModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/7.
//

#import "XYEffectAudioModel.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYEffect.h"
#import "XYEngineWorkspace.h"
#import "XYStordboardOperationMgr.h"
#import "XYStoryboardModel.h"
#import <XYCategory/XYCategory.h>

@implementation XYEffectAudioModel

- (XYEngineModelType)engineModelType {
    return XYEngineModelTypeAudio;
}

- (void)reload {
    [super reload];
    [self reloadIsInvalid];
    if (!self.isInvalid) {
        [self reloadVolumeValue];
        [self reloadIsFadeInON];
        [self reloadIsFadeOutON];
        [self reloadIsRepeatON];
        [self reloadAudioTitle];
    }
}

- (void)reloadVolumeValue {
    self.volumeValue = [self.storyboard audioVolumeEffectIndex:self.indexInStoryboard trackType:self.trackType groupID:self.groupID];
}

- (void)reloadIsFadeInON {
    self.isFadeInON = [self.storyboard getBGMFadeIsfadeInElseFadeOut:YES pEffect:self.pEffect];
}

- (void)reloadIsFadeOutON {
    self.isFadeOutON = [self.storyboard getBGMFadeIsfadeInElseFadeOut:NO pEffect:self.pEffect];
}

- (void)reloadIsRepeatON {
    self.isRepeatON = [self.storyboard audioIsRepeatEffect:self.pEffect];
}

- (void)reloadIsInvalid {//sunshine code
    if(GROUP_ID_BGMUSIC == self.groupID || GROUP_ID_DUBBING == self.groupID || GROUP_ID_RECORD == self.groupID ) {
           NSString *bgmPath = [self.storyboard getBGMPath];
      if ([bgmPath hasSuffix:@"dummy.mp3"]) {
          self.isInvalid = YES;
      } else {
          self.isInvalid = NO;
      }
    }
}

- (void)reloadAudioFilePath {
    self.filePath = [self.storyboard getAudioFilePath:self.pEffect];
}

- (void)reloadAudioTitle {
    [self reloadAudioFilePath];
    [self reloadIsAddedByTheme];
    self.title = [self.storyboard getAudioTitle:self.pEffect];
    if ([NSString xy_isEmpty:self.title]) {
        self.title = self.filePath;
    }
    if ([self.title containsString:@"/"]) {
        NSArray *componentArr = [self.title componentsSeparatedByString:@"/"];
        NSString *lastComponentStr = componentArr.lastObject;
        if ([lastComponentStr containsString:@"."]) {
            NSArray *lastComponentArr = [lastComponentStr componentsSeparatedByString:@"."];
            NSString *audioName = lastComponentArr.firstObject;
            self.title = audioName;
        }
    }
}

- (void)reloadIsAddedByTheme {
    MBool bEffectAddByTheme = MFalse;
    [self.pEffect getProperty:AMVE_PROP_EFFECT_ADDEDBYTHEME PropertyData:&bEffectAddByTheme];
    if (bEffectAddByTheme) {
        self.isAddedByTheme = [[XYEngineWorkspace stordboardMgr] bgmIsAddedByTheme:self.filePath];
    } else {
        self.isAddedByTheme = NO;
    }
}

@end
