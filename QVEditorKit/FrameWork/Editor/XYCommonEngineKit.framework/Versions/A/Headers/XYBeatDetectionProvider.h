//
//  XYBeatDetectionProvider.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2021/9/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XYVeRangeModel;

@interface XYBeatDetectionData : NSObject

/// 弱拍时间点,单位ms
@property (nonatomic, copy) NSArray<NSNumber *> *beatValues;

/// 强拍时间点，单位ms
@property (nonatomic, copy) NSArray<NSNumber *> *downBeatValues;

@end

@interface XYBeatDetectionConfig : NSObject

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

/// progress 值范围 [0-1]
typedef void (^BeatDetectionProgressBlock)(CGFloat progress);
typedef void (^BeatDetectionFinishBlock)(BOOL success, NSString * _Nullable outPath, NSError * _Nullable error);

@interface XYBeatDetectionProvider : NSObject

/// 解析节拍点
/// @param config 配置参数
/// @param progress 进度 回调
/// @param finish 结束 回调
- (void)analyzeBeatDetection:(XYBeatDetectionConfig *)config
                    progress:(BeatDetectionProgressBlock)progress
                      finish:(BeatDetectionFinishBlock)finish;

/// 解析结束后从输出的json文件中获取解析结果
/// @param filePath 解析后的结果文件路径
/// @param audioRange 需要获取的range
+ (XYBeatDetectionData *)dataWithOutDataFilePath:(NSString *)filePath
                                      audioRange:(XYVeRangeModel *)audioRange;

/// 获取音视频文件时长
/// @param filePath 文件路径
+ (NSInteger)fetchMediaDurationWithFilePath:(NSString *)filePath;

/// 销毁audio analyzer
- (BOOL)unInit;

@end

NS_ASSUME_NONNULL_END
