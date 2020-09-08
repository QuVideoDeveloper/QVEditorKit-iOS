//
//  XYBaseEngineTask.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"
#import "XYCommonEngineGlobalData.h"

typedef NS_ENUM(NSInteger, XYEngineTaskType) {
    XYEngineTaskTypeClip,
    XYEngineTaskTypeAudio,
    XYEngineTaskTypeVision,
    XYEngineTaskTypeVisionText,
};

@class XYBaseEngineTask, XYStoryboard, XYEngine, XYEngineUndoManagerConfig, XYTaskErrorModel;

@protocol XYBaseEngineTaskDelegate <NSObject>

- (void)onEngineFinish:(XYBaseEngineTask *_Nonnull)baseTask;

@end

NS_ASSUME_NONNULL_BEGIN

@interface XYBaseEngineTask : NSObject
@property (nonatomic, copy) NSDictionary *userInfo;//用户自带的信息
@property(nonatomic, assign) BOOL dataClipReinitThumbnailManager;
@property(nonatomic, assign) XYEngineUndoActionState undoAntionState;
@property (nonatomic, strong) XYEngineUndoManagerConfig *undoConfigModel;
@property (nonatomic, assign) XYEngineTaskType engineTaskType;
@property (nonatomic, assign) XYCommonEngineTaskID taskID;
@property (nonatomic, assign) BOOL preRunTaskPlayerNeedPause;//在执行runTask的预处理是否需要暂停播放器  默认暂停
@property (nonatomic, assign) XYCommonEngineOperationCode operationCode;
@property (nonatomic, strong) CXiaoYingEffect *pEffect;
@property (nonatomic, strong) CXiaoYingClip *pClip;
@property (nonatomic, assign) XYCommonEngineGroupID groupID;
@property (nonatomic, assign) BOOL isReload;//根据 trackType groupId 刷新对应的memory的数据
@property (nonatomic, assign) XYEngineReloadTimeLineType reloadTimeLineType;//刷新timeLine 方式
@property (nonatomic, assign) BOOL succeed;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, assign) BOOL isAutoplay;//是否自动播放
@property (nonatomic, assign) BOOL isNeedCheckTrans;
@property (nonatomic, assign) BOOL adjustEffect; //是否刷新效果
@property (nonatomic, weak) XYStoryboard *storyboard;//当前的storyboard

@property (nonatomic, weak) XYStoryboard *globalStoryboard;//当前的storyboard
@property (nonatomic, assign) NSInteger seekPositon;//用于播放器指定seek 没有配置默认值是值 -1 是默认seek到当前
@property (nonatomic, weak) id<XYBaseEngineTaskDelegate> delegate;
@property (nonatomic, assign) BOOL skipReloadTimeline;//跳过刷新timeline 业务控制

@property (nonatomic, assign) BOOL needRebuildThumbnailManager;//是否需要重新创建ThumbnailManager
@property (nonatomic, assign) BOOL isInstantRefresh; //YES的情况下，该效果将会快速刷新
@property (nonatomic, assign) BOOL skipRefreshPlayer; //只需要设置值 不需要刷新播放器
@property (nonatomic, assign) BOOL skipPreprocessNotice;//跳过引擎前处理的通知

@property (nonatomic, strong) XYTaskErrorModel *errorModel;
@property (nonatomic, copy) void(^completionBlock)(BOOL success, NSError *error, id obj);
- (void)run;
- (void)engineOperate;//需要子类实现
- (void)engineOperateEnd;//需要子类实现
- (XYEngine *)engine;

@end

NS_ASSUME_NONNULL_END
