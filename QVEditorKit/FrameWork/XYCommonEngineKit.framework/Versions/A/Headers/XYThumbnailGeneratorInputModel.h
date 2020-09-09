//
//  XYThumbnailGeneratorInputModel.h
//  XYThumbnailGenerator
//
//  Created by 徐新元 on 2020/7/24.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "XYEngineEnum.h"
#import "XYClipModel.h"

typedef NS_ENUM(NSInteger, XYThumbnailType) {
    XYThumbnailTypeUnknown,//未知格式
    XYThumbnailTypePHAssetVideo,//系统相册视频的缩略图
    XYThumbnailTypePHAssetImage,//系统相册图片的缩略图
    XYThumbnailTypePHAssetGif,//系统相册Gif的缩略图
    XYThumbnailTypeLocalVideo,//本地视频的缩略图
    XYThumbnailTypeLocalImage,//本地图片的缩略图
    XYThumbnailTypeLocalGif,//本地Gif的缩略图
    XYThumbnailTypePIP,//画中画镜头的缩略图
};

typedef NS_ENUM(NSInteger, XYThumbnailQueueType) {
    XYThumbnailQueueTypeSystem,//用系统方法取缩略图
    XYThumbnailQueueTypeEngine,//用引擎方法取缩略图
};


NS_ASSUME_NONNULL_BEGIN

@interface XYThumbnailGeneratorInputModel : NSObject

#pragma mark - 外部传入的数据
///Clip的identifier
@property (nonatomic, copy) NSString *clipIdentifier;

///XYClipModel最好是外面传进来，避免再遍历重新取
@property (nonatomic, strong) XYClipModel *clipModel;

///Effect的identifier
@property (nonatomic, copy) NSString *effectIdentifier;

///缩略图时间点(单位毫秒)
@property (nonatomic, copy) NSArray<NSNumber *> *originalSeekPositions;

///缩略图的尺寸（单位是point，不是像素，不传的话，默认50x50）
@property (nonatomic, assign) CGSize thumbnailPointSize;

/// 真实时间的缩略图会在这个区域内返回 [requestedTime-requestedTimeTolerance, requestedTime+requestedTimeTolerance] requestedTimeTolerance越短的话，就会耗费更多时间, -1的话就是没有限制
@property (nonatomic, assign) NSInteger requestedTimeTolerance;

@property (nonatomic, copy) void (^outputBlock)(id outputModel);

@property (nonatomic, copy) void (^placeholderBlock)(id outputModel);

//业务方需要的信息，来时啥样，complete回去时啥样
@property (nonatomic, assign) NSInteger beginTime;
@property (nonatomic, assign) NSInteger endTime;
@property (nonatomic, assign) NSInteger clipIndex;

#pragma mark - 根据传入数据计算得出的参数

/// Clip的类型
@property (nonatomic, assign) XYCommonEngineClipModuleType clipType;

/// 缩略图类型
@property (nonatomic, assign, readonly) XYThumbnailType thumbnailType;

/// 媒体文件路径
@property (nonatomic, copy, readonly) NSString *mediaFilePath;

/// 缓存的Key
@property (nonatomic, copy, readonly) NSArray<NSString *> *cacheKeys;

///相对物理文件换算后的时间点(单位毫秒)
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *realSeekPositions;

/// 取缩略图的Queue
@property (nonatomic, assign, readonly) XYThumbnailQueueType thumbnailQueueType;

/// PHAsset
@property (nonatomic, strong) PHAsset *phAsset;

/// AVAsset
@property (nonatomic, strong) AVAsset *avAsset;

/// 计算过去缩略图要用的辅助参数
- (void)calculateInputModel;

@end

NS_ASSUME_NONNULL_END
