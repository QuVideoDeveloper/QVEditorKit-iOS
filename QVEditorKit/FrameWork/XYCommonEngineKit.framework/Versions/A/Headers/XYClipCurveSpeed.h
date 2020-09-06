//
//  XYClipCurveSpeed.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/8/21.
//

#import <Foundation/Foundation.h>

@class XYPoint;

NS_ASSUME_NONNULL_BEGIN

@interface XYClipCurveSpeed : NSObject

///加速上限，实际可变范围为[1/iMaxScale, iMaxScale]
@property (nonatomic, assign) NSInteger iMaxScale;

/**
 * 曲线变速的控制点位，x表示时间轴，y表示对应的加速倍速，x取值范围[0, 100],y取值范围[1,100]；
 * x是原时间均分成100等份后的归一化值，y在[1,50]范围内对应实际加速倍速[1/iMaxScale, 1]的映射值; [51, 100]范围内对应实际加速倍速[1, iMaxScale]的映射值；
 * points至少需要2个点，且第一个点和最后一个点的x值必须为0和100，即表示整段视频长度，x取值必须递增，y值可以相等；
 * 实际的变速曲线会根据每两个点的生成一段正弦曲线，如果2个点的y值相同即为定值变速；
 */

@property (nonatomic, strong) NSMutableArray <XYPoint *> *mSpeedPoints;

@end

NS_ASSUME_NONNULL_END
