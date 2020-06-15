//
//  XYOperationMgrBase.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import "XYOperationMgrBase.h"
#import "XYOperationMgrBase_Private.h"
#import "XYEngineUndoMgr.h"
#import "XYBaseEngineModel.h"
#import "XYEngineWorkspace.h"
#import "XYCommonEngineTaskMgr.h"

@implementation XYOperationMgrBase

//TODO 不用重置 storyboard sunshine
- (instancetype)initWithStoryboard:(XYStoryboard *)storyboard {
    self = [super init];
    if (self) {
        self.storyboard = storyboard;
    }
    return self;
}

- (XYStoryboard *)storyboard {
    return [XYEngineWorkspace currentStoryboard];
}

- (XYReactBlackMapBoard *)dataBoard {
    if (!_dataBoard) {
        _dataBoard = [[XYReactBlackMapBoard alloc] init];
    }
    return _dataBoard;
}

- (void)addObserver:(id)observer observerID:(XYCommonEngineTaskID)observerID block:(void (^)(id obj))block {
    if (block) {
        RACSignal *signal = [self.dataBoard addObserver:observer forKey:[NSString stringWithFormat:@"%d",observerID]];
        [signal subscribeNext:block];
    }
}

- (void)removeObserver:(id)observer observerID:(XYCommonEngineTaskID)observerID {
    [self.dataBoard removeObserver:observer forKey:[NSString stringWithFormat:@"%d",observerID]];
}

- (void)reloadData {
    
}

- (void)addUndo:(XYBaseEngineModel *)engineModel {
    XYEngineUndoActionState actionState = engineModel.undoActionState;
    engineModel.undoActionState = XYEngineUndoActionStateNone;
    XYEngineUndoManagerConfig *undoConfigModelCopy = [engineModel.undoConfigModel xyModelCopy];
    [[XYCommonEngineTaskMgr task] postTaskHandle:^{
        if (XYEngineUndoActionStateNone == actionState) {
            return;
        } else {
            __block XYEngineUndoManagerConfig *undoConfig;
            if (XYEngineUndoActionStateNone != actionState) {
                undoConfig = undoConfigModelCopy;
                undoConfig.identifier = engineModel.identifier;
                undoConfig.taskID = engineModel.taskID;
                undoConfig.groupID = engineModel.groupID;
            }
            if (XYEngineUndoActionStateBySelf == actionState) {
                [[XYEngineWorkspace undoMgr] addDoWithConfig:^XYEngineUndoManagerConfig * _Nonnull(XYEngineUndoManagerConfig * _Nonnull config) {
                    if (!undoConfig) {
                        undoConfig = config;
                    }
                    return undoConfig;
                }];
                return;
            }
            BOOL preAdd = NO;
            if (XYEngineUndoActionStateForcePreAdd == actionState) {
                preAdd = YES;
            } else if (XYEngineUndoActionStatePreAdd == actionState) {
                if (XYEngineUndoActionStatePreAdd == actionState && XYEngineUndoActionStatePreAdd != [XYEngineWorkspace undoMgr].undoAntionState) {
                    preAdd = YES;
                }
            }
            if (preAdd) {
                [[XYEngineWorkspace undoMgr] preAddDoWithConfig:^XYEngineUndoManagerConfig * _Nonnull(XYEngineUndoManagerConfig * _Nonnull config) {
                    if (!undoConfig) {
                        undoConfig = config;
                    }
                    return undoConfig;
                }];
            } else if (XYEngineUndoActionStateSetPreAdd == actionState || XYEngineUndoActionStateAdded == actionState) {
                [[XYEngineWorkspace undoMgr] setPreAddDoneWithConfig:^XYEngineUndoManagerConfig * _Nonnull(XYEngineUndoManagerConfig * _Nonnull config) {
                    if (!undoConfig) {
                        undoConfig = config;
                    }
                    return undoConfig;
                }];
                if (XYEngineUndoActionStateSetPreAdd == actionState) {
                    [[XYEngineWorkspace undoMgr] preAddDoWithConfig:^XYEngineUndoManagerConfig * _Nonnull(XYEngineUndoManagerConfig * _Nonnull config) {
                        if (!undoConfig) {
                            undoConfig = config;
                        }
                        return undoConfig;
                    }];
                }
            }
        }
    }];
    
}

- (void)cleanData {
    
}

- (id)getCopyXYMeta {
    return nil;
}

@end
