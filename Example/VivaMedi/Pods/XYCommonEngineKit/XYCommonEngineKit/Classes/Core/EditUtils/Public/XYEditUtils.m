//
//  EditUtils.m
//  XiaoYing
//
//  Created by xuxinyuan on 13-5-30.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//

#import "XYEditUtils.h"
#import "XYEngine.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYEffect.h"
#import "XYStoryboard+XYClip.h"
#import "XYCommonEngineGlobalData.h"
#import <XYCategory/XYCategory.h>

#define PREF_VALUE_NO                                   @"no"
#define PREF_VALUE_YES                                  @"yes"

static NSString *const kXYEditUtilsErrorDomain = @"kXYEditUtilsErrorDomain";

@implementation XYExportParam

- (instancetype)init {
	NSAssert(NO, @"Use initWithDefaultParams instead");
	return [super init];
}

- (instancetype)initWithDefaultParams:(BOOL)isChinese {
	self = [super init];

	self.sourceType = AMVE_STREAM_SOURCE_TYPE_STORYBOARD;
	self.hSession = MNull;
	self.pSrcSize = CGSizeMake(0, 0);
	self.pDstSize = CGSizeMake(0, 0);
	self.dwResampleMode = AMVE_RESAMPLE_MODE_UPSCALE_FITIN;
	self.dwPos = 0;
	self.dwLen = -1;
	self.ignoreWatermarkFlag = NO;
	self.watermarkDisplayRect = CGRectMake(0, 0, 10000, 10000);
	self.llWaterMarkID = (isChinese == NO) ? 0x4B00000000000002L : 0x4B00000000000001L;
	self.bgColor = 0x000000;
	self.nickNameWatermark = nil;
	self.wmHiderInterval = 1; //数字水印嵌入周期,1表示每帧都嵌入

	return self;
}

@end

@implementation XYEditUtils

+ (QVET_RENDER_CONTEXT_TYPE)createDisplayContext:(UIView *)playbackView {
	NSLog(@"createDisplayContext<--");
	QVET_RENDER_CONTEXT_TYPE displayContext = {0};
	//Set display context
	displayContext.hDisplayContext = (__bridge MHandle)playbackView;
	//displayContext.hOSD = MNull;
	displayContext.colorBackground = 0;
	displayContext.rectScreen.top = displayContext.rectClip.top = playbackView.bounds.origin.y * playbackView.contentScaleFactor;
	displayContext.rectScreen.bottom = displayContext.rectClip.bottom = (playbackView.bounds.origin.y * playbackView.contentScaleFactor + playbackView.bounds.size.height * playbackView.contentScaleFactor);
	displayContext.rectScreen.left = displayContext.rectClip.left = playbackView.bounds.origin.x * playbackView.contentScaleFactor;
	displayContext.rectScreen.right = displayContext.rectClip.right = (playbackView.bounds.origin.x * playbackView.contentScaleFactor + playbackView.bounds.size.width * playbackView.contentScaleFactor);
	displayContext.dwRotation = 0;
	displayContext.dwResampleMode = AMVE_RESAMPLE_MODE_UPSCALE_FITIN;
	displayContext.dwRenderTarget = QVET_RENDER_TARGET_SCREEN;
	NSLog(@"createDisplayContext-->");
	return displayContext;
}

+ (CXiaoYingStream *)createStream:(int)sourceType
                         hSession:(MHandle)hSession
                       frameWidth:(int)frameWidth
                      frameHeight:(int)frameHeight
                            dwPos:(MDWord)dwPos
                            dwLen:(MDWord)dwLen
                        dwBGColor:(MDWord)dwBGColor {
	NSLog(@"createStream<--");
	MRESULT res = QVET_ERR_NONE;
	AMVE_STREAM_SOURCE_TYPE stream_source = {0};
	AMVE_STREAM_PARAM_TYPE stream_param = {0};
	CXiaoYingStream *stream = [[CXiaoYingStream alloc] init];
	stream_source.dwType = sourceType;
	stream_source.hData = hSession;
	stream_param.FrameSize.cx = frameWidth;
	stream_param.FrameSize.cy = frameHeight;
	res = [stream Open:&stream_source StreamParam:&stream_param];
	res = [stream SetBGColor:dwBGColor];

	NSLog(@"createStream-->0x%x", res);
	return stream;
}

+ (CXiaoYingStream *)createStreamForExport:(XYExportParam *)exportParam error:(NSError **)error isChinese:(BOOL)isChinese {
	NSLog(@"createStream<--");
	NSString *errorMsg = nil;
	MRESULT res = QVET_ERR_NONE;
	AMVE_STREAM_SOURCE_TYPE stream_source = {0};
	AMVE_STREAM_PARAM_TYPE stream_param = {0};
	CXiaoYingStream *stream = [[CXiaoYingStream alloc] init];
	stream_source.dwType = exportParam.sourceType;
	stream_source.hData = exportParam.hSession;
	stream_param.FrameSize.cx = exportParam.pSrcSize.width;
	stream_param.FrameSize.cy = exportParam.pSrcSize.height;
	stream_param.RenderTargetSize.cx = exportParam.pDstSize.width;
	stream_param.RenderTargetSize.cy = exportParam.pDstSize.height;
	stream_param.dwResampleMode = exportParam.dwResampleMode;
	if (exportParam.wmUserCode) {
		const char *userCode = [exportParam.wmUserCode UTF8String];
		stream_param.WMHiderData.pszWMUserCode = (char *)userCode;
		stream_param.WMHiderData.dwWMHiderInterval = exportParam.wmHiderInterval;
	}

    /*
     设置页里 点三下Dev模式 强制水印开关处理
     */
    NSString *result = [self xy_loadPreference:@"pref_key_common_dev_water_mark_display" defaultValue:PREF_VALUE_NO];
    
    if([result isEqualToString:PREF_VALUE_YES])
    {
        
       MInt64 tempID = [self getWatermarkId:(XYWatermarkTypeNomarl) nickName:exportParam.nickNameWatermark ignoreWatermarkFlag:NO isChinese:isChinese];
        exportParam.llWaterMarkID = tempID;
    }
    
    MHandle hWatermark = MNull;
    MRECT prcDisplay = {
        (MLong)exportParam.watermarkDisplayRect.origin.x,
        (MLong)exportParam.watermarkDisplayRect.origin.y,
        (MLong)exportParam.watermarkDisplayRect.size.width,
        (MLong)exportParam.watermarkDisplayRect.size.height};

    if (exportParam.hSession == NULL) {
        errorMsg = @"hSession is nil";
        res = -1;
        QVET_CHECK_VALID_GOTO(res)
    }
    
    
	MSIZE size = {exportParam.pSrcSize.width, exportParam.pSrcSize.height};
	QVET_Watermark_Create([[XYEngine sharedXYEngine] getCXiaoYingEngine].hSessionContext, exportParam.llWaterMarkID, &prcDisplay, &hWatermark /*out*/, &size);

	if (exportParam.llWaterMarkID != 0 && [NSString xy_isEmpty:exportParam.nickNameWatermark] == NO) {
		NSString *tempNameStr = [NSString stringWithFormat:@"@%@", exportParam.nickNameWatermark];

		MTChar *nameChar = (MTChar *)[tempNameStr UTF8String];

		MDWord nameIndex = 0;
		res = QVET_Watermark_SetTitle(hWatermark, nameIndex, nameChar);
		if (res) {
			errorMsg = [NSString stringWithFormat:@"QVET_Watermark_SetTitle fail res=0x%x", res];
			QVET_CHECK_VALID_GOTO(res)
		}
	}

	stream_param.hWatermark = hWatermark;
	res = [stream Open:&stream_source StreamParam:&stream_param];
	QVET_Watermark_Destroy(hWatermark);
	if (res) {
		errorMsg = [NSString stringWithFormat:@"Open stream fail res=0x%x", res];
		QVET_CHECK_VALID_GOTO(res)
	}

	res = [stream SetBGColor:exportParam.bgColor];
	if (res) {
		errorMsg = [NSString stringWithFormat:@"SetBGColor fail res=0x%x", res];
		QVET_CHECK_VALID_GOTO(res)
	}

FUN_EXIT:
	if (res) {
		NSLog(@"[EditUtil createStreamForExport] %@", errorMsg);
		if (stream) {
			[stream Close];
			stream = nil;
		}
		//记录错误信息
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
		errorMsg = [NSString stringWithFormat:@"Create Stream Fail: %@", errorMsg];
		[userInfo setValue:errorMsg forKey:NSLocalizedFailureReasonErrorKey];
		if (error) {
			*error = [[NSError alloc] initWithDomain:@"kXYEditUtilsErrorDomain" code:res userInfo:userInfo];
		}
	}
	NSLog(@"createStream-->");
	return stream;
}

+ (void)rebuidStream:(CXiaoYingStream *)stream
          sourceType:(int)sourceType
            hSession:(MHandle)hSession
          frameWidth:(int)frameWidth
         frameHeight:(int)frameHeight
               dwPos:(MDWord)dwPos
               dwLen:(MDWord)dwLen {
	NSLog(@"rebuidStream<--");
	MRESULT res = QVET_ERR_NONE;
	AMVE_STREAM_SOURCE_TYPE stream_source = {0};
	AMVE_STREAM_PARAM_TYPE stream_param = {0};
	stream_source.dwType = sourceType;
	stream_source.hData = hSession;
	stream_param.FrameSize.cx = frameWidth;
	stream_param.FrameSize.cy = frameHeight;
	res = [stream Open:&stream_source StreamParam:&stream_param];
	NSLog(@"rebuidStream-->");
	return;
}

+ (AMVE_BUBBLETEXT_SOURCE_TYPE *)allocBubbleSource {
	AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = MNull;
	MDWord dwSize = sizeof(AMVE_BUBBLETEXT_SOURCE_TYPE);

	pBubbleSource = (AMVE_BUBBLETEXT_SOURCE_TYPE *)MMemAlloc(MNull, dwSize);
	if (MNull == pBubbleSource)
		return MNull;
	MMemSet(pBubbleSource, 0, dwSize);
	dwSize = sizeof(MTChar) * (AMVE_MAXPATH + 1);
	pBubbleSource->pszText = (MTChar *)MMemAlloc(MNull, dwSize);
	if (MNull == pBubbleSource->pszText) {
		[self freeBubbleSource:pBubbleSource];
		pBubbleSource = MNull;
		return pBubbleSource;
	}
	MMemSet(pBubbleSource->pszText, 0, dwSize);

	pBubbleSource->pszAuxiliaryFont = (MTChar *)MMemAlloc(MNull, dwSize);
	if (MNull == pBubbleSource->pszAuxiliaryFont) {
		[self freeBubbleSource:pBubbleSource];
		pBubbleSource = MNull;
		return pBubbleSource;
	}
    MMemSet(pBubbleSource->pszAuxiliaryFont, 0, dwSize);
	return pBubbleSource;
}

+ (void)freeBubbleSource:(AMVE_BUBBLETEXT_SOURCE_TYPE *)pBubbleSource {
	if (MNull == pBubbleSource)
		return;
	if (MNull != pBubbleSource->pszText) {
		MMemFree(MNull, pBubbleSource->pszText);
		pBubbleSource->pszText = MNull;
	}
	if (MNull != pBubbleSource->pszAuxiliaryFont) {
		MMemFree(MNull, pBubbleSource->pszAuxiliaryFont);
		pBubbleSource->pszAuxiliaryFont = MNull;
	}
	MMemFree(MNull, pBubbleSource);
	pBubbleSource = MNull;
}

+ (int)ARGB2ABGR:(int)argbValue {
	int r = (argbValue >> 16) & 0xFF;
	int g = (argbValue >> 8) & 0xFF;
	int b = (argbValue)&0xFF;
	int a = (argbValue >> 24) & 0xFF;
	int abgr = a << 24 | b << 16 | g << 8 | r;
	return abgr;
}

+ (int)ABGR2ARGB:(int)abgrValue {
	int b = (abgrValue >> 16) & 0xFF;
	int g = (abgrValue >> 8) & 0xFF;
	int r = (abgrValue)&0xFF;
	int a = (abgrValue >> 24) & 0xFF;
	int argb = a << 24 | r << 16 | g << 8 | b;
	return argb;
}

+ (BOOL)isFileEditable:(NSString *)fileName {
	MTChar *charFileName = (MTChar *)[fileName UTF8String];
	CXiaoYingEngine *cxiaoyingEngine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
	if (!cxiaoyingEngine) {
		return NO;
	}
	MDWord res = [CXiaoYingUtils isFileEditable:cxiaoyingEngine
	                                   FileName:charFileName
	                                       Flag:AMVE_CHECK_AUDIO | AMVE_CHECK_VIDEO | AMVE_CHECK_NO_AUDIO_TRACK];
	switch (res) {
        case AMVE_UNSUPPORT_FILE:
		case AMVE_UNSUPPORT_RESOLUTION:
		case AMVE_UNSUPPORT_VCODEC:
		case AMVE_UNSUPPORT_ACODEC:
		case AMVE_UNSUPPORT_NOVIDEO:
			return NO;
		default:
			return YES;
	}
}

//Original duration to timescaled duration
+ (MDWord)originalDurationToTimeScaledDuration:(MDWord)originalDuration
                                     timeScale:(float)timeScale {
	MDWord duration = originalDuration * timeScale;
	return duration;
}

//Timescaled duration to original duration
+ (MDWord)timeScaledDurationToOriginalDuration:(MDWord)timeScaledDuration
                                     timeScale:(float)timeScale {
	MDWord duration = timeScaledDuration / timeScale;
	return duration;
}

+ (BOOL)isPointInRotatedRect:(MPOINT)mpt
                       angle:(MFloat)angle
                      center:(MPOINT)center
                        rect:(MRECT)rect {
	int xDist = mpt.x - center.x;
	int yDist = mpt.y - center.y;
	float radian = angle * M_PI / 180.0f;
	float cosRad = cosf(radian);
	float sinRad = sinf(radian);
	int tx = (int)(center.x + xDist * cosRad - yDist * sinRad);
	int ty = (int)(center.y + xDist * sinRad + yDist * cosRad);

	BOOL inRect = NO;
	if (tx >= rect.left && tx <= rect.right && ty >= rect.top && ty <= rect.bottom) {
		inRect = YES;
	}

	return inRect;
}

+ (MInt64)getWatermarkId:(XYWatermarkType)watermarkType nickName:(NSString *)nickName ignoreWatermarkFlag:(BOOL)ignoreWatermarkFlag isChinese:(BOOL)isChinese {
    MInt64 llWaterMarkID = 0;
    BOOL isUsedCustomWatermark = [XYCommonEngineGlobalData data].configModel.isUsedCustomWatermark;
         if (ignoreWatermarkFlag) {
               if ([NSString xy_isEmpty:nickName] == NO) {
                   llWaterMarkID = 0x4B00000000000010L;
               }
           } else {
               if ([NSString xy_isEmpty:nickName] == NO) {
                   if (XYWatermarkTypeForUploading == watermarkType) {
                       llWaterMarkID = (isChinese == NO) ? 0x4B0000000000000BL : 0x4B00000000000014L;
                   }else{
                       llWaterMarkID = (isChinese == NO) ? 0x4B0000000000000BL : 0x4B0000000000000AL;
                   }
               }else {
                   llWaterMarkID = (isChinese == NO) ? 0x4B00000000000021L : 0x4B00000000000020L;
               }
           }
           return llWaterMarkID;

}

+ (id)xy_loadPreference:(NSString *)key defaultValue:(id)defaultValue {
    NSString *realKey = key;
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    id value = [saveDefaults valueForKey:realKey];
    if(!value){
        value = defaultValue;
    }
    return value;
}

@end
