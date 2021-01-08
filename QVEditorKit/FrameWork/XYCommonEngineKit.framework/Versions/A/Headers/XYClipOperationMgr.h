//
//  XYClipOperationMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import <Foundation/Foundation.h>
#import "XYOperationMgrBase.h"
#import "XYEngineClassHeader.h"

@class XYClipModel;
@class XYBaseEngineTask;
@class XYEffectModel;
@class XYSegmentCallBackData;

NS_ASSUME_NONNULL_BEGIN

@protocol XYClipOperationDelegate <NSObject>

@optional

/// 扣像检测回调
/// @param playbackData 播放放回的值
- (void)segmentStateCallBack:(XYSegmentCallBackData *)playbackData;

@end


@interface XYClipOperationMgr : XYOperationMgrBase

@property (nonatomic, weak) id<XYClipOperationDelegate> clipDelegate;
@property (nonatomic, assign) NSInteger clipsTotalDuration;

@property (nonatomic, copy) NSArray <XYClipModel *> *clipModels;//获取所有clip信息

/// 播放器暂停是否开启分割预加载
/// @param isEnable isEnable YES：为开启 NO：为关闭 默认时关闭状态
- (void)playerStopPreDetectionEnable:(BOOL)isEnable;
- (XYClipModel *)fetchClipModelWithIdentifier:(NSString *)identifier;//从clip的identifier 来获取clipmodel
- (void)removeClipModelWithIdentifier:(NSString *)identifier;
- (XYClipModel *)fetchClipModelObjectAtIndex:(NSUInteger)idx;
- (void)runTask:(XYClipModel *)clipModel;
- (void)runTaskToMore:(NSArray <XYClipModel *> *)clipModels;//应用多个或者全部

- (void)runTask:(XYClipModel *)clipModel
completionBlock:(XYTaskCompletionBlock)completionBlock;
- (void)runTaskToMore:(NSArray <XYClipModel *> *)clipModels completionBlock:(XYTaskCompletionBlock)completionBlock;//应用多个或者全部
@end

NS_ASSUME_NONNULL_END
