//
//  XYStoryboardTaskFactory.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import "XYStoryboardTaskFactory.h"
#import "XYBaseStoryboardTask.h"
#import "XYStoryboardTaskAddTheme.h"
#import "XYStoryboardTaskRatio.h"
#import "XYStoryboardTaskUndo.h"
#import "XYStoryboardTaskRedo.h"
#import "XYStoryboardTaskBackUp.h"
#import "XYStoryboardTaskReset.h"
#import "XYStoryboardTaskUpdateThemeText.h"

@implementation XYStoryboardTaskFactory

+ (XYBaseStoryboardTask *)factoryWithType:(XYCommonEngineTaskID)taskID {
    XYBaseStoryboardTask *storyboardTask;
    if (XYCommonEngineTaskIDStoryboardAddTheme== taskID) {
        
        storyboardTask = [[XYStoryboardTaskAddTheme alloc] init];
        
    } else if (XYCommonEngineTaskIDStoryboardRatio == taskID) {
        
        storyboardTask = [[XYStoryboardTaskRatio alloc] init];
        
    } else if (XYCommonEngineTaskIDStoryboardUndo == taskID) {
        
        storyboardTask = [[XYStoryboardTaskUndo alloc] init];
        
    } else if (XYCommonEngineTaskIDStoryboardRedo == taskID) {
        
        storyboardTask = [[XYStoryboardTaskRedo alloc] init];
        
    } else if (XYCommonEngineTaskIDStoryboardBackUp == taskID) {
        
        storyboardTask = [[XYStoryboardTaskBackUp alloc] init];
        
    } else if (XYCommonEngineTaskIDStoryboardReset == taskID) {
        
        storyboardTask = [[XYStoryboardTaskReset alloc] init];
        
    } else if (XYCommonEngineTaskIDStoryboardUpdateThemeText == taskID) {
        
        storyboardTask = [[XYStoryboardTaskUpdateThemeText alloc] init];
        
    }
    return storyboardTask;
}

@end
