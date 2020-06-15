//
//  XYEffectVisionTextModel.m
//  XYCommonEngineKit
//
//  Created by 徐新元 on 2019/11/20.
//

#import "XYEffectVisionTextModel.h"
#import "XYStoryboard.h"
#import "XYEffectModel.h"
#import <XYCategory/XYCategory.h>

@implementation XYEffectVisionSubTitleLabelInfoModel


@end

@implementation XYEffectVisionTextModel

- (XYEngineModelType)engineModelType {
    return XYEngineModelTypeVisionText;
}

- (void)reload {
    NSLog(@"XYEffectVisionTextModel reload %@",self);
    [super reload];
    XYMultiTextInfo *multiTextInfo = [self.storyboard getStoryboardTextInfo:self.pEffect viewFrame:[XYCommonEngineGlobalData data].playbackViewFrame];
    
    MBool bHasBG = MTrue;
    MBool bIsAnimated = MTrue;
    MDWord dwBGFormat = QVET_BUBBLE_BG_FORMAT_NONE;
    
    [self.storyboard getTemplateTextOriginalSize:multiTextInfo.textTemplateFilePath
                                    previewFrame:[XYCommonEngineGlobalData data].playbackViewFrame
                                          bHasBG:&bHasBG
                                     bIsAnimated:&bIsAnimated
                                      dwBGFormat:&dwBGFormat];
    
    multiTextInfo.dwBGFormat = dwBGFormat;
    
    [self textInfoToEffectVisionTextModel:multiTextInfo];
}

- (void)textInfoToEffectVisionTextModel:(XYMultiTextInfo *)multiTextInfo {
    CGSize previewSize = [XYCommonEngineGlobalData data].playbackViewFrame.size;
    CGRect visionViewRect = [self rcDisplayRegionToVisionViewRect:multiTextInfo.rcRegionRatio previewSize:previewSize];
    
    self.textRegionRect = [self cgRectFromMRect:multiTextInfo.textRegionRatio];
    self.centerPoint = CGPointMake(visionViewRect.origin.x + visionViewRect.size.width/2.0, visionViewRect.origin.y + visionViewRect.size.height/2.0);
    self.width = visionViewRect.size.width;
    self.height = visionViewRect.size.height;
    self.templateID = multiTextInfo.textTemplateID;
    self.filePath = multiTextInfo.textTemplateFilePath;
    self.destVeRange.dwPos = multiTextInfo.startPosition;
    self.destVeRange.dwLen = multiTextInfo.duration;
    self.rotation = multiTextInfo.fRotateAngle;
    __block NSMutableArray *subTextList = [NSMutableArray array];
    [multiTextInfo.subTextInfoList enumerateObjectsUsingBlock:^(XYMultiSubTextInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XYEffectVisionSubTitleLabelInfoModel *subTextModel = [[XYEffectVisionSubTitleLabelInfoModel alloc] init];
        subTextModel.verticalReversal = obj.bVerReversal;
        subTextModel.horizontalReversal = obj.bHorReversal;
        subTextModel.text = obj.text;
        if (obj.clrText) {
            subTextModel.textColor = [UIColor xy_colorWithHexARGB:obj.clrText];
        } else {
            subTextModel.textColor = nil;
        }
        subTextModel.textLine = obj.textLine;
        subTextModel.textFontName = obj.fontName;
        subTextModel.textAlignment = obj.dwTextAlignment;
        subTextModel.isTextExtraEffectEnabled = obj.bEnableEffect;
        subTextModel.textStrokeWPercent = obj.fStrokeWPercent;
        if (obj.dwStrokeColor) {
            subTextModel.textStrokeColor = [UIColor xy_colorWithHexARGB:obj.dwStrokeColor];
        } else {
            subTextModel.textStrokeColor = nil;
        }
            
        if (obj.dwShadowColor) {
            subTextModel.textShadowColor = [UIColor xy_colorWithHexARGB:obj.dwShadowColor];
        } else {
            subTextModel.textShadowColor = nil;
        }
        
        subTextModel.textShadowXShift = obj.fDShadowXShift;
        subTextModel.textShadowYShift = obj.fDShadowYShift;
        subTextModel.textShadowBlurRadius = obj.fDShadowBlurRadius;
        [subTextList addObject:subTextModel];
    }];
    
    self.multiTextList = subTextList;
    self.isFrameMode = multiTextInfo.isFrameMode;
    self.isInstantRefresh = multiTextInfo.isInstantRefresh;

    
    self.textTransparency = multiTextInfo.dwTransparency;
    self.isStaticPicture = multiTextInfo.isStaticPicture;
    self.defaultIsStaticPicture = multiTextInfo.defaultIsStaticPicture;
    self.textBGFormat = multiTextInfo.dwBGFormat;
    self.isAnimatedText = multiTextInfo.isAnimatedText;
    self.themeTextType = multiTextInfo.themeTextType;
    self.themeTextSubIndex = multiTextInfo.themeTextSubIndex;
    self.textVersion = multiTextInfo.dwVersion;
    self.currentScale = multiTextInfo.scaleRatio;
    
    
    self.defaultWidth = self.userDataModel.defaultWidth;
    self.defaultHeight = self.userDataModel.defaultHeight;
    
    if (self.defaultWidth > 0) {
        self.currentScale = self.width/self.defaultWidth;
    }
}

@end
