//
//  XYThumbnailGeneratorUtil.h
//  XYThumbnailGenerator
//
//  Created by 徐新元 on 2020/7/24.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYThumbnailGeneratorUtil : NSObject

/// 将引擎传过来的路径转换成PHAsset的
/// @param engineClipFilePath 跟引擎约定好的路径格式（PHASSET://xxxxxxxxx.mp4）
+ (NSString * __nullable)localIdentifierFromEngineClipFilePath:(NSString *)engineClipFilePath;

/// 通过localIdentifier获取到PHAsset
/// @param localIdentifier PHAsset的localIdentifier
+ (PHAsset * __nullable)phAssetFromLocaIdentifier:(NSString *)localIdentifier;

/// 通过PHAsset获取AVAsset
/// @param phasset PHAsset
/// @param resultHandler 回调Block
+ (void)avassetFromPHAsset:(PHAsset *)phasset
             resultHandler:(void (^)(AVAsset * __nullable asset))resultHandler;

/// 从AVAsset里获取缩略图
/// @param avasset AVAsset
/// @param thumbnailPixelSize 缩略图的尺寸(像素)
/// @param seekPositions 时间点数组（毫秒）
/// @param requesetedTimeTolerance 返回的真实缩略图允许时间范围 [seekPosition-requesetedTimeTolerance, seekPosition+requesetedTimeTolerance]
+ (void)thumbnailFromAvasset:(AVAsset *)avasset
          thumbnailPixelSize:(CGSize)thumbnailPixelSize
               seekPositions:(NSArray<NSNumber *> *)seekPositions
      requestedTimeTolerance:(NSInteger)requestedTimeTolerance
                  newCalFunc:(BOOL)newCalFunc
                clipDuration:(NSInteger)clipDuration
           completionHandler:(void(^)(UIImage * __nullable image, NSInteger actualSeekPosition))completionHandler;

/// 图片镜头从PHAsset中获取缩略图
/// @param phasset 图片的phasset
/// @param thumbnailPixelSize 缩略图的尺寸(像素)
/// @param completionHandler 结果回调
+ (void)thumbnailFromPHAsset:(PHAsset *)phasset
          thumbnailPixelSize:(CGSize)thumbnailPixelSize
           completionHandler:(void(^)(UIImage * _Nullable image))completionHandler;

/// 通过ImageIO的方法来resize图片，可以大幅减少内存占用
/// @param localImageFilePath 图片文件路径
/// @param pointSize 需要缩放的大小
+ (UIImage * __nullable)downSampleLocalImage:(NSString *)localImageFilePath toPointSize:(CGSize)pointSize;

@end

NS_ASSUME_NONNULL_END
