//
//  XYCommonEngineLifeCycleService.m
//  XYCommonAPIManager
//
//  Created by lizitao on 2019/8/21.
//

#import "XYCommonEngineLifeCycleService.h"
#import "XYCommonEngineTaskMgr.h"

@interface XYCommonEngineLifeCycleService ()

@end

@implementation XYCommonEngineLifeCycleService

- (void)start {
    
    [self addObserver];
}

- (void)stop {
    [self removeObserver];
}

- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(applicationWillResignActive:)
                                                       name:UIApplicationWillResignActiveNotification
                                                     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(applicationDidBecomeActive:)
                                                       name:UIApplicationDidBecomeActiveNotification
                                                     object:nil];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];


}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [[XYCommonEngineTaskMgr task] pause];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [[XYCommonEngineTaskMgr task] resume];
}


@end
