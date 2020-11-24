//
//  XYDrawLayerPaintPenInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/11/13.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,  XYDrawLayerState) {
    XYDrawLayerStateBegan = 0,
    XYDrawLayerStateChange,
    XYDrawLayerStateEnd,
};

@interface XYDrawLayerPaintPenInfo : NSObject

@property(nonatomic, assign) XYDrawLayerState drawLayerState;

/// 画笔类型
@property(nonatomic, readwrite) XYDrawPaintType dwPenType;

/// 线条的颜色 16进制值 格式0xABGR 0xFFFFFFFF
@property(nonatomic, readwrite) NSInteger dwLineColor;

/// 0 实线 1 虚线
@property(nonatomic, readwrite) NSInteger dwLineType;

/// 线条的粗细程度, 相对于底图的百分比，例如底图宽度720， 真实的Thickness=720*fLineThickness
@property(nonatomic, readwrite) CGFloat fLineThickness;

/// 相对于底图的百分比 例如底图宽度720， 真实的虚线的长度是=720*fDottedLine
@property(nonatomic, readwrite) CGFloat fDottedLine;

/// 是否开启发光
@property(nonatomic, readwrite) BOOL  bEnableLight;

/// 发光的宽度， 相对于底图的百分比 例如底图宽度720， 真实的发光半径是=720*fLightRadius
@property(nonatomic, readwrite) CGFloat fLightRadius;

/// 发光的颜色 16进制值 格式0xABGR 0xFFFFFFFF
@property(nonatomic, readwrite) NSInteger dwLightColor;

/// 边缘羽化程度 0~1； 边缘羽化只有在开启发光或者擦出功能才会有作用
@property(nonatomic, readwrite) CGFloat fEdgeFeathering;

/// 画的点信息
@property(nonatomic, assign) CGPoint drawPoint;

@end

NS_ASSUME_NONNULL_END
