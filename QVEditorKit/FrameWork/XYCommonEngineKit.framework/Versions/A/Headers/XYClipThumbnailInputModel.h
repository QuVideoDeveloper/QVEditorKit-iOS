//
//  XYThumbnailInputModel.h
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/12/20.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

@class XYStoryboard, CXiaoYingClip, XYVeRangeModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYClipThumbnailInputModel : NSObject <NSCopying,NSMutableCopying>

#pragma mark - 外部用参数
/// 相对于当前clip或是画中画effect的时间点
@property (nonatomic, assign) NSInteger seekPosition;

/// 缩略图宽，一个clip第一次请求缩略图时确定，后面的传进来无效; 不传的话，默认128
@property (nonatomic, assign) CGFloat thumbnailWidth;

/// 缩略图高，一个clip第一次请求缩略图时确定，后面的传进来无效; 不传的话，默认128
@property (nonatomic, assign) CGFloat thumbnailHeight;

/// 是否跳过黑帧；默认跳过黑帧
@property (nonatomic, assign) BOOL skipBlackFrame;

/// 是否是临时Storyboard取缩略图
@property (nonatomic, assign) BOOL isTempWorkSpace;

/// 取缩略图线程堆栈中最多多少个operation
@property (nonatomic, assign) NSInteger maxOperationCount;

/// 直接使用外部传入的seekPosition来从原视频中获取缩略图，忽略内部计算
@property (nonatomic, assign) BOOL useInputSeekPositionDirectly;

/// 内部计算时忽略TrimRange
@property (nonatomic, assign) BOOL ignoreTrimRange;

//业务方需要的信息，来时啥样，complete回去时啥样
@property (nonatomic, assign) NSInteger beginTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger clipIndex;



#pragma mark - 内部用参数
@property (nonatomic, copy) NSString *identifier;//Clip或是Effect的identifier
@property (nonatomic, copy) NSString *clipFilePath;//clip或是媒effect对应的媒体文件的路径
@property (nonatomic, weak) XYStoryboard *storyboard;
@property (nonatomic, strong) CXiaoYingClip *clip;
@property (nonatomic, strong) XYVeRangeModel *trimVeRange;
@property (nonatomic, strong) XYVeRangeModel *sourceVeRange;
@property (nonatomic, assign) CGFloat  speedValue;
@property (nonatomic, assign) BOOL isReversed;
@property (nonatomic, assign) XYCommonEngineClipModuleType clipType;
@property (nonatomic, assign) NSInteger themeID;
@property (nonatomic, assign) NSInteger fixTime;

/// 是否SceneClip中的子Clip
@property (nonatomic, assign) BOOL isSubClip;
/// ThumbnailManager销毁时，是否需要清除该缩略图的缓存
@property (nonatomic, assign) BOOL needCleanCache;

/// 复制一个clip用于取缩略图
/// @param clip 需要被复制的clip
- (void)duplicatedClip:(CXiaoYingClip *)clip;

@end

NS_ASSUME_NONNULL_END
