//
//  XYSlideShowTransformModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/5/9.
//

#import <Foundation/Foundation.h>
#import "XYSlideShowEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYSlideShowTransformModel : NSObject

/// 背景的类型
@property (nonatomic) XYSlideShowTransformType transformType;

/// 模糊度 值范围 0-100
@property (nonatomic) NSInteger blur;

/// 缩放大小
@property (nonatomic) CGFloat scale;

/// 旋转角度 值范围 0-360
@property (nonatomic) NSInteger rotation;

/// X方向移动的值  值范围 -10-10 个屏幕
@property (nonatomic) CGFloat shiftX;

/// Y方向移动的值  值范围 -10-10 个屏幕
@property (nonatomic) CGFloat shiftY;

/// 背景颜色R通道 值范围 0-255
@property (nonatomic) NSInteger clearR;

/// 背景颜色G通道 值范围 0-255
@property (nonatomic) NSInteger clearG;

/// 背景颜色B通道 值范围 0-255
@property (nonatomic) NSInteger clearB;

/// 背景颜色A通道 值范围 0-255
@property (nonatomic) NSInteger clearA;
/// 是否镜像 YES：为镜像，NO：非镜像
@property (nonatomic) BOOL isMirror;

@property (nonatomic) CGFloat rectL; //0-1
@property (nonatomic) CGFloat rectT; //0-1
@property (nonatomic) CGFloat rectR; //0-1
@property (nonatomic) CGFloat rectB; //0-1

@end

NS_ASSUME_NONNULL_END
