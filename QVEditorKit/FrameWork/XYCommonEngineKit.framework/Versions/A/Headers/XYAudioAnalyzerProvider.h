//
//  XYAudioExtractManager.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/9/10.
//

@class XYVeRangeModel;

@interface XYAudioDotParam : NSObject

/// 解析的模型文件路径
@property (nonatomic, copy) NSString * _Nullable strAudioModelFilePath;

/// 解析的音乐文件
@property (nonatomic, copy) NSString *strAudioFilePath;

/// 解析后的结果文件路径，名称APP定义，不重复就行 
@property (nonatomic, copy) NSString *strOutDataFilePath;

/// 重新解析，生成结果文件。参数变化时 默认YES
@property (nonatomic, assign) BOOL bNewBuild;

/// 音乐是否重复播放 默认NO 可选参数
@property (nonatomic, assign) BOOL bRepeatAudio;

/// 时间起点 和 数据时间长度 毫秒
@property (nonatomic, strong) XYVeRangeModel *audioRange;

/// 因为repeat的缘故，引入这个变量 默认全长 起始点为在storyboard中Effect起始的时间 可选参数
@property (nonatomic, strong) XYVeRangeModel *dstAudioRange;

@end

#import <Foundation/Foundation.h>
/// progress 值范围 [0-1]
typedef void (^AudioAnalyzerProgressBlock)(CGFloat progress);
typedef void (^AudioAnalyzerFinishBlock)(BOOL success, NSString *outPath, NSError * _Nullable error);


NS_ASSUME_NONNULL_BEGIN

@interface XYAudioAnalyzerProvider : NSObject

+ (XYAudioAnalyzerProvider *)provider;

/// 解析音乐卡的
/// @param config 配置参数
/// @param progress 进度 主线程
/// @param finish 结束 主线程
- (void)analyzeAudioDots:(XYAudioDotParam *)config
                progress:(AudioAnalyzerProgressBlock)progress
                  finish:(AudioAnalyzerFinishBlock)finish;


/// 根据路径获取对应的dot数据
/// @param outputFilePath 输出的路径
/// @param range 范围
- (NSArray<NSNumber*>* _Nullable)fetchDotByOutputFilepath:(NSString *)outputFilePath range:(XYVeRangeModel *)range;

/// 销毁audio analyzer
- (BOOL)unInit;

@end

NS_ASSUME_NONNULL_END
