//
//  TextInfo.h
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/9.
//

#import "XYEngineDef.h"
#import <Foundation/Foundation.h>

@interface TextInfo : NSObject

@property (nonatomic, copy) NSString *identifier;//唯一标志
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic) CGRect textRect;
@property (nonatomic) MInt64 textTemplateID;
@property (nonatomic, copy) NSString *textTemplateFilePath;
@property (nonatomic) MDWord startPosition;
@property (nonatomic) MDWord duration;
@property (nonatomic) MFloat fRotateAngle;
@property (nonatomic) MPOINT ptRotateCenter;
@property (nonatomic) MRECT textRegionRatio;//文字部分相对于整个bubble的万分比区域
@property (nonatomic) MRECT rcRegionRatio;
@property (nonatomic) MCOLORREF clrText;
@property (nonatomic) BOOL isStaticPicture;
@property (nonatomic) BOOL defaultIsStaticPicture;
@property (nonatomic) MDWord textLine;
@property (nonatomic) CGFloat textOneLineHeight;
@property (nonatomic) MBool bVerReversal;
@property (nonatomic) MBool bHorReversal;
@property (nonatomic) MDWord dwBGFormat;
@property (nonatomic) MBool bIsAnimated;
@property (nonatomic, copy) NSString *fontName;
@property (nonatomic) ThemeTextType themeTextType;
@property (nonatomic) MDWord themeTextSubIndex;
@property (nonatomic) MDWord previewDuration;
@property (nonatomic) MDWord dwVersion;
@property (nonatomic) BOOL isFrameMode;       //isFrameMode为YES的情况下，贴纸应用到全透明的Storyboard上也是透明的，否则背景会变黑
@property (nonatomic) MDWord dwTextAlignment; //对齐方式
@property (nonatomic) MDWord dwTransparency; //透明度，全透明0～100不透明
@property (nonatomic) BOOL isInstantRefresh; //快速刷新效果
@property (nonatomic, copy) NSString *userData; //自定义数据
@property (nonatomic) BOOL isAnimatedText;
@property (nonatomic) float scaleRatio; //字幕放大倍数

//字幕额外效果
@property (nonatomic) MBool bEnableEffect;       //是否启用以下效果
@property (nonatomic) MCOLORREF dwStrokeColor;   //描边颜色
@property (nonatomic) MFloat fStrokeWPercent;    //描边粗细
@property (nonatomic) MCOLORREF dwShadowColor;   //阴影颜色
@property (nonatomic) MFloat fDShadowBlurRadius; //fDShadowBlurRadius: iOS必须>=0; android 上必须 > 0;
@property (nonatomic) MFloat fDShadowXShift;     //阴影X轴偏移
@property (nonatomic) MFloat fDShadowYShift;     //阴影Y轴偏移
@property (nonatomic, strong) CXiaoYingClip *pClip;



@end
