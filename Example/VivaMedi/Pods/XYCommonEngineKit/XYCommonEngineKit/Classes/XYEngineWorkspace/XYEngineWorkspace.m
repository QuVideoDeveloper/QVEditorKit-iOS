//
//  XYCommonEngineManager.m
//  AWSCore
//
//  Created by 夏澄 on 2019/10/11.
//

#import "XYEngineWorkspace.h"
#import "XYCommonEngineTaskMgr.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYClip.h"
#import "XYStoryboard+XYThumbnail.h"
#import "XYClipOperationMgr.h"
#import "XYEffectOperationMgr.h"
#import "XYStordboardOperationMgr.h"
#import "XYQProjectOperatonMgr.h"
#import "XYEngineEnum.h"

#import "XYStoryboardModel.h"
#import "XYClipModel.h"
#import <XYReactDataBoard/XYReactBlackMapBoard.h>
#import "XYEngineUndoMgr.h"
#import "XYBaseEngineTask.h"
#import "XYStbBackUpModel.h"
#import "XYEffectModel.h"
#import "XYCommonEngineLifeCycleService.h"
#import "XYProjectExportMgr.h"

@interface XYEngineWorkspace()
@property (nonatomic, strong) XYReactBlackMapBoard *dataBoard;
@property (nonatomic, strong) XYClipOperationMgr *clipMgr;
@property (nonatomic, strong) XYEffectOperationMgr *effectMgr;
@property (nonatomic, strong) XYStordboardOperationMgr *stordboardMgr;
@property (nonatomic, strong) XYQProjectOperatonMgr *projectMgr;
@property (nonatomic, strong) XYEngineUndoMgr *undoMgr;
@property (nonatomic, strong) XYProjectExportMgr *exportMgr;

@property (nonatomic, strong) XYStoryboard *storyboard;

@property (nonatomic, strong) XYStoryboard *tempWorkspaceStoryboard;
@property (nonatomic, strong) XYEngineUndoMgr *tempWorkspaceUndoMgr;
@property (nonatomic, strong) XYReactBlackMapBoard *tempWorkspaceDataBoard;
@property (nonatomic, strong) XYClipOperationMgr *tempWorkspaceClipMgr;

@property (nonatomic , strong) XYEngineWorkspaceConfiguration *workspaceConfigModel;
@property (nonatomic , strong) CXiaoYingStoryBoardSession *pCurrentStbSession;

@property (nonatomic, assign) BOOL isTempWorkspace;

@property (nonatomic, strong) XYCommonEngineLifeCycleService *lifeCycleService;


@end

@implementation XYEngineWorkspace

static dispatch_once_t spaceOnceToken;
static XYEngineWorkspace *_space;

+ (XYEngineWorkspace *)space {
    dispatch_once(&spaceOnceToken, ^{
      _space = [[XYEngineWorkspace alloc] init];
    });
    return _space;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isPrebackWorkspace = NO;
        [self.lifeCycleService start];
    }
    return self;
}


#pragma mark - public
+ (void)clean {
    [[XYEngineWorkspace space].lifeCycleService stop];
    [XYEngineWorkspace space].lifeCycleService = nil;
    [XYEngineWorkspace space].clipMgr = nil;
    [XYEngineWorkspace space].effectMgr = nil;
    [XYEngineWorkspace space].stordboardMgr = nil;
//    [XYEngineWorkspace space].projectMgr = nil;

    [XYEngineWorkspace space].undoMgr = nil;
    [XYEngineWorkspace space].storyboard = nil;

    [[XYEngineWorkspace undoMgr] clean];
    [XYCommonEngineGlobalData clean];
}


+ (void)pause {
    [[XYCommonEngineTaskMgr task] pause];
}

+ (void)resume {
    [[XYCommonEngineTaskMgr task] resume];
}

+ (XYStoryboard *)currentStoryboard {
    if ([XYEngineWorkspace space].isTempWorkspace) {
       return [XYEngineWorkspace space].tempWorkspaceStoryboard;
    } else {
       return [XYEngineWorkspace space].storyboard;
    }
}

+ (XYEngineUndoMgr *)undoMgr {
    if ([XYEngineWorkspace space].isTempWorkspace) {
      return [XYEngineWorkspace space].tempWorkspaceUndoMgr;
    } else {
      return [XYEngineWorkspace space].undoMgr;
    }
}

+ (XYProjectExportMgr *)exportMgr {
    return [XYEngineWorkspace space].exportMgr;
}

+ (XYClipOperationMgr *)clipMgr {
    if ([XYEngineWorkspace space].isTempWorkspace) {
       return [XYEngineWorkspace space].tempWorkspaceClipMgr;
    } else {
       return [XYEngineWorkspace space].clipMgr;
    }
}


+ (XYEffectOperationMgr *)effectMgr {
  return [XYEngineWorkspace space].effectMgr;
}

+ (XYStordboardOperationMgr *)stordboardMgr {
  return [XYEngineWorkspace space].stordboardMgr;
}

+ (XYQProjectOperatonMgr*)projectMgr {
  return [XYEngineWorkspace space].projectMgr;
}

+ (void)addObserver:(id _Nonnull )observer taskID:(XYCommonEngineTaskID)taskID block:(void (^)(XYBaseEngineTask *task))block {
    RACSignal *signal = [[XYEngineWorkspace space].dataBoard addObserver:observer forKey:[NSString stringWithFormat:@"%d",taskID]];
    [signal subscribeNext:block];
}

+ (void)removeObserver:(id _Nonnull )observer taskID:(XYCommonEngineTaskID)taskID {
    [[XYEngineWorkspace space] removeObserver:observer observerID:taskID];
}

#pragma mark - private

#pragma mark - deletage

- (void)onOperationTaskStart:(XYBaseEngineTask *_Nonnull)baseTask {
    if (![XYEngineWorkspace space].isTempWorkspace) {
        [[XYEngineWorkspace space].dataBoard setValue:baseTask forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDObserverEveryTaskStart]];
    }
}

- (void)onOperationTaskFinish:(XYBaseEngineTask *_Nonnull)baseTask {
    XYStbBackUpModel *backUpModel = [XYEngineWorkspace stordboardMgr].backUpModel;
    if (!self.isTempWorkspace && XYCommonEngineTaskIDStoryboardBackUp != baseTask.taskID && XYCommonEngineTaskIDStoryboardReset != baseTask.taskID && backUpModel.needCheckWorkspaceIsModefy && !baseTask.isInstantRefresh) {
        backUpModel.afterBackUpIsModified = [self fetchAfterBackUpIsModified:baseTask];
    }
    if ([XYEngineWorkspace space].isTempWorkspace) {
        [[XYEngineWorkspace space].dataBoard setValue:baseTask forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDObserverTempWorkspaceEveryTaskFinish]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[XYEngineWorkspace space].dataBoard setValue:baseTask forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDObserverTempWorkspaceEveryTaskFinishDispatchMain]];
            [[XYEngineWorkspace space].dataBoard setValue:baseTask forKey:[NSString stringWithFormat:@"%d",baseTask.taskID]];
        });
    } else {
        [[XYEngineWorkspace space].dataBoard setValue:baseTask forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDObserverEveryTaskFinish]];
        [[XYEngineWorkspace space].dataBoard setValue:baseTask forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDFinanceObserverEveryTaskFinish]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[XYEngineWorkspace space].dataBoard setValue:baseTask forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDObserverEveryTaskFinishDispatchMain]];
            [[XYEngineWorkspace space].dataBoard setValue:baseTask forKey:[NSString stringWithFormat:@"%d",baseTask.taskID]];

        });
    }
}

- (BOOL)fetchAfterBackUpIsModified:(XYBaseEngineTask *_Nonnull)baseTask {
    XYStbBackUpModel *backUpModel = [XYEngineWorkspace stordboardMgr].backUpModel;
    backUpModel.currentStbModel = [[self stordboardMgr] getCopyXYMeta];
    backUpModel.currentClipList = [[self clipMgr] getCopyXYMeta];
    backUpModel.currentEffectMapData = [[self effectMgr] getCopyXYMeta];
    self.pCurrentStbSession = [self.storyboard cXiaoYingStoryBoardSession];
    [self.storyboard setCXiaoYingStoryBoardSession:backUpModel.backUpXiaoYingStoryBoardSession];
    backUpModel.preBackUpStbModel = [[self stordboardMgr] getCopyXYMeta];
    backUpModel.preBackUpClipList = [[self clipMgr] getCopyXYMeta];
    backUpModel.preBackUpEffectMapData = [[self effectMgr] getCopyXYMeta];
    //恢复
    [self.storyboard setCXiaoYingStoryBoardSession:self.pCurrentStbSession];
    //storyboard
    if (![backUpModel.preBackUpStbModel xyModelIsEqual:backUpModel.currentStbModel]) {
        return YES;
    }
    //clip
    if (backUpModel.preBackUpClipList.count != backUpModel.currentClipList.count) {
        return YES;
    }
    for (int i = 0 ; i < backUpModel.preBackUpClipList.count; i ++) {
        XYClipModel *thisClipModel = backUpModel.preBackUpClipList[i];
        __block XYClipModel *thatClipModel;
        if (i < backUpModel.currentClipList.count) {//
            thatClipModel = backUpModel.currentClipList[i];
        }
        if (!thatClipModel || ![thisClipModel.identifier isEqualToString:thatClipModel.identifier]) {
            thatClipModel = nil;
            [backUpModel.currentClipList enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([thisClipModel.identifier isEqualToString:obj.identifier]) {
                    thatClipModel = obj;
                    *stop = YES;//找到对应的 model
                }
            }];
        }
        if (!thatClipModel || ![thisClipModel xyModelIsEqual:thatClipModel]) {
            return YES;
        }
    }
    //effect
    NSArray *groupKeys = backUpModel.preBackUpEffectMapData.allKeys;
    for (int i = 0 ; i < groupKeys.count ; i ++) {
        NSString *key = groupKeys[i];
        NSArray <XYEffectModel *> * thisEffects = backUpModel.preBackUpEffectMapData[key];
        NSArray <XYEffectModel *> * thatEffects = backUpModel.currentEffectMapData[key];
        if (0 == thisEffects.count && 0 == thatEffects.count) {
            continue;
        }
        if (thisEffects.count != thatEffects.count) {
            return YES;
        }
        for (int j = 0 ; j < thisEffects.count; j ++) {
            XYEffectModel *thisEffectModel = thisEffects[j];
            __block XYEffectModel *thatEffectModel;
            if (j < thatEffects.count) {
                thatEffectModel = thatEffects[j];
            }
            if (!thatEffectModel || ![thisEffectModel.identifier isEqualToString:thatEffectModel.identifier]) {
                thatEffectModel = nil;
                [thatEffects enumerateObjectsUsingBlock:^(XYEffectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([thisEffectModel.identifier isEqualToString:obj.identifier]) {
                        thatEffectModel = obj;
                        *stop = YES;//找到对应的 model
                    }
                }];
            }
            if (!thatEffectModel || ![thisEffectModel xyModelIsEqual:thatEffectModel]) {
                return YES;
            }
        }
    };
    return NO;
}

#pragma mark - lazy

- (XYCommonEngineLifeCycleService *)lifeCycleService {
    if (!_lifeCycleService) {
        _lifeCycleService = [[XYCommonEngineLifeCycleService alloc] init];
    }
    return _lifeCycleService;
}

- (XYEngineWorkspaceConfiguration *)workspaceConfigModel {
    if (!_workspaceConfigModel) {
        _workspaceConfigModel = [[XYEngineWorkspaceConfiguration alloc] init];
    }
    return _workspaceConfigModel;
}

- (XYReactBlackMapBoard *)dataBoard {
    if (!_dataBoard) {
        _dataBoard = [[XYReactBlackMapBoard alloc] init];
    }
    return _dataBoard;
}


- (XYStoryboard *)storyboard {
    if (!_storyboard) {
        _storyboard = [XYStoryboard sharedXYStoryboard];
    }
    return _storyboard;
}

- (XYClipOperationMgr *)clipMgr {
    if (!_clipMgr) {
        _clipMgr = [[XYClipOperationMgr alloc] initWithStoryboard:self.storyboard];
        _clipMgr.delegate = [XYEngineWorkspace space];
    }
    return _clipMgr;
}

- (XYEffectOperationMgr *)effectMgr {
    if (!_effectMgr) {
        _effectMgr = [[XYEffectOperationMgr alloc] initWithStoryboard:self.storyboard];
        _effectMgr.delegate = [XYEngineWorkspace space];
    }
    return _effectMgr;
}

- (XYStordboardOperationMgr *)stordboardMgr {
    if (!_stordboardMgr) {
        _stordboardMgr = [[XYStordboardOperationMgr alloc] initWithStoryboard:self.storyboard];
        _stordboardMgr.delegate = [XYEngineWorkspace space];
    }
    return _stordboardMgr;
}

- (XYQProjectOperatonMgr *)projectMgr {
    if (!_projectMgr) {
        _projectMgr = [[XYQProjectOperatonMgr alloc] initWithStoryboard:self.storyboard];
        _projectMgr.delegate = [XYEngineWorkspace space];
    }
    return _projectMgr;
}

- (XYEngineUndoMgr *)undoMgr {
    if (!_undoMgr) {
        _undoMgr = [[XYEngineUndoMgr alloc] init];
    }
    return _undoMgr;
}

- (XYProjectExportMgr *)exportMgr {
    if (!_exportMgr) {
        _exportMgr = [[XYProjectExportMgr alloc] init];
    }
    return _exportMgr;
}


#pragma -- tempWorkspace

- (XYEngineUndoMgr *)tempWorkspaceUndoMgr {
    if (!_tempWorkspaceUndoMgr) {
        _tempWorkspaceUndoMgr = [[XYEngineUndoMgr alloc] init];
    }
    return _tempWorkspaceUndoMgr;
}

- (XYStoryboard *)tempWorkspaceStoryboard {
    if (!_tempWorkspaceStoryboard) {
        _tempWorkspaceStoryboard = [[XYStoryboard alloc] init];
        [_tempWorkspaceStoryboard initXYStoryBoard];
    }
    return _tempWorkspaceStoryboard;
}

- (XYClipOperationMgr *)tempWorkspaceClipMgr {
    if (!_tempWorkspaceClipMgr) {
        _tempWorkspaceClipMgr = [[XYClipOperationMgr alloc] initWithStoryboard:self.tempWorkspaceStoryboard];
        _tempWorkspaceClipMgr.delegate = [XYEngineWorkspace space];
    }
    return _tempWorkspaceClipMgr;
}

- (XYReactBlackMapBoard *)tempWorkspaceDataBoard {
    if (!_tempWorkspaceDataBoard) {
        _tempWorkspaceDataBoard = [[XYReactBlackMapBoard alloc] init];
    }
    return _tempWorkspaceDataBoard;
}

+ (void)reloadAllData {
    [[XYEngineWorkspace space].stordboardMgr reloadData];//先刷新 clip effect 会对这里的内存数据有依赖
    [[XYEngineWorkspace space].clipMgr reloadData];
    [[XYEngineWorkspace space].effectMgr reloadData];
}

+ (void)initializeWithConfig:(XYEngineWorkspaceConfiguration *(^)(XYEngineWorkspaceConfiguration *config))configBlock {
    [XYCommonEngineGlobalData clean];
    XYEngineWorkspaceConfiguration *configModel = configBlock([XYEngineWorkspace space].workspaceConfigModel);
    [XYEngineWorkspace resetConfig:configModel];
    [self reloadAllData];
}

+ (void)updateWithConfig:(XYEngineWorkspaceConfiguration *(^)(XYEngineWorkspaceConfiguration *config))configBlock {
    XYEngineWorkspaceConfiguration *configModel = configBlock([XYEngineWorkspace space].workspaceConfigModel);
    [XYEngineWorkspace resetConfig:configModel];
}

+ (void)resetConfig:(XYEngineWorkspaceConfiguration *)configModel {
    [XYCommonEngineGlobalData data].configModel = configModel;
    [XYCommonEngineGlobalData data].playbackViewFrame = CGRectMake(0, 0, [XYEngineWorkspace currentStoryboard].playView.streamSize.width, [XYEngineWorkspace currentStoryboard].playView.streamSize.height);
}

+ (BOOL)isTempWorkspace {
    return [XYEngineWorkspace space].isTempWorkspace;
}

+ (void)switchWorkspaceWithClipModel:(XYClipModel *)clipModel block:(void (^)(BOOL succ))block {//sunshine 工程切换 线程问题处理 代码待整理
    if ([XYEngineWorkspace space].isTempWorkspace) {
        block(YES);
        return;
    }
    [XYEngineWorkspace space].backWorkspaceseekPosition = [clipModel.seekPositionNumber integerValue];
    clipModel.seekPositionNumber = nil;
    XYStoryboard *currentStoryboard = [XYEngineWorkspace currentStoryboard];
    [[XYCommonEngineTaskMgr task] postTaskHandle:^{
        [XYEngineWorkspace space].isTempWorkspace = YES;
        [[XYEngineWorkspace space].dataBoard setValue:nil forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDStoryboardWillSwitch]];
        XYStoryboard *tempStoryboard = [XYEngineWorkspace space].tempWorkspaceStoryboard;
        CXiaoYingClip *clip = [currentStoryboard duplicateClip:clipModel.clipIndex];
        MPOINT outPutResolution = {0,0};
        outPutResolution.x = [XYEngineWorkspace space].stordboardMgr.currentStbModel.outPutResolution.width;
        outPutResolution.y = [XYEngineWorkspace space].stordboardMgr.currentStbModel.outPutResolution.height;
        
        [tempStoryboard insertClip:clip Position:0];
        [tempStoryboard setClipIdentifier:clip identifier:clipModel.identifier];
        if (clipModel.isSwitchSourceRange) {
            float timeScale = [tempStoryboard getClipTimeScaleByClip:clipModel.pClip];
            [tempStoryboard setClipTrimRange:0 startPos:0 endPos:clipModel.sourceVeRange.dwLen * timeScale];
        }
        [tempStoryboard setOutputResolution:&outPutResolution];
        [[XYEngineWorkspace space].tempWorkspaceClipMgr reloadData];
//        [[XYEngineWorkspace undoMgr] reSetStoryboard:[XYEngineWorkspace currentStoryboard]];
        [[XYEngineWorkspace space].dataBoard setValue:@(0) forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDStoryboardSwitch]];
        [XYEngineWorkspace space].tempWorkspaceClipMgr.delegate = [XYEngineWorkspace space];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    }];
}


+ (void)preBackWorkSpace:(void (^)(BOOL succ))block {
    [[XYCommonEngineTaskMgr task] postTaskHandle:^{
        [XYEngineWorkspace space].isPrebackWorkspace = YES;
        [XYEngineWorkspace space].isTempWorkspace = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    }];
}

+ (void)backWorkspace:(void (^)(BOOL succ))block {//sunshine 工程切换 线程问题处理 代码待整理
    if (![XYEngineWorkspace space].isTempWorkspace && ![XYEngineWorkspace space].isPrebackWorkspace) {
        if (block) {
            block(YES);
        }
        return;
    }
    NSArray *tempClips = [XYEngineWorkspace space].tempWorkspaceClipMgr.clipModels;
    [XYEngineWorkspace space].tempWorkspaceClipMgr.delegate = nil;
    [[XYCommonEngineTaskMgr task] postTaskHandle:^{
        [XYEngineWorkspace space].isPrebackWorkspace = NO;
        [XYEngineWorkspace space].isTempWorkspace = NO;
        [XYEngineWorkspace space].tempWorkspaceClipMgr = nil;
        [XYEngineWorkspace space].tempWorkspaceDataBoard = nil;
        [XYEngineWorkspace space].tempWorkspaceUndoMgr = nil;
        XYBaseEngineTask *task = [XYBaseEngineTask new];
        task.userInfo = @{@"clips":tempClips};
        [[XYEngineWorkspace space].dataBoard setValue:task forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDStoryboardWillSwitch]];
        [[XYEngineWorkspace space].tempWorkspaceStoryboard unInitXYStoryBoard];
        [XYEngineWorkspace space].tempWorkspaceStoryboard = nil;
//        [[XYEngineWorkspace undoMgr] reSetStoryboard:[XYEngineWorkspace currentStoryboard]];
        [[XYEngineWorkspace space].dataBoard setValue:@([XYEngineWorkspace space].backWorkspaceseekPosition) forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDStoryboardSwitch]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    }];
}

- (void)addObserver:(id)observer observerID:(XYCommonEngineTaskID)observerID block:(void (^)(id obj))block {
    if (block) {
        RACSignal *signal = [[XYEngineWorkspace space].dataBoard addObserver:observer forKey:[NSString stringWithFormat:@"%d",observerID]];
        [signal subscribeNext:block];
    }
}

- (void)removeObserver:(id)observer observerID:(XYCommonEngineTaskID)observerID {
    [[XYEngineWorkspace space].dataBoard removeObserver:observer forKey:[NSString stringWithFormat:@"%d",observerID]];
}

+ (void)adjustEffect:(XYCommonEngineTaskID)taskID {
    if (![XYEngineWorkspace isTempWorkspace]) {
        [[XYEngineWorkspace effectMgr] adjustEffect:taskID];
    }
}


+ (BOOL)projectIsBelow:(NSString *)appVersion {
    BOOL isBelow = NO;
    NSString *draftProjectVersion = [[[XYEngineWorkspace space].storyboard fetchProjectVersionInfo] valueForKey:kXYCommonEngineAppVersion];
    NSString *currentVersion = appVersion;
    if (currentVersion && draftProjectVersion) {
        NSArray *list1 = [draftProjectVersion componentsSeparatedByString:@"."];
        NSArray *list2 = [currentVersion componentsSeparatedByString:@"."];
        for (int i = 0; i < list1.count || i < list2.count; i++)
        {
            NSInteger a = 0, b = 0;
            if (i < list1.count) {
                a = [list1[i] integerValue];
            }
            if (i < list2.count) {
                b = [list2[i] integerValue];
            }
            if (a < b) {
                isBelow = YES;
                break;
            }
        }
    }
    return isBelow;
}

+ (CGFloat)outPutResolutionWidth {
    return [XYCommonEngineGlobalData data].configModel.outPutResolutionWidth;
}

+ (void)cleanAllData {
    [[XYEngineWorkspace clipMgr] cleanData];
    [[XYEngineWorkspace effectMgr] cleanData];
    [[XYEngineWorkspace stordboardMgr] cleanData];
}

@end
