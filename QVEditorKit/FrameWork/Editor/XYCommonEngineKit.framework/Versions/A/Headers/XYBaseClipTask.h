//
//  XYBaseClipTask.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYBaseEngineTask.h"
#import "XYClipModel.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYEffect.h"
#import "XYStoryboard+XYClip.h"

@class XYAdjustEffectValueModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYBaseClipTask : XYBaseEngineTask

@property (nonatomic, assign) BOOL isNeedSetAdjustEffectValue;//是否需要将改动的值带给reload 后的clipModel 用于效果重新计算

@property(nonatomic, copy) NSArray <XYClipModel *> *clipModels;

- (void)enumerateObjectsUsingBlock:(void (NS_NOESCAPE ^)(XYClipModel *obj, NSUInteger idx, BOOL *stop))userBlock;


@end

NS_ASSUME_NONNULL_END
