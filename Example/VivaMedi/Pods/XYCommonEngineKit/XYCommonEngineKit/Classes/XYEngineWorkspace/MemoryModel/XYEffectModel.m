//
//  XYEffectModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import "XYEffectModel.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYEffect.h"
#import "XYStoryboard+XYClip.h"
#import "XYEffectRelativeClipInfo.h"

#import "XYEngineWorkspace.h"
#import "XYClipOperationMgr.h"
#import "XYClipModel.h"
#import "XYAdjustEffectValueModel.h"
#import <XYCategory/XYCategory.h>

@implementation XYEffectUserDataModel

@end


@implementation XYEffectModel


- (instancetype)init {
    self = [super init];
    if (self) {
        self.identifier = [XYStoryboard createIdentifier];
    }
    return self;
}

- (instancetype)init:(XYEngineConfigModel *)config {
    self = [super init:config];
    if (self) {
        [self privateInitData:config.storyboard trackType:config.trackType groupId:config.groupID effecIndex:config.idx];
    }
    return self;
}

- (void)privateInitData:(XYStoryboard *)storyBoard trackType:(MDWord)dwTrackType groupId:(MDWord)groupId effecIndex:(NSInteger)idx {
    _indexInStoryboard = idx;
    _trackType = dwTrackType;
    self.groupID = groupId;
    CXiaoYingEffect *effect = [self.storyboard getStoryboardEffectByIndex:idx dwTrackType:dwTrackType groupId:groupId];
    _pEffect = effect;
    [self reloadLayerId];
}

#pragma mark - lazy

- (XYEffectRelativeClipInfo *)relativeClipInfo {
    if (!_relativeClipInfo) {
        _relativeClipInfo = [[XYEffectRelativeClipInfo alloc] init];
    }
    return _relativeClipInfo;
}

- (XYEffectUserDataModel *)userDataModel {
    if (!_userDataModel) {
        _userDataModel = [XYEffectUserDataModel new];
    }
    return _userDataModel;
}

#pragma mark -- 获取属性值
- (void)reloadLayerId {
    _layerID = [self.storyboard getEffectLayerId:self.pEffect];
}

- (void)reloadMdestVeRange {
    AMVE_POSITION_RANGE_TYPE effectRange = [self.storyboard getEffectRange:self.pEffect];
    self.destVeRange.dwPos = effectRange.dwPos;
    self.destVeRange.dwLen = effectRange.dwLen;
    self.isEqualStoryboardDuration = self.destVeRange.dwLen == [self.storyboard getDuration];
}

- (void)reloadIdentifier {
    NSString *identifier = [self.storyboard getEffectIdentifier:self.pEffect];
    if ([NSString xy_isEmpty:identifier]) {
        self.identifier = [XYStoryboard createIdentifier];
        [self.storyboard setEffectIdentifier:self.pEffect identifier:self.identifier];
    } else {
        self.identifier = identifier;
    }
}

- (void)reloadEffectSourceRange {
    AMVE_POSITION_RANGE_TYPE range = [self.storyboard getEffectSourceRange:self.pEffect];
    self.sourceVeRange = [XYVeRangeModel VeRangeModelWithPosition:range.dwPos length:range.dwLen];
}

- (void)reloadEffectTrimRange {
    AMVE_POSITION_RANGE_TYPE range = [self.storyboard getEffectTrimRange:self.pEffect];
    self.trimVeRange = [XYVeRangeModel VeRangeModelWithPosition:range.dwPos length:range.dwLen];
}

- (void)reloadUserData {
    NSString *userDataString = [self.storyboard getEffectUserData:self.pEffect];
    _userDataModel = [XYEffectUserDataModel yy_modelWithJSON:userDataString];
}


- (void)reloadVoiceChangeValue {
    self.voiceChangeValue = [self.storyboard getEffctVoiceChangeValueWithEffect:self.pEffect];
}

- (NSInteger)fetchLayerIdCellIndex {
    NSInteger layerIdCellIndex = (_layerID - LAYER_ID_VISION_BASE) / LAYER_ID_EVERY_CELL_ADDEND;
    return layerIdCellIndex;
}

//刷新相对clip的数据 添加 手动修改mDestVeRange都需要刷新下
- (void)reloadRelativeClipInfo {
    if ([NSString xy_isEmpty:self.userDataModel.relativeClipInfo.clipIdentifier]) {
        [self updateRelativeClipInfo];
    } else {
        self.relativeClipInfo = self.userDataModel.relativeClipInfo;
    }
}

- (void)updateRelativeClipInfo {
    AMVE_POSITION_RANGE_TYPE effectDestRange = [self.storyboard getEffectRange:self.pEffect];
    __block XYClipModel *clipModel;
    [[XYEngineWorkspace clipMgr].clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.destVeRange.dwPos >= obj.destVeRange.dwPos && self.destVeRange.dwPos <= obj.destVeRange.dwPos + obj.destVeRange.dwLen) {
            self.relativeClipInfo.relativeStart = self.destVeRange.dwPos - obj.destVeRange.dwPos;
            clipModel = obj;
        };
    }];
    self.relativeClipInfo.destVeRange.dwPos = self.destVeRange.dwPos;
    self.relativeClipInfo.destVeRange.dwLen = self.destVeRange.dwLen;
    self.relativeClipInfo.clipIdentifier = clipModel.identifier;
    self.relativeClipInfo.relativeSourceStart = clipModel.trimVeRange.dwPos + self.relativeClipInfo.relativeStart;
    self.relativeClipInfo.videoDuration = [self.storyboard getDuration];
    if ([self.storyboard getDuration] == self.destVeRange.dwLen) {
        self.relativeClipInfo.isFullDuration = YES;
    } else {
        self.relativeClipInfo.isFullDuration = NO;
    }
    self.userDataModel.relativeClipInfo = self.relativeClipInfo;
    [self.storyboard setEffectUserData:self.pEffect effectUserData:[self.userDataModel yy_modelToJSONString]];
    
}

- (void)reload {
    [self reloadIdentifier];
    [self reloadMdestVeRange];
    [self reloadEffectSourceRange];
    [self reloadEffectTrimRange];
    [self reloadUserData];
    [self reloadRelativeClipInfo];
    [self reloadLayerId];
}

//1.根据clipIdentifier 找不到clip 删除effect， 根据自己相对clip的destRange 再次调整destRange
- (void)adjustEffect {
    XYClipModel *clipModel = [[XYEngineWorkspace clipMgr] fetchClipModelWithIdentifier:self.relativeClipInfo.clipIdentifier];
    if (!clipModel) {
        if (XYCommonEngineGroupIDBgmMusic == self.groupID) {
            if (!self.isEqualStoryboardDuration) {
                [self.storyboard removeEffect:self.pEffect];
                self.pEffect = nil;
            }
        } else {
            [self.storyboard removeEffect:self.pEffect];
            self.pEffect = nil;
        }
    } else {
        if (self.pEffect) {
            if (clipModel.adjustEffectValueModel.adjustType == XYAdjustEffectTypeCut) {
                NSMutableArray <XYVeRangeModel*> *cutRangeModels = [NSMutableArray array];
                NSArray <XYVeRangeModel *> *rangeModels = clipModel.adjustEffectValueModel.rangeModels;
                if (rangeModels.count == 2) {
                    BOOL headIsInCuts = NO;//头 是否在剪出的多段里 不在就删除
                    XYVeRangeModel *firstRangeModel = rangeModels.firstObject;
                    XYVeRangeModel *seconRangeModel = rangeModels.lastObject;
                    NSInteger preLen = clipModel.adjustEffectValueModel.preTrimModel.dwLen;
                    XYVeRangeModel *cutRange = [XYVeRangeModel VeRangeModelWithPosition:firstRangeModel.dwPos + firstRangeModel.dwLen length:seconRangeModel.dwPos - (firstRangeModel.dwPos + firstRangeModel.dwLen)];
                    //cut右边新生成的clip 这里是相对的无需考虑
                    NSInteger relativeTrimStart = self.relativeClipInfo.relativeSourceStart + clipModel.adjustEffectValueModel.preTrimModel.dwPos;//cut 是相对clip源的 进行修正
                    if (relativeTrimStart >= cutRange.dwPos && relativeTrimStart <= cutRange.dwPos + cutRange.dwLen) {
                        headIsInCuts = YES;
                    } else if (relativeTrimStart > cutRange.dwPos + cutRange.dwLen) {
                        self.relativeClipInfo.relativeStart = self.relativeClipInfo.relativeStart - cutRange.dwLen;
                    }
                    if (headIsInCuts) {
                        [self.storyboard removeEffect:self.pEffect];
                        self.pEffect = nil;
                    }
                }
            } else if (clipModel.adjustEffectValueModel.adjustType == XYAdjustEffectTypeTrim) {
                if (clipModel.adjustEffectValueModel.rangeModels.count > 0) {
                    XYVeRangeModel *preTrimModel = clipModel.adjustEffectValueModel.preTrimModel;
                    XYVeRangeModel *trimModel = clipModel.adjustEffectValueModel.rangeModels.firstObject;
                    if (XYCommonEngineClipModuleImage == clipModel.clipType) {
                        CGFloat excValue = trimModel.dwLen / (CGFloat)preTrimModel.dwLen;
                        self.relativeClipInfo.relativeStart = (NSInteger)(self.relativeClipInfo.relativeStart * excValue);
                    } else {
                        NSInteger relativeTrimStart = preTrimModel.dwPos + self.relativeClipInfo.relativeStart;
                        if (relativeTrimStart < trimModel.dwPos || relativeTrimStart > trimModel.dwPos + trimModel.dwLen) {
                            [self.storyboard removeEffect:self.pEffect];
                            self.pEffect = nil;
                        } else {
                            self.relativeClipInfo.relativeStart = self.relativeClipInfo.relativeStart - (trimModel.dwPos - preTrimModel.dwPos);
                        }
                    }
                }
            } else if (XYAdjustEffectTypeSpeed == clipModel.adjustEffectValueModel.adjustType) {
                CGFloat excValue = clipModel.speedValue / clipModel.adjustEffectValueModel.preSpeedValue;
                self.relativeClipInfo.relativeStart = (NSInteger)(self.relativeClipInfo.relativeStart / excValue);
            }
            if (self.relativeClipInfo.relativeStart < 0) {
                self.relativeClipInfo.relativeStart = 0;
            }
            self.destVeRange.dwPos = clipModel.destVeRange.dwPos + self.relativeClipInfo.relativeStart;
            if (self.destVeRange.dwPos > [self.storyboard getDuration] || self.destVeRange.dwLen <= 0 || self.destVeRange.dwPos < 0) {
                [self.storyboard removeEffect:self.pEffect];
                self.pEffect = nil;
            }
            if (self.destVeRange.dwPos +  self.destVeRange.dwLen > [self.storyboard getDuration]) {//部分超出了视频的总时长
                self.destVeRange.dwLen = [self.storyboard getDuration] - self.destVeRange.dwPos;
            }
            if (self.pEffect) {
                [self.storyboard setEffectRange:self.pEffect startPos:self.destVeRange.dwPos duration:self.destVeRange.dwLen];
            }
        }
    }
}

- (void)updateIndexInStoryboard:(NSInteger)indexInStoryboard {
    _indexInStoryboard = indexInStoryboard;
}

@end
