//
//  XYBaseEngineModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/12.
//

#import "XYBaseEngineModel.h"
#import "XYStoryboard.h"
#import "XYEngineUndoMgr.h"
#import "XYVeRangeModel.h"

@implementation XYEngineConfigModel

@end


@interface XYBaseEngineModel ()

@end


@implementation XYBaseEngineModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _skipReloadTimeline = NO;
        self.undoActionState = XYEngineUndoActionStateNone;
        self.taskID = XYCommonEngineTaskNone;
    }
    return self;
}

- (instancetype)init:(XYEngineConfigModel *)config {
    if (self =  [super init]) {
        self.taskID = XYCommonEngineTaskNone;
        _skipReloadTimeline = NO;
        _undoActionState = XYEngineUndoActionStateNone;
        _storyboard = config.storyboard;
    }
    return self;
}

- (XYEngineUndoManagerConfig *)undoConfigModel {
    if (!_undoConfigModel) {
        _undoConfigModel = [XYEngineUndoManagerConfig new];
    }
    return _undoConfigModel;
}

- (XYVeRangeModel *)trimVeRange {
    if (!_trimVeRange) {
        _trimVeRange = [[XYVeRangeModel alloc] init];
    }
    return _trimVeRange;
}


- (XYVeRangeModel *)destVeRange {
    if (!_destVeRange) {
        _destVeRange = [[XYVeRangeModel alloc] init];
    }
    return _destVeRange;
}


- (XYVeRangeModel *)sourceVeRange {
    if (!_sourceVeRange) {
        _sourceVeRange = [[XYVeRangeModel alloc] init];
    }
    return _sourceVeRange;
}

@end
