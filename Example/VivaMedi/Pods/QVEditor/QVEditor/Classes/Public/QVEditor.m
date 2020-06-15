//
//  QVEditor.m
//  QVEditor
//
//  Created by 夏澄 on 2020/4/23.
//

#import "QVEditor.h"
#import <XYTemplateDataMgr/XYTemplateDataMgr.h>
#import <XYCommonEngineKit/XYCommonEngineKit.h>

@implementation QVEditorConfiguration
@end

@implementation QVEditor

+ (QVEditor *)editor {
    static QVEditor *editor;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
      editor = [[QVEditor alloc] init];
    });
    return editor;
}

+ (void)initializeWithConfig:(QVEditorConfiguration *)config delegate:(id <QVEngineDataSourceProtocol>)delegate {
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
    engineparam.corruptImagePath = config.corruptImgPath;
    [XYEngine sharedXYEngine].engineLogDelegate = delegate;
    [[XYEngine sharedXYEngine] initEngineWithParam:engineparam
                                   templateAdapter:[XYTemplateDataMgr sharedInstance]
                                   filePathAdapter:[XYTemplateDataMgr sharedInstance]
                                       metalEnable:NO];
    [XYStoryboard sharedXYStoryboard].templateDelegate = [XYTemplateDataMgr sharedInstance];
    [XYStoryboard sharedXYStoryboard].textDataSourceDelegate = delegate;
    [XYStoryboard sharedXYStoryboard].dataSource = delegate;
    //inital template
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[XYTemplateDataMgr sharedInstance] initAll:config.defaultTemplateVersion];
        [[XYTemplateDataMgr sharedInstance] scanDisk:^(BOOL result) {

        }];
        
        [[XYTemplateDataMgr sharedInstance] registerTemplateFonts];
    
    });
}

@end
