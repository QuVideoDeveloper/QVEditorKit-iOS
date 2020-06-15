//
//  QVVideoEditManager.h
//  VivaMedi
//
//  Created by chaojie zheng on 2020/4/21.
//  Copyright © 2020 QuVideo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;

NS_ASSUME_NONNULL_BEGIN

@class QVMediAlbumMediaItem;

/// 视频处理manager
@interface QVMediVideoEditManager : NSObject

///  sharedInstance
+ (instancetype _Nonnull)sharedInstance;

- (void)removeObserver;

- (void)addClip:(NSInteger)index finish:(void(^)(void))finish;

- (void)selectImageFinish:(void(^)(QVMediAlbumMediaItem *mediaItem))finish;

- (void)selectOneVideoFinish:(void(^)(QVMediAlbumMediaItem *mediaItem))finish;

- (void)selectMediaItemFinish:(void(^)(QVMediAlbumMediaItem *mediaItem))finish;

- (void)selectVideoFinish:(void(^)(void))finish;

+ (NSString *)qvmedi_engineLocalIdentifier:(PHAsset *)phAsset;

@end

NS_ASSUME_NONNULL_END
