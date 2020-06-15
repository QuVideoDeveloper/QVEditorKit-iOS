//
//  NSFileManager+XYFileList.m
//  XiaoYing
//
//  Created by hongru qi on 2016/12/14.
//  Copyright © 2016年 XiaoYing. All rights reserved.
//

#import "NSFileManager+XYFileList.h"
#import <AVFoundation/AVAsset.h>
#import <SSZipArchive/SSZipArchive.h>

@implementation NSFileManager (XYFileList)

+ (NSString*)xy_removeLastSlash:(NSString*)filePath
{
    if ([self xy_isEmptyString:filePath] || [filePath length] < 2) {
        return filePath;
    }
    
    NSUInteger length = [filePath length];
    NSString* lastCharString = [filePath substringWithRange:NSMakeRange(length - 1,1)];
    
    if ([lastCharString isEqualToString:@"/"]) {
        NSString* newFilePath = [filePath substringWithRange:NSMakeRange(0,(length - 1))];
        return newFilePath;
    }else{
        return filePath;
    }
}

+ (int)xy_getFileListCount:(NSString *)folderPath
{
    [self xy_removeLastSlash:folderPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    int count = 0;
    NSArray *fileList = [fileManager subpathsOfDirectoryAtPath:folderPath error:&error];
    
    if (fileList != nil && [fileList count] > 0) {
        for (NSString* item in fileList) {
            BOOL isDir = NO;
            BOOL valid;
            NSString* filePath = [NSString stringWithFormat:@"%@/%@",folderPath,item];
            valid = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
            if (valid && isDir) {
                int fileCount = [self xy_getFileListCount:filePath];
                count = count + fileCount;
            }else{
                count++;
            }
        }
    }
    
    return count;
}

+ (void)xy_copyFileNamed:(NSString *)filename intoFolder:(NSString *)dirname
{
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    // set up the full path for the destination file
    NSString *writableFilePath = [dirname stringByAppendingPathComponent:filename];
    success = [fileManager fileExistsAtPath:writableFilePath];
    
    // if the file is already there, just return
    if (success) return;
    // The file not exist, so copy it to the documents flder.
    NSString *defaultFileFolder = [[NSBundle mainBundle] resourcePath];
    
    NSString *defaultFilePath = [defaultFileFolder stringByAppendingPathComponent:filename];
    success = [fileManager copyItemAtPath:defaultFilePath toPath:writableFilePath error:&error];
    
    if (!success) {
        //[self alert:@"Failed to copy resource file"];
        NSAssert1(0, @"Failed to copy file to documents with message '%@'.", [error localizedDescription]);
    }
}

+ (NSArray *)xy_getAllFileList:(NSString *)folderPath byExt:(NSString *)ext
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *filterList = nil;
    NSArray *fileList = [fileManager subpathsOfDirectoryAtPath:folderPath error:&error];
    if(!ext){
        filterList = fileList;
    }else{
        NSPredicate *fltr = [NSPredicate predicateWithFormat:
                             [NSString stringWithFormat:@"self ENDSWITH '%@'",ext]];
        filterList = [fileList filteredArrayUsingPredicate:fltr];
    }
    
    NSInteger count = [filterList count];
    NSMutableArray *finalList = [[NSMutableArray alloc]init];
    
    for(int i=0;i<count;i++){
        NSString *fullPath = [NSString stringWithFormat:@"%@%@", folderPath, filterList[i]];//[folderPath stringByAppendingString:(NSString *)[filterList objectAtIndex:i]];
        [finalList addObject:fullPath];
    }
    
    return finalList;
}

+ (unsigned long long)xy_getFileSize:(NSString *)filePath
{
    NSDictionary *fileAttributes =[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [fileAttributes fileSize];
}

+ (BOOL)xy_isFileExist:(NSString *)filePath
{
    NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath] && ([fileDictionary fileSize] != 0);
}

+ (void)xy_checkFoldExistAndCreateFolder:(NSString*)filePath
{
    NSString* newFilePath = [self xy_removeLastSlash:filePath];
    BOOL isDir = NO;
    BOOL valid = [[NSFileManager defaultManager] fileExistsAtPath:newFilePath isDirectory:&isDir];
    
    if (valid) {
        if (!isDir) {
            [self xy_deleteFile:newFilePath];
            [self xy_createFolder:newFilePath];
        }
    }else{
        [self xy_createFolder:newFilePath];
    }
}

+ (BOOL)xy_deleteFile:(NSString *)filePath
{
    if ([self xy_isEmptyString:filePath]) {
        return NO;
    }
    
    BOOL res = [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    return res;
}

+ (BOOL)xy_createFolder:(NSString *)folderPath
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
}

+ (BOOL)xy_copyFile:(NSString *)fromFilePath toFilePath:(NSString *)toFilePath
{
    if(![self xy_isFileExist:fromFilePath] || [self xy_isEmptyString:toFilePath]){
        return NO;
    }
    
    return [[NSFileManager defaultManager] copyItemAtPath:fromFilePath toPath:toFilePath error:nil];
}

+ (BOOL)xy_moveFile:(NSString *)fromFilePath toFilePath:(NSString *)toFilePath
{
    if(![self xy_isFileExist:fromFilePath] || [self xy_isEmptyString:toFilePath]){
        return NO;
    }
    
    return [[NSFileManager defaultManager] moveItemAtPath:fromFilePath toPath:toFilePath error:nil];
}

+ (BOOL)xy_isVideoFile:(NSString *)filePath
{
    if(filePath && [filePath hasPrefix:@"/"]
       && ([filePath hasSuffix:@".mp4"] || [filePath hasSuffix:@".m4v"])){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)xy_isImageFile:(NSString *)filePath
{
    if(filePath && [filePath hasPrefix:@"/"]
       && ([filePath hasSuffix:@".jpg"] || [filePath hasSuffix:@".png"])){
        return YES;
    }else{
        return NO;
    }
}


+ (BOOL)xy_isMusicFile:(NSString *)filePath
{
    if(([filePath hasSuffix:@".m4a"] || [filePath hasSuffix:@".mp3"] || [filePath hasSuffix:@".wav"])){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)xy_isLocalMusicFileExists:(NSString *)filePath
{
    if(filePath && [filePath hasPrefix:@"/"]
       && ([filePath hasSuffix:@".m4a"] || [filePath hasSuffix:@".mp3"] || [filePath hasSuffix:@".wav"])){
        return [self xy_isFileExist:filePath];
    }else{
        return NO;
    }
}

+ (long)xy_getVideoDuration:(NSString *)videoFilePath
{
    if([self xy_isFileExist:videoFilePath]){
        NSURL *sourceMovieURL = [NSURL fileURLWithPath:videoFilePath];
        AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
        CMTime duration = sourceAsset.duration;
        return (long)duration.value/duration.timescale;
    }else{
        return 0;
    }
}

+ (BOOL)xy_saveUIImage:(UIImage *)imageToSave toFilePath:(NSString *)toFilePath
{
    return [NSFileManager xy_saveUIImage:imageToSave toFilePath:toFilePath compressionQuality:0.7];
}

+ (BOOL)xy_saveUIImage:(UIImage *)imageToSave toFilePath:(NSString *)toFilePath compressionQuality:(CGFloat)compressionQuality
{
    if(!imageToSave || !toFilePath){
        return NO;
    }
    [self xy_createFolder:[toFilePath stringByDeletingLastPathComponent]];
    if([toFilePath hasSuffix:@".png"]){
        return [UIImagePNGRepresentation(imageToSave) writeToFile:toFilePath atomically:YES];
    }else{
        return [UIImageJPEGRepresentation(imageToSave, compressionQuality) writeToFile:toFilePath atomically:YES];
    }
}

+ (void)xy_zip:(NSArray *)inputPaths zippedPath:(NSString *)zippedPath
{
    [SSZipArchive createZipFileAtPath:zippedPath withFilesAtPaths:inputPaths];
}


+ (NSArray *)xy_unzip:(NSString *)destinationPath zippedPath:(NSString *)zippedPath
{
    NSString *destinationTmpPath = [NSString stringWithFormat:@"%@/Temp_%lld",destinationPath,[self xy_currentMilliseconds]];
    [self xy_createFolder:destinationTmpPath];
    // Unzipping
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [SSZipArchive unzipFileAtPath:zippedPath toDestination:destinationTmpPath];
    NSString *trashFolder = [NSString stringWithFormat:@"%@/__MACOSX",destinationTmpPath];
    [self xy_deleteFile:trashFolder];
    //    NSLog(@"upzip %@ res=%hhd",zippedPath,res);
    NSArray *afterUnzipFileList = [fileManager subpathsAtPath:destinationTmpPath];
    
    NSMutableArray *filterList = [[NSMutableArray alloc] init];
    for(NSString *str in afterUnzipFileList){
        NSString *tmpfullpath = [NSString stringWithFormat:@"%@/%@",destinationTmpPath,str];
        NSString *fullpath = [NSString stringWithFormat:@"%@/%@",destinationPath,str];
        BOOL isDir = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath: tmpfullpath isDirectory:&isDir] && ![tmpfullpath isEqualToString:zippedPath]){
            if(!isDir){
                [self xy_moveFile:tmpfullpath toFilePath:fullpath];
                [filterList addObject:fullpath];
            }else{
                [self xy_createFolder:fullpath];
            }
        }
    }
    [self xy_deleteFile:destinationTmpPath];
    return filterList;
}

+ (CGSize)xy_getImageSize:(NSString *)imageFilePath
{
    if([self xy_isFileExist:imageFilePath]){
        UIImage *image = [UIImage  imageWithContentsOfFile:imageFilePath];
        return image.size;
    }else{
        return CGSizeMake(480, 480);
    }
}

+ (BOOL)xy_isEmptyString:(NSString *)string;
{
    if (((NSNull *) string == [NSNull null]) || (string == nil) || ![string isKindOfClass:(NSString.class)]) {
        return YES;
    }
    
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

+ (long long)xy_currentMilliseconds
{
    return [[NSDate date] timeIntervalSince1970]*1000;
}

@end
