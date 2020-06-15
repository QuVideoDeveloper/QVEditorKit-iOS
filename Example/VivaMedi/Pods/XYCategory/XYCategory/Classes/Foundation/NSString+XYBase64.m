//
//  NSString+XYBase64.m
//  XYCategory
//
//  Created by robbin on 2019/6/24.
//

#import "NSString+XYBase64.h"
#import "NSData+XYBase64.h"

@implementation NSString (XYBase64)

- (NSString *)xy_base64EncodedString {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xy_base64EncodedString];
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData xy_dataWithBase64EncodedString:base64EncodedString];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
