//
//  XYKeyBezierCurve.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYKeyBezierCurve : NSObject

/// 贝塞尔缓动曲线Id
@property (nonatomic, assign) NSInteger bezierCurveId;

/// 贝塞尔缓动曲线起点,需固定（ 0，0）
@property (nonatomic, assign) CGPoint start;

/// 贝塞尔缓动曲线终点,需固定（ 10000，10000）
@property (nonatomic, assign) CGPoint stop;

/// 贝塞尔缓动节点1
@property (nonatomic, assign) CGPoint c0;

/// 贝塞尔缓动节点2
@property (nonatomic, assign) CGPoint c1;

@end

NS_ASSUME_NONNULL_END
