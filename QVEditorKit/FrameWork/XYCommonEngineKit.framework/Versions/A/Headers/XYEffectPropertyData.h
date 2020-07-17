//
//  XYEffectPropertyData.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYBaseCopyModel.h"

@class XYStoryboard;
@class XYClipModel;

typedef NS_ENUM(NSInteger, XYCommonEnginebackgroundType) {
    XYCommonEngineBackgroundNormal = 0,//没有使用背景
    XYCommonEngineBackgroundBlur,//模糊背景，也可以用E、F代替
    XYCommonEngineBackgroundColor,//颜色背景模板
    XYCommonEngineBackgroundImage,//（图片背景[10~100]）e
  //（图片背景[0-10]）
};

typedef NS_ENUM(NSInteger, XYCommonEngineRatioFitType) {
    XYCommonEngineRatioFitNormal = 0,
    XYCommonEngineRatioFitIn,
    XYCommonEngineRatioFitOut,
};

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectPropertyData : XYBaseCopyModel
@property (nonatomic, assign) XYCommonEngineRatioFitType fitType;
@property (nonatomic, assign) CGFloat backgroundBlurValue;//背景模糊 值范围 0 - 100
@property (nonatomic, assign) NSInteger linearGradientAngle; //线性渐变的旋转角度 默认为水平方向，取值范围：0~360，对应的角度：0~360，单位为°
@property (nonatomic, copy) NSArray *backgroundColorList;//严格要求排序是起始颜色 中间颜色 结束颜色   数组里的对象  格式（0Xffffff）

@property (nonatomic, copy) NSString *backImagePath;//设置背景图片。参数 1. clipPropertyData.backImagePath 设置默认背景图片 传nil
//缩放 移动 旋转 需要的参数。 一、缩放 需要的参数 scaleX scaleY (没做缩放默认值是1)
@property (nonatomic, assign) CGFloat scale;

/// 是否镜像 YES：为镜像，NO：非镜像
@property (nonatomic, assign) BOOL isMirror;//Y轴镜像
//旋转 angleZ 0~360，没做旋转默认是0
@property (nonatomic, assign) NSInteger angleZ;
//移动 需要的参数 1.shiftX 2.shiftY（没做移动默认值都是1,shiftX 是移动的X除以播放器的的宽(streamSize.width) + 原来的shiftX,shiftY同理）
@property (nonatomic, assign) CGFloat shiftX;
@property (nonatomic, assign) CGFloat shiftY;
@property (nonatomic, assign) BOOL isAnimationON;

@property(nonatomic, assign) XYCommonEnginebackgroundType effectType;
- (void)load:(XYStoryboard *)storyboard clipModel:(XYClipModel *)clipModel;
- (void)refresh;

@end

NS_ASSUME_NONNULL_END
