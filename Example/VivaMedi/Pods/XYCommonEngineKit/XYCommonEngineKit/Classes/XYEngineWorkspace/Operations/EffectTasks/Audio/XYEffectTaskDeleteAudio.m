//
//  XYEffectTaskDeleteMusic.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/26.
//

#import "XYEffectTaskDeleteAudio.h"

@implementation XYEffectTaskDeleteAudio

- (BOOL)isReload {
    return YES;
}

- (void)engineOperate {
    if (self.effectModels.count <= 0 && self.effectModel) {
//        self.operationCode = XYCommonEngineOperationCodeRemoveEffect;
        self.operationCode = XYCommonEngineOperationCodeUpdateAllEffect;
        self.effectModels = @[self.effectModel];
    } else if (self.effectModels.count == 1) {
//        self.operationCode = XYCommonEngineOperationCodeRemoveEffect;
        self.operationCode = XYCommonEngineOperationCodeUpdateAllEffect;
    } else {
        self.operationCode = XYCommonEngineOperationCodeUpdateAllEffect;
    }//TODO: 引擎删除主题配乐 XYCommonEngineOperationCodeRemoveEffect 依旧会有音乐
    [self.effectModels enumerateObjectsUsingBlock:^(XYEffectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectByIndex:obj.indexInStoryboard  dwTrackType:self.trackType groupId:self.groupID];
        [self.storyboard removeEffect:effect];
    }];
}


@end
