//
//  XYClipTaskSplit.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/16.
//

#import "XYClipTaskSplit.h"
#import "XYEngineWorkspace.h"
#import "XYClipOperationMgr.h"

@implementation XYClipTaskSplit {
    NSInteger _seekPos;
}


- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _seekPos = -1;
    }
    return self;
}

- (NSInteger)seekPositon {
    if (_seekPos > 0) {
        return _seekPos;
    }
    __block NSInteger seekPos = -1;
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.seekPositionNumber && 0 == idx) {
            seekPos = [obj.seekPositionNumber integerValue];
        } else if (!obj.seekPositionNumber){
            *stop = YES;
        }
        obj.seekPositionNumber = nil;
    }];
    return seekPos;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineAll;
}

- (BOOL)isReload {
    return YES;
}

- (BOOL)needRebuildThumbnailManager {
    return YES;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //相对timeline 上的clip splitPositon
        if (obj.splitClipPostion > 0) {
            if (obj.splitClipPostion >= obj.destVeRange.dwLen) {
                return;
            }
            [self.storyboard splitClip:obj.clipIndex splitPosition:obj.splitClipPostion];
        }
    }];
}
@end
