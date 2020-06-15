//
//  XYProjectExportMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/14.
//

#import <Foundation/Foundation.h>
#import "XYProjectExportConfiguration.h"

@class XYClipModel;

typedef NS_ENUM(NSInteger, XYProjectExportResultType) {
    XYProjectExportResultTypeNormal = 0,//正常
    XYProjectExportResultTypeCancel,//取消导出
    XYProjectExportResultTypeDidEnterBackgroundStop,//进入后台后结束导出
    XYProjectExportResultTypeIsNotEnoughDiskStop,//没有足够的存储空间
    XYProjectExportResultTypeIsExporting,//上一个视频在导出中
    XYProjectExportResultTypeFailed,//失败
};

typedef void (^export_start_block)(void);
typedef void (^export_success_block)(void);
typedef void (^export_progress_block)(NSInteger currentTime,NSInteger totalTime);
typedef void (^export_failure_block)(XYProjectExportResultType result, NSInteger errorCode);

NS_ASSUME_NONNULL_BEGIN

@interface XYProjectExportMgr : NSObject


/// 导出视频
/// @param config 导出配置参数
/// @param start 导出开始 主线程
/// @param progress 导出进度 主线程
/// @param success 导出成功 主线程
/// @param failure 导出失败 主线程
- (void)exportWithConfig:(XYProjectExportConfiguration *)config
                   start:(export_start_block)start
                progress:(export_progress_block)progress
                 success:(export_success_block)success
                 failure:(export_failure_block)failure;

/// 取消导出
- (void)cancel;


/// 倒放
/// @param filePath 需要的视频资源路径
/// @param exportFilePath 导出的文件了路径
/// @param progress 倒放进度 主线程
/// @param success 倒放成功 主线程
/// @param failure 倒放失败 主线程
- (void)reverseWithFilePath:(NSString *)filePath
     exportFilePath:(NSString *)exportFilePath
           progress:(export_progress_block)progress
            success:(export_success_block)success
            failure:(export_failure_block)failure;
@end

NS_ASSUME_NONNULL_END
