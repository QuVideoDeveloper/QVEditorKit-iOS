//
//  NSArray+XYFileList.h
//  XiaoYing
//
//  Created by hongru qi on 2016/12/14.
//  Copyright © 2016年 XiaoYing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (XYFileList)

+ (NSArray *)xy_getFileList:(NSString *)folderPath byExts:(NSArray *)exts;

+ (NSArray *)xy_getFileList:(NSString *)folderPath byExt:(NSString *)ext;

@end
