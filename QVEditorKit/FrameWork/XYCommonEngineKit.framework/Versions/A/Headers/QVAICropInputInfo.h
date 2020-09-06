//
//  QVAICropInputInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/8/28.
//

typedef NS_ENUM(NSInteger,  QVAICropPaddingType) {
    QVAICropPaddingBorderBlack = 0, //黑边
    QVAICropPaddingBorderWhite, //白边
    QVAICropPaddingBorderMean, //参考附近原始图像的颜色自动决定补边颜色，过渡区域加羽化融合
    QVAICropPaddingBorderBlur //附近原始图像的高斯模糊用于补边，边缘图像模糊并轻微放大作为填充

};

typedef NS_ENUM(NSInteger,  QVAICropType) {
    QVAICropTypeMaxImageContent = 0, //远景模式(最大化保留图像信息模式)，这种模型下裁切区域越大越好，至少有一边边长等于输入图像边长
    QVAICropTypeMaxImageRegion //近景模式(最大化目标区域信息模式)，这种模式下仅保留优选出来的感兴趣区域，无用的图像信息会被丢弃
};


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QVAICropInputInfo : NSObject

/// 输入图像数据
@property (nonatomic, strong) UIImage *inputImage;

/// 是否使用目标物体检测信息 如人体检测
@property (nonatomic, assign) BOOL isUseObjectInfo;

/// 是否使用人脸检测信息
@property (nonatomic, assign) BOOL isUseFaceInfo;

/// 是否使用显著性检测信息
@property (nonatomic, assign) BOOL isUseSalientInfo;

/// 裁剪模式 近景还是远景模式 默认远景模式
@property (nonatomic, assign) QVAICropType cropType;

/// 是否允许内部进行图像补边，如果允许padding，裁切框有可能超出图片 默认不支持padding
@property (nonatomic, assign) BOOL isAllowPadding;

/// 如果允许补边，补边大小与原始边长的比例上限,推荐0.3~0.8 默认0.5
@property (nonatomic, assign) CGFloat paddingRatio;

/// 补边方式可选balck, white, mean, blur 默认黑边
@property (nonatomic, assign) QVAICropPaddingType paddingType;

@end

NS_ASSUME_NONNULL_END
