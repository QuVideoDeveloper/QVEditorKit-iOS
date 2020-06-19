//
//  NSData+XYString.m
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import "NSData+XYString.h"

@implementation NSData (XYString)

- (NSString *)xy_UTF8String {
    if (self.length > 0) {
        return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    }
    return @"";
}


@end
