//
//  XYStoryboardTaskRedo.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/22.
//

#import "XYStoryboardTaskRedo.h"
#import "XYEngineWorkspace.h"
#import "XYEngineUndoMgr.h"

@implementation XYStoryboardTaskRedo

- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}

- (XYEngineUndoActionState)undoAntionState {
    return XYEngineUndoActionStateForcePreAdd;
}

- (BOOL)isReload {
    return NO;
}

- (BOOL)needRebuildThumbnailManager {
    return YES;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReBuildPlayer;
}

- (void)engineOperate {
    [XYEngineWorkspace cleanAllData];
    self.undoConfigModel = [[XYEngineWorkspace undoMgr] redo];
    self.seekPositon = [self.undoConfigModel.undoseekPositionNumber integerValue];
    if (!self.undoConfigModel.redoSeekPositionNumber) {
        self.undoConfigModel.redoSeekPositionNumber = self.storyboardModel.undoConfigModel.redoSeekPositionNumber;
    }
}

@end
