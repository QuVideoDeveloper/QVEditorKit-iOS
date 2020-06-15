//
//  XYStoryboardTaskUndo.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/22.
//

#import "XYStoryboardTaskUndo.h"
#import "XYEngineWorkspace.h"
#import "XYEngineUndoMgr.h"

@implementation XYStoryboardTaskUndo

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
    self.undoConfigModel = [[XYEngineWorkspace undoMgr] undo];
    self.seekPositon = [self.undoConfigModel.undoseekPositionNumber integerValue];
}

@end
