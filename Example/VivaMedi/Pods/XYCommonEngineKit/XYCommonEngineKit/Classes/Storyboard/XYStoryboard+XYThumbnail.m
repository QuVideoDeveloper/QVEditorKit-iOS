//
//  XYStoryboard+XYThumbnail.m
//  XYCommonEngineKit
//
//  Created by lizitao on 2019/9/17.
//

#import "XYStoryboard+XYThumbnail.h"
#import "XYCommonEngineUtility.h"
#import "XYStoryboard+XYClip.h"

@implementation XYStoryboard (aThumbnail)

- (void)prepareThumbnailManager:(CXiaoYingClip *)clip
                  dwThumbPixelW:(MDWord)dwThumbPixelW
                  dwThumbPixelH:(MDWord)dwThumbPixelH
                      PimalFlag:(MBool)pimalFlag
               onlyOriginalClip:(MBool)onlyOriginalClip
{
    MRESULT res = QVET_ERR_NONE;
    res = [clip createThumbnailManager:dwThumbPixelW
                                Height:dwThumbPixelH
                          ResampleMode:AMVE_RESAMPLE_MODE_UPSCALE_FITOUT
                             PimalFlag:pimalFlag
                      OnlyOriginalClip:onlyOriginalClip];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard prepareThumbnailManager createThumbnailManager err=0x%lx", res);
    }
    return;
}
    
- (UIImage *)createThumbnail:(CXiaoYingClip *)clip
                  dwPosition:(MDWord)dwPosition
               dwThumbPixelW:(MDWord)dwThumbPixelW
               dwThumbPixelH:(MDWord)dwThumbPixelH
              skipBlackFrame:(MBool)skipBlackFrame
{
    if (!clip
        || clip.hClip == NULL
        || clip.hThumbnailMgr == NULL) {
        return nil;
    }
    
    if ([XYStoryboard sharedXYStoryboard].isInBackground) {
        return nil;
    }
    
    MRESULT res = QVET_ERR_NONE;
    CVImageBufferRef cvImgBuf = nil;
    if (kCVReturnSuccess !=
        CVPixelBufferCreate(kCFAllocatorDefault, dwThumbPixelW, dwThumbPixelH, kCVPixelFormatType_32BGRA, nil, &cvImgBuf)) {
        return nil;
    }
    
    CVPixelBufferLockBaseAddress(cvImgBuf, 0);
    //get thumbnail
    res = [clip getThumbnail:dwPosition
          SkipBlackFrameFlag:skipBlackFrame
                 ImageBuffer:cvImgBuf];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createThumbnail getThumbnail err=0x%lx", res);
    }
    UIImage *image = [self createImageFromCVImageBufferRef:cvImgBuf imageWidth:dwThumbPixelW imageHeight:dwThumbPixelH scale:1 orientation:UIImageOrientationUp];
    return image;
}
    
- (void)destroyThumbnailManager:(CXiaoYingClip *)clip
{
    MRESULT res = [clip destroyThumbnailManager];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard destroyThumbnailManager err=0x%lx", res);
    }
}
    
- (UIImage *)createThumbnail:(MDWord)dwPosition
               dwThumbPixelW:(MDWord)dwThumbPixelW
               dwThumbPixelH:(MDWord)dwThumbPixelH
{
    return [self createThumbnail:dwPosition dwThumbPixelW:dwThumbPixelW dwThumbPixelH:dwThumbPixelH PimalFlag:MTrue onlyOriginalClip:MFalse];
}
    
- (UIImage *)createThumbnail:(MDWord)dwPosition
               dwThumbPixelW:(MDWord)dwThumbPixelW
               dwThumbPixelH:(MDWord)dwThumbPixelH
                   PimalFlag:(MBool)pimalFlag
            onlyOriginalClip:(MBool)onlyOriginalClip
{
    if ([XYStoryboard sharedXYStoryboard].isInBackground) {
        return nil;
    }
    if (!self.cXiaoYingStoryBoardSession) {
        return nil;
    }
    MDWord dwStbDuration = [self.cXiaoYingStoryBoardSession getDuration];
    if (dwPosition > dwStbDuration) {
        return nil;
    }
    MRESULT res = QVET_ERR_NONE;
    CVImageBufferRef cvImgBuf = nil;
    
    CXiaoYingClip *pStbClip = [self.cXiaoYingStoryBoardSession getDataClip];
    CXiaoYingClip *pDuplicatedStbClip = [[CXiaoYingClip alloc] init];
    res = [pDuplicatedStbClip duplicate:pStbClip];
    res = [pDuplicatedStbClip createThumbnailManager:dwThumbPixelW
                                              Height:dwThumbPixelH
                                        ResampleMode:AMVE_RESAMPLE_MODE_UPSCALE_FITOUT
                                           PimalFlag:pimalFlag
                                    OnlyOriginalClip:onlyOriginalClip];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createThumbnail createThumbnailManager err=0x%lx", res);
    }
    if (kCVReturnSuccess != CVPixelBufferCreate(kCFAllocatorDefault, dwThumbPixelW, dwThumbPixelH, kCVPixelFormatType_32BGRA, nil, &cvImgBuf)) {
        return nil;
    }
    
    CVPixelBufferLockBaseAddress(cvImgBuf, 0);
    //get thumbnail
    res = [pDuplicatedStbClip getThumbnail:dwPosition
                        SkipBlackFrameFlag:MFalse
                               ImageBuffer:cvImgBuf];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createThumbnail getThumbnail err=0x%lx", res);
    }
    UIImage *image = [self createImageFromCVImageBufferRef:cvImgBuf imageWidth:dwThumbPixelW imageHeight:dwThumbPixelH scale:1 orientation:UIImageOrientationUp];
    res = [pDuplicatedStbClip destroyThumbnailManager];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createThumbnail destroyThumbnailManager err=0x%lx", res);
    }
    return image;
}
    
- (void)createThumbnails:(MDWord)dwThumbPixelW
           dwThumbPixelH:(MDWord)dwThumbPixelH
             dwPositions:(NSArray *)dwPositions
               PimalFlag:(MBool)pimalFlag
        onlyOriginalClip:(MBool)onlyOriginalClip
                   block:(void (^)(UIImage *image, int index))block
{
    [self createThumbnails:dwThumbPixelW dwThumbPixelH:dwThumbPixelH dwPositions:dwPositions PimalFlag:pimalFlag onlyOriginalClip:onlyOriginalClip skipBlackFrameFlag:MFalse block:block];
}
    
- (void)createThumbnails:(MDWord)dwThumbPixelW
           dwThumbPixelH:(MDWord)dwThumbPixelH
             dwPositions:(NSArray *)dwPositions
               PimalFlag:(MBool)pimalFlag
        onlyOriginalClip:(MBool)onlyOriginalClip
      skipBlackFrameFlag:(MBool)skipBlackFrameFlag
                   block:(void (^)(UIImage *image, int index))block
{
    if ([XYStoryboard sharedXYStoryboard].isInBackground) {
        return;
    }
    if (!self.cXiaoYingStoryBoardSession) {
        return;
    }
    
    int count = [dwPositions count];
    if (count == 0) {
        return;
    }
    
    MDWord dwStbDuration = [self getDuration];
    MRESULT res = QVET_ERR_NONE;
    CVImageBufferRef cvImgBuf = nil;
    
    CXiaoYingClip *pStbClip = [self.cXiaoYingStoryBoardSession getDataClip];
    CXiaoYingClip *pDuplicatedStbClip = [[CXiaoYingClip alloc] init];
    res = [pDuplicatedStbClip duplicate:pStbClip];
    res = [pDuplicatedStbClip createThumbnailManager:dwThumbPixelW
                                              Height:dwThumbPixelH
                                        ResampleMode:AMVE_RESAMPLE_MODE_UPSCALE_FITOUT
                                           PimalFlag:pimalFlag
                                    OnlyOriginalClip:onlyOriginalClip];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createThumbnails createThumbnailManager err=0x%lx", res);
    }
    for (int i = 0; i < count; i++) {
        if (kCVReturnSuccess !=
            CVPixelBufferCreate(kCFAllocatorDefault, dwThumbPixelW, dwThumbPixelH, kCVPixelFormatType_32BGRA, nil, &cvImgBuf)) {
            if (block) {
                block(nil, i);
            }
            break;
        }
        MDWord pos = [[dwPositions objectAtIndex:i] unsignedIntValue];
        if (pos > dwStbDuration) {
            pos = dwStbDuration;
        }
        CVPixelBufferLockBaseAddress(cvImgBuf, 0);
        //get thumbnail
        res = [pDuplicatedStbClip getThumbnail:pos
                            SkipBlackFrameFlag:skipBlackFrameFlag
                                   ImageBuffer:cvImgBuf];
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard createThumbnails getThumbnail err=0x%lx", res);
        }
        UIImage *image = [self createImageFromCVImageBufferRef:cvImgBuf imageWidth:dwThumbPixelW imageHeight:dwThumbPixelH scale:1 orientation:UIImageOrientationUp];
        if (block) {
            block(image, i);
        }
    }
    res = [pDuplicatedStbClip destroyThumbnailManager];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createThumbnails destroyThumbnailManager err=0x%lx", res);
    }
    return;
}
    
- (void)createClipThumbnails:(MDWord)dwClipIndex
                 dwPositions:(NSArray *)dwPositions
               dwThumbPixelW:(MDWord)dwThumbPixelW
               dwThumbPixelH:(MDWord)dwThumbPixelH
                   PimalFlag:(MBool)pimalFlag
                       block:(void (^)(UIImage *image, int index))block
{
    MDWord clipCount = [self.cXiaoYingStoryBoardSession getClipCount];
    if (dwClipIndex >= clipCount) {
        return;
    }
    CXiaoYingClip *trimedClip = [self.cXiaoYingStoryBoardSession getClip:dwClipIndex];
    [self createClipThumbnailsByClip:trimedClip dwPositions:dwPositions dwThumbPixelW:dwThumbPixelW dwThumbPixelH:dwThumbPixelH PimalFlag:pimalFlag block:block];
}
    
- (void)createClipThumbnailsByClip:(CXiaoYingClip *)trimedClip
                       dwPositions:(NSArray *)dwPositions
                     dwThumbPixelW:(MDWord)dwThumbPixelW
                     dwThumbPixelH:(MDWord)dwThumbPixelH
                         PimalFlag:(MBool)pimalFlag
                             block:(void (^)(UIImage *image, int index))block
    
{
    if ([XYStoryboard sharedXYStoryboard].isInBackground) {
        return;
    }
    if (!self.cXiaoYingStoryBoardSession) {
        return;
    }
    if (!trimedClip) {
        return;
    }
    MRESULT res = QVET_ERR_NONE;
    CVImageBufferRef cvImgBuf = nil;
    CXiaoYingClip *pStbClip = [[CXiaoYingClip alloc] init];
    res = [pStbClip duplicate:trimedClip];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createClipThumbnails duplicate err=0x%lx", res);
    }
    AMVE_POSITION_RANGE_TYPE clipRange = {0, 0xffffffff};
    [self setClipTrimRange:pStbClip trimRange:clipRange];
    
    AMVE_POSITION_RANGE_TYPE clipSourceRange = {0, 0xffffffff};
    res = [pStbClip setProperty:AMVE_PROP_CLIP_SRC_RANGE PropertyData:&clipSourceRange];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createClipThumbnails AMVE_PROP_CLIP_SRC_RANGE err=0x%lx", res);
    }
    
    NSLog(@"createThumbnailManager <--");
    res = [pStbClip createThumbnailManager:dwThumbPixelW
                                    Height:dwThumbPixelH
                              ResampleMode:AMVE_RESAMPLE_MODE_UPSCALE_FITOUT
                                 PimalFlag:pimalFlag
                          OnlyOriginalClip:MFalse];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createClipThumbnails createThumbnailManager err=0x%lx", res);
    }
    NSLog(@"createThumbnailManager -->");
    
    int count = [dwPositions count];
    for (int i = 0; i < count; i++) {
        NSLog(@"createClipThumbnail [%d] <--", i);
        if (kCVReturnSuccess !=
            CVPixelBufferCreate(kCFAllocatorDefault, dwThumbPixelW, dwThumbPixelH, kCVPixelFormatType_32BGRA, nil, &cvImgBuf)) {
            NSLog(@"createClipThumbnail [%d] fail -->", i);
            break;
        }
        
        CVPixelBufferLockBaseAddress(cvImgBuf, 0);
        //get thumbnail
        res = [pStbClip getThumbnail:[[dwPositions objectAtIndex:i] unsignedLongValue]
                  SkipBlackFrameFlag:MFalse
                         ImageBuffer:cvImgBuf];
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard createClipThumbnails getThumbnail err=0x%lx", res);
        }
        UIImage *image = [self createImageFromCVImageBufferRef:cvImgBuf imageWidth:dwThumbPixelW imageHeight:dwThumbPixelH scale:1 orientation:UIImageOrientationUp];
        if (block) {
            block(image, i);
        }
        NSLog(@"createClipThumbnail [%d] success -->", i);
    }
    NSLog(@"destroyThumbnailManager <--");
    res = [pStbClip destroyThumbnailManager];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createClipThumbnails destroyThumbnailManager err=0x%lx", res);
    }
    NSLog(@"destroyThumbnailManager -->");
}
    
- (UIImage *)createClipThumbnail:(MDWord)dwClipIndex
                      dwPosition:(MDWord)dwPosition
                   dwThumbPixelW:(MDWord)dwThumbPixelW
                   dwThumbPixelH:(MDWord)dwThumbPixelH
                       PimalFlag:(MBool)pimalFlag
{
    CXiaoYingClip *clip = [self getClipByIndex:dwClipIndex];
    return [self createClipThumbnailByClip:clip dwPosition:dwPosition dwThumbPixelW:dwThumbPixelW dwThumbPixelH:dwThumbPixelH PimalFlag:pimalFlag];
}
    
- (UIImage *)createClipThumbnailByClip:(CXiaoYingClip *)trimedClip
                            dwPosition:(MDWord)dwPosition
                         dwThumbPixelW:(MDWord)dwThumbPixelW
                         dwThumbPixelH:(MDWord)dwThumbPixelH
                             PimalFlag:(MBool)pimalFlag
{
    if ([XYStoryboard sharedXYStoryboard].isInBackground) {
        return nil;
    }
    if (!self.cXiaoYingStoryBoardSession) {
        return nil;
    }
    if (!trimedClip) {
        return nil;
    }
    NSLog(@"[ENGINE]XYStoryboard createClipThumbnail <--");
    MRESULT res = QVET_ERR_NONE;
    CVImageBufferRef cvImgBuf = nil;
    
    CXiaoYingClip *pStbClip = [[CXiaoYingClip alloc] init];
    res = [pStbClip duplicate:trimedClip];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createClipThumbnail duplicate err=0x%lx", res);
    }
    AMVE_POSITION_RANGE_TYPE clipRange = {0, 0xffffffff};
    [self setClipTrimRange:pStbClip trimRange:clipRange];
    
    AMVE_POSITION_RANGE_TYPE clipSourceRange = {0, 0xffffffff};
    res = [pStbClip setProperty:AMVE_PROP_CLIP_SRC_RANGE PropertyData:&clipSourceRange];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createClipThumbnail AMVE_PROP_CLIP_SRC_RANGE err=0x%lx", res);
    }
    
    res = [pStbClip createThumbnailManager:dwThumbPixelW
                                    Height:dwThumbPixelH
                              ResampleMode:AMVE_RESAMPLE_MODE_UPSCALE_FITOUT
                                 PimalFlag:pimalFlag
                          OnlyOriginalClip:MFalse];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createClipThumbnail createThumbnailManager err=0x%lx", res);
    }
    if (kCVReturnSuccess !=
        CVPixelBufferCreate(kCFAllocatorDefault, dwThumbPixelW, dwThumbPixelH, kCVPixelFormatType_32BGRA, nil, &cvImgBuf)) {
        NSLog(@"[ENGINE]XYStoryboard createClipThumbnail fail -->");
        return nil;
    }
    
    CVPixelBufferLockBaseAddress(cvImgBuf, 0);
    //get thumbnail
    res = [pStbClip getThumbnail:dwPosition
              SkipBlackFrameFlag:MTrue
                     ImageBuffer:cvImgBuf];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createClipThumbnail getThumbnail err=0x%lx", res);
    }
    MDWord rotation;
    [pStbClip getProperty:AMVE_PROP_CLIP_ROTATION PropertyData:&rotation];
    //引擎中取得的thumbnail是和clip一致的，因此如果创建clip时用的是旋转过的图片，这里拿到的image是和创建clip时旋转过的图片方向一致的。
    UIImage *image = [self createImageFromCVImageBufferRef:cvImgBuf imageWidth:dwThumbPixelW imageHeight:dwThumbPixelH scale:1 orientation:UIImageOrientationUp];
    
    res = [pStbClip destroyThumbnailManager];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createClipThumbnail destroyThumbnailManager err=0x%lx", res);
    }
    NSLog(@"[ENGINE]XYStoryboard createClipThumbnail success -->");
    return image;
}
    
- (UIImage *)getStickerThumb:(StickerInfo *)stickerInfo
{
    CXiaoYingEngine *engine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
    if (!engine) {
        return nil;
    }
    NSString *path = stickerInfo.xytFilePath;
    if (![path hasPrefix:@"PHASSET:"] && ![path hasPrefix:@"ipod-library:"] && ![XYCommonEngineUtility xy_isFileExist:path]) {
        return nil;
    }
    CVImageBufferRef cvImgBuf = nil;
    if (stickerInfo.dwFrameWidth % 4) {
        stickerInfo.dwFrameWidth += 4 - stickerInfo.dwFrameWidth % 4;
    }
    if (stickerInfo.dwFrameHeight % 4) {
        stickerInfo.dwFrameHeight += 4 - stickerInfo.dwFrameHeight % 4;
    }
    if (kCVReturnSuccess != CVPixelBufferCreate(kCFAllocatorDefault, stickerInfo.dwFrameWidth, stickerInfo.dwFrameHeight, kCVPixelFormatType_32BGRA, nil, &cvImgBuf)) {
        return nil;
    }
    
    CVPixelBufferLockBaseAddress(cvImgBuf, 0);
    
    MRESULT res = QVET_ERR_NONE;
    NSLog(@"width=%lu height=%lu", stickerInfo.dwFrameWidth, stickerInfo.dwFrameHeight);
    res = [CXiaoYingUtils GetAnimatedFrameBitmap:engine FrameFile:(MChar *)[path UTF8String] Position:stickerInfo.dwExamplePos Bitmap:cvImgBuf];
    if (res) {
        NSLog(@"[ENGINE]GetAnimatedFrameInfo err=0x%lx", res);
        return nil;
    }
    UIImage *image = [self createImageFromCVImageBufferRef:cvImgBuf imageWidth:stickerInfo.dwFrameWidth imageHeight:stickerInfo.dwFrameHeight scale:1 orientation:UIImageOrientationUp];
    return image;
}
    
- (UIImage *)getMosaicThumb:(StickerInfo *)stickerInfo
{
    CXiaoYingEngine *engine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
    if (!engine) {
        return nil;
    }
    NSString *path = stickerInfo.xytFilePath;
    if (![path hasPrefix:@"PHASSET:"] && ![path hasPrefix:@"ipod-library:"] && ![XYCommonEngineUtility xy_isFileExist:path]) {
        return nil;
    }
    CVImageBufferRef cvImgBuf = nil;
    if (stickerInfo.dwFrameWidth % 4) {
        stickerInfo.dwFrameWidth += 4 - stickerInfo.dwFrameWidth % 4;
    }
    if (stickerInfo.dwFrameHeight % 4) {
        stickerInfo.dwFrameHeight += 4 - stickerInfo.dwFrameHeight % 4;
    }
    if (kCVReturnSuccess != CVPixelBufferCreate(kCFAllocatorDefault, stickerInfo.dwFrameWidth, stickerInfo.dwFrameHeight, kCVPixelFormatType_32BGRA, nil, &cvImgBuf)) {
        return nil;
    }
    
    CVPixelBufferLockBaseAddress(cvImgBuf, 0);
    
    MRESULT res = QVET_ERR_NONE;
    NSLog(@"width=%lu height=%lu", stickerInfo.dwFrameWidth, stickerInfo.dwFrameHeight);
    res = [CXiaoYingUtils GetAnimatedFrameBitmap:engine FrameFile:(MChar *)[path UTF8String] Position:stickerInfo.dwExamplePos Bitmap:cvImgBuf];
    if (res) {
        NSLog(@"[ENGINE]GetAnimatedFrameInfo err=0x%lx", res);
        return nil;
    }
    UIImage *image = [self createImageFromCVImageBufferRef:cvImgBuf imageWidth:stickerInfo.dwFrameWidth imageHeight:stickerInfo.dwFrameHeight scale:1 orientation:UIImageOrientationUp];
    return image;
}
    
#pragma mark - Thumbnail related
- (UIImage *)createImageFromCVImageBufferRef:(CVImageBufferRef)cvImgBuf
                                  imageWidth:(size_t)imageWidth
                                 imageHeight:(size_t)imageHeight
                                       scale:(CGFloat)scale
                                 orientation:(UIImageOrientation)orientation
{
    MVoid *spriteData = CVPixelBufferGetBaseAddress(cvImgBuf);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(spriteData, imageWidth, imageHeight, 8, CVPixelBufferGetBytesPerRow(cvImgBuf), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:newImage scale:scale orientation:orientation];
    CVPixelBufferUnlockBaseAddress(cvImgBuf, 0);
    CGImageRelease(newImage);
    CVPixelBufferRelease(cvImgBuf);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return image;
}

#pragma mark - 关键帧拿缩略图
- (UIImage *)createThumbnailByKeyFrame:(CXiaoYingClip *)clip
                            dwPosition:(MDWord)dwPosition
                         dwThumbPixelW:(MDWord)dwThumbPixelW
                         dwThumbPixelH:(MDWord)dwThumbPixelH
                        skipBlackFrame:(MBool)skipBlackFrame {
    if (!clip
        || clip.hClip == NULL
        || clip.hThumbnailMgr == NULL) {
        return nil;
    }
    
    if ([XYStoryboard sharedXYStoryboard].isInBackground) {
        return nil;
    }
    
    MRESULT res = QVET_ERR_NONE;
    CVImageBufferRef cvImgBuf = nil;
    if (kCVReturnSuccess !=
        CVPixelBufferCreate(kCFAllocatorDefault, dwThumbPixelW, dwThumbPixelH, kCVPixelFormatType_32BGRA, nil, &cvImgBuf)) {
        return nil;
    }
    
    CVPixelBufferLockBaseAddress(cvImgBuf, 0);
    
    MBool direct = MTrue;
    MDWord tempPosition = dwPosition;
    res = [clip getKeyFramePositionFromThumbnailMgr:&tempPosition Direct:direct];
    if (res) {
        res = [clip getThumbnail:dwPosition SkipBlackFrameFlag:skipBlackFrame ImageBuffer:cvImgBuf];
        NSLog(@"[ENGINE]XYStoryboard createThumbnail getThumbnail err=0x%lx", res);
    } else {
        if (tempPosition == -1) {
            res = [clip getThumbnail:dwPosition SkipBlackFrameFlag:skipBlackFrame ImageBuffer:cvImgBuf];
        } else {
            res = [clip getKeyframe:tempPosition SkipBlackFrameFlag:skipBlackFrame ImageBuffer:cvImgBuf];
            
            if (res) {
                res = [clip getThumbnail:dwPosition SkipBlackFrameFlag:skipBlackFrame ImageBuffer:cvImgBuf];
            }
        }
    }
    
    UIImage *image = [self createImageFromCVImageBufferRef:cvImgBuf imageWidth:dwThumbPixelW imageHeight:dwThumbPixelH scale:1 orientation:UIImageOrientationUp];
    return image;
}

- (UIImage *)createThumbnailByKeyFrame:(MDWord)dwPosition
                         dwThumbPixelW:(MDWord)dwThumbPixelW
                         dwThumbPixelH:(MDWord)dwThumbPixelH {
    return [self createThumbnailByKeyFrame:dwPosition dwThumbPixelW:dwThumbPixelW dwThumbPixelH:dwThumbPixelH PimalFlag:MTrue onlyOriginalClip:MFalse];
}

- (UIImage *)createThumbnailByKeyFrame:(MDWord)dwPosition
                         dwThumbPixelW:(MDWord)dwThumbPixelW
                         dwThumbPixelH:(MDWord)dwThumbPixelH
                             PimalFlag:(MBool)pimalFlag
                      onlyOriginalClip:(MBool)onlyOriginalClip {
    if ([XYStoryboard sharedXYStoryboard].isInBackground) {
            return nil;
    }
    if (!self.cXiaoYingStoryBoardSession) {
        return nil;
    }
    MDWord dwStbDuration = [self.cXiaoYingStoryBoardSession getDuration];
    if (dwPosition > dwStbDuration) {
        return nil;
    }
    MRESULT res = QVET_ERR_NONE;
    CVImageBufferRef cvImgBuf = nil;
    
    CXiaoYingClip *pStbClip = [self.cXiaoYingStoryBoardSession getDataClip];
    CXiaoYingClip *pDuplicatedStbClip = [[CXiaoYingClip alloc] init];
    res = [pDuplicatedStbClip duplicate:pStbClip];
    res = [pDuplicatedStbClip createThumbnailManager:dwThumbPixelW
                                              Height:dwThumbPixelH
                                        ResampleMode:AMVE_RESAMPLE_MODE_UPSCALE_FITOUT
                                           PimalFlag:MTrue
                                    OnlyOriginalClip:MFalse];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createThumbnail createThumbnailManager err=0x%lx", res);
    }
    if (kCVReturnSuccess != CVPixelBufferCreate(kCFAllocatorDefault, dwThumbPixelW, dwThumbPixelH, kCVPixelFormatType_32BGRA, nil, &cvImgBuf)) {
        return nil;
    }
    
    CVPixelBufferLockBaseAddress(cvImgBuf, 0);
    
    MBool direct = MTrue;
    MDWord tempPosition = dwPosition;
    res = [pDuplicatedStbClip getKeyFramePositionFromThumbnailMgr:&tempPosition Direct:direct];
    if (res) {
        res = [pDuplicatedStbClip getThumbnail:dwPosition SkipBlackFrameFlag:MFalse ImageBuffer:cvImgBuf];
        NSLog(@"[ENGINE]XYStoryboard createThumbnail getThumbnail err=0x%lx", res);
    } else {
        if (tempPosition == -1) {
            res = [pDuplicatedStbClip getThumbnail:dwPosition SkipBlackFrameFlag:MFalse ImageBuffer:cvImgBuf];
        } else {
            res = [pDuplicatedStbClip getKeyframe:tempPosition SkipBlackFrameFlag:MFalse ImageBuffer:cvImgBuf];
            
            if (res) {
                res = [pDuplicatedStbClip getThumbnail:dwPosition SkipBlackFrameFlag:MFalse ImageBuffer:cvImgBuf];
            }
        }
    }
    
    UIImage *image = [self createImageFromCVImageBufferRef:cvImgBuf imageWidth:dwThumbPixelW imageHeight:dwThumbPixelH scale:1 orientation:UIImageOrientationUp];
    res = [pDuplicatedStbClip destroyThumbnailManager];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard createThumbnail destroyThumbnailManager err=0x%lx", res);
    }
    return image;
}
    
@end
