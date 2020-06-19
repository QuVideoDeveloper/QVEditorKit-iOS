//
//  NSString+XYEmpty.m
//  XYCategory
//
//  Created by robbin on 2019/4/10.
//

#import "NSString+XYEmpty.h"

@implementation NSString (XYEmpty)

+ (BOOL)xy_isEmpty:(NSString *)string {
    if (((NSNull *) string == [NSNull null]) || (string == nil) || ![string isKindOfClass:(NSString.class)]) {
        return YES;
    }
    
    string = [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)xy_isNotEmpty {
    return ![NSString xy_isEmpty:self];
}

@end
