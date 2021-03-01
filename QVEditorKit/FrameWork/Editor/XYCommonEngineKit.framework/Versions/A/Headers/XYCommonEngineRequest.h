//
//  XYCommonEngineRequest.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/5.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"
#import "XYEffectPropertyMgr.h"
#import <Photos/Photos.h>

@class XYEffectVisionModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYCommonEngineRequest : NSObject

/// 获取素材转场的时长
/// @param effectTransFilePath 转场路径
+ (NSInteger)requestEffectTansDuration:(NSString *)effectTransFilePath;

/// 判断转场是否可以编辑
/// @param effectTransFilePath 转场路径
+ (BOOL)requestTranEditable:(NSString *)effectTransFilePath;

/// 同步获取素材的缩略图
/// @param visionModel visionModel
/// @param size 尺寸
+ (UIImage *)requestTemplateThumbnail:(XYEffectVisionModel *)visionModel
                                 size:(CGSize)size;


/// 异步获取素材的缩略图，包括相册作为素材的
/// @param visionModel 视觉效果对象
/// @param size size 尺寸
/// @param block main block
+ (void)requestEffectVisionThumbnail:(XYEffectVisionModel *)visionModel
                                size:(CGSize)size
                               block:(void(^)(UIImage *image))block;

/// 同步获取素材的缩略图，包括相册作为素材的
/// @param visionModel 视觉效果对象
/// @param size size 尺寸
+ (UIImage *)synchronousRequestEffectVisionThumbnail:(XYEffectVisionModel *)visionModel size:(CGSize)size;

/// 将phAsset的assetId 转换引擎的路径
/// @param phAsset phAsset
+ (NSString *)requestFilePathForEngineFilePath:(PHAsset *)phAsset;


///将engineFilePath 转换成PHAsset
/// @param engineFilePath engineFilePath
+ (PHAsset *)requestAssetByEngineFilePath:(NSString *)engineFilePath;

+ (MPOINT)requestStoryboardSizeWithInputWidth:(CGFloat)width
      inputScale:(MSIZE)inputScale
       isPhotoMV:(BOOL)isPhotoMV
isAppliedEffects:(BOOL)isAppliedEffects;

@end

NS_ASSUME_NONNULL_END
