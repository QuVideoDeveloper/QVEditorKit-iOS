//
//  XYEffectRelativeClipInfo.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/7.
//

#import "XYEffectRelativeClipInfo.h"
#import "XYVeRangeModel.h"

@implementation XYEffectRelativeClipInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.adjustState = XYEffectAdjustStateNone;
    }
    return self;
}

- (XYVeRangeModel *)destVeRange {
    if (!_destVeRange) {
        _destVeRange = [[XYVeRangeModel alloc] init];
    }
    return _destVeRange;
}

@end
