//
//  XYBaseKeyFrame.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/19.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

@class XYKeyBezierCurve;

NS_ASSUME_NONNULL_BEGIN

@interface XYBaseKeyFrame : NSObject

/// 关键帧类型
@property (nonatomic, assign) XYKeyFrameType keyFrameType;

/// 相对offset 做操作的类型 默认做加法操作
@property (nonatomic, assign) XYKeyFrameOffsetOpcodeType offsetOpcodeType;

/// 变化方式 普通线性插值还是贝塞尔
@property (nonatomic, assign) XYMethodKeyFrameType methodType;

/// 整体偏移，相对关键帧的整体偏移，defalut = 1
@property (nonatomic, assign) CGFloat offsetValue;

/// 相对于效果入点的时间
@property (nonatomic, assign) NSInteger relativeTimePos;

/// 关键帧是否曲线路径
@property (nonatomic, assign) BOOL isCurvePath;

/// 关键帧缓动贝塞尔曲线点
@property (nonatomic, strong) XYKeyBezierCurve *mKeyBezierCurve;

@end

NS_ASSUME_NONNULL_END
