//
//  XYStoryboardTaskRatio.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/11.
//

#import "XYStoryboardTaskRatio.h"
#import "XYCommonEngineGlobalData.h"

@implementation XYStoryboardTaskRatio

- (XYCommonEngineOperationCode)operationCode {
    return XYCommonEngineOperationCodeReBuildPlayer;
}

- (XYEngineReloadTimeLineType)reloadTimeLineType {
    return XYEngineReloadTimeLineByNone;
}

- (void)engineOperate {
    MPOINT outPutResolution = {0};
    outPutResolution.x = [XYCommonEngineGlobalData data].configModel.outPutResolutionWidth;
    outPutResolution.y = outPutResolution.x / self.storyboardModel.ratioValue;
    [self.storyboard setOutputResolution:&outPutResolution];
    self.storyboardModel.outPutResolution = CGSizeMake(outPutResolution.x, outPutResolution.y);
    [self.storyboard setPropRatioSelected:self.storyboardModel.isPropRatioSelected];
}

@end
