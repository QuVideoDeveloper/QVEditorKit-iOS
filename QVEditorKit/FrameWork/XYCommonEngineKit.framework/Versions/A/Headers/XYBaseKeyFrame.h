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

/// 相对于视频的时间点
@property (nonatomic, assign) NSInteger posTime;

/// 关键帧是否曲线路径
@property (nonatomic, assign) BOOL isCurvePath;

/// 关键帧缓动贝塞尔曲线点
@property (nonatomic, strong) XYKeyBezierCurve *mKeyBezierCurve;

@end

NS_ASSUME_NONNULL_END
