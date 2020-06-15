//
//  XYStoryboardTaskUpdateThemeText.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/23.
//

#import "XYStoryboardTaskUpdateThemeText.h"

@implementation XYStoryboardTaskUpdateThemeText
- (void)engineOperate {
//    self.operationCode = XYCommonEngineOperationCodeUpdateEffect;
    self.operationCode = XYCommonEngineOperationCodeUpdateAllEffect;
    [self.storyboardModel.themeTextList enumerateObjectsUsingBlock:^(TextInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CXiaoYingEffect *effect = [self.storyboard setThemeTextWithTextInfo:obj];
        self.pEffect = effect;
//        CXiaoYingClip *clip = nil;
//
//        if(obj.themeTextType == ThemeTextTypeFrontCover) {
//            clip = [self.storyboard getCover:AMVE_PROP_STORYBOARD_THEME_COVER];
//        } else if (obj.themeTextType == ThemeTextTypeBackCover) {
//            clip = [self.storyboard getCover:AMVE_PROP_STORYBOARD_THEME_BACK_COVER];
//        } else if (obj.themeTextType == ThemeTextTypeStoryboard) {
//            clip = [[self.storyboard getStoryboardSession] getDataClip];
//        }
//        self.pClip = clip;
//        if(!clip) {
//            self.operationCode = XYCommonEngineOperationCodeDisplayRefresh;
//        }
    }];
    
}
@end
