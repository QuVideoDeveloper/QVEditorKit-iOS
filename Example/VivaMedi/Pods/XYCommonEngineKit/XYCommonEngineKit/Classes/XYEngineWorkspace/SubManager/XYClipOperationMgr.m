//
//  XYClipOperationMgr.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import "XYClipOperationMgr.h"
#import "XYClipModel.h"
#import "XYStoryboard+XYClip.h"
#import "XYCommonEngineTaskMgr.h"
#import "XYOperationMgrBase_Private.h"
#import "XYClipTaskFactory.h"
#import "XYClipTaskAdd.h"
#import "XYEngineEnum.h"
#import "XYStoryboard+XYThumbnail.h"
#import "XYEngineWorkspace.h"
#import "XYEffectVisionTextModel.h"
#import "XYAdjustEffectValueModel.h"
#import "XYStordboardOperationMgr.h"
#import "XYStoryboardModel.h"

#define XY_ENGINE_MIN_TRANS_TIME 0 //clip小于这个时间 删除转场

@interface XYClipOperationMgr()<XYBaseEngineTaskDelegate>

@property (nonatomic, copy) NSArray <XYClipModel *> *clipList;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation XYClipOperationMgr



#pragma mark -- Public Method

- (XYEffectModel *)fetchEffectModelOnTopByTouchPoint:(CGPoint)touchPoint seekPosition:(NSInteger)seekPosition {
    XYClipModel *lastModel;
    NSInteger clipIdx = [self.storyboard getClipIndexByTime:seekPosition];
    [self.lock lock];
    if (clipIdx < self.clipList.count) {
        lastModel = [self.clipList objectAtIndex:clipIdx];
    } else {
        lastModel = self.clipList.lastObject;
    }
    [self.lock unlock];
    lastModel.fatchWhenTaskisExcusing = [XYCommonEngineTaskMgr task].isExcusing;
    if (XYCommonEngineClipModuleCustomCoverBack == lastModel.clipType) {
        XYEffectVisionTextModel *textModel = lastModel.clipEffectModel.backCoverVisionModels.lastObject;
        CGPoint centerPoint = textModel.centerPoint;
        CGFloat width = textModel.width;
        CGFloat height = textModel.height;
        CGRect textRext = CGRectMake(centerPoint.x - width / 2.0, centerPoint.y - height / 2.0, width, height);
        if (CGRectContainsPoint(textRext, touchPoint)) {
            return textModel;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
    return nil;
}

- (XYClipModel *)fetchClipModelWithIdentifier:(NSString *)identifier {
    [self.lock lock];
    __block XYClipModel *clipModel;
    [self.clipList enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.identifier && identifier && [obj.identifier isEqualToString:identifier]) {
            clipModel = obj;
            *stop = YES;
        }
    }];
    [self.lock unlock];
    clipModel.fatchWhenTaskisExcusing = [XYCommonEngineTaskMgr task].isExcusing;
    return clipModel;
}

- (XYClipModel *)fetchClipModelObjectAtIndex:(NSUInteger)idx {
    XYClipModel *clipModel;
    [self.lock lock];
    if (idx < self.clipList.count) {
        clipModel = [self.clipList objectAtIndex:idx];
    }
    [self.lock unlock];
    clipModel.fatchWhenTaskisExcusing = [XYCommonEngineTaskMgr task].isExcusing;
    return clipModel;
}

- (NSInteger)fetchClipModelIdxWithIdentifier:(NSString *)identifier {
    __block NSInteger clipModelIdx = -1;
    [self.lock lock];
    NSMutableArray *bridgeMArr = [NSMutableArray array];
    [self.clipList enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([identifier isEqualToString:obj.identifier]) {
            clipModelIdx = idx;
            *stop = YES;
        }
    }];
    [self.lock unlock];
    return clipModelIdx;
}

//- (NSArray *)fetchClipModelWithPosition:(NSInteger)position {
//    [self.lock lock];
//    __block XYClipModel *clipModel;
//    [self.clipList enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (position >= obj.destVeRange.dwPos &&
//            position < obj.destVeRange.dwPos + obj.destVeRange.dwLen) {
//            clipModel = obj;
//            *stop = YES;
//            return ;
//        }
//    }];
//    [self.lock unlock];
//    clipModel.fatchWhenTaskisExcusing = [XYCommonEngineTaskMgr task].isExcusing;
//    return clipModel;
//}


- (void)removeClipModelWithIdentifier:(NSString *)identifier {
    [self.lock lock];
    __block XYClipModel *clipModel;
    NSMutableArray *bridgeMArr = [NSMutableArray array];
    [self.clipList enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.identifier isEqualToString:identifier]) {
            [bridgeMArr addObject:obj];
        }
    }];
    self.clipList = bridgeMArr;
    [self.lock unlock];
}

- (id)getCopyXYMeta {
   return [self loadClipModels];
}

- (NSArray <XYClipModel *> *)clipModels {
    NSArray *clips;
    [self.lock lock];
    if (self.clipList) {
        clips = [NSArray arrayWithArray:self.clipList];
    }
    [self.lock unlock];
    return clips;
}

- (void)runTask:(XYClipModel *)clipModel {
    if (clipModel) {
        [self runTaskToMore:@[clipModel]];
    }
}

- (void)runTaskToMore:(NSArray <XYClipModel *> *)clipModels {
    XYClipModel *clipModel = clipModels.firstObject;
    [XYEngineWorkspace space].undoActionState = clipModel.undoActionState;
    if (clipModel) {
        if (XYEngineUndoActionStateSetPreAdd != clipModel.undoActionState) {
            XYEngineUndoActionState undoActionState = clipModel.undoActionState;
            [self addUndo:clipModel];//这里会重置掉undoActionState
            __block XYCommonEngineTaskID taskID = clipModel.taskID;
            if (XYCommonEngineTaskNone == taskID) {
                [clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (XYCommonEngineTaskNone != obj.taskID) {
                        taskID = obj.taskID;
                        *stop = YES;
                    }
                }];
            }
            XYBaseClipTask *clipTask = [XYClipTaskFactory factoryWithType:taskID];
            clipTask.userInfo = clipModel.userInfo;
            clipTask.undoAntionState = undoActionState;
            clipTask.globalStoryboard = [XYStoryboard sharedXYStoryboard];
            clipTask.taskID = taskID;
            clipTask.storyboard = self.storyboard;
            clipTask.clipModels = clipModels;
            clipTask.delegate = self;
            [[XYCommonEngineTaskMgr task] postTask:clipTask preprocessBlock:^{
                [clipTask.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.fatchWhenTaskisExcusing) {
                        obj.fatchWhenTaskisExcusing = NO;
                        obj.pClip = [self fetchClipModelWithIdentifier:obj.identifier].pClip;
                    }
                }];
                if ([self.delegate respondsToSelector:@selector(onOperationTaskStart:)]) {
                    [self.delegate onOperationTaskStart:clipTask];
                }
            }];
        } else {
            [self addUndo:clipModels.firstObject];
        }
    }
}


#pragma mark -- delegate

- (void)onEngineFinish:(XYBaseEngineTask *)baseTask {
    [XYEngineWorkspace stordboardMgr].currentStbModel.videoDuration = [self.storyboard getDuration];
    if (baseTask.isReload) {
        XYBaseClipTask *clipTask = baseTask;
        [self reloadDataIsNeedCheckTrans:baseTask.isNeedCheckTrans];
        if (clipTask.isNeedSetAdjustEffectValue) {
            [clipTask.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XYClipModel *idtObj = [self fetchClipModelWithIdentifier:obj.identifier];
                idtObj.adjustEffectValueModel = obj.adjustEffectValueModel;
                obj.adjustEffectValueModel = nil;
            }];
        }
        if (baseTask.adjustEffect) {
//            [XYEngineWorkspace adjustEffect:baseTask.taskID];
        }
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


- (NSMutableArray <XYClipModel *> *)loadClipModels {
    NSMutableArray *clipModels = [NSMutableArray array];
    CXiaoYingCover *cCoverFrontModel = [self.storyboard getCover:AMVE_PROP_STORYBOARD_THEME_COVER];
    CXiaoYingCover *cCoverBackModel = [self.storyboard getCover:AMVE_PROP_STORYBOARD_THEME_BACK_COVER];
    
    NSInteger clipCount = [self.storyboard getClipCount];
    
    if (cCoverFrontModel) {
        XYEngineConfigModel *config = [[XYEngineConfigModel alloc] init];
        config.clipType = XYCommonEngineClipModuleThemeCoverFront;
        config.idx = -1;
        config.storyboard = self.storyboard;
        XYClipModel *model = [[XYClipModel alloc] init:config];
        [model reload];
        [clipModels addObject:model];
    }
    for (int i = 0; i < clipCount; i ++) {
        XYClipModel *clipModel = [self getClipModelByIndex:i];
        if (clipModel) {
            [clipModels addObject:clipModel];
        }
    }
    
    if (cCoverBackModel) {
        XYEngineConfigModel *config = [[XYEngineConfigModel alloc] init];
        config.clipType = XYCommonEngineClipModuleThemeCoverBack;
        config.idx = clipCount + (cCoverBackModel ? 1 : 0);
        config.storyboard = self.storyboard;
        XYClipModel *model = [[XYClipModel alloc] init:config];
        [model reload];
        [clipModels addObject:model];
    }
    __block NSInteger nextDestStartPos = 0;
    __block NSInteger preTransLen = 0;
    __block NSInteger videoDuration = 0;
    [clipModels enumerateObjectsUsingBlock:^(XYClipModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.objIndex = idx;
        AMVE_POSITION_RANGE_TYPE range = [self.storyboard getClipTimeRange:idx];
        XYVeRangeModel *rangeModel = [XYVeRangeModel VeRangeModelWithPosition:range.dwPos length:range.dwLen];
        obj.destVeRange = rangeModel;
        XYVeRangeModel *destVeRange;
        if (idx < clipModels.count - 1) {
            AMVE_POSITION_RANGE_TYPE nextRange = [self.storyboard getClipTimeRange:idx + 1];
            XYVeRangeModel *nextRangeModel = [XYVeRangeModel VeRangeModelWithPosition:nextRange.dwPos length:nextRange.dwLen];

            AMVE_POSITION_RANGE_TYPE transRange = [self.storyboard getClipTransitionTimeRange:idx];
            NSInteger transLen = rangeModel.dwPos + rangeModel.dwLen - nextRangeModel.dwPos;//引擎这边返回的转场可能不是重叠的 也有是加在两个clip之间
            destVeRange = [XYVeRangeModel VeRangeModelWithPosition:nextDestStartPos length:rangeModel.dwLen - transLen / 2.0 - preTransLen / 2.0];
            nextDestStartPos = destVeRange.dwPos + destVeRange.dwLen;
            obj.frontTransTime = preTransLen / 2.0;
            obj.backTransTime = transLen / 2.0;
            preTransLen = transLen;
            obj.fixTime = transLen / 2.0;
            obj.clipEffectModel.transDestRange = [XYVeRangeModel VeRangeModelWithPosition:transRange.dwPos length:transRange.dwLen];
        } else {
            obj.frontTransTime = preTransLen / 2.0;
            obj.backTransTime = 0;
            obj.fixTime = preTransLen / 2.0;
            destVeRange = [XYVeRangeModel VeRangeModelWithPosition:nextDestStartPos length:rangeModel.dwLen - preTransLen / 2.0];
        }
        nextDestStartPos = destVeRange.dwPos + destVeRange.dwLen;
        videoDuration = videoDuration + destVeRange.dwLen;
    }];
//    self.clipsTotalDuration = videoDuration;
    return clipModels;
}

- (XYClipModel *)getClipModelByIndex:(NSInteger)clipIdx {
    XYEngineConfigModel *config = [[XYEngineConfigModel alloc] init];
    config.storyboard = self.storyboard;
    config.idx = clipIdx;
    XYClipModel *model = [[XYClipModel alloc] init:config];
    [model reload];
    return model;
}


- (void)reloadData {
    [self reloadDataIsNeedCheckTrans:YES];
}

- (void)reloadDataIsNeedCheckTrans:(BOOL)isNeedCheckTrans {
    [self.lock lock];
    self.clipList = [NSArray arrayWithArray:[self loadClipModels]];
    [self.lock unlock];
}

- (NSInteger )fetchClipCount {
    NSInteger count;
    [self.lock lock];
    count = self.clipList.count;
    [self.lock unlock];
    return count;
}


#pragma mark - lazy

- (NSRecursiveLock *)lock {
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

//- (void)handleTransitionsCheck:(XYClipModel *)obj isLastOne:(BOOL)isLastOne isNeedCheckTrans:(BOOL)isNeedCheckTrans {
//    if (isNeedCheckTrans) {
//        BOOL deleteTrans = NO;
//        if (isLastOne) {
//            deleteTrans = YES;
//        } else {
//            NSInteger transMinTime = XY_ENGINE_MIN_TRANS_TIME;
//            if (obj.clipEffectModel.effectTransFilePath && ![obj.clipEffectModel.effectTransFilePath isEqualToString:[XYCommonEngineGlobalData data].configModel.effectDefaultTransFilePath] && obj.trimVeRange.dwLen < transMinTime) {
//                deleteTrans = YES;
//            }
//        }
//        if (deleteTrans) {
//            [self.storyboard setClipTransition:[XYCommonEngineGlobalData data].configModel.effectDefaultTransFilePath configureIndex:obj.clipEffectModel.effectConfigIndex == 0 ? 0 : rand() % obj.clipEffectModel.effectConfigIndex pClip:obj.pClip];
//            obj.clipEffectModel.effectTransFilePath = [XYCommonEngineGlobalData data].configModel.effectDefaultTransFilePath;
//        }
//    }
//}

- (void)cleanData {
    self.clipList = nil;
}

//- (void)preprocessCheck:(XYCommonEngineTaskID)taskID clipModels:(NSArray <XYClipModel *> *)clipModels {
//    if (XYCommonEngineTaskIDClipDelete == taskID) {
//        [clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [self removeClipModelWithIdentifier:obj.identifier];
//        }];
//        __block NSInteger nextPos = 0;
//        [self.lock lock];
//        [self.clipList enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            obj.destVeRange.dwPos = nextPos;
//            nextPos = nextPos + obj.destVeRange.dwPos + obj.destVeRange.dwLen;
//        }];
//        [self.lock unlock];
//    }
//}


@end
