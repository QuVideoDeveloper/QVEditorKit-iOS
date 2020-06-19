//
//  XYXYTemplateDataMgr.m
//  XiaoYing
//
//  Created by Mac on 13-10-18.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//
#import <XYCategory/XYCategory.h>
#import "XYTemplateDataMgr.h"

//system
#import <CoreText/CoreText.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
//engine
#import "stylefilehead.h"
#import "amvedef.h"
#import "XYEngine.h"
#import "CXiaoYingInc.h"
#import "NSNumber+Language.h"

//common kit & third party sdk
//#import <XYUIKit/XYUIKit.h>
//#import <XYXMLDictionary/XYXMLDictionary.h>
//#import <XYVivaUserCenter/XYVivaUserCenter.h>
#import <XYDatabase/XYDBUtility.h>
#import <FMDB/FMDB.h>


#import "XYTemplateDBDefine.h"

#import <XYCategory/XYCategory.h>
#import <QVBaseKit/QVBaseKit.h>
#import "XYXMLDictionary.h"

#define PREF_KEY_SAVED_TEMPLATE_MGR_VERSION     @"pref_key_saved_template_mgr_version"

#define DEFAULT_DOWNLOAD_ORDERNO                1
#define DEFAULT_INSIDE_ORDERNO                  100

#define DEFAULT_TEMPLATE_FILE_EXT               @"xyt"
#define DEFAULT_ZIP_FILE_EXT                    @"zip"
#define DEFAULT_TTF_FILE_EXT                    @"ttf"
#define DEFAULT_OTF_FILE_EXT                    @"otf"


#define TEMPLATE_PROGRESS_DOWNLOAD_COPY         10
#define TEMPLATE_PROGRESS_PRIVATE_COPY          30

#define TEMPLATE_PROGRESS_COPY                  40
#define TEMPLATE_PROGRESS_GET_LIST              2
#define TEMPLATE_PROGRESS_PREINSTALL            58


#define XYTEMPLATE_PRODUCT_ID_MASK              0x0000F00000000000LL
#define XYTEMPLATE_PRODUCT_ID_VIVAVIDEO         0
#define XYTEMPLATE_PRODUCT_ID_LIVESHOW          4


//support test gift xyt  in XiaoYing
//#define SUPPORT_TEST_TEMPLATE          1

//test xyt folder
#define APP_TEMPLATES_PATH_TEST          [NSString stringWithFormat:@"%@/data/test",APP_APPLICATION_SUPPORT_PATH]

const static UInt64 ORDER_FIRST_TEMPLATE_LIST[] = {
    TEMPLATE_DEFAULT_EFFECT,//default effect
    TEMPLATE_DEFAULT_TRANSITION,//default transition
    TEMPLATE_DEFAULT_THEME,//default theme
    TEMPLATE_DEFAULT_TEXT //default bubble
};

const static UInt64  NONE_TEMPLATEID_LIST[] = {
    0x0400000000000000LL,//default effect
    0x0300000000000000LL,//default transition
    0x0100000000000000LL,//default theme
    0x0600000000000000LL,//ne animate frame
    0x0900000000000000LL,
    0x0700000000000000LL,
    0x0800000000000000LL,
    0x0900000000000001LL,
};

const static UInt64 COMMON_INVISIBLE_TEMPLATE_LIST[] =  {
    0x0400030000000038LL  //pan&zoom
};

@implementation XYTemplateItemData

- (id)init {
    self = [super init];
    if (self) {
        _lID             = 0;
        _strPath         = nil;
        _strTitle        = nil;
        _strLogo         = nil;
        _nVersion        = 0;
        _nOrder          = DEFAULT_INSIDE_ORDERNO;
        _nOriOrder       = DEFAULT_INSIDE_ORDERNO;
        _nSubOrder       = DEFAULT_INSIDE_ORDERNO;
        _nFromType       = 0;
        _lUpdateTime     = 0;
        _nFavorite       = 0;
        _strExtInfo      = nil;
        _lLayoutFlag     = 0;
    }
    return self;
}

- (BOOL)isDummy{
    return _nDownloadFlag != 0;
}

- (MDWord)fileidOfStrExtInfo
{
    MDWord nFileID = 0;
    
    if([NSString xy_isEmpty:self.strExtInfo])
    {
        return nFileID;
    }
    
    NSData *JSONData = [self.strExtInfo dataUsingEncoding: NSUTF8StringEncoding];
    
    if(JSONData)
    {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:JSONData options: 0 error:nil];
        
        if(array == nil || [array count] == 0)
        {
            return nFileID;
        }
        
        NSDictionary *dict = [array firstObject];
        
        if(dict == nil)
        {
            return nFileID;
        }
        
        nFileID = [[dict objectForKey:@"dwFileID"] intValue];
    }
    
    return nFileID;
}

@end


@interface XYTemplateDataMgr()
{
    dispatch_queue_t    _queue;
    NSMutableArray* mTemplateArray;
    int savedTemplateMgrVersion;
    int currentProgress;
    NSMutableArray *imageEffectSequenceArray;
    NSMutableArray *funnyEffectSequenceArray;
    NSMutableArray *fbEffectSequenceArray;
    NSMutableArray *animateFrameSequenceArray;
    NSMutableArray *bubbleFrameSequenceArray;
    NSMutableArray *posterSequenceArray;
    NSMutableArray *themeSequenceArray;
    NSMutableArray *themeVideoSequenceArray;
    NSMutableArray *themePhotoSequenceArray;
    NSMutableArray *transitionSequenceArray;
    NSMutableArray *defaultMusicSequenceArray;
    NSMutableArray *soundEffectSequenceArray;
    NSMutableArray *sceneSequenceArray;
    NSMutableArray *pasterSequenceArray;
    NSMutableArray *divaSequenceArray;
    NSMutableArray *pastercomboSequenceArray;
    NSMutableArray *invisibleInternationalSequenceArray;
    
    NSMutableDictionary *mDynamicListFromServer;
}

@end

@implementation XYTemplateDataMgr
@synthesize nInstallProgress;

#pragma mark -- static instance and init/scan db
+ (XYTemplateDataMgr *)sharedInstance
{
    static dispatch_once_t pred;
    static XYTemplateDataMgr *sharedInstance;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[XYTemplateDataMgr alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"task.%@", self] UTF8String], NULL);
        mTemplateArray = [[NSMutableArray alloc] init];
        mDynamicListFromServer = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)initAll
{
    [self scanDB];
    [self prepareSequenceDict];
}

- (BOOL)isInChina {
    if ([self.dataSource respondsToSelector:@selector(templateCountryIsInChina)]) {
        return [self.dataSource templateCountryIsInChina];
    } else {
        return [@"CN" isEqualToString:[self getCountryFromSimCard]];
    }
}


- (NSString *)getCountryFromSimCard {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    if (@available(iOS 12.0, *)) {
        NSDictionary *carrierDic = [info serviceSubscriberCellularProviders];
        if (carrierDic.allValues.count >= 1) {
            CTCarrier *carrier = carrierDic.allValues.firstObject;
            NSString *code = carrier.isoCountryCode;
            if (![NSString xy_isEmpty:code]) {
                return [code uppercaseString];
            }
        }
    } else {
        CTCarrier *carrier = [info subscriberCellularProvider];
        NSString *code = carrier.isoCountryCode;
        if (![NSString xy_isEmpty:code]) {
            return [code uppercaseString];
        }
    }
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}


- (void)prepareSequenceDict
{
    NSString* sequenceFilePath = [NSString stringWithFormat:@"%@/sequence.xml",APP_BUNDLE_PRIVATE_PATH];

    if ([self isInChina]) {
        sequenceFilePath = [NSString stringWithFormat:@"%@/sequence_zh_CN.xml",APP_BUNDLE_PRIVATE_PATH];
    }

    NSDictionary *sequenceDict = [[XYXMLDictionaryParser sharedInstance] dictionaryWithFile:sequenceFilePath];
    animateFrameSequenceArray = [[sequenceDict valueForKey:@"animateframe"] valueForKey:@"item"];
    bubbleFrameSequenceArray = [[sequenceDict valueForKey:@"bubbleframe"] valueForKey:@"item"];
    defaultMusicSequenceArray = [[sequenceDict valueForKey:@"defaultmusic"] valueForKey:@"item"];
    imageEffectSequenceArray = [[sequenceDict valueForKey:@"imageeffect"] valueForKey:@"item"];
    themeSequenceArray = [[sequenceDict valueForKey:@"theme"] valueForKey:@"item"];
    themeVideoSequenceArray = [[sequenceDict valueForKey:@"theme_video"] valueForKey:@"item"];
    themePhotoSequenceArray = [[sequenceDict valueForKey:@"theme_photo"] valueForKey:@"item"];
    transitionSequenceArray = [[sequenceDict valueForKey:@"transition"] valueForKey:@"item"];
    funnyEffectSequenceArray = [[sequenceDict valueForKey:@"funny"] valueForKey:@"item"];
    fbEffectSequenceArray = [[sequenceDict valueForKey:@"postfb"] valueForKey:@"item"];
    invisibleInternationalSequenceArray = [[sequenceDict valueForKey:@"international_invisible"] valueForKey:@"item"];
    posterSequenceArray = [[sequenceDict valueForKey:@"poster"] valueForKey:@"item"];
    sceneSequenceArray = [[sequenceDict valueForKey:@"pip"] valueForKey:@"item"];
    pasterSequenceArray = [[sequenceDict valueForKey:@"sticker"] valueForKey:@"item"];
    divaSequenceArray = [[sequenceDict valueForKey:@"diva"] valueForKey:@"item"];
    pastercomboSequenceArray = [[sequenceDict valueForKey:@"pastercombo"] valueForKey:@"item"];
}

-(void)scanDB {
    BOOL isNeedToUpdateTemplateVersion = [self isNeedToUpdateTemplateVersion];
    BOOL isPreInstallTemplateFinished = [self isPreInstallTemplateFinished];
    if(isNeedToUpdateTemplateVersion || isPreInstallTemplateFinished == NO){
        //delete previous install private template
        NSString *strWhere = [NSString stringWithFormat:@"%@ = 0",TEMPLATE_FROM_TYPE];
        [[[XYDBUtility shareInstance] databaseManager:@"XYTemplateDBMgr"] deleteInQueue:TBL_NAME_TEMPLATE where:strWhere];
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC", TBL_NAME_TEMPLATE, TEMPLATE_UPDATETIME];
    BOOL isHans = ([NSNumber xy_getLanguageID:[XYDeviceUtility fullLanguage]] == LANG_ID_ZH_CHS);
    NSMutableArray* missTemplate = [[NSMutableArray alloc] init];
    
    __block NSMutableArray *birdgeXYTemplateItemDataArray = [[NSMutableArray alloc] init];
    
    [[[XYDBUtility shareInstance] databaseManager:@"XYTemplateDBMgr"] queryData:sql getResult:^(FMResultSet *result) {
        if(result != nil) {
            NSString* strTemplatePath = nil;
            int nFromType;
            
            while([result next]) {
                nFromType       = [result intForColumn: TEMPLATE_FROM_TYPE];
                NSString* dbPath = [result stringForColumn: TEMPLATE_URL];
                BOOL isPrivatePathTemplate = [dbPath xy_isPrivatePathTemplate];
                if (isPrivatePathTemplate) {
                    strTemplatePath = [[result stringForColumn: TEMPLATE_URL] xy_toBundleFullPath];
                }else{
                    strTemplatePath = [[result stringForColumn: TEMPLATE_URL] xy_toTemplateFullPath];
                }
                
                if(![NSFileManager xy_isFileExist:strTemplatePath]) {
                    [missTemplate addObject:strTemplatePath];
                    NSLog(@"missTemplate:%@",strTemplatePath);
                    continue;//template miss.
                }
                
                XYTemplateItemData* item = [[XYTemplateItemData alloc] init];
                item.strPath     = strTemplatePath;
                
                NSString* strLogo = [result stringForColumn: TEMPLATE_LOGO];
                if (isPrivatePathTemplate) {
                    if ([NSString xy_isEmpty:strLogo] == NO) {
                        if ([strLogo hasPrefix:@"/data/logo"]) {
                            strLogo = [strLogo xy_toDocumentFullPath];
                        }else{
                           strLogo = nil;
                        }
                    }
                }else{
                    if ([NSString xy_isEmpty:strLogo] == NO) {
                        strLogo     = [strLogo xy_toTemplateFullPath];
                    }
                }
                
                item.strLogo = strLogo;
                
                item.lID         = [result unsignedLongLongIntForColumn: TEMPLATE_ID];
                item.strTitle    = [result stringForColumn: TEMPLATE_TITLE];
                item.nVersion        = [result intForColumn: TEMPLATE_VERSION];
                item.nOrder          = [result intForColumn: TEMPLATE_ORDERNO];
                item.nSubOrder       = [result intForColumn: TEMPLATE_SUB_ORDERNO];
                item.nFromType       = [result intForColumn: TEMPLATE_FROM_TYPE];
                item.lUpdateTime     = [result longLongIntForColumn: TEMPLATE_UPDATETIME];
                item.nFavorite       = [result intForColumn: TEMPLATE_FAVORITE];
                item.lLayoutFlag     = [result unsignedLongLongIntForColumn:TEMPLATE_LAYOUT_FLAG];
                item.strExtInfo      = [result stringForColumn: TEMPLATE_EXT_INFO];
                item.nConfigureCount = [result intForColumn:TEMPLATE_CONFIGURE_COUNT];
                item.nDownloadFlag   = [result intForColumn:TEMPLATE_DOWNLOAD_FLAG];
                item.nDelFlag = [result intForColumn:TEMPLATE_DEL_FLAG];
                item.strSceneCode = [result stringForColumn:TEMPLATE_SCENECODE];
                item.nAppFlag = [result intForColumn:TEMPLATE_APP_FLAG];
                if ([NSString xy_isEmpty:item.strSceneCode]) {
                    item.strSceneCode = @"0";
                }
                
                item.nOriOrder = item.nOrder;
                item.strLocalizedTitle = [self getTitle:item];
                item.nTemplateType = [CXiaoYingStyle GetTemplateType:item.lID];
                if((item.nTemplateType == AMVE_STYLE_MODE_SOUND_EFFECT || item.nTemplateType == AMVE_STYLE_MODE_MUSIC) && isHans){
                    item.strPinYin = [self hanziToPinYin:item.strLocalizedTitle];
                }else{
                    item.strPinYin = item.strLocalizedTitle;
                }
                
                //Use Webp thumbnail if available
                //test
                NSString *webpFilePath = [self getTemplateExternalFileInternalWithItem:item SubTemID:0 FileID:QVET_TEMPLATE_THUMBNAIL_FILE_ID];
                if (![NSString xy_isEmpty:webpFilePath]) {
                    item.strLogo = webpFilePath;
                }
                
                [birdgeXYTemplateItemDataArray addObject:item];
            }
        }
    }];
    
    dispatch_sync(_queue, ^{
        [mTemplateArray addObjectsFromArray:birdgeXYTemplateItemDataArray];
    });
    
    for(NSString* strTemplateMiss in missTemplate) {
        NSString *strWhere = [NSString stringWithFormat:@"%@ = %@",TEMPLATE_URL, strTemplateMiss];
        [[[XYDBUtility shareInstance] databaseManager:@"XYTemplateDBMgr"] deleteInQueue:TBL_NAME_TEMPLATE where:strWhere];
    }
}

#pragma mark -- utility mehtod
-(BOOL)isDefaultTemplate:(UInt64)lID {
    if(lID == 0){
        return YES;
    }
    for(int i = 0; i< sizeof(ORDER_FIRST_TEMPLATE_LIST) / sizeof(ORDER_FIRST_TEMPLATE_LIST[0]); i++) {
        if(lID == ORDER_FIRST_TEMPLATE_LIST[i])
            return YES;
    }
    return NO;
}

-(BOOL)isEmptyTemplate:(UInt64)lID {
    for(int i = 0; i< sizeof(NONE_TEMPLATEID_LIST) / sizeof(NONE_TEMPLATEID_LIST[0]); i++) {
        if(lID == NONE_TEMPLATEID_LIST[i])
            return TRUE;
    }
    return FALSE;
}

#pragma mark -- private method for scan disk
-(NSMutableArray*) getPrivateTemplateList{
    NSArray *exts = @[DEFAULT_TEMPLATE_FILE_EXT,DEFAULT_ZIP_FILE_EXT,DEFAULT_TTF_FILE_EXT,DEFAULT_OTF_FILE_EXT];
    //scan inside templates
    NSMutableArray* diskTemplateArray = [[NSMutableArray alloc] init];
    NSArray* templateScan = [NSArray xy_getFileList:APP_BUNDLE_THEMES_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_BUBBLES_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_EFFECTS_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_POSTERS_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_TEXTFRAMES_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_COVERS_PATH byExts:exts];
    if(templateScan != nil) {
        [diskTemplateArray addObjectsFromArray:templateScan];
    }

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_TRANSITIONS_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_MUSIC_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_SOUND_EFFECT_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_ANIMATED_FRAME_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_PIP_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_STICKER_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_DIVA_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

    templateScan = [NSArray xy_getFileList:APP_BUNDLE_PASTERCOMBO_PATH byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];

#ifdef SUPPORT_TEST_TEMPLATE
//#warning 为测试添加测试通道
    if(![NSFileManager xy_fileExist:APP_TEMPLATES_PATH_TEST]){
        [NSFileManager xy_createFolder:APP_TEMPLATES_PATH_TEST];
    }
    NSString *test = [NSString stringWithFormat:@"%@/",APP_TEMPLATES_PATH_TEST];
    templateScan = [NSArray xy_getFileList:test byExts:exts];
    if(templateScan != nil)
        [diskTemplateArray addObjectsFromArray:templateScan];
#endif
    return diskTemplateArray;
}

- (void)scanTemplates:(BOOL)bForce{
    //1.get private template list
    NSMutableArray* diskTemplateArray = [self getPrivateTemplateList];
    
    //2.get downloaded template list
    NSArray *exts = @[DEFAULT_TEMPLATE_FILE_EXT,DEFAULT_ZIP_FILE_EXT,DEFAULT_TTF_FILE_EXT,DEFAULT_OTF_FILE_EXT];
    NSString *templateDownloadPath = [NSString stringWithFormat:@"%@/",APP_TEMPLATES_PATH];
    NSArray* templateDownload = [NSArray xy_getFileList:templateDownloadPath byExts:exts];
    
    //3.set dialog progress
    currentProgress += TEMPLATE_PROGRESS_GET_LIST;
    [self updateTemplatePopView:currentProgress];
    
    //4.install template from private folder
    int index=0;
    int count = (int)([diskTemplateArray count] + [templateDownload count]);
    for(NSString* strTemplateFile in diskTemplateArray) {
        //If the template is forced to install or is not installed
        if(bForce || [self getByURLInternal:strTemplateFile] == nil) {
            //new template file
            [self install:strTemplateFile fromType:FROM_TYPE_LOCAL force:bForce isDeleteOriginFile:YES];
        }
        if(count>0){
            int preinstallProgress = index*TEMPLATE_PROGRESS_PREINSTALL/count;
            [self updateTemplatePopView:currentProgress+preinstallProgress];
        }
        index++;
    }
    [diskTemplateArray removeAllObjects];

    //5. install downloaded templates
    if(templateDownload != nil) {
        for(NSString* strTemplateFile in templateDownload) {
            if([self getByURLInternal:strTemplateFile] == nil) {
                //new template file
                [self install:strTemplateFile fromType:FROM_TYPE_DOWNLOAD force:YES isDeleteOriginFile:YES];
            }
            if(count>0){
                int downloadProgress = index*TEMPLATE_PROGRESS_PREINSTALL/count;
                [self updateTemplatePopView:currentProgress+downloadProgress];
            }
            index++;
        }
    }

    //6.set dialog progress to 100%
    currentProgress = 100;
    [self updateTemplatePopView:currentProgress];
}

-(void)deletePreInstallTemplate{
#warning -- todo 老小影逻辑  4.0升级5.0  建议可以删除
//    [NSFileManager xy_deleteFile:APP_ANIMATED_FRAME_PATH];
//    [NSFileManager xy_deleteFile:APP_BUBBLES_PATH];
//    [NSFileManager xy_deleteFile:APP_MUSIC_PATH];
//    [NSFileManager xy_deleteFile:APP_EFFECTS_PATH];
//    [NSFileManager xy_deleteFile:APP_PIP_PATH];
//    [NSFileManager xy_deleteFile:APP_SOUND_EFFECT_PATH];
//    [NSFileManager xy_deleteFile:APP_STICKER_PATH];
//    [NSFileManager xy_deleteFile:APP_THEMES_PATH];
//    [NSFileManager xy_deleteFile:APP_TRANSITIONS_PATH];
//    [NSFileManager xy_deleteFile:APP_DIVA_PATH];
//    [NSFileManager xy_deleteFile:APP_PASTERCOMBO_PATH];
}

-(void)deletePreDownloadTemplate{
    #warning -- todo 老小影逻辑  4.0升级5.0  建议可以删除
//    NSMutableArray* preTemplateNameList = [self getAllWorkFolderNameList];
//    if (preTemplateNameList == nil || [preTemplateNameList count] == 0) {
//        return;
//    }
//    for(NSString* folderName in preTemplateNameList){
//        NSString* filePath = [NSString stringWithFormat:@"%@/data/%@/templates",APP_APPLICATION_SUPPORT_PATH,folderName];
//        [NSFileManager xy_deleteFile:filePath];
//    }
}

//- (NSMutableArray*)getAllWorkFolderNameList{
//    NSMutableArray* folderList = [[NSMutableArray alloc] init];
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", TBL_NAME_SOCIAL_ACCOUNT];
//    [[[XYDBUtility shareInstance] databaseManager:@"XYGlobalDBManager"] queryData:sql getResult:^(FMResultSet *result) {
//        if(!result){
//            return;
//        }
//        while ([result next]) {
//            NSString* workFolderName = [result stringForColumn:ACCOUNT_WORKPATH];
//            [folderList addObject:workFolderName];
//        }
//    }];
//
//    return folderList;
//}


- (BOOL)isNeedToUpdateTemplateVersion
{
    BOOL needUpdate = NO;
    int currentTemplateVesion = CURRENT_PREINSTALLED_TEMPLATE_VERSION;
    int savedTemplateVersion = [[self xy_loadPreference:PREF_KEY_PREINSTLLED_TEMPLATE_VERSION] intValue];
    if(currentTemplateVesion >savedTemplateVersion){
        needUpdate = YES;
    }
    return needUpdate;
}

- (BOOL)isPreInstallTemplateFinished
{
    BOOL isFinished = [[self xy_loadPreference:PREF_KEY_PREINSTLLED_TEMPLATE_FINISH defaultValue:PREF_VALUE_NO] isEqualToString:PREF_VALUE_YES];
    return isFinished;
}

- (BOOL)isNeedToCopyPreviousDownloadTemplate{
    
    BOOL needCopy = [[self xy_loadPreference:PREF_KEY_COPY_PRE_DOWNLOAD_TEMPLATE_FINISH defaultValue:PREF_VALUE_YES]
                     isEqualToString:PREF_VALUE_YES];
    return needCopy;
}

- (void)upgradeTemplate
{
    int currentTemplateVesion = CURRENT_PREINSTALLED_TEMPLATE_VERSION;
    
    [self xy_savePreference:[NSNumber numberWithInt:currentTemplateVesion]  key:PREF_KEY_PREINSTLLED_TEMPLATE_VERSION];
}

#pragma mark -- scan disk
- (void)scanDisk:(XYTEMPLATE_COMPLETE_BLOCK)block {
    //1.check if template/temp folde is existed
    NSString *DOCUpATH = APP_DOCUMENT_DIRECTORY;
    NSString *filepATH = APP_TEMP_PATH;
    if(![NSFileManager xy_isFileExist:APP_TEMP_PATH]){
        [NSFileManager xy_createFolder:APP_TEMP_PATH];
    }
    if(![NSFileManager xy_isFileExist:APP_TEMPLATES_PATH]){
        [NSFileManager xy_createFolder:APP_TEMPLATES_PATH];
    }
    
    if(![NSFileManager xy_isFileExist:APP_TEMPLATES_LOGO_PATH]){
        [NSFileManager xy_createFolder:APP_TEMPLATES_LOGO_PATH];
    }
    
    
#warning -- todo  tmeplate push 素材应该不会用了
//    [NSFileManager xy_checkFoldExistAndCreateFolder:APP_TEMPLATES_PUSH_DOWNLOAD_PATH];
    
    [NSFileManager xy_checkFoldExistAndCreateFolder:APP_TEMPLATES_DOWNLOAD_PATH];
    
    //2.check if we should install template
    BOOL isNeedToUpdateTemplateVersion = [self isNeedToUpdateTemplateVersion];
    BOOL isPreInstallTemplateFinished = [self isPreInstallTemplateFinished];
    //        BOOL isNeedCopyPreDownloadTemplate = [self isNeedToCopyPreviousDownloadTemplate];
    
    [[NSFileManager defaultManager] setDelegate:self];
    
    if (isPreInstallTemplateFinished == NO || isNeedToUpdateTemplateVersion) {
        //3.set pop up dialog
        currentProgress = 0;
        [self updateTemplatePopView:currentProgress];
        _isInstalling = YES;
        [self upgradeTemplate];
        
        //update download copy
        [self deletePreDownloadTemplate];
        currentProgress = TEMPLATE_PROGRESS_DOWNLOAD_COPY;
        [self updateTemplatePopView:currentProgress];
        
        //update private copy
        [self deletePreInstallTemplate];
        
        [self xy_savePreference:PREF_VALUE_YES key:PREF_KEY_PREINSTLLED_TEMPLATE_FINISH];
        [self xy_savePreference:PREF_VALUE_NO key:PREF_KEY_COPY_PRE_DOWNLOAD_TEMPLATE_FINISH];
        
        NSLog(@"copy private folder end.....");
    }
    
    //5.scan template and install template
    currentProgress = TEMPLATE_PROGRESS_COPY;
    [self updateTemplatePopView:currentProgress];
    NSLog(@"scanTemplates start.....");
    [self scanTemplates:isNeedToUpdateTemplateVersion];
    
    NSLog(@"scanTemplates end.....");
    //6.scan closed, dismiss popup dialog
    _isInstalling = NO;
    
    NSLog(@"dismissTemplatePopView >>> ");
    
    //delete garden filters
    [self deleteGardenFilters];
    
    block(YES);
}

- (void)deleteGardenFilters
{
#warning -- todo 可能是业务逻辑 建议删除
//    NSString *value = [self xy_loadPreference:@"is_delete_Garden_Filters" defaultValue:@"no"];
//
//    if([value isEqualToString:@"no"])
//    {
//        NSString *rollCode = @"18041916205151";
//
//        __block NSMutableArray *installTemplateIdList = [[NSMutableArray alloc] init];
//
//        NSString *whereCause = [NSString stringWithFormat:@"%@ = '%@'", TEMPLATE_ROLL_MAP_ROLL_CODE, rollCode];
//
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", TBL_NAME_TEMPLATE_ROLL_MAP, whereCause];
//
//        [[[XYDBUtility shareInstance] databaseManager:@"XYGlobalDBManager"] queryData:sql getResult:^(FMResultSet *resultSet) {
//            if(!resultSet)
//            {
//                return;
//            }
//
//            while([resultSet next])
//            {
//
//                unsigned long long templateId = [resultSet unsignedLongLongIntForColumn:TEMPLATE_ROLL_MAP_TEMPLATE_ID];
//
//                [installTemplateIdList addObject:@(templateId)];
//            }
//        }];
//
//        for(NSNumber *number in installTemplateIdList)
//        {
//            UInt64 templateId = [number unsignedLongLongValue];
//
//            NSString *strPath = [[XYTemplateDataMgr sharedInstance] getPathByID:templateId];
//
//            [[XYTemplateDataMgr sharedInstance] uninstall:strPath];
//        }
//
//        [[[XYDBUtility shareInstance] databaseManager:@"XYGlobalDBManager"] deleteInQueue:TBL_NAME_TEMPLATE_ROLL_MAP where:whereCause];
//
//        [self xy_savePreference:@"yes" key:@"is_delete_Garden_Filters"];
//    }
}

#pragma mark -- public method for template data

- (NSArray<NSNumber *> *)getPasterComboByID:(UInt64)lID {
    CXiaoYingStyle *style = [self getCXiaoYingStyleByID:lID];
    if (style) {
        return [style GetSubPasterID];
    }else{
        return nil;
    }
}

- (CXiaoYingEffectSwichInfo *)getPasterSwitchInfoByID:(UInt64)lID {
    CXiaoYingStyle *style = [self getCXiaoYingStyleByID:lID];
    if (style) {
        CXiaoYingEffectSwichInfo *switchInfo = [[CXiaoYingEffectSwichInfo alloc] init];
        MRESULT res = [style GetEffectSwitchInfo:switchInfo];
        if (res == MERR_NONE) {
            return switchInfo;
        }
    }
    return nil;
}

- (NSArray<NSNumber *> *)getPasterGroupBySwitchInfo:(CXiaoYingEffectSwichInfo *)switchInfo
                                         groupIndex:(NSInteger)groupIndex
                                       subPasterIDs:(NSArray<NSNumber *> *)subPasterIDs {
    int groupCount = switchInfo.uiGroupCount;
    if (groupCount == 0) {
        return nil;
    }
    
    NSInteger allSubPasterCount = [subPasterIDs count];
    NSInteger theGroupIndex = groupIndex;

    if (theGroupIndex >= groupCount) {
        theGroupIndex = 0;
    }
    CXIAOYING_EFFECT_SWITCH_GROUP_INFO groupInfo = switchInfo.pGourpList[theGroupIndex];
    NSMutableArray *array = [NSMutableArray array];
    for (int itemIndex=0; itemIndex<groupInfo.uiItemCount; itemIndex++) {
        int finalIndex = groupInfo.pItemList[itemIndex];
        if (finalIndex < allSubPasterCount) {
            NSNumber *templateId = subPasterIDs[finalIndex];
            [array addObject:templateId];
        }
    }
    
    if ([array count] > 0) {
        return array;
    } else {
        return nil;
    }
}

- (XYTemplateItemData*)getByID:(UInt64)lID {
    __block XYTemplateItemData *param;
    dispatch_sync(_queue, ^{
        for(XYTemplateItemData* item in mTemplateArray) {
            if(item.lID == lID){
                param = item;
                break;
            }
        }
    });
    return param;
}

- (XYTemplateItemData*)getByURL:(NSString*)strURL {
    if(strURL == nil)
        return nil;
    
    __block XYTemplateItemData *param;
    dispatch_sync(_queue, ^{
        for(XYTemplateItemData* item in mTemplateArray) {
            if([strURL isEqualToString:item.strPath]){
                param = item;
                break;
            }
        }
    });
    return param;
}

- (NSString*)getPathByID:(UInt64)lID {
    __block NSString *param;
    dispatch_sync(_queue, ^{
        for(XYTemplateItemData* item in mTemplateArray) {
            if(item.lID == lID){
                param = item.strPath;
                break;
            }
            
        }
    });
    return param;
}

- (UInt64)getIDByPath:(NSString *)path {
    __block UInt64 param = -1;
    dispatch_sync(_queue, ^{
        for(XYTemplateItemData* item in mTemplateArray) {
            if([item.strPath isEqualToString:path]){
                param = item.lID;
                break;
            }
            
        }
    });
    if(param == 0xffffffffffffffff){
        //以下代码用于修复由于160722之前推送的幻影主题中xyt模版错误，导致生活小记主题卡死的问题
        if ([path hasSuffix:@"0x4A00000000000083.xyt"]) {
            return 0x4A00000000000083;
        }else{
            NSLog(@"getIDByPath failed path:%@",path);
        }
    }
    return param;
}

- (NSString *)getTemplateExternalFile:(MInt64)templateID SubTemID:(MDWord)subTemplateID FileID:(MDWord)fileID
{
    __block XYTemplateItemData *item;
    dispatch_sync(_queue, ^{
        for(XYTemplateItemData* info in mTemplateArray) {
            if(info.lID == templateID){
                item = info;
                break;
            }
        }
    });
    
    if(!item){
        return nil;
    }
    
    if([NSString xy_isEmpty:item.strExtInfo]){
        return nil;
    }
    
    NSString *filename=@"";
    NSString *filePath=@"";
    NSData *JSONData = [item.strExtInfo dataUsingEncoding: NSUTF8StringEncoding];
    if(JSONData){
        NSArray *array = [NSJSONSerialization JSONObjectWithData:JSONData options: 0 error:nil];
        for(NSDictionary *dict in array)
        {
            int nSubID = [[dict objectForKey:@"dwSubTemplateID"] intValue];
            int nFileID = [[dict objectForKey:@"dwFileID"] intValue];
            if(subTemplateID == nSubID && nFileID == fileID)
            {
                filename = [dict objectForKey:@"szFileName"];
                filePath = [NSString stringWithFormat:@"%@/%@",[item.strPath stringByDeletingLastPathComponent],filename];
                break;
            }
        }
    }
    
    if([filePath hasSuffix:APP_TEMPLATE_EXT] ){
        if(![NSFileManager xy_isFileExist:filePath]){//Patch for missing xyt files
            NSString *fileInRootFolder = [NSString stringWithFormat:@"%@/%@",[item.strPath stringByDeletingLastPathComponent],[filename lastPathComponent]];
            [NSFileManager xy_moveFile:fileInRootFolder toFilePath:filePath];
        }
        
        if(![self getByURL:filePath]){//Patch for missing db data for the internal folder xyt files
            int fromType = [self isAssetsTemplate:filePath]?FROM_TYPE_LOCAL:FROM_TYPE_DOWNLOAD;
            [self installTemplate:filePath fromType:fromType force:NO appFlag:0];
        }
    }
    return filePath;
}

#pragma mark -- private method for template data
- (XYTemplateItemData*)getByIDInternal:(UInt64)lID {
    for(XYTemplateItemData* item in mTemplateArray) {
        if(item.lID == lID)
            return item;
    }
    
    return nil;
}

- (XYTemplateItemData*)getByURLInternal:(NSString*)strURL {
    if(strURL == nil)
        return nil;
    
    for(XYTemplateItemData* item in mTemplateArray) {
        if([strURL isEqualToString:item.strPath])
            return item;
    }
    
    return nil;
}

//- (NSString*)getPathByIDInternal:(UInt64)lID {
//    for(XYTemplateItemData* item in mTemplateArray) {
//        if(item.lID == lID)
//            return item.strPath;
//    }
//    
//    return nil;
//}
//
//- (UInt64)getIDByPathInternal:(NSString *)path {
//    for(XYTemplateItemData* item in mTemplateArray) {
//        if([item.strPath isEqualToString:path])
//            return item.lID;
//    }
//    
//    return -1;
//}

- (NSString *)getTemplateExternalFileInternal:(MInt64)templateID SubTemID:(MDWord)subTemplateID FileID:(MDWord)fileID {
    XYTemplateItemData *item = [self getByIDInternal:templateID];
    return [self getTemplateExternalFileInternalWithItem:item SubTemID:subTemplateID FileID:fileID];
}

- (NSString *)getTemplateExternalFileInternalWithItem:(XYTemplateItemData *)item SubTemID:(MDWord)subTemplateID FileID:(MDWord)fileID
{
    if(!item){
        return nil;
    }
    if([NSString xy_isEmpty:item.strExtInfo]){
        return nil;
    }
    
    NSString *filename;
    NSData *JSONData = [item.strExtInfo dataUsingEncoding: NSUTF8StringEncoding];
    if(JSONData){
        NSArray *array = [NSJSONSerialization JSONObjectWithData:JSONData options: 0 error:nil];
        for(NSDictionary *dict in array)
        {
            int nSubID = [[dict objectForKey:@"dwSubTemplateID"] intValue];
            int nFileID = [[dict objectForKey:@"dwFileID"] intValue];
            if(subTemplateID == nSubID && nFileID == fileID)
            {
                filename = [dict objectForKey:@"szFileName"];
                filename = [NSString stringWithFormat:@"%@/%@",[item.strPath stringByDeletingLastPathComponent],filename];
                break;
            }
        }
    }
    return filename;
}


#pragma mark -- public utility method
- (NSInteger)getTemplateIndex:(NSArray<XYTemplateItemData *> *)templateArray searchBy:(BOOL (^)(XYTemplateItemData *))block{
    __block NSInteger index = -1;
    [templateArray enumerateObjectsUsingBlock:^(XYTemplateItemData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block(obj)) {
            index = (NSInteger)idx;
            *stop = YES;
        }
    }];
    return index;
}

- (NSInteger)getIndexByPath:(NSArray<XYTemplateItemData *> *)templateArray templatePath:(NSString *)templatePath{
    return [self getTemplateIndex:templateArray searchBy:^BOOL(XYTemplateItemData *item) {
        return [item.strPath isEqualToString:templatePath];
    }];
}

- (NSInteger)getIndexByID:(NSArray *)templateArray lID:(UInt64)lID{
    return [self getTemplateIndex:templateArray searchBy:^BOOL(XYTemplateItemData *item) {
        return item.lID == lID;
    }];
}

- (UInt64)getIDByIndex:(NSArray *)templateArray index:(int)index{
    int count = (int)[templateArray count];
    if(index < count && index>=0){
        XYTemplateItemData* item = [templateArray objectAtIndex:index];
        return item.lID;
    }
    return 0;
}

- (XYTemplateItemData *)getByIndex:(NSArray *)templateArray index:(int)index{
    int count = (int)[templateArray count];
    if(index < count && index>=0){
        XYTemplateItemData* item = [templateArray objectAtIndex:index];
        return item;
    }
    return nil;
}

- (XYTemplateItemData *)getByPath:(NSArray *)templateArray path:(NSString *)path{
    __block XYTemplateItemData* item = nil;
    [templateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([((XYTemplateItemData*)obj).strPath isEqualToString:path]) {
            item = obj;
            *stop = YES;
        }
    }];
    return item;
}

- (NSString *)getPathByIndex:(NSArray *)templateArray index:(int)index{
    int count = (int)[templateArray count];
    if(index < count && index>=0){
        XYTemplateItemData* item = [templateArray objectAtIndex:index];
        return item.strPath;
    }
    return nil;
}

- (NSString *)getLogoByIndex:(NSArray *)templateArray index:(int)index{
    int count = (int)[templateArray count];
    if(index < count  && index>=0){
        XYTemplateItemData* item = [templateArray objectAtIndex:index];
        return item.strLogo;
    }
    return nil;
}

- (NSString *)getTitleByIndex:(NSArray *)templateArray index:(int)index{
    int count = (int)[templateArray count];
    if(index < count  && index>=0){
        XYTemplateItemData* item = [templateArray objectAtIndex:index];
        return [self getTitle:item];
    }
    return nil;
}

- (NSString *)getTitle:(XYTemplateItemData *)XYTemplateItemData{
    if ([self.dataSource respondsToSelector:@selector(currentUserLanguage)]) {
        return [self getTitle:XYTemplateItemData language:[self.dataSource currentUserLanguage]];
    } else {
        //获取系统当前语言版本
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *current = [languages objectAtIndex:0];
        return [self getTitle:XYTemplateItemData language:[self languageFormat:current]];
    }
}

///语言和语言对应的.lproj的文件夹前缀不一致时在这里做处理
- (NSString *)languageFormat:(NSString*)language{
    
    if([language isEqualToString:@"zh-CN"]){
        return @"zh-Hans";
    }

    if([language isEqualToString:@"zh-TW"]){
        return @"zh-Hant";
    }
    
    if([language rangeOfString:@"zh-Hans"].location != NSNotFound){
        return @"zh-Hans";
    } else if ([language rangeOfString:@"zh-Hant"].location != NSNotFound) {
        return @"zh-Hant";
    } else {
        //字符串查找
        if([language rangeOfString:@"-"].location != NSNotFound) {
            //除了中文以外的其他语言统一处理@"ru_RU" @"ko_KR"取前面一部分
            NSArray *ary = [language componentsSeparatedByString:@"-"];
            if (ary.count > 1) {
                NSString *str = ary[0];
                return str;
            }
        }
    }
    return language;
}

- (NSString *)getTitle:(XYTemplateItemData *)XYTemplateItemData language:(NSString *)language{
    
    if(XYTemplateItemData && XYTemplateItemData.strTitle){
        NSData *JSONData = [XYTemplateItemData.strTitle dataUsingEncoding: NSUTF8StringEncoding];
        if(JSONData){
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:JSONData options: 0 error:nil];
            NSString *title = [dict objectForKey:[[NSNumber numberWithInteger:[NSNumber xy_getLanguageID:language]] stringValue]];
            if ([NSString xy_isEmpty:title]) {//如果没有取到对应语言的情况下用英语
                title = [dict objectForKey:[[NSNumber numberWithInteger:LANG_ID_ZH_CHS] stringValue]];
            }
            return title;
        }else{
            return nil;
        }
    }
    return nil;
}

- (NSString *)getExtInfoFileNameByIndex:(NSArray *)templateArray index:(int)index{
    int count = (int)[templateArray count];
    if(index < count  && index>=0){
        XYTemplateItemData* item = [templateArray objectAtIndex:index];
        return [self getExternalFileName:item];
    }
    return nil;
}

- (NSString *)getExternalFileName:(XYTemplateItemData *)item
{
    if(item && item.strExtInfo){
        NSData *JSONData = [item.strExtInfo dataUsingEncoding: NSUTF8StringEncoding];
        if(JSONData){
            NSArray *array = [NSJSONSerialization JSONObjectWithData:JSONData options: 0 error:nil];
            if([array count] == 0){
                return nil;
            }
            NSDictionary *dict = [array objectAtIndex:0];
            NSString *filename = [dict objectForKey:@"szFileName"];
            filename = [NSString stringWithFormat:@"%@/%@",[item.strPath stringByDeletingLastPathComponent],filename];
            return filename;
        }
    }
    return nil;
}

- (UInt64)getThemeCoverPositionByThemeId:(UInt64)themeId {
    if (themeId==0) {
        return 0;
    }
    
    CXiaoYingStyle *style = [self getCXiaoYingStyleByID:themeId];
    UInt32 coverPosition = 0;
    [style GetThemeCoverPosition:&coverPosition];
    return coverPosition;
}

#pragma mark -- private method for getting data from CXiaoYingStyle
- (NSString *)getTemplateNameFromStyle:(CXiaoYingStyle *)style dwLanguageID:(MDWord)dwLanguageID
{
    MChar *cTemplateName = (MChar *)malloc(MAX_PATH);
    [style GetTemplateName:dwLanguageID Title:cTemplateName];
    NSString *name = [NSString stringWithUTF8String:cTemplateName];
    free(cTemplateName);
    return name;
}

- (UIImage *)createTemplateThumbnailFromStyle:(CXiaoYingStyle *)style
                                   thumbWidth:(MDWord)thumbWidth
                                  thumbHeight:(MDWord)thumbHeight
{
    return [style GetThumbnailUIImage];
}

-(NSString*)getTitleInfos:(CXiaoYingStyle*)style {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    //zh-CN
    NSString* title = [self getTemplateNameFromStyle:style dwLanguageID:LANG_ID_ZH_CHS];
    if(title != nil) {
        [dict setValue:title forKey:[[NSNumber numberWithInt:LANG_ID_ZH_CHS] stringValue]];
    }

    //english
    title = [self getTemplateNameFromStyle:style dwLanguageID:APP_LOCALIZATION_ID_DECIMAL];
    if(title != nil) {
        [dict setValue:title forKey:[[NSNumber numberWithInt:APP_LOCALIZATION_ID_DECIMAL] stringValue]];
    }

    //ar
    title = [self getTemplateNameFromStyle:style dwLanguageID:LANG_ID_AR_SA];
    if(title != nil) {
        [dict setValue:title forKey:[[NSNumber numberWithInt:LANG_ID_AR_SA] stringValue]];
    }

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];

    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

-(NSString*)getExtFileInfos:(CXiaoYingStyle*)style {
    //get external file info
    MDWord dwExtInfoCount = 0;
    NSMutableArray* extInfoArray = [[NSMutableArray alloc] init];
    MRESULT res = [style GetExternalFileCount:&dwExtInfoCount];
    if(res == 0 && dwExtInfoCount > 0) {
        QVET_EXTERNAL_ITEM_INFO* info = (QVET_EXTERNAL_ITEM_INFO*)malloc(sizeof(QVET_EXTERNAL_ITEM_INFO) * dwExtInfoCount);
        res = [style GetExternalFileInfos:info InfoCount:dwExtInfoCount];
        if(res == 0) {
            for(MDWord i = 0; i < dwExtInfoCount; i++) {
                NSMutableDictionary* extItem = [[NSMutableDictionary alloc] init];
                [extItem setValue:[NSNumber numberWithUnsignedLong:info[i].dwFileID] forKey:@"dwFileID"];
                [extItem setValue:[NSNumber numberWithUnsignedLong:info[i].dwSubTemplateID] forKey:@"dwSubTemplateID"];
                [extItem setValue:[NSString stringWithUTF8String:info[i].szFileName] forKey:@"szFileName"];
                [extInfoArray addObject:extItem];
            }
        }
        free(info);
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extInfoArray
                                                       options:0
                                                         error:&error];
    
    if (error == nil && jsonData != nil && [jsonData length] > 0){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

- (BOOL) isAssetsTemplate:(NSString*) strXYT{
    if([strXYT rangeOfString:APP_BUNDLE_PRIVATE_PATH].location !=NSNotFound){
        return YES;
    }
    else{
        return NO;
    }
}

-(BOOL)isVisibleTemplate:(MInt64)llTemplateID {
    
    if ([CXiaoYingStyle GetTemplateType:llTemplateID] == AMVE_STYLE_MODE_COVER) {
        return false;
    }
    return [CXiaoYingStyle IsPublicTemplate: llTemplateID];
}

-(BOOL)isLiveShowTemplate:(MInt64)llTemplateID{
    long long productId = 0;
    productId = llTemplateID & XYTEMPLATE_PRODUCT_ID_MASK;
//    NSLog(@"templateid:0x%llx , product id：0x%llx",llTemplateID,productId);
    if(productId > 0){
        productId = productId >> 44;
        if (productId == XYTEMPLATE_PRODUCT_ID_LIVESHOW) {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}

#pragma mark -- public method install and uninstall
- (NSArray<NSNumber *> *)install:(NSString *)strTemplateFile
{
    return [self install:strTemplateFile isDeleteOriginFile:YES];
}

- (NSArray<NSNumber *> *)install:(NSString*)strTemplateFile isDeleteOriginFile:(BOOL)isDeleteOriginFile
{
    return [self install:strTemplateFile fromType:FROM_TYPE_DOWNLOAD force:YES isDeleteOriginFile:isDeleteOriginFile];
}

- (void)uninstall:(NSString*)strTemplatePath{
    dispatch_sync(_queue, ^{
        
        if([NSString xy_isEmpty:strTemplatePath])
            return ;
        
        //step1: delete item from TBL_NAME_TEMPLATE table
        //    NSString* strTemplateRelativePath;
        //    NSRange textRange =[strTemplatePath rangeOfString:@"/Documents"];
        //
        //    if(textRange.location != NSNotFound){
        //        strTemplateRelativePath = [strTemplatePath toDocumentRelativePath];
        //    }else{
        //        strTemplateRelativePath = [strTemplatePath toTemplateRelativePath];
        //    }
        //    NSString *strWhere = [NSString stringWithFormat:@"%@ = '%@'",TEMPLATE_URL, strTemplateRelativePath];
        //    [[[XYDBUtility shareInstance] databaseManager:@"XYGlobalDBManager"] deleteInQueue:TBL_NAME_TEMPLATE where:strWhere];
        
        
        if(mTemplateArray == nil || mTemplateArray.count == 0)
            return;
        
        //step 2: remove from TemplateMgr and DB
        XYTemplateItemData *tobeDeletedInfo;
        for(XYTemplateItemData* info in mTemplateArray) {
            if(info == nil)
                continue;
            
            if ([strTemplatePath isEqualToString:info.strPath]) {
                tobeDeletedInfo = info;
                break;
            }
        }
        
        if (tobeDeletedInfo) {
            BOOL bVirtualDel = [self isPreInstallTemplate:tobeDeletedInfo.strPath];
            if (bVirtualDel) {
                [self removeTemplateLogo:tobeDeletedInfo.strPath lID:tobeDeletedInfo.lID];
                [self removeTemplate:tobeDeletedInfo.lID delFlag:TEMPLATE_DELETE_FLAG_VIRTUAL];
                [self removeAllPrivateOfTheme:tobeDeletedInfo.lID force:NO];
            }else{
                [self deleteTemplateExtFile:tobeDeletedInfo.lID extInfo:tobeDeletedInfo.strExtInfo];
                [NSFileManager xy_deleteFile:strTemplatePath];
                [self removeTemplateLogo:tobeDeletedInfo.strPath lID:tobeDeletedInfo.lID];
                [self removeTemplate:tobeDeletedInfo.lID delFlag:TEMPLATE_DELETE_FLAG_NORMAL];
                [self removeAllPrivateOfTheme:tobeDeletedInfo.lID force:YES];
            }
        }
    });
}



#pragma mark -- private method for install and uninstall template
- (NSArray<NSNumber *> *)install:(NSString*)strTemplateFile fromType:(int)nFromType force:(BOOL)bForce isDeleteOriginFile:(BOOL)isDeleteOriginFile {
    NSMutableArray* installedList = [[NSMutableArray alloc] init];
    if(strTemplateFile == nil || ![NSFileManager xy_isFileExist:strTemplateFile])
        return installedList;
    
    BOOL isFBSticker = NO;
    NSRange range = [strTemplateFile rangeOfString:@"/0x11"];
    if (range.location != NSNotFound) {
        isFBSticker = YES;
    }
    
    NSMutableArray* pendingInstall = [[NSMutableArray alloc] init];
    NSMutableArray* fontPathArray = [NSMutableArray array];
    if([[[NSString xy_getFileExtension:strTemplateFile] lowercaseString] isEqualToString:DEFAULT_ZIP_FILE_EXT]) {
        NSArray* unZipFiles = nil;
        if (nFromType == FROM_TYPE_DOWNLOAD) {
            unZipFiles = [self unzipDownloadPackage: strTemplateFile];
        }else {
            unZipFiles = [self unzipPackage: strTemplateFile];
        }
        
        if(unZipFiles != nil) {
            for(NSString* strFile in unZipFiles) {
                NSString *fileExt = [[NSString xy_getFileExtension:strFile] lowercaseString];
                if([fileExt isEqualToString:DEFAULT_TEMPLATE_FILE_EXT]) {
                    [pendingInstall addObject:strFile];
                }else if ([fileExt isEqualToString:DEFAULT_TTF_FILE_EXT] || [fileExt isEqualToString:DEFAULT_OTF_FILE_EXT]){//collect unziped font file path
                    [fontPathArray addObject:strFile];
                }
            }
        }
        
    } else {
        NSString *fileExt = [[NSString xy_getFileExtension:strTemplateFile] lowercaseString];
        if ([fileExt isEqualToString:DEFAULT_TTF_FILE_EXT] || [fileExt isEqualToString:DEFAULT_OTF_FILE_EXT]){//collect unziped font file path
            [fontPathArray addObject:strTemplateFile];
        }else{
            if (nFromType == FROM_TYPE_DOWNLOAD) {
                //copy file to template file path
                NSString* newTemplateFile = [NSString stringWithFormat:@"%@/%@",APP_TEMPLATES_PATH,[NSString xy_getFileName:strTemplateFile]];
                if ([newTemplateFile isEqualToString:strTemplateFile] == NO && ![strTemplateFile hasPrefix:APP_TEMPLATES_PATH]) {//Fixed Missing xyt files issue
                    [NSFileManager xy_copyFile:strTemplateFile toFilePath:newTemplateFile];
                    if(isDeleteOriginFile)
                    {
                        [NSFileManager xy_deleteFile:strTemplateFile];
                    }
                }
                [pendingInstall addObject:newTemplateFile];
            }else{
                [pendingInstall addObject:strTemplateFile];
            }
        }
    }
    
    dispatch_sync(_queue, ^{
        int appFlag = 0;
        if (isFBSticker) {
            appFlag = 1;
        }
        for(NSString* strXYT in pendingInstall) {
            UInt64 templateId = [self installTemplate: strXYT fromType:nFromType force:bForce appFlag:appFlag];
            if (templateId > 0) {
                [installedList addObject:[NSNumber numberWithUnsignedLongLong:templateId]];
            }
        }
    });
    
    //copy & register font
    for (NSString* fontPath in fontPathArray) {
        if (![NSFileManager xy_isFileExist:APP_FONTS_PATH]) {
            [NSFileManager xy_createFolder:APP_FONTS_PATH];
        }
        NSString * newFontPath = [NSString stringWithFormat:@"%@/%@",APP_FONTS_PATH,[NSString xy_getFileName:fontPath]];
        [NSFileManager xy_copyFile:fontPath toFilePath:newFontPath];
        [self registerFontWithPath:newFontPath];
    }
    return installedList;
}

- (void)registerFontWithPath:(NSString *)fontFilePath{
    NSString *fontName = [NSString xy_registerFont:fontFilePath];
    NSString *fontID = [[fontFilePath lastPathComponent] stringByDeletingPathExtension];
    if (fontName != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:fontName forKey:[fontID lowercaseString]];
    }
}

-(UInt64)installTemplate:(NSString*)strXYT fromType:(int)nFromType force:(BOOL)bForce appFlag:(int)appFlag {
    if(![NSFileManager xy_isFileExist:strXYT]){
        return 0;
    }
    BOOL isHans = ([NSNumber xy_getLanguageID:[XYDeviceUtility fullLanguage]] == LANG_ID_ZH_CHS);
    //1. get template info
    CXiaoYingStyle* style = [[CXiaoYingStyle alloc] init];
    MRESULT res = [style Create:[strXYT UTF8String] BGLayoutMode:QVTP_LAYOUT_MODE_PORTRAIT SerialNo:MNull];
    if(res != 0)
        return 0;
    XYTemplateItemData* item = [[XYTemplateItemData alloc] init];
    item.lID = [style GetID];
    
    item.nAppFlag = appFlag;
    item.strPath = strXYT;
    MDWord configureCount = 0;
    res = [style GetConfigureCount:&configureCount];
    item.nConfigureCount = configureCount;
    MBool downloadFlag = [style GetDummryFlag];
    item.nDownloadFlag = downloadFlag;
    item.strTitle = [self getTitleInfos: style];
    item.strExtInfo = [self getExtFileInfos: style];
    item.nVersion = [style GetVersion];
    MDWord nCatagoryID = 0;
    res = [style GetCategroyID:&nCatagoryID];
    item.strSceneCode = [NSString stringWithFormat:@"%u",nCatagoryID];
    
    MDWord dwLayout= 0;
    [style GetSupportedLayouts:&dwLayout];
    item.lLayoutFlag = dwLayout;
    item.strLocalizedTitle = [self getTitle:item];
    item.nTemplateType = [CXiaoYingStyle GetTemplateType:item.lID];
    
//    if (item.nTemplateType == AMVE_STYLE_MODE_EFFECT && [CXiaoYingStyle IsThemeSubTemplate:item.lID] == MFalse) {
//        NSLog(@"0x%llx",item.lID);
//    }
    
    if((item.nTemplateType == AMVE_STYLE_MODE_SOUND_EFFECT || item.nTemplateType == AMVE_STYLE_MODE_MUSIC) && isHans){
        item.strPinYin = [self hanziToPinYin:item.strLocalizedTitle];
    }else{
        item.strPinYin = item.strLocalizedTitle;
    }
    
    //2. check if the installing template is already installed.
    XYTemplateItemData* prevInfo = [self getByIDInternal:item.lID];
    if(bForce) {
        //if the existed template is a virtual template and is already deleted.
        //we need to set nDelFlag = TEMPLATE_DELETE_FLAG_NORMAL for the next step.
        //and we also need to delete the related item in the db.
        if(prevInfo != nil && prevInfo.nDelFlag == TEMPLATE_DELETE_FLAG_VIRTUAL) {
            prevInfo.nDelFlag = TEMPLATE_DELETE_FLAG_NORMAL;
            NSString* strWhere = [NSString stringWithFormat:@"%@ = %lld AND %@ = %d", TEMPLATE_ID, item.lID,TEMPLATE_DEL_FLAG,TEMPLATE_DELETE_FLAG_VIRTUAL];
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setValue:[NSNumber numberWithInt:TEMPLATE_DELETE_FLAG_NORMAL] forKey:TEMPLATE_DEL_FLAG];
            [[[XYDBUtility shareInstance] databaseManager:@"XYTemplateDBMgr"] updateInQueue:TBL_NAME_TEMPLATE withParameterDictionary:dict where:strWhere];
        }
    }
    
    //there is a template already existed, so we need to check if we can overide it.
    if(prevInfo != nil) {
        //if it is not forced to install, we can not override virtual deleted template
        if(prevInfo.nDelFlag == TEMPLATE_DELETE_FLAG_VIRTUAL) {
            //can not override virtual deleted template
            [style Destory];
            return 0;
        }
        
        //assets template can not override download template
        if([self isAssetsTemplate:strXYT]&& ![self isAssetsTemplate:prevInfo.strPath]) {
            [style Destory];
            return 0;
        }
        
        //dummy template can not override normal template
        if((item.nDownloadFlag == 1) && (prevInfo.nDownloadFlag == 0)) {
            [style Destory];
            return 0;
        }
        //FIXME 本地空模板版本号小于 网上下载下来的版本号。 需要修复此处逻辑。
        /*if( nVersion < prevInfo.nVersion) {
         //low version can not override high version
         return -1;
         }*/
    }
    
    if (nFromType != FROM_TYPE_LOCAL ) {
            //3. get thumb and other and destroy style
            UIImage* image = [self createTemplateThumbnailFromStyle:style thumbWidth:TEMPLATE_THUMBNAIL_WIDTH thumbHeight:TEMPLATE_THUMBNAIL_HEIGHT];
            
            if(image != nil) {
                //ccf-TODO save to local cache file
                NSString *folder = [strXYT stringByDeletingLastPathComponent];
                NSString* strTemplateLogo = [NSString stringWithFormat:@"%@/%lld.png",folder,item.lID];
                if ([NSFileManager xy_isFileExist:strTemplateLogo]) {
                    [NSFileManager xy_deleteFile:strTemplateLogo];
                }
                [NSFileManager xy_saveUIImage:image toFilePath:strTemplateLogo];
                item.strLogo = strTemplateLogo;
            }
    }
    
    
    [style Destory];
    style = nil;
    
    //4. set order
    item.lUpdateTime = CFAbsoluteTimeGetCurrent();
    item.nFromType = nFromType;
    if(nFromType == FROM_TYPE_DOWNLOAD) {
        item.nOrder    = DEFAULT_DOWNLOAD_ORDERNO;
        item.nSubOrder = DEFAULT_DOWNLOAD_ORDERNO;
        item.nOriOrder = item.nOrder;
    }
    
    if(prevInfo != nil) {
        item.nOrder    = prevInfo.nOrder;
        item.nSubOrder = prevInfo.nSubOrder;
        item.nOriOrder = prevInfo.nOriOrder;
        item.nFavorite = prevInfo.nFavorite;
        
        if((prevInfo.nFromType == FROM_TYPE_LOCAL || prevInfo.nFromType == FROM_TYPE_VIRTUAL_OVERRIDE)
           && nFromType == FROM_TYPE_DOWNLOAD) {
            item.nFromType = FROM_TYPE_VIRTUAL_OVERRIDE;
        }
        
        if ([prevInfo.strPath isEqualToString:item.strPath] == NO
            && [prevInfo.strPath xy_isPrivatePathTemplate] == NO) {
            [NSFileManager xy_deleteFile:prevInfo.strPath];
        }
    }
    
    //Use Webp thumbnail if available
    NSString *webpFilePath = [self getTemplateExternalFileInternalWithItem:item SubTemID:0 FileID:QVET_TEMPLATE_THUMBNAIL_FILE_ID];
    if (![NSString xy_isEmpty:webpFilePath]) {
        item.strLogo = webpFilePath;
    }
    
    //update tempalte array
    if (prevInfo != nil) {
        prevInfo.lID = item.lID;
        prevInfo.strPath = item.strPath;
        prevInfo.strTitle = item.strTitle;
        prevInfo.strLogo = item.strLogo;
        prevInfo.nVersion = item.nVersion;
        prevInfo.nOrder = item.nOrder;
        prevInfo.nSubOrder = item.nSubOrder;
        prevInfo.nFromType = item.nFromType;
        prevInfo.lUpdateTime = item.lUpdateTime;
        prevInfo.nFavorite = item.nFavorite;
        prevInfo.strExtInfo = item.strExtInfo;
        prevInfo.lLayoutFlag = item.lLayoutFlag;
        prevInfo.nDownloadFlag = item.nDownloadFlag;
        prevInfo.nConfigureCount = item.nConfigureCount;
        prevInfo.nOriOrder = item.nOriOrder;
        prevInfo.nDelFlag = item.nDelFlag;
        prevInfo.strSceneCode = item.strSceneCode;
        
    }else{
        [mTemplateArray insertObject:item atIndex:0];
    }
    
    //6. update to DB
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSNumber numberWithInt:item.nVersion] forKey:TEMPLATE_VERSION];
    [dict setValue:[NSNumber numberWithInt:item.nOrder] forKey:TEMPLATE_ORDERNO];
    [dict setValue:[NSNumber numberWithInt:item.nSubOrder] forKey:TEMPLATE_SUB_ORDERNO];
    [dict setValue:[NSNumber numberWithInt:item.nFromType] forKey:TEMPLATE_FROM_TYPE];
    [dict setValue:[NSNumber numberWithUnsignedLongLong:item.lUpdateTime] forKey:TEMPLATE_UPDATETIME];
    [dict setValue:[NSNumber numberWithInt:item.nFavorite] forKey:TEMPLATE_FAVORITE];
    [dict setValue:[NSNumber numberWithUnsignedLongLong:item.lLayoutFlag] forKey:TEMPLATE_LAYOUT_FLAG];

    BOOL isPrivatePathTemplate = [item.strPath xy_isPrivatePathTemplate];
    if (isPrivatePathTemplate) {
        [dict setValue:[item.strLogo xy_toDocumentRelativePath] forKey:TEMPLATE_LOGO];
        [dict setValue:[item.strPath xy_toBundleRelativePath] forKey:TEMPLATE_URL];
    }else {
        [dict setValue:[item.strLogo xy_toTemplateRelativePath] forKey:TEMPLATE_LOGO];
        [dict setValue:[item.strPath xy_toTemplateRelativePath] forKey:TEMPLATE_URL];
    }

    [dict setValue:item.strTitle forKey:TEMPLATE_TITLE];
    [dict setValue:item.strExtInfo forKey:TEMPLATE_EXT_INFO];
    [dict setValue:[NSNumber numberWithInt:item.nDownloadFlag] forKey:TEMPLATE_DOWNLOAD_FLAG];
    [dict setValue:[NSNumber numberWithInt:item.nConfigureCount] forKey:TEMPLATE_CONFIGURE_COUNT];
    [dict setValue:item.strSceneCode forKey:TEMPLATE_SCENECODE];
    [dict setValue:@(appFlag) forKey:TEMPLATE_APP_FLAG];
    
    
    __block BOOL bNewItem = TRUE;
    NSString* strWhere = [NSString stringWithFormat:@"%@ = %lld", TEMPLATE_ID, item.lID];
    NSString* strUpdateSQL = [NSString stringWithFormat:@"select * from %@ where %@", TBL_NAME_TEMPLATE, strWhere];
    [[[XYDBUtility shareInstance] databaseManager:@"XYTemplateDBMgr"] queryData: strUpdateSQL getResult:^(FMResultSet *result) {
        if(result != nil && [result next]) {
            bNewItem = FALSE;
        }
    }];
    
    if(bNewItem) {
        [dict setValue:[NSNumber numberWithUnsignedLongLong:item.lID] forKey:TEMPLATE_ID];
        [[[XYDBUtility shareInstance] databaseManager:@"XYTemplateDBMgr"] insertInQueue:TBL_NAME_TEMPLATE withParameterDictionary:dict];
    } else {
        [[[XYDBUtility shareInstance] databaseManager:@"XYTemplateDBMgr"] updateInQueue:TBL_NAME_TEMPLATE withParameterDictionary:dict where:strWhere];
    }
    
    return item.lID;
}

-(NSArray*)unzipPackage:(NSString*)strZipFile {
    NSArray *array =  [NSFileManager xy_unzip:[strZipFile stringByDeletingLastPathComponent] zippedPath:strZipFile];
    [NSFileManager xy_deleteFile:strZipFile];
    return  array;
}

-(NSArray*)unzipDownloadPackage:(NSString*)strZipFile {
    NSArray *array =  [NSFileManager xy_unzip:APP_TEMPLATES_PATH zippedPath:strZipFile];
    [NSFileManager xy_deleteFile:strZipFile];
    return  array;
    
}

-(BOOL)isPreInstallTemplate:(NSString*) strTemplatePath {
    if([NSString xy_isEmpty:strTemplatePath])
        return NO;
    XYTemplateItemData* item = [self getByURLInternal:strTemplatePath];
    if (item != nil) {
        return item.nFromType != FROM_TYPE_DOWNLOAD;
    }
    
    return [self isAssetsTemplate:strTemplatePath];
}


- (void) deleteTemplateExtFile:(UInt64) lID extInfo:(NSString*) extInfo{
    NSLog(@"deleteTemplateExtFile:%@",extInfo);
    if ([NSString xy_isEmpty:extInfo] || [extInfo isEqualToString:@"[]"]) {
        return;
    }
    
    //[{"dwFileID":8001,"dwSubTemplateID":0,"szFileName":"0x0281000000000009/cover.mp4"},{"dwFileID":8001,"dwSubTemplateID":0,"szFileName":"0x0281000000000009/cover.mp4"}]
    NSArray* dicArray = [extInfo xy_getObjectFromJSONString];
    if (dicArray == nil || dicArray.count == 0) {
        return;
    }
    
    NSMutableArray* listDelPath = [[NSMutableArray alloc] init];
    for (int i = 0; i<dicArray.count; i++) {
        NSString* strExtFile;
        NSString* strParent;
        NSDictionary* dict = dicArray[i];
        int nSubID = [[dict objectForKey:@"dwSubTemplateID"] intValue];
        int nFileID = [[dict objectForKey:@"dwFileID"] intValue];
        strExtFile = [self getTemplateExternalFileInternal:lID SubTemID:nSubID FileID:nFileID];
        if (strExtFile != nil && [NSFileManager xy_isFileExist:strExtFile]) {
            //there is no "/" at the end of this method, so we add it.
            strParent = [NSString stringWithFormat:@"%@/",[strExtFile stringByDeletingLastPathComponent]];
            [listDelPath addObject:strParent];
            [NSFileManager xy_deleteFile:strExtFile];
        }
        NSLog(@"file:%@,filePath:%@",strExtFile,strParent);
    }
    
    for (int j = 0; j< listDelPath.count; j++) {
        NSString* delPath = listDelPath[j];
        if ([delPath isEqualToString:APP_TEMPLATES_PATH]) {
            continue;
        }
        [NSFileManager xy_deleteFile:delPath];
    }
    
    NSLog(@"deleteTemplateExtFile out");
}

- (void) removeTemplate:(UInt64) lID delFlag:(int)nDelFlag{
    NSInteger index = [self getIndexByID:mTemplateArray lID:lID];
    [mTemplateArray removeObjectAtIndex:index];
    
    //delete from download table
    if(TEMPLATE_DELETE_FLAG_VIRTUAL == nDelFlag) {
        NSString* strWhere = [NSString stringWithFormat:@"%@ = %lld", TEMPLATE_ID, lID];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSNumber numberWithInt:TEMPLATE_DELETE_FLAG_VIRTUAL] forKey:TEMPLATE_DEL_FLAG];
        [[[XYDBUtility shareInstance] databaseManager:@"XYTemplateDBMgr"] updateInQueue:TBL_NAME_TEMPLATE withParameterDictionary:dict where:strWhere];
    }else{
        NSString *strWhere = [NSString stringWithFormat:@"%@ = %lld",TEMPLATE_ID, lID];
        [[[XYDBUtility shareInstance] databaseManager:@"XYTemplateDBMgr"] deleteInQueue:TBL_NAME_TEMPLATE where:strWhere];
    }
}

- (void) removeAllPrivateOfTheme:(UInt64) lID force:(BOOL)bForceDel{
    if (mTemplateArray == nil || mTemplateArray.count == 0) {
        return;
    }
    
    if ([CXiaoYingStyle GetTemplateType:lID] != AMVE_STYLE_MODE_THEME) {
        return;
    }
    
    long long lThemeSequenceID = [CXiaoYingStyle GetTemplateSequenceID:lID];
    NSMutableArray* list= [[NSMutableArray alloc] init];
    for(XYTemplateItemData* itemData in mTemplateArray){
        if (itemData == nil || itemData.lID == lID) {
            continue;
        }
        
        if ([CXiaoYingStyle IsThemeSubTemplate:itemData.lID]
            && lThemeSequenceID == [CXiaoYingStyle GetTemplateSequenceID:itemData.lID]){
            [list addObject:itemData];
        }
    }
    if (list.count == 0) {
        return;
    }
    
    for (XYTemplateItemData* item in list) {
        if (item != nil && [NSString xy_isEmpty:item.strPath] == NO) {
            if (!bForceDel) {
                [self removeTemplate:item.lID delFlag:TEMPLATE_DELETE_FLAG_VIRTUAL];
            }else{
                [self deleteTemplateExtFile:item.lID extInfo:item.strExtInfo];
                [NSFileManager xy_deleteFile:item.strPath];
                [self removeTemplateLogo:item.strPath lID:item.lID];
                [self removeTemplate:item.lID delFlag:TEMPLATE_DELETE_FLAG_NORMAL];
            }
        }else{
            [self removeTemplate:item.lID delFlag:TEMPLATE_DELETE_FLAG_NORMAL];
        }
        
    }
}

- (void) removeTemplateLogo:(NSString*) strTemplatePath lID:(UInt64) lID{
    NSString *folder = [strTemplatePath stringByDeletingLastPathComponent];
    NSString* strTemplateLogo = [NSString stringWithFormat:@"%@/%lld.png",folder,lID];
    if ([NSFileManager xy_isFileExist:strTemplateLogo]) {
        [NSFileManager xy_deleteFile:strTemplateLogo];
    }
}

//not used now
- (void) syncTemplateOrder{
    if (mTemplateArray == nil || mTemplateArray.count == 0) {
        return;
    }
    
    for (XYTemplateItemData *item in mTemplateArray) {
        if (item == nil || item.nOriOrder == item.nOrder) {
            continue;
        }
        item.nOriOrder = item.nOrder;
        
        //update to DB
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSNumber numberWithInt:item.nOrder] forKey:TEMPLATE_ORDERNO];
        NSString* strWhere = [NSString stringWithFormat:@"%@ = %lld", TEMPLATE_ID, item.lID];
        [[[XYDBUtility shareInstance] databaseManager:@"XYTemplateDBMgr"] updateInQueue: TBL_NAME_TEMPLATE withParameterDictionary:dict where:strWhere];
    }
}


//not used now
- (BOOL) setTemplateOrder:(UInt64)lID orderNo:(int)nOrderNo{
    if (mTemplateArray == nil || mTemplateArray.count == 0)
        return false;
    
    XYTemplateItemData *info = [self getByIDInternal:lID];
    if (info == nil || info.strPath == nil)
        return NO;
    NSLog(@"info.nOrder:%d,nOrderNo:%d",info.nOrder,nOrderNo);
    BOOL bChanged = (info.nOrder != nOrderNo);
    info.nOrder = nOrderNo;
    return bChanged;
}


-(NSMutableArray*)sortTemplate:(NSMutableArray*)pendingArray type:(int)nTemplateType mask:(int)mask{
    if(pendingArray == nil || [pendingArray count] <= 1)
        return pendingArray;
    
    NSMutableArray* sortedArray = [[NSMutableArray alloc] init];
    
    NSMutableArray* todoArray = [[NSMutableArray alloc] init];
    [todoArray addObjectsFromArray:pendingArray];
    
    //order dynamic push item at front
    NSString* templateTypeString = [NSString stringWithFormat:@"%d",nTemplateType];
    NSMutableArray* listDynamicServer = [mDynamicListFromServer objectForKey:templateTypeString];
    if(listDynamicServer != nil && [listDynamicServer count] > 0) {
        //avoid clear/modified by other thread, so we add try/catch and copy
        NSArray* listDynamicServerCopy = [NSArray arrayWithArray:listDynamicServer];
        for(NSNumber* numTemplateID in listDynamicServerCopy) {
            //add download template in high priority
            __block int nItemCount = (int)[todoArray count];
            for(int i = nItemCount -1; i >= 0; i--) {
                XYTemplateItemData* item = [todoArray objectAtIndex:i];
                if(item.lID == [numTemplateID longLongValue]) {
                    [sortedArray addObject:item];
                    [todoArray removeObjectAtIndex:i];
                }
            }
        }
    }
    
    //add download template in high priority
    NSMutableArray* downloadArray = [[NSMutableArray alloc] init];
    __block int nItemCount = (int)[todoArray count];
    for(int i = nItemCount -1; i >= 0; i--) {
        XYTemplateItemData* item = [todoArray objectAtIndex:i];
        if(item.nFromType == FROM_TYPE_DOWNLOAD) {
           //NSLog(@"sortTemplate 333 lID:0x%llx,strTitle:%@,order:%d,from:%d",item.lID,item.strLocalizedTitle,item.nOrder,item.nFromType);
            //[sortedArray addObject:item];
            [downloadArray addObject:item];
            [todoArray removeObjectAtIndex:i];
        }
    }
    NSSortDescriptor* sortUpdateTime = [NSSortDescriptor sortDescriptorWithKey:@"lUpdateTime" ascending:NO];
    [downloadArray sortUsingDescriptors:[NSArray arrayWithObject:sortUpdateTime]];
    [sortedArray addObjectsFromArray:downloadArray];
    

    
    NSArray *defaultSortSequence;
    int nDefaultSequnceCount = 0;
    if(nTemplateType == AMVE_STYLE_MODE_THEME) {
        if ((mask & TEMPLATE_QUERY_TYPE_MASK_PHOTO_EXCLUDE) !=0) {
            defaultSortSequence = themeVideoSequenceArray;
        }else{
            defaultSortSequence = themePhotoSequenceArray;
        }

        nDefaultSequnceCount = (int)[defaultSortSequence count];
    } else if(nTemplateType == AMVE_STYLE_MODE_TRANSITION) {
        defaultSortSequence = transitionSequenceArray;
        nDefaultSequnceCount = (int)[transitionSequenceArray count];
    } else if(nTemplateType == AMVE_STYLE_MODE_EFFECT) {
        if((mask & TEMPLATE_QUERY_TYPE_MASK_POSTFB_ONLY) != 0){
            defaultSortSequence = fbEffectSequenceArray;
            nDefaultSequnceCount = (int)[fbEffectSequenceArray count];
        }else if((mask & TEMPLATE_QUERY_TYPE_MASK_FUNNY_ONLY) != 0){
            defaultSortSequence = funnyEffectSequenceArray;
            nDefaultSequnceCount = (int)[funnyEffectSequenceArray count];
        }else{
            defaultSortSequence = imageEffectSequenceArray;
            nDefaultSequnceCount = (int)[imageEffectSequenceArray count];
        }
    } else if(nTemplateType == AMVE_STYLE_MODE_BUBBLE_FRAME) {
        defaultSortSequence = bubbleFrameSequenceArray;
        nDefaultSequnceCount = (int)[bubbleFrameSequenceArray count];
    } else if(nTemplateType == AMVE_STYLE_MODE_POSTER) {
        defaultSortSequence = posterSequenceArray;
        nDefaultSequnceCount = (int)[posterSequenceArray count];
    } else if(nTemplateType == AMVE_STYLE_MODE_MUSIC) {
        defaultSortSequence = defaultMusicSequenceArray;
        nDefaultSequnceCount = (int)[defaultMusicSequenceArray count];
    }else if(nTemplateType == AMVE_STYLE_MODE_SOUND_EFFECT) {
        defaultSortSequence = soundEffectSequenceArray;
        nDefaultSequnceCount = (int)[soundEffectSequenceArray count];
    } else if(nTemplateType == AMVE_STYLE_MODE_ANIMATED_FRAME) {
        defaultSortSequence = animateFrameSequenceArray;
        nDefaultSequnceCount = (int)[animateFrameSequenceArray count];
    } else if(nTemplateType == AMVE_STYLE_MODE_SCENE) {
        defaultSortSequence = sceneSequenceArray;
        nDefaultSequnceCount = (int)[sceneSequenceArray count];
    } else if(nTemplateType == AMVE_STYLE_MODE_PASTER_FRAME) {
        defaultSortSequence = pasterSequenceArray;
        nDefaultSequnceCount = (int)[pasterSequenceArray count];
    } else if(nTemplateType == AMVE_STYLE_MODE_DIVA) {
        defaultSortSequence = divaSequenceArray;
        nDefaultSequnceCount = (int)[divaSequenceArray count];
    }

    
    //add inside template by sequence
    long long lDefSequenceID = 0;
    for(int i = 0; i < nDefaultSequnceCount; i++) {
        lDefSequenceID = [self xy_getLongLongFromString:[[defaultSortSequence objectAtIndex:i] valueForKey:@"_id"]];
        nItemCount = (int)[todoArray count];
        for(int j = nItemCount - 1; j >= 0; j--) {
            XYTemplateItemData* item = [todoArray objectAtIndex:j];
            if(item.lID == lDefSequenceID) {
                [sortedArray addObject:item];
                [todoArray removeObjectAtIndex:j];
                break;
            }
        }
    }
    
    //add others
    [sortedArray addObjectsFromArray:todoArray];
    //hide template if international version
    for(int j = 0; j< sizeof(COMMON_INVISIBLE_TEMPLATE_LIST) / sizeof(COMMON_INVISIBLE_TEMPLATE_LIST[0]); j++) {
        UInt64 lTemID = COMMON_INVISIBLE_TEMPLATE_LIST[j];
        
        nItemCount = (int)sortedArray.count;
        for (int i = nItemCount -1; i>=0; i --) {
            XYTemplateItemData* item = sortedArray[i];
            if (lTemID == item.lID) {
                [sortedArray removeObjectAtIndex:i];
                break;
            }
        }
    }
    
    
#warning -- todo 海外素材的隐藏列表  业务逻辑
//    if([[XYVivaAppInfoMgr sharedMgr] isInChina] == NO) {
//        //hide template if international version
//        [invisibleInternationalSequenceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            UInt64 lTemID  = [NSString xy_getLongLongFromString:[obj valueForKey:@"_id"]];
//            nItemCount = (int)sortedArray.count;
//            for (int i = nItemCount -1; i>=0; i --) {
//                XYTemplateItemData* item = sortedArray[i];
//                if (lTemID == item.lID && item.nFromType != FROM_TYPE_DOWNLOAD ) {
//                    [sortedArray removeObjectAtIndex:i];
//                    break;
//                }
//            }
//        }];
//    }

    NSSortDescriptor* sortByOrderNo = [NSSortDescriptor sortDescriptorWithKey:@"nOrder" ascending:YES];
    [sortedArray sortUsingDescriptors:[NSArray arrayWithObject:sortByOrderNo]];
    
    //set default to the first position
    for(int k= 0;k<sortedArray.count;k++){
        XYTemplateItemData* item = sortedArray[k];
        if([self isDefaultTemplate:item.lID]){
            [sortedArray removeObjectAtIndex:k];
            [sortedArray insertObject:item atIndex:0];
//            NSLog(@"reset default order,order:%d",k);
        }
        
    }
    
    return sortedArray;
}


#pragma mark -- public method for query template by mask
- (NSArray<XYTemplateItemData *>*)query:(int)nTemplateType queryMask:(int)nQueryMask {
    __block NSMutableArray<XYTemplateItemData *> * resultArray;
    dispatch_sync(_queue, ^{
        NSMutableArray* result = [[NSMutableArray alloc] init];
        //BOOL bPhotoTemplate = FALSE;
        for(XYTemplateItemData* item in mTemplateArray) {
            //check nTemplateType
            //        NSLog(@"query template lID:%lld",item.lID);
            //        NSLog(@"title:%@",item.strTitle);
            
            //nAppFlag == 1,hidden it
            if (item.nAppFlag == 1) {
                continue;
            }
            
            if([CXiaoYingStyle GetTemplateType:(MInt64)item.lID] != nTemplateType)
                continue;
            
            if ([CXiaoYingStyle IsThemeSubTemplate:item.lID] == MTrue) {//Do not show theme sub template
                continue;
            }
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_DEFAULT_EXCLUDE) != 0 && [self isEmptyTemplate:item.lID])
                continue;
            
            if((nQueryMask & (TEMPLATE_QUERY_TYPE_MASK_PHOTO_EXCLUDE | TEMPLATE_QUERY_TYPE_MASK_VIDEO_EXCLUDE)) != 0) {
                BOOL bIsPhotoTemplate = [CXiaoYingStyle IsPhotoTemplate:(MInt64)item.lID];
                if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_PHOTO_EXCLUDE) != 0) {
                    if(bIsPhotoTemplate)
                        continue;
                }
                
                if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_VIDEO_EXCLUDE) != 0) {
                    if(!bIsPhotoTemplate)
                        continue;
                }
            }
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_FUNNY_EXCLUDE) != 0 && [CXiaoYingStyle IsFunnyEffectTemplate:item.lID])
                continue;
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_POSTFB_EXCLUDE) != 0 && [CXiaoYingStyle IsFBPostprocessTemplate:item.lID])
                continue;
            
            if(item.nDelFlag == TEMPLATE_DELETE_FLAG_VIRTUAL)
                continue;//template is virtual deleted
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_FAVORITE_ONLY) != 0 && (item.nFavorite & FLAG_BIT_FAVORITE) == 0)
                continue;
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_LOCAL_EXCLUDE) != 0 && item.nFromType == FROM_TYPE_LOCAL)
                continue;
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_DOWNLOAD_ONLY) != 0 && item.nFromType != FROM_TYPE_DOWNLOAD)
                continue;
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_ONLINE_ONLY) != 0 && [CXiaoYingStyle IsOfflineTemplate:(MInt64)item.lID])
                continue;
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_FUNNY_ONLY) != 0 && ![CXiaoYingStyle IsFunnyEffectTemplate:(MInt64)item.lID])
                continue;
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_POSTFB_ONLY) != 0 && ![CXiaoYingStyle IsFBPostprocessTemplate:(MInt64)item.lID])
                continue;
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_PREFB_ONLY) != 0 && ![CXiaoYingStyle IsFBPreprocessTemplate:(MInt64)item.lID])
                continue;
            if((int)item.lLayoutFlag != -1) {
                if(((nQueryMask & TEMPLATE_QUERY_LAYOUT_MASK_ALL) & item.lLayoutFlag) == 0)
                    continue;
            }
            
            if(![self isVisibleTemplate: (MInt64)item.lID])
                continue;
            
            if((nQueryMask & TEMPLATE_QUERY_TYPE_MASK_VIRTUAL_EXCLUDE) != 0 && item.nDownloadFlag == 1)
                continue;
            
            if([self isOutOfDateTemplate:item.lID]){
                continue;
            }
 
#ifndef SUPPORT_TEST_TEMPLATE
            if ([self isLiveShowTemplate:(MInt64)item.lID]) {
                continue;
            }
#endif
            
            //now,it is our desired template
            [result addObject:item];
        }
        
        //sort it
        resultArray = [self sortTemplate: result type: nTemplateType mask:nQueryMask];
    });
    return resultArray;
}

-(BOOL)isOutOfDateTemplate:(UInt64) llID{
    BOOL isOutOfDate = NO;
    if(llID == 0x0300000000000032L ||
       llID == 0x0300000000000036L ||
       llID == 0x030000000000003AL ||
       llID == 0x0400000000000067L ||
       llID == 0x0400000000000062L ||
       llID == 0x040000000000006AL   ) {
       isOutOfDate = YES;
    }
    return isOutOfDate;
}

#pragma mark -- delegate for file manager

/* fileManager:shouldProceedAfterError:copyingItemAtPath:toPath: gives the delegate an opportunity to recover from or continue copying after an error. If an error occurs, the error object will contain an NSError indicating the problem. The source path and destination paths are also provided. If this method returns YES, the NSFileManager instance will continue as if the error had not occurred. If this method returns NO, the NSFileManager instance will stop copying, return NO from copyItemAtPath:toPath:error: and the error will be provied there.

 If the delegate does not implement this method, the NSFileManager instance acts as if this method returned NO.
 */
- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error copyingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath
{
//    NSLog(@"srcPath:%@ dstPath:%@",srcPath,dstPath);
    NSLog(@"error:%@,code:%d",error.description,(int)error.code);
    if (error.code == 516) {
        NSString* newFilePath = [NSFileManager xy_removeLastSlash:dstPath];
        BOOL isDir = NO;
        BOOL valid;
        valid = [[NSFileManager defaultManager] fileExistsAtPath:newFilePath isDirectory:&isDir];
        if (valid && isDir) {
            return  YES;
        }
        
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSError* error1;
        [fileManager removeItemAtPath:dstPath error: &error1];
        [fileManager copyItemAtPath:srcPath toPath:dstPath error: &error1];
    }
    return YES;
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error movingItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    NSLog(@"movingItemAtPath :%d",(int)error.code);
    if (error.code == 516) {
        NSString* newFilePath = [NSFileManager xy_removeLastSlash:dstPath];
        BOOL isDir = NO;
        BOOL valid;
        valid = [[NSFileManager defaultManager] fileExistsAtPath:newFilePath isDirectory:&isDir];
        if (valid && isDir) {
            return  YES;
        }
        
        NSFileManager* fileManager = [NSFileManager defaultManager];
        NSError* error1;
        [fileManager removeItemAtPath:dstPath error: &error1];
        [fileManager copyItemAtPath:srcPath toPath:dstPath error: &error1];
    }
    
    
    return YES;
}


/* fileManager:shouldProceedAfterError:removingItemAtPath: allows the delegate an opportunity to remedy the error which occurred in removing the item at the path provided. If the delegate returns YES from this method, the removal operation will continue. If the delegate returns NO from this method, the removal operation will stop and the error will be returned via linkItemAtPath:toPath:error:.

 If the delegate does not implement this method, the NSFileManager instance acts as if this method returned NO.
 */
- (BOOL)fileManager:(NSFileManager *)fileManager shouldProceedAfterError:(NSError *)error removingItemAtPath:(NSString *)path
{
    return YES;
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldCopyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
    BOOL isDir = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:srcPath isDirectory:&isDir];
    if (isDir) {
        return YES;
    }
    
    NSLog(@"srcPath:%@ dstPath:%@",srcPath,dstPath);
    return YES;
}

- (BOOL)fileManager:(NSFileManager *)fileManager shouldMoveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath{
//    NSLog(@"shouldMoveItemAtPath in");
    return YES;
}

#pragma mark -- pop up view
- (void)showTemplatePopView
{
    [self updateTemplatePopView:currentProgress];
}

- (void)updateTemplatePopView:(int)percent
{    nInstallProgress = percent;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kXiaoYingSDKTemplateCheckProgress" object:@(percent)];
}

- (void)dismissTemplatePopView
{
//    [[XYPopupViewMgr sharedInstance] dismiss];
}


#pragma mark - for register fonts
- (void)registerTemplateFonts
{
    NSFileManager * fileMgr = [[NSFileManager alloc] init];
    NSMutableArray *pathArray = [NSMutableArray array];
    for (NSString *fontFileName in [fileMgr subpathsAtPath:APP_FONTS_PATH]) {
        [pathArray addObject:[NSString stringWithFormat:@"%@/%@", APP_FONTS_PATH, fontFileName]];
    }
    for (NSString *fontFileName in [fileMgr subpathsAtPath:APP_BUNDLE_FONTS_PATH]) {
        [pathArray addObject:[NSString stringWithFormat:@"%@/%@", APP_BUNDLE_FONTS_PATH, fontFileName]];
    }
    for (NSString * path in pathArray) {
        NSString *ext = path.pathExtension.lowercaseString;
        if ([ext isEqualToString:DEFAULT_TTF_FILE_EXT]|| [ext isEqualToString:DEFAULT_OTF_FILE_EXT]) {
            [self registerFontWithPath:path];
        }
    }
}

-(UIImage*)getTemplateLogoImage:(XYTemplateItemData*)item{
    if ([NSString xy_isEmpty:item.strPath]) {
        return nil;
    }
    NSString* strXYT = item.strPath;
    CXiaoYingStyle* style = [[CXiaoYingStyle alloc] init];
    MRESULT res = [style Create:[strXYT UTF8String] BGLayoutMode:QVTP_LAYOUT_MODE_PORTRAIT SerialNo:MNull];
    if(res != 0)
        return nil;

    //3. get thumb and other and destroy style
    UIImage* image = [self createTemplateThumbnailFromStyle:style thumbWidth:TEMPLATE_THUMBNAIL_WIDTH thumbHeight:TEMPLATE_THUMBNAIL_HEIGHT];
    [style Destory];
    style = nil;
    return image;
    
}

- (NSString *)getTemplateWebpLogoImageFilePath:(XYTemplateItemData*)item {
   return [self getTemplateExternalFileInternal:item.lID SubTemID:0 FileID:QVET_TEMPLATE_THUMBNAIL_FILE_ID];
}

- (CXiaoYingStyle *)getCXiaoYingStyleByID:(UInt64)lID
{
    __block CXiaoYingStyle *style = [[CXiaoYingStyle alloc] init];
    
    dispatch_sync(_queue, ^{
        for(XYTemplateItemData *item in mTemplateArray)
        {
            if(item.lID == lID)
            {
                MRESULT res = [style Create:[item.strPath UTF8String] BGLayoutMode:QVTP_LAYOUT_MODE_PORTRAIT SerialNo:MNull];
                if(res != 0)
                {
                    NSLog(@"pasterComboByID : res = %d", res);
                }
                
                break;
            }
        }
    });
    
    return style;
}

//获取人脸表情动作提示类型
- (NSInteger)getPasterExpressionType:(UInt64)templateID {
    UInt32 tempTipType = 0;
    NSArray *combo = [[XYTemplateDataMgr sharedInstance] getPasterComboByID:templateID];
    for (NSNumber *num in combo) {
        CXiaoYingStyle *tempCXiaoYing = [self getCXiaoYingStyleByID:num.unsignedLongLongValue];
        [tempCXiaoYing GetPasterExpressionType:&tempTipType];
        
        if(tempTipType != 0) {
            return tempTipType;
        }
    }
    return AMVE_FACEDT_EXPRESSION_TYPE_NONE;
}

- (NSString *)hanziToPinYin:(NSString *)hanziText
{
    if ([hanziText length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            //            NSLog(@"pinyin: %@", ms);
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            //            NSLog(@"pinyin: %@", ms);
        }
        return ms;
    }else{
        return hanziText;
    }
}

#pragma mark - CXiaoYingTemplateAdapter
- (MRESULT) GetTemplateFile : (MInt64) llID
               TemplatePath : (MTChar*) szTemplatePath
                 BubberSize : (MDWord) dwBufSize
{
    if (MNull == szTemplatePath)
        return MERR_INVALID_PARAM;
    
    if(llID == 0x070000000000000A
       || llID == 0x0700000000000002
       || llID == 0x0700000000000003
       || llID == 0x0700000000000004
       || llID == 0x0700000000000006
       || llID == 0x0700000000000009){
        llID = TEMPLATE_DEFAULT_BGM_ID;
    }
    
    //we should map V2 ID to V3 from 2015/04/27
    //1. 0x0300000000000032，0x030000000000003B，0x0100000000000054 //已下架
    //2. 0x0300000000000036，0x030000000000003C，0x0100030000000058//内置
    //3. 0x030000000000003A, 0x030000000000003D, 0x010003000000005D//内置
    //4. 0x0400000000000067, 0x040000000000006C, 0x010003000000005A //内置
    //5. 0x0400000000000062L, 0x040000000000006EL,0x010000000000004B
    
    if(llID == 0x0300000000000032L) {
        llID = 0x030000000000003BL;
    } else if(llID == 0x0300000000000036L) {
        llID = 0x030000000000003CL;
    } else if(llID == 0x030000000000003AL) {
        llID = 0x030000000000003DL;
    } else if(llID == 0x0400000000000067L) {
        llID = 0x040000000000006CL;
    } else if(llID == 0x0400000000000062L) {
        llID = 0x040000000000006EL;
    } else if(llID == 0x040000000000006AL) {
        llID = 0x040000000000006BL;
    }
    
    NSString *templatePath = [[XYTemplateDataMgr sharedInstance] getPathByID:llID];
    if(templatePath){
        MTChar *pszTemp = (MTChar*)[templatePath UTF8String];
        if (!pszTemp || 0==MStrLen(pszTemp))
            return MERR_FILE_NOT_EXIST;
        
        if ( dwBufSize < sizeof(MTChar)*(MStrLen(pszTemp)+1))
            return MERR_INVALID_PARAM;
        
        MStrCpy(szTemplatePath, pszTemp);
        return MERR_NONE;
    }else{
        szTemplatePath[0] = 0;
        return QVET_ERR_COMMON_TEMPLATE_MISSING;
    }
}

- (MInt64) GetTemplateID : (const MTChar*) szTemplatePath
{
    NSString *templatePath = [NSString stringWithUTF8String:szTemplatePath];
    return [self getIDByPath:templatePath];
}

- (MRESULT) GetTemplateExternalFile:(MInt64)templateID
                           SubTemID:(MDWord)subTemplateID
                             FileID:(MDWord)fileID
                           FilePath:(MChar *)szFilePath
                            PathLen:(MDWord)dwLen
{
    NSString *externalTemplateFilePath = [self getTemplateExternalFile:templateID
                                                              SubTemID:subTemplateID
                                                                FileID:fileID];
    if(externalTemplateFilePath){
        MTChar *pszTemp = (MTChar*)[externalTemplateFilePath UTF8String];
        if (!pszTemp || 0==MStrLen(pszTemp))
            return MERR_FILE_NOT_EXIST;
        
        if ( dwLen < sizeof(MTChar)*(MStrLen(pszTemp)+1))
            return MERR_INVALID_PARAM;
        
        MStrCpy(szFilePath, pszTemp);
        return MERR_NONE;
    }else{
        return QVET_ERR_APP_NOT_READY;
    }
}

- (MRESULT) ModifyFilePath : (MTChar*)pszFileToModify
                 StrBufLen : (MDWord)dwStrBufLen
{
    NSString *originalFilePath = [NSString stringWithUTF8String:pszFileToModify];
    NSString *fullPath = [originalFilePath xy_toReplaceAppRootPath];
    MTChar *pszTemp = (MTChar*)[fullPath UTF8String];
    if (pszTemp == nil) {
        return QVET_ERR_APP_NULL_POINTER;
    }
    MDWord strLength = MStrLen(pszTemp);
    if(strLength>dwStrBufLen || strLength==0){
        return QVET_ERR_APP_SMALL_BUF;
    }else{
        MStrCpy(pszFileToModify, pszTemp);
    }
    
    return QVET_ERR_NONE;
}

//获取字幕的子类型
- (NSInteger)getXYTemplateItemDataSubTcid:(XYTemplateItemData *)data
{
    return [CXiaoYingStyle GetTemplateSubType:data.lID];
}

- (NSInteger)onGetThemeCoverPositionByThemeId:(UInt64)themeId {
    return [self getThemeCoverPositionByThemeId:themeId];
}

- (NSString *)onGetTemplateFilePathWithID:(UInt64)templateID {
    NSString *templatePath = [[XYTemplateDataMgr sharedInstance] getPathByID:templateID];
    return templatePath;
}

-(BOOL)isContainVoiceInExtFileWithTemplateFilePath:(NSString *)filePath{
    CXiaoYingStyle *style = [[CXiaoYingStyle alloc] init];
    [style Create:[filePath UTF8String] BGLayoutMode:QVTP_LAYOUT_MODE_PORTRAIT SerialNo:MNull];
    MDWord dwExtInfoCount = 0;
    MRESULT res = [style GetExternalFileCount:&dwExtInfoCount];
    BOOL isContain = NO;
    if(res == 0 && dwExtInfoCount > 0) {
        QVET_EXTERNAL_ITEM_INFO* info = (QVET_EXTERNAL_ITEM_INFO*) MMemAlloc(MNull, sizeof(QVET_EXTERNAL_ITEM_INFO) * dwExtInfoCount);
        res = [style GetExternalFileInfos:info InfoCount:dwExtInfoCount];
        if(res == 0) {
            for(MDWord i = 0; i < dwExtInfoCount; i++) {
                if (info[i].dwFileID == 1000)
                    isContain = YES;
            }
        }
        MMemFree(MNull, info);
    }
    return isContain;
}

- (NSArray *)getTemplateArray
{
    return mTemplateArray;
}

- (MSIZE)getThemeInnerBestSize:(UInt64)themeId//获取主题里推荐的比例
{
    MSIZE result = {0};
    
    if(themeId == 0)
    {
        return result;
    }
    
    CXiaoYingStyle *style = [self getCXiaoYingStyleByID:themeId];
    
    MDWord res = [style GetThemeExportSize:&result];
    
    return result;
}

+ (BOOL)IsPhotoTemplate:(UInt64)themeId
{
    return [CXiaoYingStyle IsPhotoTemplate:(MInt64)themeId];
}

- (NSString *)xy_loadPreference:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

- (id)xy_loadPreference:(NSString *)key defaultValue:(id)defaultValue {
    NSString *realKey = key;
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    id value = [saveDefaults valueForKey:realKey];
    if(!value){
        value = defaultValue;
    }
    return value;
}


- (void)xy_savePreference:(id)data key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:key];
}

- (unsigned long long)xy_getLongLongFromString:(NSString*) strLongLong
{
    NSScanner* scanner = [NSScanner scannerWithString:strLongLong];
    unsigned long long longlongTtid = 0;
    [scanner scanHexLongLong: &longlongTtid];
    return longlongTtid;
}

@end
