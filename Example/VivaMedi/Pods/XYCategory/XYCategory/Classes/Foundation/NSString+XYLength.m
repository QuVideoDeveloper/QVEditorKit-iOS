//
//  NSString+XYLength.m
//  XYCategory
//
//  Created by robbin on 2019/4/10.
//

#import "NSString+XYLength.h"

@implementation NSString (XYLength)

- (NSUInteger)xy_unicodeLength {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar uc = [self characterAtIndex:i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    return asciiLength;
}

@end
