//
//  XYVideoThumbnailManager.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYVideoThumbnailManager : NSObject

+ (XYVideoThumbnailManager *)manager;

/// 异步获取封面缩略图
/// @param thumbnailSize 封面宽、高
/// @param block 主线程 返回缩略图
- (void)fetchVideoCoverThumbnailsWithThumbnailSize:(CGSize)thumbnailSize block:(void (^)(UIImage *image))block;

/// 从总的视频根据时间点来获取缩略图
/// @param thumbnailSize 缩略图宽、高
/// @param seekPosition 获取缩略图对应的时间点
/// @param block 主线程 返回缩略图
- (void)fetchThumbnailsWithThumbnailSize:(CGSize)thumbnailSize seekPosition:(NSInteger)seekPosition block:(void (^)(UIImage *image))block;

/// 销毁视频根据时间点来获取缩略图的句柄 如退出当前工程需要销毁或者更改了效果，不然下次进来获取的还是上次数据
- (void)destroyThumbnailHandle;

@end

NS_ASSUME_NONNULL_END
