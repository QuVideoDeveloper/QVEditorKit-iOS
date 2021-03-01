//
//  XYDotAnalyzerProvider.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/10/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XYAudioAnalyzerProvider, XYVideoAnalyzerProvider;

@interface XYDotAnalyzerProvider : NSObject

/// 单例使用可选
+ (XYDotAnalyzerProvider *)provider;

/// 音频卡点分析
@property(nonatomic, strong) XYAudioAnalyzerProvider *audioDotProvider;

/// 视频卡点分析
@property(nonatomic, strong) XYVideoAnalyzerProvider *vedioDotProvider;

@end

NS_ASSUME_NONNULL_END
