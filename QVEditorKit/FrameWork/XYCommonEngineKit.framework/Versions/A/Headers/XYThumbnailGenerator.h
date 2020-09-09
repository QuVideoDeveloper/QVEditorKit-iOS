//
//  XYThumbnailGenerator.h
//  XYThumbnailGenerator
//
//  Created by 徐新元 on 2020/7/23.
//

#import <Foundation/Foundation.h>
#import "XYThumbnailGeneratorInputModel.h"
#import "XYThumbnailGeneratorOutputModel.h"

typedef NS_ENUM(NSInteger, XYThumbnailGeneratorErrorCode) {
    XYThumbnailGeneratorErrorCodeGetPHAssetFail,//获取PHAsset失败
    XYThumbnailGeneratorErrorCodeGetAVAssetFail,//获取AVAsset失败
    XYThumbnailGeneratorErrorCodeGetThumbnailFail,//获取缩略图失败
};

NS_ASSUME_NONNULL_BEGIN

@interface XYThumbnailGenerator : NSObject


/// 单例
+ (XYThumbnailGenerator *)sharedInstance;

/// 获取缩略图
/// @param inputBlock 输入
/// @param outputBlock 真实缩略图输出
/// @param placeholderBlock Placeholder输出
- (void)thumbnailWithInputBlock:(void (^__nonnull)(XYThumbnailGeneratorInputModel *inputModel))inputBlock
                    outputBlock:(void (^__nonnull)(XYThumbnailGeneratorOutputModel *outputModel))outputBlock
               placeholderBlock:(void (^)(XYThumbnailGeneratorOutputModel *outputModel))placeholderBlock;

- (void)destroy;

@end

NS_ASSUME_NONNULL_END
