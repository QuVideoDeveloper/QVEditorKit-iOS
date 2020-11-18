//
//  XYClipModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//


#import "XYBaseEngineModel.h"
#import "XYEffectPropertyData.h"
#import "XYVeRangeModel.h"
#import "XYEffectPropertyMgr.h"
#import "XYClipEffectModel.h"
#import "XYCommonEngineGlobalData.h"
#import "XYEngineStructClass.h"
#import "XYColorCurveInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYMediaInfo : NSObject

@property (nonatomic) CGSize size;

@end

@class XYStoryboard, XYCommonEngineRequest, XYEffectVisionTextModel, XYAdjustEffectValueModel, PHAsset, XYClipCurveSpeed, XYDrawLayerPaintPenInfo;

@interface XYClipModel : XYBaseEngineModel
@property (nonatomic, copy) NSString *clipFilePath;
@property (nonatomic, copy) NSString *filterFilePath;
@property (nonatomic) NSInteger filterConfigIndex;
@property (nonatomic, copy) NSString *musicFilePath;
@property (nonatomic) NSInteger dwMusicTrimStartPos;
@property (nonatomic) NSInteger dwMusicTrimLen;
@property (nonatomic) XYClipPadding cropRect;//比例 (0,0,10000,10000)表示裁剪的区域时全部 ,是个万分比
@property (nonatomic) NSInteger rotation;//值范围 0-360
@property (nonatomic) NSInteger clipIndex;//当前的clipIndex
@property (nonatomic) NSInteger globalIndex;//用于切换到了临时storyboard 时使用
@property (nonatomic) BOOL isReversed;//是否被倒放
@property (nonatomic) NSInteger videoFileDuration;//物理视频文件的总时长

/// 是否需要模糊背景 默认是YES
@property (nonatomic) BOOL isBlurBack;
@property (nonatomic, assign) NSInteger objIndex;
@property (nonatomic, assign) BOOL isSwitchSourceRange;// 切换临时时变速后的源的长度
@property (readonly, nonatomic, assign) XYCommonEngineClipModuleType clipType;
@property (nonatomic, copy) NSArray <XYClipModel*> *clipModels;//cut model add clip model 等
@property (nonatomic, strong) XYClipEffectModel *clipEffectModel;//滤镜 转场
@property(nonatomic, assign) CGFloat storyboardRatioValue;

@property (nonatomic, assign) BOOL     isMute;//是否静音  type为video时有效
@property (nonatomic, assign) CGFloat  volumeValue;//音量值, 值范围 [0,200] 100是原声音量
@property (nonatomic, assign) CGFloat  voiceChangeValue;//变声值, 值范围 [-60,60]
@property (nonatomic, assign) CGFloat  speedValue;//视频变速

/// 曲线变速
@property (nonatomic, strong) XYClipCurveSpeed *curveSpeed;
@property (nonatomic, assign) BOOL     speedAdjustEffect;//视频变速是否刷新效果
@property (nonatomic, assign) BOOL     iskeepTone;//是否保持原声调
@property (nonatomic, assign) BOOL     isAudioNSXOn;//是否开启音频降噪功能
//@property (nonatomic, assign) BOOL     isAnimOn;//是否开启动画

@property (nonatomic, assign) XYClipMirrorMode mirrorMode;
@property (nonatomic, copy) NSArray <XYAdjustItem *> *adjustItems;// 参数调节等
@property (nonatomic, strong) XYEffectPropertyData *clipPropertyData;//图片动画 clip的手势 背景颜色 背景图片 属性
@property (nonatomic, strong) XYColorCurveInfo *colorCurveInfo;// 曲线变色
@property (nonatomic, assign) NSInteger splitClipPostion;//相对clip分割的postion

@property (nonatomic, strong) XYClipModel *duplicateClipModel;
@property (nonatomic, assign) CGSize originSize;//clip 原始尺寸
@property (nonatomic, assign) CGSize clipSize;//clip 目前的原始尺寸

//交互顺序
@property (nonatomic, assign) NSInteger sourceIndex;
@property (nonatomic, assign) NSInteger destinationIndex;
@property (nonatomic, strong) CXiaoYingClip *pClip;
@property (nonatomic, strong) XYAdjustEffectValueModel *adjustEffectValueModel;//如trim 变化的绝对值 左边 用于效果重新计算

@property (nonatomic, assign) NSInteger frontTransTime;//转场前部分时间
@property (nonatomic, assign) NSInteger backTransTime;//转场后部分时间
@property (nonatomic, assign) NSInteger fixTime;//用于缩略图的起始时间的校准
@property (readonly, nonatomic, copy) NSDictionary *clipParam;

/// 画笔
@property (nonatomic, strong) XYDrawLayerPaintPenInfo *drawLayerPenInfo;




/// /// 根据曲线变速后的时间范围获取对应的原clip的时间范围
/// @param range 变后的对应的时间范围
- (XYVeRangeModel *)fetchSouceRangeWithCurveSpeedRange:(XYVeRangeModel *)range;

/// /// 根据原clip的时间范围获取对应的曲线变速后的时间范围
/// @param range 原clip的时间范围
- (XYVeRangeModel *)fetchCurveSpeedRangeWithSouceRange:(XYVeRangeModel *)range;

/// 根据phAsset 获取到给引擎的镜头路径
/// @param phAsset PHAsset对象
+ (NSString *)getClipFilePathForEngine:(PHAsset *)phAsset;
- (void)updateIdentifier:(NSString *)identifier;
- (void)reload;
- (void)reloadIsMute;
- (void)reloadVolumeValue;
- (void)reloadVoiceChangeValue;
- (void)reloadCustomCoverTextModel;
- (void)reloadFilterData;

- (XYEffectVisionTextModel *)fetchCustomBackTextModel;

+ (XYMediaInfo *)fetchClipSizeWithClipPath:(NSString *)clipPath;

/// 判断图片是否有人像
/// @param position clip上的时间点
/// @param width clip缩略图的宽
/// @param height clip缩略图的高
/// @param degree 纹理转正需要旋转的角度
/// 是否原图
/// @param threshold 目标人像占比
- (BOOL)thumbnailHasPortrait:(NSInteger)position
                       width:(NSInteger)width
                      height:(NSInteger)height
                      degree:(NSInteger)degree
            onlyOriginalClip:(BOOL)onlyOriginalClip
                   threshold:(CGFloat)threshold;

/// 获取画笔undo队列的个数
- (NSInteger)drawPenUndoCount;

/// 获取画笔redo队列的个数
- (NSInteger)drawPenRendCount;

@end

NS_ASSUME_NONNULL_END
