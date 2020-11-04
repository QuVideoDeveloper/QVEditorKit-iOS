//
//  XYEffectVisionTextModel.h
//  XYCommonEngineKit
//
//  Created by 徐新元 on 2019/11/20.
//

#import "XYEffectVisionModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYEffectVisionTextAlignment) {
    XYEffectVisionTextAlignmentLeft = AMVE_STYLE_TEXT_ALIGNMENT_LEFT,
    XYEffectVisionTextAlignmentMiddle = AMVE_STYLE_TEXT_ALIGNMENT_HOR_CENTER | AMVE_STYLE_TEXT_ALIGNMENT_VER_CENTER,
    XYEffectVisionTextAlignmentRight = AMVE_STYLE_TEXT_ALIGNMENT_RIGHT,
    XYEffectVisionTextAlignmentVertical = AMVE_STYLE_TEXT_ALIGNMENT_TOP ,
    XYEffectVisionTextAlignmentJustify = AMVE_STYLE_TEXT_ALIGNMENT_HOR_FULLFILL | AMVE_STYLE_TEXT_ALIGNMENT_VER_FULLFILL,
};

@class XYEffectVisionTextModel;

@interface XYEffectVisionSubTitleLabelInfoModel : NSObject
@property (nonatomic, assign) NSInteger mParamID;
@property (nonatomic, copy) NSString *text;//字幕当前文字

/// 多行字幕每个文本部分相对于整个字幕尺寸的万分比rect
@property (nonatomic, assign) CGRect textRegionRect;

/// 是否粗体 默认不是
@property (nonatomic, assign) NSInteger isBold;

/// 是否斜体 默认不是
@property (nonatomic, assign) NSInteger isItalic;

@property (nonatomic, strong) UIColor *textColor;//字幕颜色
@property (nonatomic, copy) NSString *textDefault;//字幕素材的默认文字
@property (nonatomic, copy) NSString *textFontName;//字幕字体名称
//字幕基本属性
@property (nonatomic, assign) NSInteger textLine;//字幕行数
@property (nonatomic, assign) XYEffectVisionTextAlignment textAlignment; //对齐方式
@property (nonatomic, assign) BOOL verticalReversal; //竖直翻转
@property (nonatomic, assign) BOOL horizontalReversal; //水平翻转

//字幕额外效果
@property (nonatomic, assign) BOOL isTextExtraEffectEnabled;//是否启用以下额外效果
@property (nonatomic, strong) UIColor *textStrokeColor;//描边颜色
@property (nonatomic, strong) UIColor *textShadowColor;//阴影颜色
@property (nonatomic, assign) float textStrokeWPercent;//描边粗细，引擎那边限制可以认为是0.0～1.0，但取值范围建议 0.0～0.5
@property (nonatomic, assign) float textShadowBlurRadius;//阴影模糊程度: iOS必须>=0; Android必须>0;
@property (nonatomic, assign) float textShadowXShift;//阴影X轴偏移
@property (nonatomic, assign) float textShadowYShift;//阴影Y轴偏移

/// 获取多行字幕每个文本部分streamSize尺寸
/// @param textModel textModel 对象
- (CGRect)fetchTextRect:(XYEffectVisionTextModel *)textModel;

@end

@interface XYEffectVisionTextModel : XYEffectVisionModel
@property (nonatomic, assign) NSInteger textBGFormat;//背景类型
@property (nonatomic, assign) NSInteger textVersion;//字幕版本，当前没用到
@property (nonatomic, assign) NSInteger textTransparency;//字幕不透明度 全透明0，不透明100
@property (nonatomic, assign) CGFloat textOneLineHeight;//字幕单行高度

//动画字幕相关
@property (nonatomic, assign) BOOL isAnimatedText;//是否动画字幕
//是否支持竖排文字
@property (nonatomic, assign) BOOL isSupportVertical;
//主题字幕相关
@property (nonatomic, assign) ThemeTextType themeTextType;//主题文字类型
@property (nonatomic, assign) NSInteger themeTextSubIndex;//主题文字顺序

//字幕额外效果
@property (nonatomic, assign) BOOL isTextExtraEffectEnabled;//是否启用以下额外效果

@property (nonatomic, assign) BOOL useCustomTextInfo;//第一次添加 如果这个值是YES，则文字大小、颜色、字体、位置、阴影、描边、描边大小、对齐方式，都用外面传进来的值，否则用模版里的信息
@property (nonatomic, copy) NSArray <XYEffectVisionSubTitleLabelInfoModel *> *multiTextList;//多行字幕标签信息列表， 单行字幕数组里只有一个
 

/// 获取素材推荐的最小时长
/// @param filePath 素材路径 返回是值范围 [0 - 无限大]
+ (NSInteger)getTemplateMinDurationWithTemplateFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
