//
//  XYBaseEffectVisionTask.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/8.
//

#import "XYBaseEffectTask.h"

@class XYEffectVisionModel, XYEffectVisionTextModel, XYEffectVisionKeyFrameModel, XYColorCurveInfo, XYColorCurveItem;

NS_ASSUME_NONNULL_BEGIN

@interface XYBaseEffectTaskVision : XYBaseEffectTask

#pragma mark - Basic

/// 获取一个新的图层ID
- (float)newEffectLayerId:(XYEffectVisionModel *)effectModel;

#pragma mark - Text
/// 从模版中获取信息并更新XYEffectVisionTextModel
/// @param templateFilePath 模版路径
/// @param effectVisionTextModel 字幕的model
- (void)updateEffectVisionTextModelByTemplate:(NSString *)templateFilePath effectVisionTextModel:(XYEffectVisionTextModel *)effectVisionTextModel fullLanguage:(NSString *)fullLanguage;


/// 根据当前信息更新s字幕的宽高数据
/// @param effectVisionTextModel 字幕的model
- (void)updateTextSizeInEffectVisionTextModel:(XYEffectVisionTextModel *)effectVisionTextModel;

/// 将XYEffectVisionTextModel转换成TextInfo
/// @param effectVisionTextModel 字幕的model
- (XYMultiTextInfo *)mapToTextInfo:(XYEffectVisionTextModel *)effectVisionTextModel;


#pragma mark - Sticker
/// 从模版中获取信息并更新XYEffectVisionModel
/// @param templateFilePath 模版路径
/// @param effectVisionModel 视觉效果的model
- (void)updateEffectVisionStickerModelByTemplate:(NSString *)templateFilePath effectVisionModel:(XYEffectVisionModel *)effectVisionModel;

/// 将XYEffectVisionModel转换成StickerInfo
/// @param effectVisionModel 视觉效果的model
- (StickerInfo *)mapToStickerInfo:(XYEffectVisionModel *)effectVisionModel;


#pragma mark - KeyFrame
/// 设置关键帧
/// @param keyFrames 要设置进去的关键帧数组，空的话就是清除所有关键帧
/// @param effectVisionModel 关键帧所在effectModel
- (void)setKeyFrames:(NSArray<XYEffectVisionKeyFrameModel *> *)keyFrames
   effectVisionModel:(XYEffectVisionModel *)effectVisionModel;


#pragma mark - Utils
/// 检查是否是一个模版文件
/// @param filePath 待检查的模版文件路径
- (BOOL)isTemplateFilePath:(NSString *)filePath;

/// 从XYEffectVisionModel获取预览区域的尺寸
/// @param effectVisionModel 视觉效果的model
- (CGSize)previewSizeFromEffectVisionModel:(XYEffectVisionModel *)effectVisionModel;

/// 从XYEffectVisionModel获取rcDispRegion用于设置到引擎
/// @param effectVisionModel 视觉效果的model
/// @param previewSize 画预览区域Size
- (MRECT)rcDispRegionFromEffectModel:(nonnull XYEffectVisionModel *)effectVisionModel previewSize:(CGSize)previewSize;


/// 从XYEffectVisionModel获取rcDispRegion用于设置到引擎
/// @param centerPoint 效果中心点
/// @param width 效果宽
/// @param height 效果高
/// @param previewSize 画预览区域Size
- (MRECT)rcDispRegionFromCenterPoint:(CGPoint)centerPoint
                               width:(CGFloat)width
                              height:(CGFloat)height
                         previewSize:(CGSize)previewSize;

/// 设置锚点属性
/// @param effectVisionModel effectVisionModel
- (void)setAnchor:(nonnull XYEffectVisionModel *)effectVisionModel;

///设置混合模板及透明度
/// @param effectVisionModel effectVisionModel
- (CXiaoYingEffect *)setEffectOverlayInfo:(nonnull XYEffectVisionModel *)effectVisionModel;

///设置混合蒙版
- (void)setEffectMaskInfo:(nonnull XYEffectVisionModel *)effectVisionModel;

/// 设置画中画滤镜
/// @param effectVisionModel effectVisionModel
- (void)setEffectFilter:(nonnull XYEffectVisionModel *)effectVisionModel;

/// 设置画中画特效
/// @param effectVisionModel effectVisionModel
- (void)setEffectSubFX:(nonnull XYEffectVisionModel *)effectVisionModel;

/// 设置画中画动画滤镜
/// @param effectVisionModel effectVisionModel
- (void)setEffectAnimFilter:(nonnull XYEffectVisionModel *)effectVisionModel;

/// 设置画中画滤镜参数调节
/// @param effectVisionModel effectVisionModel
- (void)setEffectSubAdjust:(nonnull XYEffectVisionModel *)effectVisionModel;

/// 计算旋转后的位置
/// @param oldPoint oldPoint
/// @param centerPoint centerPoint
+ (CGPoint)calcNewPoint:(CGPoint)oldPoint
            centerPoint:(CGPoint)centerPoint
               rotation:(CGFloat)rotation;

/// 设置更新关键帧
/// @param effectVisionModel effectVisionModel
- (void)handleSetEffectKeyFrameInfo:(XYEffectVisionModel *)effectVisionModel;

/// 设置更新关键帧整体偏移量 修改对应关键帧的 也可以单独更新
/// @param effectVisionModel effectVisionModel offsetValue
- (void)updateEffectKeyFrameOffset:(XYEffectVisionModel *)effectVisionModel;

/// 设置3d信息
/// @param effectVisionModel effectVisionModel
 - (void)set3DTransform:(XYEffectVisionModel *)effectVisionModel;

/// 设置画中画效果插件
/// @param effectVisionModel effectVisionModel
- (void)setEffectEffectPlugin:(nonnull XYEffectVisionModel *)effectVisionModel;

/// 设置画中画曲线变色
/// @param effectVisionModel effectVisionModel
- (void)setEffectEffectCurveColor:(nonnull XYEffectVisionModel *)effectVisionModel;

+ (NSMutableArray<XYColorCurveItem *> *)fetchCurveColorInfo:(CXiaoYingEffect *)colorCurveEffect;
+ (void)updateCurveColor:(CXiaoYingEffect *)colorCurveEffect colorCurveInfo:(XYColorCurveInfo *)colorCurveInfo;

- (void)updateLayerID:(XYEffectVisionModel *)effectModel;

+ (void)updateEffect3DTransform:(CXiaoYingEffect *)pEffect size:(XYVe3DDataF *)size center:(XYVe3DDataF *)center;
@end

NS_ASSUME_NONNULL_END
