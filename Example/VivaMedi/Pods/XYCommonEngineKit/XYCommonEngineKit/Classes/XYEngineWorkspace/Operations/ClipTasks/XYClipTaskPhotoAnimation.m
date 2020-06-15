//
//  XYClipTaskPhotoAnimation.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/16.
//

#import "XYClipTaskPhotoAnimation.h"
#import "XYClipEditRatioService.h"

@implementation XYClipTaskPhotoAnimation

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeDisplayRefresh;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [XYClipEditRatioService setSingleClipAnimationWithClipIndex:obj.clipIndex effectType:obj.clipPropertyData.effectType doAnim:obj.clipPropertyData.isAnimationON storyBoard:self.storyboard];
    }];
}

@end
