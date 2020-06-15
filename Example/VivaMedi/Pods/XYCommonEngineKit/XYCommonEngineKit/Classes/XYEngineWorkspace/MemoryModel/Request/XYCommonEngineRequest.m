//
//  XYCommonEngineRequest.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/5.
//

#import "XYCommonEngineRequest.h"
#import "XYEngineWorkspace.h"
#import "XYCommonEngineTaskMgr.h"
#import "XYClipEffectModel.h"
#import "XYBaseEffectTaskVision.h"
#import "XYCommonEngineGlobalData.h"
#import "XYEffectOperationMgr.h"
#import "XYEffectVisionModel.h"
#import "XYStoryboard+XYThumbnail.h"
#import <XYCategory/XYCategory.h>

@implementation XYCommonEngineRequest


+ (NSInteger)requestEffectTansDuration:(NSString *)effectTransFilePath editorPlayerViewFrame:(CGRect)editorPlayerViewFrame {
    if (effectTransFilePath) {
        XYStoryboard *storyboard = [XYEngineWorkspace currentStoryboard];
        NSString *templateFilePath = effectTransFilePath;
        MDWord dwLayoutMode = [storyboard getLayoutMode:editorPlayerViewFrame.size.width height:editorPlayerViewFrame.size.height];
        MTChar *pTemplatePath = (MTChar *)[templateFilePath UTF8String];
        CXiaoYingStyle *pStyle = [[CXiaoYingStyle alloc] init];
        MRESULT res = [pStyle Create:pTemplatePath
                        BGLayoutMode:dwLayoutMode
                            SerialNo:MNull];
        QVET_TRANSITION_INFO transInfo = {0};
        [pStyle GetTransInfo:&transInfo];
        [pStyle Destory];
        return transInfo.dwDuration;
    }
    return 0;
}


+ (void)requestVisionThumbnailsTimePosition:(NSInteger)tPosition
                                 pixelWidth:(NSInteger)pixelWidth pixelHeight:(NSInteger)pixelHeight
                                 identifier:(NSString *)identifier
                                      block:(void (^)(UIImage * _Nonnull))block {
    if (identifier) {
        XYEffectModel *effectModel = [[XYEngineWorkspace effectMgr] fetchEffectModel:identifier];
        if (effectModel.filePath) {
            XYStoryboard *storyboard = [[XYStoryboard alloc] init];
            [storyboard initXYStoryBoard];
            
            XYClipDataItem *dataItem = [[XYClipDataItem alloc] init];
            dataItem.startPos = 0;
            dataItem.endPos = -1;
            dataItem.timeScale = 1.0;
            dataItem.clipFilePath = effectModel.filePath;
            dataItem.rotation = 0;
            [storyboard insertClipByClipDataItem:dataItem Position:0];
            UInt32 duration = [storyboard getDuration];
            NSMutableArray<NSNumber *> *array = [NSMutableArray arrayWithCapacity:1];
            
            CGFloat tempDuraiton = (CGFloat)duration;
            [array addObject:@(tPosition)];
            [storyboard createThumbnails:pixelWidth
                           dwThumbPixelH:pixelHeight
                             dwPositions:[array copy]
                               PimalFlag:MTrue
                        onlyOriginalClip:MFalse
                                   block:^(UIImage *image, int index) {
                if (block) {
                    block(image);
                }
            }];
        }
    }
}


+ (MPOINT)requestStoryboardSizeWithInputWidth:(CGFloat)width inputScale:(MSIZE)inputScale isPhotoMV:(BOOL)isPhotoMV isAppliedEffects:(BOOL)isAppliedEffects {
    XYStoryboard *storyboard = [XYEngineWorkspace currentStoryboard];
    MPOINT result = [storyboard calFitSize:inputScale width:width isPhotoMV:isPhotoMV isAppliedEffects:isAppliedEffects];
    return result;
}

+ (UIImage *)requestTemplateThumbnail:(XYEffectVisionModel *)visionModel size:(CGSize)size {
    UIImage *image = [self getTemplateLogoImage:visionModel size:size];
    return image;
}

+ (UIImage*)getTemplateLogoImage:(XYEffectVisionModel *)visionModel size:(CGSize)size {
    NSString *filePath = visionModel.filePath;
    if ([filePath hasSuffix:@"gif"] || [filePath hasSuffix:@"GIF"]) {
        StickerInfo *stickerInfo = [[[XYBaseEffectTaskVision alloc] init] mapToStickerInfo:visionModel];
        if (0 == stickerInfo.dwFrameWidth) {
            stickerInfo.dwFrameWidth = size.width;
        }
        if (0 == stickerInfo.dwFrameHeight) {
            stickerInfo.dwFrameHeight = size.height;
        }
        return [[XYEngineWorkspace currentStoryboard] getStickerThumb:stickerInfo];
    } else {
        if ([NSString xy_isEmpty:filePath]) {
            return nil;
        }
        NSString* strXYT = filePath;
        CXiaoYingStyle* style = [[CXiaoYingStyle alloc] init];
        MRESULT res = [style Create:[strXYT UTF8String] BGLayoutMode:QVTP_LAYOUT_MODE_PORTRAIT SerialNo:MNull];
        if(res != 0)
            return nil;
        
        //3. get thumb and other and destroy style
        UIImage* image = [style GetThumbnailUIImage];
        [style Destory];
        style = nil;
        return image;
    }
}

@end
