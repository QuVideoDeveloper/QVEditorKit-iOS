//
//  XYClipModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import "XYClipModel.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYClip.h"
#import "XYStoryboard+XYEffect.h"
#import "XYCommonEngineRequest.h"
#import "XYClipEditRatioService.h"
#import <objc/runtime.h>
#import "XYEffectVisionTextModel.h"
#import "XYCommonEngineGlobalData.h"
#import "XYAdjustEffectValueModel.h"
#import "XYCommonEngineGlobalData.h"
#import "XYEngineWorkspace.h"
#import <XYCategory/XYCategory.h>
#import <Photos/Photos.h>

@interface XYClipModel()


@end


@implementation XYClipModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initNormalType];
    }
    return self;
}

- (void)initNormalType {
    self.clipIndex = -1;
    self.speedValue = 1.0;
    self.identifier = [XYStoryboard createIdentifier];
    self.speedAdjustEffect = YES;
}

- (XYEngineModelType)engineModelType {
    return XYEngineModelTypeClip;
}

#pragma mark --lazy

- (instancetype)init:(XYEngineConfigModel *)config {
    self = [super init:config];
    if (self) {
        [self initNormalType];
        self.clipIndex = config.idx;
        _clipType = config.clipType;
        if (XYCommonEngineClipModuleThemeCoverFront != self.clipType && XYCommonEngineClipModuleThemeCoverBack != self.clipType) {
            self.pClip = [self.storyboard getClipByIndex:config.idx];
        } else {
            if (XYCommonEngineClipModuleThemeCoverFront == self.clipType) {
                self.pClip = [self.storyboard getCover:AMVE_PROP_STORYBOARD_THEME_COVER];
            } else if (XYCommonEngineClipModuleThemeCoverBack == self.clipType) {
                self.pClip = [self.storyboard getCover:AMVE_PROP_STORYBOARD_THEME_BACK_COVER];
            }
        }
    }
    return self;
}

#pragma mark - lazy

- (XYAdjustEffectValueModel *)adjustEffectValueModel {
    if (!_adjustEffectValueModel) {
        _adjustEffectValueModel = [[XYAdjustEffectValueModel alloc] init];
    }
    return _adjustEffectValueModel;
}


- (XYClipEffectModel *)clipEffectModel {
    if (!_clipEffectModel) {
        _clipEffectModel = [[XYClipEffectModel alloc] init];
    }
    return _clipEffectModel;
}


- (XYEffectPropertyData *)clipPropertyData {
    if (!_clipPropertyData) {
        _clipPropertyData = [[XYEffectPropertyData alloc] init];
    }
    return _clipPropertyData;
}

#pragma mark --获取属性值

- (void)reloadIdentifier {
    NSString *identifier = [self.storyboard getClipIdentifier:self.pClip];
    if ([NSString xy_isEmpty:identifier]) {
        self.identifier = [XYStoryboard createIdentifier];
        [self.storyboard setClipIdentifier:self.pClip identifier:self.identifier];
    } else {
        self.identifier = identifier;
    }
}

- (void)reloadIsMute {
    self.isMute = [self.storyboard isClipPrimalAudioDisabled:self.pClip];
}

- (void)reloadVolumeValue {
    self.volumeValue = [self.storyboard clipOriginVolumeWithPClip:self.pClip];
}

- (void)reloadAudioNSX {
    self.isAudioNSXOn = [self.storyboard isAudioNSXOn:self.pClip];
}

- (void)reloadVoiceChangeValue {
    self.voiceChangeValue = [self.storyboard getVoiceChangeValueWithClipIndex:self.clipIndex];
}


- (void)reloadSpeedValue {
    float clipTimeScale = [self.storyboard getClipTimeScaleByClip:self.pClip];
    if (XYIsFloatZero(clipTimeScale)) {
        self.speedValue = 1.0;
    }
    self.speedValue = 1 / clipTimeScale;
}

- (void)reloadIskeepTone {
    self.iskeepTone = [self.storyboard isKeepTone:self.clipIndex];
}

- (void)reloadTrimVeRange {
    AMVE_POSITION_RANGE_TYPE trimRange = [self.storyboard getClipTrimRangeByClip:self.pClip];
    self.trimVeRange.dwPos = trimRange.dwPos;
    self.trimVeRange.dwLen = trimRange.dwLen;
}

- (void)reloadSourceVeRange {
    AMVE_POSITION_RANGE_TYPE sourceRange = [self.storyboard getClipSourceRangeByClip:self.pClip];
    self.sourceVeRange.dwPos = sourceRange.dwPos;
    self.sourceVeRange.dwLen = sourceRange.dwLen;
}

- (void)reloadClipType {
    if ([self.identifier isEqualToString:XY_CUSTOM_COVER_BACK_IDENTIFIER]) {
        _clipType = XYCommonEngineClipModuleCustomCoverBack;
        self.clipEffectModel.pEffect = [self.storyboard getEffectByClipIndex:self.clipIndex trackType:XYCommonEngineTrackTypeVideo groupID:XYCommonEngineGroupIDText];
    } else {
        if (_clipType != XYCommonEngineClipModuleThemeCoverBack && _clipType != XYCommonEngineClipModuleThemeCoverFront) {
            _clipType = [self.storyboard getClipType:self.clipIndex];
        }
    }
}

- (void)reloadEffectTransFilePath {
    self.clipEffectModel.effectTransFilePath = [self.storyboard getClipTransitionPathByClip:self.pClip];
}

- (void)reloadClipFilePath {
    self.clipFilePath = [self.storyboard getClipPath:self.pClip];
}

- (void)reloadCustomCoverTextModel {
    NSMutableArray *visionModels = [NSMutableArray array];
    NSInteger visionStickerCount = [self.pClip getEffectCount:XYCommonEngineTrackTypeVideo GroupID:XYCommonEngineGroupIDSticker];
    for (int i = 0; i < visionStickerCount; i ++) {
        CXiaoYingEffect *pEffect = [self.pClip getEffect:XYCommonEngineTrackTypeVideo GroupID:XYCommonEngineGroupIDSticker EffectIndex:i];
        XYEffectVisionModel *stickerVisionModel = [[XYEffectVisionModel alloc] init];
        stickerVisionModel.groupID = XYCommonEngineGroupIDSticker;
        stickerVisionModel.storyboard = self.storyboard;
        stickerVisionModel.pEffect = pEffect;
        StickerInfo *stickerInfo = [self.storyboard getStoryboardStickerInfo:pEffect];
        [stickerVisionModel reload];
        [stickerVisionModel updateIndexInStoryboard:i];
        [visionModels addObject:stickerVisionModel];
    }
    NSInteger visionTextCount = [self.pClip getEffectCount:XYCommonEngineTrackTypeVideo GroupID:XYCommonEngineGroupIDText];
    for (int i = 0; i < visionTextCount; i ++) {
        XYEffectVisionTextModel *textModel = [[XYEffectVisionTextModel alloc] init];
        textModel.storyboard = self.storyboard;
        textModel.pEffect = [self.pClip getEffect:XYCommonEngineTrackTypeVideo GroupID:XYCommonEngineGroupIDText EffectIndex:i];
        textModel.groupID = XYCommonEngineGroupIDText;
        [textModel reload];
        [textModel updateIndexInStoryboard:i];
        if (0 == textModel.destVeRange.dwLen) {
            textModel.destVeRange.dwLen = 3000;
            [self.storyboard setEffectRange:textModel.pEffect startPos:textModel.destVeRange.dwPos duration:textModel.destVeRange.dwLen];
        }
        [visionModels addObject:textModel];
    }
    
    self.clipEffectModel.backCoverVisionModels = visionModels;
}

- (void)reloadAdjustData {
    CXiaoYingEffect *filterParamEffect = [self.pClip getEffect:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:GROUP_ID_VIDEO_PARAM_ADJUST_EFFECT EffectIndex:0];
    NSArray <XYAdjustItem *> *effectPropertyItems = [XYEffectPropertyMgr getEffectPropertyItemsWithTemplateID:[XYCommonEngineGlobalData data].configModel.adjustEffectId];
    if (filterParamEffect) {
        [effectPropertyItems enumerateObjectsUsingBlock:^(XYAdjustItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QVET_EFFECT_PROPDATA propData = {obj.dwID,0};
            [filterParamEffect getProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&propData];
            obj.dwCurrentValue = propData.lValue;
        }];
    }
    self.adjustItems = effectPropertyItems;
}

- (void)reloadFilterData {
    [self.clipEffectModel reload:self.pClip storyboard:self.storyboard];
}

- (void)reloadIsReversed {
    self.isReversed = [self.storyboard isClipReversed:self.pClip];
}

- (void)reloadRotation {
    self.rotation = [self.storyboard getClipRotationByClip:self.pClip];
}

- (void)updateIdentifier:(NSString *)identifier {
    self.identifier = identifier;
}

- (void)reloadCropRect {
    MRECT crop = [self.storyboard getClipCropRect:self.clipIndex];
    self.cropRect = CGRectMake(crop.left, crop.top, crop.right - crop.left, crop.bottom - crop.top);
}

- (CGSize)clipSize{
    return [XYClipEditRatioService getVideoInfoSizeWithClipIndex:self.clipIndex storyBoard:self.storyboard];
}

- (void)reloadMirrorMode {
    MDWord flip = 0;
    [self.pClip getProperty:AMVE_PROP_CLIP_FLIP PropertyData:&flip];
    self.mirrorMode = flip;
}

#pragma mark --重新加载所有属性的值

- (void)reload {
    [self reloadRotation];
    [self reloadIdentifier];
    [self reloadTrimVeRange];
    [self reloadEffectTransFilePath];
    [self reloadSpeedValue];
    [self reloadIsMute];
    [self reloadVolumeValue];
    [self reloadAudioNSX];
    [self reloadCropRect];
    [self reloadMirrorMode];
    if (XYCommonEngineClipModuleThemeCoverFront != self.clipType && XYCommonEngineClipModuleThemeCoverBack != self.clipType) {
        [self reloadClipFilePath];
        [self reloadVoiceChangeValue];
        [self reloadIskeepTone];
        [self reloadSourceVeRange];
        [self reloadClipType];
        [self reloadAdjustData];
        [self.clipPropertyData load:self.storyboard clipModel:self];
        [self reloadFilterData];
        [self reloadIsReversed];
        if (XYCommonEngineClipModuleCustomCoverBack == self.clipType) {
            [self reloadCustomCoverTextModel];
        }
    }
}

- (XYEffectVisionTextModel *)fetchCustomBackTextModel {
    __block XYEffectVisionTextModel *textModel;
    [self.clipEffectModel.backCoverVisionModels enumerateObjectsUsingBlock:^(XYEffectVisionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (XYCommonEngineGroupIDText == obj.groupID) {
            textModel = obj;
            *stop = YES;
        }
    }];
    return textModel;
}

+ (NSString *)getClipFilePathForEngine:(PHAsset *)phAsset {
    NSString *string = [phAsset valueForKey:@"filename"];
    NSArray *NameArray = [string componentsSeparatedByString:@"."];
    NSString *videoLocalIdentifier = [NSString stringWithFormat:@"PHASSET://%@.%@",phAsset.localIdentifier,NameArray[1]];
    return videoLocalIdentifier;
}

@end
