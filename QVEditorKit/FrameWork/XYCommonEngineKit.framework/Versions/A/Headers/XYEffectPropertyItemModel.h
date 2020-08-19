//
//  XYEffectPropertyItemModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/7/30.
//

#import <Foundation/Foundation.h>
#import "XYBaseKeyFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectPropertyKeyInfo: XYBaseKeyFrame
/// 关键帧值
@property (nonatomic, assign) CGFloat value;

@end

@interface XYEffectPropertyItemModel : NSObject

/// 设置value的key
@property (nonatomic, assign) NSInteger valueKey;

/// 最小值
@property (nonatomic, assign) NSInteger minValue;

/// 最大值
@property (nonatomic, assign) NSInteger maxValue;

/// 当前的值
@property (nonatomic, assign) NSInteger value;

/// 关键帧标识符 name
@property (nonatomic, copy) NSString *name;

/// 步长
@property (nonatomic, assign) NSInteger step;

/// 1：开关 2：枚举值 3：有限区间 4：无限区间 5：颜色值R通道 6：颜色值G通道 7：颜色值B通道 8：颜色值A通道
@property (nonatomic, assign) NSInteger controlType;

@property (nonatomic, assign) BOOL isUnlimitedMode;

///  是否支持关键帧
@property (nonatomic, assign) BOOL isSupportKeyframe;

/// 单位
@property (nonatomic, assign) NSInteger unit;

/// 精度 0：（默认）1：十分比 2：百分比 3：千分比 4：万分比
@property (nonatomic, assign) NSInteger precision;
@property (nonatomic, assign) NSInteger adjustPos;

/// 通配符
@property (nonatomic, copy) NSString *wildCards;//通配符

/// subItemType 值范围 5000 - 6000
@property (nonatomic, assign) NSInteger subItemType;

/// 关键帧列表
@property (nonatomic, strong) NSMutableArray <XYEffectPropertyKeyInfo *> *keyFrameList;

@end

NS_ASSUME_NONNULL_END
