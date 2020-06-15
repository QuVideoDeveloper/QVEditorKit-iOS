//
//  XYStoryboardUtility.h
//  XYCommonEngineKit
//
//  Created by lizitao on 2019/9/17.
//

#import "XYStoryboard.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYStoryboardUtility : NSObject

+ (BOOL)isThemeApplyed:(CXiaoYingStoryBoardSession *)storyboardSession;

+ (BOOL)isCoverExsit:(MDWord)coverType storyboard:(XYStoryboard *)storyboard;

+ (MDWord)getUnRealClipCount:(XYStoryboard *)storyboard;

+ (MDWord)getStoryboardFirstVideoTimestamp:(XYStoryboard *)storyboard;

+ (AMVE_POSITION_RANGE_TYPE)calcStoryboardPlayerRangeWithoutCover:(XYStoryboard *)storyboard;

+ (void)showLayer:(MFloat)fLayerID
       IsShown:(MBool)bIsShown
    storyboard:(XYStoryboard *)storyboard;

+ (AMVE_VIDEO_INFO_TYPE)getVideoInfo:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
