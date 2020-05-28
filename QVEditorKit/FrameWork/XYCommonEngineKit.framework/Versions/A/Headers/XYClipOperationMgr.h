//
//  XYClipOperationMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import <Foundation/Foundation.h>
#import "XYOperationMgrBase.h"

@class XYClipModel;
@class XYBaseEngineTask;
@class XYEffectModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYClipOperationMgr : XYOperationMgrBase

@property (nonatomic, assign) NSInteger videoDuration;

@property (nonatomic, copy) NSArray <XYClipModel *> *clipModels;

- (XYEffectModel *)fetchEffectModelOnTopByTouchPoint:(CGPoint)touchPoint seekPosition:(NSInteger)seekPosition;
- (XYClipModel *)fetchClipModelWithIdentifier:(NSString *)identifier;//从timeline交互 来获取clipmodel 必须用此方法
- (XYClipModel *)fetchClipModelObjectAtIndex:(NSUInteger)idx;//此方法用处 如 播放器的seek时获取到index 或者播放器的回调根据时间取到index //会包含片头 片尾
- (void)removeClipModelWithIdentifier:(NSString *)identifier;

- (void)runTask:(XYClipModel *)clipModel;
- (void)runTaskToMore:(NSArray <XYClipModel *> *)clipModels;//应用多个或者全部

@end

NS_ASSUME_NONNULL_END
