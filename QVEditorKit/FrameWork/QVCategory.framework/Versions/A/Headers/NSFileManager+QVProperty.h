//
//  NSFileManager+XYProperty.h
//  XYBase
//
//  Created by robbin on 2019/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (QVProperty)

+ (NSString *)qv_getFileNameFromPath:(NSString *)filePath;

+ (NSString *)qv_getFileNameNoExtension:(NSString *)filePath;

+ (NSString *)qv_getFileExtensionWithPath:(NSString *)filePath;

+ (unsigned long long)qv_getFileSizeWithPath:(NSString *)filePath;

+ (BOOL)qv_fileExist:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
