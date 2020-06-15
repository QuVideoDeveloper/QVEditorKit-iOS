//
//  XYBaseClipTask.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYBaseClipTask.h"
#import "XYClipModel.h"

@implementation XYBaseClipTask

- (BOOL)skipReloadTimeline {
    __block BOOL isSkip = NO;
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.skipReloadTimeline && 0 == idx) {
            isSkip = obj.skipReloadTimeline;
        } else if (!obj.skipReloadTimeline){
            *stop = YES;
        }
        obj.skipReloadTimeline = NO;
    }];
    return isSkip;
}

- (XYEngineTaskType)engineTaskType {
    return XYEngineTaskTypeClip;
}

- (BOOL)isAutoplay {
    __block BOOL isAutoplay = NO;
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isAutoplay && 0 == idx) {
            isAutoplay = obj.isAutoplay;
        } else if (!obj.isAutoplay){
            *stop = YES;
        }
        obj.isAutoplay = NO;
    }];
    return isAutoplay;
}

- (NSInteger)seekPositon {
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


@end
