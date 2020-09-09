//
//  XYThumbnailGeneratorOutputModel.h
//  XYThumbnailGenerator
//
//  Created by 徐新元 on 2020/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYThumbnailGeneratorOutputModel : NSObject

@property (nonatomic, strong) UIImage *thumbnailImage;

/// 缓存的Key
@property (nonatomic, copy) NSArray<NSString *> *cacheKeys;

///相对物理文件换算后的时间点(单位毫秒)
@property (nonatomic, copy) NSArray<NSNumber *> *realSeekPositions;

/// 媒体文件路径
@property (nonatomic, copy) NSString *mediaFilePath;

//业务方需要的信息，来时啥样，complete回去时啥样
@property (nonatomic, assign) NSInteger beginTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger clipIndex;

@end

NS_ASSUME_NONNULL_END
