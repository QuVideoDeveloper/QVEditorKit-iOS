//
//  XYEffectTaskVisionDeleteKeyFrame.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/13.
//

#import "XYEffectTaskVisionDeleteKeyFrame.h"
#import "XYEffectVisionModel.h"
#import "XYEngineWorkspace.h"
#import "XYEffectOperationMgr.h"

@implementation XYEffectTaskVisionDeleteKeyFrame

- (void)engineOperate {
    if (self.effectModels.count <= 0 && self.effectModel) {
        self.operationCode = XYCommonEngineOperationCodeUpdateEffect;
        self.effectModels = @[self.effectModel];
    } else {
        self.operationCode = XYCommonEngineOperationCodeUpdateAllEffect;
    }
    [self.effectModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYEffectVisionModel *visionModel = obj;
        [self.storyboard setKeyframeData:nil effect:visionModel.pEffect];
    }];
    if (self.effectModels.count > 1) {
      [[XYEngineWorkspace effectMgr] reloadData];
    } else {
        self.isReload = YES;
    }
}

@end
