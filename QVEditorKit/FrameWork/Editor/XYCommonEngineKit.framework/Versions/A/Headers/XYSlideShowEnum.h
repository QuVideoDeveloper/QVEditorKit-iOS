//
//  XYSlideShowEnum.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/5/8.
//

#ifndef XYSlideShowEnum_h
#define XYSlideShowEnum_h

typedef NS_ENUM(NSUInteger, XYSlideShowTransformType) {
    XYSlideShowTransformTypeBlur = QVET_SLSH_TRANSFORM_TYPE_BLUR,
    XYSlideShowTransformTypeColorFill = QVET_SLSH_TRANSFORM_TYPE_COLOR_FILL,
};

typedef NS_ENUM(NSUInteger, XYSlideShowMediaType) {
    XYSlideShowMediaTypeNone = 0, // 不知道什么类型
    XYSlideShowMediaTypeImage, // 图片
    XYSlideShowMediaTypeVideo // 视频
};

#endif /* XYSlideShowEnum_h */
