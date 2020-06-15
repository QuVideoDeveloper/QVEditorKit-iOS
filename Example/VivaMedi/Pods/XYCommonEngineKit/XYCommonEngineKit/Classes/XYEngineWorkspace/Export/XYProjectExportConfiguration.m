//
//  XYProjectExportConfiguration.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/14.
//

#import "XYProjectExportConfiguration.h"

@implementation XYProjectExportConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fps = 30;
        self.bgColor = 0x000000;
        self.watermarkDisplayRect = CGRectMake(0,0,10000,10000);
        self.bitRate = 1.0;
        self.projectType = XYProjectTypeNormal;
    }
    return self;
}

@end
