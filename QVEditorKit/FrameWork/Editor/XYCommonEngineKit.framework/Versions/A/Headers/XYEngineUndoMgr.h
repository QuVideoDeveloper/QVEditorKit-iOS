//
//  XYEngineUndoManager.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/20.
//
#import "XYEngineEnum.h"
#import "XYBaseCopyModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYEngineUndoManagerType) {
    XYEngineUndoManagerAllDisable = 0,//
    XYEngineUndoManagerUndoAble,
    XYEngineUndoManagerRedoAble,
    XYEngineUndoManagerAllAble,
};

@class CXiaoYingStoryBoardSession;
@class XYReactBlackMapBoard;
@class XYStoryboard;

@interface XYEngineUndoManagerConfig : XYBaseCopyModel

@property (nonatomic, copy) NSString *identifier;//唯一标识符
@property (nonatomic, copy) NSString *toastTitle;//必填
@property (nonatomic, assign) BOOL redoNeedForce;//redo 需要强制重新拷贝内存数据进入redoStack
@property (nonatomic, assign) XYEngineReloadTimeLineType reloadTimeLineType;
@property (nonatomic, strong) NSNumber *undoseekPositionNumber;//可选
@property (nonatomic, strong) NSNumber *redoSeekPositionNumber;//可选



@property (nonatomic, strong) NSMutableDictionary *undoParam;//反向操作的参数 //可选
@property (nonatomic, strong) NSMutableDictionary *redoParam;//将要加的功能的参数 //可选

//以下参数业务无需关心
@property (nonatomic, strong) NSDictionary *param;//unde redo 时会将reverseParam currentParam复制给param
@property (nonatomic, assign) XYCommonEngineTaskID taskID;
@property (nonatomic, assign) XYCommonEngineGroupID groupID;

@property (nonatomic, assign) BOOL isUndoAction;//yes 操作的是undo no redo
@property (nonatomic, assign) BOOL isModified;
@end

@interface XYEngineUndoManagerModule : NSObject
@property (nonatomic, strong) CXiaoYingStoryBoardSession *cXiaoYingStoryBoardSession;
@property (nonatomic, strong) XYEngineUndoManagerConfig *configModel;

@end

@interface XYEngineUndoMgr : NSObject

@property(nonatomic, assign) XYEngineUndoActionState undoAntionState;

@property(nonatomic, assign) BOOL undoAble;
@property(nonatomic, assign) BOOL redoAble;

- (XYEngineUndoManagerConfig *)undoStackWillPopObject;//业务不要调用
- (XYEngineUndoManagerConfig *)redoStackWillPopObject;//业务不要调用

- (NSInteger)getCurrentUndoStackCount;//业务不要调用

- (void)initialize:(XYStoryboard *)storyboard;

- (void)updateRedoParam:(NSMutableDictionary *)redoParam;

- (void)reSetStoryboard:(XYStoryboard *)storyboard;

//将要改变storyboard 时调用 预置一个
- (void)preAddDoWithConfig:(XYEngineUndoManagerConfig *(^)(XYEngineUndoManagerConfig *config))configBlock;

//预置的加入到undo队列里
- (void)setPreAddDoneWithConfig:(XYEngineUndoManagerConfig *(^)(XYEngineUndoManagerConfig *config))configBlock;

//将要改变storyboard 时调用
- (void)addDoWithConfig:(XYEngineUndoManagerConfig *(^)(XYEngineUndoManagerConfig *config))configBlock;

- (void)addObserver:(id _Nonnull )observer block:(void (^)(XYEngineUndoManagerConfig * _Nonnull))block;

- (void)removeObserver:(id _Nonnull )observer;

- (XYEngineUndoManagerConfig *)undo;

- (XYEngineUndoManagerConfig *)redo;

- (void)clean;


- (void)observerReSetEngine:(id _Nonnull )observer block:(void (^)(NSNumber *_Nonnull))block;//用于将改变storyboard 播放器需要destroySource
- (void)removeReSetEngine:(id _Nonnull )observer;

- (void)observerForPlayer:(id _Nonnull )observer block:(void (^)(XYEngineUndoManagerConfig * _Nonnull))block;//给播放器使用 
- (void)removeObserverForPlayer:(id _Nonnull )observer;



- (void)observerStackChange:(id _Nonnull )observer block:(void (^)(NSNumber *_Nonnull))block;//监听undo redo 堆栈变化 更新undo redo 对应的undo redo 按钮
- (void)removeObserverStackChange:(id _Nonnull )observer;

- (void)reNoticeUndoRedoStackChage;

- (void)removeObjFromUndoStactLastCount:(NSInteger)lastCount;
@end

NS_ASSUME_NONNULL_END
