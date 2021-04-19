//
//  XYEffectVisionModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/8.
//

#import "XYEffectModel.h"

@class XYEffectPicInPicOverlayInfo, XYEffectPicInPicMaskInfo, XYEffectPicInPicChromaInfo, XYEffectPicInPicFilterInfo, XYEffectPicInPicSubFx, XYAdjustItem, XYEffectKeyFrameInfo, XYVe3DDataF, XYEffectPropertyInfoModel, XYEffectPropertyItemModel, XYEffectPropertyKeyInfo, XYColorCurveInfo, XYEffectPicInPicAnimFiterInfo;

NS_ASSUME_NONNULL_BEGIN


/// 关键帧model
@interface XYEffectVisionKeyFrameModel : XYBaseCopyModel

@property (nonatomic, assign) NSInteger position;//时间点，单位ms
@property (nonatomic, strong) XYVe3DDataF *degree;//旋转角度 0 - 360
@property (nonatomic, strong) XYVe3DDataF *center;//中心点坐标 z方向中心点，< 0往屏幕外， > 0 往屏幕里
@property (nonatomic, strong) XYVe3DDataF *size;//效果宽度
@property (nonatomic, strong) XYVe3DDataF *anchorOffset;//相对锚点偏移量 默认为(0,0,0)

@end



/// 视觉类效果的model
@interface XYEffectVisionModel : XYEffectModel
@property (nonatomic, assign) CGFloat templateConfitDegree; // 素材中提取的角度
@property (nonatomic, assign) CGFloat defaultWidth; //默认宽度，素材中提取
@property (nonatomic, assign) CGFloat defaultHeight; //默认高度，素材中提取
@property (nonatomic, assign) BOOL reCalculateFrame; // YES不管当前宽高，重新计算宽高
@property (nonatomic, assign) CGFloat maxWidth; //最大的宽
@property (nonatomic, assign) CGFloat alpha; //透明度，默认1.0
@property (nonatomic, assign) CGFloat propData; //程度调节，默认1.0
@property (nonatomic, assign) BOOL hasAudio; //是否带音效
@property (nonatomic, assign) BOOL verticalReversal; //竖直翻转
@property (nonatomic, assign) BOOL horizontalReversal; //水平翻转

@property (nonatomic, strong) XYVe3DDataF *center;// 中心点 如果有修改锚点 ，效果的位置就是相对这个中心点偏移了anchor.x,anchor.y,anchor.z
@property (nonatomic, strong) XYVe3DDataF *size;//效果以streamsize的宽高深
@property (nonatomic, strong) XYVe3DDataF *degree;//角度,(0,0,0)为效果以x/y/z轴的旋转角度 。取值范围是 0~360
@property (nonatomic, strong) XYVe3DDataF *anchorOffset;//相对锚点偏移量 默认为(0,0,0)

@property (nonatomic, assign) BOOL isFrameMode; //YES的情况下，应用到全透明的Storyboard上也是透明的，否则背景会变黑
@property (nonatomic, assign) BOOL defaultIsStaticPicture; //该视觉效果默认是否静态
@property (nonatomic, assign) BOOL isStaticPicture; //YES的情况下，该效果将会静态展示
@property (nonatomic, assign) BOOL isLockRefresh; //YES的情况下，该效果为锁定刷新，不使用需要设置为NO
@property (nonatomic, strong) XYEffectKeyFrameInfo *keyFrameInfo;
@property (nonatomic) CGFloat currentScale; //根据当前宽度和dafault宽度自动计算当前放大倍数，只读
//@property (nonatomic, assign) BOOL isResetLayerID;//是否只是resetLayerID
@property (nonatomic, assign) NSInteger previewDuration;//动画预览时长
@property (nonatomic, assign) NSInteger volume;//效果的音量（只有特效和视频画中画才有作用）

@property (nonatomic, strong) XYEffectPicInPicOverlayInfo *overlayInfo; //画中画 透明度
@property (nonatomic, strong) XYEffectPicInPicMaskInfo *maskInfo; //画中画 蒙版
@property (nonatomic, strong) XYEffectPicInPicChromaInfo *chromaInfo; //画中画 抠色信息数据（绿幕）
@property (nonatomic, strong) XYEffectPicInPicFilterInfo *filterInfo; //画中画 滤镜
@property (nonatomic, strong) XYEffectPicInPicAnimFiterInfo *animFilterInfo; //画中画 动画滤镜


@property (nonatomic, strong) NSMutableArray <XYEffectPicInPicSubFx *> *fxInfoList; //画中画 特效
@property (nonatomic, copy) NSArray <XYAdjustItem *> *adjustItems;// 画中画 参数调节
@property (nonatomic, strong) XYColorCurveInfo *colorCurveInfo;// 画中画 曲线变色
@property (nonatomic, strong) NSMutableArray <XYEffectPropertyInfoModel *> *effectPluginList;// 画中画 效果插件

/// 是否开启人体扣像效果 默认不开启
@property (nonatomic, assign) BOOL segmentEnable;

/// 人脸效果支持最大的一个 默认是YES
@property (nonatomic, assign) BOOL maxFaceOnly;

/// 根据时间点来获取插件模板关键帧
/// @param itemModel itemModel
/// @param seekPosition 播放器的当前时间点
/// @param block mian Block
- (void)fetchPropertyItemKeyFrameModel:(XYEffectPropertyItemModel *)itemModel seekPosition:(NSInteger)seekPosition block:(void (^)(XYEffectPropertyKeyInfo *keyFramModel))block;

/// 根据引擎万分比计算视觉效果在播放区域显示的rect
/// @param regionRect 引擎万分比
/// @param previewSize 播放区域Size
- (CGRect)rcDisplayRegionToVisionViewRect:(MRECT)regionRect previewSize:(CGSize)previewSize;


/// MRECT转换成CGRect
/// @param mRect MRECT
- (CGRect)cgRectFromMRect:(MRECT)mRect;

- (void)reload3DTransform;

/// 判断是否是人脸贴纸
+ (BOOL)isFacePaster:(NSString *)templatePath;

@end

NS_ASSUME_NONNULL_END
