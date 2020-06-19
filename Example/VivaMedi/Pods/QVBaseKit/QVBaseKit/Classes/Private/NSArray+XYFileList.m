//
//  NSArray+XYFileList.m
//  XiaoYing
//
//  Created by hongru qi on 2016/12/14.
//  Copyright © 2016年 XiaoYing. All rights reserved.
//

#import "NSArray+XYFileList.h"

@implementation NSArray (XYFileList)

+ (NSArray *)xy_getFileList:(NSString *)folderPath byExts:(NSArray *)exts
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for(NSString *ext in exts){
        NSArray *array = [self xy_getFileList:folderPath byExt:ext];
        if(array){
            [mutableArray addObjectsFromArray:array];
        }
    }
    return mutableArray;
}

+ (NSArray *)xy_getFileList:(NSString *)folderPath byExt:(NSString *)ext
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
    
    NSMutableArray *finalList = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < filterList.count; i++){
        NSString *fullPath = [NSString stringWithFormat:@"%@%@", folderPath, filterList[i]];//[folderPath stringByAppendingString:(NSString *)[filterList objectAtIndex:i]];
        [finalList addObject:fullPath];
    }
    
    return finalList;
}

@end
