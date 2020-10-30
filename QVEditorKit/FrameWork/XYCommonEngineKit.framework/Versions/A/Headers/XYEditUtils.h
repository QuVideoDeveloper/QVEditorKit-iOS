//
//  EditUtils.h
//  XiaoYing
//
//  Created by xuxinyuan on 13-5-30.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//

#import "XYStoryboard.h"
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, XYWatermarkType) {
    XYWatermarkTypeNomarl = 0,
    XYWatermarkTypeForUploading,//导出为了上传社区
};

typedef void (^IMPORT_MEDIA_RESULT_BLOCK)(BOOL suc);
typedef void (^PROCESS_IMAGE_RESULT_BLOCK)(BOOL suc);

@interface XYExportParam : NSObject

@property (nonatomic) int sourceType;
@property (nonatomic) MHandle hSession;
@property (nonatomic) CGSize pSrcSize;
@property (nonatomic) CGSize pDstSize;
@property (nonatomic) MDWord dwResampleMode;
@property (nonatomic) MDWord dwPos;
@property (nonatomic) MDWord dwLen;
@property (nonatomic) BOOL ignoreWatermarkFlag;
@property (nonatomic) CGRect watermarkDisplayRect;
@property (nonatomic) MInt64 llWaterMarkID;
@property (nonatomic) UInt32 bgColor;
@property (nonatomic, copy) NSString *nickNameWatermark;//昵称水印文字，为空则不显示
@property (nonatomic, copy) NSString *wmUserCode; //嵌入的数字水印字符串，例如：设备id字符串
@property (nonatomic) UInt32 wmHiderInterval;     //数字水印嵌入周期,1表示每帧都嵌入

- (instancetype)init DEPRECATED_MSG_ATTRIBUTE("Use initWithDefaultParams instead");
- (instancetype)initWithDefaultParams:(BOOL)isChinese;

@end

@interface XYEditUtils : NSObject

+ (QVET_RENDER_CONTEXT_TYPE)createDisplayContext:(UIView *)playbackView;

+ (CXiaoYingStream *)createStream:(int)sourceType
                         hSession:(MHandle)hSession
                       frameWidth:(int)frameWidth
                      frameHeight:(int)frameHeight
                            dwPos:(MDWord)dwPos
                            dwLen:(MDWord)dwLen
                        dwBGColor:(MDWord)dwBGColor;

+ (CXiaoYingStream *)createStreamForExport:(XYExportParam *)exportParam error:(NSError **)error isChinese:(BOOL)isChinese;

+ (void)rebuidStream:(CXiaoYingStream *)stream
          sourceType:(int)sourceType
            hSession:(MHandle)hSession
          frameWidth:(int)frameWidth
         frameHeight:(int)frameHeight
               dwPos:(MDWord)dwPos
               dwLen:(MDWord)dwLen;

+ (AMVE_BUBBLETEXT_SOURCE_TYPE *)allocBubbleSource;

+ (AMVE_BUBBLETEXT_SOURCE_TYPE *)allocBubbleSourceWithMutiTextCount:(NSInteger)mutiTextCount;

+ (void)freeBubbleSource:(AMVE_BUBBLETEXT_SOURCE_TYPE *)pBubbleSource;

+ (int)ARGB2ABGR:(int)argbValue;

+ (int)ABGR2ARGB:(int)abgrValue;

+ (BOOL)isFileEditable:(NSString *)fileName;

//Original duration to timescaled duration
+ (MDWord)originalDurationToTimeScaledDuration:(MDWord)originalDuration
                                     timeScale:(float)timeScale;

//Timescaled duration to original duration
+ (MDWord)timeScaledDurationToOriginalDuration:(MDWord)timeScaledDuration
                                     timeScale:(float)timeScale;

+ (BOOL)isPointInRotatedRect:(MPOINT)mpt
                       angle:(MFloat)angle
                      center:(MPOINT)center
                        rect:(MRECT)rect;

+ (MInt64)getWatermarkId:(XYWatermarkType)watermarkType nickName:(NSString *)nickName ignoreWatermarkFlag:(BOOL)ignoreWatermarkFlag isChinese:(BOOL)isChinese;

@end
