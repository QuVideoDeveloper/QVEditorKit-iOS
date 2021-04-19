//
//  XYEffectOperationMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import <Foundation/Foundation.h>
#import "XYOperationMgrBase.h"
#import "XYEngineEnum.h"
#import "XYEngineClassHeader.h"


@class XYEffectModel, XYEffectVisionModel, XYEffectVisionKeyFrameModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectOperationMgr : XYOperationMgrBase

@property (nonatomic, copy) NSArray <XYEffectModel *> *allEffects;

- (NSArray <XYEffectModel *> *)effectModels:(XYCommonEngineGroupID)groupType;//根据groupID 获取效果列表
- (XYEffectModel *)fetchEffectModelOnTopByTouchPoint:(CGPoint)touchPoint seekPosition:(NSInteger)seekPosition;//根据时间和位置来获取效果
- (XYEffectModel *)fetchEffectModel:(XYCommonEngineGroupID)groupType identifier:(NSString *)identifier;
- (XYEffectModel *)fetchEffectModel:(NSString *)identifier;
- (NSArray <XYEffectModel *> *)fetchEffectModel:(XYCommonEngineGroupID)groupType filePath:(NSString *)filePath;
- (void)fetchKeyFrameModel:(NSString *)identifier seekPosition:(NSInteger)seekPosition block:(void (^)(XYEffectVisionKeyFrameModel *keyFramModel))block;
- (void)fetchFacePasterVisionModel:(NSString *)identifier block:(void (^)(XYEffectVisionModel *visionModel))block;
- (void)fetchKeyFrameModelWithEffectModel:(XYEffectModel *)effectModel seekPosition:(NSInteger)seekPosition block:(void (^)(XYEffectVisionKeyFrameModel *keyFramModel))block;

- (void)runTask:(XYEffectModel *)effectModel;
- (void)runTaskToMore:(NSArray <XYEffectModel *> *)effectModels;//应用多个或者全部

- (void)runTask:(XYEffectModel *)effectModel
completionBlock:(XYTaskCompletionBlock)completionBlock;
- (void)runTaskToMore:(NSArray <XYEffectModel *> *)effectModels completionBlock:(XYTaskCompletionBlock)completionBlock;//应用多个或者全部

@end

NS_ASSUME_NONNULL_END
