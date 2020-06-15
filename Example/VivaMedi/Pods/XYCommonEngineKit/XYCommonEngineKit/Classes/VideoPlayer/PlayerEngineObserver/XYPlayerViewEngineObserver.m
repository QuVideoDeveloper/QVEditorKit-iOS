//
//  XYCrabEditPlayerEngineObserver.m
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/10/24.
//

#import "XYPlayerViewEngineObserver.h"
#import "XYCommonEngineKit.h"
#import <XYToolKit/XYToolKit.h>
#import "XYPlayerView.h"

static NSInteger const kSnapPlayViewTag  = 89999;

@interface XYPlayerViewEngineObserver ()

@property (nonatomic, weak) XYPlayerView *editorPlayerView;

@property (nonatomic, assign) BOOL isLastOperationInstantUpdate;

@end


@implementation XYPlayerViewEngineObserver


//开始监听引擎操作
- (void)startObserverWithPlayerView:(XYPlayerView *)playerView {
    self.editorPlayerView = playerView;
    
    @weakify(self);
    //前处理监听
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskStart block:^(id obj) {
        @strongify(self);
        XYBaseEngineTask *task = obj;
        if (!task.skipRefreshPlayer) {
            [self preProcessWithTask:task];
        }
    }];
    
    //后处理监听
    
    void (^block)(id obj) = ^(id obj){
        @strongify(self);
        XYBaseEngineTask *task = obj;
        if (!task.skipRefreshPlayer) {
            [self postProcessWithTask:task];
        }
    };
    
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskFinish block:block];
    
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverTempWorkspaceEveryTaskFinish block:block];
    
    //临时工作站将要切Storyboard 播放器destroySource
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDStoryboardWillSwitch block:^(id obj) {
        @strongify(self);
        [self.editorPlayerView pause];
        [self.editorPlayerView destroySource];//切换之前就需要 destroySource sunshine 待整理
    }];
    
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDStoryboardSwitch block:^(id obj) {
        @strongify(self);
        XYBaseEngineTask *task = [[XYBaseEngineTask alloc] init];
        if ([obj isKindOfClass:[NSNumber class]]) {
            task.seekPositon = [obj integerValue];
        }
        task.operationCode = XYCommonEngineOperationCodeReOpen;
        [self postProcessReopenPlayer:task];//task 类型不对 sunshine 待整理
    }];
}

//去除监听
- (void)removeObserver {
    [XYEngineWorkspace removeObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskStart];
    [XYEngineWorkspace removeObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskFinish];
    [XYEngineWorkspace removeObserver:self taskID:XYCommonEngineTaskIDStoryboardWillSwitch];
    [XYEngineWorkspace removeObserver:self taskID:XYCommonEngineTaskIDStoryboardSwitch];
    [[XYEngineWorkspace undoMgr] removeObserverStackChange:self];
    [[XYEngineWorkspace undoMgr] removeReSetEngine:self];
}

//引擎操作开始前的预处理
- (void)preProcessWithTask:(XYBaseEngineTask *)task {
    [self.editorPlayerView setDisablePlayAndSeek:YES];
    
    XYCommonEngineOperationCode oprationCode = task.operationCode;
    
    //调节音量的时候不需要暂停播放器,其余所有引擎操作开始前都需要暂停播放器
    if (task.preRunTaskPlayerNeedPause) {
        [self.editorPlayerView pause];
    }
        
    switch (oprationCode) {
        case XYCommonEngineOperationCodeReOpen:
        case XYCommonEngineOperationCodeReBuildPlayer:
            [self preProcessReopenPlayer:task];
            break;
        case XYCommonEngineOperationCodeStartInstantUpdateVisionEffect:
            [self preProcessStartInstantVisionEffectUpdate:task];
            break;
        case XYCommonEngineOperationCodeRemoveEffect:
        case XYCommonEngineOperationCodeReplaceEffect:
            [self preProcessVisionEffectDelete:task];
            break;
        case XYCommonEngineOperationCodeUpdateEffect:
            [self preProcessVisionEffectUpdate];
            break;
        default:
            break;
    }
}

//根据引擎操作完成后的处理
- (void)postProcessWithTask:(XYBaseEngineTask *)task {
    [self.editorPlayerView setDisablePlayAndSeek:NO];
    
    XYCommonEngineOperationCode oprationCode = task.operationCode;
    
    switch (oprationCode) {
        case XYCommonEngineOperationCodeNone:
            break;//无需刷播放器的task
        case XYCommonEngineOperationCodeReOpen:
        case XYCommonEngineOperationCodeReBuildPlayer:
            [self postProcessReopenPlayer:task];
            break;
        case XYCommonEngineOperationCodeAddEffect:
        case XYCommonEngineOperationCodeUpdateEffect:
            [self postProcessUpdateEffect:task opCode:oprationCode effect:task.pEffect];
            break;
        case XYCommonEngineOperationCodeRemoveEffect:
        case XYCommonEngineOperationCodeDisplayRefresh:
            [self.editorPlayerView displayRefreshAsync:NO];
            break;
        case XYCommonEngineOperationCodeStartInstantUpdateVisionEffect:
            [self.editorPlayerView displayRefreshAsync:YES];
            break;
        case XYCommonEngineOperationCodeRefreshAudio:
            [self postProcessRefreshAudio];
            break;
        case XYCommonEngineOperationCodeRefreshAudioEffect:
            [self postProcessRefreshAudioEffect:task];
            break;
        case XYCommonEngineOperationCodeReplaceEffect:
            [self postProcessUpdateEffect:task opCode:XYCommonEngineOperationCodeAddEffect effect:task.pEffect];
            break;
        case XYCommonEngineOperationCodeUpdateAllClipAllEffect:
        case XYCommonEngineOperationCodeUpdateAllMusic:
            [self postProcessUpdateEffect:task opCode:oprationCode effect:nil];
            break;
        case XYCommonEngineOperationCodeUpdateAllEffect:
            [self postProcessUpdateEffect:task opCode:oprationCode effect:nil];
            break;
        default:
        {
            NSAssert(NO, @"不应该跑到这里！");
            break;
        }
    }
    if (task.isAutoplay) {
        [self.editorPlayerView playAsync:NO];
    }
}

#pragma mark - 更新引擎效果之前处理
- (void)preProcessReopenPlayer:(XYBaseEngineTask *)task {
    [self showSnapView];
    XYBaseStoryboardTask *storyboardTask = (XYBaseStoryboardTask *)task;
    if (![storyboardTask isKindOfClass:[XYBaseStoryboardTask class]]) {
        return;
    }
    CGFloat ratio = 1;
    if ((XYCommonEngineTaskIDStoryboardUndo == task.taskID || XYCommonEngineTaskIDStoryboardRedo == task.taskID ) && task.undoConfigModel.param[@"ratio"]) {
        ratio = [task.undoConfigModel.param[@"ratio"] floatValue];
    } else {
        XYStoryboardModel *storyboardModel = storyboardTask.storyboardModel;
        if (XYCommonEngineTaskIDStoryboardReset == task.taskID && [XYEngineWorkspace stordboardMgr].backUpModel.afterBackUpIsModified) {
            [self.editorPlayerView pause];
            [self.editorPlayerView destroySource];
            storyboardModel.ratioValue = [XYEngineWorkspace stordboardMgr].backUpModel.preBackUpRatio;
        }
        ratio = storyboardModel.ratioValue;
    }
    
    if (self.editorPlayerView.playerConfig.videoRatio != ratio) {
        self.editorPlayerView.playerConfig.videoRatio = ratio;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self updateWorkspaceConfig:task.taskID];
        });
    }
}

- (void)preProcessStartInstantVisionEffectUpdate:(XYBaseEngineTask *)task {
    XYBaseEffectTask *effectVisionUpdateTask = task;
    XYEffectVisionModel *effectVisionModel = effectVisionUpdateTask.effectModel;
    if (effectVisionModel.isInstantRefresh) {
        self.isLastOperationInstantUpdate = YES;
        [self.editorPlayerView lockStuffUnderEffect:effectVisionModel.pEffect async:YES];
    }
}

- (void)preProcessVisionEffectUpdate {
    if (self.isLastOperationInstantUpdate) {
        [self.editorPlayerView displayRefreshAsync:NO];
        self.isLastOperationInstantUpdate = NO;
    }
}

- (void)preProcessVisionEffectDelete:(XYBaseEngineTask *)task {
    XYBaseEffectTask *effectVisionUpdateTask = task;
    [self.editorPlayerView refreshEffect:[[XYEngineWorkspace currentStoryboard] getDataClip]
                                                   OpCode:QVET_REFRESH_STREAM_OPCODE_REMOVE_EFFECT
                                                   effect:task.pEffect
                                                    async:NO];
}

#pragma mark - 更新完引擎效果之后处理
- (void)postProcessUpdateEffect:(XYBaseEngineTask *)task
                         opCode:(NSInteger)opCode
                         effect:(CXiaoYingEffect *)effect {
    CXiaoYingClip *pClip = task.pClip == nil ? [[XYEngineWorkspace currentStoryboard] getDataClip] : task.pClip;
    [self.editorPlayerView refreshEffect:pClip
                                  OpCode:opCode
                                  effect:task.pEffect
                                   async:NO];
    [self.editorPlayerView displayRefreshAsync:NO];
    
    if (task.groupID == XYCommonEngineGroupIDText
        || task.groupID == XYCommonEngineGroupIDSticker
        || task.groupID == XYCommonEngineGroupIDCollage
        || task.groupID == XYCommonEngineGroupIDWatermark) {
        XYBaseEffectTask *effectVisionUpdateTask = task;
        XYEffectVisionModel *effectVisionModel = effectVisionUpdateTask.effectModel;
        [self.editorPlayerView unlockStuffUnderEffect:effectVisionModel.pEffect async:YES];
    }
}

- (void)postProcessRefreshAudio {
    [self.editorPlayerView refreshAudio];
}

- (void)postProcessRefreshAudioEffect:(XYBaseEngineTask *)task {
    [self.editorPlayerView refreshAudio];
    if (![task isKindOfClass:[XYBaseClipTask class]]) {
        return;
    }
    XYBaseClipTask *clipTask = task;
    [clipTask.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull clipModel, NSUInteger idx, BOOL * _Nonnull stop) {
        CXiaoYingClip *pClip = clipModel.pClip;
        CXiaoYingEffect *effect = [pClip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC EffectIndex:0];
        if (effect) {
            [self.editorPlayerView refreshEffect:pClip
                                          OpCode:QVET_REFRESH_STREAM_OPCODE_UPDATE_ALL_MUSIC
                                          effect:effect
                                           async:YES];
        }
    }];
}

- (void)postProcessReopenPlayer:(XYBaseEngineTask *)task {
    //要在DestroySource之前先保存当前seekPosition
    NSInteger previousSeekPosition = self.editorPlayerView.playerConfig.seekPosition;
    NSInteger seekPosition = task.seekPositon;
    if (seekPosition < 0) {
        seekPosition = previousSeekPosition;
    }
    if (seekPosition > [XYEngineWorkspace stordboardMgr].currentStbModel.videoDuration) {
        seekPosition = [XYEngineWorkspace stordboardMgr].currentStbModel.videoDuration;
    }
    
    if (XYCommonEngineOperationCodeReBuildPlayer == task.operationCode) {
        [self.editorPlayerView destroySource];
    }
    
    [self.editorPlayerView refreshWithConfig:^XYPlayerViewConfiguration *(XYPlayerViewConfiguration *config) {
        config = [XYPlayerViewConfiguration storyboardSourceConfig:[XYEngineWorkspace currentStoryboard]];
        config.seekPosition = seekPosition;
        config.needRebuildStram = YES;
        return config;
    }];
    
    [self.editorPlayerView seekToPosition:seekPosition async:NO];
    
    if (task.isAutoplay) {
        [self.editorPlayerView playAsync:NO];
    }
    [self hideSnapView];
}

- (void)updateWorkspaceConfig:(XYCommonEngineTaskID)taskID {
}

- (void)showSnapView {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *existView = [self.editorPlayerView viewWithTag:kSnapPlayViewTag];
        if(existView) {
            return ;
        }
        
        UIView *snapView = [self.editorPlayerView snapshotViewAfterScreenUpdates:NO];
        snapView.frame = self.editorPlayerView.bounds;
        snapView.tag = kSnapPlayViewTag;
        [self.editorPlayerView addSubview:snapView];
    });
}

- (void)hideSnapView {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *snapView = [self.editorPlayerView viewWithTag:kSnapPlayViewTag];
        if(snapView) {
            [snapView removeFromSuperview];
        }
    });
}

#pragma mark -
- (void)dealloc {
    NSLog(@"XYCrabEditPlayerEngineObserver dealloc");
}



@end
