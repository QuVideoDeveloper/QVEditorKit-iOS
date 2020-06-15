//
//  XYEffectOperationMgr.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import "XYEffectOperationMgr.h"
#import "XYOperationMgrBase_Private.h"
#import "XYBaseEffectTask.h"
#import "XYEffectTaskFactory.h"
#import "XYEffectModel.h"
#import "XYEffectVisionModel.h"
#import "XYEffectVisionTextModel.h"
#import "XYCommonEngineTaskMgr.h"
#import "XYEffectAudioModel.h"
#import "XYEffectRelativeClipInfo.h"
#import "XYEngineWorkspace.h"
#import "XYClipOperationMgr.h"
#import "XYClipModel.h"
#import "XYStordboardOperationMgr.h"
#import "XYStoryboardModel.h"


@interface XYEffectOperationMgr ()<XYBaseEngineTaskDelegate>

@property (nonatomic, strong) NSMutableDictionary *effectMapData;

@property (nonatomic, strong) NSRecursiveLock *lock;

@property (nonatomic, strong) NSMutableArray *everyCellMaxLayerIdList;

@end

@implementation XYEffectOperationMgr


- (void)runTask:(XYEffectModel *)effectModel {
    [XYEngineWorkspace space].undoActionState = effectModel.undoActionState;
    if ([effectModel isKindOfClass:[XYEffectVisionModel class]]) {
        XYEffectVisionModel *effectVisionModel = effectModel;
        BOOL isPIPStickerMosaic = effectVisionModel.groupID == XYCommonEngineGroupIDCollage
        ||effectVisionModel.groupID == XYCommonEngineGroupIDSticker
        ||effectVisionModel.groupID == XYCommonEngineGroupIDMosaic;
        
        if (effectVisionModel.isInstantRefresh && isPIPStickerMosaic) {
            //马赛克，画中画或贴纸effect做一下copy防止这个model在引擎task执行之前，就在主线程被下一次操作修改
            effectModel = [effectModel xyModelCopy];
        }
    }
    effectModel.everyCellMaxLayerIdList = self.everyCellMaxLayerIdList;
    if (XYEngineUndoActionStateSetPreAdd != effectModel.undoActionState) {
        XYEngineUndoActionState undoActionState = effectModel.undoActionState;
        [self addUndo:effectModel];//这里会重置掉undoActionState
        XYBaseEffectTask *effectTask = [XYEffectTaskFactory factoryWithType:effectModel.taskID];
        effectTask.undoAntionState = undoActionState;
        effectTask.groupID = effectModel.groupID;
        effectTask.taskID = effectModel.taskID;
        effectTask.storyboard = self.storyboard;
        effectTask.delegate = self;
        effectTask.effectModel = effectModel;
        [[XYCommonEngineTaskMgr task] postTask:effectTask preprocessBlock:^{
            if (effectModel.fatchWhenTaskisExcusing) {
                effectModel.fatchWhenTaskisExcusing = NO;
                effectTask.effectModel.pEffect = [self fetchEffectModel:effectModel.identifier].pEffect;
            }
            if ([self.delegate respondsToSelector:@selector(onOperationTaskStart:)]) {
                [self.delegate onOperationTaskStart:effectTask];
            }
        }];
    } else {
        [self addUndo:effectModel];
    }
    effectModel.undoActionState = XYEngineUndoActionStateNone;
}

- (void)runTaskToMore:(NSArray <XYEffectModel *> *)effectModels {
    XYEffectModel *effectModel = [effectModels firstObject];
    [XYEngineWorkspace space].undoActionState = effectModel.undoActionState;
    [effectModels enumerateObjectsUsingBlock:^(XYEffectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.everyCellMaxLayerIdList = self.everyCellMaxLayerIdList;
    }];
    if (XYEngineUndoActionStateSetPreAdd != effectModel.undoActionState) {
        [self addUndo:effectModel];
        XYBaseEffectTask *effectTask = [XYEffectTaskFactory factoryWithType:effectModel.taskID];
        effectTask.userInfo = effectModel.userInfo;
        effectTask.effectModels = effectModels;
        effectTask.groupID = effectModel.groupID;
        effectTask.taskID = effectModel.taskID;
        effectTask.storyboard = self.storyboard;
        effectTask.delegate = self;
        effectTask.effectModel = effectModel;
        [[XYCommonEngineTaskMgr task] postTask:effectTask preprocessBlock:^{
            if ([self.delegate respondsToSelector:@selector(onOperationTaskStart:)]) {
                [effectModels enumerateObjectsUsingBlock:^(XYEffectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.fatchWhenTaskisExcusing) {
                        obj.pEffect = [self fetchEffectModel:obj.identifier].pEffect;
                        obj.fatchWhenTaskisExcusing = NO;
                    }
                }];
                [self.delegate onOperationTaskStart:effectTask];
            }
        }];
    } else {
        [self addUndo:effectModel];
    }
}

#pragma mark -- delegate

- (void)onEngineFinish:(XYBaseEngineTask *)baseTask {
    [XYEngineWorkspace stordboardMgr].currentStbModel.videoDuration = [self.storyboard getDuration];
    XYBaseEffectTask *effectTask = baseTask;
    if (effectTask.isReload) {
        [self reloadDataWithTrackType:effectTask.trackType groupId:effectTask.groupID];
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


- (NSArray *)loadEffectModelsWithTrackType:(XYCommonEngineTrackType)trackType groupId:(XYCommonEngineGroupID)groupId reloadCellMaxLayerID:(BOOL)reloadCellMaxLayerID {
    NSMutableArray <XYEffectModel *> *effectModels = [NSMutableArray array];
    int count = [self.storyboard getEffectCount:trackType groupId:groupId];
    for (int i = 0; i<count; i++) {
        XYEffectModel *effectModel;
        if (XYCommonEngineTrackTypeAudio == trackType) {
            XYEngineConfigModel *config = [[XYEngineConfigModel alloc] init];
            config.storyboard = self.storyboard;
            config.idx = i;
            config.trackType = trackType;
            config.groupID = groupId;
            effectModel = [[XYEffectAudioModel alloc] init:config];
        } else if (XYCommonEngineTrackTypeVideo == trackType) {
            XYEngineConfigModel *config = [[XYEngineConfigModel alloc] init];
            config.storyboard = self.storyboard;
            config.idx = i;
            config.trackType = trackType;
            config.groupID = groupId;
            if (groupId == XYCommonEngineGroupIDText) {
                effectModel = [[XYEffectVisionTextModel alloc] init:config];
            } else {
                effectModel = [[XYEffectVisionModel alloc] init:config];
            }
            
        }
        if (!effectModel.isInvalid) {
            [effectModel reload];
            if (XYCommonEngineTrackTypeAudio != trackType && reloadCellMaxLayerID) {
                [self reloadEveryCellMaxLayer:effectModel];
            }
            [effectModels addObject:effectModel];
        }
    }
    return effectModels;
}

- (void)reloadData {
    [self.lock lock];
    [self.everyCellMaxLayerIdList removeAllObjects];
    self.effectMapData = [self getAllEffectMapData:YES];
    [self.lock unlock];
}


- (void)reloadDataWithTrackType:(XYCommonEngineTrackType)trackType groupId:(XYCommonEngineGroupID)groupId {
    [self.lock lock];
    NSArray *models = [self loadEffectModelsWithTrackType:trackType groupId:groupId reloadCellMaxLayerID:YES];
    if (XYCommonEngineGroupIDBgmMusic == groupId) {
        [self.effectMapData setValue:models forKey:[self effectKeyTrackType:XYCommonEngineTrackTypeAudio groupId:XYCommonEngineGroupIDBgmMusic]];
    } else if (XYCommonEngineGroupIDRecord == groupId) {
        [self.effectMapData setValue:models forKey:[self effectKeyTrackType:XYCommonEngineTrackTypeAudio groupId:XYCommonEngineGroupIDRecord]];
    } else if (XYCommonEngineGroupIDDubbing == groupId) {
        [self.effectMapData setValue:models forKey:[self effectKeyTrackType:XYCommonEngineTrackTypeAudio groupId:XYCommonEngineGroupIDDubbing]];
    } else if (XYCommonEngineGroupIDSticker == groupId
               ||XYCommonEngineGroupIDWatermark == groupId
               ||XYCommonEngineGroupIDMosaic == groupId
               ||XYCommonEngineGroupIDCollage == groupId
               ||XYCommonEngineGroupIDText == groupId
               ||XYCommonEngineGroupIDAnimatedFrame == groupId) {
        [self.effectMapData setValue:models forKey:[self effectKeyTrackType:XYCommonEngineTrackTypeVideo groupId:groupId]];
    }
    [self.lock unlock];
}

- (NSMutableDictionary *)getAllEffectMapData:(BOOL)reloadCellMaxLayerID {
    NSMutableDictionary *effectMapData = [NSMutableDictionary dictionary];
    NSMutableArray *opList = [NSMutableArray array];
    __block NSString *trackTypeKey = @"trackType";
    __block NSString *groupIDKey = @"groupID";
    //Audio Effect
    //Bgm
    [opList addObject:@{trackTypeKey : @(XYCommonEngineTrackTypeAudio),
                              groupIDKey : @(XYCommonEngineGroupIDBgmMusic)}];
    //Record
    [opList addObject:@{trackTypeKey : @(XYCommonEngineTrackTypeAudio),
                                 groupIDKey : @(XYCommonEngineGroupIDRecord)}];
    //Dubbing
    [opList addObject:@{trackTypeKey : @(XYCommonEngineTrackTypeAudio),
                                 groupIDKey : @(XYCommonEngineGroupIDDubbing)}];
    
    //Vision Effect
    //Text
    [opList addObject:@{trackTypeKey : @(XYCommonEngineTrackTypeVideo),
                                 groupIDKey : @(XYCommonEngineGroupIDText)}];
    //Sticker
    [opList addObject:@{trackTypeKey : @(XYCommonEngineTrackTypeVideo),
                                 groupIDKey : @(XYCommonEngineGroupIDSticker)}];
    //Mosaic
    [opList addObject:@{trackTypeKey : @(XYCommonEngineTrackTypeVideo),
                                 groupIDKey : @(XYCommonEngineGroupIDMosaic)}];
    
    //AnimatedFrame
    [opList addObject:@{trackTypeKey : @(XYCommonEngineTrackTypeVideo),
                                 groupIDKey : @(XYCommonEngineGroupIDAnimatedFrame)}];
    
    //Collage
    [opList addObject:@{trackTypeKey : @(XYCommonEngineTrackTypeVideo),
                                   groupIDKey : @(XYCommonEngineGroupIDCollage)}];
    
    //Watermark
    [opList addObject:@{trackTypeKey : @(XYCommonEngineTrackTypeVideo),
                                   groupIDKey : @(XYCommonEngineGroupIDWatermark)}];
    
    [opList enumerateObjectsUsingBlock:^(NSDictionary *objDic, NSUInteger idx, BOOL * _Nonnull stop) {
        XYCommonEngineTrackType trackType = [objDic[trackTypeKey] integerValue];
        XYCommonEngineGroupID groupID = [objDic[groupIDKey] integerValue];
        NSArray *modelList = [self loadEffectModelsWithTrackType:trackType groupId:groupID reloadCellMaxLayerID:reloadCellMaxLayerID];
        [effectMapData setValue:modelList forKey:[self effectKeyTrackType:trackType groupId:groupID]];
        
    }];
    return effectMapData;
}

- (NSArray <XYEffectModel *> *)effectModels:(XYCommonEngineGroupID)groupType {
    NSArray *models;
    [self.lock lock];
    if (XYCommonEngineGroupIDBgmMusic == groupType) {
        models = [self.effectMapData valueForKey:[self effectKeyTrackType:XYCommonEngineTrackTypeAudio groupId:XYCommonEngineGroupIDBgmMusic]];
    } else if (XYCommonEngineGroupIDRecord == groupType) {
        models = [self.effectMapData valueForKey:[self effectKeyTrackType:XYCommonEngineTrackTypeAudio groupId:XYCommonEngineGroupIDRecord]];
    } else if (XYCommonEngineGroupIDDubbing == groupType) {
        models = [self.effectMapData valueForKey:[self effectKeyTrackType:XYCommonEngineTrackTypeAudio groupId:XYCommonEngineGroupIDDubbing]];
    } else if (XYCommonEngineGroupIDSticker == groupType
               ||XYCommonEngineGroupIDWatermark == groupType
               ||XYCommonEngineGroupIDMosaic == groupType
               ||XYCommonEngineGroupIDCollage == groupType
               ||XYCommonEngineGroupIDText == groupType
               ||XYCommonEngineGroupIDAnimatedFrame == groupType) {
        models = [self.effectMapData valueForKey:[self effectKeyTrackType:XYCommonEngineTrackTypeVideo groupId:groupType]];
    }
    [self.lock unlock];
    return [NSArray arrayWithArray:models];
}

#pragma mark - public

 - (NSArray<XYEffectModel *> *)allEffects {
    NSMutableArray *effects = [NSMutableArray array];
    [self.lock lock];
    [self.effectMapData.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [effects addObject:obj];
    }];
    [self.lock unlock];
    return effects;
}

- (id)getCopyXYMeta {
   return [self getAllEffectMapData:NO];
}

#pragma mark - 效果重新计算
- (void)adjustEffect:(XYCommonEngineTaskID)taskID {
    [self.lock lock];
    //audio adjust
    NSArray *audioGroupIds = @[@(XYCommonEngineGroupIDBgmMusic),
                                @(XYCommonEngineGroupIDRecord),
                                @(XYCommonEngineGroupIDDubbing)];
    [audioGroupIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *audioEffectList = [self.effectMapData valueForKey:[self effectKeyTrackType:XYCommonEngineTrackTypeAudio groupId:[obj integerValue]]];
        [self adjustEffectEveryCellList:[self sortedArray:audioEffectList taskID:taskID] taskID:taskID];
    }];
    // vision adjust
    __block NSMutableDictionary *visionLayerGroupDic = [NSMutableDictionary dictionary];//根据layerGroupID 分类
    NSMutableArray <XYEffectModel *> *visionList = [NSMutableArray array];
    NSArray *visionGroupIds = @[@(XYCommonEngineGroupIDText),
                                @(XYCommonEngineGroupIDMosaic),
                                @(XYCommonEngineGroupIDSticker),
                                @(XYCommonEngineGroupIDCollage),
                                @(XYCommonEngineGroupIDAnimatedFrame)];
    [visionGroupIds enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [visionList addObjectsFromArray:[self.effectMapData valueForKey:[self effectKeyTrackType:XYCommonEngineTrackTypeVideo groupId:[obj integerValue]]]];
    }];
    [visionList enumerateObjectsUsingBlock:^(XYEffectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *everyCellKey = [NSString stringWithFormat:@"%d",[obj fetchLayerIdCellIndex]];
        NSMutableArray *everyCellList = [visionLayerGroupDic valueForKey:everyCellKey];//有没有这层的数据
        if (everyCellList) {//有往这层加
            [everyCellList addObject:obj];
            [visionLayerGroupDic setValue:everyCellList forKey:everyCellKey];
        } else {//没有 新建一层数据 加入字典
            NSMutableArray *newCellList = [NSMutableArray array];
            [newCellList addObject:obj];
            [visionLayerGroupDic setValue:newCellList forKey:everyCellKey];
        }
    }];
    [[visionLayerGroupDic allValues] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self adjustEffectEveryCellList:[self sortedArray:obj taskID:taskID] taskID:taskID];
    }];
    [self.lock unlock];
    //需要重新刷下内存 因为有效果可能被删除了 所以对应的引擎index 都会变掉
    [self reloadData];
}

- (void)fetchKeyFrameModel:(NSString *)identifier seekPosition:(NSInteger)seekPosition block:(void (^)(XYEffectVisionKeyFrameModel *keyFramModel))block {
    [[XYCommonEngineTaskMgr task] postTaskHandle:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([self fetchKeyFrameModel:identifier seekPosition:seekPosition]);
            }
        });
    }];
}

- (void)fetchKeyFrameModelWithEffectModel:(XYEffectModel *)effectModel seekPosition:(NSInteger)seekPosition block:(void (^)(XYEffectVisionKeyFrameModel *keyFramModel))block {
    NSString *identifier = effectModel.identifier;
    [[XYCommonEngineTaskMgr task] postTaskHandle:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block([self fetchKeyFrameModel:identifier seekPosition:seekPosition]);
            }
        });
    }];
}

- (XYEffectVisionKeyFrameModel *)fetchKeyFrameModel:(NSString *)identifier seekPosition:(NSInteger)seekPosition {
    XYEffectVisionKeyFrameModel *keyFramModel;
    XYEffectVisionModel *currentEffectModel = [self fetchEffectModel:identifier];
    if (currentEffectModel && currentEffectModel.keyFrames.count > 0) {
        CXiaoYingEffect *pEffect = currentEffectModel.pEffect;
        if (pEffect) {
            CXiaoYingKeyFrameTransformValue* value = [self.storyboard getEffectKeyFrameTransformValue:currentEffectModel.pEffect timeStamp:seekPosition];
            if (value) {
                keyFramModel = [[XYEffectVisionKeyFrameModel alloc] init];
                CGSize preSize = [XYCommonEngineGlobalData data].playbackViewFrame.size;
                MLong baseWidth = [self.storyboard geteEffectKeyframeBaseWidthWithEffect:pEffect];
                MLong baseHeight = [self.storyboard geteEffectKeyframeBaseHeightWithEffect:pEffect];
                keyFramModel.position = value->ts + currentEffectModel.destVeRange.dwPos;
                keyFramModel.rotation = value->rotation;
                keyFramModel.width = (value->widthRatio * baseWidth / 10000.0f) * preSize.width;
                keyFramModel.height = (value->heightRatio * baseHeight / 10000.0f) * preSize.height;
                keyFramModel.centerPoint = CGPointMake((value->position.x / 10000.0f) * preSize.width, (value->position.y / 10000.0f) * preSize.height);
            }
        }
    }
    return keyFramModel;
}

- (XYEffectModel *)fetchEffectModel:(NSString *)identifier {
    [self.lock lock];
    __block XYEffectModel *identifierModel;
    [self.effectMapData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray *models = obj;
        [models enumerateObjectsUsingBlock:^(XYEffectModel *effectModel, NSUInteger idx, BOOL * _Nonnull _stop) {
            if (identifier && effectModel.identifier && [identifier isEqualToString:effectModel.identifier]) {
                identifierModel = effectModel;
                *_stop = YES;
            }
        }];
        if (identifierModel) {
            *stop = YES;
        }
    }];
    [self.lock unlock];
    return identifierModel;
}

- (NSArray <XYEffectModel *> *)fetchEffectModel:(XYCommonEngineGroupID)groupType filePath:(NSString *)filePath {
    __block NSMutableArray *idtArr = [NSMutableArray array];
    NSArray <XYEffectModel *> * models = [self effectModels:groupType];
    [self.lock lock];
    [models enumerateObjectsUsingBlock:^(XYEffectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.filePath && filePath && [obj.filePath isEqualToString:filePath]) {
            [idtArr addObject:obj];
        }
    }];
    [self.lock unlock];
    return idtArr;
}


- (XYEffectModel *)fetchEffectModel:(XYCommonEngineGroupID)groupType identifier:(NSString *)identifier {
    NSArray <XYEffectModel *> * models = [self effectModels:groupType];
    __block XYEffectModel *idtMapModel;
    [self.lock lock];
    [models enumerateObjectsUsingBlock:^(XYEffectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.identifier && identifier && [obj.identifier isEqualToString:identifier]) {
            idtMapModel = obj;
            *stop = YES;
        }
    }];
    
    [self.lock unlock];
    idtMapModel.fatchWhenTaskisExcusing = [XYCommonEngineTaskMgr task].isExcusing;
    return idtMapModel;
}

- (XYEffectModel *)fetchEffectModelOnTopByTouchPoint:(CGPoint)touchPoint seekPosition:(NSInteger)seekPosition {
    CGFloat width = [XYCommonEngineGlobalData data].playbackViewFrame.size.width;
    CGFloat height = [XYCommonEngineGlobalData data].playbackViewFrame.size.height;
    MPOINT mpt = {(MLong)(touchPoint.x*10000/width),(MLong)(touchPoint.y*10000/height)};
    
    NSArray *groupIds = @[@(XYCommonEngineGroupIDText),
                          @(XYCommonEngineGroupIDMosaic),
                          @(XYCommonEngineGroupIDSticker),
                          @(XYCommonEngineGroupIDCollage),
                          @(XYCommonEngineGroupIDWatermark)];
    
    CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectOnTopByTime:seekPosition touchPoint:mpt];
    if (!effect) {
        return nil;
    }
        
    NSString *identifier = [self.storyboard getEffectIdentifier:effect];
    NSInteger groupId = [self.storyboard getEffectGroupId:effect];
    XYEffectModel *effectModel = [self fetchEffectModel:groupId identifier:identifier];
    effectModel.fatchWhenTaskisExcusing = [XYCommonEngineTaskMgr task].isExcusing;
    return effectModel;
}

#pragma mark - lazy

- (NSRecursiveLock *)lock {
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

- (NSMutableDictionary *)effectMapData {
    if (!_effectMapData) {
        _effectMapData = [NSMutableDictionary dictionary];
    }
    return _effectMapData;
}

- (NSMutableArray *)everyCellMaxLayerIdList {
    if (!_everyCellMaxLayerIdList) {
        _everyCellMaxLayerIdList = [NSMutableArray array];
    }
    return _everyCellMaxLayerIdList;
}

#pragma mark - private

- (NSString *)effectKeyTrackType:(XYCommonEngineTrackType)trackType groupId:(XYCommonEngineGroupID)groupId {
    return [NSString stringWithFormat:@"%d%d",trackType,groupId];
}

- (void)reloadEveryCellMaxLayer:(XYEffectModel *)effectModel {
    if (effectModel.layerID == LAYER_ID_NEW_WATERMARK) {
        return;
    }
    if (self.everyCellMaxLayerIdList.count <= 0) {
        NSInteger cellIndex = [effectModel fetchLayerIdCellIndex];
        effectModel.horizontalPosition = cellIndex + 2;
        if (cellIndex < self.everyCellMaxLayerIdList.count) {
            float cellMaxLayerID = [self.everyCellMaxLayerIdList[cellIndex] floatValue];
            if (effectModel.layerID > cellMaxLayerID) {
                [self.everyCellMaxLayerIdList replaceObjectAtIndex:cellIndex withObject:@(effectModel.layerID)];
            }
        } else {
            [self.everyCellMaxLayerIdList addObject:@(effectModel.layerID)];
        }
        effectModel.everyCellMaxLayerIdList = self.everyCellMaxLayerIdList;
    }
}

- (NSArray *)sortedArray:(NSArray <XYEffectModel *> *)list taskID:(XYCommonEngineTaskID)taskID {
    if (list.count > 0) {
        NSMutableArray *sortedArr = [NSMutableArray array];
        [sortedArr addObjectsFromArray:[list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            XYEffectModel *effectModel1 = obj1;
            XYEffectModel *effectModel2 = obj2;
            NSInteger firstPos = effectModel1.destVeRange.dwPos;
            NSInteger secondPos = effectModel2.destVeRange.dwPos;
            
            if (XYCommonEngineTaskIDClipExchange == taskID) {//交换 用相对时间来排序
                XYClipModel *relativeClipModel1 = [[XYEngineWorkspace clipMgr] fetchClipModelWithIdentifier:effectModel1.relativeClipInfo.clipIdentifier];
                XYClipModel *relativeClipModel2 = [[XYEngineWorkspace clipMgr] fetchClipModelWithIdentifier:effectModel2.relativeClipInfo.clipIdentifier];
                firstPos = effectModel1.relativeClipInfo.relativeStart + relativeClipModel1.destVeRange.dwPos;
                secondPos = effectModel2.relativeClipInfo.relativeStart + relativeClipModel2.destVeRange.dwPos;
            }
            NSNumber *first = [NSNumber numberWithUnsignedLong:firstPos];
            NSNumber *second = [NSNumber numberWithUnsignedLong:secondPos];
            return [first compare:second];
        }]];
        return sortedArr;
    } else {
        return nil;
    }
}

- (void)adjustEffectEveryCellList:(NSArray <XYEffectModel *> *)list taskID:(XYCommonEngineTaskID)taskID {
    [list enumerateObjectsUsingBlock:^(XYEffectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BOOL isRelativeFullDuration = NO;
        if (XYCommonEngineGroupIDBgmMusic == obj.groupID && 1 == list.count && ((!obj.isAddedByTheme && ((XYEffectAudioModel *)obj).isRepeatON) || obj.isAddedByTheme)) {
            if (obj.userDataModel.relativeClipInfo.isFullDuration) {
                isRelativeFullDuration = YES;
                if (XYCommonEngineTaskIDStoryboardAddTheme == taskID && !obj.isAddedByTheme) {
                    obj.destVeRange.dwPos = 0;
                    obj.destVeRange.dwLen = [self.storyboard getDuration];
                } else {
                    NSInteger subValue = [self.storyboard getDuration] - obj.relativeClipInfo.videoDuration;
                    obj.destVeRange.dwLen = obj.destVeRange.dwLen + subValue;
                }
                [self.storyboard setEffectRange:obj.pEffect startPos:obj.destVeRange.dwPos duration:obj.destVeRange.dwLen];
            }
        }
        if (!isRelativeFullDuration) {
            [obj adjustEffect];
        }
        if (XYCommonEngineTaskIDStoryboardAddTheme == taskID) {
            if (obj.isAddedByTheme) { //主题音乐
                [self.storyboard updateAudiGainWithPEffect:obj.pEffect volumeValue:100];
            }
        }
    }];
    [self adjustEffectEveryCellListCutTail:list taskID:taskID];
    
}

- (void)adjustEffectEveryCellListCutTail:(NSArray <XYEffectModel *> *)list taskID:(XYCommonEngineTaskID)taskID {
    if (list.count > 0) {
        for (int i = 0; i < list.count; i ++) {
            XYEffectModel *effectModel = [list objectAtIndex:i];
            if (!effectModel.pEffect) {
                continue;
            }
            NSInteger subValue = 0;
            if (i == list.count - 1) {//最后一个
            } else {
                XYEffectModel *nextModel = [list objectAtIndex:i + 1];
                subValue = effectModel.destVeRange.dwPos + effectModel.destVeRange.dwLen - nextModel.destVeRange.dwPos;
            }
            if (subValue > 0) {
                if (effectModel.destVeRange.dwLen - subValue > 0) {
                    effectModel.destVeRange.dwLen = effectModel.destVeRange.dwLen - subValue;
                    [self.storyboard setEffectRange:effectModel.pEffect startPos:effectModel.destVeRange.dwPos duration:effectModel.destVeRange.dwLen];
                }
            }
            if (effectModel.destVeRange.dwPos + effectModel.destVeRange.dwLen > [self.storyboard getDuration]) {
                [self.storyboard setEffectRange:effectModel.pEffect startPos:effectModel.destVeRange.dwPos duration:[self.storyboard getDuration] - effectModel.destVeRange.dwPos];
            }
            [effectModel updateRelativeClipInfo];
        }
    }
}

- (void)cleanData {
    self.effectMapData = nil;
}

@end
