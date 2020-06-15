//
//  XYStoryboardTaskReset.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/2/3.
//

#import "XYStoryboardTaskReset.h"
#import "XYEngineWorkspace.h"
#import "XYStordboardOperationMgr.h"
#import "XYEngineUndoMgr.h"
#import "XYStbBackUpModel.h"

@implementation XYStoryboardTaskReset

- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}

- (XYEngineUndoActionState)undoAntionState {
    if ([XYEngineWorkspace stordboardMgr].backUpModel.afterBackUpIsModified) {
        return XYEngineUndoActionStateForcePreAdd;
    } else {
        return XYEngineUndoActionStateNone;
    }
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    if ([XYEngineWorkspace stordboardMgr].backUpModel.afterBackUpIsModified) {
        return XYEngineReloadTimeLineAll;
    } else {
        return XYEngineReloadTimeLineByNone;
    }
}

- (BOOL)isReload {
    if ([XYEngineWorkspace stordboardMgr].backUpModel.afterBackUpIsModified) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)needRebuildThumbnailManager {
    if ([XYEngineWorkspace stordboardMgr].backUpModel.afterBackUpIsModified) {
        return YES;
    } else {
        return NO;
    }
}

- (XYCommonEngineOperationCode)operationCode {
    if ([XYEngineWorkspace stordboardMgr].backUpModel.afterBackUpIsModified) {
        return XYCommonEngineOperationCodeReBuildPlayer;
    } else {
        return XYCommonEngineOperationCodeNone;
    }
}

- (void)engineOperate {
    [XYStoryboard sharedXYStoryboard].isModified = [XYEngineWorkspace stordboardMgr].backUpModel.preBackUpIsModified;
    if ([XYEngineWorkspace stordboardMgr].backUpModel.afterBackUpIsModified) {
        [[XYEngineWorkspace undoMgr] removeObjFromUndoStactLastCount:[[XYEngineWorkspace undoMgr] getCurrentUndoStackCount] - [XYEngineWorkspace stordboardMgr].backUpModel.backUpWhenUndoStackCount];
        if ([XYEngineWorkspace stordboardMgr].backUpModel.backUpXiaoYingStoryBoardSession) {
            [self.storyboard setStoryboardSession:[XYEngineWorkspace stordboardMgr].backUpModel.backUpXiaoYingStoryBoardSession];
        }
    }
}

@end
