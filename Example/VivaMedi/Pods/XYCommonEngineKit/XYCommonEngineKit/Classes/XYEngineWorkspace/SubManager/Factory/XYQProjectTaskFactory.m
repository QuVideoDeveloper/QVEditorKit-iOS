//
//  XYProjectTaskFactory.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/23.
//

#import "XYQProjectTaskFactory.h"
#import "XYBaseProjectTask.h"
#import "XYQProjectTaskLoad.h"
#import "XYQProjectTaskSaveProject.h"
#import "XYQProjectTaskMemoryLoadFinish.h"
#import "XYQProjectTaskCreate.h"

@implementation XYQProjectTaskFactory

+ (XYBaseProjectTask *)factoryWithType:(XYCommonEngineTaskID)taskID {
    XYBaseProjectTask *projectTask;
    if (XYCommonEngineTaskIDQProjectLoadProject == taskID) {
        
        projectTask = [[XYQProjectTaskLoad alloc] init];
        
    } else if (XYCommonEngineTaskIDQProjectSaveProject == taskID) {
        
        projectTask = [[XYQProjectTaskSaveProject alloc] init];
        
    } else if (XYCommonEngineTaskIDProjectMemoryDataLoadFinish == taskID) {
        
        projectTask = [[XYQProjectTaskMemoryLoadFinish alloc] init];
        
    } else if (XYCommonEngineTaskIDQProjectCreate == taskID) {
        
        projectTask = [[XYQProjectTaskCreate alloc] init];
        
    }
    return projectTask;
}


@end
