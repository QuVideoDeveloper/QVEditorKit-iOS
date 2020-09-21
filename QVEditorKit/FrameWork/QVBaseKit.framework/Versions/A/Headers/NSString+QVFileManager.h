//
//  NSString+XYFileManager.h
//  XiaoYing
//
//  Created by hongru qi on 2016/12/14.
//  Copyright © 2016年 XiaoYing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QVFileManager)

+ (NSString *)qv_getFileName:(NSString *)filePath;

+ (NSString *)qv_getFileNameWithoutExtension:(NSString *)filePath;

+ (NSString *)qv_getFileExtension:(NSString *)filePath;

+ (NSString *)qv_registerFont:(NSString*)path;

@end
