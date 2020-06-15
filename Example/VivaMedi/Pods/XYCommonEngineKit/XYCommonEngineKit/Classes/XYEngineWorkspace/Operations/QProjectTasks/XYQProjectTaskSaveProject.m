//
//  XYProjectTaskSaveProject.m
//  AWSCore
//
//  Created by 夏澄 on 2019/10/23.
//

#import "XYQProjectTaskSaveProject.h"

@implementation XYQProjectTaskSaveProject

- (void)engineOperate {
    if ([self.storyboard getStoryboardHSession] == NULL || [self.storyboard getClipCount] == 0) {
        self.succeed = NO;
    }else {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [self.storyboard saveStoryboardWithSaveConfigBlock:^XYStoryboardSaveConfig * _Nonnull(XYStoryboardSaveConfig *saveConfig) {
            saveConfig.prjFilePath = self.projectModel.prjFilePath;
            saveConfig.needUpdateThumbnail = self.projectModel.thumbnailFilePath != nil;
            saveConfig.thumbnailFilePath = self.projectModel.thumbnailFilePath;
            saveConfig.thumbPos = self.projectModel.thumbPos;
            return saveConfig;
        } completeBlock:^(MRESULT result) {
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC));
    }
}

@end
