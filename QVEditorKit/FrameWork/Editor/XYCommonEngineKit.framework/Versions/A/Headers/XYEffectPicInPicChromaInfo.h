//
//  XYEffectChromaInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/15.
//

#import "XYEffectBasePicInPicInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectPicInPicChromaInfo : XYEffectBasePicInPicInfo

/// 是否删除此效果
@property (nonatomic, assign) BOOL isDelete;

///抠色的颜色值, 如0xFFFFFF
@property (nonatomic, assign) NSInteger colorHexValue;

/// 抠色的精度（0~100）
@property (nonatomic, assign) CGFloat accuracy;

/// 是否自动去除画中画纯背景色
@property (nonatomic, assign) BOOL isAutoMaskBgColor;

///画中画选中的坐标 相对画中画的坐标
@property (nonatomic, assign) CGPoint selectPoint;

@end

NS_ASSUME_NONNULL_END
