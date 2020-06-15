//
//  XYPhotoLibraryHelper.m
//  XYToolKit
//
//  Created by robbin on 2019/3/21.
//

#import "XYPhotoLibraryHelper.h"
@import Photos;

@implementation XYPhotoLibraryHelper

+ (void)xy_saveVideo:(NSURL *)videoUrl toCustomAlbum:(NSString *)albumName  completionBlock:(XYPhotoLibrarySaveCompletionBlock)block {
    [self xy_saveAsset:videoUrl isVideo:YES toCustomAlbum:albumName ext:[videoUrl.absoluteString pathExtension] completionBlock:^(NSURL * _Nonnull assetURL, NSError * _Nonnull error, NSString * _Nonnull localIdeitifier) {
        if (block) {
            block(assetURL, error);
        }
    }];
}

+ (void)xy_saveVideo:(NSURL *)videoUrl
       toCustomAlbum:(NSString *)albumName
completionBlockWithLocalIdentifier:(XYPhotoLibrarySaveCompletionBlockWithLocalIdetifier)block {
    [self xy_saveAsset:videoUrl isVideo:YES toCustomAlbum:albumName ext:[videoUrl.absoluteString pathExtension] completionBlock:block];
}

+ (void)xy_saveImage:(NSURL *)imageUrl
       toCustomAlbum:(NSString *)albumName
completionBlockWithLocalIdentifier:(XYPhotoLibrarySaveCompletionBlockWithLocalIdetifier)block {
    [self xy_saveAsset:imageUrl isVideo:NO toCustomAlbum:albumName ext:[imageUrl.absoluteString pathExtension] completionBlock:block];
}

+ (void)xy_saveImage:(NSURL *)imageUrl toCustomAlbum:(NSString *)albumName completionBlock:(XYPhotoLibrarySaveCompletionBlock)block {
    [self xy_saveAsset:imageUrl isVideo:NO toCustomAlbum:albumName ext:[imageUrl.absoluteString pathExtension] completionBlock:^(NSURL * _Nonnull assetURL, NSError * _Nonnull error, NSString * _Nonnull localIdeitifier) {
        if (block) {
            block(assetURL, error);
        }
    }];
}

+ (void)xy_saveAsset:(NSURL *)fileUrl isVideo:(BOOL)isVideo toCustomAlbum:(NSString *)albumName ext:(NSString *)ext completionBlock:(XYPhotoLibrarySaveCompletionBlockWithLocalIdetifier)block {
    if (!fileUrl) {
        [self complete:block assetURL:nil errorCode:XYPhotoLibraryErrorInvalidFileUrl errorUserInfo:nil localIdeitifier:nil];
        return;
    }
    
    __block NSString *localIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        if (albumName && albumName.length > 0) {
            //获取自定义相册changeRequest
            PHAssetCollectionChangeRequest *collectionRequest = nil;
            //创建搜索集合
            PHFetchResult <PHAssetCollection *>*result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
            //遍历搜索集合并取出对应的相册，返回当前的相册changeRequest
            for (PHAssetCollection *assetCollection in result) {
                if ([assetCollection.localizedTitle isEqualToString:albumName]) {
                    collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection assets:[PHAsset fetchAssetsInAssetCollection:assetCollection options:nil]];
                    break;
                }
            }
            //如果不存在，创建一个名字为albumName的相册changeRequest
            if (!collectionRequest && albumName.length > 0) {
                collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
            }
            
            if (!collectionRequest) {
                NSLog(@"获取collectionRequest失败");
                [self complete:block assetURL:nil errorCode:XYPhotoLibraryErrorCreateAssetFailed errorUserInfo:nil localIdeitifier:nil];
                return;
            }
            
            //创建一个占位对象
            PHObjectPlaceholder *placeHolder = nil;
            if (isVideo) {
                placeHolder = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileUrl].placeholderForCreatedAsset;
            } else {
                placeHolder = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:fileUrl].placeholderForCreatedAsset;
            }
            if (placeHolder == nil) {
                //创建占位对象失败，直接返回
                NSLog(@"创建placeHolder失败");
                [self complete:block assetURL:nil errorCode:XYPhotoLibraryErrorCreateAssetFailed errorUserInfo:nil localIdeitifier:nil];
                return;
            }
            //将占位对象添加到相册请求中
            [collectionRequest addAssets:@[placeHolder]];
            //保存一下localIdentifier，等到complete的时候要用
            localIdentifier = placeHolder.localIdentifier;
        } else {
            PHAssetChangeRequest *request;
            if (isVideo) {
                request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileUrl];
            } else {
                request = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:fileUrl];
            }

            localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success || error) {
            NSLog(@"保存失败");
            [self complete:block assetURL:nil errorCode:XYPhotoLibraryErrorSaveAssetFailed errorUserInfo:nil localIdeitifier:nil];
            return;
        }
        NSLog(@"保存成功");
        NSURL *urlAsset = [self assetUrlFromLocalIdentifier:localIdentifier ext:ext];
        if (!urlAsset) {
            [self complete:block assetURL:nil errorCode:XYPhotoLibraryErrorGetAssetUrlFailed errorUserInfo:nil localIdeitifier:nil];
        } else {
            [self complete:block assetURL:urlAsset errorCode:XYPhotoLibraryErrorNone errorUserInfo:nil localIdeitifier:localIdentifier];
        }
    }];
}

+ (void)complete:(XYPhotoLibrarySaveCompletionBlockWithLocalIdetifier)block assetURL:(NSURL *)assetURL errorCode:(XYPhotoLibraryErrorCode)errorCode errorUserInfo:(NSDictionary *)errorUserInfo localIdeitifier:(NSString *)localIdeitifier {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block(assetURL,[NSError errorWithDomain:@"XYPhotoLibraryError" code:errorCode userInfo:errorUserInfo], localIdeitifier);
        }
    });
}

+ (nullable NSURL *)assetUrlFromLocalIdentifier:(NSString *__nullable)localIdentifier ext:(NSString *)ext {
    if (!localIdentifier) {
        return nil;
    }
    
    NSArray *strings = [localIdentifier componentsSeparatedByString:@"/"];
    if (!strings || [strings count]==0) {
        return nil;
    }
    
    NSString *subId = strings[0];
    NSString *assetUrlString = [NSString stringWithFormat:@"assets-library://asset/asset.%@?id=%@&ext=%@",ext,subId,ext];
    return [NSURL URLWithString:assetUrlString];
}

@end
