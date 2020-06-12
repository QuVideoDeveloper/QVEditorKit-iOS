//
//  XYSlideShowMedia.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//


#import <Foundation/Foundation.h>
#import "XYSlideShowEnum.h"

@class CXiaoYingSourceInfoNode, XYVeRangeModel, PHAsset;

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

/// 根据phAsset 获取到给引擎的镜头路径
/// @param phAsset PHAsset对象
+ (NSString *)getMediaPathForEngine:(PHAsset *)phAsset;

- (instancetype)initWithMediaPath:(NSString *)mediaPath mediaTyp:(XYSlideShowMediaType)mediaType;

- (instancetype)initWithNode:(CXiaoYingSourceInfoNode *)node;

@end


NS_ASSUME_NONNULL_END
