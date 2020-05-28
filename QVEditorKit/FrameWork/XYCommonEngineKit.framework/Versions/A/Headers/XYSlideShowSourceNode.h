//
//  XYVirtualSourceInfoNode.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import <Foundation/Foundation.h>
#import "XYSlideShowEnum.h"
#import "XYSourceInfoNodeHelper.h"

NS_ASSUME_NONNULL_BEGIN

@class CXiaoYingVirtualSourceInfoNode, XYRectModel, XYVeRangeModel, XYSlideShowTransformModel, XYSlideShowMedia;

@interface XYSlideShowSourceNode : NSObject

/// 图片视频媒体资源路径
@property (nonatomic, readonly, copy, nonnull) NSString *mediaPath;

/// 旋转角度
@property (nonatomic) NSUInteger rotation;

/// node 所在视频上的时间点
@property (nonatomic, readonly) NSInteger previewPos;

/// node 在哪个场景上
@property (nonatomic, readonly) NSInteger sceneIndex;

/// node的比例
@property (nonatomic, readonly) CGFloat aspectRatio;

/// panzoom 是否开启
@property (nonatomic, readonly) BOOL isPanzoomOpen;

/// node 所在场景上的长度
@property (nonatomic, readonly) NSInteger sceneDuration;

/// 媒体资源类型
@property (nonatomic, readonly) XYSlideShowMediaType mediaType;

///源的缩放、移动、旋转
@property(readwrite, nonatomic, strong) XYSlideShowTransformModel *transform;

/// 视频的trim range
@property(nonatomic, strong, readonly) XYVeRangeModel *trimRange; 

/// 在源的数组中的位置
@property (nonatomic) NSInteger idx;

@property(readonly,nonatomic) CXIAOYING_TRANSFORM_PARAMETERS transformPara;

@property (nonatomic, strong, nonnull) CXiaoYingVirtualSourceInfoNode *vSourceInfoNode;

- (void)updateTransformWithMedia:(XYSlideShowMedia *)media;
- (instancetype)initWithVSourceInfoNode:(CXiaoYingVirtualSourceInfoNode *)vSourceInfoNode;

@end

NS_ASSUME_NONNULL_END
