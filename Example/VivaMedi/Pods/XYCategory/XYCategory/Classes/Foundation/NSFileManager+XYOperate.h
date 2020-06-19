//
//  NSFileManager+XYOperate.h
//  XYBase
//
//  Created by robbin on 2019/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (XYOperate)

+ (BOOL)xy_moveFromFile:(NSString *)fromFilePath toFile:(NSString *)toFilePath;

+ (BOOL)xy_copyFromFile:(NSString *)fromFilePath toFile:(NSString *)toFilePath;

+ (BOOL)xy_createFolderWithPath:(NSString *)folderPath;

+ (BOOL)xy_deleteFileWithPath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
