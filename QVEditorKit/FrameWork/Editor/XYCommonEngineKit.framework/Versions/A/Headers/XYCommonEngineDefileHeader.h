//
//  XYCommonEngineDefileHeader.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/10/16.
//
#import <Foundation/Foundation.h>

#ifndef XYCommonEngineDefileHeader_h
#define XYCommonEngineDefileHeader_h

#pragma mark - struct

typedef struct __tag_XYMBITMAP
{
    unsigned long    dwPixelArrayFormat;
    long    lWidth;
    long    lHeight;
    union {
        long    lPitch[3];
        struct {
            long wStride;    // width stride
            long lLayers;    // layer number or image depth
            long lStride;    // layer stride or depth pitch
        };
        struct {
            long lDataSize;
            long lLayerNum;
            long lPadding1;
        };
    };
    char*    pPlane[3];
}XYMBITMAP, *LPXYMBITMAP;

#pragma mark - 枚举

// 转场点检测算法类型

typedef NS_ENUM(NSInteger, XYVideoAnalyzeType) {
    XYVideoAnalyzeTypeSeg = 0,        // 面向视频镜头切分的变化检测
    XYVideoAnalyzeTypeMusicBeats = 1,    // 面向音乐卡点视频的卡点检测
};

#pragma mark - block


#endif /* XYCommonEngineDefileHeader_h */
