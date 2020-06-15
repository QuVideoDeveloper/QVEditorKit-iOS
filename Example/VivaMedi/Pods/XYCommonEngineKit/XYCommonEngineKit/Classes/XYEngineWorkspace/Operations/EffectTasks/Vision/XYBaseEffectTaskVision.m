//
//  XYBaseEffectVisionTask.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/8.
//

#import "XYBaseEffectTaskVision.h"
#import "XYEffectVisionModel.h"
#import "XYEffectVisionTextModel.h"
#import "NSNumber+Language.h"
#import <XYCategory/XYCategory.h>
#import "NSNumber+Language.h"

@implementation XYBaseEffectTaskVision

#pragma mark - Basic

- (XYEngineTaskType)engineTaskType {
    return XYEngineTaskTypeVision;
}

- (XYCommonEngineTrackType)trackType {
    return XYCommonEngineTrackTypeVideo;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineBySelf;
}

-(CXiaoYingEffect *)pEffect {
    return self.effectModel.pEffect;
}

- (float)newEffectLayerId {
    if (XYCommonEngineGroupIDWatermark == self.effectModel.groupID) {
        return LAYER_ID_NEW_WATERMARK;
    }
    NSInteger timeLineCellIndex = self.effectModel.horizontalPosition - 2;//加在timeline的的第几行
    if (timeLineCellIndex < 0) {
        timeLineCellIndex = 0;
    }
    __block float newLayerID = LAYER_ID_VISION_BASE;
    __block NSInteger inListIdx = -1;//默认不在列表里
    [self.effectModel.everyCellMaxLayerIdList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger layerIdCellInListIndex = ([obj floatValue] - LAYER_ID_VISION_BASE) / LAYER_ID_EVERY_CELL_ADDEND;
        if (timeLineCellIndex == layerIdCellInListIndex) {
            inListIdx = idx;
            newLayerID = [obj floatValue] + LAYER_ID_ADDEND;//取到对应的行最大的layerid 加 一个特定的切片值 生成新的行最大layerid
            *stop = YES;
        }
    }];
    if (inListIdx >= 0) {//列表里有
        [self.effectModel.everyCellMaxLayerIdList replaceObjectAtIndex:inListIdx withObject:@(newLayerID)];
    } else {//不在列表里
        newLayerID = LAYER_ID_VISION_BASE + timeLineCellIndex * LAYER_ID_EVERY_CELL_ADDEND + LAYER_ID_ADDEND;
        [self.effectModel.everyCellMaxLayerIdList addObject:@(newLayerID)];
    }
    return newLayerID;
}

#pragma mark - Text
- (void)updateEffectVisionTextModelByTemplate:(NSString *)templateFilePath effectVisionTextModel:(XYEffectVisionTextModel *)effectVisionTextModel fullLanguage:(NSString *)fullLanguage {
    MBool bHasBG = MFalse;
    MRESULT res = 0;
    
    if (![self isTemplateFilePath:templateFilePath]) {
        return;
    }
    CGSize previewSize = [self previewSizeFromEffectVisionModel:effectVisionTextModel];
    CGSize size = CGSizeZero;
    MDWord dwLayoutMode = [self getLayoutMode:previewSize.width height:previewSize.height];
    MTChar *pTxtTemplate = (MTChar *)[templateFilePath UTF8String];
    CXiaoYingStyle *pStyle = [[CXiaoYingStyle alloc] init];
    
    //创建CXiaoYingStyle
    res = [pStyle Create:pTxtTemplate BGLayoutMode:dwLayoutMode SerialNo:MNull];
    if (res != QVET_ERR_NONE) {
        NSLog(@"[ENGINE]XYStoryboard getTemplateTextOriginalSize style Create err=0x%lx", res);
        [pStyle Destory];
        return;
    }
    
    //获取BubbleInfo
    MSIZE bgSize = {previewSize.width, previewSize.height};
    CXiaoYingEngine *cxiaoyingEngine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
    NSInteger languageID = [NSNumber xy_getLanguageID:fullLanguage];
//    AMVE_MUL_BUBBLETEXT_INFO *pMulInfo = MNull;

    CXiaoYingStyle *qStyle = [[CXiaoYingStyle alloc] init];
     CXiaoYingTextMulInfo *pInfo = MNull;
     AMVE_MUL_BUBBLETEXT_INFO *pMulInfo = MNull;
     static MHandle hTextEngine = MNull;
     MRESULT ret = 0;
     MPOINT pStbSize = {0};
    ret = [self.storyboard.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
     MSIZE size1 = {pStbSize.x, pStbSize.y};
     
     ret = [qStyle Create:[effectVisionTextModel.filePath UTF8String] BGLayoutMode:0 SerialNo:nil];
    pInfo = [qStyle GetTextMulInfo:self.engine languageID:[NSNumber xy_getLanguageID:[self.storyboard fetchLanguageCode]] bgSize:size1];
     pMulInfo = [pInfo getMulInfo];
        if (res) {
        NSLog(@"[ENGINE]XYStoryboard getTemplateTextOriginalSize style GetBubbleTemplateInfo err=0x%lx", res);
        [pStyle Destory];
        return;
    }
    NSMutableArray *subtitleArr = [NSMutableArray array];
    for (int i = 0; i < pMulInfo->dwTextCount; i++) {
        QVET_BUBBLE_TEMPLATE_INFO btInfo = pMulInfo->pMulBTInfo[i].btInfo;
        if (btInfo.bIsAnimated == MFalse) {//老类型的字幕模版，预览时长设成2000
            btInfo.dwMinDuration = 2000;
        }
        effectVisionTextModel.textRegionRect = [effectVisionTextModel cgRectFromMRect:btInfo.rcRegion];
        if (effectVisionTextModel.rotation == 0) {
            effectVisionTextModel.rotation = btInfo.fRotation;
        }
        if (effectVisionTextModel.destVeRange.dwLen == 0) {
            effectVisionTextModel.destVeRange.dwLen = btInfo.dwMinDuration;
        }
        XYEffectVisionSubTitleLabelInfoModel *subTextInfo = [XYEffectVisionSubTitleLabelInfoModel new];
        if (effectVisionTextModel.multiTextList.count <= 1 ) {
            NSString *dafaultText = effectVisionTextModel.multiTextList[0].text;
            if (![NSString xy_isEmpty:dafaultText]) {
                subTextInfo.text = dafaultText;
            }
        }
        subTextInfo.textDefault = [NSString stringWithUTF8String:btInfo.text.szDefaultText];
        if ([NSString xy_isEmpty:subTextInfo.text]) {
            subTextInfo.text = subTextInfo.textDefault;
        }
        effectVisionTextModel.textVersion = btInfo.dwVersion;
        if (btInfo.text.clrText && !effectVisionTextModel.useCustomTextInfo) {
            subTextInfo.textColor = [UIColor xy_colorWithHexARGB:btInfo.text.clrText];
        }
        effectVisionTextModel.textBGFormat = btInfo.dwBGFormat;
        
        effectVisionTextModel.defaultIsStaticPicture = (btInfo.bIsAnimated == MFalse);
        subTextInfo.isTextExtraEffectEnabled = YES;
        //如果useCustomTextInfo是NO的话，则用模版里的z属性
        if (!effectVisionTextModel.useCustomTextInfo) {
            subTextInfo.textAlignment = btInfo.text.dwAlignment;
            subTextInfo.textShadowColor = [UIColor xy_colorWithHexARGB:btInfo.text.dwShadowColor];
            subTextInfo.textShadowBlurRadius = btInfo.text.fDShadowBlurRadius;
            subTextInfo.textShadowXShift = btInfo.text.fDShadowXShift;
            subTextInfo.textShadowYShift = btInfo.text.fDShadowYShift;
            subTextInfo.textStrokeColor = [UIColor xy_colorWithHexARGB:btInfo.text.dwStrokeColor];
            subTextInfo.textStrokeWPercent = btInfo.text.fStrokeWPercent;
        }
        
        effectVisionTextModel.previewDuration = btInfo.dwMinDuration;
        effectVisionTextModel.userDataModel.previewDuration = btInfo.dwMinDuration;
        [subtitleArr addObject:subTextInfo];
    }
    
    if (!effectVisionTextModel.userDataModel) {
        effectVisionTextModel.userDataModel = [XYEffectUserDataModel new];
    }
    //视觉类效果公共属性
    if (effectVisionTextModel.centerPoint.x == 0 && effectVisionTextModel.centerPoint.y == 0) {
        effectVisionTextModel.centerPoint = CGPointMake(previewSize.width/2, previewSize.height/2);
    }
    
    
    
    effectVisionTextModel.destVeRange.dwLen = [self fixedDurationByPos:effectVisionTextModel.destVeRange.dwPos dwDuration:effectVisionTextModel.destVeRange.dwLen];
    
    effectVisionTextModel.alpha = 1.0;//暂时无效
    
    //字幕特有属性
    effectVisionTextModel.textTransparency = 100;//暂时无效
    
    
    
    effectVisionTextModel.isAnimatedText = [self.storyboard isAnimatedText:effectVisionTextModel.templateID];
    effectVisionTextModel.multiTextList = subtitleArr;
    res = [pStyle Destory];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getTemplateTextOriginalSize style Destory err=0x%lx", res);
    }
    return;
}

- (void)updateTextSizeInEffectVisionTextModel:(XYEffectVisionTextModel *)effectVisionTextModel {
    CGSize previewSize = [self previewSizeFromEffectVisionModel:effectVisionTextModel];
    CGFloat textScale = effectVisionTextModel.currentScale;
    
    //字幕的尺寸需要用引擎接口测量
    AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleMulSource = MNull;
       //字幕的尺寸需要用引擎接口测量
    XYEffectVisionSubTitleLabelInfoModel * subTitleModel;
    AMVE_BUBBLETEXT_SOURCE_TYPE *bubbleSource = nil;
    if (effectVisionTextModel.multiTextList.count > 0) {
        subTitleModel = effectVisionTextModel.multiTextList[0];
    }
    bubbleSource = [self.storyboard bubbleSourceWithTextTemplateID:effectVisionTextModel.templateID
                                                              text:subTitleModel.text
                                                      textFontName:subTitleModel.textFontName
                                                     textAlignment:subTitleModel.textAlignment
                                                  textEnableEffect:subTitleModel.isTextExtraEffectEnabled
                                                  textShadowXShift:subTitleModel.textShadowXShift
                                                  textShadowYShift:subTitleModel.textShadowYShift
                                                 textStrokePercent:subTitleModel.textStrokeWPercent];

    
    

    
    //1.0倍情况下算出来的默认字幕尺寸
    CGSize standardTextSize = [self.storyboard measureStandardTextSize:bubbleSource
                                                  textTemplateFilePath:effectVisionTextModel.filePath
                                                           previewSize:previewSize];
    
    //乘以当前放大倍数后的当前字幕尺寸
    CGSize currentTextSize = CGSizeMake(standardTextSize.width * textScale, standardTextSize.height * textScale);
    
    effectVisionTextModel.defaultWidth = standardTextSize.width;
    effectVisionTextModel.defaultHeight = standardTextSize.height;
    
    effectVisionTextModel.width = currentTextSize.width;
    effectVisionTextModel.height = currentTextSize.height;
    
    effectVisionTextModel.userDataModel.defaultWidth = standardTextSize.width;
    effectVisionTextModel.userDataModel.defaultHeight = standardTextSize.height;
}

- (XYMultiTextInfo *)mapToTextInfo:(XYEffectVisionTextModel *)effectVisionTextModel {
    CGSize previewSize = [self previewSizeFromEffectVisionModel:effectVisionTextModel];
    XYMultiTextInfo *multiTextInfo = [[XYMultiTextInfo alloc] init];
    multiTextInfo.identifier = effectVisionTextModel.identifier;
    multiTextInfo.textTemplateID = effectVisionTextModel.templateID;
    multiTextInfo.textTemplateFilePath = effectVisionTextModel.filePath;
    multiTextInfo.startPosition = effectVisionTextModel.destVeRange.dwPos;
    multiTextInfo.duration = effectVisionTextModel.destVeRange.dwLen;
    multiTextInfo.fRotateAngle = effectVisionTextModel.rotation;
    multiTextInfo.dwTransparency = effectVisionTextModel.textTransparency;
    //    textInfo.ptRotateCenter;
    multiTextInfo.rcRegionRatio = [self rcDispRegionFromEffectModel:effectVisionTextModel previewSize:previewSize];
    multiTextInfo.textRegionRatio = [self mrectFromCGRect:effectVisionTextModel.textRegionRect];
    multiTextInfo.isStaticPicture = effectVisionTextModel.isStaticPicture;
    multiTextInfo.defaultIsStaticPicture = effectVisionTextModel.defaultIsStaticPicture;
    multiTextInfo.dwBGFormat = effectVisionTextModel.textBGFormat;
    multiTextInfo.bIsAnimated = effectVisionTextModel.isAnimatedText;
    multiTextInfo.themeTextType = effectVisionTextModel.themeTextType;
    multiTextInfo.themeTextSubIndex = effectVisionTextModel.themeTextSubIndex;
    multiTextInfo.previewDuration = effectVisionTextModel.previewDuration;
    multiTextInfo.dwVersion = effectVisionTextModel.textVersion;
    multiTextInfo.isFrameMode = effectVisionTextModel.isFrameMode;
    multiTextInfo.isInstantRefresh = effectVisionTextModel.isInstantRefresh;
    multiTextInfo.pClip = effectVisionTextModel.pClip;
    multiTextInfo.userData = [effectVisionTextModel.userDataModel yy_modelToJSONString];
    multiTextInfo.scaleRatio = effectVisionTextModel.currentScale;
    NSMutableArray *multiTextList = [NSMutableArray array];
    [effectVisionTextModel.multiTextList enumerateObjectsUsingBlock:^(XYEffectVisionSubTitleLabelInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYMultiSubTextInfo *subTextInfo = [[XYMultiSubTextInfo alloc] init];
        subTextInfo.text = obj.text;
        subTextInfo.textColor = obj.textColor;
        
        subTextInfo.clrText = [UIColor xy_hexARGBWithColor:obj.textColor];
        subTextInfo.textLine = obj.textLine;
        //    textInfo.textOneLineHeight = effectVisionTextModel.;
        subTextInfo.bVerReversal = obj.verticalReversal;
        subTextInfo.bHorReversal = obj.horizontalReversal;
        subTextInfo.fontName = obj.textFontName;
        subTextInfo.dwTextAlignment = obj.textAlignment;
        subTextInfo.bEnableEffect = obj.isTextExtraEffectEnabled;
        subTextInfo.dwStrokeColor = [UIColor xy_hexARGBWithColor:obj.textStrokeColor];
        subTextInfo.fStrokeWPercent = obj.textStrokeWPercent;
        subTextInfo.dwShadowColor = [UIColor xy_hexARGBWithColor:obj.textShadowColor];
        subTextInfo.fDShadowBlurRadius = obj.textShadowBlurRadius;
        subTextInfo.fDShadowXShift = obj.textShadowXShift;
        subTextInfo.fDShadowYShift = obj.textShadowYShift;
        [multiTextList addObject:subTextInfo];
    }];
    multiTextInfo.subTextInfoList = multiTextList;
    return multiTextInfo;
}

#pragma mark - Sticker
- (void)updateEffectVisionStickerModelByTemplate:(NSString *)templateFilePath effectVisionModel:(XYEffectVisionModel *)effectVisionModel {

    CGSize previewSize = [self previewSizeFromEffectVisionModel:effectVisionModel];
    
    QVET_ANIMATED_FRAME_TEMPLATE_INFO animatedFrameInfo = {0};
    MSIZE bgSize = {0};
    bgSize.cx = previewSize.width;
    bgSize.cy = previewSize.height;
    
    MRESULT res = QVET_ERR_NONE;
    res = [CXiaoYingUtils GetAnimatedFrameInfo:self.engine FrameFile:(MChar *)self.filePath.UTF8String BGSzie:&bgSize FrameInfo:&animatedFrameInfo];
    
    if (res) {
        NSLog(@"[ENGINE]GetAnimatedFrameInfo err=0x%lx", res);
    }
    
    CGRect visionRect = [effectVisionModel rcDisplayRegionToVisionViewRect:animatedFrameInfo.rcDispRegion previewSize:previewSize];
    
    if (!effectVisionModel.userDataModel) {
        effectVisionModel.userDataModel = [XYEffectUserDataModel new];
    }
    
    CGFloat oldDefaultWidth = effectVisionModel.defaultWidth;
    
    effectVisionModel.defaultWidth = visionRect.size.width;
    effectVisionModel.userDataModel.defaultWidth = visionRect.size.width;
    
    effectVisionModel.defaultHeight = visionRect.size.height;
    effectVisionModel.userDataModel.defaultHeight = visionRect.size.height;
    
    CGFloat newDefaultWidth = effectVisionModel.defaultWidth;
    CGFloat newDefaultHeight = effectVisionModel.defaultHeight;
    
    CGFloat currentScale = effectVisionModel.currentScale;
    
    if (effectVisionModel.currentScale != 1.0) {
        effectVisionModel.width = effectVisionModel.defaultWidth * currentScale;
        effectVisionModel.height = effectVisionModel.defaultHeight * currentScale;
    }
    
   if (effectVisionModel.reCalculateFrame) {
        effectVisionModel.width = effectVisionModel.defaultWidth;
        effectVisionModel.height = effectVisionModel.defaultHeight;
        effectVisionModel.reCalculateFrame = NO;
    } else {
        if (effectVisionModel.width == 0) {
            effectVisionModel.width = effectVisionModel.defaultWidth;
        }
        
        if (effectVisionModel.height == 0) {
            effectVisionModel.height = effectVisionModel.defaultHeight;
        }
    }
    
    [effectVisionModel updateAllKeyFramesWithOldDefaultWidth:oldDefaultWidth newDefaultWidth:newDefaultWidth newDefaultHeight:newDefaultHeight];
    
    if (effectVisionModel.centerPoint.x == 0 && effectVisionModel.centerPoint.y == 0) {
        effectVisionModel.centerPoint = CGPointMake(visionRect.origin.x + visionRect.size.width/2, visionRect.origin.y + visionRect.size.height/2);
    }
    
    if (effectVisionModel.destVeRange.dwLen == 0) {
        effectVisionModel.destVeRange.dwLen = animatedFrameInfo.dwDuration;
    }
    
    effectVisionModel.destVeRange.dwLen = [self fixedDurationByPos:effectVisionModel.destVeRange.dwPos dwDuration:effectVisionModel.destVeRange.dwLen];
    effectVisionModel.previewDuration = [self fixedDurationByPos:effectVisionModel.destVeRange.dwPos dwDuration:animatedFrameInfo.dwDuration];
    effectVisionModel.userDataModel.previewDuration = effectVisionModel.previewDuration;
    effectVisionModel.hasAudio = animatedFrameInfo.bHasAudio;
    
    if (effectVisionModel.groupID != GROUP_ID_WATERMARK) {//水印的Alpha值需要外面设
        effectVisionModel.alpha = 1.0;
    }
}

- (StickerInfo *)mapToStickerInfo:(XYEffectVisionModel *)effectVisionModel {
    CGSize previewSize = [self previewSizeFromEffectVisionModel:effectVisionModel];
    
    StickerInfo *stickerInfo = [[StickerInfo alloc] init];
    stickerInfo.identifier = effectVisionModel.identifier;
    stickerInfo.xytFilePath = effectVisionModel.filePath;
    stickerInfo.startPos = effectVisionModel.destVeRange.dwPos;
    stickerInfo.dwCurrentDuration = effectVisionModel.destVeRange.dwLen;
    stickerInfo.fRotateAngle = effectVisionModel.rotation;
    stickerInfo.bVerReversal = effectVisionModel.verticalReversal;
    stickerInfo.bHorReversal = effectVisionModel.horizontalReversal;
    stickerInfo.isFrameMode = effectVisionModel.isFrameMode;
    stickerInfo.isStaticPicture = effectVisionModel.isStaticPicture;
    stickerInfo.rcRegionRatio = [self rcDispRegionFromEffectModel:effectVisionModel previewSize:previewSize];
    stickerInfo.isInstantRefresh = effectVisionModel.isInstantRefresh;
    stickerInfo.alpha = effectVisionModel.alpha;
    stickerInfo.mosaicRatio = effectVisionModel.propData;
    stickerInfo.pClip = effectVisionModel.pClip;
    stickerInfo.userData = [effectVisionModel.userDataModel yy_modelToJSONString];
    
    stickerInfo.dwSourceStartPos = effectVisionModel.sourceVeRange.dwPos;
    stickerInfo.dwSourceDuration = effectVisionModel.sourceVeRange.dwLen;
    
    stickerInfo.dwTrimStartPos = effectVisionModel.trimVeRange.dwPos;
    stickerInfo.dwTrimDuration = effectVisionModel.trimVeRange.dwLen;
    
    stickerInfo.dwDefaultDuration = effectVisionModel.previewDuration;
    stickerInfo.volume = effectVisionModel.volume;
    
    return stickerInfo;
}

#pragma mark - KeyFrame
- (void)setKeyFrames:(NSArray<XYEffectVisionKeyFrameModel *> *)keyFrames
   effectVisionModel:(XYEffectVisionModel *)effectVisionModel {
    if ([keyFrames count] > 0) {
        XYEffectVisionKeyFrameModel *firstKeyFrame = keyFrames[0];
        CGSize previewSize = [self previewSizeFromEffectVisionModel:effectVisionModel];
        MRECT rect = [self rcDispRegionFromCenterPoint:firstKeyFrame.centerPoint
                                                 width:effectVisionModel.defaultWidth
                                                height:effectVisionModel.defaultHeight
                                           previewSize:previewSize];
        [self.storyboard updateKeyframeTransformOriginRegion:rect effect:effectVisionModel.pEffect];
    }
    
    NSArray <XYEffectVisionKeyFrameModel *> *array = [NSArray arrayWithArray:keyFrames];
    NSMutableArray<CXiaoYingKeyFrameTransformValue *> *newArray = [NSMutableArray array];
    __block XYEffectVisionKeyFrameModel *preKeyFrameModel = nil;
    [array enumerateObjectsUsingBlock:^(XYEffectVisionKeyFrameModel * _Nonnull keyFrame, NSUInteger idx, BOOL * _Nonnull stop) {
        if(keyFrame.needUpdateFrameModelLater) {
            //字幕这种由于尺寸是业务层调用updateFrame之后通过引擎计算的，因此需要在将关键帧信息设给引擎前根据计算出来的宽高，再更新一下关键帧
            keyFrame.width = effectVisionModel.width;
            keyFrame.height = effectVisionModel.height;
            keyFrame.needUpdateFrameModelLater = NO;
        }
        CXiaoYingKeyFrameTransformValue *keyFrameTrnsformValue = [self mapToKeyFrameTransformValue:keyFrame preKeyFrameModel:preKeyFrameModel];
        preKeyFrameModel = keyFrame;
        preKeyFrameModel.rotation = keyFrame.rotation;
        [newArray addObject:keyFrameTrnsformValue];
    }];
    
    [self.storyboard setKeyframeData:newArray effect:effectVisionModel.pEffect];
    

}

- (CXiaoYingKeyFrameTransformValue *)mapToKeyFrameTransformValue:(XYEffectVisionKeyFrameModel *)keyFrameModel
                                                preKeyFrameModel:(XYEffectVisionKeyFrameModel *)preKeyFrameModel {
    CGSize previewSize = [self previewSizeFromEffectVisionModel:self.effectModel];
    CXiaoYingKeyFrameTransformValue *keyFrameTransformValue = [CXiaoYingKeyFrameTransformValue new];
    
    keyFrameTransformValue->ts = keyFrameModel.position;
    MPOINT centerPoint = { 10000*keyFrameModel.centerPoint.x/previewSize.width, 10000*keyFrameModel.centerPoint.y/previewSize.height};
    keyFrameTransformValue->position = centerPoint;
    
    if (preKeyFrameModel) {//不是第一个关键帧，需要计算一下
        keyFrameModel.rotation = [self calculateNewRotationWithPreviousRotation:preKeyFrameModel.rotation currentRotation:keyFrameModel.rotation];
    } else {//是第一个关键帧，不需要计算，直接用这个角度
        
    }
    keyFrameTransformValue->rotation = keyFrameModel.rotation;
    
    CGFloat baseWidth = [self.storyboard geteEffectKeyframeBaseWidthWithEffect:self.effectModel.pEffect];
    CGFloat baseHeight = [self.storyboard geteEffectKeyframeBaseHeightWithEffect:self.effectModel.pEffect];
    
    if (baseWidth > 0) {
        keyFrameTransformValue->widthRatio = 10000.0*keyFrameModel.width/previewSize.width/baseWidth;
    }
    
    if (baseHeight > 0) {
        keyFrameTransformValue->heightRatio = 10000.0*keyFrameModel.height/previewSize.height/baseHeight;
    }

    return keyFrameTransformValue;
}

/// 以顺时针旋转360度为一个基准，根据两个关键帧旋转的角度差来判断, 当顺时针旋转小于180’的 顺时针旋转,当顺时针旋转大于180‘的  逆时针旋转,两个关键帧之间的旋转角度 最大180’
/// @param prevRotation 上一个关键帧的旋转角度
/// @param currentRotation 当前关键帧的旋转角度
- (float)calculateNewRotationWithPreviousRotation:(float)prevRotation currentRotation:(float)currentRotation {
    while ((currentRotation - prevRotation > 180) || (currentRotation - prevRotation < -180)) {
        if (currentRotation - prevRotation > 180) {
            currentRotation = currentRotation - 360;
        } else if (currentRotation - prevRotation < -180) {
            currentRotation = currentRotation + 360;
        }
    }
    return currentRotation;
}

#pragma mark - Utils
//需要限制effect的最大时长不能超过Storyboard的长度
- (MDWord)fixedDurationByPos:(MDWord)dwPos dwDuration:(MDWord)dwDuration {
    MDWord storyboardDuration = [self.storyboard getDuration];
    if (dwPos >= storyboardDuration) {
        NSAssert(NO, @"效果起始点超过了storyboard总时长");
        return 0;
    }
    if (dwPos + dwDuration > storyboardDuration) {
        dwDuration = storyboardDuration - dwPos;
    }
    return dwDuration;
}

- (BOOL)isTemplateFilePath:(NSString *)filePath {
    return !(![filePath hasPrefix:@"PHASSET:"] && ![filePath hasPrefix:@"ipod-library:"] && ![self xy_isFileExist:filePath]);
}

- (CGSize)previewSizeFromEffectVisionModel:(XYEffectVisionModel *)effectVisionModel {
    return [XYCommonEngineGlobalData data].playbackViewFrame.size;
}

- (MRECT)rcDispRegionFromEffectModel:(XYEffectVisionModel *)effectVisionModel previewSize:(CGSize)previewSize {
    CGPoint centerPont = effectVisionModel.centerPoint;
    CGFloat width = effectVisionModel.width;
    CGFloat height = effectVisionModel.height;
    return [self rcDispRegionFromCenterPoint:centerPont width:width height:height previewSize:previewSize];
}

- (MRECT)rcDispRegionFromCenterPoint:(CGPoint)centerPoint
                               width:(CGFloat)width
                              height:(CGFloat)height
                         previewSize:(CGSize)previewSize {
    CGFloat originX = centerPoint.x - width/2;
    CGFloat originY = centerPoint.y - height/2;
    
    MRECT rcDispRegion = {0,0,0,0};
    if (previewSize.width > 0 && previewSize.height > 0 ) {
        rcDispRegion.left = originX * 10000 / previewSize.width;
        rcDispRegion.top = originY * 10000 / previewSize.height;
        rcDispRegion.right = (originX + width) * 10000 / previewSize.width;
        rcDispRegion.bottom = (originY + height) * 10000 / previewSize.height;
    }
    
    return rcDispRegion;
}

- (MRECT)mrectFromCGRect:(CGRect)cgRect {
    MRECT rect = {cgRect.origin.x, cgRect.origin.y, cgRect.origin.x+cgRect.size.width, cgRect.origin.y+cgRect.size.height};
    return rect;
}

- (int)getLayoutMode:(int)width height:(int)height {
    float r0, r1, r2;
    int mode = QVTP_LAYOUT_MODE_W4_H3;
    if (width == 0 || height == 0)
        return mode;
    if (width == height)
        return QVTP_LAYOUT_MODE_W1_H1;
    r0 = (float)width / height;
    if (width > height) {
        r1 = r0 - (float)4 / 3;
        r2 = r0 - (float)16 / 9;
        if (r1 < 0)
            r1 = -r1;
        if (r2 < 0)
            r2 = -r2;
        if (r1 < r2)
            mode = QVTP_LAYOUT_MODE_W4_H3;
        else
            mode = QVTP_LAYOUT_MODE_W16_H9;
    } else {
        r1 = r0 - (float)3 / 4;
        r2 = r0 - (float)9 / 16;
        if (r1 < 0)
            r1 = -r1;
        if (r2 < 0)
            r2 = -r2;
        if (r1 < r2)
            mode = QVTP_LAYOUT_MODE_W3_H4;
        else
            mode = QVTP_LAYOUT_MODE_W9_H16;
    }
    return mode;
}

- (BOOL)xy_isFileExist:(NSString *)filePath
{
    NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath] && ([fileDictionary fileSize] != 0);
}

@end
