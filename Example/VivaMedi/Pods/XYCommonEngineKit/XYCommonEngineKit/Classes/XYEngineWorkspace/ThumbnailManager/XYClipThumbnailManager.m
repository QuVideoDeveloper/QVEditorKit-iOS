//
//  XYThumbnailManager.m
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/12/19.
//

#import "XYClipThumbnailManager.h"
#import "XYClipThumbnailModel.h"
#import "XYCommonEngineKit.h"
#import <XYToolKit/XYToolKit.h>
#import <SDWebImage/SDWebImage.h>

@interface XYClipThumbnailManager ()

@property (nonatomic, assign) BOOL isDestroyed;
@property (nonatomic, strong) NSMutableDictionary <NSString *, XYClipThumbnailModel *> *thumbnailModelDict;

@end

@implementation XYClipThumbnailManager

- (instancetype)init {
    self = [super init];
    if (self) {
#ifdef DEBUG
        [self cleanMemoryCache];
        [self cleanDiskCache:nil];
#endif
    }
    return self;
}

- (void)dealloc {
    NSLog(@"XYVivaEditorThumbnailManager dealloc");
    [self destroyThumbnailManager];
}

#pragma mark - Public
- (void)thumbnailWithClipIdentifier:(NSString *)clipIdentifier
                         inputBlock:(void (^)(XYClipThumbnailInputModel *inputModel))inputBlock
                      completeBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))completeBlock
                   placeholderBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))placeholderBlock {
    [self thumbnailWithClipIdentifier:clipIdentifier
                      isTempWorkSpace:NO
                           inputBlock:inputBlock
                        completeBlock:completeBlock
                     placeholderBlock:placeholderBlock];
}

- (void)thumbnailWithClipIdentifier:(NSString *)clipIdentifier
                    isTempWorkSpace:(BOOL)isTempWorkSpace
                         inputBlock:(void (^)(XYClipThumbnailInputModel *inputModel))inputBlock
                      completeBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))completeBlock
                   placeholderBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))placeholderBlock {
    if (self.isDestroyed) {
        return;
    }
    XYClipThumbnailModel *thumbnailModel = [self thumbnailModelWithClipIdentifier:clipIdentifier isTempWorkSpace:isTempWorkSpace];
    if (inputBlock) {
        inputBlock(thumbnailModel.inputModel);
    }
#ifdef DEBUG
    [self logInputModel:thumbnailModel isTempWorkSpace:isTempWorkSpace];
#endif
    [thumbnailModel thumbnailWithCompleteBlock:completeBlock
                              placeholderBlock:placeholderBlock];
}

- (void)thumbnailWithEffectIdentifier:(NSString *)effectIdentifier
                           inputBlock:(void (^)(XYClipThumbnailInputModel *inputModel))inputBlock
                        completeBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))completeBlock
                     placeholderBlock:(void (^)(XYClipThumbnailCompleteModel *completeModel))placeholderBlock {
    if (self.isDestroyed) {
        return;
    }
    XYClipThumbnailModel *thumbnailModel = [self thumbnailModelWithEffectIdentifier:effectIdentifier];
    if (inputBlock) {
        inputBlock(thumbnailModel.inputModel);
    }
    [thumbnailModel thumbnailWithCompleteBlock:completeBlock
                              placeholderBlock:placeholderBlock];
}

- (void)cleanMemoryCache {
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)cleanDiskCache:(void (^)(void))completeBlock {
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:completeBlock];
}

- (void)addRealTaskObserver {
    @weakify(self);
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskFinish block:^(id obj) {
        @strongify(self);
        XYBaseEngineTask *task = obj;
        [self postProcessEngineTask:task isTempWorkSpace:NO];
    }];
    
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskStart block:^(id obj) {
        @strongify(self);
        XYBaseEngineTask *task = obj;
        [self preProcessEngineTask:task isTempWorkSpace:NO];
    }];
}

- (void)addTempTaskObserver {
    @weakify(self);
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDObserverTempWorkspaceEveryTaskFinish block:^(id obj) {
        @strongify(self);
        XYBaseEngineTask *task = obj;
        [self postProcessEngineTask:task isTempWorkSpace:YES];
    }];
    
    [XYEngineWorkspace addObserver:self taskID:XYCommonEngineTaskIDStoryboardWillSwitch block:^(XYBaseEngineTask *task) {
        NSArray *clipModels = task.userInfo[@"clips"];
        @strongify(self);
        [clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull clipModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [self destroyThumbnailManagerWithClipModel:clipModel isTemp:YES];
        }];
    }];
}

- (void)destroyThumbnailManager {
    self.isDestroyed = YES;
    [self removeObserver];
    [self.thumbnailModelDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, XYClipThumbnailModel * _Nonnull thumbnailModel, BOOL * _Nonnull stop) {
        [thumbnailModel cancelAllOperations];
    }];
    self.thumbnailModelDict = nil;
    NSLog(@"【Thumbnail】destroyThumbnailManager");
}

#pragma mark - Private
- (XYClipThumbnailModel *)thumbnailModelWithClipIdentifier:(NSString *)clipIdentifier isTempWorkSpace:(BOOL)isTempWorkSpace {
    if (!clipIdentifier) {
        return nil;
    }
    NSString *key = [self keyByClipIdentifier:clipIdentifier isTemp:isTempWorkSpace];
    XYClipThumbnailModel *thumbnailModel = self.thumbnailModelDict[key];
    if (!thumbnailModel) {
        XYClipThumbnailInputModel *inputModel = [XYClipThumbnailInputModel new];
        thumbnailModel = [XYClipThumbnailModel new];
        thumbnailModel.key = key;
        thumbnailModel.inputModel = inputModel;
        XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelWithIdentifier:clipIdentifier];
        [self updateInputModelWithClipModel:clipModel inputModel:inputModel];
        self.thumbnailModelDict[key] = thumbnailModel;
    }
    return thumbnailModel;
}

- (XYClipThumbnailModel *)thumbnailModelWithEffectIdentifier:(NSString *)effectIdentifier {
    NSString *key = [self keyByEffectIdentifier:effectIdentifier];
    XYClipThumbnailModel *thumbnailModel = self.thumbnailModelDict[key];
    if (!thumbnailModel) {
        thumbnailModel = [XYClipThumbnailModel new];
        thumbnailModel.key = key;
        XYClipThumbnailInputModel *inputModel = [XYClipThumbnailInputModel new];
        inputModel.storyboard = [XYStoryboard sharedXYStoryboard];
        thumbnailModel.inputModel = inputModel;
        [self updateInputModelClipWithEffectIdentifier:effectIdentifier inputModel:inputModel];
        self.thumbnailModelDict[key] = thumbnailModel;
        
    }
    return thumbnailModel;
}

- (void)updateInputModelClipWithEffectIdentifier:(NSString *)effectIdentifier inputModel:(XYClipThumbnailInputModel *)inputModel {
    XYEffectModel *effectModel = [[XYEngineWorkspace effectMgr] fetchEffectModel:effectIdentifier];
    CXiaoYingClip *clip = [inputModel.storyboard createClip:effectModel.filePath
                                                srcRangePos:effectModel.sourceVeRange.dwPos
                                                srcRangeLen:effectModel.sourceVeRange.dwLen
                                               trimRangePos:0
                                               trimRangeLen:effectModel.sourceVeRange.dwLen];
    inputModel.clipType = [inputModel.storyboard getClipTypeByClip:clip];
    inputModel.clip = clip;
    inputModel.clipFilePath = effectModel.filePath;
    inputModel.sourceVeRange = effectModel.sourceVeRange;
    inputModel.trimVeRange = effectModel.trimVeRange;
    inputModel.speedValue = 1.0;
}

- (void)updateInputModelWithClipModel:(XYClipModel *)clipModel inputModel:(XYClipThumbnailInputModel *)inputModel {
    inputModel.storyboard = [XYStoryboard sharedXYStoryboard];
    inputModel.clipFilePath = clipModel.clipFilePath;
    inputModel.sourceVeRange = clipModel.sourceVeRange;
    inputModel.trimVeRange = clipModel.trimVeRange;
    inputModel.isReversed = clipModel.isReversed;
    inputModel.clipType = clipModel.clipType;
    inputModel.speedValue = clipModel.speedValue;
    inputModel.fixTime = clipModel.fixTime;
    
    if (clipModel.clipType == XYCommonEngineClipModuleThemeCoverFront
        ||clipModel.clipType == XYCommonEngineClipModuleThemeCoverBack) {
        inputModel.themeID = [inputModel.storyboard getThemeID];
    }
    
    if (clipModel.pClip) {
        inputModel.clip = [[CXiaoYingClip alloc] init];
        [inputModel.clip duplicate:clipModel.pClip];
    }
}

- (NSString *)keyByClipIdentifier:(NSString *)clipIdentifier isTemp:(BOOL)isTemp {
    NSString *key = [NSString stringWithFormat:@"ClipIdentifier_%@_%d",clipIdentifier,isTemp];
    return key;
}

- (NSString *)keyByEffectIdentifier:(NSString *)effectIdentifier {
    NSString *key = [NSString stringWithFormat:@"EffectIdentifier_%@",effectIdentifier];
    return key;
}

#pragma mark - Engine Task Observer
- (void)removeObserver {
    [XYEngineWorkspace removeObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskStart];
    [XYEngineWorkspace removeObserver:self taskID:XYCommonEngineTaskIDObserverEveryTaskFinish];
    [XYEngineWorkspace removeObserver:self taskID:XYCommonEngineTaskIDObserverTempWorkspaceEveryTaskFinish];
    [XYEngineWorkspace removeObserver:self taskID:XYCommonEngineTaskIDStoryboardWillSwitch];
}

- (void)preProcessEngineTask:(XYBaseEngineTask *)task isTempWorkSpace:(BOOL)isTemp{
    if (!task.needRebuildThumbnailManager) {//不需要RebuildThumbnailManager
        return;
    }
    if (task.taskID == XYCommonEngineTaskIDStoryboardUndo
        ||task.taskID == XYCommonEngineTaskIDStoryboardRedo
        ||task.taskID == XYCommonEngineTaskIDStoryboardAddTheme
        ||task.taskID == XYCommonEngineTaskIDStoryboardReset) {
        //Undo Redo操作先停止所有取缩略图操作
        
        [[XYEngineWorkspace clipMgr].clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull clipModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [self destroyThumbnailManagerWithClipModel:clipModel isTemp:isTemp];
        }];
    }
}

- (void)postProcessEngineTask:(XYBaseEngineTask *)task isTempWorkSpace:(BOOL)isTemp {
    if (!task.needRebuildThumbnailManager) {//不需要RebuildThumbnailManager
        return;
    }
    if ([task isKindOfClass:[XYBaseEffectTask class]]) {
        XYBaseEffectTask *baseEffectTask = task;
        if (baseEffectTask.effectModel.groupID != XYCommonEngineGroupIDCollage) {
            return;
        }
        
        //画中画效果的引擎操作
        [self rebuildThumbnailManagerWithEffectIdentifier:baseEffectTask.effectModel.identifier];
        return;
    }
    
    if (task.taskID == XYCommonEngineTaskIDStoryboardUndo
        ||task.taskID == XYCommonEngineTaskIDStoryboardRedo
        ||task.taskID == XYCommonEngineTaskIDStoryboardAddTheme
        ||task.taskID == XYCommonEngineTaskIDStoryboardReset) {
        //Undo Redo 切主题操作完成后重新创建取缩略图的ThumbnailManager
        [[XYEngineWorkspace clipMgr].clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull clipModel, NSUInteger idx, BOOL * _Nonnull stop) {
            [self createThumbnailManagerWithClipModel:clipModel isTemp:NO];
        }];
        
        if (task.undoConfigModel.groupID == XYCommonEngineGroupIDCollage && task.undoConfigModel.taskID == XYCommonEngineTaskIDEffectVisionUpdate) {
            //画中画修改，并undo后，需要重新创建一下ThumbnailManager，因为effect路径变了
            [self rebuildThumbnailManagerWithEffectIdentifier:task.undoConfigModel.identifier];
        }
        return;
    }
    
    //其余引擎操作
    [[XYEngineWorkspace clipMgr].clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull clipModel, NSUInteger idx, BOOL * _Nonnull stop) {
        [self rebuildThumbnailManagerWithClipModel:clipModel isTemp:isTemp];
    }];
}

- (void)destroyThumbnailManagerWithClipModel:(XYClipModel *)clipModel isTemp:(BOOL)isTemp {
    NSString *key = [self keyByClipIdentifier:clipModel.identifier isTemp:isTemp];
    XYClipThumbnailModel *thumbnailModel = self.thumbnailModelDict[key];
    [thumbnailModel cancelAllOperations];
}

- (void)createThumbnailManagerWithClipModel:(XYClipModel *)clipModel isTemp:(BOOL)isTemp {
    NSString *key = [self keyByClipIdentifier:clipModel.identifier isTemp:isTemp];
    XYClipThumbnailModel *thumbnailModel = self.thumbnailModelDict[key];
    [self updateInputModelWithClipModel:clipModel inputModel:thumbnailModel.inputModel];
    if (clipModel.pClip) {
        thumbnailModel.inputModel.clip = [[CXiaoYingClip alloc] init];
        [thumbnailModel.inputModel.clip duplicate:clipModel.pClip];
    }
    [thumbnailModel resumeAllOperations];
}

- (void)rebuildThumbnailManagerWithClipModel:(XYClipModel *)clipModel isTemp:(BOOL)isTemp {
    NSString *key = [self keyByClipIdentifier:clipModel.identifier isTemp:isTemp];
    XYClipThumbnailModel *thumbnailModel = self.thumbnailModelDict[key];
    [thumbnailModel cancelAllOperations];
    [self updateInputModelWithClipModel:clipModel inputModel:thumbnailModel.inputModel];
    if (clipModel.pClip) {
        thumbnailModel.inputModel.clip = [[CXiaoYingClip alloc] init];
        [thumbnailModel.inputModel.clip duplicate:clipModel.pClip];
    }
    [thumbnailModel resumeAllOperations];
}

- (void)rebuildThumbnailManagerWithEffectIdentifier:(NSString *)effectIdentifier {
    NSString *key = [self keyByEffectIdentifier:effectIdentifier];
    XYClipThumbnailModel *thumbnailModel = self.thumbnailModelDict[key];
    [thumbnailModel cancelAllOperations];
    [self updateInputModelClipWithEffectIdentifier:effectIdentifier inputModel:thumbnailModel.inputModel];
    [thumbnailModel resumeAllOperations];
}

#pragma mark - Utils
- (void)logInputModel:(XYClipThumbnailModel *)thumbModel isTempWorkSpace:(BOOL)isTempWorkSpace {
    XYClipThumbnailInputModel *inputModel = thumbModel.inputModel;
    NSInteger operationCount = [thumbModel.thumbnailQueue operationCount];
    NSLog(@"[ThumbnailManager] SeekPosition=%d,Speed=%.2f,TrimPos=%d,Reversed=%d,Temp=%d,OperationCount=%d",
          inputModel.seekPosition,inputModel.speedValue,inputModel.trimVeRange.dwPos,inputModel.isReversed,isTempWorkSpace,operationCount);
}

#pragma mark - Lazy Init
- (NSMutableDictionary <NSString *, XYClipThumbnailModel *> *)thumbnailModelDict {
    if (!_thumbnailModelDict) {
        _thumbnailModelDict = [NSMutableDictionary dictionary];
    }
    return _thumbnailModelDict;
}

@end
