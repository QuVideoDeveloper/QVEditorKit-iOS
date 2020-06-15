//
//  NSFileManager+XYFileList.h
//  XiaoYing
//
//  Created by hongru qi on 2016/12/14.
//  Copyright © 2016年 XiaoYing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (XYFileList)

+ (NSString*)xy_removeLastSlash:(NSString*)filePath;

+ (void)xy_copyFileNamed:(NSString *)filename intoFolder:(NSString *)dirname;

+ (NSArray *)xy_getAllFileList:(NSString *)folderPath byExt:(NSString *)ext;

+ (unsigned long long)xy_getFileSize:(NSString *)filePath;

+ (BOOL)xy_isFileExist:(NSString *)filePath;

+ (BOOL)xy_isMusicFile:(NSString *)filePath;

+ (BOOL)xy_isImageFile:(NSString *)filePath;

+ (BOOL)xy_isVideoFile:(NSString *)filePath;

+ (BOOL)xy_isLocalMusicFileExists:(NSString *)filePath;

+ (long)xy_getVideoDuration:(NSString *)videoFilePath;

+ (BOOL)xy_moveFile:(NSString *)fromFilePath toFilePath:(NSString *)toFilePath;

+ (BOOL)xy_copyFile:(NSString *)fromFilePath toFilePath:(NSString *)toFilePath;

+ (BOOL)xy_createFolder:(NSString *)folderPath;

+ (BOOL)xy_deleteFile:(NSString *)filePath;

+ (void)xy_checkFoldExistAndCreateFolder:(NSString*)filePath;

+ (BOOL)xy_saveUIImage:(UIImage *)imageToSave toFilePath:(NSString *)toFilePath;

/**
 @param compressionQuality 只针对Jpg图片才有用，范围0.0～1.0
 */
+ (BOOL)xy_saveUIImage:(UIImage *)imageToSave toFilePath:(NSString *)toFilePath compressionQuality:(CGFloat)compressionQuality;

+ (void)xy_zip:(NSArray *)inputPaths zippedPath:(NSString *)zippedPath;

+ (NSArray *)xy_unzip:(NSString *)destinationPath zippedPath:(NSString *)zippedPath;

+ (CGSize)xy_getImageSize:(NSString *)imageFilePath;
@end
