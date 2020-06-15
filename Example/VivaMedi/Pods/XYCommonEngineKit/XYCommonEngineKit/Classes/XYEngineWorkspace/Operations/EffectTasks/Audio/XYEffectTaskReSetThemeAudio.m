//
//  XYEffectTaskReSetThemeAudio.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/4.
//

#import "XYEffectTaskReSetThemeAudio.h"

@implementation XYEffectTaskReSetThemeAudio


- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineAll;
}

- (BOOL)isReload {
    return YES;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeUpdateAllMusic;
}

- (void)engineOperate {
    [self.storyboard removeBGM];
    [self.storyboard resetBGM];
}

@end
