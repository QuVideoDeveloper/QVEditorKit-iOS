//
//  QVAppDelegate.m
//  QVEditorKit
//
//  Created by Sunshine on 05/28/2020.
//  Copyright (c) 2020 Sunshine. All rights reserved.
//

#import "QVAppDelegate.h"

#import <XYTemplateDataMgr/XYTemplateDataMgr.h>
//#import <XYCommonEngineKit/XYStoryboard.h>
#import <XYCommonEngine/CXiaoYingInc.h>
#import <XYCommonEngineKit/XYCommonEngineKit.h>

@implementation QVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //inital template db\
    //初始化window
    //inital template db
    NSBundle *mainBundle =  [NSBundle xy_templateBundle];
    XYTemplateDBMgr *templateDBMgr = [[XYTemplateDBMgr alloc] init];
    NSString *globalTargetPath = APP_TEMPLATE_DATABASE_FULL_PATH;
    NSString *globalSourcePath = [[mainBundle resourcePath] stringByAppendingPathComponent:APP_TEMPLATE_DATABASE_NAME];
    [templateDBMgr initDBWithTargetPath:globalTargetPath sourcePath:globalSourcePath];
    [[XYDBUtility shareInstance] registerDatabaseManager:templateDBMgr forName:@"XYTemplateDBMgr"];
    
    //inital engine
    XYEngineParam *engineparam = [[XYEngineParam alloc] initWithDefaultParam];
    engineparam.licensePath = nil;
    [[XYEngine sharedXYEngine] initEngineWithParam:engineparam
                                   templateAdapter:[XYTemplateDataMgr sharedInstance]
                                   filePathAdapter:[XYTemplateDataMgr sharedInstance]
                                       metalEnable:NO];
    [XYStoryboard sharedXYStoryboard].templateDelegate = [XYTemplateDataMgr sharedInstance];

    //inital template
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[XYTemplateDataMgr sharedInstance] initAll:1];
        [[XYTemplateDataMgr sharedInstance] scanDisk:^(BOOL result) {

        }];
        
        [[XYTemplateDataMgr sharedInstance] registerTemplateFonts];
    
    });

//    [[XYStoryboard sharedXYStoryboard] initAll];
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
