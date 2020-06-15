//
//  XYSlideShowPanzoomModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/5/9.
//

#import "XYSlideShowTransformModel.h"

@implementation XYSlideShowTransformModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transformType = XYSlideShowTransformTypeColorFill;
        self.clearA = 255;
        self.rectB = 1;
        self.rectR = 1;
        self.scale = 1;
    }
    return self;
}

@end
