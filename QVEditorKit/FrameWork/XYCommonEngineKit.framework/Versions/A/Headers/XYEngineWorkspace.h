//
//  XYCommonEngineManager.h
//  AWSCore
//
//  Created by 夏澄 on 2019/10/11.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"
#import "XYEngineWorkspaceConfiguration.h"

@class XYClipOperationMgr;
@class XYEffectOperationMgr;
@class XYStordboardOperationMgr;
@class XYQProjectOperatonMgr;
@class XYStoryboard;
@class XYClipModel;
@class XYEngineUndoMgr;
@class XYProjectExportMgr;

NS_ASSUME_NONNULL_BEGIN

@protocol XYEngineWorkspaceDataSource <NSObject>

/// 是否是在中国 可有ip、语言、国家码等来确定
- (BOOL)engingCountryIsInChina;

@end

@interface XYEngineWorkspace : NSObject

@property (nonatomic, weak) id <XYEngineWorkspaceDataSource> dataSource;

@property (nonatomic, assign) BOOL isPrebackWorkspace;//切换会正式工作站的前处理中
@property (nonatomic, assign) XYEngineUndoActionState undoActionState;
@property (nonatomic, assign) NSInteger backWorkspaceseekPosition;

+ (XYEngineWorkspace *)space;

+ (void)addObserver:(id _Nonnull )observer taskID:(XYCommonEngineTaskID)taskID block:(void (^)(id obj))block;

+ (void)removeObserver:(id _Nonnull )observer taskID:(XYCommonEngineTaskID)taskID;

+ (void)initializeWithConfig:(XYEngineWorkspaceConfiguration *(^)(XYEngineWorkspaceConfiguration *config))configBlock;
+ (void)updateWithConfig:(XYEngineWorkspaceConfiguration *(^)(XYEngineWorkspaceConfiguration *config))configBlock;
+ (XYClipOperationMgr *)clipMgr;

+ (XYEffectOperationMgr *)effectMgr;

+ (XYStordboardOperationMgr *)stordboardMgr;

+ (XYQProjectOperatonMgr *)projectMgr;

+ (XYEngineUndoMgr *)undoMgr;

+ (XYProjectExportMgr *)exportMgr;


+ (void)reloadAllData;//刷新所有内存数据
+ (void)cleanAllData;

+ (XYStoryboard *)currentStoryboard;

+ (BOOL)isTempWorkspace;

//临时的工作站 代码需要优化 sunshine
+ (void)switchWorkspaceWithClipModel:(XYClipModel *)clipModel block:(void (^)(BOOL succ))block;//切换引擎工作站到临时状态

//在back 前处理
+ (void)preBackWorkSpace:(void (^)(BOOL succ))block;
+ (void)backWorkspace:(void (^)(BOOL succ))block;//恢复引擎工作站

+ (void)pause;

+ (void)resume;

+ (BOOL)projectIsBelow:(NSString *)appVersion;

+ (void)clean;

+ (CGFloat)outPutResolutionWidth;

@end

NS_ASSUME_NONNULL_END
