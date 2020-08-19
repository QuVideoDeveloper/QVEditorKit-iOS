//
//  XYSlideShowTransformModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/5/9.
//

#import <Foundation/Foundation.h>
#import "XYSlideShowEnum.h"
#import "CXiaoYingInc.h"

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

//移动 需要的参数 1.shiftX 2.shiftY（没做移动默认值都是1,shiftX 是移动的X除以播放器的的宽(streamSize.width) + 原来的shiftX,shiftY同理）
@property (nonatomic) CGFloat shiftX;
@property (nonatomic) CGFloat shiftY;

@property (readwrite, nonatomic) CXIAOYING_TRANSFORM_PARAMETERS engineTransform;

@end

NS_ASSUME_NONNULL_END
