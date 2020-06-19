//
//  QVEditor.m
//  QVEditor
//
//  Created by 夏澄 on 2020/4/23.
//

#import "QVEditor.h"
#import <XYTemplateDataMgr/XYTemplateDataMgr.h>

@implementation QVEditorConfiguration
@end

@implementation QVEditor

+ (void)initializeWithConfig:(QVEditorConfiguration *)config {
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
    engineparam.licensePath = config.licensePath;
    [[XYEngine sharedXYEngine] initEngineWithParam:engineparam
                                   templateAdapter:[XYTemplateDataMgr sharedInstance]
                                   filePathAdapter:[XYTemplateDataMgr sharedInstance]
                                       metalEnable:NO];
    [XYStoryboard sharedXYStoryboard].templateDelegate = [XYTemplateDataMgr sharedInstance];

    //inital template
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[XYTemplateDataMgr sharedInstance] initAll];
        [[XYTemplateDataMgr sharedInstance] scanDisk:^(BOOL result) {

        }];
        
        [[XYTemplateDataMgr sharedInstance] registerTemplateFonts];
    
    });
}

@end
