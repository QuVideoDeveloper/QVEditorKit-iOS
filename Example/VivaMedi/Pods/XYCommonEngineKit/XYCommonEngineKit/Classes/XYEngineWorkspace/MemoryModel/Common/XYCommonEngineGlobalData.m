//
//  XYCommonEngineGlobalData.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/4.
//

#import "XYCommonEngineGlobalData.h"
#import "XYVeRangeModel.h"
#import "XYEngineWorkspace.h"
#import "XYStoryboard.h"

static dispatch_once_t dataOnceToken;
static XYCommonEngineGlobalData *_data;

@implementation XYCommonEngineGlobalData

+ (XYCommonEngineGlobalData *)data {
    dispatch_once(&dataOnceToken, ^{
      _data = [[XYCommonEngineGlobalData alloc] init];
    });
    return _data;
}

+ (void)clean {
    dataOnceToken = 0;
    _data = nil;
}

- (XYEngineWorkspaceConfiguration *)configModel {
    if (!_configModel) {
        _configModel = [[XYEngineWorkspaceConfiguration alloc] init];
    }
    return _configModel;
}

- (CGRect)playbackViewFrame {
    return CGRectMake(0, 0, [XYEngineWorkspace currentStoryboard].playView.streamSize.width, [XYEngineWorkspace currentStoryboard].playView.streamSize.height);
}

@end
