//
//  XYStoryboardTaskBackUp.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/2/3.
//

#import "XYStoryboardTaskBackUp.h"
#import "XYStoryboardModel.h"
#import "XYStordboardOperationMgr.h"
#import "XYEngineWorkspace.h"
#import "XYEngineUndoMgr.h"
#import "XYStbBackUpModel.h"

@implementation XYStoryboardTaskBackUp

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (BOOL)isReload {
    return NO;
}

- (BOOL)needRebuildThumbnailManager {
    return NO;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeNone;
}

- (void)engineOperate {
    [XYEngineWorkspace stordboardMgr].backUpModel.backUpWhenUndoStackCount = [[XYEngineWorkspace undoMgr] getCurrentUndoStackCount];
    [XYEngineWorkspace stordboardMgr].backUpModel.preBackUpRatio = self.storyboardModel.ratioValue;
    [XYEngineWorkspace stordboardMgr].backUpModel.preBackUpIsModified = self.storyboard.isModified;
    [XYEngineWorkspace stordboardMgr].backUpModel.backUpXiaoYingStoryBoardSession = [self.storyboard duplicate];
    [XYEngineWorkspace stordboardMgr].backUpModel.needCheckWorkspaceIsModefy = YES;
    [XYEngineWorkspace stordboardMgr].backUpModel.afterBackUpIsModified = NO;
    [XYEngineWorkspace stordboardMgr].backUpModel.preBackUpStbModel = [self.storyboardModel xyModelCopy];
}

@end
