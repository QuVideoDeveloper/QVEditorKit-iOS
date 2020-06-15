//
//  XYClipTaskCrop.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/5.
//

#import "XYClipTaskCrop.h"

@implementation XYClipTaskCrop

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    [self.clipModels enumerateObjectsUsingBlock:^(XYClipModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger rotation = obj.rotation;
        BOOL isLandScapeClip = NO;
        AMVE_VIDEO_INFO_TYPE clipInfo = {0};
            MRECT cropRect = {(MLong)CGRectGetMinX(obj.cropRect), (MLong)CGRectGetMinY(obj.cropRect), (MLong)CGRectGetMaxX(obj.cropRect), (MLong)CGRectGetMaxY(obj.cropRect)};

        MRESULT res = [obj.pClip getProperty:AMVE_PROP_CLIP_SOURCE_INFO PropertyData:&clipInfo];
        MLong left = cropRect.left * 10000 / clipInfo.dwFrameWidth;
        MLong top = cropRect.top * 10000 / clipInfo.dwFrameHeight;
        MLong right = cropRect.right * 10000 / clipInfo.dwFrameWidth;
        MLong bottom = cropRect.bottom * 10000 / clipInfo.dwFrameHeight;
        MRECT rectForEngine = {left, top, right, bottom};
        if (clipInfo.dwFrameWidth > clipInfo.dwFrameHeight) {
            isLandScapeClip = YES;
        } else {
            isLandScapeClip = NO;
        }
        if (right > 0 && bottom > 0) {
            if (cropRect.right - cropRect.left > cropRect.bottom - cropRect.top) {
                isLandScapeClip = YES;
            } else {
                isLandScapeClip = NO;
            }
            res = [obj.pClip setProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&rectForEngine];
        }
        
        if (rotation == 90 || rotation == 270) {
            isLandScapeClip = !isLandScapeClip;
        }
        res = [obj.pClip setProperty:AMVE_PROP_CLIP_ROTATION PropertyData:&rotation];
        MDWord rotate;
        [obj.pClip getProperty:AMVE_PROP_CLIP_ROTATION PropertyData:&rotate];
    }];
}

@end
