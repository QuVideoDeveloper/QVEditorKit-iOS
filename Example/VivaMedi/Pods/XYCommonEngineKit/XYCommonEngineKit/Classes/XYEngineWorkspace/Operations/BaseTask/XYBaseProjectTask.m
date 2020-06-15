//
//  XYBaseProjectTask.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/23.
//

#import "XYBaseProjectTask.h"

@implementation XYBaseProjectTask

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (BOOL)isReload {
    return NO;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeNone;
}

- (BOOL)isAutoplay {
    BOOL isAutoplay = self.projectModel.isAutoplay;
    self.projectModel.isAutoplay = NO;
    return isAutoplay;
}

- (NSInteger)seekPositon {
    NSInteger seekPos = -1;
    if (self.projectModel.seekPositionNumber) {
        seekPos = [self.projectModel.seekPositionNumber integerValue];
        self.projectModel.seekPositionNumber = nil;
    }
    return seekPos;
}

@end
