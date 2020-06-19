//
//  XYPhotoLibraryHelper.h
//  XYToolKit
//
//  Created by robbin on 2019/3/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XYPhotoLibraryErrorCode) {
    XYPhotoLibraryErrorNone,
    XYPhotoLibraryErrorInvalidFileUrl,
    XYPhotoLibraryErrorCreateAssetFailed,
    XYPhotoLibraryErrorSaveAssetFailed,
    XYPhotoLibraryErrorGetAssetUrlFailed,
};

NS_ASSUME_NONNULL_BEGIN

typedef void (^XYPhotoLibrarySaveCompletionBlock)(NSURL *assetURL, NSError *error);
typedef void (^XYPhotoLibrarySaveCompletionBlockWithLocalIdetifier)(NSURL *assetURL, NSError *error, NSString * localIdeitifier);

@interface XYPhotoLibraryHelper : NSObject

+ (void)xy_saveVideo:(NSURL *)videoUrl
       toCustomAlbum:(NSString *)albumName
     completionBlockWithLocalIdentifier:(XYPhotoLibrarySaveCompletionBlockWithLocalIdetifier)block;

+ (void)xy_saveImage:(NSURL *)imageUrl
       toCustomAlbum:(NSString *)albumName
     completionBlockWithLocalIdentifier:(XYPhotoLibrarySaveCompletionBlockWithLocalIdetifier)block;

/**
 保存视频到系统相册

 @param videoUrl 视频地址
 @param albumName 相册名称
 @param block 回调方法
 */
+ (void)xy_saveVideo:(NSURL *)videoUrl
       toCustomAlbum:(NSString *)albumName
     completionBlock:(XYPhotoLibrarySaveCompletionBlock)block;

/**
 保存图片到系统相册

 @param imageUrl 图片地址
 @param albumName 相册名称
 @param block 回调方法
 */
+ (void)xy_saveImage:(NSURL *)imageUrl
       toCustomAlbum:(NSString *)albumName
     completionBlock:(XYPhotoLibrarySaveCompletionBlock)block;


@end

NS_ASSUME_NONNULL_END
