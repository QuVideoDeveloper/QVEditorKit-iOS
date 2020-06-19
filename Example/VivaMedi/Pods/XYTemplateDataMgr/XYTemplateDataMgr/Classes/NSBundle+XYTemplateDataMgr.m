//
//  NSBundle+XYTemplateDataMgr.m
//  XYTemplateDataMgr
//
//  Created by hzy on 2019/8/22.
//

#import "NSBundle+XYTemplateDataMgr.h"


@implementation NSBundle (XYTemplateDataMgr)
+ (NSBundle *)xy_templateBundle {
    static NSBundle *bundle = nil;
    if (bundle == nil) {
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"XYTemplateDataMgr")] pathForResource:@"XYTemplateDataMgr" ofType:@"bundle"]];
    }
    return bundle;
}

@end
