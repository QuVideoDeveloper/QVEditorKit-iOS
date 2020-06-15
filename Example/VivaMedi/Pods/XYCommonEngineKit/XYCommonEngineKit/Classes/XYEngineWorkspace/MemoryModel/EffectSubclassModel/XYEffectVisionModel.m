//
//  XYEffectVisionModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/8.
//

#import "XYEffectVisionModel.h"
#import "XYStoryboard.h"

@implementation XYEffectVisionKeyFrameModel

@end

@interface XYEffectVisionModel ()

@property (nonatomic, strong) NSMutableArray<XYEffectVisionKeyFrameModel *> *privateKeyFrames;

@end

@implementation XYEffectVisionModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.volume = 50;
    }
    return self;
}

- (instancetype)init:(XYEngineConfigModel *)config {
    self = [super init:config];
    if (self) {
        self.volume = 50;
    }
    return self;
}

- (XYEngineModelType)engineModelType {
    return XYEngineModelTypeVision;
}

- (void)reload {
    [super reload];
    
    //是否支持Instant refresh的标志，load工程后需要重新设置
    [self reloadInstantRefresh];
    //视觉类效果都支持关键帧，这里统一reload
    [self reloadKeyFrames];
    [self reloadDefaultWidthAndHeight];
    [self reloadPreviewDuration];
    
    if (self.groupID != XYCommonEngineGroupIDText) {//字幕数据有点不同，放到字幕自己的model里去reload
        StickerInfo *stickerInfo = [self.storyboard getStoryboardStickerInfo:self.pEffect];
        [self stickerInfoToEffectVisionModel:stickerInfo];
    }
}

- (CGRect)rcDisplayRegionToVisionViewRect:(MRECT)regionRect previewSize:(CGSize)previewSize {
    CGRect viewRect = CGRectZero;
    if (previewSize.width > 0 && previewSize.height > 0) {
        MRECT innerRect = {0};
        innerRect.left = 0;
        innerRect.top = 0;
        innerRect.right = innerRect.left + previewSize.width;
        innerRect.bottom = innerRect.top + previewSize.height;
        
        MLong innerRectLeft = innerRect.left;
        MLong innerRectTop = innerRect.top;
        MLong innerRectWidth = (innerRect.right - innerRect.left);
        MLong innerRectHeight = (innerRect.bottom - innerRect.top);
        
        CGFloat finalRectLeft = innerRectLeft + regionRect.left/10000.0f*innerRectWidth;
        CGFloat finalRectTop = innerRectTop + regionRect.top/10000.0f*innerRectHeight;
        CGFloat finalRectWidth = (regionRect.right - regionRect.left)/10000.0f*innerRectWidth;
        CGFloat finalRectHeight = (regionRect.bottom - regionRect.top)/10000.0f*innerRectHeight;
        
        viewRect = CGRectMake(finalRectLeft, finalRectTop, finalRectWidth, finalRectHeight);
    }
    return viewRect;
}

- (CGRect)cgRectFromMRect:(MRECT)mRect {
    CGRect cgRect = CGRectMake(mRect.left, mRect.top, mRect.right-mRect.left, mRect.bottom-mRect.top);
    return cgRect;
}

#pragma mark - 关键帧
- (void)addNewKeyFrame:(NSInteger)position {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.keyFrames];
     XYEffectVisionKeyFrameModel *keyFrameModel = [self createNewKeyFrameModel:position];
    [array addObject:keyFrameModel];
    [array sortUsingComparator:^NSComparisonResult(XYEffectVisionKeyFrameModel *  _Nonnull keyFrame1, XYEffectVisionKeyFrameModel *  _Nonnull keyFrame2) {
        return [@(keyFrame1.position) compare:@(keyFrame2.position)];
    }];
    self.privateKeyFrames = array;
}

- (void)deleteKeyFrame:(NSInteger)position {
    if ([self.keyFrames count] == 0) {
        return;
    }
    NSInteger index = [self keyFrameIndexByPosition:position];
    
    NSMutableArray <XYEffectVisionKeyFrameModel *> *array = [NSMutableArray arrayWithArray:self.keyFrames];
    if (index >= 0 && index < [array count]) {
        [array removeObjectAtIndex:index];
    }
    self.privateKeyFrames = array;
}

- (void)updateKeyFrame:(NSInteger)position {
    if ([self.keyFrames count] == 0) {
        return;
    }
    NSInteger index = [self keyFrameIndexByPosition:position];
    
    NSArray <XYEffectVisionKeyFrameModel *> *array = [NSArray arrayWithArray:self.keyFrames];
    if (index >= 0 && index < [self.privateKeyFrames count]) {
        XYEffectVisionKeyFrameModel *keyFrame = self.privateKeyFrames[index];
        [self updateKeyFrameModel:keyFrame];
    }
}

- (void)updateAllKeyFramesWithOldDefaultWidth:(CGFloat)oldDefaultWidth newDefaultWidth:(CGFloat)newDefaultWidth newDefaultHeight:(CGFloat)newDefaultHeight {
    if ([self.privateKeyFrames count] == 0) {
        return;
    }
    
    CGFloat newRatio = self.width/self.height;
    [self.privateKeyFrames enumerateObjectsUsingBlock:^(XYEffectVisionKeyFrameModel * _Nonnull keyFrameModel, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat scale = keyFrameModel.width/oldDefaultWidth;
        keyFrameModel.width = newDefaultWidth * scale;
        keyFrameModel.height = newDefaultHeight * scale;
    }];
}

#pragma mark - Private
- (void)stickerInfoToEffectVisionModel:(StickerInfo *)stickerInfo {
    CGSize previewSize = [XYCommonEngineGlobalData data].playbackViewFrame.size;
    CGRect visionViewRect = [self rcDisplayRegionToVisionViewRect:stickerInfo.rcRegionRatio previewSize:previewSize];
    
    self.width = visionViewRect.size.width;
    self.height = visionViewRect.size.height;
    self.centerPoint = CGPointMake(visionViewRect.origin.x + visionViewRect.size.width/2.0, visionViewRect.origin.y + visionViewRect.size.height/2.0);
    self.filePath = stickerInfo.xytFilePath;
    self.destVeRange.dwPos = stickerInfo.startPos;
    self.destVeRange.dwLen = stickerInfo.dwCurrentDuration;
    self.rotation = stickerInfo.fRotateAngle;
    self.verticalReversal = stickerInfo.bVerReversal;
    self.horizontalReversal = stickerInfo.bHorReversal;
    self.isFrameMode = stickerInfo.isFrameMode;
    self.isStaticPicture = stickerInfo.isStaticPicture;
    self.isInstantRefresh = stickerInfo.isInstantRefresh;
    self.alpha = stickerInfo.alpha;
    self.propData = stickerInfo.mosaicRatio;
    self.previewDuration = stickerInfo.dwDefaultDuration;
    self.volume = stickerInfo.volume;
    self.hasAudio = stickerInfo.bHasAudio == MTrue;
}

- (void)reloadDefaultWidthAndHeight {
    self.defaultWidth = self.userDataModel.defaultWidth;
    self.defaultHeight = self.userDataModel.defaultHeight;
}

- (void)reloadPreviewDuration {
    self.previewDuration = self.userDataModel.previewDuration;
}

- (void)reloadMtrimVeRange {
    CXiaoYingClip *pStbDataClip = [self.storyboard.cXiaoYingStoryBoardSession getDataClip];
    AMVE_POSITION_RANGE_TYPE trimVeRange = [self.storyboard getClipAudioTrimRange:pStbDataClip audioClipIndex:self.indexInStoryboard groupID:self.groupID layerID:self.layerID];
    XYVeRangeModel *trimVeRangeModel = [[XYVeRangeModel alloc] init];
    trimVeRangeModel.dwPos = trimVeRange.dwPos;
    trimVeRangeModel.dwLen = trimVeRange.dwLen;
    self.trimVeRange = trimVeRangeModel;
}

- (void)reloadInstantRefresh {
    MBool supportInstantRefresh = MTrue;
    MRESULT ret = [self.pEffect setProperty:AVME_PROP_EFFECT_INSTANT_VIDEO_TRANSFORM_SET PropertyData:&supportInstantRefresh];
}

- (void)reloadKeyFrames {
    NSArray<CXiaoYingKeyFrameTransformValue *> *keyFrameTransformValues = [self.storyboard getKeyframeData:self.pEffect];
    
    NSArray <CXiaoYingKeyFrameTransformValue *> *array = [NSArray arrayWithArray:keyFrameTransformValues];
       NSMutableArray<XYEffectVisionKeyFrameModel *> *newArray = [NSMutableArray array];
       [array enumerateObjectsUsingBlock:^(CXiaoYingKeyFrameTransformValue * _Nonnull keyFrameTransformValue, NSUInteger idx, BOOL * _Nonnull stop) {
           XYEffectVisionKeyFrameModel *keyFrameModel = [self mapToKeyFrameModel:keyFrameTransformValue];
           [newArray addObject:keyFrameModel];
       }];
    self.privateKeyFrames = newArray;
}

- (XYEffectVisionKeyFrameModel *)mapToKeyFrameModel:(CXiaoYingKeyFrameTransformValue *)keyFrameTransformValue {
    CGSize previewSize = [XYCommonEngineGlobalData data].playbackViewFrame.size;
    XYEffectVisionKeyFrameModel *keyFrameModel = [XYEffectVisionKeyFrameModel new];
    keyFrameModel.position = keyFrameTransformValue->ts;
    keyFrameModel.centerPoint = CGPointMake(keyFrameTransformValue->position.x/10000.0*previewSize.width, keyFrameTransformValue->position.y/10000.0*previewSize.height);
    keyFrameModel.rotation = keyFrameTransformValue->rotation;
    NSInteger effectRegionWidth = [self.storyboard geteEffectKeyframeBaseWidthWithEffect:self.pEffect]*keyFrameTransformValue->widthRatio;
    NSInteger effectRegionHeight = [self.storyboard geteEffectKeyframeBaseHeightWithEffect:self.pEffect]*keyFrameTransformValue->heightRatio;
    keyFrameModel.width = effectRegionWidth/10000.0*previewSize.width;
    keyFrameModel.height = effectRegionHeight/10000.0*previewSize.height;
    
    return keyFrameModel;
}

- (XYEffectVisionKeyFrameModel *)createNewKeyFrameModel:(NSInteger)position {
    XYEffectVisionKeyFrameModel *keyFrameModel = [XYEffectVisionKeyFrameModel new];
    keyFrameModel.position = position;
    keyFrameModel.rotation = self.rotation;
    keyFrameModel.centerPoint = self.centerPoint;
    keyFrameModel.width = self.width;
    keyFrameModel.height = self.height;
    
    return keyFrameModel;
}

- (void)updateKeyFrameModel:(XYEffectVisionKeyFrameModel *)keyFrameModel {
    keyFrameModel.rotation = self.rotation;
    keyFrameModel.centerPoint = self.centerPoint;
    keyFrameModel.width = self.width;
    keyFrameModel.height = self.height;
    
    if (self.groupID == XYCommonEngineGroupIDText) {
        keyFrameModel.needUpdateFrameModelLater = YES;
    }
}

- (NSInteger)keyFrameIndexByPosition:(NSInteger)position {
    __block NSInteger index = -1;
    NSArray <XYEffectVisionKeyFrameModel *> *array = [NSArray arrayWithArray:self.keyFrames];
    [array enumerateObjectsUsingBlock:^(XYEffectVisionKeyFrameModel * _Nonnull keyFrame, NSUInteger idx, BOOL * _Nonnull stop) {
        if (keyFrame.position == position) {
            *stop;
            index = idx;
        }
    }];
    return index;
}

- (NSMutableArray<XYEffectVisionKeyFrameModel *> *)privateKeyFrames {
    if (!_privateKeyFrames) {
        _privateKeyFrames = [NSMutableArray array];
    }
    return _privateKeyFrames;
}

- (NSMutableArray<XYEffectVisionKeyFrameModel *> *)keyFrames {
    return self.privateKeyFrames;
}

- (CGFloat)currentScale {
    if (self.groupID == XYCommonEngineGroupIDText) {
        if (_currentScale == 0) {
            return 1.0;
        }
        return _currentScale;
    }
    
    
    CGFloat scale = 0;
    if (self.width>0 && self.defaultWidth>0) {
        scale = self.width/self.defaultWidth;
    } else {
        scale = 1.0;
    }
    return scale;
}


@end
