//
//  XYSlideShowMedia.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//


#import <Foundation/Foundation.h>
#import "XYSlideShowEnum.h"

@class CXiaoYingSourceInfoNode, XYVeRangeModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYSlideShowMedia : NSObject

@property (nonatomic, strong, readonly) CXiaoYingSourceInfoNode *sourceInfoNode;

/// 图片视频媒体资源路径
@property (nonatomic, copy, readonly) NSString *mediaPath;

/// 旋转角度
@property (nonatomic) NSUInteger rotation;

/// 媒体资源类型
@property (nonatomic, readonly) XYSlideShowMediaType mediaType;

/// 视频的range
@property (nonatomic, strong) XYVeRangeModel *videoRange;

- (instancetype)initWithMediaPath:(NSString *)mediaPath mediaTyp:(XYSlideShowMediaType)mediaType;

- (instancetype)initWithNode:(CXiaoYingSourceInfoNode *)node;

@end


NS_ASSUME_NONNULL_END
