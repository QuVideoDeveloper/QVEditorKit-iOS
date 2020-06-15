//
//  XYStordboardOperationMgr.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import "XYStordboardOperationMgr.h"
#import "XYOperationMgrBase_Private.h"
#import "XYBaseEngineTask.h"
#import "XYStoryboardTaskAddTheme.h"
#import "XYCommonEngineTaskMgr.h"
#import "XYStoryboardModel.h"
#import "XYEngineDef.h"
#import "XYStoryboardTaskFactory.h"
#import "XYBaseStoryboardTask.h"
#import "XYEngineWorkspace.h"
#import "XYClipOperationMgr.h"
#import "XYEffectOperationMgr.h"
#import "XYEngineUndoMgr.h"
#import "XYStbBackUpModel.h"
#import "XYCommonEngineGlobalData.h"
#import <XYCategory/XYCategory.h>

#define APP_BUNDLE_DIRECTORY         \
[[NSBundle mainBundle] resourcePath]

#define APP_BUNDLE_PRIVATE_PATH         \
[NSString stringWithFormat:@"%@/private",APP_BUNDLE_DIRECTORY]

#define APP_BUNDLE_MUSIC_PATH          \
[NSString stringWithFormat:@"%@/defaultmusic/",APP_BUNDLE_PRIVATE_PATH]

@interface XYStordboardOperationMgr ()<XYBaseEngineTaskDelegate>


@end


@implementation XYStordboardOperationMgr

- (void)runTask:(XYStoryboardModel *)storyboardModel {
    if (XYCommonEngineTaskIDStoryboardBackUp == storyboardModel.taskID) {
        [XYEngineWorkspace stordboardMgr].backUpModel.needCheckWorkspaceIsModefy = NO;
    }
    [XYEngineWorkspace space].undoActionState = storyboardModel.undoActionState;
    if (XYEngineUndoActionStateSetPreAdd != storyboardModel.undoActionState) {
        NSAssert(storyboardModel == self.currentStbModel, @"用这个currentStbModel 不要自己new一个出来");
        XYEngineUndoActionState undoActionState = storyboardModel.undoActionState;
        [self addUndo:storyboardModel];//这里会重置掉undoActionState
        XYBaseStoryboardTask *storyboardTask = [XYStoryboardTaskFactory factoryWithType:storyboardModel.taskID];
        storyboardTask.userInfo = storyboardModel.userInfo;
        storyboardTask.undoAntionState = undoActionState;
        storyboardTask.taskID = storyboardModel.taskID;
        storyboardTask.storyboard = self.storyboard;
        storyboardTask.delegate = self;
        storyboardTask.storyboardModel = storyboardModel;
        [[XYCommonEngineTaskMgr task] postTask:storyboardTask preprocessBlock:^{
            if ([self.delegate respondsToSelector:@selector(onOperationTaskStart:)]) {
                XYEngineUndoManagerConfig *undoConfigModel;
                if (XYCommonEngineTaskIDStoryboardUndo == storyboardTask.taskID) {
                    undoConfigModel = [[XYEngineWorkspace undoMgr] undoStackWillPopObject];
                } else if (XYCommonEngineTaskIDStoryboardRedo == storyboardTask.taskID) {
                    undoConfigModel = [[XYEngineWorkspace undoMgr] redoStackWillPopObject];
                }
                if (undoConfigModel) {
                    storyboardTask.undoConfigModel = undoConfigModel;
                }
                [self.delegate onOperationTaskStart:storyboardTask];
            };
        }];
    } else {
        [self addUndo:storyboardModel];
    }
}

- (id)getCopyXYMeta {
    XYEngineConfigModel *config = [[XYEngineConfigModel alloc] init];
    config.storyboard = self.storyboard;
    XYStoryboardModel *stbModel = [[XYStoryboardModel alloc] init:config];
    [stbModel reload];
    return stbModel;
}

#pragma mark -- delegate

- (void)onEngineFinish:(XYBaseEngineTask *)baseTask {
    [XYEngineWorkspace stordboardMgr].currentStbModel.videoDuration = [self.storyboard getDuration];
    if (XYCommonEngineTaskIDStoryboardAddTheme == baseTask.taskID || XYCommonEngineTaskIDStoryboardReset == baseTask.taskID) {
        [self.currentStbModel reload];
        [[XYEngineWorkspace clipMgr] reloadData];
        [[XYEngineWorkspace effectMgr] reloadData];//重新计算效果会调用这个方法 应用主题后效果会删除 这时内存数据还有一份 重新刷的时候不需要更新相对clip的信息
        if (baseTask.adjustEffect) {
//            [XYEngineWorkspace adjustEffect:baseTask.taskID];
//            [[XYEngineWorkspace effectMgr] reloadData];//重新计算后 可能有删除的effect 需要重新加载内存数据 这里就是引擎用index带来的问题
        }
    } else if (XYCommonEngineTaskIDStoryboardRatio == baseTask.taskID) {
        [[XYEngineWorkspace clipMgr] reloadData];
        [[XYEngineWorkspace effectMgr] reloadData];
    }
    if ([self.delegate respondsToSelector:@selector(onOperationTaskFinish:)]) {
         [self.delegate onOperationTaskFinish:baseTask];
     }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataBoard setValue:baseTask forKey:[NSString stringWithFormat:@"%d",baseTask.taskID]];
        if (XYEngineUndoActionStateSetPreAdd == baseTask.undoAntionState || XYEngineUndoActionStateAdded == baseTask.undoAntionState || XYEngineUndoActionStateForcePreAdd == baseTask.undoAntionState) {
            XYBaseEngineModel *engineModel = [[XYBaseEngineModel alloc] init];
            engineModel.undoActionState = XYEngineUndoActionStateForcePreAdd;
            [self addUndo:engineModel];
        }
    });
}

#pragma mark -- lazy

- (XYStbBackUpModel *)backUpModel {
    if (!_backUpModel) {
        _backUpModel = [[XYStbBackUpModel alloc] init];
    }
    return _backUpModel;
}

- (XYStoryboardModel *)currentStbModel {
    if (!_currentStbModel) {
        XYEngineConfigModel *config = [[XYEngineConfigModel alloc] init];
        config.storyboard = self.storyboard;
        _currentStbModel = [[XYStoryboardModel alloc] init:config];
    }
    return _currentStbModel;
}

- (void)reloadData {
    [self.currentStbModel reload];
}

- (BOOL)bgmIsAddedByTheme:(NSString *)bgmPath {
    __block BOOL isAddedByTheme = NO;
    NSArray *themeMusicPathList = self.currentStbModel.themeMusicPathList;
    if ([bgmPath containsString:APP_BUNDLE_MUSIC_PATH]) {
        isAddedByTheme = YES;
    } else {
        [themeMusicPathList enumerateObjectsUsingBlock:^(NSString *themeMusicPath, NSUInteger idx, BOOL * _Nonnull stop) {
            if (themeMusicPath && bgmPath) {
                isAddedByTheme = [themeMusicPath isEqualToString:bgmPath];
                if (isAddedByTheme) {
                    *stop = YES;
                }
            }
        }];
    }
    return isAddedByTheme;
}

- (CGFloat)originaRatio:(BOOL)isPhotoMV {
    BOOL isThemeApplied = self.currentStbModel.themeID > 0x100000000000000;
    MSIZE inputScale;
    inputScale.cx = 0;
    inputScale.cy = 0;
    MPOINT size = [self.storyboard updateStoryboardSizeWithInputWidth:[XYCommonEngineGlobalData data].configModel.outPutResolutionWidth inputScale:inputScale isPhotoMV:isPhotoMV isAppliedEffects:isThemeApplied downScale:YES];
    CGFloat ratio = 16 / 9.0;
    if (size.y > 0 && size.x > 0) {
        CGFloat sizeY = size.y;
        ratio = size.x / sizeY;
    }
    return ratio;
}

- (void)cleanData {
    self.currentStbModel = nil;
}

@end
