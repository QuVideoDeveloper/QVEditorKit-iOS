//
//  UINib+XYInit.m
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import "UINib+XYInit.h"
#import "NSBundle+XYInit.h"

@implementation UINib (XYInit)

+ (UINib *)xy_nibWithNibName:(NSString *)name bundleName:(NSString * __nullable)bundleName
{
    return [UINib nibWithNibName:name bundle:[NSBundle xy_bundleWithBundleName:bundleName]];
}

+ (id)xy_uniqueViewWithNibName:(NSString *)name bundleName:(NSString * __nullable)bundleName
{
    if (name.length <= 0) {
        return nil;
    }
    return [[[UINib xy_nibWithNibName:name bundleName:bundleName] instantiateWithOwner:nil options:nil] lastObject];
}

@end
