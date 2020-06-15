//
//  XYEffectTaskVisionDuplicate.m
//  XYCommonEngineKit
//
//  Created by 徐新元 on 2019/11/27.
//

#import "XYEffectTaskVisionDuplicate.h"

@implementation XYEffectTaskVisionDuplicate

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeUpdateAllEffect;//TODO:用addEffect 刷不出来 待check sunshine
}

- (BOOL)isReload {
    return YES;
}

- (void)engineOperate {
    CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectByIndex:self.indexInStoryboard dwTrackType:self.trackType groupId:self.groupID];
    CXiaoYingEffect *duplicateEffect = [effect duplicate];
    CXiaoYingClip *pStbDataClip = [self.storyboard.cXiaoYingStoryBoardSession getDataClip];
    [pStbDataClip insertEffect:duplicateEffect];

    [self.storyboard setEffectIdentifier:duplicateEffect identifier:self.effectModel.duplicateEffectModel.identifier];
    [self.storyboard setEffectRange:duplicateEffect startPos:self.effectModel.duplicateEffectModel.destVeRange.dwPos duration:self.effectModel.duplicateEffectModel.destVeRange.dwLen];
    [self.storyboard setEffectLayerId:duplicateEffect layerId:[self newEffectLayerId]];
    
    self.pEffect = duplicateEffect;
    self.effectModel.duplicateEffectModel = nil;
}

@end
