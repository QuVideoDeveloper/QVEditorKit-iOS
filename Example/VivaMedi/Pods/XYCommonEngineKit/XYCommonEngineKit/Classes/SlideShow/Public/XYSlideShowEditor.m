//
//  XYSlideShowEditor.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import "XYSlideShowEditor.h"
#import "XYSlideShowConfiguration.h"
#import "XYAutoEditMgr.h"
#import "XYStoryboard.h"
#import "XYSlideShowEnum.h"
#import "XYSlideShowMedia.h"
#import "XYSlideShowClipMgr.h"

@implementation XYSlideShowEditor {
    NSString *_fullLanguage;
}

+ (XYSlideShowEditor *)sharedInstance {
    static XYSlideShowEditor *editor;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
      editor = [[XYSlideShowEditor alloc] init];
    });
    return editor;
}

- (void)initializeWithConfig:(XYSlideShowConfiguration *)config {
    _fullLanguage = config.fullLanguage;
    [XYAutoEditMgr sharedInstance].defaultStoryboardWidth = config.videoResolution.width;
    [XYAutoEditMgr sharedInstance].defaultStoryboardHeight = config.videoResolution.height;

}


- (void)createProjectWithThemeId:(NSInteger)themeId
                          medias:(NSArray <XYSlideShowMedia *> *)medias
                        complete:(void (^)(BOOL success))complete {
    [[XYAutoEditMgr sharedInstance] reInitSlideShowSession];
    _slideShowSession = [XYAutoEditMgr sharedInstance].slideShowSession;
    [[XYStoryboard sharedXYStoryboard] initXYStoryBoard];
    [[XYAutoEditMgr sharedInstance] setTheme:themeId];
    [medias enumerateObjectsUsingBlock:^(XYSlideShowMedia * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[XYAutoEditMgr sharedInstance] insertImage:obj];
    }];
    [XYAutoEditMgr sharedInstance].isPortraitScreen = YES;//默认是竖屏
    MSIZE size = [[XYStoryboard sharedXYStoryboard] getThemeInnerBestSize:[[XYStoryboard sharedXYStoryboard].templateDelegate onGetTemplateFilePathWithID:themeId]];
    if (size.cx < size.cy) {
        [XYAutoEditMgr sharedInstance].isPortraitScreen = YES;
    }else{
        [XYAutoEditMgr sharedInstance].isPortraitScreen = NO;
    }
    [[XYAutoEditMgr sharedInstance] makeStoryboard:_fullLanguage completeBlock:^(UInt32 result, id  _Nullable userData) {
        if (result != 0) {
            if (complete) {
                complete(NO);
            }
        }else{
            [[XYStoryboard sharedXYStoryboard] setStoryboardSession:[[XYAutoEditMgr sharedInstance] getStoryboardSession]];
            MPOINT outPutResolution = {0,0};
            CGSize outSize = [[XYAutoEditMgr sharedInstance] getExportSizeWithIsPortraitScreen:[XYAutoEditMgr sharedInstance].isPortraitScreen];
            outPutResolution.x = (MLong)outSize.width;
            outPutResolution.y = (MLong)outSize.height;
            [[XYAutoEditMgr sharedInstance] setOutputResolution:&outPutResolution];
            if (complete) {
                complete(YES);
            }
        }
    } detectFaceProgress:^(NSUInteger doneNum, NSUInteger totalNum) {
        
    }];
}

- (void)saveProject:(NSString *)projectFilePath
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure {
    [[XYAutoEditMgr sharedInstance] saveProject:projectFilePath completeBlock:^(UInt32 result, id  _Nullable userData) {
        if (0 == result) {
            if (success) {
                success();
            }
        } else {
            if (failure) {
                failure([NSError errorWithDomain:@"com.sdk.engine" code:result userInfo:@{NSLocalizedDescriptionKey: @"failed to save"}]);
            }
        }
    }];
}

- (void)loadProject:(NSString *)projectFilePath
            success:(void(^)(void))success
            failure:(void(^)(NSError *error))failure {
    [[XYAutoEditMgr sharedInstance] loadProject:projectFilePath completeBlock:^(UInt32 result, id  _Nullable userData) {
        if (0 == result) {
            if (success) {
                success();
            }
        } else {
            if (failure) {
                failure([NSError errorWithDomain:@"com.sdk.engine" code:result userInfo:@{NSLocalizedDescriptionKey: @"failed to load"}]);
            }
        }
    }];
}

- (XYSlideShowClipMgr *)clipMgr {
    if (!_clipMgr) {
        _clipMgr = [[XYSlideShowClipMgr alloc] init];
    }
    return _clipMgr;
}

@end
