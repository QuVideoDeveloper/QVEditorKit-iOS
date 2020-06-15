//
//  XYVirtualSourceInfoNode.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import "XYSlideShowSourceNode.h"
#import "CXiaoYingVirtualSourceInfoNode.h"
#import "XYRectModel.h"
#import "XYVeRangeModel.h"
#import "XYSlideShowTransformModel.h"
#import "XYAutoEditMgr.h"
#import "XYSlideShowMedia.h"
#import "XYSlideshowEidtCommon.h"
#import "XYSourceInfoNodeHelper.h"

@interface XYSlideShowSourceNode ()

@end

@implementation XYSlideShowSourceNode

- (UInt32)previewPos{
    return self.vSourceInfoNode.uiPreviewPos;
}

- (NSString *)mediaPath{
    return [self.vSourceInfoNode.pSourceFile copy];
}


- (NSInteger)sceneIndex
{
    return (NSInteger)_vSourceInfoNode.uiSceneIndex;
}

- (UInt32)sceneDuration
{
    return _vSourceInfoNode.uiSceneDuration;
}

- (XYSlideShowMediaType)mediaType
{
    return [XYSourceInfoNodeHelper getXYSourceInfoTypeByInnerSourceType:self.vSourceInfoNode.uiSourceType];
}

- (NSInteger)focusCenterX{
    CXiaoYingVirtualVideoSourceInfo *videoSourceInfo = [self getVideoSourceInfo];
    if (videoSourceInfo) {
        return videoSourceInfo.siPicCenterX;
    }
    CXiaoYingVirtualImageSourceInfo *imageSourceInfo = [self getImageSourceInfo];
    if (imageSourceInfo) {
        return imageSourceInfo.siFaceCenterX;
    }
    return 0;
}

- (void)setFocusCenterX:(NSInteger)focusCenterX
{
    CXiaoYingVirtualVideoSourceInfo *videoSourceInfo = [self getVideoSourceInfo];
    if (videoSourceInfo) {
        videoSourceInfo.siPicCenterX = (SInt32)focusCenterX;
    }
    CXiaoYingVirtualImageSourceInfo *imageSourceInfo = [self getImageSourceInfo];
    if (imageSourceInfo) {
        imageSourceInfo.siFaceCenterX = (SInt32)focusCenterX;
    }
}

- (NSInteger)focusCenterY{
    CXiaoYingVirtualVideoSourceInfo *videoSourceInfo = [self getVideoSourceInfo];
    if (videoSourceInfo) {
        return videoSourceInfo.siPicCenterY;
    }
    CXiaoYingVirtualImageSourceInfo *imageSourceInfo = [self getImageSourceInfo];
    if (imageSourceInfo) {
        return imageSourceInfo.siFaceCenterY;
    }
    return 0;
}

- (void)setFocusCenterY:(NSInteger)focusCenterY
{
    CXiaoYingVirtualVideoSourceInfo *videoSourceInfo = [self getVideoSourceInfo];
    if (videoSourceInfo) {
        videoSourceInfo.siPicCenterY = (SInt32)focusCenterY;
    }
    CXiaoYingVirtualImageSourceInfo *imageSourceInfo = [self getImageSourceInfo];
    if (imageSourceInfo) {
        imageSourceInfo.siFaceCenterY = (SInt32)focusCenterY;
    }
}

- (CGFloat)aspectRatio
{
    return self.vSourceInfoNode.fAspectRatio;
}

- (BOOL)playtoEnd
{
    CXiaoYingVirtualVideoSourceInfo *videoSourceInfo = [self getVideoSourceInfo];
    if (videoSourceInfo) {
        return videoSourceInfo.bPlaytoEnd;
    }
    return NO;
}


- (BOOL)faceDetected
{
    CXiaoYingVirtualImageSourceInfo *imageSourceInfo = [self getImageSourceInfo];
    if (imageSourceInfo) {
        return imageSourceInfo.bFaceDetected;
    }
    return NO;
}


- (CXiaoYingVirtualVideoSourceInfo *)getVideoSourceInfo
{
    if ([self.vSourceInfoNode.pVirtualSourceInfo isKindOfClass:[CXiaoYingVirtualVideoSourceInfo class]]) {
        return (CXiaoYingVirtualVideoSourceInfo *)self.vSourceInfoNode.pVirtualSourceInfo;
    }
    return nil;
}

- (CXiaoYingVirtualImageSourceInfo *)getImageSourceInfo
{
    if ([self.vSourceInfoNode.pVirtualSourceInfo isKindOfClass:[CXiaoYingVirtualImageSourceInfo class]]) {
        return (CXiaoYingVirtualImageSourceInfo *)self.vSourceInfoNode.pVirtualSourceInfo;
    }
    return nil;
}

- (instancetype)initWithVSourceInfoNode:(CXiaoYingVirtualSourceInfoNode *)vSourceInfoNode{
    self = [super init];
    if (self) {
        _vSourceInfoNode = vSourceInfoNode;
        if (!_trimRange) {
            _trimRange = [[XYVeRangeModel alloc] init];
        }
        CXiaoYingVirtualVideoSourceInfo *videoSourceInfo = [self getVideoSourceInfo];
        if (videoSourceInfo) {
            _trimRange.dwPos = videoSourceInfo.trimRange.uiPosition;
            _trimRange.dwLen = videoSourceInfo.trimRange.uiLen;
        }
    }
    return self;
}

- (XYSlideShowTransformModel *)transform {
    if (!_transform) {
        _transform = [[XYSlideShowTransformModel alloc] init];
        [self update_transform];
    }
    return _transform;
    
}

- (void)update_transform {
    _transform.transformType = self.vSourceInfoNode.TransformPara.effectTransformType;
    _transform.blur = self.vSourceInfoNode.TransformPara.blurLenH;
    _transform.scale = self.vSourceInfoNode.TransformPara.scaleX;
    _transform.rotation = self.vSourceInfoNode.TransformPara.angleZ;
    _transform.shiftX = self.vSourceInfoNode.TransformPara.shiftX;
    _transform.shiftY = self.vSourceInfoNode.TransformPara.shiftY;
    _transform.clearR = self.vSourceInfoNode.TransformPara.clearR;
    _transform.clearG = self.vSourceInfoNode.TransformPara.clearG;
    _transform.clearB = self.vSourceInfoNode.TransformPara.clearB;
    _transform.clearA = self.vSourceInfoNode.TransformPara.clearA;
    
    _transform.isMirror = self.vSourceInfoNode.TransformPara.scaleX < 0;
    _transform.rectL = self.vSourceInfoNode.TransformPara.rectL;
    _transform.rectT = self.vSourceInfoNode.TransformPara.rectT;
    _transform.rectR = self.vSourceInfoNode.TransformPara.rectR;
    _transform.rectB = self.vSourceInfoNode.TransformPara.rectB;
}


//添加图片后的需要重置下图片
- (void)updateTransformWithMedia:(XYSlideShowMedia *)media {
    _transform.transformType = self.vSourceInfoNode.TransformPara.effectTransformType;
    self.transform.transformType = XYSlideShowTransformTypeBlur;
    if (fabs(self.vSourceInfoNode.TransformPara.scaleX) < 0.0001) {
        _transform.blur = 20;
        _transform.scale = 1;
        _transform.rotation = 0;
        _transform.shiftX = 0;
        _transform.shiftY = 0;
        _transform.clearR = self.vSourceInfoNode.TransformPara.clearR;
        _transform.clearG = self.vSourceInfoNode.TransformPara.clearG;
        _transform.clearB = self.vSourceInfoNode.TransformPara.clearB;
        _transform.clearA = self.vSourceInfoNode.TransformPara.clearA;
        
        _transform.isMirror = NO;
        _transform.rectL = 0;
        _transform.rectT = 0;
        _transform.rectR = 1;
        _transform.rectB = 1;
    }
    NSArray * infoList =[[XYAutoEditMgr sharedInstance] getVirtualImgInfoNodeArray];
    CXiaoYingVirtualSourceInfoNode *pVirtualSrcInfoNode = self.vSourceInfoNode;
    CXIAOYING_TRANSFORM_PARAMETERS mTransformType = {0};
    float fScale = 1.0;
    float fRefValue = 0.0f;
    float fDiff = 0.0f;
    PHAsset * phAsset = [XYSlideshowEidtCommon getAssetByAssetPath:self.vSourceInfoNode.pSourceFile];
    
    NSUInteger width = phAsset.pixelWidth;
    NSUInteger height = phAsset.pixelHeight;
    if (phAsset && phAsset.pixelHeight != 0) {
        float fAspectSrc = (float)width / (float)height;
        fRefValue = 16.0f / (float)height;
        
        if (fAspectSrc > pVirtualSrcInfoNode.fAspectRatio)
        {
            fScale = pVirtualSrcInfoNode.fAspectRatio / fAspectSrc;
        }
        else
        {
            fScale = fAspectSrc /pVirtualSrcInfoNode.fAspectRatio;
        }
        
        fDiff = fabs(fAspectSrc - pVirtualSrcInfoNode.fAspectRatio);
        
        if (fDiff > fRefValue)
        {
            self.transform.scale = fScale;
        }else {
            self.transform.scale = 1.0;
        }
        self.transform.transformType = XYSlideShowTransformTypeBlur;
        
        self.transform.blur = 20;
        
        self.transform.rotation = 0;
        
        
        self.transform.shiftX = 0;
        self.transform.shiftY = 0;
        
        self.transform.rectL = 0;
        self.transform.rectT = 0;
        self.transform.rectR = 1.0;
        self.transform.rectB = 1.0;
        [[XYAutoEditMgr sharedInstance] setVirtualSourceTransformParaWithInfoNode:pVirtualSrcInfoNode transformPara:self.transformPara];
    } else {
        [self update_transform];
        [[XYAutoEditMgr sharedInstance] setVirtualSourceTransformParaWithInfoNode:pVirtualSrcInfoNode transformPara:mTransformType];
    }
}


- (CXIAOYING_TRANSFORM_PARAMETERS)transformPara {
    CXIAOYING_TRANSFORM_PARAMETERS trans = {0};
    trans.effectTransformType = self.transform.transformType;
    trans.blurLenH = self.transform.blur;
    trans.blurLenV = self.transform.blur;
    trans.scaleX = self.transform.scale;
    trans.scaleY = self.transform.scale;
    trans.scaleZ = self.vSourceInfoNode.TransformPara.angleZ;
    trans.angleX = self.vSourceInfoNode.TransformPara.angleX;
    trans.angleY = self.vSourceInfoNode.TransformPara.angleY;
    trans.angleZ = self.transform.rotation;
    trans.shiftX = self.transform.shiftX;
    trans.shiftY = self.transform.shiftY;
    trans.rectL = self.transform.rectL;
    trans.rectT = self.transform.rectT;
    trans.rectR = self.transform.rectR;
    trans.rectB = self.transform.rectB;
    trans.clearR = self.transform.clearR;
    trans.clearG = self.transform.clearG;
    trans.clearB = self.transform.clearB;
    trans.clearA = self.transform.clearA;
    return trans;
}

- (BOOL)isPanzoomOpen {
    return _vSourceInfoNode.bTransformFlag;
}


@end
