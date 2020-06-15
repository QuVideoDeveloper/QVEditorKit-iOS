//
//  XYStoryboard.m
//  XiaoYing
//
//  Created by xuxinyuan on 13-4-26.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//

#import "XYStoryboard.h"
#import "NSNumber+Language.h"
#import "XYEditUtils.h"
#import "XYEffectPositionDataModel.h"
#import "XYEffectPositionMgr.h"
#import "XYEngine.h"
#import "XYStoryboard+XYEffect.h"
#import "XYStoryboard+XYClip.h"
#import "XYStoryboard+XYThumbnail.h"
#import "XYCommonEngineUtility.h"
#import "XYStoryboardUserDataMgr.h"
#import <XYCategory/XYCategory.h>
#import "XYDefaultParseThemeText.h"
#import "XYAutoEditMgr.h"

static NSString * _Nullable const kXYCommonEngineProjectVersionInfoDic = @"kXYCommonEngineProjectVersionInfoDic";



#define PROJECT_VERSION_BEFORE_4_0 0x00020007
#define LINE_BYTES(Width, BitCnt) ((((MLong)(Width) * (BitCnt) + 31) >> 5) * 4)

#define CHECK_ERR_GOTO_LOOPEND(res) \
	if (res) {                      \
		goto LOOP_END;              \
	}

#define CHECK_VALID_RET_VOID(ret) \
	if (ret) {                    \
		return;                   \
	}

#define CHECK_VALID_RET(ret) \
	if (ret) {               \
		return ret;          \
	}

#define CHECK_VALID_RET_NIL(ret) \
	if (ret) {                   \
		return nil;              \
	}

static MBool g_bThemeApplying = MFalse;

@implementation XYStoryboardSaveConfig

@end

@interface XYStoryboard ()

//保存工程delegate转block用
@property (nonatomic, strong) XYAMVESaveStoryboardDelegateToBlock *amveSaveStoryboardDelegateToBlock;
//加载工程delegate转block用
@property (nonatomic, strong) XYAMVELoadStoryboardDelegateToBlock *amveLoadStoryboardDelegateToBlock;

@property (nonatomic, strong) XYAMVELoadStoryboardDataDelegateToBlock *amveLoadStoryboardDataDelegateToBlock;

@property (strong, nonatomic) CXiaoYingStoryBoardSession *loadPrjDataSession;

//用于分配bubbleText内存
@property (nonatomic) AMVE_BUBBLETEXT_SOURCE_TYPE *pTxtSrc;
@property (nonatomic) MDWord dwTxtCount;



@end

@implementation XYStoryboard

+ (XYStoryboard *)sharedXYStoryboard {
	static XYStoryboard *xyStoryboard;
	static dispatch_once_t pred;
	dispatch_once(&pred, ^{
	  xyStoryboard = [[XYStoryboard alloc] init];
	  [xyStoryboard initAll];
      [xyStoryboard addObserver];
	});
	return xyStoryboard;
}

- (void)initAll {
    self.cXiaoYingStoryBoardSession = [[CXiaoYingStoryBoardSession alloc] init];
    self.pTxtSrc = MNull;
    self.dwTxtCount = 0;
    self.amveSaveStoryboardDelegateToBlock = [[XYAMVESaveStoryboardDelegateToBlock alloc] init];
    self.amveLoadStoryboardDelegateToBlock = [[XYAMVELoadStoryboardDelegateToBlock alloc] init];
    self.coverCompressQualityParam = 70;
}

#pragma mark - Storyboard related
- (MRESULT)setUserData:(NSString *)strUserData {
	if (!self.cXiaoYingStoryBoardSession || [NSString xy_isEmpty:strUserData]) {
		return MERR_APP_BASE;
	}
	MDWord length = [strUserData lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	MByte *tmpData = (MByte *)[strUserData cStringUsingEncoding:NSUTF8StringEncoding];
	AMVE_USER_DATA_TYPE amveUserData = {tmpData, length + 1};

	CXiaoYingClip *dataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	MRESULT res = [dataClip setProperty:AMVE_PROP_CLIP_USERDATA PropertyData:&amveUserData];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard setUserData err 0x%x", res);
	}
	return res;
}

- (NSString *)getUserData {
	if (!self.cXiaoYingStoryBoardSession) {
		return nil;
	}
	CXiaoYingClip *dataClip = [self.cXiaoYingStoryBoardSession getDataClip];

	AMVE_USER_DATA_TYPE tmpAmveUserData = {MNull, 0};
	MRESULT res = [dataClip getProperty:AMVE_PROP_CLIP_USERDATA PropertyData:&tmpAmveUserData];
	if (res || tmpAmveUserData.dwUserDataLen == 0) {
		NSLog(@"[ENGINE]XYStoryboard getTmpUserData err 0x%x", res);
		return nil;
	}
	MByte *pbyUserData = (MByte *)MMemAlloc(MNull, tmpAmveUserData.dwUserDataLen);
	MMemSet(pbyUserData, 0, tmpAmveUserData.dwUserDataLen);
	AMVE_USER_DATA_TYPE amveUserData = {pbyUserData, 0};
	res = [dataClip getProperty:AMVE_PROP_CLIP_USERDATA PropertyData:&amveUserData];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getUserData err 0x%x", res);
		free(pbyUserData);
		return nil;
	}
	NSString *strUserData = [NSString stringWithUTF8String:(char *)amveUserData.pbyUserData];
	free(pbyUserData);
	return strUserData;
}

- (NSString *)getClipData:(CXiaoYingClip *)clip {
    if (!self.cXiaoYingStoryBoardSession) {
        return nil;
    }

    AMVE_USER_DATA_TYPE tmpAmveUserData = {MNull, 0};
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_USERDATA PropertyData:&tmpAmveUserData];
    if (res || tmpAmveUserData.dwUserDataLen == 0) {
        NSLog(@"[ENGINE]XYStoryboard getTmpUserData err 0x%x", res);
        return nil;
    }
    MByte *pbyUserData = (MByte *)MMemAlloc(MNull, tmpAmveUserData.dwUserDataLen);
    MMemSet(pbyUserData, 0, tmpAmveUserData.dwUserDataLen);
    AMVE_USER_DATA_TYPE amveUserData = {pbyUserData, 0};
    res = [clip getProperty:AMVE_PROP_CLIP_USERDATA PropertyData:&amveUserData];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getUserData err 0x%x", res);
        free(pbyUserData);
        return nil;
    }
    NSString *strUserData = [NSString stringWithUTF8String:(char *)amveUserData.pbyUserData];
    free(pbyUserData);
    return strUserData;
}

- (void)setStoryboardSession:(CXiaoYingStoryBoardSession *)storyboardSession {
	self.cXiaoYingStoryBoardSession = storyboardSession;
}

- (void)renewStoryboardSession {
	CXiaoYingStoryBoardSession *newStoryboardSession = [CXiaoYingStoryBoardSession duplicate:self.cXiaoYingStoryBoardSession];
	if (newStoryboardSession) {
		self.cXiaoYingStoryBoardSession = newStoryboardSession;
	}
}

- (MRESULT)initXYStoryBoard {
	[self unInitXYStoryBoard];
	NSLog(@"[ENGINE]XYStoryboard initXYStoryBoard");
	self.cXiaoYingStoryBoardSession = nil;
	self.cXiaoYingStoryBoardSession = [[CXiaoYingStoryBoardSession alloc] init];
	MRESULT res = [self.cXiaoYingStoryBoardSession Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] ThemeOptHandler:self];
	[self setModified:NO];
	NSLog(@"[ENGINE]XYStoryboard initXYStoryBoard err=0x%x", res);
	return res;
}

- (MRESULT)unInitXYStoryBoard {
	MRESULT res = 0;
	if (self.cXiaoYingStoryBoardSession) {
		NSLog(@"[ENGINE]XYStoryboard unInitXYStoryBoard");
		self.currentProjectFullFilePath = nil;
		res = [self.cXiaoYingStoryBoardSession UnInit];
		self.cXiaoYingStoryBoardSession = nil;
		NSLog(@"[ENGINE]XYStoryboard unInitXYStoryBoard err=0x%x", res);
	}
	return res;
}

- (MRESULT)unInitAutoEditStoryBoard {
	MRESULT res = 0;
	if (self.cXiaoYingStoryBoardSession) {
		NSLog(@"[ENGINE]XYStoryboard unInitXYStoryBoard");
		self.currentProjectFullFilePath = nil;
		res = [self.cXiaoYingStoryBoardSession UnInit];
		self.cXiaoYingStoryBoardSession = nil;
		NSLog(@"[ENGINE]XYStoryboard unInitXYStoryBoard err=0x%lx", res);
	}
	return res;
}

- (CXiaoYingStoryBoardSession *)getStoryboardSession {
	return self.cXiaoYingStoryBoardSession;
}

- (MHandle)getStoryboardHSession {
	return self.cXiaoYingStoryBoardSession.hSession;
}

- (CXiaoYingClip *)getDataClip {
	return [self.cXiaoYingStoryBoardSession getDataClip];
}

- (UInt32)getDuration {
	return [self.cXiaoYingStoryBoardSession getDuration];
}

- (MRESULT)setStoryboardTrimRange:(MDWord)startPos
                           endPos:(MDWord)endPos {
	[self setModified:YES];
	CXiaoYingClip *cXiaoYingClip = [self.cXiaoYingStoryBoardSession getDataClip];
	AMVE_POSITION_RANGE_TYPE clipRange = {0};
	clipRange.dwPos = startPos;
	clipRange.dwLen = endPos - startPos;
    MRESULT res = [self setClipTrimRange:cXiaoYingClip trimRange:clipRange];
	
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard setStoryboardTrimRange startPos=%ld endPos=%ld, err=0x%lx", startPos, endPos, res);
	}
	return res;
}

- (AMVE_POSITION_RANGE_TYPE)getStoryboradTrimRange {
	CXiaoYingClip *cXiaoYingClip = [self.cXiaoYingStoryBoardSession getDataClip];
	AMVE_POSITION_RANGE_TYPE clipRange = [self getClipTrimRangeByClip:cXiaoYingClip];
	return clipRange;
}

- (MRESULT)applyStoryboardTrim {
	MRESULT res = [self.cXiaoYingStoryBoardSession applyTrim];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard applyStoryboardTrim err=0x%lx", res);
	}
	return res;
}

- (AMVE_VIDEO_INFO_TYPE)getVideoInfo {
	AMVE_VIDEO_INFO_TYPE videoinfo = {0};
	if (!self.cXiaoYingStoryBoardSession || ![self.cXiaoYingStoryBoardSession getDataClip]) {
		videoinfo.dwFrameWidth = 640;
		videoinfo.dwFrameHeight = 360;
		return videoinfo;
	}
	MRESULT res = [[self.cXiaoYingStoryBoardSession getDataClip] getProperty:AMVE_PROP_CLIP_SOURCE_INFO
	                                                            PropertyData:(MVoid *)&videoinfo];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getVideoInfo err=0x%lx", res);
	}
	return videoinfo;
}

- (void)saveProjectThumbnail:(NSString *)prjFilePath {
	//    [NSFileManager xy_createFolder:APP_PROJECT_PATH];
	NSString *thumbFilePath = [prjFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@".jpg"];
	MSIZE exportSize = {0};
	[self getExportSize:&exportSize];
	AMVE_POSITION_RANGE_TYPE clipTrimRange = [self getClipTrimRangeByIndex:0];
    if ([[XYStoryboard sharedXYStoryboard] isReverseTrim:0]) {
        clipTrimRange.dwPos = 0;
    }
	UIImage *thumb = [self createClipThumbnail:0 dwPosition:clipTrimRange.dwPos dwThumbPixelW:exportSize.cx dwThumbPixelH:exportSize.cy PimalFlag:MFalse];
	[UIImageJPEGRepresentation(thumb, 0.7) writeToFile:thumbFilePath atomically:YES];
	NSLog(@"save thumbnail to %@", thumbFilePath);
}

- (void)saveProjectThumbnails:(NSString *)filePath thumbPos:(UInt64)thumbPos {
    if (!filePath) {
        return;
    }
    //    [NSFileManager xy_createFolder:APP_PROJECT_PATH];
    BOOL isThumb0Exsit = NO;
    NSString *thumbFilePath = filePath;
    if ([[filePath pathExtension] containsString:@"prj"]) {
        thumbFilePath = [filePath stringByReplacingOccurrencesOfString:@".prj" withString:@".jpg"];
    }
    NSString *thumbPath0 = thumbFilePath;
    isThumb0Exsit = [NSFileManager xy_fileExist:thumbPath0];
    
    if (![self isModified] && isThumb0Exsit) {
        return;
    }
    
    //Create project thumbnail
    MSIZE exportSize = {0};
    [self getExportSize:&exportSize];
    
    NSArray *posArray = @[ @(thumbPos) ];
    
    [self createThumbnails:exportSize.cx
             dwThumbPixelH:exportSize.cy
               dwPositions:posArray
                 PimalFlag:MFalse
          onlyOriginalClip:MFalse
        skipBlackFrameFlag:MTrue
                     block:^(UIImage *image, int index) {
        NSString *finalThumPath = thumbFilePath;
        if (index != 0) {
            finalThumPath = [thumbFilePath stringByReplacingOccurrencesOfString:@".jpg" withString:[NSString stringWithFormat:@"_%d%@", index, @".jpg"]];
        }
        [UIImageJPEGRepresentation(image, ((float)self.coverCompressQualityParam)/100.0f) writeToFile:finalThumPath atomically:YES];
    }];
    NSLog(@"save thumbnails to %@", thumbFilePath);
}

- (MRESULT)saveStoryboardWithSaveConfigBlock:(XYStoryboardSaveConfig *_Nonnull (^)(XYStoryboardSaveConfig * saveConfig))saveConfigBlock
            completeBlock:(SAVE_COMPLETE_BLOCK)completeBlock {
	if (self.amveSaveStoryboardDelegateToBlock.storyboardSaveCompleteBlock) {
        if (completeBlock) {
            completeBlock(-1);
        }
		return -1;
	}
    XYStoryboardSaveConfig *saveConfig = [XYStoryboardSaveConfig new];
    if (saveConfigBlock) {
        saveConfig = saveConfigBlock(saveConfig);
        saveConfigBlock = nil;
    }
    NSString *prjFilePath = saveConfig.prjFilePath;
	NSLog(@"[ENGINE]XYStoryboard saveStoryboard to %@", prjFilePath);
    if (saveConfig.needUpdateThumbnail && !saveConfig.thumbnailFilePath) {
		[self saveProjectThumbnails:prjFilePath thumbPos:saveConfig.thumbPos];
    } else {
        [self saveProjectThumbnails:saveConfig.thumbnailFilePath thumbPos:saveConfig.thumbPos];
    }
	[self setModified:NO];
    [self saveProjectVersionInfo];
	self.amveSaveStoryboardDelegateToBlock.projectFilePath = prjFilePath;
    self.currentProjectFullFilePath = prjFilePath;
	self.amveSaveStoryboardDelegateToBlock.storyboardSaveCompleteBlock = completeBlock;
	MRESULT res = QVET_ERR_NONE;
	if (prjFilePath) {
		BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:[prjFilePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
		res = [self.cXiaoYingStoryBoardSession saveProject:(MChar *)[prjFilePath UTF8String] SessionStateHandler:self.amveSaveStoryboardDelegateToBlock];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard saveStoryboard err=0x%lx", res);
			self.amveSaveStoryboardDelegateToBlock.storyboardSaveCompleteBlock = nil;
			if (completeBlock) {
				completeBlock(res);
			}
		}
	} else {
		res = QVET_ERR_APP_FILE_OPEN;
		if (completeBlock) {
			completeBlock(res);
		}
		NSLog(@"[ENGINE]XYStoryboard saveStoryboard err=0x%lx", res);
	}
	NSLog(@"saveStoryboard res=0x%lx", res);
	return res;
}

//保存工程版本信息
- (void)saveProjectVersionInfo {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //app版本
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if ([NSString xy_isEmpty:appVersion]) {
        return;
    }
    NSMutableDictionary *userDataDict = [XYStoryboardUserDataMgr getUserDataDict];
    if (!userDataDict) {
        userDataDict = [[NSMutableDictionary alloc] init];
    }
    NSDictionary *projectVersionInfoDic = @{kXYCommonEngineAppVersion : appVersion};
    [userDataDict setValue:projectVersionInfoDic forKey:kXYCommonEngineProjectVersionInfoDic];
    [XYStoryboardUserDataMgr saveUserDataDict:userDataDict];
}

- (NSDictionary *)fetchProjectVersionInfo {
    NSMutableDictionary *userDataDict = [XYStoryboardUserDataMgr getUserDataDict];
    return [userDataDict valueForKey:kXYCommonEngineProjectVersionInfoDic];
}

- (MRESULT)backupStoryboard:(NSString *)prjFilePath block:(SAVE_COMPLETE_BLOCK)block {
	return [self backupStoryboard:prjFilePath saveThumbnails:YES block:block];
}

- (MRESULT)backupStoryboard:(NSString *)prjFilePath saveThumbnails:(BOOL)saveThumbnails block:(SAVE_COMPLETE_BLOCK)block {
	NSString *backUpPrjFilePath = [prjFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@"_backup.prj"];
    return [self saveStoryboardWithSaveConfigBlock:^XYStoryboardSaveConfig *(XYStoryboardSaveConfig *saveConfig) {
        saveConfig.prjFilePath = backUpPrjFilePath;
        saveConfig.needUpdateThumbnail = saveThumbnails;
        return saveConfig;
    } completeBlock:^(MRESULT result) {
        block(result);
    }];
}

- (void)fetchProjectTemplates:(NSString *)prjFilePath complete:(void (^)(NSInteger errorCode, NSArray <NSNumber *> *templates))complete {
    [self.loadPrjDataSession UnInit];
    self.loadPrjDataSession = [[CXiaoYingStoryBoardSession alloc] init];
    [self.loadPrjDataSession Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] ThemeOptHandler:self];
    
    self.amveLoadStoryboardDataDelegateToBlock = [[XYAMVELoadStoryboardDataDelegateToBlock alloc] init];
    __weak __typeof(self) wself = self;
    self.amveLoadStoryboardDataDelegateToBlock.storyboardLoadCompleteBlock = ^(MRESULT errCode) {
        CXiaoYingStoryBoardProjectData *prjData = [self.loadPrjDataSession fetchProjectData];
        if (complete) {
            complete(0, prjData.templates);
        }
    };
    MRESULT result = [self.loadPrjDataSession loadProjectData:(MChar *)[prjFilePath UTF8String] SessionStateHandler:self.amveLoadStoryboardDataDelegateToBlock];
    if (result != 0) {
        if (complete) {
            complete(result, nil);
        }
    }
}

+ (BOOL)isLastWorkedPrjExsit:(NSString *)prjFilePath {
	NSString *lastWorkedPrjFilePath = [prjFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@"_last_worked.prj"];
	if ([NSFileManager xy_fileExist:lastWorkedPrjFilePath]) {
		return YES;
	}
	return NO;
}

- (void)loadLastWorkedPrj:(NSString *)prjFilePath {
	//try to load the last worked project file.
	NSString *prjDataFilePath = [prjFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@".dat"];
	NSString *lastWorkedPrjFilePath = [prjFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@"_last_worked.prj"];
	NSString *lastWorkedPrjDataFilePath = [prjFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@"_last_worked.dat"];
	[NSFileManager xy_moveFromFile:lastWorkedPrjFilePath toFile:prjFilePath];
	[NSFileManager xy_moveFromFile:lastWorkedPrjDataFilePath toFile:prjDataFilePath];
}

- (MRESULT)innerLoadStoryboard:(NSString *)prjFilePath
          afterLoadPrjFilrPath:(NSString *)afterLoadPrjFilrPath
             loadCompleteBlock:(LOAD_COMPLETE_BLOCK)block {
	self.amveLoadStoryboardDelegateToBlock.isClipMissing = NO;
	self.amveLoadStoryboardDelegateToBlock.isTemplateMissing = NO;
	if (self.amveLoadStoryboardDelegateToBlock.storyboardLoadCompleteBlock) {
        if (block) {
            block(-1);
        }
		return -1;
	}

	if (![NSFileManager xy_fileExist:prjFilePath]) {
		self.amveLoadStoryboardDelegateToBlock.storyboardLoadCompleteBlock = nil;
		if (block) {
			block(-1);
		}
		return -1;
	}
	self.amveLoadStoryboardDelegateToBlock.projectFilePath = prjFilePath;
	self.amveLoadStoryboardDelegateToBlock.storyboardLoadCompleteBlock = block;

	MRESULT res = [self initXYStoryBoard];

	res = [self.cXiaoYingStoryBoardSession loadProject:(MChar *)[prjFilePath UTF8String] SessionStateHandler:self.amveLoadStoryboardDelegateToBlock];

	if (res) {
		self.amveLoadStoryboardDelegateToBlock.storyboardLoadCompleteBlock = nil;
		if (block) {
			block(res);
		}
	} else {
		self.currentProjectFullFilePath = afterLoadPrjFilrPath;
	}
	return res;
}

- (MRESULT)loadStoryboard:(NSString *)prjFilePath block:(LOAD_COMPLETE_BLOCK)block {
    if (self.isSlideShowSession) {
        [self initXYStoryBoard];
        self.isSlideShowSession = NO;
    }
    BOOL isPrjFileExist = [NSFileManager xy_fileExist:prjFilePath];
    if (!isPrjFileExist) {
        NSLog(@"Project file is missing");
        //The project file is missing,try to load the last worked project file.
        [self loadLastWorkedPrj:prjFilePath];
    }
    return [self innerLoadStoryboard:prjFilePath afterLoadPrjFilrPath:prjFilePath loadCompleteBlock:block];
}

- (MRESULT)reloadCurrentStoryboard:(LOAD_COMPLETE_BLOCK)block {
	NSString *tempPrjFilePath = self.currentProjectFullFilePath;

	MRESULT res = [self innerLoadStoryboard:tempPrjFilePath afterLoadPrjFilrPath:tempPrjFilePath loadCompleteBlock:block];
	return res;
}

- (MRESULT)reloadBackupStoryboard:(LOAD_COMPLETE_BLOCK)block {
	NSString *tmpProjectFilePath = self.currentProjectFullFilePath;
	NSString *backUpPrjFilePath = [self.currentProjectFullFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@"_backup.prj"];

	MRESULT res = [self innerLoadStoryboard:backUpPrjFilePath afterLoadPrjFilrPath:tmpProjectFilePath loadCompleteBlock:block];
	return res;
}

- (void)upgradeCurrentStoryboard {//sunshine 代码现在不用调 待整理
//	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
//	if (!pStbDataClip) {
//		return;
//	}
//	//    MDWord projectVersion = [CXiaoYingUtils GetProjectVersion:(MChar *)self.currentProjectFullFilePath.UTF8String];
//	//    if(projectVersion < PROJECT_VERSION_BEFORE_4_0){
//	//Need to be upgraded
//	MDWord textEffectCount = [self getEffectCount:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_TEXT_FRAME];
//	CGFloat textBaseLayerId = LAYER_ID_SUBTITLE;
//	for (int i = 0; i < textEffectCount; i++) {
//		CXiaoYingEffect *textEffect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:GROUP_TEXT_FRAME EffectIndex:i];
//		textBaseLayerId += LAYER_ID_ADDEND;
//		[self setEffectLayerId:textEffect layerId:textBaseLayerId];
//	}
//
//	MDWord stickerEffectCount = [self getEffectCount:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_STICKER];
//	CGFloat stickerBaseLayerId = LAYER_ID_STICKER;
//	for (int i = 0; i < stickerEffectCount; i++) {
//		CXiaoYingEffect *stickerEffect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:GROUP_STICKER EffectIndex:i];
//		stickerBaseLayerId += LAYER_ID_ADDEND;
//		[self setEffectLayerId:stickerEffect layerId:stickerBaseLayerId];
//	}
//
//    MDWord mosaicEffectCount = [self getEffectCount:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_ID_MOSAIC];
//    CGFloat mosaicBaseLayerId = LAYER_ID_MOSAIC;
//    for (int i = 0; i < mosaicEffectCount; i++) {
//        CXiaoYingEffect *mosaicEffect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:GROUP_ID_MOSAIC EffectIndex:i];
//        mosaicBaseLayerId += LAYER_ID_ADDEND;
//        [self setEffectLayerId:mosaicEffect layerId:mosaicBaseLayerId];
//    }
	//    }
}

- (void)setModified:(BOOL)modified {
	_isModified = modified;
}

- (BOOL)IsModified {
	return _isModified;
}

+ (void)deleteBackup:(NSString *)prjFilePath {
	NSString *backUpPrjFilePath = [prjFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@"_backup.prj"];
	NSString *autoBackUpPrjFilePath = [prjFilePath stringByReplacingOccurrencesOfString:@".prj" withString:@"_auto_backup.prj"];
	if ([NSFileManager xy_fileExist:backUpPrjFilePath]) {
		[NSFileManager xy_deleteFileWithPath:backUpPrjFilePath];
		[NSFileManager xy_deleteFileWithPath:[backUpPrjFilePath stringByReplacingOccurrencesOfString:@"_backup.prj" withString:@"_backup.dat"]];
		NSLog(@"deleteBackup %@", backUpPrjFilePath);
	}
	if ([NSFileManager xy_fileExist:autoBackUpPrjFilePath]) {
		[NSFileManager xy_deleteFileWithPath:autoBackUpPrjFilePath];
		[NSFileManager xy_deleteFileWithPath:[autoBackUpPrjFilePath stringByReplacingOccurrencesOfString:@"_backup.prj" withString:@"_auto_backup.dat"]];
		NSLog(@"deleteAutoBackUpPrjFilePath %@", autoBackUpPrjFilePath);
	}
}

- (MRESULT)setOutputResolution:(MPOINT *)pStbSize {
	if (nil == self.cXiaoYingStoryBoardSession)
		return QVET_ERR_APP_FAIL;

	MRESULT res = [self.cXiaoYingStoryBoardSession setProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:pStbSize];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard setOutputResolution err=0x%lx", res);
	}
	return res;
}

- (MRESULT)getOutputResolution:(MPOINT *)pStbSize {
	if (nil == self.cXiaoYingStoryBoardSession)
		return QVET_ERR_APP_FAIL;

	MRESULT res = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:pStbSize];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getOutputResolution err=0x%lx", res);
	}
	return res;
}

- (CGSize)getExportSize {
	MSIZE exportSize = {0};
	[self getExportSize:&exportSize];
	return CGSizeMake(exportSize.cx, exportSize.cy);
}

- (CGSize)getHDExportSize {
	MSIZE exportSize = {0};
	[self getHDExportSize:&exportSize];
	return CGSizeMake(exportSize.cx, exportSize.cy);
}

- (CGSize)getHDRecommededExportSizeFromMinimumWidth:(CGFloat)minimumWidth {
	MSIZE pSize = {0};
	MRESULT res = [self getExportSize:&pSize];
	if (nil == self.cXiaoYingStoryBoardSession || res)
		return CGSizeMake(640, 480);

	CGFloat videoRatio = (CGFloat)pSize.cx / pSize.cy;

	if (videoRatio - 16.0 / 9.0 < 0.01 && videoRatio - 16.0 / 9.0 > -0.01) {
		videoRatio = 16.0 / 9.0;
	} else if (videoRatio - 9.0 / 16.0 < 0.01 && videoRatio - 9.0 / 16.0 > -0.01) {
		videoRatio = 9.0 / 16.0;
	} else if (videoRatio - 1.0 < 0.01 && videoRatio - 1.0 > -0.01) {
		videoRatio = 1.0;
	}

	CXiaoYingEngine *pEngine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
	MPOINT maxResolution = {1920, 1920};
	res = [pEngine GetProperty:AMVE_PROP_CONTEXT_MAX_SUPPORT_RESOLUTION Value:&maxResolution];

	if (pSize.cx < pSize.cy) {
		pSize.cx = minimumWidth;
		pSize.cy = minimumWidth / videoRatio;
		if (pSize.cy > maxResolution.x) {
			pSize.cy = maxResolution.x;
			pSize.cx = maxResolution.x * videoRatio;
		}
	} else if (pSize.cx > pSize.cy) {
		pSize.cy = minimumWidth;
		pSize.cx = minimumWidth * videoRatio;
        if (AMVE_VIDEO_4K_HEIGHT == minimumWidth) {//导出4k 以最长边不超过 3840
           if (pSize.cx > AMVE_VIDEO_4K_WIDTH) {
                pSize.cx = AMVE_VIDEO_4K_WIDTH;
                pSize.cy = pSize.cx / videoRatio;
            }
        }else if (pSize.cx > maxResolution.x) {
			pSize.cx = maxResolution.x;
			pSize.cy = maxResolution.x / videoRatio;
		}
	} else {
		pSize.cx = minimumWidth;
		pSize.cy = minimumWidth;
	}

	if (pSize.cx % 4 != 0) {
		pSize.cx -= pSize.cx % 4;
	}

	if (pSize.cy % 4 != 0) {
		pSize.cy -= pSize.cy % 4;
	}
	return CGSizeMake(pSize.cx, pSize.cy);
}

- (MRESULT)getExportSize:(MSIZE *)pSize {
	if (nil == self.cXiaoYingStoryBoardSession)
		return QVET_ERR_APP_FAIL;

	MPOINT pStbSize = {0};
	MRESULT res = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getExportSize err=0x%lx", res);
	}
	if (pStbSize.x == 0 || pStbSize.y == 0) {
		return QVET_ERR_APP_FAIL;
	}

	CGFloat videoRatio = (CGFloat)pStbSize.x / pStbSize.y;

	if (videoRatio - 16.0 / 9.0 < 0.01 && videoRatio - 16.0 / 9.0 > -0.01) {
		videoRatio = 16.0 / 9.0;
	} else if (videoRatio - 9.0 / 16.0 < 0.01 && videoRatio - 9.0 / 16.0 > -0.01) {
		videoRatio = 9.0 / 16.0;
	} else if (videoRatio - 1.0 < 0.01 && videoRatio - 1.0 > -0.01) {
		videoRatio = 1.0;
	}

	if ([self is64bit]) {
		if (pStbSize.x < pStbSize.y) {
			pSize->cx = 480;
			pSize->cy = 480 / videoRatio;
		} else if (pStbSize.x > pStbSize.y) {
			pSize->cy = 480;
			pSize->cx = 480 * videoRatio;
		} else {
			pSize->cx = 480;
			pSize->cy = 480;
		}
	} else {
		if (pStbSize.x < pStbSize.y) {
			pSize->cx = 360;
			pSize->cy = 360 / videoRatio;
		} else if (pStbSize.x > pStbSize.y) {
			pSize->cy = 360;
			pSize->cx = 360 * videoRatio;
		} else {
			pSize->cx = 480;
			pSize->cy = 480;
		}
	}

	if (pSize->cx % 4 != 0) {
		pSize->cx -= pSize->cx % 4;
	}

	if (pSize->cy % 4 != 0) {
		pSize->cy -= pSize->cy % 4;
	}
	return QVET_ERR_NONE;
}

- (MRESULT)getHDExportSize:(MSIZE *)pSize {
	MRESULT res = [self getExportSize:pSize];
	if (nil == self.cXiaoYingStoryBoardSession || res)
		return QVET_ERR_APP_FAIL;

	CGFloat videoRatio = (CGFloat)pSize->cx / pSize->cy;

	if (videoRatio - 16.0 / 9.0 < 0.01 && videoRatio - 16.0 / 9.0 > -0.01) {
		videoRatio = 16.0 / 9.0;
	} else if (videoRatio - 9.0 / 16.0 < 0.01 && videoRatio - 9.0 / 16.0 > -0.01) {
		videoRatio = 9.0 / 16.0;
	} else if (videoRatio - 1.0 < 0.01 && videoRatio - 1.0 > -0.01) {
		videoRatio = 1.0;
	}

	if (pSize->cx < pSize->cy) {
		pSize->cx = 720;
		pSize->cy = 720 / videoRatio;
	} else if (pSize->cx > pSize->cy) {
		pSize->cy = 720;
		pSize->cx = 720 * videoRatio;
	} else {
		pSize->cx = 720;
		pSize->cy = 720;
	}

	if (pSize->cx % 4 != 0) {
		pSize->cx -= pSize->cx % 4;
	}

	if (pSize->cy % 4 != 0) {
		pSize->cy -= pSize->cy % 4;
	}
	return QVET_ERR_NONE;
}

- (BOOL)updateStoryboardSize:(BOOL)isPhotoMV {
	BOOL isThemeApplied = [self getThemeID] > 0x100000000000000;
	return [self updateStoryboardSize:isPhotoMV isAppliedEffects:isThemeApplied];
}

- (BOOL)updateStoryboardSize:(BOOL)isPhotoMV isAppliedEffects:(BOOL)isAppliedEffects {
	MPOINT outPutResolution = [self getStoryboardOriginalSize:isPhotoMV isAppliedEffects:isAppliedEffects];
	if (outPutResolution.x != 0 && outPutResolution.y != 0) {
		return [self setOutputResolution:&outPutResolution];
	} else {
		return NO;
	}
}

- (MPOINT)getStoryboardOriginalSize:(BOOL)isPhotoMV {
	BOOL isThemeApplied = [self getThemeID] > 0x100000000000000;
	return [self getStoryboardOriginalSize:isPhotoMV isAppliedEffects:isThemeApplied];
}

- (MPOINT)getStoryboardOriginalSize:(BOOL)isPhotoMV isAppliedEffects:(BOOL)isAppliedEffects {
	MPOINT outPutResolution = {0};
	MRESULT res = MERR_NONE;
	if (!self.cXiaoYingStoryBoardSession) {
		return outPutResolution;
	}

	if (isPhotoMV) {
		outPutResolution.x = 640;
		outPutResolution.y = 480;
		return outPutResolution;
	}

	int clipCount = [self getClipCount];
	if (clipCount == 0) {
		return outPutResolution;
	}

	BOOL isFirstClipImage = [self isFirstClipPicture];
	if (isFirstClipImage) {
		outPutResolution.x = 640;
		outPutResolution.y = 480;
		return outPutResolution;
	}
	MSIZE firstClipSize = {0};
	[self getFirstClipSize:&firstClipSize];
	if (firstClipSize.cx == 0 || firstClipSize.cy == 0) {
		return outPutResolution;
	}

	if (firstClipSize.cx < firstClipSize.cy) {
		//portrait
		BOOL bUseRawVideoResolution = !isFirstClipImage && !isAppliedEffects;
		if (bUseRawVideoResolution) { //Use raw video resolution
			outPutResolution = [self getFitInSize:firstClipSize];
		} else {
			outPutResolution.x = 480;
			outPutResolution.y = 480;
		}
	} else {
		outPutResolution = [self getFitInSize:firstClipSize];
	}

	return outPutResolution;
}

- (MPOINT)getFitInSize:(MSIZE)clipSize {
	MPOINT outPutResolution = {0};
	CGFloat videoRatio = (CGFloat)clipSize.cx / clipSize.cy;

	if (clipSize.cx < clipSize.cy) {
		outPutResolution.y = 640;
		if (videoRatio > 3.0 / 4.0) {
			outPutResolution.x = 480;
		} else {
			outPutResolution.x = 640 * videoRatio;
		}
	} else if (clipSize.cx > clipSize.cy) {
		outPutResolution.x = 640;
		if (videoRatio < 4.0 / 3.0) {
			outPutResolution.y = 480;
		} else {
			outPutResolution.y = 640 / videoRatio;
		}
	} else {
		outPutResolution.x = 480;
		outPutResolution.y = 480;
	}

	if (outPutResolution.x % 2 != 0) {
		outPutResolution.x -= 1;
	}

	if (outPutResolution.y % 2 != 0) {
		outPutResolution.y -= 1;
	}
	return outPutResolution;
}

- (MPOINT)updateStoryboardSizeWithInputWidth:(CGFloat)width inputScale:(MSIZE)inputScale isPhotoMV:(BOOL)isPhotoMV downScale:(BOOL)downScale
{
    BOOL isThemeApplied = [self getThemeID] > 0x100000000000000;
    
    return [self updateStoryboardSizeWithInputWidth:width inputScale:inputScale isPhotoMV:isPhotoMV isAppliedEffects:isThemeApplied downScale:downScale];
}

- (MPOINT)updateStoryboardSizeWithInputWidth:(CGFloat)width inputScale:(MSIZE)inputScale isPhotoMV:(BOOL)isPhotoMV isAppliedEffects:(BOOL)isAppliedEffects downScale:(BOOL)downScale
{
    MPOINT result = [self calFitSize:inputScale width:width isPhotoMV:isPhotoMV isAppliedEffects:isAppliedEffects];
    
    MRESULT res = MERR_NONE;
    
    if(result.x != 0 && result.y != 0)
    {
        res = [self setOutputResolution:&result downScale:downScale];
    }
    return result;
}

- (MRESULT)setOutputResolution:(MPOINT *)pStbSize downScale:(BOOL)downScale
{
    if(nil == self.cXiaoYingStoryBoardSession)
    {
        return QVET_ERR_APP_FAIL;
    }
    
    MRESULT res = [self.cXiaoYingStoryBoardSession setProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:pStbSize];
    
    if(downScale == NO)
    {
        MBool result = MFalse;
        
        res = [[[XYEngine sharedXYEngine] getCXiaoYingEngine] SetProperty:AMVE_PROP_CONTEXT_PLAY_DOWN_SCALE Value:&result];
    }
    
    if(res)
    {
    }
    
    return res;
}

- (MPOINT)calFitSize:(MSIZE)inputScale width:(CGFloat)width isPhotoMV:(BOOL)isPhotoMV isAppliedEffects:(BOOL)isAppliedEffects
{
    MPOINT outputResult = {0};
    
    CGFloat outputWidth = width;
    CGFloat outputScaleX = 1.0;
    CGFloat outputScaleY = 1.0;
    
    if(width == 0)
    {
        outputResult.x = 480.0;
        outputResult.y = 480.0;
        
        return outputResult;
    }
    
    if(inputScale.cx == 0 && inputScale.cy == 0)
    {
        ///photoMV
        if(isPhotoMV)
        {
            outputWidth = width;
            outputScaleX = 4.0;
            outputScaleY = 3.0;
        }
        else
        {
            MSIZE firstClipSize = {0};
            
            [self getFirstClipSize:&firstClipSize];
            
            ///竖的
            if(firstClipSize.cx < firstClipSize.cy)
            {
                BOOL isFirstClipImage = [self isFirstClipPicture];
                
                BOOL bUseRawVideoResolution = !isFirstClipImage && !isAppliedEffects;
                
                if(!bUseRawVideoResolution)
                {
                    outputWidth = width;
                    outputScaleX = 1.0;
                    outputScaleY = 1.0;
                }
                else
                {
                    outputWidth = width;
                    outputScaleX = firstClipSize.cx;
                    outputScaleY = firstClipSize.cy;
                }
            }
            else
            {
                ///横的
                outputWidth = width;
                outputScaleX = firstClipSize.cx;
                outputScaleY = firstClipSize.cy;
            }
        }
    }
    else
    {
        outputWidth = width;
        outputScaleX = inputScale.cx;
        outputScaleY = inputScale.cy;
    }
    
    CGFloat toCalOutputHeight = outputWidth * (CGFloat)(outputScaleY / outputScaleX);
    
    if(toCalOutputHeight > outputWidth)
    {
        toCalOutputHeight = outputWidth;
        
        outputWidth = toCalOutputHeight * (CGFloat)(outputScaleX / outputScaleY);
    }
    
    outputResult.x = outputWidth;
    outputResult.y = toCalOutputHeight;
    
    return outputResult;
}

- (BOOL)isHDStoryboard {
	return [self isStoryboardSizeLargerOrEqualTo:CGSizeMake(720, 720)];
}

- (BOOL)isStoryboardSizeLargerOrEqualTo:(CGSize)targetSize {
	MDWord clipCount = [self getClipCount];
	for (MDWord index = 0; index < clipCount; index++) {
		CXiaoYingClip *clip = [self getClipByIndex:index];
		if ([self isClip:clip sizeLargerEqualTo:targetSize]) {
			return YES;
		}
	}
	return NO;
}

- (UIImageOrientation)imageOrientationFromRotation:(MDWord)rotation {
	UIImageOrientation orientation;
	switch (rotation) {
		case 0:
			orientation = UIImageOrientationUp;
			break;
		case 90:
			orientation = UIImageOrientationLeft;
			break;
		case 180:
			orientation = UIImageOrientationDown;
			break;
		case 270:
			orientation = UIImageOrientationRight;
			break;
		default:
			orientation = UIImageOrientationUp;
			break;
	}
	return orientation;
}

#pragma mark - Text bubble related
- (CGSize)getTemplateTextOriginalSize:(NSString *)templateFilePath
                         previewFrame:(CGRect)previewFrame
                               bHasBG:(MBool *)bHasBG
                          bIsAnimated:(MBool *)bIsAnimated
                           dwBGFormat:(MDWord *)dwBGFormat {
	CGSize size = CGSizeZero;
	QVET_BUBBLE_TEMPLATE_INFO btInfo = {0};
	MDWord dwLayoutMode = [self getLayoutMode:previewFrame.size.width height:previewFrame.size.height];
	if (!templateFilePath) {
		*bHasBG = MTrue;
		return size;
	}
	MTChar *pTxtTemplate = (MTChar *)[templateFilePath UTF8String];
	CXiaoYingStyle *pStyle = [[CXiaoYingStyle alloc] init];

	MRESULT res = [pStyle Create:pTxtTemplate
	                BGLayoutMode:dwLayoutMode
	                    SerialNo:MNull];
	if (res != QVET_ERR_NONE) {
		NSLog(@"[ENGINE]XYStoryboard getTemplateTextOriginalSize style Create err=0x%lx", res);
		[pStyle Destory];
		*bHasBG = MTrue;
		return size;
	}

	MSIZE bgSize = {0};
	bgSize.cx = previewFrame.size.width;
	bgSize.cy = previewFrame.size.height;
	res = [pStyle GetBubbleTemplateInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine]
	                         LanguageID:[NSNumber xy_getLanguageID:[self fetchLanguageCode]]
	                             BGSize:&bgSize
	                       TemplateInfo:&btInfo];

	if (res != QVET_ERR_NONE) {
		NSLog(@"[ENGINE]XYStoryboard getTemplateTextOriginalSize style GetBubbleTemplateInfo err=0x%lx", res);
		[pStyle Destory];
		*bHasBG = MTrue;
		return size;
	}
	NSString *defaultFormatText = [NSString stringWithUTF8String:btInfo.text.szDefaultText];

	MRECT rect = btInfo.rcRegion;
	size.width = (rect.right - rect.left) / 10000.0f * previewFrame.size.width;
	size.height = (rect.bottom - rect.top) / 10000.0f * previewFrame.size.height;
	if (btInfo.dwBGFormat != QVET_BUBBLE_BG_FORMAT_NONE)
		*bHasBG = MTrue;
	else
		*bHasBG = MFalse;

	*bIsAnimated = btInfo.bIsAnimated;
	*dwBGFormat = btInfo.dwBGFormat;
	res = [pStyle Destory];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getTemplateTextOriginalSize style Destory err=0x%lx", res);
	}
	return size;
}

//- (MultiTextInfo *)getMultiTemplateTextInfo:(NSString *)templateFilePath previewFrame:(CGRect)previewFrame inputTexts:(NSArray<NSString *> *)inputTexts caculateTemplateid:(MInt64 (^)(NSString *templateItemPath))caculateBlock {
//
//    MDWord dwLayoutMode = [self getLayoutMode:previewFrame.size.width height:previewFrame.size.height];
//    if (!templateFilePath) {
//        return nil;
//    }
//    MTChar *pTxtTemplate = (MTChar *)[templateFilePath UTF8String];
//    CXiaoYingStyle *pStyle = [[CXiaoYingStyle alloc] init];
//
//    MRESULT res = [pStyle Create:pTxtTemplate
//                    BGLayoutMode:dwLayoutMode
//                        SerialNo:MNull];
//    if (res != QVET_ERR_NONE) {
//        NSLog(@"[ENGINE]XYStoryboard getTemplateTextInfo style Create err=0x%lx", res);
//        [pStyle Destory];
//        return nil;
//    }
//
//    MSIZE bgSize = {0};
//    NSUInteger dwTextCount = 0;
//    bgSize.cx = previewFrame.size.width;
//    bgSize.cy = previewFrame.size.height;
//
//    //================================获取pBubbleArray============================================
//
//    CXiaoYingTextMulInfo *pcTextMulInfo = [pStyle GetTextMulInfo:bgSize];
//
//    __block NSMutableArray<TextInfo *> *textInfos = [NSMutableArray new];
//    //    __block NSArray <NSString *> *blockInputTexts = inputTexts;
//
//    [pcTextMulInfo.paramIDArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *_Nonnull stop) {
//      QVET_BUBBLE_TEMPLATE_INFO btInfo = {0};
//      [pStyle GetBubbleTemplateInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine]
//                         LanguageID:0
//                            ParamID:[obj integerValue]
//                             BGSize:&bgSize
//                       TemplateInfo:&btInfo];
//      NSString *defaultFormatText = [NSString stringWithUTF8String:btInfo.text.szDefaultText];
//      NSString *defaultFontName = [NSString stringWithUTF8String:btInfo.text.szFontName];
//
//      TextInfo *textInfo = [[TextInfo alloc] init];
//      textInfo.text = defaultFormatText;
//      textInfo.dwVersion = btInfo.dwVersion;
//      textInfo.textTemplateFilePath = templateFilePath;
//      //0x0900600000000012
//      textInfo.textTemplateID = caculateBlock(templateFilePath);
//      textInfo.textColor = [self colorWithHex:btInfo.text.clrText];
//      textInfo.duration = btInfo.dwMinDuration;
//      textInfo.clrText = btInfo.text.clrText;
//      if (textInfo.clrText == 0) {
//          textInfo.clrText = 0xFFFFFF;
//      }
//      if (inputTexts.count > idx)
//          textInfo.text = [inputTexts objectAtIndex:idx];
//      textInfo.dwBGFormat = btInfo.dwBGFormat;
//      textInfo.bIsAnimated = btInfo.bIsAnimated;
//      textInfo.previewDuration = btInfo.dwMinDuration;
//      textInfo.dwTextAlignment = btInfo.text.dwAlignment;
//      //    textInfo.fontName = fontName;
//      textInfo.bEnableEffect = MTrue;
//      textInfo.dwShadowColor = btInfo.text.dwShadowColor;
//      textInfo.fDShadowBlurRadius = btInfo.text.fDShadowBlurRadius;
//      textInfo.fDShadowXShift = btInfo.text.fDShadowYShift;
//      textInfo.fDShadowYShift = btInfo.text.fDShadowYShift;
//      textInfo.dwStrokeColor = btInfo.text.dwStrokeColor;
//      textInfo.fStrokeWPercent = btInfo.text.fStrokeWPercent;
//
//      //        if(nil == blockInputTexts){
//      //            if (self.textParserDelegate && [self.textParserDelegate respondsToSelector:@selector(onParseText:)]) {
//      //                blockInputText = [self.textParserDelegate onParseText:defaultFormatText];
//      //            }
//      //        }
//      //        textInfo.text = blockInputText;
//      textInfo.rcRegionRatio = btInfo.rcRegion;
//      MRECT rect = btInfo.rcRegion;
//      CGFloat finalRectLeft = previewFrame.origin.x + rect.left / 10000.0f * previewFrame.size.width;
//      CGFloat finalRectTop = previewFrame.origin.y + rect.top / 10000.0f * previewFrame.size.height;
//      CGFloat finalRectWidth = (rect.right - rect.left) / 10000.0f * previewFrame.size.width;
//      CGFloat finalRectHeight = (rect.bottom - rect.top) / 10000.0f * previewFrame.size.height;
//      textInfo.textRect = CGRectMake(finalRectLeft, finalRectTop, finalRectWidth, finalRectHeight);
//      [textInfos addObject:textInfo];
//    }];
//
//    AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleArray = (AMVE_BUBBLETEXT_SOURCE_TYPE *)MMemAlloc(MNull, sizeof(AMVE_BUBBLETEXT_SOURCE_TYPE) * textInfos.count);
//    if (pBubbleArray == MNull) {
//        return nil;
//    }
//
//    for (MDWord i = 0; i < textInfos.count; i++) {
//        AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = [self textInfoToBubbleSource:textInfos[i]];
//        pBubbleArray[i] = *pBubbleSource;
//    }
//
//    //================================计算字幕大小============================================
//    CVImageBufferRef cvImgBuf = nil;
//    NSString *pBubbleTemplate = templateFilePath;
//    CXiaoYingStoryBoardSession *stb = [self getStoryboardSession];
//    if (nil == stb) {
//        return nil;
//    }
//    MPOINT stbSize = {0};
//    [stb getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&stbSize];
//    MSIZE BGSize = {stbSize.x, stbSize.y};
//    AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = [self textInfoToBubbleSource:textInfos.firstObject];
//    XY_BUBBLE_MEASURE_RESULT BMR = {0};
//    res = [CXiaoYingStyle measureBubbleByTemplate:pBubbleTemplate
//                                           BGSize:&BGSize
//                                    bubbleTextSrc:pBubbleSource
//                                           result:&BMR];
//
//    if (res) {
//        NSLog(@"[ENGINE]measureBubbleByTemplate failed res=0x%lx", res);
//        [XYEditUtils freeBubbleSource:pBubbleSource];
//        return nil;
//    }
//
//    MSIZE finalSize = {0};
//    finalSize.cx = BMR.bubbleW;
//    finalSize.cy = BMR.bubbleH;
//    MDWord dwThumbPixelW = finalSize.cx * 2;
//    MDWord dwThumbPixelH = finalSize.cy * 2;
//
//    cvImgBuf = [self allocPBForBubbleThumb:dwThumbPixelW Height:dwThumbPixelH];
//
//    CVPixelBufferLockBaseAddress(cvImgBuf, 0);
//
//    //================================生成image=========================================
//
//    [pStyle CreateTextAnimationThumbnailHandle:[[XYEngine sharedXYEngine] getCXiaoYingEngine]
//                                          Path:templateFilePath
//                                 ThumbnailSize:(MSIZE){dwThumbPixelW, dwThumbPixelH}];
//    MHandle check = [[[XYEngine sharedXYEngine] getCXiaoYingEngine] hSessionContext];
//
//    res = [pStyle GetTextAnimationThumbnailHandle:pcTextMulInfo
//                                     BubbleSource:pBubbleArray
//                                         ThumbBuf:cvImgBuf];
//
//    if (res) {
//        CVPixelBufferUnlockBaseAddress(cvImgBuf, 0);
//        [XYEditUtils freeBubbleSource:pBubbleArray];
//        return nil;
//    }
//
//    MVoid *spriteData = CVPixelBufferGetBaseAddress(cvImgBuf);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//
//    CGContextRef context = CGBitmapContextCreate(spriteData, dwThumbPixelW, dwThumbPixelH, 8, 4 * dwThumbPixelW, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    CGImageRef newImage = CGBitmapContextCreateImage(context);
//    UIImage *image = [UIImage imageWithCGImage:newImage];
//    CVPixelBufferUnlockBaseAddress(cvImgBuf, 0);
//    CFRelease(newImage);
//    CFRelease(colorSpace);
//    CFRelease(context);
//    [self freePBForBubbleThumb:cvImgBuf];
//    [XYEditUtils freeBubbleSource:pBubbleArray];
//
//    [pStyle DestoryTextAnimationThumbnailHandle];
//    [pStyle Destory];
//    if (res) {
//        NSLog(@"[ENGINE]XYStoryboard getTemplateTextInfo style Destory err=0x%lx", res);
//    }
//
//    return image;
//}

- (TextInfo *)getTemplateTextInfo:(NSString *)templateFilePath
                     previewFrame:(CGRect)previewFrame
                        inputText:(NSString *)inputText {
	QVET_BUBBLE_TEMPLATE_INFO btInfo = {0};
	MDWord dwLayoutMode = [self getLayoutMode:previewFrame.size.width height:previewFrame.size.height];
	if (!templateFilePath) {
		return nil;
	}
	MTChar *pTxtTemplate = (MTChar *)[templateFilePath UTF8String];
	CXiaoYingStyle *pStyle = [[CXiaoYingStyle alloc] init];

	MRESULT res = [pStyle Create:pTxtTemplate
	                BGLayoutMode:dwLayoutMode
	                    SerialNo:MNull];
	if (res != QVET_ERR_NONE) {
		NSLog(@"[ENGINE]XYStoryboard getTemplateTextInfo style Create err=0x%lx", res);
		[pStyle Destory];
		return nil;
	}

	MSIZE bgSize = {0};
	bgSize.cx = previewFrame.size.width;
	bgSize.cy = previewFrame.size.height;

	res = [pStyle GetBubbleTemplateInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine]
	                         LanguageID:[NSNumber xy_getLanguageID:[self fetchLanguageCode]]
	                             BGSize:&bgSize
	                       TemplateInfo:&btInfo];

	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getTemplateTextInfo style GetBubbleTemplateInfo err=0x%lx", res);
	}
	if (res != QVET_ERR_NONE) {
		res = [pStyle Destory];
		NSLog(@"[ENGINE]XYStoryboard getTemplateTextInfo style Destory err=0x%lx", res);
		return nil;
	}

	NSString *defaultFormatText = [NSString stringWithUTF8String:btInfo.text.szDefaultText];
	//    NSString *fontName = [NSString stringWithUTF8String:btInfo.text.szFontName];

	TextInfo *textInfo = [[TextInfo alloc] init];
	textInfo.dwVersion = btInfo.dwVersion;
	textInfo.textTemplateFilePath = templateFilePath;
	textInfo.textColor = [self colorWithHex:btInfo.text.clrText];
	textInfo.duration = btInfo.dwMinDuration;
	textInfo.clrText = btInfo.text.clrText;
	if (textInfo.clrText == 0) {
		textInfo.clrText = 0xFFFFFF;
	}
	textInfo.dwBGFormat = btInfo.dwBGFormat;
	textInfo.bIsAnimated = btInfo.bIsAnimated;
	textInfo.previewDuration = btInfo.dwMinDuration;
	textInfo.dwTextAlignment = btInfo.text.dwAlignment;
	//    textInfo.fontName = fontName;
	textInfo.bEnableEffect = MTrue;
	textInfo.dwShadowColor = btInfo.text.dwShadowColor;
	textInfo.fDShadowBlurRadius = btInfo.text.fDShadowBlurRadius;
	textInfo.fDShadowXShift = btInfo.text.fDShadowXShift;
	textInfo.fDShadowYShift = btInfo.text.fDShadowYShift;
	textInfo.dwStrokeColor = btInfo.text.dwStrokeColor;
	textInfo.fStrokeWPercent = btInfo.text.fStrokeWPercent;

	if (nil == inputText) {
		if (self.textParserDelegate && [self.textParserDelegate respondsToSelector:@selector(onParseText:)]) {
			inputText = [self.textParserDelegate onParseText:defaultFormatText];
		}
	}
	textInfo.text = inputText;
	textInfo.rcRegionRatio = btInfo.rcRegion;
	MRECT rect = btInfo.rcRegion;
	CGFloat finalRectLeft = previewFrame.origin.x + rect.left / 10000.0f * previewFrame.size.width;
	CGFloat finalRectTop = previewFrame.origin.y + rect.top / 10000.0f * previewFrame.size.height;
	CGFloat finalRectWidth = (rect.right - rect.left) / 10000.0f * previewFrame.size.width;
	CGFloat finalRectHeight = (rect.bottom - rect.top) / 10000.0f * previewFrame.size.height;
	textInfo.textRect = CGRectMake(finalRectLeft, finalRectTop, finalRectWidth, finalRectHeight);
	[pStyle Destory];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getTemplateTextInfo style Destory err=0x%lx", res);
	}
	return textInfo;
}

- (AMVE_BUBBLETEXT_SOURCE_TYPE *)textInfoToBubbleSource:(TextInfo *)textInfo {
	AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = [XYEditUtils allocBubbleSource];
	if (![NSString xy_isEmpty:textInfo.text]) {
		MTChar *pszInput = (MTChar *)[textInfo.text UTF8String];
        if (MNull == pszInput) {
            pszInput = (MTChar *)[@" " UTF8String];
        }
		MStrCpy(pBubbleSource->pszText, pszInput);
	}
	pBubbleSource->clrBackground = 0;
	pBubbleSource->bHorReversal = MFalse;
	pBubbleSource->bVerReversal = MFalse;
	pBubbleSource->fRotateAngle = 0;
	pBubbleSource->dwTransparency = 100;
	pBubbleSource->llTemplateID = textInfo.textTemplateID;
	pBubbleSource->clrText = textInfo.clrText;
	pBubbleSource->rcRegionRatio.left = textInfo.rcRegionRatio.left;
	pBubbleSource->rcRegionRatio.top = textInfo.rcRegionRatio.top;
	pBubbleSource->rcRegionRatio.right = textInfo.rcRegionRatio.right;
	pBubbleSource->rcRegionRatio.bottom = textInfo.rcRegionRatio.bottom;
	pBubbleSource->bVerReversal = textInfo.bVerReversal;
	pBubbleSource->bHorReversal = textInfo.bHorReversal;
	pBubbleSource->dwTextAlignment = textInfo.dwTextAlignment;
	pBubbleSource->TextExtraEffect.bEnableEffect = textInfo.bEnableEffect;
	pBubbleSource->TextExtraEffect.dwShadowColor = textInfo.dwShadowColor;
	pBubbleSource->TextExtraEffect.fDShadowBlurRadius = textInfo.fDShadowBlurRadius;
	pBubbleSource->TextExtraEffect.fDShadowXShift = textInfo.fDShadowXShift;
	pBubbleSource->TextExtraEffect.fDShadowYShift = textInfo.fDShadowYShift;
	pBubbleSource->TextExtraEffect.dwStrokeColor = textInfo.dwStrokeColor;
	pBubbleSource->TextExtraEffect.fStrokeWPercent = textInfo.fStrokeWPercent;
	if (![NSString xy_isEmpty:textInfo.fontName]) {
		MStrCpy(pBubbleSource->pszAuxiliaryFont, textInfo.fontName.UTF8String);
	}
	return pBubbleSource;
}

- (AMVE_BUBBLETEXT_SOURCE_TYPE *)bubbleSourceWithTextTemplateID:(NSInteger)textTemplateID
                                                           text:(NSString *)text
                                                   textFontName:(NSString *)textFontName
                                                  textAlignment:(NSInteger)textAlignment
                                               textEnableEffect:(BOOL)textEnableEffect
                                               textShadowXShift:(CGFloat)textShadowXShift
                                               textShadowYShift:(CGFloat)textShadowYShift
                                              textStrokePercent:(CGFloat)textStrokePercent {
    AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = [XYEditUtils allocBubbleSource];
    if (![NSString xy_isEmpty:text]) {
        MTChar *pszInput = (MTChar *)[text UTF8String];
        if (MNull == pszInput) {
            pszInput = (MTChar *)[@" " UTF8String];
        }
        MStrCpy(pBubbleSource->pszText, pszInput);
    }
    pBubbleSource->clrBackground = 0;
    pBubbleSource->llTemplateID = textTemplateID;
    pBubbleSource->dwTextAlignment = textAlignment;
    pBubbleSource->TextExtraEffect.bEnableEffect = textEnableEffect?MTrue:MFalse;
    pBubbleSource->TextExtraEffect.fDShadowXShift = textShadowXShift;
    pBubbleSource->TextExtraEffect.fDShadowYShift = textShadowYShift;
    pBubbleSource->TextExtraEffect.fStrokeWPercent = textStrokePercent;
    if (![NSString xy_isEmpty:textFontName]) {
        MStrCpy(pBubbleSource->pszAuxiliaryFont, textFontName.UTF8String);
    }
    return pBubbleSource;
}



- (CVPixelBufferRef)allocPBForBubbleThumb:(size_t)w
                                   Height:(size_t)h {
	//由于引擎底层限制，字幕的thumbnail必须用这个函数来分配内存
	if (w <= 0 || h <= 0) {
		return NULL;
	}

	CVPixelBufferRef pb = NULL;
	void *baseAddr = NULL;
	size_t bytesPerRow = LINE_BYTES(w, 32);
	size_t totalBytes = bytesPerRow * h;
	CVReturn res = kCVReturnError;

	baseAddr = malloc(totalBytes);
	QVET_CHECK_POINTER_GOTO(baseAddr, kCVReturnAllocationFailed);

	res = CVPixelBufferCreateWithBytes(kCFAllocatorDefault, w, h, kCVPixelFormatType_32BGRA, baseAddr, bytesPerRow, NULL, NULL, NULL, &pb);
	QVET_CHECK_VALID_GOTO(res);

FUN_EXIT:
	if (res) {
		[self freePBForBubbleThumb:pb];
		pb = NULL;
	}
	return pb;
}

- (void)freePBForBubbleThumb:(CVPixelBufferRef)pb {
	if (!pb) {
		return;
	}

	CVPixelBufferLockBaseAddress(pb, 0);

	void *baseAddr = CVPixelBufferGetBaseAddress(pb);
	if (baseAddr) {
		free(baseAddr);
	}
	CVPixelBufferUnlockBaseAddress(pb, 0);
	CVPixelBufferRelease(pb);
}

- (UIImage *)getStickerThumb:(StickerInfo *)stickerInfo size:(CGSize)size {
   return [self getStickerThumb:stickerInfo];
}

- (UIImage *)getTextThumb:(TextInfo *)textInfo multiply:(int)multiply maxWidth:(int)maxWidth block:(void (^)(CGSize bubbleSize))block {
    if (!textInfo) {
        return nil;
    }
    CVImageBufferRef cvImgBuf = nil;
    MRESULT res = QVET_ERR_NONE;
    NSString *pBubbleTemplate = textInfo.textTemplateFilePath;
    CXiaoYingStoryBoardSession *stb = [self getStoryboardSession];
    if (nil == stb) {
        return nil;
    }
    
    MPOINT stbSize = {0};
    [stb getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&stbSize];
    MSIZE BGSize = {stbSize.x, stbSize.y};
    AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = [self textInfoToBubbleSource:textInfo];
    XY_BUBBLE_MEASURE_RESULT BMR = {0};
    res = [CXiaoYingStyle measureBubbleByTemplate:pBubbleTemplate
                                           BGSize:&BGSize
                                    bubbleTextSrc:pBubbleSource
                                           result:&BMR];
    if (res) {
        NSLog(@"[ENGINE]measureBubbleByTemplate failed res=0x%lx", res);
        [XYEditUtils freeBubbleSource:pBubbleSource];
        return nil;
    }
    
    MSIZE finalSize = {0};
    finalSize.cx = BMR.bubbleW;
    finalSize.cy = BMR.bubbleH;
    if (block) {
        //返回bubble size出去，外面要用到
        block(CGSizeMake(finalSize.cx, finalSize.cy));
    }
    MDWord dwThumbPixelW = finalSize.cx * multiply;
    MDWord dwThumbPixelH = finalSize.cy * multiply;
    
    CGFloat thumbRatio = 1.0;
    if (finalSize.cx > 0 && finalSize.cy > 0) {
        thumbRatio = (CGFloat)finalSize.cx / (CGFloat)finalSize.cy;
    }
    
    //获取字幕缩略图添加最大尺寸限制
    if (dwThumbPixelW > maxWidth) {
        dwThumbPixelW = maxWidth;
        dwThumbPixelH = dwThumbPixelW / thumbRatio;
    }
    
    if (dwThumbPixelH > maxWidth) {
        dwThumbPixelH = maxWidth;
        dwThumbPixelW = dwThumbPixelH * thumbRatio;
    }
    
    cvImgBuf = [self allocPBForBubbleThumb:dwThumbPixelW Height:dwThumbPixelH];
    if (!cvImgBuf) {
        [XYEditUtils freeBubbleSource:pBubbleSource];
        return nil;
    }
    CVPixelBufferLockBaseAddress(cvImgBuf, 0);
    MSIZE contentSize = {(MLong)dwThumbPixelW, (MLong)dwThumbPixelH};
    {
        CXiaoYingStyle *qStyle = [[CXiaoYingStyle alloc] init];
        CXiaoYingTextMulInfo *pMulInfo = MNull;
        AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleMulSource = MNull;
        AMVE_MUL_BUBBLETEXT_INFO *pcMulInfo = MNull;
        static MHandle hTextEngine = MNull;
        
        res = [qStyle Create:[pBubbleTemplate UTF8String] BGLayoutMode:0 SerialNo:nil];
        pMulInfo = [qStyle GetTextMulInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine] languageID:0x409 bgSize:BGSize];
        
        if (hTextEngine == MNull)
        {
            hTextEngine = [CXiaoYingStyle CreatEffectThumbnailEngine:[[XYEngine sharedXYEngine] getCXiaoYingEngine] bgSize:&BGSize];
        }
        pcMulInfo = [pMulInfo getMulInfo];
        pBubbleMulSource = (AMVE_BUBBLETEXT_SOURCE_TYPE *)MMemAlloc(MNull, pcMulInfo->dwTextCount * sizeof(AMVE_BUBBLETEXT_SOURCE_TYPE));
        for (MDWord i = 0; i < pcMulInfo->dwTextCount; i++)
        {
            pBubbleMulSource[i] = *pBubbleSource;
            pBubbleMulSource[i].dwParamID = pcMulInfo->pMulBTInfo[i].dwParamID;
        }
        res = [CXiaoYingStyle GetTextThumbnail:hTextEngine textCount:pcMulInfo->dwTextCount BubbleSource:pBubbleMulSource contentSize:&contentSize ThumbBuf:cvImgBuf timeStamp:pcMulInfo->dwPreviewPos];
        MMemFree(MNull, pBubbleMulSource);
        
    }
    NSLog(@"font Name for bubble:%s", pBubbleSource->pszAuxiliaryFont);
    /*
     res = [CXiaoYingStyle getBubbleThumbnailFromTemplate:[[XYEngine sharedXYEngine] getCXiaoYingEngine]
     BGSize:&BGSize
     bubbleTextSrc:pBubbleSource
     contentSize:&contentSize
     thumbBuf:cvImgBuf
     timeStamp:0];
     */    if (res) {
         CVPixelBufferUnlockBaseAddress(cvImgBuf, 0);
         [XYEditUtils freeBubbleSource:pBubbleSource];
         return nil;
     }
    
    MVoid *spriteData = CVPixelBufferGetBaseAddress(cvImgBuf);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(spriteData, dwThumbPixelW, dwThumbPixelH, 8, 4 * dwThumbPixelW, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef newImage = CGBitmapContextCreateImage(context);
    UIImage *image = [UIImage imageWithCGImage:newImage];
    CVPixelBufferUnlockBaseAddress(cvImgBuf, 0);
    CFRelease(newImage);
    CFRelease(colorSpace);
    CFRelease(context);
    [self freePBForBubbleThumb:cvImgBuf];
    [XYEditUtils freeBubbleSource:pBubbleSource];
    return image;
}

#pragma mark - Animated frame related
- (AnimatedFrameInfo *)getTemplateAnimatedFrameInfo:(NSString *)templateFilePath
                                       previewFrame:(CGRect)previewFrame {
	QVET_ANIMATED_FRAME_TEMPLATE_INFO atInfo = {0};
	MDWord dwLayoutMode = [self getLayoutMode:previewFrame.size.width height:previewFrame.size.height];
	if (!templateFilePath) {
		return nil;
	}
	MTChar *pTemplatePath = (MTChar *)[templateFilePath UTF8String];
	CXiaoYingStyle *pStyle = [[CXiaoYingStyle alloc] init];

	MRESULT res = [pStyle Create:pTemplatePath
	                BGLayoutMode:dwLayoutMode
	                    SerialNo:MNull];
	if (res != QVET_ERR_NONE) {
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard getTemplateAnimatedFrameInfo style Create err=0x%lx", res);
		}
		[pStyle Destory];
		return nil;
	}

	MSIZE bgSize = {0};
	bgSize.cx = previewFrame.size.width;
	bgSize.cy = previewFrame.size.height;
	res = [pStyle GetAnimatedFrameTemplateInfo:&bgSize TemplateInfo:&atInfo];

	if (res != QVET_ERR_NONE) {
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard getTemplateAnimatedFrameInfo style GetAnimatedFrameTemplateInfo err=0x%lx", res);
		}
		[pStyle Destory];
		return nil;
	}
	AnimatedFrameInfo *afInfo = [[AnimatedFrameInfo alloc] init];
	afInfo.xytFilePath = templateFilePath;
	afInfo.dwCurrentDuration = atInfo.dwDuration;
	afInfo.dwTotalDuration = atInfo.dwDuration;
	afInfo.rcDispRegion = atInfo.rcDispRegion;
	afInfo.bHasAudio = atInfo.bHasAudio;

	res = [pStyle Destory];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getTemplateAnimatedFrameInfo style Destroy err=0x%lx", res);
	}
	return afInfo;
}

- (AnimatedFrameInfo *)getStoryboardAnimatedFrameInfo:(CXiaoYingEffect *)effect {
	if (!effect) {
		return nil;
	}
	AnimatedFrameInfo *animatedFrameInfo = [[AnimatedFrameInfo alloc] init];

	MRESULT ret = QVET_ERR_NONE;

	AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
	mediaSrc.pSource = malloc(1000);
	ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSrc];

	//CHECK_VALID_RET_NIL(ret)
	MTChar *pszAnimatedFramePath = (MTChar *)mediaSrc.pSource;
	NSString *path = [NSString stringWithUTF8String:pszAnimatedFramePath];
	free(mediaSrc.pSource);
	animatedFrameInfo.xytFilePath = path;

	AMVE_POSITION_RANGE_TYPE effectRange;
	ret = [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&effectRange];
	animatedFrameInfo.startPos = effectRange.dwPos;
	animatedFrameInfo.dwCurrentDuration = effectRange.dwLen;

	return animatedFrameInfo;
}

- (MRESULT)setAnimatedFrame:(AnimatedFrameInfo *)animatedFrameInfo {
	if (!self.cXiaoYingStoryBoardSession) {
		return MERRP_APP;
	}
	if (!animatedFrameInfo) {
		return MERRP_APP;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	MRESULT ret = QVET_ERR_NONE;

	CXiaoYingEngine *pEngine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
	if (!pEngine)
		return QVET_ERR_APP_FAIL;

	CXiaoYingEffect *pEffect = [[CXiaoYingEffect alloc] init];
	ret = [pEffect Create:pEngine
	           EffectType:AMVE_EFFECT_TYPE_VIDEO_FRAME
	            TrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO
	              GroupID:GROUP_ANIMATED_FRAME
	              LayerID:(MFloat)LAYER_ID_ANIMATED_FRAME];
	CHECK_VALID_RET(ret);

	ret = [pStbDataClip insertEffect:pEffect];
	CHECK_VALID_RET(ret);

	MTChar *pszAnimatedFramePkg = (MTChar *)[animatedFrameInfo.xytFilePath UTF8String];
	AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
	mediaSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_FILE;
	mediaSrc.pSource = pszAnimatedFramePkg;
	mediaSrc.bIsTmpSrc = MFalse;
	ret = [pEffect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE
	              PropertyData:&mediaSrc];
	CHECK_VALID_RET(ret);

	AMVE_POSITION_RANGE_TYPE effectRange;
	effectRange.dwPos = animatedFrameInfo.startPos;
	effectRange.dwLen = animatedFrameInfo.dwCurrentDuration;
	ret = [pEffect setProperty:AMVE_PROP_EFFECT_RANGE
	              PropertyData:(MVoid *)&effectRange];
	CHECK_VALID_RET(ret);

	MRECT rcRegionRatio = animatedFrameInfo.rcDispRegion;
	ret = [pEffect setProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO
	              PropertyData:(MVoid *)&rcRegionRatio];
	CHECK_VALID_RET(ret);

	MFloat layerID = (MFloat)LAYER_ID_ANIMATED_FRAME;
	ret = [pEffect setProperty:AMVE_PROP_EFFECT_LAYER
	              PropertyData:&layerID];
	CHECK_VALID_RET(ret);

	[self setModified:YES];
	return ret;
}

#pragma mark - Paster(Sticker) related
- (StickerInfo *)getTemplateStickerInfo:(NSString *)templateFilePath previewFrame:(CGRect)previewFrame {
	//    NSString *path = [[TemplateDataMgr sharedInstance] getPathByID:llTemplateID];
	return [self getTemplateStickerInfoByPath:templateFilePath previewFrame:previewFrame];
}

- (StickerInfo *)getTemplateStickerInfoByPath:(NSString *)path previewFrame:(CGRect)previewFrame {
	if (![path hasPrefix:@"PHASSET:"] && ![path hasPrefix:@"ipod-library:"] && ![NSFileManager xy_fileExist:path])
		return nil;

	CXiaoYingEngine *engine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
	if (!engine)
		return nil;
	//    MInt64 llTemplateID = [[TemplateDataMgr sharedInstance] getIDByPath:path];
	QVET_ANIMATED_FRAME_TEMPLATE_INFO animatedFrameInfo = {0};
	MSIZE bgSize = {0};
	bgSize.cx = previewFrame.size.width;
	bgSize.cy = previewFrame.size.height;
	MRESULT res = QVET_ERR_NONE;
	res = [CXiaoYingUtils GetAnimatedFrameInfo:engine FrameFile:(MChar *)path.UTF8String BGSzie:&bgSize FrameInfo:&animatedFrameInfo];

	if (res) {
		NSLog(@"[ENGINE]GetAnimatedFrameInfo err=0x%lx", res);
	}
	StickerInfo *stickerInfo = [[StickerInfo alloc] init];

	//    while (animatedFrameInfo.dwDuration < 2000) {
	//        animatedFrameInfo.dwDuration = animatedFrameInfo.dwDuration*2;
	//    }
	MPOINT maxResolution = {800, 800};
	float ratio = (float)animatedFrameInfo.dwFrameWidth / (float)animatedFrameInfo.dwFrameHeight;
	if (MAX(animatedFrameInfo.dwFrameWidth, animatedFrameInfo.dwFrameHeight) > maxResolution.x) {
		if (animatedFrameInfo.dwFrameWidth > animatedFrameInfo.dwFrameHeight) {
			animatedFrameInfo.dwFrameWidth = maxResolution.x;
			animatedFrameInfo.dwFrameHeight = animatedFrameInfo.dwFrameWidth / ratio;
		} else {
			animatedFrameInfo.dwFrameHeight = maxResolution.x;
			animatedFrameInfo.dwFrameWidth = animatedFrameInfo.dwFrameHeight * ratio;
		}
	}

	stickerInfo.dwCurrentDuration = animatedFrameInfo.dwDuration;
	stickerInfo.dwDefaultDuration = animatedFrameInfo.dwDuration;
	stickerInfo.rcDispRegion = animatedFrameInfo.rcDispRegion;
	stickerInfo.rcRegionRatio = animatedFrameInfo.rcDispRegion;
	stickerInfo.dwFrameWidth = animatedFrameInfo.dwFrameWidth;
	stickerInfo.dwFrameHeight = animatedFrameInfo.dwFrameHeight;
	stickerInfo.xytFilePath = path;
	stickerInfo.bHasAudio = animatedFrameInfo.bHasAudio;
	stickerInfo.dwExamplePos = animatedFrameInfo.dwExamplePos;

	return stickerInfo;
}





#pragma mark - Mosaic related
- (StickerInfo *)getMosaicInfoByPath:(NSString *)path previewFrame:(CGRect)previewFrame {
    if (![path hasPrefix:@"PHASSET:"] && ![path hasPrefix:@"ipod-library:"] && ![NSFileManager xy_fileExist:path])
        return nil;
    
    CXiaoYingEngine *engine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
    if (!engine)
        return nil;
    //    MInt64 llTemplateID = [[TemplateDataMgr sharedInstance] getIDByPath:path];
    QVET_ANIMATED_FRAME_TEMPLATE_INFO animatedFrameInfo = {0};
    MSIZE bgSize = {0};
    bgSize.cx = previewFrame.size.width;
    bgSize.cy = previewFrame.size.height;
    MRESULT res = QVET_ERR_NONE;
    res = [CXiaoYingUtils GetAnimatedFrameInfo:engine FrameFile:(MChar *)path.UTF8String BGSzie:&bgSize FrameInfo:&animatedFrameInfo];
    
    if (res) {
        NSLog(@"[ENGINE]GetAnimatedFrameInfo err=0x%lx", res);
    }
    StickerInfo *stickerInfo = [[StickerInfo alloc] init];
    
    //    while (animatedFrameInfo.dwDuration < 2000) {
    //        animatedFrameInfo.dwDuration = animatedFrameInfo.dwDuration*2;
    //    }
    MPOINT maxResolution = {800, 800};
    float ratio = (float)animatedFrameInfo.dwFrameWidth / (float)animatedFrameInfo.dwFrameHeight;
    if (MAX(animatedFrameInfo.dwFrameWidth, animatedFrameInfo.dwFrameHeight) > maxResolution.x) {
        if (animatedFrameInfo.dwFrameWidth > animatedFrameInfo.dwFrameHeight) {
            animatedFrameInfo.dwFrameWidth = maxResolution.x;
            animatedFrameInfo.dwFrameHeight = animatedFrameInfo.dwFrameWidth / ratio;
        } else {
            animatedFrameInfo.dwFrameHeight = maxResolution.x;
            animatedFrameInfo.dwFrameWidth = animatedFrameInfo.dwFrameHeight * ratio;
        }
    }
    
    stickerInfo.dwCurrentDuration = animatedFrameInfo.dwDuration;
    stickerInfo.dwDefaultDuration = animatedFrameInfo.dwDuration;
    stickerInfo.rcDispRegion = animatedFrameInfo.rcDispRegion;
    stickerInfo.rcRegionRatio = animatedFrameInfo.rcDispRegion;
    stickerInfo.dwFrameWidth = animatedFrameInfo.dwFrameWidth;
    stickerInfo.dwFrameHeight = animatedFrameInfo.dwFrameHeight;
    stickerInfo.xytFilePath = path;
    stickerInfo.bHasAudio = animatedFrameInfo.bHasAudio;
    stickerInfo.dwExamplePos = animatedFrameInfo.dwExamplePos;
    
    return stickerInfo;
}

- (StickerInfo *)getStoryboardMosaicInfo:(CXiaoYingEffect *)effect {
    if (!effect) {
        return nil;
    }
    StickerInfo *stickerInfo = [[StickerInfo alloc] init];
    
    MRESULT ret = QVET_ERR_NONE;
    
    AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
    mediaSrc.pSource = malloc(1000);
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSrc];
    
    //CHECK_VALID_RET_NIL(ret)
    MTChar *pszStickerPath = (MTChar *)mediaSrc.pSource;
    NSString *path = [NSString stringWithUTF8String:pszStickerPath];
    free(mediaSrc.pSource);
    stickerInfo.xytFilePath = path;
    
    AMVE_POSITION_RANGE_TYPE effectRange;
    ret = [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&effectRange];
    stickerInfo.startPos = effectRange.dwPos;
    stickerInfo.dwCurrentDuration = effectRange.dwLen;
    
    MRECT regionRatio = {0};
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&regionRatio];
    stickerInfo.rcRegionRatio = regionRatio;
    
    MFloat fRotateAngle;
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
    stickerInfo.fRotateAngle = fRotateAngle;
    
    MBool bVerReversal, bHorReversal;
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_X_FLIP PropertyData:&bHorReversal];
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_Y_FLIP PropertyData:&bVerReversal];
    stickerInfo.bHorReversal = bHorReversal;
    stickerInfo.bVerReversal = bVerReversal;
    
    MFloat layerID;
    ret = [effect getProperty:AMVE_PROP_EFFECT_LAYER PropertyData:&layerID];
    stickerInfo.layerID = layerID;
    
    MBool isFrameMode = MFalse;
    ret = [effect getProperty:AMVE_PROP_EFFECT_IS_FRAME_MODE PropertyData:&isFrameMode];
    stickerInfo.isFrameMode = (isFrameMode == MTrue);
    
    MBool isStaticPicture = MFalse;
    ret = [effect getProperty:AMVE_PROP_EFFECT_FRAME_STATIC_PICTURE PropertyData:&isStaticPicture];
    stickerInfo.isStaticPicture = (isStaticPicture == MTrue);
    
    if ([stickerInfo.xytFilePath hasSuffix:@"0x0500000000300001.xyt"]) { //像素化
        MPOINT pStbSize = {0};
        MRESULT ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
        MWord hor_id = 1;
        MWord ver_id = 2;
        MFloat max_value;
        if (pStbSize.x > pStbSize.y) {//width > height
            max_value = pStbSize.x * VIVAVIDEO_MOSAIC_PIXEL_MAX_RATIO;
            QVET_EFFECT_PROPDATA propData = {hor_id,0};
            ret = [effect getProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&propData];
            stickerInfo.mosaicRatio = (propData.lValue * 1.0) / max_value;
        }else {
            max_value = pStbSize.y * VIVAVIDEO_MOSAIC_PIXEL_MAX_RATIO;
            QVET_EFFECT_PROPDATA propData = {ver_id,0};
            ret = [effect getProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&propData];
            stickerInfo.mosaicRatio = (propData.lValue * 1.0) / max_value;
        }
    }else {
        MFloat max_value = VIVAVIDEO_MOSAIC_GAUSSIAN_MAX_VALUE;
        MWord gaussian_id = 1;
        QVET_EFFECT_PROPDATA propData = {gaussian_id,0};
        ret = [effect getProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&propData];
        stickerInfo.mosaicRatio = (propData.lValue * 1.0) / max_value;
    }
    
    
    return stickerInfo;
}

- (CXiaoYingEffect *)setMosaic:(StickerInfo *)stickerInfo layerID:(MFloat)layerID groupID:(MDWord)groupID {
    if (!self.cXiaoYingStoryBoardSession) {
        return nil;
    }
    if (!stickerInfo) {
        return nil;
    }
    CXiaoYingClip *dataClip = [self.cXiaoYingStoryBoardSession getDataClip];
    MRESULT ret = QVET_ERR_NONE;
    
    CXiaoYingEngine *engine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
    if (!engine) {
        return nil;
    }
    
    //create sticker effect
    CXiaoYingEffect *effect = [[CXiaoYingEffect alloc] init];
    
    ret = [effect Create:engine EffectType:AMVE_EFFECT_TYPE_VIDEO_FRAME TrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:groupID LayerID:(MFloat)layerID];
    CHECK_VALID_RET_NIL(ret);
    
    //insert effect
    ret = [dataClip insertEffect:effect];
    CHECK_VALID_RET_NIL(ret);
    //set path
    MTChar *pszStickerPath = (MTChar *)[stickerInfo.xytFilePath UTF8String];
    AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
    mediaSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_FILE;
    mediaSrc.pSource = pszStickerPath;
    mediaSrc.bIsTmpSrc = MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSrc];
    CHECK_VALID_RET_NIL(ret);
    //set range
    AMVE_POSITION_RANGE_TYPE effectRange;
    effectRange.dwPos = stickerInfo.startPos;
    effectRange.dwLen = stickerInfo.dwCurrentDuration;
    ret = [effect setProperty:AMVE_PROP_EFFECT_RANGE
                 PropertyData:(MVoid *)&effectRange];
    CHECK_VALID_RET_NIL(ret);
    //set region ratio
    MRECT rcRegionRatio = stickerInfo.rcRegionRatio;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&rcRegionRatio];
    NSLog(@"region: %ld %ld %ld %ld", rcRegionRatio.top, rcRegionRatio.bottom, rcRegionRatio.left, rcRegionRatio.right);
    CHECK_VALID_RET_NIL(ret);
    //set layer
    ret = [effect setProperty:AMVE_PROP_EFFECT_LAYER
                 PropertyData:&layerID];
    CHECK_VALID_RET_NIL(ret);
    //set rotateAngle
    MFloat fRotateAngle = stickerInfo.fRotateAngle;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
    CHECK_VALID_RET_NIL(ret);
    //set x y flip
    MBool bVerReversal = stickerInfo.bVerReversal;
    MBool bHorReversal = stickerInfo.bHorReversal;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_X_FLIP PropertyData:&bHorReversal];
    CHECK_VALID_RET_NIL(ret);
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_Y_FLIP PropertyData:&bVerReversal];
    CHECK_VALID_RET_NIL(ret);
    
    MPOINT pStbSize = {0};
    ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
    CHECK_VALID_RET_NIL(ret);
    MSIZE size = {pStbSize.x, pStbSize.y};
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_BG_RESOLUTION
                 PropertyData:&size];
    CHECK_VALID_RET_NIL(ret);
    
    MBool isFrameMode = stickerInfo.isFrameMode ? MTrue : MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_IS_FRAME_MODE
                 PropertyData:&isFrameMode];
    CHECK_VALID_RET_NIL(ret);
    
    MBool isStaticPicture = stickerInfo.isStaticPicture ? MTrue : MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_FRAME_STATIC_PICTURE
                 PropertyData:&isStaticPicture];
    CHECK_VALID_RET_NIL(ret);
    
    MBool bMute = MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MUTE // 3. 设置当前 effect 是否为静音, bMute = MTrue 时画中画视频为静音, bMute = MFalse 时画中画视频有声音，声音的强度百分比由 AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT 来指定;
                 PropertyData:(MVoid *)&bMute];
    CHECK_VALID_RET_NIL(ret);
    
    MDWord volume = 0; // volume = 0, 表示该特效的声音强度为0, volue = 100 表示该effect 的强度为 100%;
    // 仅在 AMVE_PROP_EFFECT_AUDIO_FRAME_MUTE 对应设置的值为MFalse 时，设置
    ret = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT // 4. 设置当前 effect 是否为静音, bMute = MTrue 时画中画视频为静音, bMute = MFalse 时画中画视频有声音，声音的强度百分比由 AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT 来指定;
                 PropertyData:(MVoid *)&volume];
    CHECK_VALID_RET_NIL(ret);
    
    
//    effect = [dataClip getEffect:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:GROUP_ID_MOSAIC EffectIndex:0];
    QVET_TRAJECTORY_VALUE pvalues[1];
    QVET_TRAJECTORY_DATA data = {0};
    data.updateMode = QVET_TRAJECTORY_UPDATE_MODE_REPLACE;
    data.cnt = 1;
    data.capacity = data.cnt;
    data.value = &pvalues;
    
    for (int i = 0; i < data.cnt; i++) {
        pvalues[i].ts = stickerInfo.startPos;
        pvalues[i].rotation = stickerInfo.fRotateAngle;
        pvalues[i].region = stickerInfo.rcRegionRatio;
    }
    MRESULT res = [effect insertNewTrajectory:0 trData: &data];
    CHECK_VALID_RET_NIL(ret);
    
    [self setModified:YES];
    return effect;
}

- (MRESULT)updateMosaicInfo:(StickerInfo *)stickerInfo toEffect:(CXiaoYingEffect *)effect {
    MRESULT ret = QVET_ERR_NONE;
    //set path
    MTChar *pszStickerPath = (MTChar *)[stickerInfo.xytFilePath UTF8String];
    AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
    mediaSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_FILE;
    mediaSrc.pSource = pszStickerPath;
    mediaSrc.bIsTmpSrc = MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSrc];
    CHECK_VALID_RET_NIL(ret);
    //set region ratio
    MRECT rcRegionRatio = stickerInfo.rcRegionRatio;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&rcRegionRatio];
    NSLog(@"region: %ld %d %ld %ld", rcRegionRatio.top, rcRegionRatio.bottom, rcRegionRatio.left, rcRegionRatio.right);
    CHECK_VALID_RET(ret);
    //set rotateAngle
    MFloat fRotateAngle = stickerInfo.fRotateAngle;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
    CHECK_VALID_RET(ret);
    //set x y flip
    MBool bVerReversal = stickerInfo.bVerReversal;
    MBool bHorReversal = stickerInfo.bHorReversal;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_X_FLIP PropertyData:&bHorReversal];
    CHECK_VALID_RET(ret);
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_Y_FLIP PropertyData:&bVerReversal];
    CHECK_VALID_RET(ret);
    MPOINT pStbSize = {0};
    ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
    CHECK_VALID_RET(ret);
    MSIZE size = {pStbSize.x, pStbSize.y};
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_BG_RESOLUTION
                 PropertyData:&size];
    CHECK_VALID_RET(ret);
    
    QVET_TRAJECTORY_VALUE pvalues[1];
    QVET_TRAJECTORY_DATA data = {0};
    data.updateMode = QVET_TRAJECTORY_UPDATE_MODE_REPLACE;
    data.cnt = 1;
    data.capacity = data.cnt;
    data.value = &pvalues;
    
    for (int i = 0; i < data.cnt; i++) {
        pvalues[i].ts = stickerInfo.startPos;
        pvalues[i].rotation = stickerInfo.fRotateAngle;
        pvalues[i].region = stickerInfo.rcRegionRatio;
        if ([[XYEngine sharedXYEngine] getMetalEnable]) {
            MLong tmp = rcRegionRatio.top;
            pvalues[i].region.top = 10000.0 - pvalues[i].region.bottom;
            pvalues[i].region.bottom = 10000.0 - tmp;
        }
    }
    ret = [effect insertNewTrajectory:0 trData: &data];
    CHECK_VALID_RET_NIL(ret);
    
    //新修改
    if ([stickerInfo.xytFilePath hasSuffix:@"0x0500000000300001.xyt"]) { //像素化
        float resolutionRatio = (pStbSize.x * 1.0) / (pStbSize.y * 1.0);
        MDWord hor_id = 1;
        MDWord ver_id = 2;
        MFloat hor_value;
        MFloat ver_value;
        MFloat max_value;
        if (resolutionRatio > 1) { //width > height
            max_value = pStbSize.x * VIVAVIDEO_MOSAIC_PIXEL_MAX_RATIO;
            hor_value = max_value * stickerInfo.mosaicRatio;
            ver_value = (hor_value * 1.0) / resolutionRatio;
            
            if (ver_value < VIVAVIDEO_MOSAIC_PIXEL_MIN_VALUE) {
                ver_value = VIVAVIDEO_MOSAIC_PIXEL_MIN_VALUE;
                hor_value = ver_value * resolutionRatio;
            }
        }else {
            max_value = pStbSize.y * VIVAVIDEO_MOSAIC_PIXEL_MAX_RATIO;
            ver_value = max_value * stickerInfo.mosaicRatio;
            hor_value = (ver_value * 1.0) / resolutionRatio;
            
            if (hor_value < VIVAVIDEO_MOSAIC_PIXEL_MIN_VALUE) {
                hor_value = VIVAVIDEO_MOSAIC_PIXEL_MIN_VALUE;
                ver_value = hor_value * resolutionRatio;
            }
        }
        
        QVET_EFFECT_PROPDATA hor_propData = {hor_id,hor_value};
        ret = [effect setProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&hor_propData];
        
        QVET_EFFECT_PROPDATA ver_propData = {ver_id,ver_value};
        ret = [effect setProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&ver_propData];
    }else {
        MDWord hor_id = 1;
        MDWord ver_id = 2;
        MFloat max_value = VIVAVIDEO_MOSAIC_GAUSSIAN_MAX_VALUE;
        MFloat gaussian_value = stickerInfo.mosaicRatio * max_value;
        QVET_EFFECT_PROPDATA hor_propData = {hor_id,gaussian_value};
        ret = [effect setProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&hor_propData];
        
        QVET_EFFECT_PROPDATA ver_propData = {ver_id,gaussian_value};
        ret = [effect setProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&ver_propData];
    }
    
    
    [self setModified:YES];
    return ret;
}

#pragma mark - watermark related
- (CXiaoYingEffect *)setwatermarkInfo:(StickerInfo *)stickerInfo layerID:(MFloat)layerID groupID:(MDWord)groupID {
    if (!self.cXiaoYingStoryBoardSession) {
        return nil;
    }
    if (!stickerInfo) {
        return nil;
    }
    CXiaoYingClip *dataClip = [self.cXiaoYingStoryBoardSession getDataClip];
    MRESULT ret = QVET_ERR_NONE;
    
    CXiaoYingEngine *engine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
    if (!engine) {
        return nil;
    }
    //create sticker effect
    CXiaoYingEffect *effect = [[CXiaoYingEffect alloc] init];
    ret = [effect Create:engine EffectType:AMVE_EFFECT_TYPE_VIDEO_FRAME TrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:groupID LayerID:(MFloat)layerID];
    CHECK_VALID_RET_NIL(ret);
    //insert effect
    ret = [dataClip insertEffect:effect];
    CHECK_VALID_RET_NIL(ret);
    //set path
    MTChar *pszStickerPath = (MTChar *)[stickerInfo.xytFilePath UTF8String];
    AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
    mediaSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_FILE;
    mediaSrc.pSource = pszStickerPath;
    mediaSrc.bIsTmpSrc = MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSrc];
    CHECK_VALID_RET_NIL(ret);
    //set range
    AMVE_POSITION_RANGE_TYPE effectRange;
    effectRange.dwPos = 0;
    effectRange.dwLen = [self getDuration];
    ret = [effect setProperty:AMVE_PROP_EFFECT_RANGE
                 PropertyData:(MVoid *)&effectRange];
    CHECK_VALID_RET_NIL(ret);
    //set region ratio
    MRECT rcRegionRatio = stickerInfo.rcRegionRatio;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&rcRegionRatio];
    NSLog(@"region: %ld %ld %ld %ld", rcRegionRatio.top, rcRegionRatio.bottom, rcRegionRatio.left, rcRegionRatio.right);
    CHECK_VALID_RET_NIL(ret);
    //set layer
    ret = [effect setProperty:AMVE_PROP_EFFECT_LAYER
                 PropertyData:&layerID];
    CHECK_VALID_RET_NIL(ret);
    //set rotateAngle
    MFloat fRotateAngle = stickerInfo.fRotateAngle;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
    CHECK_VALID_RET_NIL(ret);
    //set x y flip
    MBool bVerReversal = stickerInfo.bVerReversal;
    MBool bHorReversal = stickerInfo.bHorReversal;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_X_FLIP PropertyData:&bHorReversal];
    CHECK_VALID_RET_NIL(ret);
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_Y_FLIP PropertyData:&bVerReversal];
    CHECK_VALID_RET_NIL(ret);
    
    MPOINT pStbSize = {0};
    ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
    CHECK_VALID_RET_NIL(ret);
    MSIZE size = {pStbSize.x, pStbSize.y};
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_BG_RESOLUTION
                 PropertyData:&size];
    CHECK_VALID_RET_NIL(ret);
    
    MBool isFrameMode = stickerInfo.isFrameMode ? MTrue : MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_IS_FRAME_MODE
                 PropertyData:&isFrameMode];
    CHECK_VALID_RET_NIL(ret);
    
    MBool isStaticPicture = stickerInfo.isStaticPicture ? MTrue : MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_FRAME_STATIC_PICTURE
                 PropertyData:&isStaticPicture];
    CHECK_VALID_RET_NIL(ret);
    
    MBool bMute = MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MUTE // 3. 设置当前 effect 是否为静音, bMute = MTrue 时画中画视频为静音, bMute = MFalse 时画中画视频有声音，声音的强度百分比由 AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT 来指定;
                 PropertyData:(MVoid *)&bMute];
    CHECK_VALID_RET_NIL(ret);
    
    MDWord volume = 0; // volume = 0, 表示该特效的声音强度为0, volue = 100 表示该effect 的强度为 100%;
    // 仅在 AMVE_PROP_EFFECT_AUDIO_FRAME_MUTE 对应设置的值为MFalse 时，设置
    ret = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT // 4. 设置当前 effect 是否为静音, bMute = MTrue 时画中画视频为静音, bMute = MFalse 时画中画视频有声音，声音的强度百分比由 AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT 来指定;
                 PropertyData:(MVoid *)&volume];
    CHECK_VALID_RET_NIL(ret);
    
    //set alpha
    MFloat falpha = stickerInfo.alpha;
    ret = [effect setProperty:AMVE_PROP_EFFECT_BLEND_ALPHA PropertyData:&falpha];
    CHECK_VALID_RET_NIL(ret);
    
    [self setModified:YES];
    return effect;
}

#pragma mark - Theme related

- (MRESULT)setTheme:(NSString *)pNSPath {
	if (!self.cXiaoYingStoryBoardSession) {
		return MERRP_APP;
	}
	[self setModified:YES];
	g_bThemeApplying = MTrue;
	MRESULT res = QVET_ERR_NONE;
	MBool bAutoApplyTheme = MTrue;
	MTChar *pszThemePkg = (MTChar *)[pNSPath UTF8String];
	QVET_CHECK_POINTER_GOTO(pszThemePkg, QVET_ERR_APP_FILE_OPEN);

	QVET_CHECK_POINTER_GOTO(self.cXiaoYingStoryBoardSession, QVET_ERR_APP_INVALID_PARAM);

	res = [self.cXiaoYingStoryBoardSession setProperty:AMVE_PROP_STORYBOARD_AUTO_APPLY_THEME
	                                             Value:&bAutoApplyTheme];
	QVET_CHECK_VALID_GOTO(res);

	res = [self.cXiaoYingStoryBoardSession setThemeOperationHandler:self];
	QVET_CHECK_VALID_GOTO(res);

	res = [self.cXiaoYingStoryBoardSession applyTheme:pszThemePkg
	                              SessionStateHandler:self];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard applyTheme err=0x%lx", res);
	}
	QVET_CHECK_VALID_GOTO(res);

	while (g_bThemeApplying) {
		[NSThread sleepForTimeInterval:0.05];
	}

FUN_EXIT:

	return res;
}

- (MInt64)getThemeID {
	MInt64 themeID = {0};
	MRESULT res = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_THEME_ID Value:&themeID];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getThemeID err=0x%lx", res);
	}
	return themeID;
}

- (NSString *)getThemePath {
    MTChar *pThemePathChar = (MTChar *)malloc(AMVE_MAXPATH);
    [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_THEME_TEMPLATE Value:pThemePathChar];
    NSString *pThemePath = pThemePathChar == MNull ? @"" : [NSString stringWithUTF8String:pThemePathChar];
    return pThemePath;
}

//AMVE_PROP_STORYBOARD_THEME_COVER or AMVE_PROP_STORYBOARD_THEME_BACK_COVER
- (CXiaoYingCover *)getCover:(MDWord)property {
	if (!self.cXiaoYingStoryBoardSession) {
		return nil;
	}

	MHandle hClip = MNull;
	MRESULT res = [self.cXiaoYingStoryBoardSession getProperty:property Value:(MVoid *)&hClip];
	if (res == QVET_ERR_NONE && hClip != MNull) {
		CXiaoYingCover *cover = [[CXiaoYingCover alloc] init];
		res = [cover Init:hClip];
		if (res == QVET_ERR_NONE) {
			return cover;
		} else {
			cover = nil;
		}
	}
	return nil;
}

- (MDWord)getCoverDuration:(CXiaoYingCover *)cover {
	if (!cover) {
		return 0;
	}
    AMVE_POSITION_RANGE_TYPE range = [self getClipTrimRangeByClip:cover];
	return range.dwLen;
}

- (MDWord)getCoverTitleIndex:(CXiaoYingCover *)cover
                        time:(MDWord)dwTime {
	if (!cover) {
		return -1;
	}
	MDWord count = 0;
	MRESULT res = [cover GetTitleCount:&count];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard getCoverTitleIndex GetTitleCount err=0x%lx", res);
		return -1;
	}
	for (int i = 0; i < count; i++) {
		QVET_COVER_TITLE_INFO coverTitleInfo = {0};
		res = [cover GetTitleDefaultInfo:i LanguageID:[NSNumber xy_getLanguageID:[self fetchLanguageCode]] TitleInfo:&coverTitleInfo];
		if (!res && dwTime >= coverTitleInfo.dwTextStart && dwTime <= coverTitleInfo.dwTextEnd) {
			return i;
		}
	}
	return -1;
}

- (TextInfo *)getCoverTextInfo:(CXiaoYingCover *)cover
                    titleIndex:(MDWord)dwTitleIndex
                     viewFrame:(CGRect)viewFrame {
	if (!cover) {
		return nil;
	}
	MDWord count = 0;
	[cover GetTitleCount:&count];
	if (dwTitleIndex >= count) {
		return nil;
	}

	MFloat layerID = 0;
	[cover GetTitleLayerID:dwTitleIndex LayerIDPtr:&layerID];
	AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = [XYEditUtils allocBubbleSource];
	[cover GetTitle:dwTitleIndex BubbleText:pBubbleSource];
	MRECT rect = pBubbleSource->rcRegionRatio;
	MCOLORREF colorRef = pBubbleSource->clrText;
	NSString *text = pBubbleSource->pszText == MNull ? @"" : [NSString stringWithUTF8String:pBubbleSource->pszText];
	TextInfo *textInfo = [[TextInfo alloc] init];

	MRECT innerRect = {0};
	innerRect.left = 0; //viewFrame.origin.x;
	innerRect.top = 0;  //viewFrame.origin.y;
	innerRect.right = innerRect.left + viewFrame.size.width;
	innerRect.bottom = innerRect.top + viewFrame.size.height;

	MLong innerRectLeft = innerRect.left;
	MLong innerRectTop = innerRect.top;
	MLong innerRectWidth = (innerRect.right - innerRect.left);
	MLong innerRectHeight = (innerRect.bottom - innerRect.top);

	CGFloat finalRectLeft = innerRectLeft + rect.left / 10000.0f * innerRectWidth;
	CGFloat finalRectTop = innerRectTop + rect.top / 10000.0f * innerRectHeight;
	CGFloat finalRectWidth = (rect.right - rect.left) / 10000.0f * innerRectWidth;
	CGFloat finalRectHeight = (rect.bottom - rect.top) / 10000.0f * innerRectHeight;

	textInfo.textRect = CGRectMake(finalRectLeft, finalRectTop, finalRectWidth, finalRectHeight);

	textInfo.text = text;
	textInfo.textColor = [self colorWithHex:colorRef];
	textInfo.clrText = colorRef;
	textInfo.textTemplateID = pBubbleSource->llTemplateID;
	[XYEditUtils freeBubbleSource:pBubbleSource];

	QVET_COVER_TITLE_INFO coverTitleInfo = {0};
	MRESULT res = [cover GetTitleDefaultInfo:dwTitleIndex LanguageID:[NSNumber xy_getLanguageID:[self fetchLanguageCode]] TitleInfo:&coverTitleInfo];
	if (res) {
		NSLog(@"[Engine]getCoverTextInfo GetTitleDefaultInfo fialed 0x%lx", res);
	} else {
		textInfo.startPosition = coverTitleInfo.dwTextStart;
		textInfo.duration = coverTitleInfo.dwTextEnd - coverTitleInfo.dwTextStart;
	}

	return textInfo;
}


- (void)updateCoverText:(CXiaoYingCover *)cover
               textInfo:(TextInfo *)textInfo
                   text:(NSString *)text
             titleIndex:(MDWord)dwTitleIndex {
	if (!cover) {
		return;
	}
	AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = MNull;
	AMVE_VIDEO_INFO_TYPE videoInfo = [self getVideoInfo];
	MSIZE bgSize = {0};
	MRESULT res = QVET_ERR_NONE;

	bgSize.cx = videoInfo.dwFrameWidth;
	bgSize.cy = videoInfo.dwFrameHeight;
	pBubbleSource = [XYEditUtils allocBubbleSource];
	if (MNull == pBubbleSource)
		return;
	res = [self prepareTextSource:pBubbleSource
	                   TemplateId:textInfo.textTemplateID
	         TextTemplateFilePath:textInfo.textTemplateFilePath
	                       BGSize:&bgSize
	                   TextString:text];
	if (res) {
		NSLog(@"[ENGINE]updateCoverText prepareTextSource err=0x%lx", res);
	}
	if (res == QVET_ERR_NONE) {
		res = [cover SetTitle:dwTitleIndex BubbleText:pBubbleSource];
	}
	if (res) {
		NSLog(@"[ENGINE]updateCoverText SetTitle err=0x%lx", res);
	}
	[XYEditUtils freeBubbleSource:pBubbleSource];
}

- (void)updateStoryboardText:(CXiaoYingEffect *)effect
                    textInfo:(TextInfo *)textInfo
                        text:(NSString *)text {
	if (!effect) {
		return;
	}
	AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = MNull;
	AMVE_VIDEO_INFO_TYPE videoInfo = [self getVideoInfo];
	MSIZE bgSize = {0};
	MRESULT res = QVET_ERR_NONE;

	bgSize.cx = videoInfo.dwFrameWidth;
	bgSize.cy = videoInfo.dwFrameHeight;
	pBubbleSource = [XYEditUtils allocBubbleSource];
	if (MNull == pBubbleSource)
		return;
	res = [self prepareTextSource:pBubbleSource
	                   TemplateId:textInfo.textTemplateID
	         TextTemplateFilePath:textInfo.textTemplateFilePath
	                       BGSize:&bgSize
	                   TextString:text];
	if (res == QVET_ERR_NONE) {
		AMVE_MEDIA_SOURCE_TYPE mediaSource = {0};
		mediaSource.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_BUBBLETEXT;
		mediaSource.pSource = pBubbleSource;
		mediaSource.bIsTmpSrc = MTrue;
		[effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSource];
		[effect setProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&pBubbleSource->rcRegionRatio];
	} else {
		NSLog(@"[ENGINE]XYStoryboard updateStoryboardText err=0x%lx", res);
	}
	[XYEditUtils freeBubbleSource:pBubbleSource];
}

- (NSMutableArray *)getAllThemeTextInfosWithViewFrame:(CGRect)viewFrame {
	NSMutableArray *themeTextInfos = [NSMutableArray array];
	CXiaoYingCover *frontCover = [self getCover:AMVE_PROP_STORYBOARD_THEME_COVER];
	MDWord frontCoverTitleCount = 0;
	MRESULT res = [frontCover GetTitleCount:&frontCoverTitleCount];
	for (int i = 0; i < frontCoverTitleCount; i++) {
		TextInfo *textInfo = [self getCoverTextInfo:frontCover titleIndex:i viewFrame:viewFrame];
		if (textInfo) {
			textInfo.themeTextType = ThemeTextTypeFrontCover;
			textInfo.themeTextSubIndex = i;
			[themeTextInfos addObject:textInfo];
		}
	}

	MDWord storyboardThemeTextEffectCount = [self getEffectCount:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_THEME_TEXT_FRAME];
	for (int i = 0; i < storyboardThemeTextEffectCount; i++) {
		CXiaoYingEffect *effect = [self getStoryboardEffectByIndex:i dwTrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_THEME_TEXT_FRAME];
		TextInfo *textInfo = [self getStoryboardTextInfo:effect];
		if (textInfo) {
			textInfo.themeTextType = ThemeTextTypeStoryboard;
			textInfo.themeTextSubIndex = i;
			[themeTextInfos addObject:textInfo];
		}
	}

	MDWord storyboardAnimThemeTextEffectCount = [self getEffectCount:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_ID_THEME_TEXT_ANIMATION];
	for (int i = 0; i < storyboardAnimThemeTextEffectCount; i++) {
		CXiaoYingEffect *effect = [self getStoryboardEffectByIndex:i dwTrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_ID_THEME_TEXT_ANIMATION];
		TextInfo *textInfo = [self getStoryboardTextInfo:effect];
		if (textInfo) {
			textInfo.themeTextType = ThemeTextTypeStoryboardAnim;
			textInfo.themeTextSubIndex = i;
			[themeTextInfos addObject:textInfo];
		}
	}

	CXiaoYingCover *backCover = [self getCover:AMVE_PROP_STORYBOARD_THEME_BACK_COVER];
	MDWord backCoverTitleCount = 0;
	res = [backCover GetTitleCount:&backCoverTitleCount];
	for (int i = 0; i < backCoverTitleCount; i++) {
		TextInfo *textInfo = [self getCoverTextInfo:backCover titleIndex:i viewFrame:viewFrame];
		if (textInfo) {
			textInfo.startPosition = [self getDuration] - textInfo.duration;
			textInfo.themeTextType = ThemeTextTypeBackCover;
			textInfo.themeTextSubIndex = i;
			[themeTextInfos addObject:textInfo];
		}
	}

	return themeTextInfos;
}

- (CXiaoYingEffect *)setThemeTextWithTextInfo:(TextInfo *)textInfo {
	CXiaoYingEffect *effect = nil;
	if (textInfo.themeTextType == ThemeTextTypeFrontCover) {
		CXiaoYingCover *frontCover = [self getCover:AMVE_PROP_STORYBOARD_THEME_COVER];
		[self updateCoverText:frontCover textInfo:textInfo text:textInfo.text titleIndex:textInfo.themeTextSubIndex];
		effect = [frontCover getTitleEffect:textInfo.themeTextSubIndex];
	} else if (textInfo.themeTextType == ThemeTextTypeBackCover) {
		CXiaoYingCover *backCover = [self getCover:AMVE_PROP_STORYBOARD_THEME_BACK_COVER];
		[self updateCoverText:backCover textInfo:textInfo text:textInfo.text titleIndex:textInfo.themeTextSubIndex];
		effect = [backCover getTitleEffect:textInfo.themeTextSubIndex];
	} else if (textInfo.themeTextType == ThemeTextTypeStoryboard) {
		effect = [self getStoryboardEffectByIndex:textInfo.themeTextSubIndex dwTrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_THEME_TEXT_FRAME];
		[self updateStoryboardText:effect textInfo:textInfo text:textInfo.text];
	} else if (textInfo.themeTextType == ThemeTextTypeStoryboardAnim) {
		effect = [self getStoryboardEffectByIndex:textInfo.themeTextSubIndex dwTrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO groupId:GROUP_ID_THEME_TEXT_ANIMATION];
		[self updateStoryboardText:effect textInfo:textInfo text:textInfo.text];
	}
	return effect;
}

#pragma mark - AMVEThemeOptDelegate

- (MRESULT)AMVEThemeOperationCallBack:(AMVE_THEME_OPERATE_TYPE *)pThemeOp {
	if (!pThemeOp)
		return QVET_ERR_APP_INVALID_PARAM;

	if (QVET_THEME_OP_TYPE_ADD_COVER == pThemeOp->dwOperateType) {
		return [self prepareCoverText:pThemeOp];
	} else if (QVET_THEME_OP_TYPE_ADD_TEXT == pThemeOp->dwOperateType) {
		return [self prepareStoryboardText:pThemeOp];
	}
	return QVET_ERR_NONE;
}

- (MRECT)caculateTextRect:(CGSize)actualTextSize
                videoSize:(MSIZE *)videoSize
                  maxRect:(MRECT)maxRect {
	if (videoSize->cx <= 0 || videoSize->cy <= 0) {
		return maxRect;
	}

	int textX = videoSize->cx * maxRect.left / 10000.0f;
	int textY = videoSize->cy * maxRect.top / 10000.0f;
	int textHeight = videoSize->cy * maxRect.bottom / 10000.0f - textY;
	int textWidth = videoSize->cx * maxRect.right / 10000.0f - textX;
	int textCenterX = textX + textWidth / 2;
	int textCenterY = textY + textHeight / 2;

	textX = textCenterX - actualTextSize.width / 2;
	textY = textCenterY - actualTextSize.height / 2;
	textWidth = actualTextSize.width;
	textHeight = actualTextSize.height;
	MRECT mrect;
	mrect.left = textX * 10000.0f / videoSize->cx;
	mrect.top = textY * 10000.0f / videoSize->cy;
	mrect.right = (textX + textWidth) * 10000.0f / videoSize->cx;
	mrect.bottom = (textY + textHeight) * 10000.0f / videoSize->cy;
	return mrect;
}

- (MRESULT)prepareTextSource:(AMVE_BUBBLETEXT_SOURCE_TYPE *)pBubbleSource
                  TemplateId:(UInt64)templateId
        TextTemplateFilePath:(NSString *)templateFilePath
                      BGSize:(MSIZE *)pBGSize
                  TextString:(NSString *)szText {
	MRESULT res = QVET_ERR_NONE;
	QVET_BUBBLE_TEMPLATE_INFO btInfo = {0};

	if (MNull == pBubbleSource)
		return -1;
	MDWord dwLayoutMode = [self getLayoutMode:pBGSize->cx height:pBGSize->cy];
	if (!templateFilePath) {
		return -1;
	}
	MTChar *pTxtTemplate = (MTChar *)[templateFilePath UTF8String];
	CXiaoYingStyle *pStyle = [[CXiaoYingStyle alloc] init];

	res = [pStyle Create:pTxtTemplate
	        BGLayoutMode:dwLayoutMode
	            SerialNo:MNull];
	if (res != QVET_ERR_NONE) {
		NSLog(@"[ENGINE]XYStoryboard prepareTextSource style Create err=0x%lx", res);
		[pStyle Destory];
		return -1;
	}
	res = [pStyle GetBubbleTemplateInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine]
	                         LanguageID:[NSNumber xy_getLanguageID:[self fetchLanguageCode]]
	                             BGSize:pBGSize
	                       TemplateInfo:&btInfo];

	if (res != QVET_ERR_NONE) {
		[pStyle Destory];
		return -1;
	}

	NSString *defaultFormatText = [NSString stringWithUTF8String:btInfo.text.szDefaultText];
	NSString *inputText = MNull;

		if (self.textParserDelegate && [self.textParserDelegate respondsToSelector:@selector(onParseText:)]) {
			inputText = [self.textParserDelegate onParseText:defaultFormatText];
        } else if ([self.textDataSourceDelegate respondsToSelector:@selector(textPrepare:)]) {
            inputText = [XYDefaultParseThemeText parse:defaultFormatText delegate:self.textDataSourceDelegate];
        } else {
            inputText = [XYDefaultParseThemeText  parseText:defaultFormatText];
        }

	[pStyle Destory];
	if (res != QVET_ERR_NONE)
		return -1;

	if (![NSString xy_isEmpty:inputText]) {
		MTChar *pszInput = (MTChar *)[inputText UTF8String];
        if (MNull == pszInput) {
            pszInput = (MTChar *)[@" " UTF8String];
        }
		MStrCpy(pBubbleSource->pszText, pszInput);
	}
	pBubbleSource->clrBackground = 0;
	pBubbleSource->bHorReversal = MFalse;
	pBubbleSource->bVerReversal = MFalse;
	pBubbleSource->fRotateAngle = 0;
	pBubbleSource->dwTransparency = 100;
	pBubbleSource->llTemplateID = templateId;
	pBubbleSource->clrText = btInfo.text.clrText;

	XY_BUBBLE_MEASURE_RESULT BMR = {0};
	res = [CXiaoYingStyle measureBubbleByTemplate:templateFilePath
	                                       BGSize:pBGSize
	                                bubbleTextSrc:pBubbleSource
	                                       result:&BMR];

	MRECT mrect = [self caculateTextRect:CGSizeMake(BMR.bubbleW, BMR.bubbleH) videoSize:pBGSize maxRect:btInfo.rcRegion];
	pBubbleSource->rcRegionRatio.left = mrect.left;
	pBubbleSource->rcRegionRatio.top = mrect.top;
	pBubbleSource->rcRegionRatio.right = mrect.right;
	pBubbleSource->rcRegionRatio.bottom = mrect.bottom;

	return QVET_ERR_NONE;
}

- (MRESULT)prepareCoverText:(AMVE_THEME_OPERATE_TYPE *)pThemeOp {
	NSLog(@"prepareCoverText<---");
	MRESULT res = QVET_ERR_NONE;
	AMVE_VIDEO_INFO_TYPE videoInfo = [self getVideoInfo];

	MSIZE bgSize;
	bgSize.cx = videoInfo.dwFrameWidth;
	bgSize.cy = videoInfo.dwFrameHeight;
	QVET_THEME_ADD_COVER_DATA *pAddCoverOp = (QVET_THEME_ADD_COVER_DATA *)pThemeOp->pOperateData;

	if (pThemeOp->bOperatorFinish) {
		//free the text source.
		[self freeTextSource];
	} else if (pAddCoverOp && pAddCoverOp->pText) {
		[self allocTextSource:pAddCoverOp->dwTextCount];
		for (int i = 0; i < pAddCoverOp->dwTextCount; i++) {
			AMVE_MEDIA_SOURCE_TYPE *pMediaSrc = pAddCoverOp->pText[i].pTextSource;
			if (pMediaSrc) {
				NSString *path = nil;
				if (self.templateDelegate && [self.templateDelegate respondsToSelector:@selector(onGetTemplateFilePathWithID:)]) {
					path = [self.templateDelegate onGetTemplateFilePathWithID:pAddCoverOp->pText[i].llTemplateID];
				}
				res = [self prepareTextSource:(self.pTxtSrc + i)
				                   TemplateId:pAddCoverOp->pText[i].llTemplateID
				         TextTemplateFilePath:path
				                       BGSize:&bgSize
				                   TextString:nil];
				if (res != QVET_ERR_NONE)
					continue;
				pMediaSrc->dwSrcType = AMVE_MEDIA_SOURCE_TYPE_BUBBLETEXT;
				pMediaSrc->pSource = self.pTxtSrc + i;
				pMediaSrc->bIsTmpSrc = MTrue;
			}
		}
	}
	NSLog(@"prepareCoverText--->");
	return res;
}

- (MRESULT)prepareStoryboardText:(AMVE_THEME_OPERATE_TYPE *)pThemeOp {
	NSLog(@"prepareStoryboardText<---");
	MRESULT res = QVET_ERR_NONE;
	AMVE_VIDEO_INFO_TYPE videoInfo = [self getVideoInfo];

	MSIZE bgSize;
	bgSize.cx = videoInfo.dwFrameWidth;
	bgSize.cy = videoInfo.dwFrameHeight;
	QVET_THEME_ADD_TEXT_DATA *pAddTextOp = (QVET_THEME_ADD_TEXT_DATA *)pThemeOp->pOperateData;

	if (pThemeOp->bOperatorFinish) {
		//free the text source.
		[self freeTextSource];
	} else if (pAddTextOp && pAddTextOp->pText) {
		pThemeOp->dwEffectTrackType = AMVE_EFFECT_TRACK_TYPE_VIDEO;
		pThemeOp->dwEffectGroupID = GROUP_THEME_TEXT_FRAME;
		[self allocTextSource:pAddTextOp->dwTextCount];
		for (int i = 0; i < pAddTextOp->dwTextCount; i++) {
			AMVE_MEDIA_SOURCE_TYPE *pMediaSrc = pAddTextOp->pText[i].pTextSource;
			if (pMediaSrc) {
				NSString *path = nil;
				if (self.templateDelegate && [self.templateDelegate respondsToSelector:@selector(onGetTemplateFilePathWithID:)]) {
					path = [self.templateDelegate onGetTemplateFilePathWithID:pAddTextOp->pText[i].llTemplateID];
				}

				res = [self prepareTextSource:(self.pTxtSrc + i)
				                   TemplateId:pAddTextOp->pText[i].llTemplateID
				         TextTemplateFilePath:path
				                       BGSize:&bgSize
				                   TextString:nil];
				if (res != QVET_ERR_NONE)
					continue;
				pMediaSrc->dwSrcType = AMVE_MEDIA_SOURCE_TYPE_BUBBLETEXT;
				pMediaSrc->pSource = self.pTxtSrc + i;
				pMediaSrc->bIsTmpSrc = MTrue;
			}
		}
	}
	NSLog(@"prepareStoryboardText--->");
	return res;
}

- (int)getLayoutMode:(int)width height:(int)height {
	float r0, r1, r2;
	int mode = QVTP_LAYOUT_MODE_W4_H3;
	if (width == 0 || height == 0)
		return mode;
	if (width == height)
		return QVTP_LAYOUT_MODE_W1_H1;
	r0 = (float)width / height;
	if (width > height) {
		r1 = r0 - (float)4 / 3;
		r2 = r0 - (float)16 / 9;
		if (r1 < 0)
			r1 = -r1;
		if (r2 < 0)
			r2 = -r2;
		if (r1 < r2)
			mode = QVTP_LAYOUT_MODE_W4_H3;
		else
			mode = QVTP_LAYOUT_MODE_W16_H9;
	} else {
		r1 = r0 - (float)3 / 4;
		r2 = r0 - (float)9 / 16;
		if (r1 < 0)
			r1 = -r1;
		if (r2 < 0)
			r2 = -r2;
		if (r1 < r2)
			mode = QVTP_LAYOUT_MODE_W3_H4;
		else
			mode = QVTP_LAYOUT_MODE_W9_H16;
	}
	return mode;
}

- (BOOL)allocTextSource:(MDWord)dwCount {
	MLong lSize = 0;
	[self freeTextSource];
	if (dwCount == 0)
		return YES;
	lSize = sizeof(AMVE_BUBBLETEXT_SOURCE_TYPE) * dwCount;
	self.pTxtSrc = (AMVE_BUBBLETEXT_SOURCE_TYPE *)MMemAlloc(MNull, lSize);
	if (MNull == self.pTxtSrc)
		return NO;
	MMemSet(self.pTxtSrc, 0, lSize);
	for (int i = 0; i < dwCount; i++) {
		self.pTxtSrc[i].pszText = (MTChar *)MMemAlloc(MNull, sizeof(MTChar) * (AMVE_MAXPATH + 1));
		if (MNull == self.pTxtSrc[i].pszText) {
			[self freeTextSource];
			return NO;
		}
		MMemSet(self.pTxtSrc[i].pszText, 0, sizeof(MTChar) * (AMVE_MAXPATH + 1));
	}
	self.dwTxtCount = dwCount;
	return YES;
}

- (void)freeTextSource {
	if (MNull == self.pTxtSrc)
		return;
	for (int i = 0; i < self.dwTxtCount; i++) {
		if (MNull != self.pTxtSrc[i].pszText) {
			MMemFree(MNull, self.pTxtSrc[i].pszText);
			self.pTxtSrc[i].pszText = MNull;
		}
	}
	MMemFree(MNull, self.pTxtSrc);
	self.pTxtSrc = MNull;
	self.dwTxtCount = 0;
}

#pragma mark - Audio related
- (MBool)isStoryboadPrimalAudioDisabled {
	if (!self.cXiaoYingStoryBoardSession) {
		return MFalse;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	return [self isClipPrimalAudioDisabled:pStbDataClip];
}

- (MBool)isClipPrimalAudioDisabled:(CXiaoYingClip *)clip {
	if (!clip) {
		return MFalse;
	}
	MBool isDisabled = MFalse;
	MRESULT res = [clip getProperty:AMVE_PROP_CLIP_PRIMAL_AUDIO_DISABLED PropertyData:&isDisabled];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard isClipPrimalAudioDisabled err=0x%lx", res);
	}
	return isDisabled;
}

- (MRESULT)disableStoryboadPrimalAudio:(MBool)disable {
	if (!self.cXiaoYingStoryBoardSession) {
		return 0;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	MRESULT res = [pStbDataClip setProperty:AMVE_PROP_CLIP_PRIMAL_AUDIO_DISABLED PropertyData:&disable];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard disableStoryboadPrimalAudio err=0x%lx", res);
	}
	return res;
}

- (MRESULT)disableClipPrimalAudio:(CXiaoYingClip *)clip disable:(BOOL)disable {
	if (!clip) {
		return MERRP_APP;
	}
	MBool mbDisable = disable ? MTrue : MFalse;
	MRESULT res = [clip setProperty:AMVE_PROP_CLIP_PRIMAL_AUDIO_DISABLED PropertyData:&mbDisable];
    
    //打个补丁，音乐镜头的声音是加在clip上的，关闭原音的同时，也关闭这个
    CXiaoYingEffect *effect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC EffectIndex:0];
    if (effect) {
        MDWord volume = disable?0:100;
        MRESULT res = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT PropertyData:&volume];
    }
    
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard disableStoryboadPrimalAudio err=0x%lx", res);
	}
	return res;
}

- (MRESULT)disableClipEffectAudio:(CXiaoYingClip *)clip disable:(BOOL)disable {
	if (!clip) {
		return MERRP_APP;
	}
	CXiaoYingEffect *effect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC EffectIndex:0];
	if (!effect) {
		return MERR_NONE;
	}
	MDWord dwMixPercent = disable ? 0 : 100;
	MRESULT res = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT PropertyData:&dwMixPercent];
	return res;
}

- (NSString *)getAudioFilePath:(MDWord)audioClipIndex groupID:(MDWord)groupID layerID:(MDWord)layerID {
	if (!self.cXiaoYingStoryBoardSession) {
		return nil;
	}

	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	int count = [pStbDataClip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID];
	if (audioClipIndex >= count) {
		return nil;
	}
	CXiaoYingEffect *effect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID EffectIndex:audioClipIndex];
	return [self getAudioFilePath:effect];
}

- (NSString *)getAudioFilePath:(CXiaoYingEffect *)effect {
	if (effect) {
		AMVE_MEDIA_SOURCE_TYPE mediaSource = {
		    AMVE_MEDIA_SOURCE_TYPE_FILE,
		    (char *)malloc(AMVE_MAXPATH),
		    MFalse};
		MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_SOURCE
		                     PropertyData:&mediaSource];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard getAudioFilePath err=0x%lx", res);
			free(mediaSource.pSource);
			return nil;
		}
		NSString *audioPath = [NSString stringWithUTF8String:(char *)mediaSource.pSource];
		free(mediaSource.pSource);
		return audioPath;
	}
	return nil;
}

- (NSString *)getAudioTitle:(CXiaoYingEffect *)effect {
    if (effect) {
        char *titleChar = (char *)malloc(AMVE_MAXPATH);
        MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_TITLE
                             PropertyData:titleChar];
        if (res) {
            NSLog(@"[ENGINE]XYStoryboard getAudioTitle err=0x%lx", res);
        }
        NSString *audioTitle = titleChar == MNull ? @"" : [NSString stringWithUTF8String:titleChar];
        free(titleChar);
        return audioTitle;
    }
    return nil;
}


+ (NSString *)createIdentifier {
    int x = arc4random() % 100;
    int y = arc4random() % 100;
    return [NSString stringWithFormat:@"%llu%d%d",[[NSDate date] timeIntervalSince1970] * 1000 * 1000,x,y];
}

- (void)muteAudio:(CXiaoYingEffect *)effect mute:(MBool)mute {
	MRESULT res = MERR_NONE;
	if (effect) {
		res = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MUTE
		             PropertyData:&mute];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard muteAudio err=0x%lx", res);
		}
	}
	[self setModified:YES];
}

- (BOOL)isAudioMute:(CXiaoYingEffect *)effect {
	MBool mute = MFalse;
	if (effect) {
		MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MUTE
		                     PropertyData:&mute];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard isAudioMute err=0x%lx", res);
		}
	}
	return mute == MTrue;
}

- (MDWord)getAudioVolume:(CXiaoYingEffect *)effect groupID:(MDWord)groupID layerID:(MDWord)layerID {
	MDWord volume = 0;
	if (effect) {
		MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT
		                     PropertyData:&volume];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard getAudioVolume err=0x%lx", res);
		}
	}
	return volume;
}

- (void)setAudioVolume:(CXiaoYingEffect *)effect volume:(MDWord)volume groupID:(MDWord)groupID layerID:(MDWord)layerID {
	MRESULT res = MERR_NONE;
	if (effect) {
		res = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT
		             PropertyData:(MVoid *)&volume];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard setAudioVolume err=0x%lx", res);
		}
	}
	[self setModified:YES];
	return;
}

- (MDWord)getAudioVolumeByIndex:(MDWord)audioClipIndex groupID:(MDWord)groupID layerID:(MDWord)layerID {
	if (!self.cXiaoYingStoryBoardSession) {
		return -1;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	NSInteger count = [pStbDataClip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID];

	if (audioClipIndex >= count) {
		return -1;
	}
	CXiaoYingEffect *effect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID EffectIndex:audioClipIndex];
	if (effect) {
		MDWord volume = 0;
		MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT
		                     PropertyData:&volume];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard getAudioVolumeByIndex err=0x%lx", res);
		}
		return volume;
	}

	return -1;
}

- (void)setAudioVolumeByIndex:(MDWord)audioClipIndex volume:(MDWord)volume groupID:(MDWord)groupID layerID:(MDWord)layerID {
	if (!self.cXiaoYingStoryBoardSession) {
		return;
	}
	MRESULT res = 0;
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	NSInteger count = [pStbDataClip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID];
	if (audioClipIndex >= count) {
		return;
	}
	CXiaoYingEffect *effect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO
	                                          GroupID:groupID
	                                      EffectIndex:audioClipIndex];
	if (effect) {
		res = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT
		             PropertyData:(MVoid *)&volume];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard setAudioVolumeByIndex err=0x%lx", res);
		}
	}
	[self setModified:YES];
	return;
}

- (BOOL)isAudioMuteByIndex:(MDWord)audioClipIndex groupID:(MDWord)groupID layerID:(MDWord)layerID {
	if (!self.cXiaoYingStoryBoardSession) {
		return MFalse;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	NSInteger count = [pStbDataClip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID];

	if (audioClipIndex >= count) {
		return MFalse;
	}
	CXiaoYingEffect *effect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID EffectIndex:audioClipIndex];
	if (effect) {
		MBool mute = 0;
		MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MUTE
		                     PropertyData:&mute];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard isAudioMuteByIndex err=0x%lx", res);
		}
		return mute == MTrue;
	}

	return MFalse;
}

- (void)muteAudioByIndex:(MDWord)audioClipIndex mute:(MBool)mute groupID:(MDWord)groupID layerID:(MDWord)layerID {
	if (!self.cXiaoYingStoryBoardSession) {
		return;
	}
	MRESULT res = 0;
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	NSInteger count = [pStbDataClip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID];
	if (audioClipIndex >= count) {
		return;
	}
	CXiaoYingEffect *effect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO
	                                          GroupID:groupID
	                                      EffectIndex:audioClipIndex];
	if (effect) {
		res = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MUTE
		             PropertyData:&mute];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard muteAudioByIndex err=0x%lx", res);
		}
	}
	[self setModified:YES];
	return;
}

- (void)removeAudio:(MDWord)audioClipIndex groupID:(MDWord)groupID {
	if (!self.cXiaoYingStoryBoardSession) {
		return;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];

	CXiaoYingEffect *effect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID EffectIndex:audioClipIndex];
	if (effect) {
		MRESULT res = [pStbDataClip removeEffect:effect];
		if (res != MERR_NONE) {
			NSLog(@"[ENGINE]XYStoryboard removeAudio err=0x%lx", res);
		}
	}
	[self setModified:YES];
	return;
}

- (void)removeAllAudios:(MDWord)groupID {
	if (!self.cXiaoYingStoryBoardSession) {
		return;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	NSInteger count = [pStbDataClip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID];
	for (int i = count - 1; i >= 0; i--) {
		[self removeAudio:i groupID:groupID];
	}
}

- (void)setBGMFadeIsfadeInElseFadeOut:(BOOL)isfadeInElseFadeOut closeFade:(BOOL)closeFade pEffect:(CXiaoYingEffect *)pEffect fadeDuration:(MDWord)fadeDuration dwLength:(MDWord)dwLength {
    if (closeFade) {
        fadeDuration = 0;
        fadeDuration = 0;
    } else {
        if (0 == fadeDuration) {
            fadeDuration = 2000;
        }
    }
    if (isfadeInElseFadeOut) {
        //fadein
        AMVE_FADE_PARAM_TYPE fadeIn = {0};
        fadeIn.dwStartPercent = 0;
        fadeIn.dwEndPercent = 100;
        fadeIn.dwDuration = fadeDuration;
        MRESULT ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_FADEIN
                              PropertyData:(MVoid *)&fadeIn];
    } else {
        //fadeout
        AMVE_FADE_PARAM_TYPE fadeOut = {0};
        fadeOut.dwStartPercent = 100;
        fadeOut.dwEndPercent = 0;
        fadeOut.dwDuration = fadeDuration;
        MRESULT ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_FADEOUT
                              PropertyData:(MVoid *)&fadeOut];
    }
    [self setModified:YES];
}

- (BOOL)getBGMFadeIsfadeInElseFadeOut:(BOOL)isfadeInElseFadeOut pEffect:(CXiaoYingEffect *)pEffect {
	AMVE_FADE_PARAM_TYPE fade = {0};
	if (isfadeInElseFadeOut) {
		//fadein
		[pEffect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_FADEIN PropertyData:(MVoid *)&fade];
	} else {
		//fadeout
		[pEffect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_FADEOUT PropertyData:(MVoid *)&fade];
	}
	if (fade.dwDuration > 0) {
		return YES;
	} else {
		return NO;
	}
}

- (MRESULT)setAudio:(NSString *)musicFilePath
  audioTrimStartPos:(MDWord)audioTrimStartPos
    audioTrimLength:(MDWord)audioTrimLength
 storyBoardStartPos:(MDWord)storyBoardStartPos
   storyBoardLength:(MDWord)storyBoardLength
            groupID:(MDWord)groupID
            layerID:(MDWord)layerID
         mixPercent:(MDWord)mixPercent
       dwRepeatMode:(MDWord)dwRepeatMode
         audioTitle:(NSString *)audioTitle
           identifier:(NSString *)identifier {

	if (!self.cXiaoYingStoryBoardSession) {
		return MERRP_APP;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	return [self setClipAudio:pStbDataClip
	            musicFilePath:musicFilePath
	        audioTrimStartPos:audioTrimStartPos
	          audioTrimLength:audioTrimLength
	               dwStartPos:storyBoardStartPos
	                 dwLength:storyBoardLength
	                  groupID:groupID
	                  layerID:layerID
	               mixPercent:mixPercent
	             dwRepeatMode:dwRepeatMode
	                     fade:groupID == GROUP_ID_BGMUSIC
                   audioTitle:audioTitle
                     identifier:identifier];
}

- (MBool)audioIsRepeatEffect:(CXiaoYingEffect *)pEffect {
    MBool isRepeat = MTrue;
    [pEffect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_REPEAT_MODE PropertyData:&isRepeat];
    return isRepeat;
}

- (MRESULT)setAudioRepeatEffect:(CXiaoYingEffect *)pEffect isRepeatON:(MBool)isRepeatON {
    MRESULT ret = QVET_ERR_NONE;
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_REPEAT_MODE
                  PropertyData:(MVoid *)&isRepeatON];
    return ret;
}

- (MRESULT)setClipAudio:(CXiaoYingClip *)clip
          musicFilePath:(NSString *)musicFilePath
      audioTrimStartPos:(MDWord)audioTrimStartPos
        audioTrimLength:(MDWord)audioTrimLength
             dwStartPos:(MDWord)dwStartPos
               dwLength:(MDWord)dwLength
                groupID:(MDWord)groupID
                layerID:(MDWord)layerID
             mixPercent:(MDWord)mixPercent
           dwRepeatMode:(MDWord)dwRepeatMode
                   fade:(BOOL)fade
             audioTitle:(NSString *)audioTitle
             identifier:(NSString *)identifier {
	if (!clip) {
		return MERRP_APP;
	}
	MRESULT ret = QVET_ERR_NONE;

	CXiaoYingEngine *pEngine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
	if (!pEngine)
		return QVET_ERR_APP_FAIL;

	CXiaoYingEffect *pEffect;
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];

	if (clip.hClip == pStbDataClip.hClip) { //[self.cXiaoYingStoryBoardSession getDataClip]; 返回的地址每次都不一样,里面的hClip是一样的
		pEffect = [self getStoryboardEffectByTime:dwStartPos dwTrackType:AMVE_EFFECT_TRACK_TYPE_AUDIO groupId:groupID];
	} else {
		pEffect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID EffectIndex:0];
	}

	if (!pEffect) {
		pEffect = [[CXiaoYingEffect alloc] init];
		ret = [pEffect Create:pEngine
		           EffectType:AMVE_EFFECT_TYPE_AUDIO_FRAME
		            TrackType:AMVE_EFFECT_TRACK_TYPE_AUDIO
		              GroupID:groupID
		              LayerID:layerID];
		CHECK_VALID_RET(ret);

		ret = [clip insertEffect:pEffect];
		CHECK_VALID_RET(ret);
        if ([NSString xy_isEmpty:identifier]) {
            identifier = [XYStoryboard createIdentifier];
        }
        ret = [self setEffectIdentifier:pEffect identifier:identifier];//引擎有问题暂时可不做 CHECK_VALID_RET
	}
    

	const MTChar *pszBGFile = [musicFilePath UTF8String];

	//1. set BGM media src
	AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
	mediaSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_FILE;
	mediaSrc.pSource = (MVoid *)pszBGFile;
    if ([NSString xy_isEmpty:audioTitle]) {
        audioTitle = @"";
    }
    const MTChar *titleChar = [audioTitle UTF8String];
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_TITLE
                  PropertyData:titleChar];
    CHECK_VALID_RET(ret);
    
	ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_SOURCE
	              PropertyData:&mediaSrc];
	CHECK_VALID_RET(ret);

	//2. set mix percent
	MDWord dwMixPercent = mixPercent;
	ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT
	              PropertyData:(MVoid *)&dwMixPercent];
	CHECK_VALID_RET(ret);

	//3. set mix range
	AMVE_POSITION_RANGE_TYPE SrcRange;
	SrcRange.dwPos = audioTrimStartPos;
	SrcRange.dwLen = audioTrimLength;
	ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE
	              PropertyData:(MVoid *)&SrcRange];
	CHECK_VALID_RET(ret);

	AMVE_POSITION_RANGE_TYPE EffectRange;
	EffectRange.dwPos = dwStartPos;
	EffectRange.dwLen = dwLength;
	ret = [pEffect setProperty:AMVE_PROP_EFFECT_RANGE
	              PropertyData:(MVoid *)&EffectRange];
	CHECK_VALID_RET(ret);

	//4. set repeat mode
    if (AMVE_AUDIO_FRAME_MODE_REPEAT == dwRepeatMode) {
        ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_REPEAT_MODE
                      PropertyData:(MVoid *)&dwRepeatMode];
        CHECK_VALID_RET(ret);
    } else {
        ret = [pEffect setProperty: AMVE_PROP_EFFECT_POSITION_ALIGNMENT
                             PropertyData:(MVoid *)&dwRepeatMode];
        CHECK_VALID_RET(ret);
    }
	

	if (fade) {
		if (dwLength < 4000) {

		} else {
			MDWord fadeinDuration = 2000;
			MDWord fadeoutDuration = 2000;
			//fadein
			[self setBGMFadeIsfadeInElseFadeOut:YES closeFade:NO pEffect:pEffect fadeDuration:fadeinDuration dwLength:dwLength];
			//fadeout
			[self setBGMFadeIsfadeInElseFadeOut:NO closeFade:NO pEffect:pEffect fadeDuration:fadeoutDuration dwLength:dwLength];
		}
	}
	[self setModified:YES];
	return QVET_ERR_NONE;
}

- (void)setAudioRange:(MDWord)audioClipIndex
    audioTrimStartPos:(MDWord)audioTrimStartPos
      audioTrimLength:(MDWord)audioTrimLength
   storyBoardStartPos:(MDWord)storyBoardStartPos
     storyBoardLength:(MDWord)storyBoardLength
              groupID:(MDWord)groupID
              layerID:(MDWord)layerID {
	if (!self.cXiaoYingStoryBoardSession) {
		return;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	[self setClipAudioRange:pStbDataClip
	         audioClipIndex:audioClipIndex
	      audioTrimStartPos:audioTrimStartPos
	        audioTrimLength:audioTrimLength
	             dwStartPos:storyBoardStartPos
	               dwLength:storyBoardLength
	                groupID:groupID
	                layerID:layerID];
}

- (void)setClipAudioRange:(CXiaoYingClip *)clip
           audioClipIndex:(MDWord)audioClipIndex
        audioTrimStartPos:(MDWord)audioTrimStartPos
          audioTrimLength:(MDWord)audioTrimLength
               dwStartPos:(MDWord)dwStartPos
                 dwLength:(MDWord)dwLength
                  groupID:(MDWord)groupID
                  layerID:(MDWord)layerID {
	NSInteger count = [clip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID];

	if (audioClipIndex >= count) {
		return;
	}
	CXiaoYingEffect *effect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID EffectIndex:audioClipIndex];
	if (effect) {

		//3. set mix range
		AMVE_POSITION_RANGE_TYPE SrcRange;
		SrcRange.dwPos = audioTrimStartPos;
		SrcRange.dwLen = audioTrimLength;
		MRESULT res = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE
		                     PropertyData:(MVoid *)&SrcRange];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard setClipAudioRange AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE err=0x%lx", res);
		}

		AMVE_POSITION_RANGE_TYPE EffectRange;
		EffectRange.dwPos = dwStartPos;
		EffectRange.dwLen = dwLength;
		res = [effect setProperty:AMVE_PROP_EFFECT_RANGE
		             PropertyData:(MVoid *)&EffectRange];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard setClipAudioRange AMVE_PROP_EFFECT_RANGE err=0x%lx", res);
		}
	}
	[self setModified:YES];
}


- (AMVE_POSITION_RANGE_TYPE)getAudioRange:(MDWord)audioClipIndex groupID:(MDWord)groupID layerID:(MDWord)layerID {
	AMVE_POSITION_RANGE_TYPE range = {0};
	if (!self.cXiaoYingStoryBoardSession) {
		return range;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	range = [self getClipAudioRange:pStbDataClip audioClipIndex:audioClipIndex groupID:groupID layerID:layerID];
	MDWord storyboardDuration = [self.cXiaoYingStoryBoardSession getDuration];
	if (range.dwPos + range.dwLen > storyboardDuration) {
		range.dwLen = storyboardDuration - range.dwPos;
	}
	return range;
}

- (AMVE_POSITION_RANGE_TYPE)getClipAudioRange:(CXiaoYingClip *)clip
                               audioClipIndex:(MDWord)audioClipIndex
                                      groupID:(MDWord)groupID
                                      layerID:(MDWord)layerID {
	AMVE_POSITION_RANGE_TYPE range = {0};
	if (!clip) {
		return range;
	}
	NSInteger count = [clip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID];

	if (audioClipIndex >= count) {
		return range;
	}
	CXiaoYingEffect *effect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID EffectIndex:audioClipIndex];
	if (effect) {
		MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&range];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard getClipAudioRange AMVE_PROP_EFFECT_RANGE err=0x%lx", res);
		}
		return range;
	}
	return range;
}

- (AMVE_POSITION_RANGE_TYPE)getAudioTrimRange:(MDWord)audioClipIndex groupID:(MDWord)groupID layerID:(MDWord)layerID {
	AMVE_POSITION_RANGE_TYPE range = {0};
	if (!self.cXiaoYingStoryBoardSession) {
		return range;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	return [self getClipAudioTrimRange:pStbDataClip audioClipIndex:audioClipIndex groupID:groupID layerID:layerID];
}

- (AMVE_POSITION_RANGE_TYPE)getClipAudioTrimRange:(CXiaoYingClip *)clip
                                   audioClipIndex:(MDWord)audioClipIndex
                                          groupID:(MDWord)groupID
                                          layerID:(MDWord)layerID {
	AMVE_POSITION_RANGE_TYPE range = {0};
	if (!clip) {
		return range;
	}
	NSInteger count = [clip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID];

	if (audioClipIndex >= count) {
		return range;
	}
	CXiaoYingEffect *effect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID EffectIndex:audioClipIndex];
	if (effect) {
		MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE PropertyData:&range];
		if (res) {
			NSLog(@"[ENGINE]XYStoryboard getClipAudioTrimRange AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE err=0x%lx", res);
		}
		return range;
	}
	return range;
}

- (void)updateAudioRawRangeStartPos:(MDWord)rawStartPos
                          rawLength:(MDWord)rawLength
                            pEffect:(CXiaoYingEffect *)pEffect {
    AMVE_POSITION_RANGE_TYPE srcRange;
    srcRange.dwPos = rawStartPos;
    srcRange.dwLen = rawLength;
    [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE
                  PropertyData:(MVoid *)&srcRange];
}

- (void)setBGM:(NSString *)musicFilePath audioTitle:(NSString *)audioTitle {
	[self removeBGM];
	[self setAudio:musicFilePath audioTrimStartPos:0 audioTrimLength:-1 storyBoardStartPos:0 storyBoardLength:0x7fffffff groupID:GROUP_ID_BGMUSIC layerID:LAYER_ID_BGM mixPercent:50 dwRepeatMode:AMVE_AUDIO_FRAME_MODE_REPEAT audioTitle:audioTitle identifier:nil];
}

- (void)setBGM:(NSString *)musicFilePath audioTrimStartPos:(MDWord)audioTrimStartPos audioTrimLength:(MDWord)audioTrimLength audioTitle:(NSString *)audioTitle{
	[self removeBGM];
	[self setAudio:musicFilePath audioTrimStartPos:audioTrimStartPos audioTrimLength:audioTrimLength storyBoardStartPos:0 storyBoardLength:0x7fffffff groupID:GROUP_ID_BGMUSIC layerID:LAYER_ID_BGM mixPercent:50 dwRepeatMode:AMVE_AUDIO_FRAME_MODE_REPEAT audioTitle:audioTitle identifier:nil];
}

- (AMVE_POSITION_RANGE_TYPE)getBGMAudioRangeInfo
{
    AMVE_POSITION_RANGE_TYPE result = {0};
    
    if(!self.cXiaoYingStoryBoardSession)
    {
        return result;
    }
    
    CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
    
    int count = [pStbDataClip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC];
    
    if(0 >= count)
    {
        return result;
    }
    
    CXiaoYingEffect *effect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC EffectIndex:0];
    
    MRESULT res = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE PropertyData:&result];
    
    if(res)
    {
    }
    
    return result;
}

- (NSString *)getBGMPath {
	return [self getAudioFilePath:0 groupID:GROUP_ID_BGMUSIC layerID:LAYER_ID_BGM];
}

- (void)removeBGM {
	[self removeAllAudios:GROUP_ID_BGMUSIC];
}


- (BOOL)isSetOriginVolume {
    BOOL isSetVolume;
    MDWord clipCount = [self getClipCount];
    if (clipCount > 0) {
        for (int i = 0; i < clipCount; i ++) {
            CXiaoYingClip *clip = [self getClipByIndex:i];
            QVET_AUDIO_GAIN gain = {0};
            [clip getProperty:AMVE_PROP_CLIP_AUDIO_GAIN PropertyData:&gain];
            if (gain.count > 0) {
                isSetVolume = YES;
                break;
            }else{
                isSetVolume = NO;
            }
        }
    }else {
        isSetVolume = NO;
    }
    return isSetVolume;
}

- (BOOL)isSetBgmVolume {
    BOOL isSetVolume;
    CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
    CXiaoYingEffect *effect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC EffectIndex:0];
    if (effect) {
        QVET_AUDIO_GAIN gain = {0};
        [effect getProperty:AMVE_PROP_EFFECT_AUDIO_GAIN PropertyData:&gain];
        if (gain.count > 0) {
            isSetVolume = YES;
        }else {
            isSetVolume = NO;
        }
    }else {
        isSetVolume = NO;
    }
    return isSetVolume;
}

- (MRESULT)updateClipOriginVolume:(MFloat)volume {
    [self setModified:YES];
    MRESULT res;
   MDWord clipCount = [self getClipCount];
    for (int i = 0; i < clipCount; i ++) {
        [self updateClipVolume:i volumeValue:volume];
    }
    return res;
}

- (MRESULT)updateClipVolume:(NSInteger)clipIndex volumeValue:(MFloat)volumeValue {
    [self setModified:YES];
    MRESULT res;
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    QVET_AUDIO_GAIN gain = {0};
    MDWord rangeList[2] = {0, -1};
    gain.timePos = &rangeList;
    MFloat gainVlaue = (MFloat)(volumeValue / 100.0);
    MFloat gainList[2] = {gainVlaue, gainVlaue};
    gain.gain = &gainList;
    gain.cap = gain.count = 2;
    res = [clip setProperty:AMVE_PROP_CLIP_AUDIO_GAIN PropertyData:&gain];
    
    //打个补丁，音乐镜头的声音是加在clip上的，关闭原音的同时，也关闭这个
    CXiaoYingEffect *effect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC EffectIndex:0];
    if (effect) {
        MDWord volume = volumeValue;
        MRESULT res = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT PropertyData:&volume];
    }
    
    return res;
}

- (MFloat)clipOriginVolume {
    MFloat volume = 100;
    MDWord clipCount = [self getClipCount];
    if (clipCount > 0) {
        for (int i = 0; i < clipCount; i ++) {
            CXiaoYingClip *clip = [self getClipByIndex:i];
            if (clip) {
                QVET_AUDIO_GAIN gain = {0};
                [clip getProperty:AMVE_PROP_CLIP_AUDIO_GAIN PropertyData:&gain];
                if (gain.count > 0) {
                    volume = gain.gain[0] * 100;
                    break;
                }
            }
        }
    }
    return volume;
}

- (MFloat)clipOriginVolume:(NSInteger)clipIndex {
    MFloat volume = 100;
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    if (clip) {
        QVET_AUDIO_GAIN gain = {0};
        [clip getProperty:AMVE_PROP_CLIP_AUDIO_GAIN PropertyData:&gain];
        if (gain.count > 0) {
            volume = gain.gain[0] * 100;
        }
    }
    return volume;
}

- (MFloat)clipOriginVolumeWithPClip:(CXiaoYingClip *)pClip {
    MFloat volume = 100;
    if (pClip) {
        QVET_AUDIO_GAIN gain = {0};
        [pClip getProperty:AMVE_PROP_CLIP_AUDIO_GAIN PropertyData:&gain];
        if (gain.count > 0) {
            volume = gain.gain[0] * 100;
        }
    }
    return volume;
}

- (MFloat)clipBgmVolume {
    MFloat volume = 100;
    CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
    CXiaoYingEffect *effect = [pStbDataClip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_BGMUSIC EffectIndex:0];
    if (effect) {
        QVET_AUDIO_GAIN gain = {0};
        [effect getProperty:AMVE_PROP_EFFECT_AUDIO_GAIN PropertyData:&gain];
        if (gain.count > 0) {
            volume = gain.gain[0] * 100;
        }
    }
    return volume;
}

- (MRESULT)updateClipBgmVolume:(MFloat)volume {
    MRESULT res;
    res = [self updateAudioVolumeEffectIndex:0 trackType:AMVE_EFFECT_TRACK_TYPE_AUDIO groupID:GROUP_ID_BGMUSIC volumeValue:volume];
    return res;
}

- (MRESULT)updateAudioVolumeEffectIndex:(int)index trackType:(MDWord)dwTrackType groupID:(MDWord)groupID volumeValue:(MFloat)volumeValue {
    [self setModified:YES];
    MRESULT res;
    CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
    CXiaoYingEffect *effect = [pStbDataClip getEffect:dwTrackType GroupID:groupID EffectIndex:index];
    return [self updateAudiGainWithPEffect:effect volumeValue:volumeValue];
}

- (MRESULT)updateAudiGainWithPEffect:(CXiaoYingEffect *)pEffect volumeValue:(MFloat)volumeValue {
    [self setModified:YES];
    MRESULT res;
    if (pEffect) {
         QVET_AUDIO_GAIN gain = {0};
           BOOL isMix = YES;
           [pEffect setProperty:AMVE_PROP_EFFECT_USE_NEW_ADUIO_MIX_MODE PropertyData:&isMix];
           MDWord rangeList[2] = {0, -1};
           gain.timePos = &rangeList;
           MFloat gainVlaue = (MFloat)(volumeValue / 100.0);
           MFloat gainList[2] = {gainVlaue, gainVlaue};
           gain.gain = &gainList;
           gain.cap = gain.count = 2;
           res = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_GAIN PropertyData:&gain];
    }
    return res;
}

- (MFloat)audioVolumeEffectIndex:(int)index trackType:(MDWord)dwTrackType groupID:(MDWord)groupID {
    MFloat volume = 100;
    CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
    CXiaoYingEffect *effect = [pStbDataClip getEffect:dwTrackType GroupID:groupID EffectIndex:index];
    if (effect) {
        QVET_AUDIO_GAIN gain = {0};
        [effect getProperty:AMVE_PROP_EFFECT_AUDIO_GAIN PropertyData:&gain];
        if (gain.count > 0) {
            volume = gain.gain[0] * 100;
        }
    }
    return volume;
}

- (void)setBGMVolume:(MDWord)volume {
	MDWord audioClipCount = [self getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO groupId:GROUP_ID_BGMUSIC];
	for (int i = 0; i < audioClipCount; i++) {
		[self setAudioVolumeByIndex:i volume:volume groupID:GROUP_ID_BGMUSIC layerID:LAYER_ID_BGM];
	}
}

- (MDWord)getBGMVolume {
	return [self getAudioVolumeByIndex:0 groupID:GROUP_ID_BGMUSIC layerID:LAYER_ID_BGM];
}

- (void)muteBGM:(MBool)mute {

	MDWord audioClipCount = [self getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO groupId:GROUP_ID_BGMUSIC];
	for (int i = 0; i < audioClipCount; i++) {
		[self muteAudioByIndex:i mute:mute groupID:GROUP_ID_BGMUSIC layerID:LAYER_ID_BGM];
	}
}

- (BOOL)isBGMMute {
	return [self isAudioMuteByIndex:0 groupID:GROUP_ID_BGMUSIC layerID:LAYER_ID_BGM];
}

- (void)setVideoSoundVolume:(MLong)volume {
	if (!self.cXiaoYingStoryBoardSession) {
		return;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	MRESULT res = [pStbDataClip setProperty:AMVE_PROP_CLIP_AUDIO_ADJUSTDB PropertyData:&volume];
	if (res) {
		NSLog(@"[Engine]setVideoSoundVolume err=0x%lx", res);
	}
}

- (MLong)getVideoSoundVolume {
	if (!self.cXiaoYingStoryBoardSession) {
		return 0;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	MDWord volume = 0;
	[pStbDataClip getProperty:AMVE_PROP_CLIP_AUDIO_ADJUSTDB PropertyData:&volume];
	return volume;
}

- (void)resetBGM {
	MDWord param = QVET_THEME_RESET_CODE_MUSIC;
	MRESULT res = [self.cXiaoYingStoryBoardSession setProperty:AMVE_PROP_STORYBOARD_RESET_THEME_ELEM Value:&param];
}

- (void)setDub:(NSString *)voiceFilePath
      startPos:(MDWord)startPos
        length:(MDWord)length
    audioTitle:(NSString *)audioTitle {

	//    NSLog(@"setDub Range 0_0");
	AMVE_VIDEO_INFO_TYPE videoinfo = {0};
	[CXiaoYingUtils getVideoInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine]
	                    FilePath:(MTChar *)[voiceFilePath UTF8String]
	                   VideoInfo:&videoinfo];
    [self setAudio:voiceFilePath audioTrimStartPos:0 audioTrimLength:videoinfo.dwVideoDuration storyBoardStartPos:startPos storyBoardLength:length groupID:GROUP_ID_DUBBING layerID:LAYER_ID_DUB mixPercent:50 dwRepeatMode:AMVE_AUDIO_FRAME_MODE_NORMAL audioTitle:audioTitle identifier:nil];
}

- (void)setDubRange:(MDWord)voiceClipIndex startPos:(MDWord)startPos {
	NSLog(@"setDub Range startPos=%lu", startPos);
	AMVE_POSITION_RANGE_TYPE range = [self getDubRange:voiceClipIndex];
	[self setAudioRange:voiceClipIndex audioTrimStartPos:range.dwPos audioTrimLength:range.dwLen storyBoardStartPos:startPos storyBoardLength:range.dwLen groupID:GROUP_ID_DUBBING layerID:LAYER_ID_DUB];
}

- (NSString *)getDubPath:(MDWord)voiceClipIndex {
	return [self getAudioFilePath:voiceClipIndex groupID:GROUP_ID_DUBBING layerID:LAYER_ID_DUB];
}

- (void)removeDub:(MDWord)voiceClipIndex {
	[self removeAudio:voiceClipIndex groupID:GROUP_ID_DUBBING];
}

- (void)setDubVolume:(MDWord)voiceClipIndex volume:(MDWord)volume {
	[self setAudioVolumeByIndex:voiceClipIndex volume:volume groupID:GROUP_ID_DUBBING layerID:LAYER_ID_DUB];
}

- (MDWord)getDubVolume:(MDWord)voiceClipIndex {
	return [self getAudioVolumeByIndex:voiceClipIndex groupID:GROUP_ID_DUBBING layerID:LAYER_ID_DUB];
}

- (AMVE_POSITION_RANGE_TYPE)getDubRange:(MDWord)voiceClipIndex {
	return [self getAudioRange:voiceClipIndex groupID:GROUP_ID_DUBBING layerID:LAYER_ID_DUB];
}

- (MDWord)getDubCount {
	if (!self.cXiaoYingStoryBoardSession) {
		return 0;
	}
	CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
	MDWord count = [pStbDataClip getEffectCount:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:GROUP_ID_DUBBING];
	return count;
}

#pragma mark - AMVESessionStateDelegate
- (MDWord)AMVESessionStateCallBack:(AMVE_CBDATA_TYPE *)pCBData {
	NSLog(@"AMVESessionStateCallBack %ld, err=0x%lx", pCBData->dwStatus, pCBData->dwErrorCode);
	if (g_bThemeApplying) {
		if (pCBData && pCBData->dwStatus == AMVE_SESSION_STATUS_STOPPED) {
			g_bThemeApplying = MFalse;
		}
	}
	return 0;
}

- (UIColor *)colorWithHex:(NSUInteger)hex {
	CGFloat red, green, blue, alpha;

	red = ((CGFloat)((hex >> 16) & 0xFF)) / ((CGFloat)0xFF);
	green = ((CGFloat)((hex >> 8) & 0xFF)) / ((CGFloat)0xFF);
	blue = ((CGFloat)((hex >> 0) & 0xFF)) / ((CGFloat)0xFF);
	alpha = hex > 0xFFFFFF ? ((CGFloat)((hex >> 24) & 0xFF)) / ((CGFloat)0xFF) : 1;

	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (AMVE_VIDEO_INFO_TYPE)getVideoInfoWithClipIndex:(int)index {
	CXiaoYingClip *cXiaoYingClip = [self getClipByIndex:index];
	AMVE_VIDEO_INFO_TYPE videoInfo = {0};
	MRESULT res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_SOURCE_INFO PropertyData:&videoInfo];
	return videoInfo;
}

- (CXiaoYingEffect *)getEffectByClipIndex:(int)index trackType:(MDWord)dwTrackType groupID:(MDWord)groupID {
	CXiaoYingClip *clip = [self getClipByIndex:index];
	if (!clip) {
		return nil;
	}
	CXiaoYingEffect *effect = [clip getEffect:dwTrackType GroupID:groupID EffectIndex:0];
	return effect;
}
#pragma mark - 视频缩放背景调节

// dwPropertyID ：AMVE_PROP_EFFECT_DST_RATIO 旋转、平移、缩放   AMVE_PROP_EFFECT_PROPDATA模糊背景及设置背景颜色
- (MRESULT)setEffectPropertyWithDwPropertyID:(MDWord)dwPropertyID pValue:(MVoid *)pValue clipIndex:(int)clipIndex {
	CXiaoYingEffect *effect = [self getEffectByClipIndex:clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM];
	if (!effect) {
		effect = [[CXiaoYingEffect alloc] init];
		[effect Create:[[XYEngine sharedXYEngine] getCXiaoYingEngine] EffectType:AMVE_EFFECT_TYPE_VIDEO_IE TrackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO GroupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM LayerID:LAYER_ID_PANZOOM];
		CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
		[clip insertEffect:effect];
	}
	return [effect setProperty:dwPropertyID PropertyData:pValue];
}

// dwPropertyID ： 此功能仅暂时用做 图片动画
- (MRESULT)setEffectPropertyWithPropertyID:(MDWord)dwPropertyID pValue:(MVoid *)pValue clipIndex:(int)clipIndex trackType:(MDWord)trackType groupID:(MDWord)groupID {
	CXiaoYingEffect *effect = [self getEffectByClipIndex:clipIndex trackType:trackType groupID:groupID];
	if (!effect) {
		return 0;
	}
	return [effect setProperty:dwPropertyID PropertyData:pValue];
}

//获取 PropertyID 对应的值
- (MRESULT)getEffectPropertyWithDwPropertyID:(MDWord)dwPropertyID pValue:(MVoid *)pValue clipIndex:(int)clipIndex trackType:(MDWord)trackType groupID:(MDWord)groupID {
	CXiaoYingEffect *effect = [self getEffectByClipIndex:clipIndex trackType:trackType groupID:groupID];
	if (effect) {
		return [effect getProperty:dwPropertyID PropertyData:pValue];
	} else {
		return -1;
	}
}

- (MRESULT)getExternalSourceWithClipIndex:(int)clipIndex source:(QVET_EFFECT_EXTERNAL_SOURCE *)source {

	CXiaoYingEffect *effect = [self getEffectByClipIndex:clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM];
	if (effect) {
		return [effect GetExternalSource:0 ExternalSource:source];
	} else {
		return -1;
	}
}

- (MRESULT)getEffectPropertyWithDwPropertyID:(MDWord)dwPropertyID pValue:(MVoid *)pValue clipIndex:(int)clipIndex {
	CXiaoYingEffect *effect = [self getEffectByClipIndex:clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM];
	if (effect) {
		return [effect getProperty:dwPropertyID PropertyData:pValue];
	} else {
		return -1;
	}
}

//设置背景

- (CXiaoYingEffect *)setEffectVideoBackImageWidthPhotoPath:(NSString *)photoPath clipIndex:(int)clipIndex {
	QVET_EFFECT_EXTERNAL_SOURCE effectSource = {0};

	AMVE_POSITION_RANGE_TYPE clipRange = {0};
	clipRange.dwPos = 0;
	clipRange.dwLen = -1;
	effectSource.dataRange = clipRange;

	AMVE_MEDIA_SOURCE_TYPE mediaSource = {
	    AMVE_MEDIA_SOURCE_TYPE_FILE,
	    (MVoid *)[photoPath cStringUsingEncoding:NSUTF8StringEncoding],
	    MFalse};

	effectSource.pSource = &mediaSource;
	CXiaoYingEffect *effect = [self getEffectByClipIndex:clipIndex trackType:AMVE_EFFECT_TRACK_TYPE_PRIMAL_VIDEO groupID:GROUP_ID_VIDEO_PARAM_ADJUST_PANZOOM];
	if (effect) {
		MRESULT res = [effect SetExternalSource:0 ExternalSource:&effectSource];
		return effect;
	} else {
		return nil;
	}
}

- (NSString *)getEffectClipBackImagePhotoPathWithClipIndex:(int)clipIndex {
    QVET_EFFECT_EXTERNAL_SOURCE effectSource = {0};
    
    AMVE_POSITION_RANGE_TYPE clipRange = {0};
    clipRange.dwPos = 0;
    clipRange.dwLen = -1;
    effectSource.dataRange = clipRange;
    
    AMVE_MEDIA_SOURCE_TYPE mediaSource = {
        AMVE_MEDIA_SOURCE_TYPE_FILE,
        (char *)malloc(MAX_PATH),
        MFalse};
    effectSource.pSource = &mediaSource;
    MRESULT res = [self getExternalSourceWithClipIndex:clipIndex source:&effectSource];
    if (res) {
        return nil;
    }else{
        AMVE_MEDIA_SOURCE_TYPE *mediaSource = effectSource.pSource;
        NSString *photoPath = [NSString stringWithUTF8String:(char *)mediaSource->pSource];
        return photoPath;
    }
}

- (MBool)isRatioSelected {
	MBool isSettedRatio = MTrue;
	MRESULT res = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_RATIO_SETTED Value:&isSettedRatio];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard isSettedRatioOrigin err=0x%lx", res);
	}
	return isSettedRatio;
}

- (void)setPropRatioSelected:(MBool)isSettedRatio {
	MRESULT res = [self.cXiaoYingStoryBoardSession setProperty:AMVE_PROP_STORYBOARD_RATIO_SETTED Value:&isSettedRatio];
	if (res) {
		NSLog(@"[ENGINE]XYStoryboard isSettedRatioOrigin err=0x%lx", res);
	}
}

- (void)setVoiceChangeValueWithClipIndex:(MDWord)clipIndex audioPitch:(float)audioPitch {
    [self setModified:YES];
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    MRESULT res = [clip setProperty:AMVE_PROP_CLIP_AUDIO_PITCH_DELTA PropertyData:&audioPitch];
}

- (float)getVoiceChangeValueWithClipIndex:(MDWord)clipIndex {
    CXiaoYingClip *clip = [self getClipByIndex:clipIndex];
    float audioPitch = 0.0;
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_AUDIO_PITCH_DELTA PropertyData:&audioPitch];
    return audioPitch;
}

- (void)setEffctVoiceChangeValueWithEffect:(CXiaoYingEffect *)pEffect audioPitch:(float)audioPitch {
    [self setModified:YES];
    MRESULT res = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_PITCH_DELTA PropertyData:&audioPitch];
}

- (float)getEffctVoiceChangeValueWithEffect:(CXiaoYingEffect *)pEffect {
    float audioPitch = 0.0;
    MRESULT res = [pEffect getProperty:AMVE_PROP_EFFECT_AUDIO_PITCH_DELTA PropertyData:&audioPitch];
    return audioPitch;
}


#pragma mark - 关键帧相关

//如果当前effect上有关键帧，需要将effect的regionRatio设置成关键帧中最大的regionRatio
- (MRESULT)setkeyFrameTypeEffectRegionRatioWithEffect:(CXiaoYingEffect *)effect {
    MRESULT ret = 0;
    CXiaoYingKeyFrameTransformData *otr_data = [effect getKeyFrameTransformData];
    if (otr_data) {
        if (otr_data.values.count > 0) {
            __block CXiaoYingKeyFrameTransformValue *targetValue;
            [otr_data.values enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CXiaoYingKeyFrameTransformValue *value = (CXiaoYingKeyFrameTransformValue *)obj;

                if (idx == 0) {
                    targetValue = value;
                }else {
                    if (value->widthRatio > targetValue->widthRatio) {
                        targetValue = value;
                    }
                }
            }];
            
            MFloat baseWidth = [self geteEffectKeyframeBaseWidthWithEffect:effect];
            MFloat baseHeight = [self geteEffectKeyframeBaseHeightWithEffect:effect];
            
            MFloat realWidth = targetValue->widthRatio * baseWidth;
            MFloat realHeight = targetValue->heightRatio * baseHeight;

            MRECT rect = {targetValue->position.x - realWidth / 2,targetValue->position.y - realHeight / 2,targetValue->position.x + realWidth / 2,targetValue->position.y + realHeight / 2};
            ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&rect];
        }
    }
    
    return ret;
}

- (MRESULT)setKeyframeData:(NSMutableArray<CXiaoYingKeyFrameTransformValue *> *)keyFrameArray effect:(CXiaoYingEffect *)effect {
    CXiaoYingKeyFrameTransformData* tr_data = [[CXiaoYingKeyFrameTransformData alloc] init];

    tr_data.values = [keyFrameArray copy];
    
    MRESULT res = [effect setKeyFrameTransformData:tr_data];
    if(res){
        NSLog(@"[ENGINE] set QVET_TIME_POSITION_ALIGNMENT_MODE_START err=0x%x",res);
    }
    return res;
}

- (NSArray<CXiaoYingKeyFrameTransformValue *> *)getKeyframeData:(CXiaoYingEffect *)effect {
    CXiaoYingKeyFrameTransformData *keyFrameData = [effect getKeyFrameTransformData];
    return keyFrameData.values;
}

- (MRESULT)updateKeyframeTransformOriginRegion:(MRECT)originRegion effect:(CXiaoYingEffect *)effect {
    MRESULT ret = [effect setProperty:AVME_PROP_EFFECT_KEYFRAME_TRANSFORM_ORIGIN_REGION PropertyData:&originRegion];
    return ret;
}

- (MLong)geteEffectKeyframeBaseWidthWithEffect:(CXiaoYingEffect *)effect {
    MRECT region = {0};
    MRESULT ret = [effect getProperty:AVME_PROP_EFFECT_KEYFRAME_TRANSFORM_ORIGIN_REGION PropertyData:&region];
    MLong baseWidth = region.right - region.left;
    if (baseWidth < 0) {
        baseWidth = 0;
    }
    return baseWidth;
}

- (MLong)geteEffectKeyframeBaseHeightWithEffect:(CXiaoYingEffect *)effect {
    MRECT region = {0};
    MRESULT ret = [effect getProperty:AVME_PROP_EFFECT_KEYFRAME_TRANSFORM_ORIGIN_REGION PropertyData:&region];
    MLong baseHeight = region.bottom - region.top;
    if (baseHeight < 0) {
        baseHeight = 0;
    }
    return baseHeight;
}


- (CXiaoYingStoryBoardSession *)duplicate {
    if (self.cXiaoYingStoryBoardSession) {
        return [CXiaoYingStoryBoardSession duplicate:self.cXiaoYingStoryBoardSession];
    }else {
        return nil;
    }
}

- (void)dealloc {
	NSLog(@"XYStoryboard dealloc");
}

#pragma mark - 8.0.0 Clip
- (NSInteger)setClipSourceRange:(CXiaoYingClip *)cXiaoYingClip sourceRange:(AMVE_POSITION_RANGE_TYPE)sourceRange {
    MRESULT res = 0;
    MBool isReversed = MFalse;
    res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&isReversed];
    
    if (isReversed == MTrue) {
        res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_INVERSE_PLAY_SOURCE_RANGE PropertyData:&sourceRange];
    } else {
        res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_SRC_RANGE PropertyData:&sourceRange];
    }
    return res;
}

- (AMVE_POSITION_RANGE_TYPE)getClipSourceRangeByClip:(CXiaoYingClip *)cXiaoYingClip {
    MRESULT res = 0;
    AMVE_POSITION_RANGE_TYPE sourceRange = {0};
    MBool isReversed = MFalse;
    res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&isReversed];
    
    if (isReversed == MTrue) {
        res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_INVERSE_PLAY_SOURCE_RANGE PropertyData:&sourceRange];
    } else {
        res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_SRC_RANGE PropertyData:&sourceRange];
    }
    return sourceRange;
}

- (NSInteger)setClipTrimRange:(CXiaoYingClip *)cXiaoYingClip trimRange:(AMVE_POSITION_RANGE_TYPE)trimRange {
    MRESULT res = 0;
    MBool isReverseTrimMdoe = MFalse;
    res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&isReverseTrimMdoe];
    
    if (isReverseTrimMdoe == MTrue) {
        res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_INVERSE_PLAY_TRIM_RANGE PropertyData:&trimRange];
    } else {
        res = [cXiaoYingClip setProperty:AMVE_PROP_CLIP_TRIM_RANGE PropertyData:&trimRange];
    }
    return res;
}

- (AMVE_POSITION_RANGE_TYPE)getClipTrimRangeByClip:(CXiaoYingClip *)cXiaoYingClip {
    MRESULT res = 0;
    AMVE_POSITION_RANGE_TYPE trimRange = {0};
    MBool isReverseTrimMdoe = MFalse;
    res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_INVERSE_PLAY_VIDEO_FLAG PropertyData:&isReverseTrimMdoe];
    
    if (isReverseTrimMdoe == MTrue) {
        res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_INVERSE_PLAY_TRIM_RANGE PropertyData:&trimRange];
    } else {
        res = [cXiaoYingClip getProperty:AMVE_PROP_CLIP_TRIM_RANGE PropertyData:&trimRange];
    }
    return trimRange;
}

- (AMVE_POSITION_RANGE_TYPE)getClipTrimRangeByIndex:(MDWord)dwIndex {
    CXiaoYingClip *cXiaoYingClip = [self getClipByIndex:dwIndex];
    return [self getClipTrimRangeByClip:cXiaoYingClip];
}

- (AMVE_POSITION_RANGE_TYPE)getClipTrimRange:(MDWord)dwIndex {
    return [self getClipTrimRangeByIndex:dwIndex];
}

#pragma mark - 8.0.0 Effect Vision
#pragma mark - Text
- (CXiaoYingEffect *)setTextEffect:(XYMultiTextInfo *)multiTextInfo layerId:(float)layerId {
    if (!self.cXiaoYingStoryBoardSession) {
        return nil;
    }
    
    CXiaoYingClip *pStbDataClip;
    if (multiTextInfo.pClip) {
        pStbDataClip = multiTextInfo.pClip;
    } else {
        if (layerId < LAYER_ID_SUBTITLE) {
            layerId = LAYER_ID_SUBTITLE;
        }
        pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
    }

    MRESULT ret = QVET_ERR_NONE;

    CXiaoYingEngine *pEngine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
    if (!pEngine)
        return nil;

    CXiaoYingEffect *pEffect = [[CXiaoYingEffect alloc] init];
//    if (textInfo.dwVersion >= QVET_SENIOR_TEXT_VERSION) {
//        ret = [pEffect Create:pEngine
//                   EffectType:AMVE_EFFECT_TYPE_VIDEO_IE
//                    TrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO
//                      GroupID:GROUP_TEXT_FRAME
//                      LayerID:layerId];
//    } else {
        ret = [pEffect Create:pEngine
                   EffectType:AMVE_EFFECT_TYPE_VIDEO_FRAME
                    TrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO
                      GroupID:GROUP_TEXT_FRAME
                      LayerID:layerId];
//    }

    ret = [pStbDataClip insertEffect:pEffect];
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_LAYER
                  PropertyData:&layerId];
    MBool supportInstantRefresh = MTrue;
    ret = [pEffect setProperty:AVME_PROP_EFFECT_INSTANT_VIDEO_TRANSFORM_SET PropertyData:&supportInstantRefresh];
    [self setEffectIdentifier:pEffect identifier:multiTextInfo.identifier];
    ret = [self setTextEffect:multiTextInfo effect:pEffect];
    return pEffect;
}

- (MRESULT)setTextEffect:(XYMultiTextInfo *)multiTextInfo effect:(CXiaoYingEffect *)pEffect {
    if (!pEffect) {
        return QVET_ERR_APP_NULL_POINTER;
    }
    
    MRESULT ret = QVET_ERR_NONE;
    MRECT rcRegionRatio = multiTextInfo.rcRegionRatio;
    MFloat fRotateAngle = multiTextInfo.fRotateAngle;
    
    MBool instantRefresh = multiTextInfo.isInstantRefresh?MTrue:MFalse;
    ret = [pEffect setProperty:AVME_PROP_EFFECT_INSTANT_VIDEO_TRANSFORM_APPLY PropertyData:&instantRefresh];
    
    MBool isStatic = multiTextInfo.isStaticPicture ? MTrue : MFalse;
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_STATIC
                  PropertyData:&isStatic];
    CHECK_VALID_RET(ret);
    
    if (multiTextInfo.isInstantRefresh) {
        ret = [pEffect setProperty:AVME_PROP_EFFECT_INSTANT_VIDEO_REGION
                      PropertyData:(MVoid *)&rcRegionRatio];
        ret = [pEffect setProperty:AVME_PROP_EFFECT_INSTANT_VIDEO_ROTATION PropertyData:&fRotateAngle];
        return ret;//只是InstantRefresh的话，其它这堆参数不需要重新设置，所以这里直接return
    }
    
    {
        NSString *templatePath;
        if (self.templateDelegate && [self.templateDelegate respondsToSelector:@selector(onGetTemplateFilePathWithID:)]) {
            templatePath = [self.templateDelegate onGetTemplateFilePathWithID:multiTextInfo.textTemplateID];
        }
        
        CXiaoYingStyle *qStyle = [[CXiaoYingStyle alloc] init];
        CXiaoYingTextMulInfo *pMulInfo = MNull;
        AMVE_MUL_BUBBLETEXT_INFO *pcMulInfo = MNull;
        AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleMulSource = MNull;
        MPOINT pStbSize = {0};
        ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
        MSIZE size = {pStbSize.x, pStbSize.y};
        
        ret = [qStyle Create:[templatePath UTF8String] BGLayoutMode:0 SerialNo:nil];
        pMulInfo = [qStyle GetTextMulInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine] languageID:[NSNumber xy_getLanguageID:[self fetchLanguageCode]] bgSize:size];
        pcMulInfo = [pMulInfo getMulInfo];

        pBubbleMulSource = (AMVE_BUBBLETEXT_SOURCE_TYPE *)MMemAlloc(MNull, pcMulInfo->dwTextCount * sizeof(AMVE_BUBBLETEXT_SOURCE_TYPE));
        for (MDWord i = 0; i < pcMulInfo->dwTextCount; i++)
        {
         
            XYMultiSubTextInfo *textInfo = [XYMultiSubTextInfo new];
            if (i < multiTextInfo.subTextInfoList.count) {
                textInfo = multiTextInfo.subTextInfoList[i];
            }
            AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = [XYEditUtils allocBubbleSource];
            if (![NSString xy_isEmpty:textInfo.text]) {
                MTChar *pszInput = (MTChar *)[textInfo.text UTF8String];
                if (MNull == pszInput) {
                    pszInput = (MTChar *)[@" " UTF8String];
                }
                MStrCpy(pBubbleSource->pszText, pszInput);
            }
            
            pBubbleSource->bHorReversal = textInfo.bHorReversal;
            pBubbleSource->bVerReversal = textInfo.bVerReversal;
            pBubbleSource->rcRegionRatio = multiTextInfo.textRegionRatio;
            pBubbleSource->fRotateAngle = multiTextInfo.fRotateAngle;
            pBubbleSource->dwTransparency = multiTextInfo.dwTransparency;
            pBubbleSource->llTemplateID = multiTextInfo.textTemplateID;
            
            NSInteger nChangeFlag = QVET_TEXT_CHANGE_FLAG_ALIGN
            |QVET_TEXT_CHANGE_FLAG_FRONT_FILE
            |QVET_TEXT_CHANGE_FLAG_TEXT_COLOR
            |QVET_TEXT_CHANGE_FLAG_STROKE
            |QVET_TEXT_CHANGE_FLAG_BOLD
            |QVET_TEXT_CHANGE_FLAG_ITALIC
            |QVET_TEXT_CHANGE_FLAG_LINE_SPACE
            |QVET_TEXT_CHANGE_FLAG_WORD_SPACE
            |QVET_TEXT_CHANGE_FLAG_SHADOW
            |QVET_TEXT_CHANGE_FLAG_FONT_SIZE;
            
            pBubbleSource->nChangeFlag = nChangeFlag;
            pBubbleSource->clrBackground = 0;
            pBubbleSource->clrText = textInfo.clrText;
            pBubbleSource->dwTextAlignment = textInfo.dwTextAlignment;
            pBubbleSource->TextExtraEffect.bEnableEffect = textInfo.bEnableEffect;
            pBubbleSource->TextExtraEffect.dwShadowColor = textInfo.dwShadowColor;
            pBubbleSource->TextExtraEffect.fDShadowBlurRadius = textInfo.fDShadowBlurRadius;
            pBubbleSource->TextExtraEffect.fDShadowXShift = textInfo.fDShadowXShift;
            pBubbleSource->TextExtraEffect.fDShadowYShift = textInfo.fDShadowYShift;
            pBubbleSource->TextExtraEffect.dwStrokeColor = textInfo.dwStrokeColor;
            pBubbleSource->TextExtraEffect.fStrokeWPercent = textInfo.fStrokeWPercent;
            
            if (![NSString xy_isEmpty:textInfo.fontName]) {
                MTChar *pszFontName = (MTChar *)[textInfo.fontName UTF8String];
                MStrCpy(pBubbleSource->pszAuxiliaryFont, pszFontName);
            }
            pBubbleMulSource[i] = *pBubbleSource;
            pBubbleMulSource[i].dwParamID = pcMulInfo->pMulBTInfo[i].dwParamID;
        }
      
        
        AMVE_MEDIA_MULTI_SOURCE_TYPE mediaMulSrc = {0};
        
        mediaMulSrc.bIsTmpSrc = MTrue;
        mediaMulSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_BUBBLETEXT;
        mediaMulSrc.dwSourceCount = pcMulInfo->dwTextCount;
        mediaMulSrc.pSource = pBubbleMulSource;
      //  pBubbleSource->dwParamID = 5000;
        ret = [pEffect setProperty:AMVE_PROP_VIDEO_FRAME_MULTI_SOURCE
                      PropertyData:&mediaMulSrc];
        CHECK_VALID_RET(ret);
          MMemFree(MNull, pBubbleMulSource);
    }

    if (!multiTextInfo.isInstantRefresh) {
        ret = [pEffect setProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO
        PropertyData:(MVoid *)&rcRegionRatio];
        ret = [pEffect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
        ret = [self setkeyFrameTypeEffectRegionRatioWithEffect:pEffect];
        CHECK_VALID_RET(ret);
    }

    MPOINT pStbSize = {0};
    ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
    MSIZE size = {pStbSize.x, pStbSize.y};
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_BG_RESOLUTION
                  PropertyData:&size];
    CHECK_VALID_RET(ret);

    MBool isFrameMode = multiTextInfo.isFrameMode ? MTrue : MFalse;
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_IS_FRAME_MODE
                  PropertyData:&isFrameMode];
    CHECK_VALID_RET(ret);
    
    
    [self setEffectUserData:pEffect effectUserData:multiTextInfo.userData];

    [self setModified:YES];
    return ret;
}


- (XYMultiTextInfo *)getStoryboardTextInfo:(CXiaoYingEffect *)effect {
    if (!effect) {
        return nil;
    }
    MRESULT res = QVET_ERR_NONE;
    MFloat layerID;
    res = [effect getProperty:AMVE_PROP_EFFECT_LAYER PropertyData:&layerID];
    if (res != QVET_ERR_NONE) {
        return nil;
    }
    MDWord groupID;
    res = [effect getProperty:AMVE_PROP_EFFECT_GROUP PropertyData:&groupID];
    if (res != QVET_ERR_NONE) {
        return nil;
    }
    
    AMVE_MEDIA_MULTI_SOURCE_TYPE mediaMulSrc = {0};
    AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = [XYEditUtils allocBubbleSource];
    mediaMulSrc.pSource = pBubbleSource;
    mediaMulSrc.bIsTmpSrc = MTrue;
    mediaMulSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_BUBBLETEXT;
    res = [effect getProperty:AMVE_PROP_VIDEO_FRAME_MULTI_SOURCE
                    PropertyData:&mediaMulSrc];
    if (res != QVET_ERR_NONE) {
          return nil;
      }
    NSMutableArray *subTextList = [NSMutableArray array];
    XYMultiTextInfo *multiTextInfo = [[XYMultiTextInfo alloc] init];
    AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleMulSource = (AMVE_BUBBLETEXT_SOURCE_TYPE *)mediaMulSrc.pSource;
    for (int i = 0; i < mediaMulSrc.dwSourceCount; i ++) {
        AMVE_BUBBLETEXT_SOURCE_TYPE *pBubbleSource = &pBubbleMulSource[i];
        XYMultiSubTextInfo *textInfo = [[XYMultiSubTextInfo alloc] init];
        multiTextInfo.textTemplateID = pBubbleSource->llTemplateID;
        multiTextInfo.isAnimatedText = [self isAnimatedText:multiTextInfo.textTemplateID];
        textInfo.text = pBubbleSource->pszText == MNull ? @"" : [NSString stringWithUTF8String:pBubbleSource->pszText];
        textInfo.clrText = pBubbleSource->clrText;
        if (textInfo.clrText == 0) {
            textInfo.clrText = 0xFFFFFF;
        }
        multiTextInfo.fRotateAngle = pBubbleSource->fRotateAngle;
        textInfo.textColor = [self colorWithHex:pBubbleSource->clrText];
        textInfo.bVerReversal = pBubbleSource->bVerReversal;
        textInfo.bHorReversal = pBubbleSource->bHorReversal;
        multiTextInfo.textRegionRatio = pBubbleSource->rcRegionRatio;

        NSString *path = nil;
        if (self.templateDelegate && [self.templateDelegate respondsToSelector:@selector(onGetTemplateFilePathWithID:)]) {
            path = [self.templateDelegate onGetTemplateFilePathWithID:multiTextInfo.textTemplateID];
            multiTextInfo.textTemplateFilePath = path;
        }

        if (pBubbleSource->pszText != MNull && pBubbleSource->pszAuxiliaryFont) {
            textInfo.fontName = [NSString stringWithUTF8String:pBubbleSource->pszAuxiliaryFont];
        }

        //如果是主题文字，不需要取textLine信息
        if (groupID != GROUP_THEME_TEXT_FRAME) {
            NSString *pBubbleTemplate = multiTextInfo.textTemplateFilePath;
            CXiaoYingStoryBoardSession *stb = [self getStoryboardSession];
            if (stb) {
                MPOINT stbSize = {0};
                [stb getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&stbSize];
                MSIZE BGSize = {stbSize.x, stbSize.y};
                XY_BUBBLE_MEASURE_RESULT BMR = {0};
                res = [CXiaoYingStyle measureBubbleByTemplate:pBubbleTemplate
                                                       BGSize:&BGSize
                                                bubbleTextSrc:pBubbleSource
                                                       result:&BMR];
                textInfo.textLine = BMR.textLines;
            }
        }
        //

        MBool isStatic = MTrue;
        MRESULT ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_STATIC PropertyData:&isStatic];
        multiTextInfo.isStaticPicture = (isStatic == MTrue);

        AMVE_POSITION_RANGE_TYPE effectRange = {0};
        ret = [effect getProperty:AMVE_PROP_EFFECT_RANGE
                     PropertyData:(MVoid *)&effectRange];
        multiTextInfo.startPosition = effectRange.dwPos;
        multiTextInfo.duration = effectRange.dwLen;

        MBool isFrameMode = MFalse;
        ret = [effect getProperty:AMVE_PROP_EFFECT_IS_FRAME_MODE PropertyData:&isFrameMode];
        multiTextInfo.isFrameMode = (isFrameMode == MTrue);

        textInfo.bEnableEffect = pBubbleSource->TextExtraEffect.bEnableEffect;
        textInfo.dwShadowColor = pBubbleSource->TextExtraEffect.dwShadowColor;
        textInfo.fDShadowBlurRadius = pBubbleSource->TextExtraEffect.fDShadowBlurRadius;
        textInfo.fDShadowXShift = pBubbleSource->TextExtraEffect.fDShadowXShift;
        textInfo.fDShadowYShift = pBubbleSource->TextExtraEffect.fDShadowYShift;
        textInfo.dwStrokeColor = pBubbleSource->TextExtraEffect.dwStrokeColor;
        textInfo.fStrokeWPercent = pBubbleSource->TextExtraEffect.fStrokeWPercent;
        textInfo.dwTextAlignment = pBubbleSource->dwTextAlignment;
        [subTextList addObject:textInfo];
        multiTextInfo.subTextInfoList = subTextList;
    }
    [XYEditUtils freeBubbleSource:pBubbleMulSource];
    return multiTextInfo;
}

//- (AMVE_MUL_BUBBLETEXT_INFO *)fetchTemplateMultiTextInfo:(NSString *)templatePath {
//    
//    CXiaoYingStyle *qStyle = [[CXiaoYingStyle alloc] init];
//    CXiaoYingTextMulInfo *pMulInfo = MNull;
//    AMVE_MUL_BUBBLETEXT_INFO *pcMulInfo = MNull;
//    static MHandle hTextEngine = MNull;
//    MRESULT ret = 0;
//    MPOINT pStbSize = {0};
//    ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
//    MSIZE size = {pStbSize.x, pStbSize.y};
//    
//    ret = [qStyle Create:[templatePath UTF8String] BGLayoutMode:0 SerialNo:nil];
//    pMulInfo = [qStyle GetTextMulInfo:[[XYEngine sharedXYEngine] getCXiaoYingEngine] languageID:[NSNumber xy_getLanguageID:[self fetchLanguageCode]] bgSize:size];
//    pcMulInfo = [pMulInfo getMulInfo];
//
//    return pcMulInfo;
//}

- (XYMultiTextInfo *)getStoryboardTextInfo:(CXiaoYingEffect *)effect
                          viewFrame:(CGRect)viewFrame {
    XYMultiTextInfo *multiTextInfo = [self getStoryboardTextInfo:effect];
    if(!multiTextInfo){
        return nil;
    }
    MRESULT res = QVET_ERR_NONE;
    MFloat layerID;
    res = [effect getProperty:AMVE_PROP_EFFECT_LAYER PropertyData:&layerID];
    if(res != QVET_ERR_NONE){
        return nil;
    }
    
    MRECT rect = {0};
    res = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&rect];
    if (viewFrame.size.width > 0 && viewFrame.size.height > 0) {
        MRECT innerRect = {0};
        //    [playbackModule getViewport:&innerRect];
        innerRect.left = 0;//viewFrame.origin.x;
        innerRect.top = 0;//viewFrame.origin.y;
        innerRect.right = innerRect.left+viewFrame.size.width;
        innerRect.bottom = innerRect.top+viewFrame.size.height;
        
        MLong innerRectLeft = innerRect.left;
        MLong innerRectTop = innerRect.top;
        MLong innerRectWidth = (innerRect.right-innerRect.left);
        MLong innerRectHeight = (innerRect.bottom-innerRect.top);
        
        CGFloat finalRectLeft = innerRectLeft+rect.left/10000.0f*innerRectWidth;
        CGFloat finalRectTop = innerRectTop+rect.top/10000.0f*innerRectHeight;
        CGFloat finalRectWidth = (rect.right-rect.left)/10000.0f*innerRectWidth;
        CGFloat finalRectHeight = (rect.bottom-rect.top)/10000.0f*innerRectHeight;
        
        multiTextInfo.textRect = CGRectMake(finalRectLeft,finalRectTop,finalRectWidth,finalRectHeight);
    }
    multiTextInfo.rcRegionRatio = rect;
    return multiTextInfo;
}

- (CGSize)measureStandardTextSize:(AMVE_BUBBLETEXT_SOURCE_TYPE *)bubbleSource
             textTemplateFilePath:(NSString *)textTemplateFilePath
                      previewSize:(CGSize)previewSize {
    MPOINT stbSize = {0};
    [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&stbSize];
    MSIZE BGSize = {stbSize.x, stbSize.y};
    XY_BUBBLE_MEASURE_RESULT BMR = {0};
    
    MRESULT ret = [CXiaoYingStyle measureBubbleByTemplate:textTemplateFilePath
                                                   BGSize:&BGSize
                                            bubbleTextSrc:bubbleSource
                                                   result:&BMR];
    if (ret) {
        NSLog(@"[ENGINE]measureBubbleByTemplate failed res=0x%lx", ret);
        [XYEditUtils freeBubbleSource:bubbleSource];
        return CGSizeMake(0, 0);
    }
    
    CGFloat width = (CGFloat)BMR.bubbleW / (CGFloat)stbSize.x * previewSize.width;
    CGFloat height = (CGFloat)BMR.bubbleH / (CGFloat)stbSize.y * previewSize.height;
    
    return CGSizeMake(width, height);
}

- (BOOL)isAnimatedText:(NSInteger)templateID {
    NSInteger subType = [CXiaoYingStyle GetTemplateSubType:templateID];
    return (subType == CXY_TEXT_SUBTYPE_ANIMATION);
}

#pragma mark - Sticker
- (CXiaoYingEffect *)setSticker:(StickerInfo *)stickerInfo layerID:(MFloat)layerID groupID:(MDWord)groupID {
    if (!self.cXiaoYingStoryBoardSession) {
        return nil;
    }
    if (!stickerInfo) {
        return nil;
    }
    CXiaoYingClip *dataClip;
    if (stickerInfo.pClip) {
        dataClip = stickerInfo.pClip;
    } else {
        dataClip = [self.cXiaoYingStoryBoardSession getDataClip];
    }
    MRESULT ret = QVET_ERR_NONE;

    CXiaoYingEngine *engine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
    if (!engine) {
        return nil;
    }
    //create sticker effect
    CXiaoYingEffect *effect = [[CXiaoYingEffect alloc] init];
    ret = [effect Create:engine EffectType:AMVE_EFFECT_TYPE_VIDEO_FRAME TrackType:AMVE_EFFECT_TRACK_TYPE_VIDEO GroupID:groupID LayerID:(MFloat)layerID];
    CHECK_VALID_RET_NIL(ret);
    [self setEffectIdentifier:effect identifier:stickerInfo.identifier];
    //insert effect
    ret = [dataClip insertEffect:effect];
    CHECK_VALID_RET_NIL(ret);
    //set path
    MTChar *pszStickerPath = (MTChar *)[stickerInfo.xytFilePath UTF8String];
    AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
    mediaSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_FILE;
    mediaSrc.pSource = pszStickerPath;
    mediaSrc.bIsTmpSrc = MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSrc];
    CHECK_VALID_RET_NIL(ret);
    
    //set effect source range
    if (stickerInfo.dwSourceDuration != 0) {
        [self setEffectSourceRange:effect dwPos:stickerInfo.dwSourceStartPos dwLen:stickerInfo.dwSourceDuration];
    }
    
    //set effect source range
    if (stickerInfo.dwTrimDuration != 0) {
        [self setEffectSourceRange:effect dwPos:stickerInfo.dwTrimStartPos dwLen:stickerInfo.dwTrimDuration];
    }
    
    //set effect range
    AMVE_POSITION_RANGE_TYPE effectRange;
    effectRange.dwPos = stickerInfo.startPos;
    effectRange.dwLen = stickerInfo.dwCurrentDuration;
    ret = [effect setProperty:AMVE_PROP_EFFECT_RANGE PropertyData:(MVoid *)&effectRange];
    CHECK_VALID_RET_NIL(ret);
    
    MBool lock = MTrue;
    ret = [effect setProperty:AVME_PROP_EFFECT_INSTANT_VIDEO_TRANSFORM_SET PropertyData:&lock];
    
    //set region ratio
    MRECT rcRegionRatio = stickerInfo.rcRegionRatio;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&rcRegionRatio];
    ret = [self setkeyFrameTypeEffectRegionRatioWithEffect:effect];
    NSLog(@"region: %ld %ld %ld %ld", rcRegionRatio.top, rcRegionRatio.bottom, rcRegionRatio.left, rcRegionRatio.right);
    CHECK_VALID_RET_NIL(ret);
    
    //set layer
    ret = [effect setProperty:AMVE_PROP_EFFECT_LAYER
                 PropertyData:&layerID];
    CHECK_VALID_RET_NIL(ret);
    //set rotateAngle
    MFloat fRotateAngle = stickerInfo.fRotateAngle;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
    CHECK_VALID_RET_NIL(ret);
    //set x y flip
    MBool bVerReversal = stickerInfo.bVerReversal;
    MBool bHorReversal = stickerInfo.bHorReversal;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_X_FLIP PropertyData:&bHorReversal];
    CHECK_VALID_RET_NIL(ret);
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_Y_FLIP PropertyData:&bVerReversal];
    CHECK_VALID_RET_NIL(ret);

    MPOINT pStbSize = {0};
    ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
    CHECK_VALID_RET_NIL(ret);
    MSIZE size = {pStbSize.x, pStbSize.y};
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_BG_RESOLUTION
                 PropertyData:&size];
    CHECK_VALID_RET_NIL(ret);

    MBool isFrameMode = stickerInfo.isFrameMode ? MTrue : MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_IS_FRAME_MODE
                 PropertyData:&isFrameMode];
    CHECK_VALID_RET_NIL(ret);

    MBool isStaticPicture = stickerInfo.isStaticPicture ? MTrue : MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_FRAME_STATIC_PICTURE
                 PropertyData:&isStaticPicture];
    CHECK_VALID_RET_NIL(ret);

    //设定效果音量
    MDWord volume = stickerInfo.volume; // volume = 0, 表示该特效的声音强度为0, volue = 100 表示该effect 的强度为 100%;
    MBool bMute = MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MUTE // 3. 设置当前 effect 是否为静音, bMute = MTrue 时画中画视频为静音, bMute = MFalse 时画中画视频有声音，声音的强度百分比由 AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT 来指定;
                 PropertyData:&bMute];
    CHECK_VALID_RET_NIL(ret);
    ret = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT // 4. 设置当前 effect 是否为静音, bMute = MTrue 时画中画视频为静音, bMute = MFalse 时画中画视频有声音，声音的强度百分比由 AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT 来指定;
                 PropertyData:&volume];
    CHECK_VALID_RET_NIL(ret);

    if (groupID == GROUP_ID_COLLAGE) {
        [self setEffectTrimRange:effect dwPos:stickerInfo.dwTrimStartPos dwLen:stickerInfo.dwTrimDuration];
    }
    
    //set alpha
    MFloat falpha = stickerInfo.alpha;
    ret = [effect setProperty:AMVE_PROP_EFFECT_BLEND_ALPHA PropertyData:&falpha];
    
    [self setMosaicRatioToEffect:effect stickerInfo:stickerInfo];
    
    [self setEffectUserData:effect effectUserData:stickerInfo.userData];
    
    [self setModified:YES];
    return effect;
}

- (MRESULT)updateStickerInfo:(StickerInfo *)stickerInfo toEffect:(CXiaoYingEffect *)effect {
    MBool isInstantRefresh = stickerInfo.isInstantRefresh?MTrue:MFalse;
    MRECT rcRegionRatio = stickerInfo.rcRegionRatio;
    MFloat fRotateAngle = stickerInfo.fRotateAngle;
    
    MRESULT ret = [effect setProperty:AVME_PROP_EFFECT_INSTANT_VIDEO_TRANSFORM_APPLY PropertyData:&isInstantRefresh];
    
    MBool isStaticPicture = stickerInfo.isStaticPicture ? MTrue : MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_FRAME_STATIC_PICTURE
                 PropertyData:&isStaticPicture];
    CHECK_VALID_RET_NIL(ret);
    
    if (stickerInfo.isInstantRefresh) {//快速刷新旋转角度及区域
        ret = [effect setProperty:AVME_PROP_EFFECT_INSTANT_VIDEO_REGION PropertyData:&rcRegionRatio];
        ret = [effect setProperty:AVME_PROP_EFFECT_INSTANT_VIDEO_ROTATION PropertyData:&fRotateAngle];
        NSLog(@"Instant region: %ld %d %ld %ld", rcRegionRatio.top, rcRegionRatio.bottom, rcRegionRatio.left, rcRegionRatio.right);
        return ret;
    }
    
    //set effect source range
    if (stickerInfo.dwSourceDuration != 0) {
        [self setEffectSourceRange:effect dwPos:stickerInfo.dwSourceStartPos dwLen:stickerInfo.dwSourceDuration];
    }
    
    //set effect source range
    if (stickerInfo.dwTrimDuration != 0) {
        [self setEffectSourceRange:effect dwPos:stickerInfo.dwTrimStartPos dwLen:stickerInfo.dwTrimDuration];
    }
    
    //set effect range
    AMVE_POSITION_RANGE_TYPE effectRange = {stickerInfo.startPos, stickerInfo.dwCurrentDuration};
    ret = [effect setProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&effectRange];
    CHECK_VALID_RET_NIL(ret);
    
    //set path
    MTChar *pszStickerPath = (MTChar *)[stickerInfo.xytFilePath UTF8String];
    AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
    mediaSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_FILE;
    mediaSrc.pSource = pszStickerPath;
    mediaSrc.bIsTmpSrc = MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSrc];
    CHECK_VALID_RET_NIL(ret);
    
    //正常刷新旋转角度及区域
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&rcRegionRatio];
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
    ret = [self setkeyFrameTypeEffectRegionRatioWithEffect:effect];
    NSLog(@"Normal region: %ld %d %ld %ld", rcRegionRatio.top, rcRegionRatio.bottom, rcRegionRatio.left, rcRegionRatio.right);
    CHECK_VALID_RET(ret);
    
    //set x y flip
    MBool bVerReversal = stickerInfo.bVerReversal;
    MBool bHorReversal = stickerInfo.bHorReversal;
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_X_FLIP PropertyData:&bHorReversal];
    CHECK_VALID_RET(ret);
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_Y_FLIP PropertyData:&bVerReversal];
    CHECK_VALID_RET(ret);
    MPOINT pStbSize = {0};
    ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
    CHECK_VALID_RET(ret);
    MSIZE size = {pStbSize.x, pStbSize.y};
    ret = [effect setProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_BG_RESOLUTION
                 PropertyData:&size];
    CHECK_VALID_RET(ret);
    //set alpha
    MFloat falpha = stickerInfo.alpha;
    ret = [effect setProperty:AMVE_PROP_EFFECT_BLEND_ALPHA PropertyData:&falpha];
    CHECK_VALID_RET(ret);
    
    [self setMosaicRatioToEffect:effect stickerInfo:stickerInfo];
    
    [self setEffectUserData:effect effectUserData:stickerInfo.userData];
    
    //设定效果音量
    MDWord volume = stickerInfo.volume; // volume = 0, 表示该特效的声音强度为0, volue = 100 表示该effect 的强度为 100%;
    MBool bMute = MFalse;
    ret = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MUTE // 3. 设置当前 effect 是否为静音, bMute = MTrue 时画中画视频为静音, bMute = MFalse 时画中画视频有声音，声音的强度百分比由 AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT 来指定;
                 PropertyData:&bMute];
    CHECK_VALID_RET_NIL(ret);
    ret = [effect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT // 4. 设置当前 effect 是否为静音, bMute = MTrue 时画中画视频为静音, bMute = MFalse 时画中画视频有声音，声音的强度百分比由 AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT 来指定;
                 PropertyData:&volume];
    CHECK_VALID_RET_NIL(ret);
    
    [self setModified:YES];
    return ret;
}

- (StickerInfo *)getStoryboardStickerInfo:(CXiaoYingEffect *)effect {
    if (!effect) {
        return nil;
    }
    StickerInfo *stickerInfo = [[StickerInfo alloc] init];

    MRESULT ret = QVET_ERR_NONE;

    AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
    
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSrc];
    if (mediaSrc.dwSrcType != AMVE_MEDIA_SOURCE_TYPE_FILE)
        return nil;
    mediaSrc.pSource = malloc(1024);
    memset(mediaSrc.pSource, 0, 1024);
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_SOURCE PropertyData:&mediaSrc];
    if (ret) {
        return nil;
    }
    //CHECK_VALID_RET_NIL(ret)
    MTChar *pszStickerPath = (MTChar *)mediaSrc.pSource;
    NSString *path = [NSString stringWithUTF8String:pszStickerPath];
    free(mediaSrc.pSource);
    stickerInfo.xytFilePath = path;

    AMVE_POSITION_RANGE_TYPE effectRange;
    ret = [effect getProperty:AMVE_PROP_EFFECT_RANGE PropertyData:&effectRange];
    stickerInfo.startPos = effectRange.dwPos;
    stickerInfo.dwCurrentDuration = effectRange.dwLen;

    MRECT regionRatio = {0};
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_REGION_RATIO PropertyData:&regionRatio];
    stickerInfo.rcRegionRatio = regionRatio;

    MFloat fRotateAngle;
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_ROTATION PropertyData:&fRotateAngle];
    stickerInfo.fRotateAngle = fRotateAngle;

    MBool bVerReversal, bHorReversal;
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_X_FLIP PropertyData:&bHorReversal];
    ret = [effect getProperty:AMVE_PROP_EFFECT_VIDEO_FRAME_Y_FLIP PropertyData:&bVerReversal];
    stickerInfo.bHorReversal = bHorReversal;
    stickerInfo.bVerReversal = bVerReversal;

    MFloat layerID;
    ret = [effect getProperty:AMVE_PROP_EFFECT_LAYER PropertyData:&layerID];
    stickerInfo.layerID = layerID;

    MBool isFrameMode = MFalse;
    ret = [effect getProperty:AMVE_PROP_EFFECT_IS_FRAME_MODE PropertyData:&isFrameMode];
    stickerInfo.isFrameMode = (isFrameMode == MTrue);

    MBool isStaticPicture = MFalse;
    ret = [effect getProperty:AMVE_PROP_EFFECT_FRAME_STATIC_PICTURE PropertyData:&isStaticPicture];
    stickerInfo.isStaticPicture = (isStaticPicture == MTrue);
    
    //获取快速刷新flag
    MBool isInstantRefresh = MFalse;
    ret = [effect getProperty:AVME_PROP_EFFECT_INSTANT_VIDEO_TRANSFORM_APPLY PropertyData:&isInstantRefresh];
    stickerInfo.isInstantRefresh = (isInstantRefresh == MTrue);
    
    MFloat alpha = 1.0;
    ret = [effect getProperty:AMVE_PROP_EFFECT_BLEND_ALPHA PropertyData:&alpha];
    stickerInfo.alpha = alpha;
    
    //处理效果中声音相关逻辑
    BOOL hasAudio = NO;
    NSInteger groupID = [self getEffectGroupId:effect];
    if (groupID == GROUP_ID_COLLAGE || groupID == GROUP_STICKER || GROUP_ANIMATED_FRAME) {
        //获取贴纸或特效中是否有音频文件
        char szPath[AMVE_MAXPATH];
        AMVE_MEDIA_SOURCE_TYPE  source;
        source.pSource = MNull;
        ret = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_SOURCE PropertyData:&source];
        if(ret == 0 && source.dwSrcType == AMVE_MEDIA_SOURCE_TYPE_FILE) {
            source.pSource = szPath;
            ret = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_SOURCE PropertyData:&source];
            hasAudio = (ret == 0);
        }
    }
    
    stickerInfo.bHasAudio = hasAudio?MTrue:MFalse;
    //支持声音的话，获取音量
    if (hasAudio) {
        NSInteger volume = 50;
        ret = [effect getProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_MIXPERCENT PropertyData:&volume];
        stickerInfo.volume = volume;
    }
    
    [self updateStickerInfoByEffect:effect stickerInfo:stickerInfo];

    return stickerInfo;
}

#pragma mark - Mosaic
- (void)updateStickerInfoByEffect:(CXiaoYingEffect *)effect stickerInfo:(StickerInfo *)stickerInfo {
    MRESULT ret = 0;
    if ([stickerInfo.xytFilePath hasSuffix:@"0x0500000000300001.xyt"]) { //像素化
        MPOINT pStbSize = {0};
        MRESULT ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
        MWord hor_id = 1;
        MWord ver_id = 2;
        MFloat max_value;
        if (pStbSize.x > pStbSize.y) {//width > height
            max_value = pStbSize.x * VIVAVIDEO_MOSAIC_PIXEL_MAX_RATIO;
            QVET_EFFECT_PROPDATA propData = {hor_id,0};
            ret = [effect getProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&propData];
            stickerInfo.mosaicRatio = (propData.lValue * 1.0) / max_value;
        }else {
            max_value = pStbSize.y * VIVAVIDEO_MOSAIC_PIXEL_MAX_RATIO;
            QVET_EFFECT_PROPDATA propData = {ver_id,0};
            ret = [effect getProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&propData];
            stickerInfo.mosaicRatio = (propData.lValue * 1.0) / max_value;
        }
    } else if ([stickerInfo.xytFilePath hasSuffix:@"0x0500000000300002.xyt"]) {
        MFloat max_value = VIVAVIDEO_MOSAIC_GAUSSIAN_MAX_VALUE;
        MWord gaussian_id = 1;
        QVET_EFFECT_PROPDATA propData = {gaussian_id,0};
        ret = [effect getProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&propData];
        stickerInfo.mosaicRatio = (propData.lValue * 1.0) / max_value;
    }
}

- (void)setMosaicRatioToEffect:(CXiaoYingEffect *)effect stickerInfo:(StickerInfo *)stickerInfo {
    MRESULT ret = 0;
    MPOINT pStbSize = {0};
    ret = [self.cXiaoYingStoryBoardSession getProperty:AMVE_PROP_STORYBOARD_OUTPUT_RESOLUTION Value:&pStbSize];
    
    if ([stickerInfo.xytFilePath hasSuffix:@"0x0500000000300001.xyt"]) { //像素化
        float resolutionRatio = (pStbSize.x * 1.0) / (pStbSize.y * 1.0);
        MDWord hor_id = 1;
        MDWord ver_id = 2;
        MFloat hor_value;
        MFloat ver_value;
        MFloat max_value;
        if (resolutionRatio > 1) { //width > height
            max_value = pStbSize.x * VIVAVIDEO_MOSAIC_PIXEL_MAX_RATIO;
            hor_value = max_value * stickerInfo.mosaicRatio;
            ver_value = (hor_value * 1.0) / resolutionRatio;
            
            if (ver_value < VIVAVIDEO_MOSAIC_PIXEL_MIN_VALUE) {
                ver_value = VIVAVIDEO_MOSAIC_PIXEL_MIN_VALUE;
                hor_value = ver_value * resolutionRatio;
            }
        }else {
            max_value = pStbSize.y * VIVAVIDEO_MOSAIC_PIXEL_MAX_RATIO;
            ver_value = max_value * stickerInfo.mosaicRatio;
            hor_value = (ver_value * 1.0) / resolutionRatio;
            
            if (hor_value < VIVAVIDEO_MOSAIC_PIXEL_MIN_VALUE) {
                hor_value = VIVAVIDEO_MOSAIC_PIXEL_MIN_VALUE;
                ver_value = hor_value * resolutionRatio;
            }
        }
        
        QVET_EFFECT_PROPDATA hor_propData = {hor_id,hor_value};
        ret = [effect setProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&hor_propData];
        
        QVET_EFFECT_PROPDATA ver_propData = {ver_id,ver_value};
        ret = [effect setProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&ver_propData];
    } else if ([stickerInfo.xytFilePath hasSuffix:@"0x0500000000300002.xyt"]) {
        MDWord hor_id = 1;
        MDWord ver_id = 2;
        MFloat max_value = VIVAVIDEO_MOSAIC_GAUSSIAN_MAX_VALUE;
        MFloat gaussian_value = stickerInfo.mosaicRatio * max_value;
        QVET_EFFECT_PROPDATA hor_propData = {hor_id,gaussian_value};
        ret = [effect setProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&hor_propData];
        
        QVET_EFFECT_PROPDATA ver_propData = {ver_id,gaussian_value};
        ret = [effect setProperty:AMVE_PROP_EFFECT_PROPDATA PropertyData:&ver_propData];
    }
}

#pragma mark -- 8.0 audio
- (CXiaoYingEffect *)setEffectAudio:(NSString *)musicFilePath
  audioTrimStartPos:(MDWord)audioTrimStartPos
    audioTrimLength:(MDWord)audioTrimLength
 storyBoardStartPos:(MDWord)storyBoardStartPos
   storyBoardLength:(MDWord)storyBoardLength
            groupID:(MDWord)groupID
            layerID:(MDWord)layerID
         mixPercent:(MDWord)mixPercent
       dwRepeatMode:(MDWord)dwRepeatMode
         audioTitle:(NSString *)audioTitle
           identifier:(NSString *)identifier {

    if (!self.cXiaoYingStoryBoardSession) {
        return nil;
    }
    CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];
    return [self setClipEffectAudio:pStbDataClip
                musicFilePath:musicFilePath
            audioTrimStartPos:audioTrimStartPos
              audioTrimLength:audioTrimLength
                   dwStartPos:storyBoardStartPos
                     dwLength:storyBoardLength
                      groupID:groupID
                      layerID:layerID
                   mixPercent:mixPercent
                 dwRepeatMode:dwRepeatMode
                         fade:groupID == GROUP_ID_BGMUSIC
                   audioTitle:audioTitle
                     identifier:identifier];
}

- (CXiaoYingEffect *)setClipEffectAudio:(CXiaoYingClip *)clip
          musicFilePath:(NSString *)musicFilePath
      audioTrimStartPos:(MDWord)audioTrimStartPos
        audioTrimLength:(MDWord)audioTrimLength
             dwStartPos:(MDWord)dwStartPos
               dwLength:(MDWord)dwLength
                groupID:(MDWord)groupID
                layerID:(MDWord)layerID
             mixPercent:(MDWord)mixPercent
           dwRepeatMode:(MDWord)dwRepeatMode
                   fade:(BOOL)fade
             audioTitle:(NSString *)audioTitle
             identifier:(NSString *)identifier {
    if (!clip) {
        return nil;
    }
    MRESULT ret = QVET_ERR_NONE;

    CXiaoYingEngine *pEngine = [[XYEngine sharedXYEngine] getCXiaoYingEngine];
    if (!pEngine)
        return nil;

    CXiaoYingEffect *pEffect;
    CXiaoYingClip *pStbDataClip = [self.cXiaoYingStoryBoardSession getDataClip];

    if (clip.hClip == pStbDataClip.hClip) { //[self.cXiaoYingStoryBoardSession getDataClip]; 返回的地址每次都不一样,里面的hClip是一样的
        pEffect = [self getStoryboardEffectByTime:dwStartPos dwTrackType:AMVE_EFFECT_TRACK_TYPE_AUDIO groupId:groupID];
    } else {
        pEffect = [clip getEffect:AMVE_EFFECT_TRACK_TYPE_AUDIO GroupID:groupID EffectIndex:0];
    }

    if (!pEffect) {
        pEffect = [[CXiaoYingEffect alloc] init];
        ret = [pEffect Create:pEngine
                   EffectType:AMVE_EFFECT_TYPE_AUDIO_FRAME
                    TrackType:AMVE_EFFECT_TRACK_TYPE_AUDIO
                      GroupID:groupID
                      LayerID:layerID];
        ret = [clip insertEffect:pEffect];
        if ([NSString xy_isEmpty:identifier]) {
            identifier = [XYStoryboard createIdentifier];
        }
        ret = [self setEffectIdentifier:pEffect identifier:identifier];
    }

    const MTChar *pszBGFile = [musicFilePath UTF8String];

    //1. set BGM media src
    AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
    mediaSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_FILE;
    mediaSrc.pSource = (MVoid *)pszBGFile;
    if ([NSString xy_isEmpty:audioTitle]) {
        audioTitle = @"";
    }
    const MTChar *titleChar = [audioTitle UTF8String];
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_TITLE
                  PropertyData:titleChar];
    
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_SOURCE
                  PropertyData:&mediaSrc];

    //音量默认设为100
    QVET_AUDIO_GAIN gain = {0};
    BOOL isMix = YES;
    [pEffect setProperty:AMVE_PROP_EFFECT_USE_NEW_ADUIO_MIX_MODE PropertyData:&isMix];
    MDWord rangeList[2] = {0, -1};
    gain.timePos = &rangeList;
    MFloat gainVlaue = (MFloat)(100 / 100.0);
    MFloat gainList[2] = {gainVlaue, gainVlaue};
    gain.gain = &gainList;
    gain.cap = gain.count = 2;
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_GAIN PropertyData:&gain];

    //3. set mix range
    AMVE_POSITION_RANGE_TYPE SrcRange;
    SrcRange.dwPos = audioTrimStartPos;
    SrcRange.dwLen = audioTrimLength;
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_RANGE
                  PropertyData:(MVoid *)&SrcRange];

    AMVE_POSITION_RANGE_TYPE EffectRange;
    EffectRange.dwPos = dwStartPos;
    EffectRange.dwLen = dwLength;
    ret = [pEffect setProperty:AMVE_PROP_EFFECT_RANGE
                  PropertyData:(MVoid *)&EffectRange];

    //4. set repeat mode
     ret = [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_REPEAT_MODE
                         PropertyData:(MVoid *)&dwRepeatMode];
    if (fade) {
        if (dwLength < 4000) {

        } else {
            MDWord fadeinDuration = 2000;
            MDWord fadeoutDuration = 2000;
            //fadein
            [self setBGMFadeIsfadeInElseFadeOut:YES closeFade:NO pEffect:pEffect fadeDuration:fadeinDuration dwLength:dwLength];
            //fadeout
            [self setBGMFadeIsfadeInElseFadeOut:NO closeFade:NO pEffect:pEffect fadeDuration:fadeoutDuration dwLength:dwLength];
        }
    }
    [self setModified:YES];
    return pEffect;
}

- (void)setAudioTitle:(CXiaoYingEffect *)pEffect audioTitle:(NSString *)audioTitle {
    const MTChar *titleChar = [audioTitle UTF8String];
    [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_TITLE
                  PropertyData:titleChar];
}

- (void)replaceAudioMusicFilePath:(NSString *)musicFilePath pEffect:(CXiaoYingEffect *)pEffect {
    if ([NSString xy_isEmpty:musicFilePath]) {
        return;
    }
    const MTChar *pszBGFile = [musicFilePath UTF8String];
    AMVE_MEDIA_SOURCE_TYPE mediaSrc = {0};
    mediaSrc.dwSrcType = AMVE_MEDIA_SOURCE_TYPE_FILE;
    mediaSrc.pSource = (MVoid *)pszBGFile;
    [pEffect setProperty:AMVE_PROP_EFFECT_AUDIO_FRAME_SOURCE
                  PropertyData:&mediaSrc];
}

- (MSIZE)getThemeInnerBestSize:(NSString *)themePath { //获取主题里推荐的比例
    MSIZE result = {0};
    if(!themePath)
    {
        return result;
    }
    CXiaoYingStyle *style = [[CXiaoYingStyle alloc] init];
    MRESULT res = [style Create:[themePath UTF8String] BGLayoutMode:QVTP_LAYOUT_MODE_PORTRAIT SerialNo:MNull];
    res = [style GetThemeExportSize:&result];
    return result;
}


- (void)setAudioNSX:(CXiaoYingClip *)clip on:(BOOL)on {
    MBool isNeedNSX = on?MTrue:MFalse;
#ifdef AMVE_PROP_CLIP_AUDIO_IS_NEED_NSX
    [clip setProperty:AMVE_PROP_CLIP_AUDIO_IS_NEED_NSX PropertyData:&isNeedNSX];
#endif
}

- (BOOL)isAudioNSXOn:(CXiaoYingClip *)clip {
    MBool isNeedNSX = MFalse;
#ifdef AMVE_PROP_CLIP_AUDIO_IS_NEED_NSX
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_AUDIO_IS_NEED_NSX PropertyData:&isNeedNSX];
#endif
    return isNeedNSX == MTrue;
}

- (void)showStoryboardTextLayer:(CXiaoYingEffect *)effect
     showLayer:(BOOL)showLayer
                 playbackModule:(id)playbackModule {
    
}


- (BOOL)is64bit
{
#if defined(__LP64__) && __LP64__
    return YES;
#else
    return NO;
#endif
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActiveNotification:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackgroundNotification:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
}

- (void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification
{
    self.isInBackground = NO;
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
    self.isInBackground = YES;
}

- (void)setTextDataSourceDelegate:(id<QVEngineDataSourceProtocol>)textDataSourceDelegate {
    _textDataSourceDelegate = textDataSourceDelegate;
    [XYAutoEditMgr sharedInstance].textDataSourceDelegate = textDataSourceDelegate;
}

- (NSString *)languageCode {
    if (!_languageCode) {
        _languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
        if (!_languageCode) {
            if (@available(macOS 10.12, iOS 10.0, *)) {
                _languageCode = [NSLocale currentLocale].languageCode;
            }
        }
    }
    return _languageCode;
}

- (NSString *)fetchLanguageCode {
     NSString *langCode = [XYStoryboard sharedXYStoryboard].languageCode;
       if ([[XYStoryboard sharedXYStoryboard].dataSource respondsToSelector:@selector(languageCode)]) {
          NSString *code = [[XYStoryboard sharedXYStoryboard].dataSource languageCode];
           if (![NSString xy_isEmpty:code]) {
               langCode = code;
           }
       }
    return langCode;
}

@end
