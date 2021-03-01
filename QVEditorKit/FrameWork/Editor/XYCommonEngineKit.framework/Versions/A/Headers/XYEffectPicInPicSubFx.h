//
//  XYEffectSubFx.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/15.
//

#import "XYEffectBasePicInPicInfo.h"

@class XYVeRangeModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectPicInPicSubFx : XYEffectBasePicInPicInfo

/// 子特效素材路径
@property (nonatomic, copy) NSString *subFxPath;

/// 子特效索引，不可修改 范围1000 - 2000
@property (nonatomic, assign) NSInteger subType;

/// 子特效出入点区间，相对效果的时间
@property (nonatomic, strong) XYVeRangeModel *destRange;

@end

NS_ASSUME_NONNULL_END
