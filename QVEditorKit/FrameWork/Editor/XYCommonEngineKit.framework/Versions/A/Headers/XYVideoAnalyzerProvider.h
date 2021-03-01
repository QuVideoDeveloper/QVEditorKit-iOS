//
//  XYVideoAnalyzerProvider.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/10/16.
//

#import <Foundation/Foundation.h>
#import "XYCommonEngineDefileHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class XYVeRangeModel;

@interface XYVideoDotConfig : NSObject

/// 视频路径
@property (nonatomic, copy) NSString *videoFilePath;

/// 分析的range 默认是全长
@property (nonatomic, strong) XYVeRangeModel *trimRange;

/// 检测方式 默认是 XYVideoAnalyzeTypeSeg
@property (nonatomic, assign) XYVideoAnalyzeType type;

@end

/// progress 值范围 [0-1]
typedef void (^VideoAnalyzerProgressBlock)(CGFloat progress);
/// -1 == error.code 取消的回调
typedef void (^VideoAnalyzerFinishBlock)(BOOL success, NSArray <NSNumber *> * _Nullable dots, NSError * _Nullable error);

@interface XYVideoAnalyzerProvider : NSObject

/// 解析音乐卡点
/// @param config 配置参数
/// @param progress 进度 子线程
/// @param finish 结束 子线程
- (void)analyzeDots:(XYVideoDotConfig *)config
           progress:(VideoAnalyzerProgressBlock)progress
             finish:(VideoAnalyzerFinishBlock)finish;


/// 取消
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
