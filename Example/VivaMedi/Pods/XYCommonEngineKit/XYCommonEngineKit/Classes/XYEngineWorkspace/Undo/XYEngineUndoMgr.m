//
//  XYEngineUndoManager.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/20.
//

#import "XYEngineUndoMgr.h"
#import "XYEngineUndoManager_Private.h"
#import <XYReactDataBoard/XYReactBlackMapBoard.h>
#import "XYStoryboard.h"
#import "XYEngineWorkspace.h"
#import "XYClipOperationMgr.h"
#import <XYCategory/XYCategory.h>

#define UNDO_MAX_STEP 50

static NSString * const XYEngineUndoRedoStackChageKey = @"xy_engine_undo_redo_key";//监听undo redo 堆栈变化 更新undo redo 对应的undo redo 按钮
static NSString * const XYEngineReSetEngineKey = @"xy_engine_undo_re_set_engine_key";
static NSString * const XYEngineForPlayerKey = @"xy_engine_undo_for_Player_key";


@implementation XYEngineUndoManagerConfig

- (NSMutableDictionary *)undoParam {
    if (!_undoParam) {
        _undoParam = [NSMutableDictionary dictionary];
    }
    return _undoParam;
}

- (NSMutableDictionary *)redoParam {
    if (!_redoParam) {
        _redoParam = [NSMutableDictionary dictionary];
    }
    return _redoParam;
}

- (NSNumber *)undoseekPositionNumber {
    if (!_undoseekPositionNumber) {
        _undoseekPositionNumber = @(-1);
    }
    return _undoseekPositionNumber;
}

- (XYEngineReloadTimeLineType)reloadType {
    return XYEngineReloadTimeLineAll;
}

@end

@implementation XYEngineUndoManagerModule

- (XYEngineUndoManagerConfig *)configModel {
    if (!_configModel) {
        _configModel = [XYEngineUndoManagerConfig new];
    }
    return _configModel;
}

@end


@interface XYEngineUndoMgr()

@property(nonatomic, weak) XYStoryboard *storyboard;

@end

@implementation XYEngineUndoMgr

- (void)initialize:(XYStoryboard *)storyboard {
    if (self) {
        self.storyboard = storyboard;
        [self clean];
        [self preAddDoWithConfig:^XYEngineUndoManagerConfig * _Nonnull(XYEngineUndoManagerConfig * _Nonnull config) {
            return config;
        }];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.undoAntionState = XYEngineUndoActionStateNone;
        self.redoAble = NO;
        self.undoAble = NO;
    }
    return self;
}

- (XYEngineUndoManagerConfig *)undoStackWillPopObject {
    XYEngineUndoManagerConfig *config = [self.undoStack lastObject].configModel;
    config.param = config.undoParam;
    return config;
}

- (XYEngineUndoManagerConfig *)redoStackWillPopObject {
    XYEngineUndoManagerConfig *config = [self.redoStack lastObject].configModel;
    config.param = config.redoParam;
    return config;
}

- (void)reSetStoryboard:(XYStoryboard *)storyboard {
    self.storyboard = storyboard;
}

- (void)clean {
    self.stackCurrentUsingModel = nil;
    self.engineBlackBoard = nil;
    self.undoDataBoard = nil;
    if (self.undoStack.count > 0) {
        [self.undoStack enumerateObjectsUsingBlock:^(XYEngineUndoManagerModule * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.cXiaoYingStoryBoardSession UnInit];
            obj.cXiaoYingStoryBoardSession = nil;
        }];
    }
    
    if (self.redoStack.count > 0) {
        [self.redoStack enumerateObjectsUsingBlock:^(XYEngineUndoManagerModule * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.cXiaoYingStoryBoardSession UnInit];
            obj.cXiaoYingStoryBoardSession = nil;
        }];
    }
    self.undoStack = nil;
    self.redoStack = nil;
    
}


//将要改变storyboard 时调用 预置一个
- (void)preAddDoWithConfig:(XYEngineUndoManagerConfig * _Nonnull (^)(XYEngineUndoManagerConfig * _Nonnull))configBlock {
    XYEngineUndoManagerModule *stackModel = [XYEngineUndoManagerModule new];
    XYEngineUndoManagerConfig *config = [XYEngineUndoManagerConfig new];
    
    stackModel.cXiaoYingStoryBoardSession = [self.storyboard duplicate];
    stackModel.configModel = configBlock(config);
    self.presetInsertStackModel = stackModel;
    self.undoAntionState = XYEngineUndoActionStatePreAdd;
}
//预置的加入到undo队列里
- (void)setPreAddDoneWithConfig:(XYEngineUndoManagerConfig * _Nonnull (^)(XYEngineUndoManagerConfig * _Nonnull))configBlock {
    self.presetInsertStackModel.configModel = configBlock(self.presetInsertStackModel.configModel);
    [self innerAddDo:self.presetInsertStackModel];
}

- (void)addDoWithConfig:(XYEngineUndoManagerConfig * _Nonnull (^)(XYEngineUndoManagerConfig * _Nonnull))configBlock {
    XYEngineUndoManagerModule *stackModel = [XYEngineUndoManagerModule new];
    XYEngineUndoManagerConfig *config = [XYEngineUndoManagerConfig new];
    stackModel.cXiaoYingStoryBoardSession = [self.storyboard duplicate];
    stackModel.configModel = configBlock(config);
    [self innerAddDo:stackModel];
}

- (void)updateRedoParam:(NSMutableDictionary *)redoParam {
    XYEngineUndoManagerModule *undoMgrModel = self.undoStack.lastObject;
    if (redoParam) {
        NSMutableDictionary *bridgeMdic = [NSMutableDictionary dictionaryWithDictionary:undoMgrModel.configModel.redoParam];
        [bridgeMdic addEntriesFromDictionary:redoParam];
        undoMgrModel.configModel.redoParam = bridgeMdic;
    }
}


- (XYEngineUndoManagerConfig *)undo {
    if (self.undoStack.count > 0) {
        if (self.stackCurrentUsingModel && !self.stackCurrentUsingModel.configModel.redoNeedForce) {
            XYEngineUndoManagerConfig *subModel = ((XYEngineUndoManagerModule *)[self.undoStack lastObject]).configModel;
            self.stackCurrentUsingModel.configModel = subModel;
            [self.redoStack addObject:self.stackCurrentUsingModel];
            self.stackCurrentUsingModel = [self.undoStack lastObject];
        }else {
            XYEngineUndoManagerModule *undoLastModel = [self.undoStack lastObject];
            XYEngineUndoManagerModule *model = [XYEngineUndoManagerModule new];
            model.cXiaoYingStoryBoardSession = [self.storyboard duplicate];
            model.configModel = undoLastModel.configModel;
            self.stackCurrentUsingModel = undoLastModel;
            [self.redoStack addObject:model];
            self.stackCurrentUsingModel.configModel.redoNeedForce = NO;
        }
        [self.undoStack removeLastObject];
        [self reSetEngine:self.stackCurrentUsingModel];
        if (self.stackCurrentUsingModel) {
            [self subjectIsUndo:YES];
        }
        if (self.undoStack.count > 0) {
            [self sendUndoRedoStackChage:XYEngineUndoManagerAllAble];
        }else {
            [self sendUndoRedoStackChage:XYEngineUndoManagerRedoAble];
        }
        return self.stackCurrentUsingModel.configModel;
    } else {
        [XYEngineWorkspace reloadAllData];
        return nil;
    }
}

- (XYEngineUndoManagerConfig *)redo {
    if (self.redoStack.count > 0) {
        if (self.stackCurrentUsingModel) {
            XYEngineUndoManagerConfig *subModel = ((XYEngineUndoManagerModule *)[self.redoStack lastObject]).configModel;
            self.stackCurrentUsingModel.configModel = subModel;
            [self.undoStack addObject:self.stackCurrentUsingModel];
        }
        self.stackCurrentUsingModel = [self.redoStack lastObject];
        [self reSetEngine:self.stackCurrentUsingModel];
        [self.redoStack removeLastObject];
        if (self.stackCurrentUsingModel) {
            [self subjectIsUndo:NO];
        }
        if (self.redoStack.count > 0) {
            [self sendUndoRedoStackChage:XYEngineUndoManagerAllAble];
        }else {
            [self sendUndoRedoStackChage:XYEngineUndoManagerUndoAble];
        }
        return self.stackCurrentUsingModel.configModel;
    } else {
        [XYEngineWorkspace reloadAllData];
        return nil;
    }
}

- (void)observerStackChange:(id)observer block:(void (^)(NSNumber * _Nonnull))block {
    RACSignal *signal = [self.engineBlackBoard addObserver:observer forKey:XYEngineUndoRedoStackChageKey];
    [signal subscribeNext:block];
}

- (void)removeObserverStackChange:(id)observer {
    [self.engineBlackBoard removeObserver:observer forKey:XYEngineUndoRedoStackChageKey];
}

- (void)removeObserver:(id)observer {
    [self.undoDataBoard removeObserver:observer forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDObserverEveryTaskFinishDispatchMain]];
}


- (void)addObserver:(id)observer block:(void (^)(XYEngineUndoManagerModule * _Nonnull))block {
    if (block) {
        RACSignal *signal = [self.undoDataBoard addObserver:observer forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDObserverEveryTaskFinishDispatchMain]];
        [signal subscribeNext:block];
    }
}

- (void)observerReSetEngine:(id _Nonnull )observer block:(void (^)(NSNumber *_Nonnull))block {
    RACSignal *signal = [self.engineBlackBoard addObserver:observer forKey:XYEngineReSetEngineKey];
    [signal subscribeNext:block];
}

- (void)observerForPlayer:(id _Nonnull )observer block:(void (^)(XYEngineUndoManagerConfig * _Nonnull))block {
    RACSignal *signal = [self.engineBlackBoard addObserver:observer forKey:XYEngineForPlayerKey];
    [signal subscribeNext:block];
}

- (void)removeObserverForPlayer:(id _Nonnull )observer {
    [self.engineBlackBoard removeObserver:observer forKey:XYEngineForPlayerKey];
}
- (void)removeReSetEngine:(id _Nonnull )observer {
    [self.engineBlackBoard removeObserver:observer forKey:XYEngineReSetEngineKey];
}


//向外发出订阅 通知需要同步的对象
- (void)subjectIsUndo:(BOOL)isUndo {
    [XYEngineWorkspace reloadAllData];
    [self.engineBlackBoard setValue:self.stackCurrentUsingModel.configModel forKey:[NSString stringWithFormat:@"%d",XYEngineForPlayerKey]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.storyboard.isModified = self.stackCurrentUsingModel.configModel.isModified;
        self.stackCurrentUsingModel.configModel.isUndoAction = isUndo;
        self.stackCurrentUsingModel.configModel.param = isUndo ? self.stackCurrentUsingModel.configModel.undoParam : self.stackCurrentUsingModel.configModel.redoParam;
        [self.undoDataBoard setValue:self.stackCurrentUsingModel.configModel forKey:[NSString stringWithFormat:@"%d",XYCommonEngineTaskIDObserverEveryTaskFinishDispatchMain]];
    });
}



- (void)innerAddDo:(XYEngineUndoManagerModule *)sender {
    if (sender) {
        self.undoAntionState = XYEngineUndoActionStateNone;
        sender.configModel.isModified = self.storyboard.isModified;
        self.stackCurrentUsingModel = nil;
        if (!sender.cXiaoYingStoryBoardSession) {
            sender.cXiaoYingStoryBoardSession = [self.storyboard duplicate];
        }
        [self.undoStack addObject:sender];
        if (self.undoStack.count > UNDO_MAX_STEP) {
            XYEngineUndoManagerModule *undoModel = self.undoStack.firstObject;
            [undoModel.cXiaoYingStoryBoardSession UnInit];
            undoModel.cXiaoYingStoryBoardSession = nil;
            if (undoModel) {
                [self.undoStack removeObject:undoModel];
            }
        }
        
        //        [self.redoStack enumerateObjectsUsingBlock:^(XYEngineUndoManagerModule * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            [obj.cXiaoYingStoryBoardSession UnInit];
        //            obj.cXiaoYingStoryBoardSession = nil;
        //        }];
        
        [self.redoStack removeAllObjects];
        [self sendUndoRedoStackChage:XYEngineUndoManagerUndoAble];
    }
}

- (NSMutableArray *)undoStack {
    if (!_undoStack) {
        _undoStack = [NSMutableArray new];
    }
    return _undoStack;
}

- (NSMutableArray *)redoStack {//sunshine 多线程问题待处理
    if (!_redoStack) {
        _redoStack = [NSMutableArray new];
    }
    return _redoStack;
}


- (XYReactBlackMapBoard *)undoDataBoard {
    if (!_undoDataBoard) {
        _undoDataBoard = [[XYReactBlackMapBoard alloc] init];
    }
    return _undoDataBoard;
}

- (XYReactBlackMapBoard *)engineBlackBoard {
    if (!_engineBlackBoard) {
        _engineBlackBoard = [[XYReactBlackMapBoard alloc] init];
    }
    return _engineBlackBoard;
}


- (void)reSetEngine:(XYEngineUndoManagerModule *)doModel {
    if (doModel) {
        [self.engineBlackBoard setValue:@(1) forKey:XYEngineReSetEngineKey];
        [self.storyboard setStoryboardSession:doModel.cXiaoYingStoryBoardSession];
    }
}

- (void)reNoticeUndoRedoStackChage {
    XYEngineUndoManagerType type;
    if (self.undoStack.count > 0 && self.redoStack.count > 0) {
        type = XYEngineUndoManagerAllAble;
    } else if (self.undoStack.count > 0) {
        type = XYEngineUndoManagerUndoAble;
    } else if (self.redoStack.count > 0) {
        type = XYEngineUndoManagerRedoAble;
    } else {
        type = XYEngineUndoManagerAllDisable;
    }
    [self sendUndoRedoStackChage:XYEngineUndoManagerAllAble];
}

- (void)sendUndoRedoStackChage:(XYEngineUndoManagerType)undoRedoStackType {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.engineBlackBoard setValue:@(undoRedoStackType) forKey:XYEngineUndoRedoStackChageKey];
        if (XYEngineUndoManagerUndoAble == undoRedoStackType || XYEngineUndoManagerAllAble == undoRedoStackType) {
            self.undoAble = YES;
        } else {
            self.undoAble = NO;
        }
        
       if (XYEngineUndoManagerRedoAble == undoRedoStackType || XYEngineUndoManagerAllAble == undoRedoStackType) {
            self.redoAble = YES;
        } else {
            self.redoAble = NO;
        }
        
    });
}

- (NSInteger)getCurrentUndoStackCount {
    return self.undoStack.count;
}

- (void)removeObjFromUndoStactLastCount:(NSInteger)lastCount {
    if (lastCount > 0) {
            NSMutableArray *bridgeArr = [NSMutableArray array];
        [self.undoStack enumerateObjectsUsingBlock:^(XYEngineUndoManagerModule * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < (self.undoStack.count - lastCount)) {
                [bridgeArr addObject:obj];
            } else {
                [obj.cXiaoYingStoryBoardSession UnInit];
                obj.cXiaoYingStoryBoardSession = nil;
            }
        }];
        self.undoStack = bridgeArr;
        if (self.undoStack.count > 0) {
            [self sendUndoRedoStackChage:XYEngineUndoManagerUndoAble];
        } else {
            [self sendUndoRedoStackChage:XYEngineUndoManagerAllDisable];
        }
    }
}

@end

