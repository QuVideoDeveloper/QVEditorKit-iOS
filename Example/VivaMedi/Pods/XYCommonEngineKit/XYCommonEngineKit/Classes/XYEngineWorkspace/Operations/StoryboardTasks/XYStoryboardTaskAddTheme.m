//
//  XYStoryboardTaskAddTheme.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import "XYStoryboardTaskAddTheme.h"
#import "XYStoryboard.h"
#import "XYStoryboardModel.h"
#import "XYEngineWorkspace.h"
#import "XYClipOperationMgr.h"
#import "XYCommonEngineGlobalData.h"
#import <XYCategory/XYCategory.h>

@implementation XYStoryboardTaskAddTheme

- (BOOL)dataClipReinitThumbnailManager {
    return YES;
}

- (BOOL)isReload {
    return YES;
}

- (BOOL)needRebuildThumbnailManager {
    return YES;
}

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReOpen;
}

- (void)engineOperate {
    MPOINT outPutResolution = {0};
    NSInteger outPutResolutionWidth = [XYCommonEngineGlobalData data].configModel.outPutResolutionWidth;
    NSInteger outPutResolutionHeight = outPutResolutionWidth / self.storyboardModel.ratioValue;
    outPutResolution.x = outPutResolutionWidth;
    outPutResolution.y = outPutResolutionHeight;
    self.storyboardModel.outPutResolution = CGSizeMake(outPutResolutionWidth, outPutResolutionHeight);
    [self.storyboard setOutputResolution:&outPutResolution];
    [self.storyboard setTheme:self.storyboardModel.themePath];
    //主题有片尾 删除自定义片尾
    CXiaoYingClip *clip = [self.storyboard getClipByIndex:([self.storyboard getClipCount] - 1)];
    NSString *identifier = [self.storyboard getClipIdentifier:clip];
    CXiaoYingCover *cCoverBackModel = [self.storyboard getCover:AMVE_PROP_STORYBOARD_THEME_BACK_COVER];
    if (cCoverBackModel && ![NSString xy_isEmpty:identifier] && [identifier isEqualToString:XY_CUSTOM_COVER_BACK_IDENTIFIER]) {
        [[XYEngineWorkspace clipMgr] removeClipModelWithIdentifier:XY_CUSTOM_COVER_BACK_IDENTIFIER];
        [self.storyboard deleteClip:([self.storyboard getClipCount] - 1)];
    }
}

@end
