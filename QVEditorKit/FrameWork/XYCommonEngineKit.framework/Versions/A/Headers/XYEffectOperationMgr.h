//
//  XYEffectOperationMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import <Foundation/Foundation.h>
#import "XYOperationMgrBase.h"
#import "XYEngineEnum.h"


@class XYEffectModel;
@class XYEffectVisionKeyFrameModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectOperationMgr : XYOperationMgrBase

@property (nonatomic, copy) NSArray <XYEffectModel *> *allEffects;

- (NSArray <XYEffectModel *> *)effectModels:(XYCommonEngineGroupID)groupType;

- (XYEffectModel *)fetchEffectModel:(XYCommonEngineGroupID)groupType identifier:(NSString *)identifier;
- (XYEffectModel *)fetchEffectModelOnTopByTouchPoint:(CGPoint)touchPoint seekPosition:(NSInteger)seekPosition;
- (XYEffectModel *)fetchEffectModel:(NSString *)identifier;
- (NSArray <XYEffectModel *> *)fetchEffectModel:(XYCommonEngineGroupID)groupType filePath:(NSString *)filePath;
- (void)fetchKeyFrameModel:(NSString *)identifier seekPosition:(NSInteger)seekPosition block:(void (^)(XYEffectVisionKeyFrameModel *keyFramModel))block;//异步 会抛到引擎队列 业务调用

- (XYEffectVisionKeyFrameModel *)fetchKeyFrameModel:(NSString *)identifier seekPosition:(NSInteger)seekPosition;//同步 ⚠️只指给引擎内部调用


- (void)runTask:(XYEffectModel *)effectModel;
- (void)runTaskToMore:(NSArray <XYEffectModel *> *)effectModels;//应用多个或者全部
- (void)adjustEffect:(XYCommonEngineTaskID)taskID;

@end

NS_ASSUME_NONNULL_END
