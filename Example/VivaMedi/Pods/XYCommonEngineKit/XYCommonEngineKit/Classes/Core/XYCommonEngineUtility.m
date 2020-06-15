//
//  XYCommonEngineUtility.m
//  XYCommonEngineKit
//
//  Created by lizitao on 2019/9/17.
//

#import "XYCommonEngineUtility.h"
#import <XYCategory/XYCategory.h>

@implementation XYCommonEngineUtility
    
    
+ (Class)obtainValidCommonEngineClass:(NSString *)cls
{
    if ([NSString xy_isEmpty:cls]) return nil;
    Class clas = NSClassFromString(cls);
    if (clas) {
        return clas;
    }
    return nil;
}
    
+ (BOOL)isTwoFloatEqual:(float)float1 float2:(float)float2
{
    return fabsf(float1 - float2) < 1.0e-7;
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
    
+ (BOOL)xy_createFolder:(NSString *)folderPath
{
    return [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
}
    
+ (BOOL)xy_isFileExist:(NSString *)filePath
{
    NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath] && ([fileDictionary fileSize] != 0);
}


@end
