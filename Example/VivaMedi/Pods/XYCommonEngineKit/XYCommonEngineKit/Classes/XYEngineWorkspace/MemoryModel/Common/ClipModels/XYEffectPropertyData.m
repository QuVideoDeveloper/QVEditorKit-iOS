//
//  XYEffectPropertyData.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYEffectPropertyData.h"
#import "XYStoryboard.h"
#import "XYClipEditRatioService.h"
#import "XYCommonEngineGlobalData.h"
#import "XYClipModel.h"
#import "XYStoryboard+XYEffect.h"
#import "XYStoryboard+XYClip.h"
#import <XYCategory/XYCategory.h>

/* 对照表 业务无需care
scaleX 对应的pid 1
scaleY 对应的pid 2
angleZ 对应的pid 3
shiftX 对应的pid 4
shiftY 对应的pid 5
startR 对应的pid 6
startG 对应的pid 7
startB 对应的pid 8
endR 对应的pid 9
endG 对应的pid 10
endB 对应的pid 11

blurX 对应的pid 6
blurY 对应的pid 7
linearGradientAngle; //对应的pid 12
*/

@interface XYEffectPropertyData()

@property(nonatomic, weak) XYStoryboard *storyboard;
@property(nonatomic, weak) XYClipModel *clipModel;


@end

@implementation XYEffectPropertyData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scale = 1;
        self.angleZ = 0;
        self.shiftX = 0;
        self.shiftY = 0;
        self.backgroundBlurValue = 0;
    }
    return self;
}

- (void)load:(XYStoryboard *)storyboard clipModel:(XYClipModel *)clipModel {
    self.clipModel = clipModel;
    self.storyboard = storyboard;
    //获取工程模板类型
    CXiaoYingEffect *effect = [storyboard getEffectByClipIndex:clipModel.clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM];
    NSString *effectStr = [storyboard getEffectPath:effect];
    if (![NSString xy_isEmpty:effectStr]) {
        NSString * effectC = [XYCommonEngineGlobalData data].configModel.effectXytCFilePath;
        NSString * effectD = [XYCommonEngineGlobalData data].configModel.effectXytDFilePath;
        NSString * effectE = [XYCommonEngineGlobalData data].configModel.effectXytEFilePath;
        NSString * effectF = [XYCommonEngineGlobalData data].configModel.effectXytFFilePath;
        
        if (![NSString xy_isEmpty:effectStr] && [effectStr isEqualToString:effectC]) {
            _effectType = XYCommonEngineBackgroundColor;
        } else if (![NSString xy_isEmpty:effectStr] && [effectStr isEqualToString:effectD]) {
            _effectType = XYCommonEngineBackgroundBlur;
        } else if (![NSString xy_isEmpty:effectStr] && ([effectStr isEqualToString:effectE] || [effectStr isEqualToString:effectF])) {
            _effectType = XYCommonEngineBackgroundImage;
            NSString *photoPath = [XYClipEditRatioService getProjectEffectPhotoPathWithClipIndex:self.clipModel.clipIndex storyBoard:storyboard];
            if (![NSString xy_isEmpty:photoPath]) {
                self.backImagePath = photoPath;
            }
        } else {
            self.effectType == XYCommonEngineBackgroundNormal;
        }
        [self refresh];
    } else {
        self.effectType == XYCommonEngineBackgroundNormal;
        [self fetchIsAnimationON];//没有模板也要刷新是否是有动画
    }
}

- (void)refresh {
    [self fetchScale];
    [self fetchShiftX];
    [self fetchShiftY];
    [self fetchIsFitIn];
    [self fetchBackgroundBlurValue];
    [self fetchIsAnimationON];
    if (XYCommonEngineBackgroundColor == self.effectType) {
        [self fetchBackgroundColorHexValue];
        [self fetchLinearGradientAngle];
    } else if (XYCommonEngineBackgroundImage == self.effectType) {
        [self fetchBackImagePath];
    }
}
- (void)fetchIsFitIn {
    [self fetchAngleZ];
    int fitInScale = [XYClipEditRatioService getFitInScaleWithPlayViewSize:[XYCommonEngineGlobalData data].playbackViewFrame.size clipIndex:self.clipModel.clipIndex] * 100;
    float clipRatio = self.clipModel.clipSize.width / (float) self.clipModel.clipSize.height;
    NSInteger clipRoration = [self.storyboard getClipRotationByClip:[self.storyboard getClipByIndex:self.clipModel.clipIndex]];
    int fitOutScale = [XYClipEditRatioService getFitoutScaleWithPlayViewSize:[XYCommonEngineGlobalData data].playbackViewFrame.size clipIndex:self.clipModel.clipIndex mRatio:-1 storyBoard:self.storyboard rotation:self.angleZ clipRotation:clipRoration clipRatio:clipRatio] * 100;
    QVET_EFFECT_PROPDATA proData = {1,1};
    int scaleX = self.scale * 100;
    if (scaleX == fitInScale) {
        self.fitType = XYCommonEngineRatioFitIn;
    }else if (scaleX == fitOutScale){
        self.fitType = XYCommonEngineRatioFitOut;
    }else{
        self.fitType = XYCommonEngineRatioFitNormal;
    }
}

- (void)fetchBackgroundBlurValue {
    MLong lValue = 0;
    QVET_EFFECT_PROPDATA proData = {6,lValue};
    [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:self.clipModel.clipIndex];
    self.backgroundBlurValue = proData.lValue;
}


- (void)fetchBackgroundColorHexValue {
    //start r g b
    QVET_EFFECT_PROPDATA colorCountProData = {17,0};
    [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&colorCountProData clipIndex:self.clipModel.clipIndex];
    [self getColorListByCount:colorCountProData.lValue];
    
}

- (void)getColorListByCount:(NSInteger)count {
        QVET_EFFECT_PROPDATA startRproData = {6,0};
        [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&startRproData clipIndex:self.clipModel.clipIndex];
        QVET_EFFECT_PROPDATA startGproData = {7,0};
        [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&startGproData clipIndex:self.clipModel.clipIndex];
        QVET_EFFECT_PROPDATA startBproData = {8,0};
        [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&startBproData clipIndex:self.clipModel.clipIndex];
        
        //end r g b
        QVET_EFFECT_PROPDATA endRproData = {9,0};
        [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&endRproData clipIndex:self.clipModel.clipIndex];
        QVET_EFFECT_PROPDATA endGproData = {10,0};
        [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&endGproData clipIndex:self.clipModel.clipIndex];
        QVET_EFFECT_PROPDATA endBproData = {11,0};
        [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&endBproData clipIndex:self.clipModel.clipIndex];
        
        NSInteger statrColorHexValue = 4278190080 + startRproData.lValue * pow(16, 4) + startGproData.lValue * pow(16, 2) + startBproData.lValue;
        NSInteger endColorHexValue = 4278190080 + endRproData.lValue * pow(16, 4) + endGproData.lValue * pow(16, 2) + endBproData.lValue;
        self.backgroundColorList = @[@(statrColorHexValue),@(endColorHexValue)];
       
        if (count <= 2) {
            self.backgroundColorList = @[@(statrColorHexValue),@(endColorHexValue)];
        } else if (count == 3) {
            //middle r g b
            QVET_EFFECT_PROPDATA midRproData = {14,0};
            [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&startRproData clipIndex:self.clipModel.clipIndex];
            QVET_EFFECT_PROPDATA midGproData = {15,0};
            [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&startGproData clipIndex:self.clipModel.clipIndex];
            QVET_EFFECT_PROPDATA midBproData = {16,0};
            [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&startBproData clipIndex:self.clipModel.clipIndex];
            
            NSInteger midColorHexValue = 4278190080 + midRproData.lValue * pow(16, 4) + midGproData.lValue * pow(16, 2) + midBproData.lValue;
            self.backgroundColorList = @[@(statrColorHexValue),@(midColorHexValue),@(endColorHexValue)];
        }
}

- (void)fetchLinearGradientAngle {
    QVET_EFFECT_PROPDATA proData = {12,0};
    [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:self.clipModel.clipIndex];
    self.linearGradientAngle = proData.lValue;
}

- (void)fetchBackImagePath {
    self.backImagePath = [self.storyboard getEffectClipBackImagePhotoPathWithClipIndex:self.clipModel.clipIndex];
}

- (void)fetchScale {
    QVET_EFFECT_PROPDATA proData = {1,1};
    [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:self.clipModel.clipIndex];
    self.scale =  fabs(proData.lValue / 5000.0 - 10);
    if (self.scale < 0) {
        self.isMirror = YES;
    } else {
        self.isMirror = NO;
    }
}


- (void)fetchAngleZ {
    QVET_EFFECT_PROPDATA proData = {3,0};
    [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:self.clipModel.clipIndex];
    self.angleZ = abs(proData.lValue);
    if (self.angleZ > 360) {
        self.angleZ = self.angleZ / 100;
    }
}

- (void)fetchShiftX {
    QVET_EFFECT_PROPDATA proData = {4,0};
    [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:self.clipModel.clipIndex];
    self.shiftX = proData.lValue / 5000.0 - 10;
}

- (void)fetchShiftY {
    QVET_EFFECT_PROPDATA proData = {5,0};
    [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:self.clipModel.clipIndex];
    self.shiftY = proData.lValue / 5000.0 - 10;
}

- (void)fetchIsAnimationON {
    CXiaoYingClip *clip = [self.storyboard getClipByIndex:self.clipModel.clipIndex];
    BOOL isPicture = [self.storyboard isClipPicture:clip];
    if (isPicture) {
        MLong lValue = 0;
        int propertyID = 13;
        if (XYCommonEngineBackgroundColor == self.effectType) {
            QVET_EFFECT_PROPDATA proData = {propertyID,lValue};
            [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:self.clipModel.clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM];
            if (proData.lValue < XY_ANIMATION_VALUE) {
                self.isAnimationON = NO;
            } else {
                self.isAnimationON = YES;
            }
        } else {
            propertyID = 8;
            QVET_EFFECT_PROPDATA proData = {propertyID,lValue};
            if (XYCommonEngineBackgroundNormal == self.effectType) {
                [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:self.clipModel.clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ANIM_PANZOOM];
            } else {
                [self.storyboard getEffectPropertyWithDwPropertyID:AMVE_PROP_EFFECT_PROPDATA pValue:&proData clipIndex:self.clipModel.clipIndex];
            }
            if (proData.lValue < XY_ANIMATION_VALUE) {
                self.isAnimationON = NO;
            } else {
                self.isAnimationON = YES;
            }
        }
    }
}

@end
