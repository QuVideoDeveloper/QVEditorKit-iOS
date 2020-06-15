//
//  XYProjectTaskLoad.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/23.
//

#import "XYQProjectTaskLoad.h"

@implementation XYQProjectTaskLoad

- (void)engineOperate {
    if (self.projectModel.prjFilePath) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self.storyboard initXYStoryBoard];
        [self.storyboard loadStoryboard:self.projectModel.prjFilePath block:^(MRESULT errCode) {
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC));
    }
}

@end
