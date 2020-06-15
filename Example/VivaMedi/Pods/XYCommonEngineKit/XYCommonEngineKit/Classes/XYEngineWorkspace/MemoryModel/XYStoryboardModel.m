//
//  XYStoryboardModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import "XYStoryboardModel.h"
#import "XYStoryboard.h"
#import "XYClipModel.h"
#import "XYEngineWorkspace.h"
#import "XYClipOperationMgr.h"
#import "XYStbBackUpModel.h"
#import "XYCommonEngineGlobalData.h"

@interface XYStoryboardModel()

@property(nonatomic, weak) XYStoryboard *storyboard;

@end

@implementation XYStoryboardModel

- (instancetype)init:(XYEngineConfigModel *)config {
    self = [super init];
       if (self) {
           self.undoActionState = XYEngineUndoActionStateNone;
           self.storyboard = config.storyboard;
           [self reload];
       }
       return self;
}

- (void)reload {
    [self reloadThemeID];
    [self reloadIsRatioSelected];
    [self reloadOutPutResolution];
    [self reloadThemePath];
    [self reloadThemeTextList];
}

- (void)reloadThemeTextList {
    self.themeTextList = [self.storyboard getAllThemeTextInfosWithViewFrame:[XYCommonEngineGlobalData data].configModel.bounds];
}

- (void)reloadThemePath {
   self.themePath = [self.storyboard getThemePath];
}

- (void)reloadThemeID {
   _themeID = [self.storyboard getThemeID];
}

- (void)reloadIsRatioSelected {
  _isPropRatioSelected = [self.storyboard isRatioSelected];
}

- (void)reloadOutPutResolution {
    MPOINT outPutResolution = {0,0};
    [self.storyboard getOutputResolution:&outPutResolution];
    self.outPutResolution = CGSizeMake(outPutResolution.x, outPutResolution.y);
    CGFloat outPutResolutionY = (CGFloat)outPutResolution.y;
    self.ratioValue = outPutResolution.x / outPutResolutionY;
}


- (NSArray *)themeMusicPathList {
    CXiaoYingEngine *cxiaoyingEngine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
    if (!self.themePath) {
        return nil;
    } else {
        CXiaoYingEngine *cxiaoyingEngine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
       return [CXiaoYingStyle GetThemeDefaultMusicPaths:cxiaoyingEngine ThemePath:self.themePath];
    }
}

@end
