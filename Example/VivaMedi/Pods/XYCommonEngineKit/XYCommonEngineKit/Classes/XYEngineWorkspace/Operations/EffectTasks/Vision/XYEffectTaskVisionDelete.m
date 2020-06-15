//
//  XYEffectTaskVisionDelete.m
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/11/19.
//

#import "XYEffectTaskVisionDelete.h"

@implementation XYEffectTaskVisionDelete

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeRemoveEffect;
}

- (BOOL)isReload {
    return YES;
}

- (void)engineOperate {
    XYEffectVisionModel *effectVisionModel = self.effectModel;    
    [self.storyboard removeEffect:self.effectModel.pEffect];
    self.effectModel.pEffect = nil;
}

@end
