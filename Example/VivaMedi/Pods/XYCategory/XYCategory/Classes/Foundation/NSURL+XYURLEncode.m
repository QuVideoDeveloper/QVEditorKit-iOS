//
//  NSURL+XYURLEncode.m
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import "NSURL+XYURLEncode.h"
#import "NSString+XYURLEncode.h"

@implementation NSURL (XYURLEncode)

- (nullable NSURL *)xy_encode {
    NSString * encodeString = [self.absoluteString xy_stringByURLEncode];
    return [NSURL URLWithString:encodeString];
}

- (NSURL *)xy_decode {
    NSString * encodeString = [self.absoluteString xy_stringByURLDecode];
    return [NSURL URLWithString:encodeString];
}

@end
