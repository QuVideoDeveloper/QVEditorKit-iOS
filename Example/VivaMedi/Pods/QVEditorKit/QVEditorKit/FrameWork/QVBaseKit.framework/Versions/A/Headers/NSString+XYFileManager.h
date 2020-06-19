//
//  NSString+XYFileManager.h
//  XiaoYing
//
//  Created by hongru qi on 2016/12/14.
//  Copyright © 2016年 XiaoYing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XYFileManager)

+ (NSString *)xy_getFileName:(NSString *)filePath;

+ (NSString *)xy_getFileNameWithoutExtension:(NSString *)filePath;

+ (NSString *)xy_getFileExtension:(NSString *)filePath;

+ (NSString *)xy_registerFont:(NSString*)path;

@end
