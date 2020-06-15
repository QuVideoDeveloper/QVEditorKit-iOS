//
//  XYModelBridgeUtility.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import "XYEngineModelBridgeUtility.h"
#import "XYClipModel.h"
#import "XYClipDataItem.h"
#import "XYEffectVisionModel.h"

@implementation XYEngineModelBridgeUtility

+ (XYClipDataItem *)bridge:(XYClipModel *)clipModel {
    XYClipDataItem *dataItem = [[XYClipDataItem alloc] init];
    dataItem.trimPos = clipModel.trimVeRange.dwPos;
    dataItem.trimLen = clipModel.trimVeRange.dwLen;
    dataItem.startPos = clipModel.sourceVeRange.dwPos;
    dataItem.endPos = clipModel.sourceVeRange.dwLen + clipModel.sourceVeRange.dwPos;
    dataItem.timeScale = 1 / clipModel.speedValue;
    dataItem.clipFilePath = clipModel.clipFilePath;
    dataItem.filterFilePath = clipModel.filterFilePath;
    dataItem.musicFilePath = clipModel.musicFilePath;
    dataItem.dwMusicTrimStartPos = clipModel.dwMusicTrimStartPos;
    dataItem.dwMusicTrimLen = clipModel.dwMusicTrimLen;
    dataItem.cropRect = clipModel.cropRect;
    dataItem.rotation = clipModel.rotation;
    dataItem.isGIF = XYCommonEngineClipModuleGif == clipModel.clipType;
    dataItem.clipIndex = clipModel.clipIndex;
    dataItem.identifier = clipModel.identifier;
    return dataItem;
}

+ (MRECT)modelToMRect:(XYRectModel *)rectMode {
    MRECT mRect = {0};
    mRect.left = rectMode.left;
    mRect.top = rectMode.top;
    mRect.right = rectMode.right;
    mRect.bottom = rectMode.bottom;
    return mRect;
}

+ (XYRectModel *)mRectToModel:(MRECT)mRect {
    XYRectModel *rectMode = [[XYRectModel alloc] init];
    rectMode.left = mRect.left;
    rectMode.top = mRect.top;
    rectMode.right = mRect.right;
    rectMode.bottom = mRect.bottom;
    return rectMode;
}


@end
