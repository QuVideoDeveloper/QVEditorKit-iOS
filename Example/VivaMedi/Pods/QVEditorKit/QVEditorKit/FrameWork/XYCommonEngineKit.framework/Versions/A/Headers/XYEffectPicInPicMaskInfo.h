//
//  XYEffectMaskInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/15.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectPicInPicMaskInfo : NSObject

/// 蒙版类型
@property (nonatomic, assign) XYEffectMaskType maskType;

/// 中心点 在streamSize的坐标系中，中心点尽量保持在素材位置内
@property (nonatomic, assign) CGPoint centerPoint;

/// 水平方向半径，在streamSize的坐标系中
@property (nonatomic, assign) CGFloat radiusX;

/// 垂直方向半径，在streamSize的坐标系中
@property (nonatomic, assign) CGFloat radiusY;

/// 旋转角度， 0~360
@property (nonatomic, assign) CGFloat rotation;

/// 羽化程度，取值范围：[0~10000]
@property (nonatomic, assign) NSInteger softness;

/// 是否反选
@property (nonatomic, assign) BOOL reverse;

@end

NS_ASSUME_NONNULL_END
