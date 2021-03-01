//
//  NSFileManager+XYFileList.h
//  XiaoYing
//
//  Created by hongru qi on 2016/12/14.
//  Copyright © 2016年 XiaoYing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (QVFileList)

+ (NSString*)qv_removeLastSlash:(NSString*)filePath;

+ (void)qv_copyFileNamed:(NSString *)filename intoFolder:(NSString *)dirname;

+ (NSArray *)qv_getAllFileList:(NSString *)folderPath byExt:(NSString *)ext;

+ (unsigned long long)qv_getFileSize:(NSString *)filePath;

+ (BOOL)qv_isFileExist:(NSString *)filePath;

+ (BOOL)qv_isMusicFile:(NSString *)filePath;

+ (BOOL)qv_isImageFile:(NSString *)filePath;

+ (BOOL)qv_isVideoFile:(NSString *)filePath;

+ (BOOL)qv_isLocalMusicFileExists:(NSString *)filePath;

+ (long)qv_getVideoDuration:(NSString *)videoFilePath;

+ (BOOL)qv_moveFile:(NSString *)fromFilePath toFilePath:(NSString *)toFilePath;

+ (BOOL)qv_copyFile:(NSString *)fromFilePath toFilePath:(NSString *)toFilePath;

+ (BOOL)qv_createFolder:(NSString *)folderPath;

+ (BOOL)qv_deleteFile:(NSString *)filePath;

+ (void)qv_checkFoldExistAndCreateFolder:(NSString*)filePath;

+ (BOOL)qv_saveUIImage:(UIImage *)imageToSave toFilePath:(NSString *)toFilePath;

/**
 @param compressionQuality 只针对Jpg图片才有用，范围0.0～1.0
 */
+ (BOOL)qv_saveUIImage:(UIImage *)imageToSave toFilePath:(NSString *)toFilePath compressionQuality:(CGFloat)compressionQuality;

+ (void)qv_zip:(NSArray *)inputPaths zippedPath:(NSString *)zippedPath;

+ (NSArray *)qv_unzip:(NSString *)destinationPath zippedPath:(NSString *)zippedPath;

+ (CGSize)qv_getImageSize:(NSString *)imageFilePath;
@end
