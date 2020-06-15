//
//  XYProjectOperatonMgr.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/23.
//

#import "XYQProjectOperatonMgr.h"
#import "XYOperationMgrBase_Private.h"
#import "XYBaseProjectTask.h"
#import "XYQProjectTaskFactory.h"
#import "XYQprojectModel.h"
#import "XYCommonEngineTaskMgr.h"

@interface XYQProjectOperatonMgr ()<XYBaseEngineTaskDelegate>

@end

@implementation XYQProjectOperatonMgr

- (void)runTask:(XYQprojectModel *)projectModel {
   XYBaseProjectTask *projectTask = [XYQProjectTaskFactory factoryWithType:projectModel.taskID];
   projectTask.userInfo = projectModel.userInfo;
   projectTask.taskID = projectModel.taskID;
   projectTask.storyboard = self.storyboard;
   projectTask.delegate = self;
   projectTask.projectModel = projectModel;
    [[XYCommonEngineTaskMgr task] postTask:projectTask preprocessBlock:^{
        if ([self.delegate respondsToSelector:@selector(onOperationTaskStart:)]) {
            [self.delegate onOperationTaskStart:projectTask];
        }
    }];
}

#pragma mark -- delegate

- (void)onEngineFinish:(XYBaseEngineTask *)baseTask {
    if ([self.delegate respondsToSelector:@selector(onOperationTaskFinish:)]) {
        [self.delegate onOperationTaskFinish:baseTask];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.dataBoard setValue:baseTask forKey:[NSString stringWithFormat:@"%d",baseTask.taskID]];
    });
}

- (XYQprojectModel *)currentProjectModel {
    if (!_currentProjectModel) {
        XYEngineConfigModel *config = [[XYEngineConfigModel alloc] init];
        config.storyboard = self.storyboard;
        _currentProjectModel = [[XYQprojectModel alloc] init:config];
    }
    return _currentProjectModel;
}

@end
