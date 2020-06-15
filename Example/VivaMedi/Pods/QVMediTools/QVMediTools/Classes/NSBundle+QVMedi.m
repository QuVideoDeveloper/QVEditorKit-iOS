//
//  NSBundle+XYInit.m
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import "NSBundle+QVMedi.h"

@implementation NSBundle (QVMedi)

+ (NSBundle *)qvmedi_bundleWithBundleName:(NSString * __nullable)bundleName
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *bundlePath = @"";
    NSBundle *tt_bundle = nil;
    if (!tt_bundle) {
        bundlePath = [NSString stringWithFormat:@"%@/%@.bundle", [bundle bundlePath], bundleName];
        tt_bundle = [NSBundle bundleWithPath:bundlePath];
    }

    return tt_bundle;
}

@end
