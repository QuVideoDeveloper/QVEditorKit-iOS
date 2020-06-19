//
//  XYBackgroundTaskHelper.m
//  XYToolKit
//
//  Created by robbin on 2019/3/26.
//

#import "XYBackgroundTaskHelper.h"

@implementation XYBackgroundTaskHelper

+ (UIBackgroundTaskIdentifier)beginBackgroundTask:(void(^ __nullable)(void))handler {
    
    UIBackgroundTaskIdentifier backgroundTaskId = UIBackgroundTaskInvalid;
    if ([UIDevice currentDevice].isMultitaskingSupported) {
        backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            if (handler) {
                handler();
            }
        }];
    }
    return backgroundTaskId;
}

+ (void)endBackgroundTask:(UIBackgroundTaskIdentifier)backgroundTaskId {
    
    if (backgroundTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskId];
    }
}

@end
