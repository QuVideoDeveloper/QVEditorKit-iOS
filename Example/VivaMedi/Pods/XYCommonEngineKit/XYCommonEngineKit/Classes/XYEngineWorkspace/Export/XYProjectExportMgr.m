//
//  XYProjectExportMgr.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/14.
//

#import "XYProjectExportMgr.h"
#import "XYEditUtils.h"
#import "XYBaseEffectTaskVision.h"
#import <XYCategory/XYCategory.h>
#import "XYCommonEngineKit.h"
#include <sys/mount.h>
#import "XYStoryboard+XYClip.h"
#import "XYCommonEngineTaskMgr.h"
#import "XYAutoEditMgr.h"
#import "XYStoryboardUtility.h"

static const NSInteger Max_Exp_FPS = 60;

#define QVET_ERR_APP_BACKGROUND             (QVET_ERR_APP_BASE + 0x20)

@interface XYProjectExportMgr()<AMVESessionStateDelegate>

@property (nonatomic, strong) CXiaoYingProducerSession *producer;
@property (nonatomic, assign) XYProjectExportResultType exportState;
@property (nonatomic, copy) export_success_block exportSuccessBlock;
@property (nonatomic, copy) export_failure_block exportFailureBlock;
@property (nonatomic, copy) export_progress_block progressBlock;
@property (nonatomic) unsigned long long exportStartTime;
@property (nonatomic, copy) NSString *currentExportingFilePath;
@property (nonatomic, strong) NSMutableDictionary *exportAttribute;
@property (nonatomic, strong) XYProjectExportConfiguration *currentProjectExportConfig;
@property (nonatomic) CGFloat exportProgress;
@property (nonatomic, strong) XYStoryboard *storyboard;
@end

@implementation XYProjectExportMgr

+ (XYProjectExportMgr *)sharedInstance
{
    static XYProjectExportMgr *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[XYProjectExportMgr alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if(self = [super init]){
        UIApplication *app = [UIApplication sharedApplication];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:app];
    }
    
    return self;
}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    if (!self.producer) {
        return;
    }
        
    NSLog(@"######Cancel Export");
    //After we called cancel export, We need to uninit produce when recieving the stopped callback from engine.
    MRESULT res = [self.producer Cancle];
    self.exportState = XYProjectExportResultTypeDidEnterBackgroundStop;
}

#pragma mark - public methods
- (void)cancel
{
    self.exportState = XYProjectExportResultTypeCancel;
    if (!self.producer) {
        return;
    }
        
    NSLog(@"######Cancel Export");
    //After we called cancel export, We need to uninit produce when recieving the stopped callback from engine.
    MRESULT res = [self.producer Cancle];
}


- (BOOL)isHaveEnoughDiskToExportWithConfig:(XYProjectExportConfiguration *)config {
    MDWord duration = [self.storyboard getDuration];
    //判断剩余空间是否足够
    CXiaoYingStoryBoardSession *cXiaoYingStoryBoardSession = [self.storyboard getStoryboardSession];
    MDWord dwAveFPS = (config.fps > 0)?config.fps:[CXiaoYingUtils GetStoryboardMaxFps:cXiaoYingStoryBoardSession MaxExpFPS:Max_Exp_FPS];
    MDWord bitrateFps = dwAveFPS;
    if (config.isGIF) {
        bitrateFps = config.fps / 1000;
    }
    
    //获取最终导出的尺寸
    CGSize exportDstSize = CGSizeZero;
    BOOL isHD = config.customLimitSize.width >= 720 && config.customLimitSize.height >= 720;
    if(isHD){
        exportDstSize = [self.storyboard getHDExportSize];
    }else{
        exportDstSize = [self.storyboard getExportSize];
    }
    if(config.customLimitSize.width != 0 && config.customLimitSize.height != 0){
        exportDstSize = CGSizeMake(config.customLimitSize.width,config.customLimitSize.height);
    }
    
    
    MDWord dwBitrate = [self calculateBitrate:bitrateFps width:exportDstSize.width height:exportDstSize.height];
    dwBitrate = dwBitrate * config.bitRate;//将引擎计算出来的Bitrate乘以系数bitrateRatio
    unsigned int length =  (unsigned int)(dwBitrate/8*(duration/1000));
    return [self isDiskSpaceEnoughForExporting:length];
}

- (void)exportWithConfig:(XYProjectExportConfiguration *)config
                   start:(export_start_block)start
                progress:(export_progress_block)progress
                 success:(export_success_block)success
                 failure:(export_failure_block)failure;
{
    if (0 == config.customLimitSize.width && 0 == config.customLimitSize.height) {
            CGFloat width = 480;
        switch (config.expType) {
            case XYEngineExportType480:
                width = 480;
                break;
            case XYEngineExportType720:
                width = 720;
                break;
            case XYEngineExportType1080:
                width = 1080;
                break;
            case XYEngineExportType4k:
                width = AMVE_VIDEO_4K_HEIGHT;
                break;
            default:
                break;
        }
        CGSize exportVideoSize = [[XYStoryboard sharedXYStoryboard] getHDRecommededExportSizeFromMinimumWidth:width];
        config.customLimitSize = exportVideoSize;
    } else {
        CGSize exportSize = [[XYStoryboard sharedXYStoryboard] getHDRecommededExportSizeFromMinimumWidth:config.customLimitSize.width];
        config.customLimitSize = exportSize;
    }
    
    
    [[XYCommonEngineTaskMgr task] postTaskHandle:^{
        self.currentProjectExportConfig = config;
        if (config.storyboard) {
            self.storyboard = config.storyboard;
        } else {
            [self.storyboard setStoryboardSession:[[XYStoryboard sharedXYStoryboard] duplicate]];
        }
        self.progressBlock = progress;
        self.exportSuccessBlock = success;
        self.exportFailureBlock = failure;
        NSAssert(config, @"必须要传入Config参数");
        if (XYProjectExportResultTypeIsExporting == self.exportState && failure) {//上一次导出尚未完成的话，不做处理
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(XYProjectExportResultTypeIsExporting, NSNotFound);
            });
            return;
        }
        
        if (XYProjectTypeSlideShow == config.projectType) {
            MPOINT outPutResolution = {0,0};
            outPutResolution.x = (MLong)config.customLimitSize.width;
            outPutResolution.y = (MLong)config.customLimitSize.height;
            [[XYAutoEditMgr sharedInstance] setSlideShowSessionSceneResolution:&outPutResolution];
            if (!config.isGIF) {
                [self.storyboard setStoryboardSession:[[XYAutoEditMgr sharedInstance] duplicateStoryboard]];
            }
        }
        //初始化部分导出相关变量
        MRESULT res = MERR_NONE;
        NSString *errorMsg = nil;
        self.progressBlock = progress;
        self.exportProgress = 0;
        self.exportStartTime = [[NSDate date] timeIntervalSince1970]*1000;
        NSString *pathExtension = [config.exportingFilePath pathExtension];
        NSAssert(pathExtension, @"路径必须有后缀");
        if (!pathExtension) {//TODO:路径必须有后缀"
            return;
        }
        self.currentExportingFilePath = config.exportingFilePath;
        
        //获取最终导出的尺寸
        CGSize exportDstSize = CGSizeZero;
        BOOL isHD = config.customLimitSize.width >= 720 && config.customLimitSize.height >= 720;
        if(isHD){
            exportDstSize = [self.storyboard getHDExportSize];
        }else{
            exportDstSize = [self.storyboard getExportSize];
        }
        if(config.customLimitSize.width != 0 && config.customLimitSize.height != 0){
            exportDstSize = CGSizeMake(config.customLimitSize.width,config.customLimitSize.height);
        }
        
        MDWord duration = [self.storyboard getDuration];
        if (config.trimRange && 0 != config.trimRange.dwLen) {
            duration = config.trimRange.dwLen;
        }
        //更新自定义片尾字幕
        [self updateCustomCoverBackSubtitle:YES];
        
        //确保Storyboard所有Layer效果可见
        [XYStoryboardUtility showLayer:-1 IsShown:MTrue storyboard:self.storyboard];
        
        //导出前需要先把Storyboard resolution设到高清，再创建stream，创建完再将Storyboard resolution设回去
        MPOINT originalOutPutResolution = {0};
        [self.storyboard getOutputResolution:&originalOutPutResolution];
        MPOINT hdOutPutResolution = {(MLong)exportDstSize.width,(MLong)exportDstSize.height};
        [self.storyboard setOutputResolution:&hdOutPutResolution];//OutPutResolution must be HD too!!!
        MHandle hSession = [self.storyboard getStoryboardHSession];
        XYExportParam *exportParam = [self createExportParam:config hSession:hSession exportDstSize:exportDstSize];
        NSError *createStreamError;
        CXiaoYingStream *stream = [XYEditUtils createStreamForExport:exportParam error:&createStreamError isChinese:[self isInChina]];
        if(isHD && originalOutPutResolution.x > 0 && originalOutPutResolution.y > 0){
            [self.storyboard setOutputResolution:&originalOutPutResolution];
        }
        
        CXiaoYingStoryBoardSession *cXiaoYingStoryBoardSession = [self.storyboard getStoryboardSession];
        MDWord dwAveFPS = (config.fps > 0)?config.fps:[CXiaoYingUtils GetStoryboardMaxFps:cXiaoYingStoryBoardSession MaxExpFPS:Max_Exp_FPS];
        MDWord bitrateFps = dwAveFPS;
        if (config.isGIF) {
            bitrateFps = config.fps / 1000;
        }
        MDWord dwBitrate = [self calculateBitrate:bitrateFps width:exportDstSize.width height:exportDstSize.height];
        //防止配的系数太大或太小
        if (config.bitRate > 10.0) {
            config.bitRate = 1.0;
        }
        
        if (config.bitRate < 0.1) {
            config.bitRate = 1.0;
        }
        
        dwBitrate = dwBitrate * config.bitRate;//将引擎计算出来的Bitrate乘以系数bitrateRatio
        
        unsigned int length =  (unsigned int)(dwBitrate/8*(duration/1000));
        if(![self isDiskSpaceEnoughForExporting:length]) {
            errorMsg = @"DiskSpaceNotEnough";
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(XYProjectExportResultTypeIsNotEnoughDiskStop, QVET_ERR_COMMON_EXPORT_SIZE_EXCEEDED);
            });
            [self reSetData];
        }
        
        //判断创建Stream是否成功
        if (createStreamError) {
            errorMsg = [createStreamError localizedFailureReason];
            res = -1;
            QVET_CHECK_VALID_GOTO(res);
        }
        
        //判断是否在后台
        if ([XYStoryboard sharedXYStoryboard].isInBackground) {
            errorMsg = @"IsInBackgroundBeforeExporting";
            res = QVET_ERR_APP_BACKGROUND;
            QVET_CHECK_VALID_GOTO(res);
        }
        
        //判断stream是否为空
        if (!stream) {
            errorMsg = @"Stream is nil";
            res = -1;
            QVET_CHECK_VALID_GOTO(res);
        }
        
        //分配Producer内存空间
        if(!_producer){
            _producer = [[CXiaoYingProducerSession alloc] init];
        }
        
        //设置Gif参数，需要在producer Init之前
        MBool mIsGIF = config.isGIF?MTrue:MFalse;
        res = [self.producer setProperty:AMVE_PROP_PRODUCER_USE_GIF_ENCODER Value:&mIsGIF];
        if (res) {
            errorMsg = [NSString stringWithFormat:@"Set gif encoder fail: 0x%x",res];
            QVET_CHECK_VALID_GOTO(res);
        }
        //Producer Init
        res = [self.producer Init :[[XYEngine sharedXYEngine] getCXiaoYingEngine] SessionStateHandler:self];
        if (res) {
            errorMsg = [NSString stringWithFormat:@"Producer init fail: 0x%x",res];
            QVET_CHECK_VALID_GOTO(res);
        }
        
        if (self.currentProjectExportConfig.isAudio) {
            AMVE_MEDIA_SOURCE_TYPE mediaSource = {0};
            mediaSource.pSource = MMemAlloc(MNull,AMVE_MAXPATH);
            CXiaoYingClip *pClip = [self.storyboard getClipByIndex:0];
            [pClip getProperty:AMVE_PROP_CLIP_SOURCE PropertyData:&mediaSource];
            [self.producer setProperty:AMVE_PROP_PRODUCER_USE_INPUT_FILE_NAME Value:mediaSource.pSource];
            MMemFree(MNull, mediaSource.pSource);
        }
        
        //设置producer param
        const char *cfilename = [_currentExportingFilePath UTF8String];
        AMVE_POSITION_RANGE_TYPE trimRange = {config.trimRange.dwPos, config.trimRange.dwLen};
        AMVE_PRODUCER_PARAM_TYPE param = [self createAMVEParam:dwBitrate aveFPS:dwAveFPS CFileName:cfilename trimRange:trimRange isGIF:config.isGIF isAudio:config.isAudio];
        res = [self.producer setProperty:AMVE_PROP_PRODUCER_PARAM Value:&param];
        if (res) {
            errorMsg = [NSString stringWithFormat:@"Producer setProperty AMVE_PROP_PRODUCER_PARAM fail: 0x%x",res];
            QVET_CHECK_VALID_GOTO(res);
        }
        
        //ActiveStream
        res = [self.producer ActiveStream:stream];
        if (res) {
            errorMsg = [NSString stringWithFormat:@"Producer ActiveStream fail: 0x%x",res];
            QVET_CHECK_VALID_GOTO(res);
        }
        
        //Start producer
        res = [self.producer Start];
        if (res) {
            errorMsg = [NSString stringWithFormat:@"Producer Start fail: 0x%x",res];
            QVET_CHECK_VALID_GOTO(res);
        }
        if (start) {
            start();
        }
        //真正开始导出后，确保设备不会自动锁屏
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            
        });
        self.exportState = XYProjectExportResultTypeIsExporting;
        return;
        
    FUN_EXIT: {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.exportFailureBlock) {
                self.exportFailureBlock(XYProjectExportResultTypeFailed, res);
            }
        });
        
        [self reSetData];
    }
    }];
}

- (void)reSetData {
    self.exportState = XYProjectExportResultTypeNormal;
    self.exportFailureBlock = nil;
    self.progressBlock = nil;
    self.exportSuccessBlock = nil;
}

#pragma mark - AMVESessionStateDelegate
- (MDWord)AMVESessionStateCallBack:(AMVE_CBDATA_TYPE *)pCBData
{
    BOOL isComplete = NO;
    
    if (pCBData->dwCurTime == pCBData->dwDuration) {
        [self updateCustomCoverBackSubtitle:NO];
        isComplete = YES;
    }
    
    if (pCBData->dwStatus == AMVE_PROCESS_STATUS_STOPPED){
        [self updateCustomCoverBackSubtitle:NO];
        NSMutableDictionary *errDict = [NSMutableDictionary new];
        NSString * userData = nil;
        
        if (pCBData->pszUserData != MNull) {
            userData = [NSString stringWithUTF8String:pCBData->pszUserData];
            [errDict setValue:userData forKey:@"userData"];
        }
        
        BOOL isSuccess = NO;
        
        if (pCBData->dwErrorCode == 0 &&
            pCBData->dwAudioErr == 0 &&
            pCBData->dwVDecErr == 0 &&
            pCBData->dwVEncErr == 0 ) {
            if ([NSFileManager xy_fileExist:_currentExportingFilePath]) {
                isSuccess = YES;
            }else {
                isSuccess = NO;
            }
        }
        
        if(isComplete && isSuccess){//Export Stopped and Completed
            //copy to camera roll
            dispatch_async(dispatch_get_main_queue(), ^{
//                XYServiceIMP(editorService, XYVivaEditorModuleService);
//                [editorService deleteWatermarkInfoFromStoryBoard];
                if (XYProjectTypeSlideShow == self.currentProjectExportConfig.projectType) {
                    [self exportSussForQslideshowWithErrDict:errDict];
                }else{
                    [self exportSussWithErrDict:errDict];
                }
            });
        }else{//Export Stopped and canceled
            if (XYProjectExportResultTypeNormal != self.exportState) {
                [self uninitProducer:0 movieLocal:_currentExportingFilePath assetURL:nil errDict:errDict];
            }else{
                NSString *mainErr = [NSString stringWithFormat:@"0x%x",pCBData->dwErrorCode];
                NSString *audioErr = [NSString stringWithFormat:@"0x%x",pCBData->dwAudioErr];
                NSString *vdecErr = [NSString stringWithFormat:@"0x%x",pCBData->dwVDecErr];
                NSString *vencErr = [NSString stringWithFormat:@"0x%x",pCBData->dwVEncErr];
                
                [errDict setValue:mainErr forKey:@"mainErr"];
                [errDict setValue:audioErr forKey:@"audioErr"];
                [errDict setValue:vdecErr forKey:@"vdecErr"];
                [errDict setValue:vencErr forKey:@"vencErr"];
    
                MDWord errorCode = pCBData->dwErrorCode;
                [self uninitProducer:errorCode movieLocal:_currentExportingFilePath assetURL:nil errDict:errDict];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    XYServiceIMP(editorService, XYVivaEditorModuleService);
//                    [editorService deleteWatermarkInfoFromStoryBoard];
                });
            }
        }
    }else{//Exporting
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.progressBlock) {
                self.progressBlock(pCBData->dwCurTime, pCBData->dwDuration);
            }

        });
    }
    
    return 0;
}

- (void)exportSussWithErrDict:(NSMutableDictionary *)errDict{
    [self uninitProducer:0 movieLocal:_currentExportingFilePath assetURL:nil errDict:errDict];
}


- (void)exportSussForQslideshowWithErrDict:(NSMutableDictionary *)errDict {
    [self uninitProducer:0 movieLocal:_currentExportingFilePath assetURL:nil errDict:errDict];
}


#pragma mark - private methods

- (void)uninitProducer:(MDWord)errorCode movieLocal:(NSString *)movieLocal assetURL:(NSURL *)assetURL errDict:(NSDictionary *)errDict
{
    NSLog(@"######UnInit producer");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.producer DeActiveStream];
        [self.producer UnInit];
        self.producer = nil;
        if (XYProjectExportResultTypeNormal == self.exportState){
            [NSFileManager xy_deleteFileWithPath:_currentExportingFilePath];
            if (self.exportFailureBlock) {
                self.exportFailureBlock(self.exportState, NSNotFound);
            }
            [self reSetData];
            return;
        }
        
        BOOL isGIF = NO;
        if ([movieLocal hasSuffix:@"GIF"]) {
            isGIF = YES;
        }
        NSString *errorMsg = [self getExportErrorMsgWithErrCode:errorCode andErrDict:errDict isGIF:isGIF];
        
        if (errorMsg) {//Export fail
            if (self.exportFailureBlock) {
                self.exportFailureBlock(XYProjectExportResultTypeFailed, errorCode);
            }
        }else{//Export Success
            if (self.exportSuccessBlock) {
                self.exportSuccessBlock();
            }
        }
        [self reSetData];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//必须在主线程调用
    });
}

- (AMVE_PRODUCER_PARAM_TYPE)createAMVEParam:(MDWord)dwBitrate
                                     aveFPS:(MDWord)dwAveFPS
                                  CFileName:(const char *)cfilename
                                  trimRange:(AMVE_POSITION_RANGE_TYPE)trimRange
                                      isGIF:(BOOL)isGIF
                                    isAudio:(BOOL)isAudio
{
    AMVE_PRODUCER_PARAM_TYPE param = {0};
    if (isGIF) {
        param.dwAudioFormat = AMVE_AUDIOFORMAT_AACLC;
        param.dwVideoFormat = AMVE_VIDEOFORMAT_GIF;
        param.dwFileFormat = AMVE_FILEFORMAT_GIF;
    }else {
        param.dwAudioFormat = AMVE_AUDIOFORMAT_AACLC;
        param.dwVideoFormat = isAudio ? AMVE_VIDEOFORMAT_NONE : AMVE_VIDEOFORMAT_H264;
        param.dwFileFormat = isAudio ? AMVE_FILEFORMAT_M4A : AMVE_FILEFORMAT_MP4;
    }
    
    MInt64 llMaxFileSize = [self freeDiskSpaceInBytes]/2;
    param.llMaxFileSize = llMaxFileSize;
    param.dwVideoBitrate = dwBitrate;
    param.dwVideoFrameRate = dwAveFPS;
    param.pszDestFile = (char*)cfilename;
    param.dwEncoderType = AMVE_ENCODER_TYPE_AUTO;
    param.range = trimRange;
    param.dwProfile = AMVE_H264_PROFILE_HIGH;
    param.dwLevel = AMVE_H264_LEVEL_UNKNOW;
    param.dwMaxExpFPS = Max_Exp_FPS * 1000;
    return param;
}

- (XYExportParam *)createExportParam:(XYProjectExportConfiguration*)config hSession:(MHandle) hSession exportDstSize:(CGSize)exportDstSize
{
    BOOL isInChina = [self isInChina];
    XYExportParam *exportParam = [[XYExportParam alloc] initWithDefaultParams:isInChina];
    exportParam.hSession = hSession;
    exportParam.pSrcSize = exportDstSize;
    exportParam.pDstSize = exportDstSize;
    exportParam.sourceType = AMVE_STREAM_SOURCE_TYPE_STORYBOARD;
    exportParam.dwResampleMode = AMVE_RESAMPLE_MODE_UPSCALE_FITIN;
    exportParam.dwPos = 0;
    exportParam.dwLen = -1;
    exportParam.ignoreWatermarkFlag = config.hideWatermark;
    exportParam.watermarkDisplayRect = config.watermarkDisplayRect;
    exportParam.bgColor = config.bgColor;
    exportParam.nickNameWatermark = config.nickNameWatermark;
    exportParam.llWaterMarkID = config.llWaterMarkID;
    return exportParam;
}

- (MDWord)calculateBitrate:(MDWord)dwFPS
                     width:(MDWord)dwWidth
                    height:(MDWord)dwHeight
{
    MDWord dwBitrate = [CXiaoYingUtils CaculateVideoBitrate:dwFPS
                                                      Width:dwWidth
                                                     Height:dwHeight
                                                    Profile:AMVE_H264_PROFILE_HIGH
                                                BitrateMode:AMVE_VIDEO_ENC_BITRATE_MODE_LOW];
    return dwBitrate;
}

- (NSString *)getExportErrorMsgWithErrCode:(MDWord)errorCode andErrDict:(NSDictionary *)errDict isGIF:(BOOL)isGIF {
    NSString *errorMsg = @"";
    
    if (errDict != nil) {
        NSString *mainErr = [errDict valueForKey:@"mainErr"];
        NSString *audioErr = [errDict valueForKey:@"audioErr"];
        NSString *vdecErr = [errDict valueForKey:@"vdecErr"];
        NSString *vencErr = [errDict valueForKey:@"vencErr"];
        
        BOOL hasMainErr = mainErr && ![mainErr isEqualToString:@"0x0"];
        BOOL hasAudioErr = audioErr && ![audioErr isEqualToString:@"0x0"];
        BOOL hasVdecErr = vdecErr && ![vdecErr isEqualToString:@"0x0"];
        BOOL hasVencErr = vencErr && ![vencErr isEqualToString:@"0x0"];
        
        BOOL hasEngineError = hasMainErr || hasAudioErr || hasVdecErr || hasVencErr;
        
        if (hasEngineError) {
            if (hasMainErr) {
                errorMsg = [errorMsg stringByAppendingString:@"_mainErr="];
                errorMsg = [errorMsg stringByAppendingString:mainErr];
            }
            if (hasAudioErr) {
                errorMsg = [errorMsg stringByAppendingString:@"_audioErr="];
                errorMsg = [errorMsg stringByAppendingString:audioErr];
            }
            if (hasVdecErr) {
                errorMsg = [errorMsg stringByAppendingString:@"_vdecErr="];
                errorMsg = [errorMsg stringByAppendingString:vdecErr];
            }
            if (hasVencErr) {
                errorMsg = [errorMsg stringByAppendingString:@"_vencErr="];
                errorMsg = [errorMsg stringByAppendingString:vencErr];
            }
            return errorMsg;
        }
    }
    
    if ([errorMsg isEqualToString:@""] && isGIF) {
        return nil;
    }
    
    
    AMVE_VIDEO_INFO_TYPE videoInfo = {0};
    MRESULT res = [CXiaoYingUtils getVideoInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine] FilePath:(MTChar *)[self.currentExportingFilePath UTF8String] VideoInfo:&videoInfo];
    BOOL isGetVideoInfoOK = (res == MERR_NONE);
    BOOL isFileSizeOK = videoInfo.dwFileSize > 0;
    BOOL isWidthOK, isHeightOK, isVideoDurationOK;
    
    if (self.currentProjectExportConfig.isAudio) {
        isWidthOK = YES;
        isHeightOK = YES;
        isVideoDurationOK = YES;
    } else {
        isWidthOK = videoInfo.dwFrameWidth > 0;
        isHeightOK = videoInfo.dwFrameHeight > 0;
        isVideoDurationOK = videoInfo.dwVideoDuration > 0;
    }
    
    BOOL isFileExist = [NSFileManager xy_fileExist:self.currentExportingFilePath];
    
    BOOL isCorrectVideoFile = isGetVideoInfoOK && isWidthOK && isHeightOK && isFileSizeOK && isVideoDurationOK && isFileExist;
    
    
    if (!isCorrectVideoFile) {
        if (!isFileExist) {
            errorMsg = [errorMsg stringByAppendingString:@"_videoFileNotExist"];
        }else if (!isGetVideoInfoOK) {
            errorMsg = [errorMsg stringByAppendingString:@"_videoInfoError"];
        }else{
            if (!isWidthOK || !isHeightOK) {
                errorMsg = [errorMsg stringByAppendingString:@"_videoFrameSizeError"];
            }
            if (!isFileSizeOK) {
                errorMsg = [errorMsg stringByAppendingString:@"_fileSizeError"];
            }
            if (!isVideoDurationOK) {
                errorMsg = [errorMsg stringByAppendingString:@"_videoDurationError"];
            }
        }
        return errorMsg;
    }
    
    return nil;
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:dateString];
    return fromdate;
}

- (void)updateCustomCoverBackSubtitle:(BOOL)isHidden {
    //更新自定义片尾字幕
    NSInteger clipCount = [self.storyboard getClipCount];
    CXiaoYingClip *lastClip = [self.storyboard getClipByIndex:clipCount - 1];
    if ([[self.storyboard getClipIdentifier:lastClip] isEqualToString:XY_CUSTOM_COVER_BACK_IDENTIFIER]) {
        NSInteger visionTextCount = [lastClip getEffectCount:XYCommonEngineTrackTypeVideo GroupID:XYCommonEngineGroupIDText];
        for (int i = 0; i < visionTextCount; i ++) {
            XYEffectVisionTextModel *textModel = [[XYEffectVisionTextModel alloc] init];
            textModel.storyboard = self.storyboard;
            textModel.pEffect = [lastClip getEffect:XYCommonEngineTrackTypeVideo GroupID:XYCommonEngineGroupIDText EffectIndex:i];
            textModel.groupID = XYCommonEngineGroupIDText;
            [textModel reload];
            XYBaseEffectTaskVision *visionTask = [[XYBaseEffectTaskVision alloc] init];
            visionTask.storyboard = self.storyboard;
            NSInteger textHeight = textModel.height;
            NSString *text = textModel.multiTextList.count > 0 ? textModel.multiTextList[0].text : @"";
            if (!textModel.pEffect || ![text isEqualToString:NSLocalizedString(@"xiaoying_str_help_ve_tap_the_text_to_modify", nil)]) {
                return;
            }
            
            TextInfo *currentTextInfo = [self.storyboard getStoryboardTextInfo:textModel.pEffect viewFrame:[XYCommonEngineGlobalData data].playbackViewFrame];
            if (isHidden) {
                textModel.destVeRange.dwLen = 0;
            } else {
                textModel.destVeRange.dwLen = 3000;
            }
            [self.storyboard setEffectRange:textModel.pEffect startPos:textModel.destVeRange.dwPos duration:textModel.destVeRange.dwLen];
        }
    }
}

- (void)xYEngineTarceLog:(NSString *)log {
    if (![NSString xy_isEmpty:log]) {
    }
}

- (void)xYEnginePrintLog:(NSString *)log {
    if (![NSString xy_isEmpty:log]) {
    }
}

- (void)xYEventLog:(NSString *)eventId attributes:(NSDictionary *)attributes {
    
}

- (BOOL)isDiskSpaceEnoughForExporting:(unsigned int)fileSize {
    long long dwMaxFileSize = [self freeDiskSpaceInBytes]/2;
    return (dwMaxFileSize < fileSize)? NO:YES;
}

- (long long)freeDiskSpaceInBytes {
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bavail);
        freespace -= 240 * 1024 * 1024;
        freespace = (freespace<0)?0:freespace;
    }
    NSString *strFreeSpace = [NSString stringWithFormat:@"手机剩余存储空间为：%qi MB" ,freespace/1024/1024];
    NSLog(@"%@",strFreeSpace);
    return freespace;
}

- (BOOL)isInChina {
    NSString *langCode = [[XYStoryboard sharedXYStoryboard] fetchLanguageCode];
    langCode = [langCode lowercaseString];
    return [langCode hasPrefix:@"zh"];
}


- (XYStoryboard *)storyboard {
    if (!_storyboard) {
        _storyboard = [[XYStoryboard alloc] init];
        [_storyboard initAll];
        [_storyboard initXYStoryBoard];
    }
    return _storyboard;
}

- (void)reverseWithFilePath:(NSString *)filePath
             exportFilePath:(NSString *)exportFilePath
                   progress:(export_progress_block)progress
                    success:(export_success_block)success
                    failure:(export_failure_block)failure

{
      if (XYProjectExportResultTypeIsExporting == self.exportState && failure) {//上一次导出尚未完成的话，不做处理
        failure(XYProjectExportResultTypeIsExporting, NSNotFound);
        return;
    }
    self.progressBlock = progress;
    self.exportSuccessBlock = success;
    self.exportFailureBlock = failure;
    self.currentExportingFilePath = exportFilePath;
    MDWord rangeLen = 30000;
    CXiaoYingClip *clip = [[XYStoryboard sharedXYStoryboard] createClip:filePath srcRangeLen:rangeLen];
    
    if(![self isClipSupportReverse:clip]){
        failure(6, NSNotFound);
        return;
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    
    const char *cfilename = [self.currentExportingFilePath UTF8String];
    
    if(!self.producer){
        self.producer = [[CXiaoYingProducerSession alloc] init];
    }
    
    MBool value = MTrue;
    [self.producer setProperty:AMVE_PROP_PRODUCER_REVERSE Value:&value];
    //Convert time scaled source range to original range
    AMVE_POSITION_RANGE_TYPE sourceRange = [[XYStoryboard sharedXYStoryboard] getClipSourceRangeByClip:clip];
    
    [[XYStoryboard sharedXYStoryboard] setClipSourceRangeByClip:clip startPos:sourceRange.dwPos endPos:sourceRange.dwPos + sourceRange.dwLen];
    [[XYStoryboard sharedXYStoryboard] setClipTrimRangeByClip:clip startPos:0 endPos:sourceRange.dwLen];
    MHandle hSession = clip.hClip;
    AMVE_VIDEO_INFO_TYPE sourceinfo = {0};
    [clip getProperty:AMVE_PROP_CLIP_SOURCE_INFO PropertyData:&sourceinfo];
    MDWord dwAveFPS = sourceinfo.dwVideoFrameRate;
    
    MFloat k = 384000.0*1.3/(320.0*240.0*30.0);
    CXiaoYingStream *stream = nil;
    
    CGSize cgExportDstSize;
    
    if([[XYStoryboard sharedXYStoryboard] isHDClip:clip]){
        cgExportDstSize = [[XYStoryboard sharedXYStoryboard] getHDExportSize];
    }else{
        cgExportDstSize = [[XYStoryboard sharedXYStoryboard] getExportSize];
    }
    MRESULT res = MERR_NONE;

    if(res){
        return;
    }
    
    XYExportParam *exportParam = [[XYExportParam alloc] initWithDefaultParams:YES];
    exportParam.hSession = hSession;
    exportParam.pSrcSize = CGSizeMake(0, 0);
    exportParam.pDstSize = cgExportDstSize;
    exportParam.sourceType = AMVE_STREAM_SOURCE_TYPE_CLIP;
    exportParam.dwResampleMode = AMVE_RESAMPLE_MODE_UPSCALE_FITIN;
    exportParam.dwPos = 0;
    exportParam.dwLen = sourceRange.dwLen;
    exportParam.ignoreWatermarkFlag = YES;
    exportParam.watermarkDisplayRect = CGRectMake(0,0,10000,10000);
    exportParam.bgColor = 0x000000;
    exportParam.llWaterMarkID = 0;
    stream = [XYEditUtils createStreamForExport:exportParam error:nil isChinese:YES];
    
    if (!stream) {
        return;
    }
    
    res = [self.producer Init :[[XYEngine sharedXYEngine] getCXiaoYingEngine] SessionStateHandler:self];
    if(res){
        NSLog(@"[ENGINE]XYProjectExportManager producer init err=0x%x",res);
        return;
    }
    
    MInt64 llMaxFileSize = [self freeDiskSpaceInBytes];
    //set param
    AMVE_PRODUCER_PARAM_TYPE param = {0};
    param.dwAudioFormat = AMVE_AUDIOFORMAT_AACLC;
    param.dwVideoFormat = AMVE_VIDEOFORMAT_H264;
    param.dwFileFormat = AMVE_FILEFORMAT_MP4;
    param.llMaxFileSize = llMaxFileSize;
    param.dwVideoBitrate = k*cgExportDstSize.width*cgExportDstSize.height*dwAveFPS/1000;
    param.dwVideoFrameRate = dwAveFPS;
    param.pszDestFile = (char*)cfilename;
    param.dwEncoderType = AMVE_ENCODER_TYPE_AUTO;
    param.dwProfile = AMVE_H264_PROFILE_HIGH;
    param.dwLevel = AMVE_H264_LEVEL_UNKNOW;
    param.dwMaxExpFPS = Max_Exp_FPS;
    
    //Set stream and param
    res = [self.producer setProperty:AMVE_PROP_PRODUCER_PARAM Value:&param];
    if(res){
        NSLog(@"[ENGINE]XYProjectExportManager producer setProperty AMVE_PROP_PRODUCER_PARAM err=0x%x",res);
        return;
    }
    res = [self.producer ActiveStream:stream];
    if(res){
        NSLog(@"[ENGINE]XYProjectExportManager producer ActiveStream err=0x%x",res);
        return;
    }
    res = [self.producer Start];
    if(res){
        NSLog(@"[ENGINE]XYProjectExportManager producer Start err=0x%x",res);
        return;
    }
}

- (BOOL)isClipSupportReverse:(CXiaoYingClip *)clip
{
    MDWord clipType = [[XYStoryboard sharedXYStoryboard] getClipTypeByClip:clip];
    if(clipType == AMVE_VIDEO_CLIP){
        return YES;
    }else{
        return NO;
    }
}
@end
