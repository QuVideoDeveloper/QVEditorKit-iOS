//
//  XYEffectVisionModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/8.
//

#import "XYEffectModel.h"

@class XYEffectPicInPicOverlayInfo, XYEffectPicInPicMaskInfo, XYEffectPicInPicChromaInfo, XYEffectPicInPicFilterInfo, XYEffectPicInPicSubFx, XYAdjustItem, XYEffectKeyFrameInfo;

NS_ASSUME_NONNULL_BEGIN


/// 关键帧model
@interface XYEffectVisionKeyFrameModel : XYBaseCopyModel

@property (nonatomic, assign) NSInteger position;//时间点，单位ms
@property (nonatomic, assign) NSInteger rotation;//旋转角度 0 - 360
@property (nonatomic, assign) CGPoint centerPoint;//中心点坐标
@property (nonatomic, assign) float width;//效果宽度
@property (nonatomic, assign) float height;//效果高度

@property (nonatomic, assign) BOOL needUpdateFrameModelLater;//是否需要在设置到引擎之前再次更新

@end



/// 视觉类效果的model
@interface XYEffectVisionModel : XYEffectModel
@property (nonatomic, assign) CGFloat defaultWidth; //默认宽度，素材中提取
@property (nonatomic, assign) CGFloat defaultHeight; //默认高度，素材中提取
@property (nonatomic, assign) BOOL reCalculateFrame; // YES不管当前宽高，重新计算宽高
@property (nonatomic, assign) CGFloat width; //当前宽度
@property (nonatomic, assign) CGFloat height; //当前高度
@property (nonatomic, assign) CGFloat maxWidth; //最大的宽
@property (nonatomic, assign) CGPoint centerPoint; //相对于播放界面的中心点坐标
@property (nonatomic, assign) NSInteger rotation; //旋转角度，顺时针 0 - 360
@property (nonatomic, assign) CGFloat alpha; //透明度，默认1.0
@property (nonatomic, assign) CGFloat propData; //程度调节，默认1.0
@property (nonatomic, assign) BOOL hasAudio; //是否带音效
@property (nonatomic, assign) BOOL verticalReversal; //竖直翻转
@property (nonatomic, assign) BOOL horizontalReversal; //水平翻转
@property (nonatomic, assign) CGPoint anchor; //锚点,(0,0)为效果的左上角位置，（0.5，0.5）表示效果的中心，（1.0，1.0）表示效果的右下角。默认是(0.5,0.5) 。取值范围是0~1
@property (nonatomic, assign) BOOL isFrameMode; //YES的情况下，应用到全透明的Storyboard上也是透明的，否则背景会变黑
@property (nonatomic, assign) BOOL defaultIsStaticPicture; //该视觉效果默认是否静态
@property (nonatomic, assign) BOOL isStaticPicture; //YES的情况下，该效果将会静态展示
@property (nonatomic, assign) BOOL isInstantRefresh; //YES的情况下，该效果将会快速刷新
@property (nonatomic, strong) XYEffectKeyFrameInfo *keyFrameInfo;
@property (nonatomic, strong) NSArray<XYEffectVisionKeyFrameModel *> *keyFrames; //关键帧数组
@property (nonatomic) CGFloat currentScale; //根据当前宽度和dafault宽度自动计算当前放大倍数，只读
@property (nonatomic, assign) BOOL isResetLayerID;//是否只是resetLayerID
@property (nonatomic, assign) NSInteger previewDuration;//动画预览时长
@property (nonatomic, assign) NSInteger volume;//效果的音量（只有特效和视频画中画才有作用）

@property (nonatomic, strong) XYEffectPicInPicOverlayInfo *overlayInfo; //画中画 透明度
@property (nonatomic, strong) XYEffectPicInPicMaskInfo *maskInfo; //画中画 蒙版
@property (nonatomic, strong) XYEffectPicInPicChromaInfo *chromaInfo; //画中画 抠色信息数据（绿幕）
@property (nonatomic, strong) XYEffectPicInPicFilterInfo *filterInfo; //画中画 滤镜
@property (nonatomic, strong) NSMutableArray <XYEffectPicInPicSubFx *> *fxInfoList; //画中画 特效
@property (nonatomic, copy) NSArray <XYAdjustItem *> *adjustItems;// 画中画 参数调节

/// 根据引擎万分比计算视觉效果在播放区域显示的rect
/// @param regionRect 引擎万分比
/// @param previewSize 播放区域Size
- (CGRect)rcDisplayRegionToVisionViewRect:(MRECT)regionRect previewSize:(CGSize)previewSize;


/// MRECT转换成CGRect
/// @param mRect MRECT
- (CGRect)cgRectFromMRect:(MRECT)mRect;

#pragma mark - 关键帧
/// 添加一个关键帧
/// @param position 当前时间点
- (void)addNewKeyFrame:(NSInteger)position;

/// 更新当前时间点上的关键帧
/// @param position 当前时间点
- (void)updateKeyFrame:(NSInteger)position;


/// 模版更新后，更新所有关键帧
/// @param oldDefaultWidth 原模版的默认宽
/// @param newDefaultWidth 新模版的默认宽
/// @param newDefaultHeight 新模版的默认高
- (void)updateAllKeyFramesWithOldDefaultWidth:(CGFloat)oldDefaultWidth newDefaultWidth:(CGFloat)newDefaultWidth newDefaultHeight:(CGFloat)newDefaultHeight;

/// 删除一个关键帧
/// @param position 当前时间点
- (void)deleteKeyFrame:(NSInteger)position;

@end

NS_ASSUME_NONNULL_END
