//
//  XYSourceInfoNodeHelper.m
//  XiaoYingCoreSDK
//
//  Created by 吕孟霖 on 16/5/19.
//  Copyright © 2016年 QuVideo. All rights reserved.
//

#import "XYSourceInfoNodeHelper.h"

@implementation XYSourceInfoNodeHelper

+ (XYSlideShowMediaType)getXYSourceInfoTypeByInnerSourceType:(UInt32)innerSourceType
{
    XYSlideShowMediaType sourceType;
    switch (innerSourceType) {
        case QVET_SLSH_SOURCE_TYPE_IMAGE:
            sourceType = XYSlideShowMediaTypeImage;
            break;
        case QVET_SLSH_SOURCE_TYPE_VIDEO:
            sourceType = XYSlideShowMediaTypeVideo;
            break;
        default:
            sourceType = XYSlideShowMediaTypeNone;
            break;
    }
    return sourceType;
}

+ (UInt32)getInnerSouceTypeByXYSourceInfoType:(XYSlideShowMediaType)sourceInfoType
{
    UInt32 innerSourceType;
    switch (sourceInfoType) {
        case XYSlideShowMediaTypeImage:
            innerSourceType = QVET_SLSH_SOURCE_TYPE_IMAGE;
            break;
        case XYSlideShowMediaTypeVideo:
            innerSourceType = QVET_SLSH_SOURCE_TYPE_VIDEO;
            break;
        default:
            innerSourceType = QVET_SLSH_SOURCE_TYPE_NONE;
            break;
    }
    return innerSourceType;
}
@end
