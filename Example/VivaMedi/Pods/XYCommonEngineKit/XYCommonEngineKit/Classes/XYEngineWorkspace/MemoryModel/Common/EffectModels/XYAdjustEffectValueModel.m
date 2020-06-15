//
//  XYAdjustEffectSyncValueModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/27.
//

#import "XYAdjustEffectValueModel.h"

@implementation XYAdjustEffectValueModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.adjustType = XYAdjustEffectTypeNone;
        self.rangeModels = nil;
    }
    return self;
}

@end
