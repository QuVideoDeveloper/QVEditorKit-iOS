//
//  XYBaseStoryboardTask.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYBaseStoryboardTask.h"

@implementation XYBaseStoryboardTask

- (BOOL)skipReloadTimeline {
    BOOL isSkip = self.storyboardModel.skipReloadTimeline;
    self.storyboardModel.skipReloadTimeline = NO;
    return isSkip;
}

- (BOOL)isAutoplay {
    BOOL isAutoplay = self.storyboardModel.isAutoplay;
    self.storyboardModel.isAutoplay = NO;
    return isAutoplay;
}

- (NSInteger)seekPositon {
    NSInteger seekPos = -1;
    if (self.storyboardModel.seekPositionNumber) {
        seekPos = [self.storyboardModel.seekPositionNumber integerValue];
        self.storyboardModel.seekPositionNumber = nil;
    }
    return seekPos;
}

@end
