//
//  XYEngineWorkspaceConfigModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/2.
//

#define APP_BUNDLE_DIRECTORY         \
[[NSBundle mainBundle] resourcePath]

#define APP_BUNDLE_PRIVATE_PATH         \
[NSString stringWithFormat:@"%@/private",APP_BUNDLE_DIRECTORY]

#define APP_BUNDLE_EFFECTS_PATH          \
[NSString stringWithFormat:@"%@/imageeffect/",APP_BUNDLE_PRIVATE_PATH]

#define APP_BUNDLE_TRANSITIONS_PATH          \
[NSString stringWithFormat:@"%@/transition/",APP_BUNDLE_PRIVATE_PATH]

#import "XYEngineWorkspaceConfiguration.h"

@implementation XYEngineWorkspaceConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.effectXyt03FilePath = [NSString stringWithFormat:@"%@0x4B00000000000003.xyt", APP_BUNDLE_EFFECTS_PATH];
        self.effectXytCFilePath = [NSString stringWithFormat:@"%@0x4B0000000000000C.xyt", APP_BUNDLE_EFFECTS_PATH];
        self.effectXytDFilePath = [NSString stringWithFormat:@"%@0x4B0000000000000D.xyt", APP_BUNDLE_EFFECTS_PATH];
        self.effectXytEFilePath = [NSString stringWithFormat:@"%@0x4B0000000000000E.xyt", APP_BUNDLE_EFFECTS_PATH];
        self.effectXytFFilePath = [NSString stringWithFormat:@"%@0x4B0000000000000F.xyt", APP_BUNDLE_EFFECTS_PATH];

        self.adjustEffectId = 0x4B00000000080001LL;
        self.adjustEffectPath = [NSString stringWithFormat:@"%@0x4B00000000080001.xyt", APP_BUNDLE_EFFECTS_PATH];
        self.isMVPrj = NO;
        self.outPutResolutionWidth = 640;
        self.addClipNeedAutoAdjustVideoScale = NO;
        self.effectDefaultTransFilePath = [NSString stringWithFormat:@"%@0300000000000000.xyt", APP_BUNDLE_TRANSITIONS_PATH];        
    }
    return self;
}

@end
