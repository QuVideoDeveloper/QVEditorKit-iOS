//
//  XYCommonEngineRequest.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/5.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"
#import "XYEffectPropertyMgr.h"

@class XYEffectVisionModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYCommonEngineRequest : NSObject

//获取素材转场的时长
+ (NSInteger)requestEffectTansDuration:(NSString *)effectTransFilePath editorPlayerViewFrame:(CGRect)editorPlayerViewFrame;

+ (MPOINT)requestStoryboardSizeWithInputWidth:(CGFloat)width inputScale:(MSIZE)inputScale isPhotoMV:(BOOL)isPhotoMV isAppliedEffects:(BOOL)isAppliedEffects;

+ (UIImage *)requestTemplateThumbnail:(XYEffectVisionModel *)visionModel size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
