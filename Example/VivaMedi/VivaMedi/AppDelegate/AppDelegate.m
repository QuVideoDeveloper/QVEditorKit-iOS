//
//  AppDelegate.m
//  VivaMedi
//
//  Created by 夏澄 on 2020/4/15.
//  Copyright © 2020 QuVideo. All rights reserved.
//

#import "AppDelegate.h"
#import "QVViewController.h"
#import "QVBaseNavigationController.h"
#import "QVTabVC.h"
#import <QVEditor/QVEditor.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //editor sdk 初始化
    QVEditorConfiguration *editorConfig = [[QVEditorConfiguration alloc] init];
    editorConfig.licensePath = [[NSBundle mainBundle] pathForResource:@"license" ofType:@"txt"];
    editorConfig.corruptImgPath = [[NSBundle mainBundle] pathForResource:@"vivavideo_default_corrupt_image" ofType:@"png"];
    editorConfig.defaultTemplateVersion = 1;
    [QVEditor initializeWithConfig:editorConfig delegate:self];
     self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
     self.window.backgroundColor = [UIColor whiteColor];
     self.window.rootViewController = [[QVBaseNavigationController alloc] initWithRootViewController:[[QVViewController alloc] init]];
     [self.window makeKeyAndVisible];
    return YES;
}

/// 可选参数 默认获取系统的语言编码
- (NSString *)languageCode {
    return @"zh-Hans";
}

/// 主题的字幕的转译
/// @param textPrepareMode 根据textPrepareMode类型设置参数
- (QVTextPrepareModel *)textPrepare:(QVTextPrepareMode)textPrepareMode {
    QVTextPrepareModel *textModel = [QVTextPrepareModel new];
    if (QVTextPrepareModeLocation == textPrepareMode) {
         textModel.location = @"location";
    }
    return textModel;
}

@end
