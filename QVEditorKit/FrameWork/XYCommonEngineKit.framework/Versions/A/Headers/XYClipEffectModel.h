//
//  XYSubClipEffectModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/5.
//

#import "XYBaseCopyModel.h"

@class XYEffectVisionModel;
@class XYEffectVisionTextModel;
@class XYVeRangeModel;
@class XYStoryboard;

NS_ASSUME_NONNULL_BEGIN

@interface XYClipEffectModel : XYBaseCopyModel
@property (nonatomic, copy) NSString *text;//如编辑自定义片尾的字幕
@property (nonatomic, copy) NSString *coverBackLogoFilePath;//片尾 logo
@property (nonatomic, copy) NSString *coverBackSegmentFilePath;//片尾 分割线

@property (nonatomic, copy) NSArray <XYEffectVisionModel *> *backCoverVisionModels;//片尾


@property (nonatomic, assign) NSInteger effectConfigIndex;//有些素材包含多种效果，表示使用第几个效果，默认0

@property (nonatomic, copy) NSString *colorFilterFilePath;//调色滤镜的路径
@property (nonatomic, assign) CGFloat colorFilterAlpha;//调色程度值 滤镜调节

@property (nonatomic, copy) NSString *themeFilterFilePath;//主题滤镜的路径
@property (nonatomic, assign) CGFloat themeFilterAlpha;//主题程度值 滤镜调节

@property (nonatomic, copy) NSString *fxFilterFilePath;//特效滤镜的路径
@property (nonatomic, assign) CGFloat fxFilterAlpha;//特效程度值 滤镜调节

@property (nonatomic, copy) NSString *effectTransFilePath;//转场的路径

@property (nonatomic, strong) XYVeRangeModel *transDestRange;//转场在视频中的range
@property (nonatomic, assign) NSInteger transDuration;//转场时长
@property (nonatomic, strong) CXiaoYingEffect *pEffect;

- (void)reload:(CXiaoYingClip *)pClip storyboard:(XYStoryboard *)storyboard;

@end

NS_ASSUME_NONNULL_END
