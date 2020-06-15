//
//  XYEngine.m
//  XiaoYing
//
//  Created by xuxinyuan on 13-4-26.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//

#import "XYEngine.h"

#define CHECk_VALID_GOTO(x)   \
	if ((x) != QVET_ERR_NONE) \
	goto FUNC_EXIT

@interface XYEngine () <QMonitorLogger>

@property (nonatomic, assign) BOOL metalValue;

@end

@implementation XYEngine

static CXiaoYingEngine *cXiaoYingEngine;

+ (XYEngine *)sharedXYEngine {
	static XYEngine *xyEngine;
	static dispatch_once_t pred;
	dispatch_once(&pred, ^{
	  xyEngine = [[XYEngine alloc] init];
	});
	return xyEngine;
}

- (SInt32)initEngineWithParam:(XYEngineParam *)param
              templateAdapter:(id<CXiaoYingTemplateAdapter>)templateAdapter
              filePathAdapter:(id<CXiaoYingFilePathAdapter>)filePathAdapter
                  metalEnable:(BOOL)metalEnable
{
	if (!param) {
		return QVET_ERR_APP_INVALID_PARAM;
	}
	self.templateDelegate = templateAdapter;
	MRESULT res = QVET_ERR_NONE;
	MBool bMute = MFalse;
	MDWord dwOutputVideoFormat = param.outputVideoFormat;
	MDWord dwOutputAudioFormat = param.outputAudioFormat;
	MDWord dwOutputFileFormat = param.outputFileFormat;
	MDWord dwResampleMode = param.resampleMode;
	MPOINT resolution = {(MLong)param.maxSupportResolution.width, (MLong)param.maxSupportResolution.height};
	MDWord dwTrimType = param.trimType;
	MInt64 defaultBgmId = param.defaultBgmId;

	cXiaoYingEngine = [[CXiaoYingEngine alloc] init];
    NSString *licensePath = param.licensePath;
    MTChar *licensePathTemp = (MTChar*)[licensePath UTF8String];
	res = [cXiaoYingEngine Create:templateAdapter FilePathModifyAdapter:filePathAdapter LicensePath:licensePathTemp];
	//Set property
	res = [cXiaoYingEngine SetProperty:(AMVE_PROP_CONTEXT_DEFAULT_PLAYBACK_MUTE) Value:(&bMute)];
	res = [cXiaoYingEngine SetProperty:(AMVE_PROP_CONTEXT_DEFAULT_OUTPUT_VIDEO_FORMAT) Value:(&dwOutputVideoFormat)];
	res = [cXiaoYingEngine SetProperty:(AMVE_PROP_CONTEXT_DEFAULT_OUTPUT_AUDIO_FORMAT) Value:(&dwOutputAudioFormat)];
	res = [cXiaoYingEngine SetProperty:AMVE_PROP_CONTEXT_DEFAULT_OUTPUT_FILE_FORMAT Value:&dwOutputFileFormat];
	res = [cXiaoYingEngine SetProperty:AMVE_PROP_CONTEXT_DEFAULT_RESAMPLE_MODE Value:&dwResampleMode];
	//Set template path,need to implement
	//Set template adapter,need to implement
	res = [cXiaoYingEngine SetProperty:AMVE_PROP_CONTEXT_MAX_SUPPORT_RESOLUTION Value:&resolution];
	res = [cXiaoYingEngine SetProperty:AMVE_PROP_CONTEXT_DEFAULT_TRIM_TYPE Value:&dwTrimType];
	res = [cXiaoYingEngine SetProperty:AMVE_PROP_CONTEXT_THEME_DEFAULT_MUSIC_TEMPLATE_ID Value:&defaultBgmId];
	if (param.tempFolderPath) {
		res = [cXiaoYingEngine SetProperty:AMVE_PROP_CONTEXT_TEMP_PATH Value:(MTChar *)[param.tempFolderPath UTF8String]];
	}
	if (param.corruptImagePath) {
		res = [cXiaoYingEngine SetProperty:AMVE_PROP_CONTEXT_DEF_IMG_FILE Value:(MTChar *)[param.corruptImagePath UTF8String]];
	}

    self.metalValue = metalEnable;
    
	if(metalEnable)
    {
		MDWord renderApi = QVET_RENDER_API_Metal10;
		res = [cXiaoYingEngine SetProperty:AMVE_PROP_CONTEXT_RENDER_API Value:&renderApi];
	}

//#ifdef DEBUG
    [self createEngineLogMonitor];
//#endif
    
	return res;
}

- (CXiaoYingEngine *)getCXiaoYingEngine {
	return cXiaoYingEngine;
}

- (void)uninit {
	if (cXiaoYingEngine) {
		[cXiaoYingEngine Destory];
	}
}

- (UInt32)getVersion {
	UInt32 version = 0;
	if (cXiaoYingEngine) {
		version = [cXiaoYingEngine GetVersion];
	}
	return version;
}

- (void)setTextTransformer:(id<CXiaoyingTextTransformer>)textTransformer {
	MRESULT res = [cXiaoYingEngine SetProperty:AMVE_PROP_CONTEXT_TEXT_TRANSFORMER Value:(MVoid *)textTransformer];
	if (res) {
		NSLog(@"[ENGINE]set text transformer error: 0x%x", res);
	}
}

- (void)setFontAdapter:(id<CXiaoYingFontAdapter>)fontAdapter {
	MRESULT res = [cXiaoYingEngine SetProperty:AMVE_PROP_CONTEXT_FONT_FINDER Value:(MVoid *)fontAdapter];
	if (res) {
		NSLog(@"[ENGINE]set fontAdapter error: 0x%x", res);
	}
}

- (BOOL)getMetalEnable
{
    return self.metalValue;
}

- (void)createEngineLogMonitor {
    [QMonitorFactory createInstance];
    id<IMonitorMethod> monitor = [QMonitorFactory getInstance];
    MDWord dwLogLevel = MON_LOG_LEVLE_T|MON_LOG_LEVLE_E; //LOG_LEVEL_ALL是所有等级都打开，上线时是打开Trace.
#ifdef DEBUG
    dwLogLevel = MON_LOG_LEVLE_E|MON_LOG_LEVLE_T;
#endif
    
    [monitor setProp:QMON_PROP_LOG_LEVEL propData:(MVoid*)&dwLogLevel];
    MBool bExternal = MTrue;
    [monitor setProp:QMON_PROP_USE_EXTERNAL_LOGGGER propData:(MVoid*)&bExternal];
    MInt64 llLogModule = MON_MODULE_ALL;
    [monitor setProp:QMON_PROP_SET_MODULE propData:(MVoid*)&llLogModule];
    [monitor setProp:QMON_PROP_EXTERNAL_LOGGER propData:(MVoid*)self];
}

- (void)printLog:(NSString*)log {
    [self uploadPrintLog:log];
    NSLog(@"【EngineLog】%@",log);
}

- (void)traceLog:(NSString*)log {
    [self uploadTarceLog:log];
    
}

- (void)uploadTarceLog:(NSString *)log {
    if ([self.engineLogDelegate respondsToSelector:@selector(xYEngineLog:)]) {
        [self.engineLogDelegate xYEngineTarceLog:log];
    }
}

- (void)uploadPrintLog:(NSString *)log {
    if ([self.engineLogDelegate respondsToSelector:@selector(xYEnginePrintLog:)]) {
        [self.engineLogDelegate xYEnginePrintLog:log];
    }
}

@end
