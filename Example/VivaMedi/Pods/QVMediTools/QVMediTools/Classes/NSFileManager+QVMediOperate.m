//
//  NSFileManager+XYOperate.m
//  XYBase
//
//  Created by robbin on 2019/4/10.
//

#import "NSFileManager+QVMediOperate.h"

@implementation NSFileManager (QVMediOperate)


+ (BOOL)qvmedi_createFolderWithPath:(NSString *)folderPath {
    return [[NSFileManager defaultManager] createDirectoryAtPath:folderPath
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}


@end
