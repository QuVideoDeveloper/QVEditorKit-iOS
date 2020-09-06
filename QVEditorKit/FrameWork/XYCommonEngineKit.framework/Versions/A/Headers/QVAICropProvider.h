//
//  QVAICropProvider.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/8/28.
//

#import <Foundation/Foundation.h>

struct QVAISize {
    NSInteger width;
    NSInteger height;
};
typedef struct CG_BOXABLE QVAISize QVAISize;

CG_INLINE QVAISize
QVAISizeMake(NSInteger width, NSInteger height)
{
  QVAISize size; size.width = width; size.height = height; return size;
}


@class QVAICropInputInfo;

NS_ASSUME_NONNULL_BEGIN

@interface QVAICropProvider : NSObject

/// 不支持并发
+ (QVAICropProvider *)shareInstance;

/// 裁剪初始化
/// @param modelPath  模型路径，传到文件夹即可，如/xxx/xxx/models * @返回值：错误码，0-正确，其他-错误
- (NSInteger)initializeAICropWithModelPath:(NSString *)modelPath;

/// 按照裁切输出图像的边长信息进行自动图像裁切（按宽高比在原图上裁切，输出的图像缩放到裁切目标宽高）
/// @param inputInfo 输入配置参数
/// @param size 期望得到的尺寸
/// @param completionBlock mian block
- (void)cropImageWithInputInfo:(QVAICropInputInfo *)inputInfo
                          size:(QVAISize)size
               completionBlock:(void(^)(BOOL success, UIImage *image, NSError *error))completionBlock;

/// 按照裁切目标的宽高比进行自动图像裁切（按比例在原图上裁切，输出的图像没有缩放）
/// @param inputInfo 输入配置参数
/// @param aspectRatio 期望得到的分辨率(目标图像宽比高)，必须是图像宽/图像高
/// @param completionBlock mian block
- (void)cropImageWithInputInfo:(QVAICropInputInfo *)inputInfo
                   aspectRatio:(CGFloat)aspectRatio
               completionBlock:(void(^)(BOOL success, UIImage *image, NSError *error))completionBlock;

/// 释放后如果需要再次裁剪 需要重新initializeAICropWithModelPath
- (void)releaseCropHandle;

@end

NS_ASSUME_NONNULL_END
