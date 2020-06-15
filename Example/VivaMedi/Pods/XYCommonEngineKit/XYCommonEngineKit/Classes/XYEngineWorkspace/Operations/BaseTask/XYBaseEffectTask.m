//
//  XYBaseEffectTask.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYBaseEffectTask.h"
#import "XYEffectModel.h"

@implementation XYBaseEffectTask

- (BOOL)skipReloadTimeline {
    BOOL isSkip = self.effectModel.skipReloadTimeline;
    self.effectModel.skipReloadTimeline = NO;
    return isSkip;
}

- (BOOL)isAutoplay {
    BOOL isAutoplay = self.effectModel.isAutoplay;
    self.effectModel.isAutoplay = NO;
    return isAutoplay;
}

- (NSInteger)seekPositon {
    NSInteger seekPos = -1;
    if (self.effectModel.seekPositionNumber) {
        seekPos = [self.effectModel.seekPositionNumber integerValue];
        self.effectModel.seekPositionNumber = nil;
    }
    return seekPos;
}

- (NSString *)filePath {
    return self.effectModel.filePath;
}

- (NSInteger)indexInStoryboard {
    return self.effectModel.indexInStoryboard;
}

- (NSInteger)trimPos {
    return self.effectModel.trimVeRange.dwPos;
}

- (NSInteger)trimLen {
    return self.effectModel.trimVeRange.dwLen;
}

- (NSInteger)destPos {
    return self.effectModel.destVeRange.dwPos;
}

- (NSInteger)destLen {
    return self.effectModel.destVeRange.dwLen;
}

- (NSInteger)duplicateStartPos {
    return self.effectModel.duplicateStartPos;
}

- (NSString *)title {
    return self.effectModel.title;
}

@end
