//
//  XYAdjustEffectSyncValueModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/27.
//

#import <Foundation/Foundation.h>

@class XYVeRangeModel;

typedef NS_ENUM(NSInteger, XYAdjustEffectType) {
    XYAdjustEffectTypeNone = 0,
    XYAdjustEffectTypeCut,
    XYAdjustEffectTypeTrim,
    XYAdjustEffectTypeSpeed,
};

NS_ASSUME_NONNULL_BEGIN

@interface XYAdjustEffectValueModel : NSObject // task 执行需要带过来的数据
@property (nonatomic, assign) XYAdjustEffectType adjustType;
@property (nonatomic, strong) XYVeRangeModel *preTrimModel;//cut trim 之前的range
@property (nonatomic, assign) CGFloat preSpeedValue;//变速之前 之前的speedValue
@property (nonatomic, copy) NSString *clipIdentifier;//clip唯一标识符 对那个clip操作
@property (nonatomic, copy) NSArray <XYVeRangeModel*> *rangeModels;
@end

NS_ASSUME_NONNULL_END
