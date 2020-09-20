//
//  NSFileManager+XYOperate.h
//  XYBase
//
//  Created by robbin on 2019/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFileManager (QVOperate)

+ (BOOL)qv_moveFromFile:(NSString *)fromFilePath toFile:(NSString *)toFilePath;

+ (BOOL)qv_copyFromFile:(NSString *)fromFilePath toFile:(NSString *)toFilePath;

+ (BOOL)qv_createFolderWithPath:(NSString *)folderPath;

+ (BOOL)qv_deleteFileWithPath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
