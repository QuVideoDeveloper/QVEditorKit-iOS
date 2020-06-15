//
//  XYClipTaskAdd.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYClipTaskAdd.h"
#import "XYClipModel.h"
#import "XYEngineModelBridgeUtility.h"
#import "XYEngineWorkspace.h"
#import "XYStoryboardModel.h"
#import "XYStordboardOperationMgr.h"
#import "XYEngineUndoMgr.h"

@implementation XYClipTaskAdd

- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineAll;
}

- (BOOL)isReload {
    return YES;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    XYClipModel *currentClipModel = self.clipModels.firstObject;
    __block isFirstAddClip = [self.storyboard getClipCount] <= 0;
    [currentClipModel.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.clipIndex >= 0) {
            [self.storyboard insertClipByClipDataItem:[XYEngineModelBridgeUtility bridge:obj] Position:obj.clipIndex];
            if ([XYCommonEngineGlobalData data].configModel.addClipNeedAutoAdjustVideoScale && ![[XYStoryboard sharedXYStoryboard] isRatioSelected]) {
                MSIZE scale = [self.storyboard getThemeInnerBestSize:[XYEngineWorkspace stordboardMgr].currentStbModel.themePath];
                [[XYEngineWorkspace stordboardMgr].currentStbModel reload];
                
                [[XYEngineWorkspace undoMgr] updateRedoParam:[NSMutableDictionary dictionaryWithDictionary:@{@"ratio":@([XYEngineWorkspace stordboardMgr].currentStbModel.ratioValue)}]];

            }
        }
    }];
}

@end
