//
//  XYSubClipEffectModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/5.
//

#import "XYClipEffectModel.h"
#import "XYVeRangeModel.h"
#import "XYEngineEnum.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYEffect.h"
#import <XYCategory/XYCategory.h>

@implementation XYClipEffectModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.effectConfigIndex = 0;
    }
    return self;
}

- (XYVeRangeModel *)transDestRange {
    if (!_transDestRange) {
        _transDestRange = [[XYVeRangeModel alloc] init];
    }
    return _transDestRange;
}

- (void)reload:(CXiaoYingClip *)pClip storyboard:(XYStoryboard *)storyboard {
    //主题滤镜的
    CXiaoYingEffect *themeFilterEffect = [[storyboard getDataClip] getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:XYCommonEngineGroupIDThemeFilter EffectIndex:0];
    
    NSString *themefilterFilePath = [storyboard getEffectPath:themeFilterEffect];
    if (![NSString xy_isEmpty:themefilterFilePath]) {
        self.themeFilterFilePath = themefilterFilePath;
        MFloat themeFilterAlpha = 1.0;
        [themeFilterEffect getProperty:AMVE_PROP_EFFECT_BLEND_ALPHA PropertyData:&themeFilterAlpha];
        self.themeFilterAlpha = themeFilterAlpha;
    }
    
    //调色滤镜的
    CXiaoYingEffect *colorFilterEffect = [pClip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:XYCommonEngineGroupIDColorFilter EffectIndex:0];
    
    NSString *colorFilePath = [storyboard getEffectPath:colorFilterEffect];
    if (![NSString xy_isEmpty:colorFilePath]) {
        self.colorFilterFilePath = colorFilePath;
        MFloat colorFilterAlpha = 1.0;
        [colorFilterEffect getProperty:AMVE_PROP_EFFECT_BLEND_ALPHA PropertyData:&colorFilterAlpha];
        self.colorFilterAlpha = colorFilterAlpha;
    }
    
    //特效滤镜的
    CXiaoYingEffect *fxFilterEffect = [pClip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:XYCommonEngineGroupIDFXFilter EffectIndex:0];
    
    NSString *fxFilePath = [storyboard getEffectPath:fxFilterEffect];
    if (![NSString xy_isEmpty:fxFilePath]) {
        self.fxFilterFilePath = fxFilePath;
        MFloat fxFilterAlpha = 1.0;
        [fxFilterEffect getProperty:AMVE_PROP_EFFECT_BLEND_ALPHA PropertyData:&fxFilterAlpha];
        self.fxFilterAlpha = fxFilterAlpha;
    }
}

- (NSInteger)transDuration {
    return self.transDestRange.dwLen;
}

@end
