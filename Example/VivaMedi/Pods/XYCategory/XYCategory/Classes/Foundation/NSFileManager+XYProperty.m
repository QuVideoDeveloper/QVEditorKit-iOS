//
//  NSFileManager+XYProperty.m
//  XYBase
//
//  Created by robbin on 2019/4/10.
//

#import "NSFileManager+XYProperty.h"

@implementation NSFileManager (XYProperty)

+ (NSString *)xy_getFileNameFromPath:(NSString *)filePath {
    NSString *fileName = [filePath lastPathComponent];
    return fileName;
}

+ (NSString *)xy_getFileNameNoExtension:(NSString *)filePath {
    NSString *fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
    return fileName;
}

+ (NSString *)xy_getFileExtensionWithPath:(NSString *)filePath {
    NSString *ext = [filePath pathExtension];
    return ext;
}

+ (unsigned long long)xy_getFileSizeWithPath:(NSString *)filePath {
    NSDictionary *fileAttributes =[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [fileAttributes fileSize];
}

+ (BOOL)xy_fileExist:(NSString *)filePath {
    NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath] && ([fileDictionary fileSize] != 0);
}

@end
