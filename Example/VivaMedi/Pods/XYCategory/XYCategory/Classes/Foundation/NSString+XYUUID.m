//
//  NSString+XYUUID.m
//  XYCategory
//
//  Created by robbin on 2019/6/24.
//

#import "NSString+XYUUID.h"

@implementation NSString (XYUUID)

+ (NSString *)xy_UUIDString {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}


@end
