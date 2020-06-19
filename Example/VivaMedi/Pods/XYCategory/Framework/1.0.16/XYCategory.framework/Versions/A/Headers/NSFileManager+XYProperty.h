//
//  NSFileManager+XYProperty.h
//  XYBase
//
//  Created by robbin on 2019/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (XYProperty)

+ (NSString *)xy_getFileNameFromPath:(NSString *)filePath;

+ (NSString *)xy_getFileNameNoExtension:(NSString *)filePath;

+ (NSString *)xy_getFileExtensionWithPath:(NSString *)filePath;

+ (unsigned long long)xy_getFileSizeWithPath:(NSString *)filePath;

+ (BOOL)xy_fileExist:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
