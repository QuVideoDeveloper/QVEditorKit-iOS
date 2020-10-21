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

/// 清除缓存的无法获取缩略图的key（iOS14会出现一开始没权限拿不到，后来用户授权了又可以拿到了的情况）
- (void)cleanFailedCacheMap;

@end

NS_ASSUME_NONNULL_END
