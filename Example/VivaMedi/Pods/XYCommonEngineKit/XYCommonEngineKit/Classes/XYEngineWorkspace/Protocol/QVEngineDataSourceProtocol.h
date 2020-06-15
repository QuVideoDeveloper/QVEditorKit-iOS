//
//  QVEngineDataSourceProtocol.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/2.
//

#import <Foundation/Foundation.h>
#import "QVTextPrepareModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol QVEngineDataSourceProtocol <NSObject>

/// 可选参数 默认获取系统的语言编码
- (NSString *)languageCode;

/// 主题的字幕的转译
/// @param textPrepareMode 根据textPrepareMode类型设置参数
- (QVTextPrepareModel *)textPrepare:(QVTextPrepareMode)textPrepareMode;


/// traceLog
/// @param log 输出的日子字符串
- (void)xYEngineTarceLog:(NSString *)log;

/// log
/// @param log 输出的日子字符串
- (void)xYEnginePrintLog:(NSString *)log;

@end

NS_ASSUME_NONNULL_END
