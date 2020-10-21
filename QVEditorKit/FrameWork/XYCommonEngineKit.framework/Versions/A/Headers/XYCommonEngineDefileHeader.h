//
//  XYCommonEngineDefileHeader.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/10/16.
//

#ifndef XYCommonEngineDefileHeader_h
#define XYCommonEngineDefileHeader_h

#pragma mark - 枚举

// 转场点检测算法类型

typedef NS_ENUM(NSInteger, XYVideoAnalyzeType) {
    XYVideoAnalyzeTypeSeg = 0,        // 面向视频镜头切分的变化检测
    XYVideoAnalyzeTypeMusicBeats = 1,    // 面向音乐卡点视频的卡点检测
};

#pragma mark - block


#endif /* XYCommonEngineDefileHeader_h */
