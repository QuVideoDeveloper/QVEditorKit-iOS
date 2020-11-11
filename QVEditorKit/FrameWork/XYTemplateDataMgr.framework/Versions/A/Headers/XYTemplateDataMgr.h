//
//  XYTemplateDataMgr.h
//  XiaoYing
//
//  Created by Mac on 13-10-18.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XYCommonEngineKit/XYCommonEngineKit.h>

#import "NSBundle+XYTemplateDataMgr.h"
#import "XYTemplateDBDefine.h"
#import "XYTemplateDBMgr.h"


@interface XYTemplateXtyInfo : NSObject

@property (nonatomic) BOOL bIsAnimated;
/// 模板推荐开始的时间
@property (nonatomic) NSInteger dwStaticPos;

/// 模板推荐的时长 范围 [0 - 无限大]
@property (nonatomic) NSInteger dwMinDuration;

/// 默认的title
@property (nonatomic, copy) NSString *title;

@end

typedef NS_ENUM(NSInteger, XYTemplateDataType) {
    XYTemplateDataTypeTheme = AMVE_STYLE_MODE_THEME,//主题
    XYTemplateDataTypeThemeCover = AMVE_STYLE_MODE_COVER,//主题封面
    XYTemplateDataTypeTranstion = AMVE_STYLE_MODE_TRANSITION,//转场
    XYTemplateDataTypeFilter = AMVE_STYLE_MODE_EFFECT,//滤镜
    XYTemplateDataTypeSticker = AMVE_STYLE_MODE_PASTER_FRAME,//贴纸
    XYTemplateDataTypeFX = AMVE_STYLE_MODE_ANIMATED_FRAME,//特效
    XYTemplateDataTypeTransition = AMVE_STYLE_MODE_TRANSITION,//转场
    XYTemplateDataTypeMusic = AMVE_STYLE_MODE_MUSIC,//音乐
    XYTemplateDataTypeText = AMVE_STYLE_MODE_BUBBLE_FRAME,//字幕
};



#define FROM_TYPE_LOCAL                 0
#define FROM_TYPE_DOWNLOAD              1
#define FROM_TYPE_VIRTUAL_OVERRIDE      2

#define FLAG_BIT_FAVORITE               (1<<0)

#define TEMPLATE_QUERY_TYPE_MASK_ALL                    0
#define TEMPLATE_QUERY_TYPE_MASK_LOCAL_EXCLUDE          (1<<15)
#define TEMPLATE_QUERY_TYPE_MASK_DEFAULT_EXCLUDE        (1<<16)
#define TEMPLATE_QUERY_TYPE_MASK_FAVORITE_ONLY          (1<<17)
#define TEMPLATE_QUERY_TYPE_MASK_DOWNLOAD_ONLY          (1<<18)
#define TEMPLATE_QUERY_TYPE_MASK_ONLINE_ONLY            (1<<19)//for camera preview
#define TEMPLATE_QUERY_TYPE_MASK_PHOTO_EXCLUDE          (1<<20)
#define TEMPLATE_QUERY_TYPE_MASK_VIDEO_EXCLUDE          (1<<21)
#define TEMPLATE_QUERY_TYPE_MASK_FUNNY_ONLY             (1<<22)
#define TEMPLATE_QUERY_TYPE_MASK_FUNNY_EXCLUDE          (1<<23)
#define TEMPLATE_QUERY_TYPE_MASK_PREFB_ONLY             (1<<24)
#define TEMPLATE_QUERY_TYPE_MASK_POSTFB_ONLY            (1<<25)
#define TEMPLATE_QUERY_TYPE_MASK_PREFB_EXCLUDE          (1<<26)
#define TEMPLATE_QUERY_TYPE_MASK_POSTFB_EXCLUDE         (1<<27)
#define TEMPLATE_QUERY_TYPE_MASK_DIVA_MUSIC_ONLY        (1<<28)
#define TEMPLATE_QUERY_TYPE_MASK_DIVA_SCENE_ONLY        (1<<29)
#define TEMPLATE_QUERY_TYPE_MASK_EFFECT_SUB_TYPE_BG_ONLY (1<<30)
#define TEMPLATE_QUERY_TYPE_MASK_VIRTUAL_EXCLUDE        (1<<31)

//layout mask
#define TEMPLATE_QUERY_LAYOUT_MASK_W1H1                 QVTP_LAYOUT_MODE_W1_H1
#define TEMPLATE_QUERY_LAYOUT_MASK_W16H9                QVTP_LAYOUT_MODE_W16_H9
#define TEMPLATE_QUERY_LAYOUT_MASK_W4H3                 QVTP_LAYOUT_MODE_W4_H3
#define TEMPLATE_QUERY_LAYOUT_MASK_W9H16                QVTP_LAYOUT_MODE_W9_H16
#define TEMPLATE_QUERY_LAYOUT_MASK_W3H4                 QVTP_LAYOUT_MODE_W3_H4
#define TEMPLATE_QUERY_LAYOUT_MASK_ALL                  (TEMPLATE_QUERY_LAYOUT_MASK_W1H1 |TEMPLATE_QUERY_LAYOUT_MASK_W16H9 | \
TEMPLATE_QUERY_LAYOUT_MASK_W4H3 | TEMPLATE_QUERY_LAYOUT_MASK_W9H16 | \
TEMPLATE_QUERY_LAYOUT_MASK_W3H4)


#warning -- todo 小影的预置素材id   要优化
#define TEMPLATE_DEFAULT_EFFECT                     0x0400000000000000LL
#define TEMPLATE_DEFAULT_FUNNY_EFFECT               0x0400000000080002LL
#define TEMPLATE_DEFAULT_FB_PRE_PROCESS_EFFECT      0x4400000000180001LL
#define TEMPLATE_DEFAULT_FB_POST_PROCESS_EFFECT     0x0400000000000000LL
#define TEMPLATE_DEFAULT_TRANSITION                 0x0300000000000000LL
#define TEMPLATE_DEFAULT_THEME                      0x0100000000000000LL
#define TEMPLATE_DEFAULT_TEXT                       0x0900000000000001LL
#define TEMPLATE_DEFAULT_ANIMATE_FRAME              0x0600000000000000LL
#define TEMPLATE_DEFAULT_BGM_ID                     0x0700000000000057LL
#define TEMPLATE_DEFAULT_SCENE_PORTRAIT             0x0C00000000000006LL
#define TEMPLATE_DEFAULT_SCENE_LAND                 0x0C0000000000000CLL
#define TEMPLATE_DEFAULT_THEME_PHOTO_MV             0x0100030000000073LL
#define TEMPLATE_DEFAULT_VIDEO_PARAM_CONFIG_EFFECT  0x4B00000000080001LL


//delete flag
#define TEMPLATE_DELETE_FLAG_NORMAL     0
#define TEMPLATE_DELETE_FLAG_VIRTUAL    (1<<0)

//for 4.0 key for only one section
//#define ONLY_ONE_SECTION_KEY            @"onlyOneSectionKey"

typedef void (^XYTEMPLATE_COMPLETE_BLOCK)(BOOL result);


@interface XYTemplateItemData : NSObject
@property (readwrite, nonatomic) NSInteger lID;
@property (readwrite, nonatomic, copy) NSString* strPath;
@property (readwrite, nonatomic, copy) NSString* strTitle;
@property (readwrite, nonatomic, copy) NSString* strLocalizedTitle;
@property (readwrite, nonatomic, copy) NSString* strPinYin;
@property (readwrite, nonatomic, copy) NSString* strLogo;
@property (readwrite, nonatomic) int nVersion;
@property (readwrite, nonatomic) int nOrder;
@property (readwrite, nonatomic) int nSubOrder;
@property (readwrite, nonatomic) int nFromType;
@property (readwrite, nonatomic) int nTemplateType;
@property (readwrite, nonatomic) SInt64 lUpdateTime;
@property (readwrite, nonatomic) int  nFavorite;
@property (readwrite, nonatomic, copy) NSString* strExtInfo;
@property (readwrite, nonatomic) UInt64 lLayoutFlag;
@property (readwrite, nonatomic) int  nDownloadFlag;
@property (readwrite, nonatomic) int  nConfigureCount;
@property (readonly, nonatomic) BOOL isDummy;//需要下载模版
//for do squence
@property (readwrite, nonatomic) int nOriOrder;
@property (readwrite, nonatomic) int nDelFlag;// 值是TEMPLATE_DELETE_FLAG_VIRTUAL 代表失效

@property (readwrite, nonatomic, copy) NSString* strSceneCode;

//for app flag, 0:show, 1: hidden
@property (readwrite, nonatomic) int nAppFlag;//值是1 过滤掉这个素材

@property (readwrite, nonatomic) MDWord fileidOfStrExtInfo;

@end


@interface XYTemplateDataMgr : NSObject <NSFileManagerDelegate,CXiaoYingTemplateAdapter,CXiaoYingFilePathAdapter,XYStoryboardTemplateDelegate>

@property BOOL isInstalling;
@property int nInstallProgress;

+ (XYTemplateDataMgr *)sharedInstance;

#pragma mark -- init method
- (void)initAll:(NSInteger)defaultTemplateVersion defaultTemplateFilePath:(NSString *)defaultTemplateFilePath;

#pragma mark -- utility method
-(BOOL)isDefaultTemplate:(UInt64)lID;

#pragma mark -- scan disk
- (void)scanDisk:(XYTEMPLATE_COMPLETE_BLOCK)block;

#pragma mark -- public method
- (void)install:(NSString *)strTemplateFile;
- (void)install:(NSString *)strTemplateFile isDeleteOriginFile:(BOOL)isDeleteOriginFile;
- (void)uninstall:(NSString*)strTemplatePath;
- (NSArray<XYTemplateItemData *>*)query:(XYTemplateDataType)nTemplateType queryMask:(int)nQueryMask;

- (XYTemplateDataType)getTemplateDataTypeByID:(UInt64)lID;

#pragma mark -- public method for template data

- (NSArray<XYTemplateItemData *>*)getAllTemplateList;

- (NSArray<NSNumber *> *)getPasterComboByID:(UInt64)lID;
- (CXiaoYingEffectSwichInfo *)getPasterSwitchInfoByID:(UInt64)lID;
- (NSArray<NSNumber *> *)getPasterGroupBySwitchInfo:(CXiaoYingEffectSwichInfo *)switchInfo
                                         groupIndex:(NSInteger)groupIndex
                                       subPasterIDs:(NSArray<NSNumber *> *)subPasterIDs;
- (XYTemplateItemData*)getByID:(UInt64)lID;
- (XYTemplateItemData*)getByPath:(NSString*)path;
- (NSString*)getPathByID:(UInt64)lID;
- (UInt64)getIDByPath:(NSString *)path;
- (NSString *)getTemplateExternalFile:(MInt64)templateID SubTemID:(MDWord)subTemplateID FileID:(MDWord)fileID;

#pragma mark-- utility method
- (NSInteger)getTemplateIndex:(NSArray<XYTemplateItemData *> *)templateArray searchBy:(BOOL(^)(XYTemplateItemData *))block;
- (NSInteger)getIndexByPath:(NSArray<XYTemplateItemData *> *)templateArray templatePath:(NSString *)templatePath;
- (NSInteger)getIndexByID:(NSArray<XYTemplateItemData *> *)templateArray lID:(UInt64)lID;

- (UInt64)getIDByIndex:(NSArray<XYTemplateItemData *> *)templateArray index:(int)index;
- (XYTemplateItemData *)getByIndex:(NSArray<XYTemplateItemData *> *)templateArray index:(int)index;
- (XYTemplateItemData *)getByPath:(NSArray *)templateArray path:(NSString *)path;
- (NSString *)getPathByIndex:(NSArray<XYTemplateItemData *> *)templateArray index:(int)index;
- (NSString *)getLogoByIndex:(NSArray<XYTemplateItemData *> *)templateArray index:(int)index;
- (NSString *)getTitleByIndex:(NSArray<XYTemplateItemData *> *)templateArray index:(int)index;
- (NSString *)getTitle:(XYTemplateItemData *)XYTemplateItemData;
- (NSString *)getTitle:(XYTemplateItemData *)XYTemplateItemData language:(NSString *)language;
- (NSString *)getExtInfoFileNameByIndex:(NSArray<XYTemplateItemData *> *)templateArray index:(int)index;
- (NSString *)getExternalFileName:(XYTemplateItemData *)item;

/**
 获取主题模版中配置的封面时间点

 @param themeId 主题模版Id
 @return return 封面时间点
 */
- (UInt64)getThemeCoverPositionByThemeId:(UInt64)themeId;

#pragma mark - for register fonts
- (void)registerTemplateFonts;

- (UIImage*)getTemplateLogoImage:(XYTemplateItemData *)item;

- (NSString *)getTemplateWebpLogoImageFilePath:(XYTemplateItemData *)item;

//获取人脸表情动作提示类型
- (NSInteger)getPasterExpressionType:(UInt64)templateID;

//判断是否有音频
-(BOOL)isContainVoiceInExtFileWithTemplateFilePath:(NSString *)filePath;

- (CXiaoYingStyle *)getCXiaoYingStyleByID:(UInt64)lID;//原来是内部函数 用于slideshow
- (NSArray *)getTemplateArray;//直接返回内部mTemplateArray 应用于音乐信息获取 

- (MSIZE)getThemeInnerBestSize:(UInt64)themeId;//获取主题里推荐的比例
+ (BOOL)IsPhotoTemplate:(UInt64)themeId;

/// 获取素材的时间
/// @param templateFilePath 素材的路径
- (NSInteger)requestTemplateDurationWithTemplateFilePath:(NSString *)templateFilePath;

/// 获取素材转场的时长
/// @param effectTransFilePath 转场路径
- (NSInteger)requestEffectTansDuration:(NSString *)effectTransFilePath;

/// 判断转场是否可以编辑
/// @param effectTransFilePath 转场路径
- (BOOL)requestTranEditable:(NSString *)effectTransFilePath;

/// 获取素材的缩略图，包括相册作为素材的
/// @param filePath 素材路径
/// @param isSynchronous 是否是同步
/// @param targetSize targetSize 尺寸
/// @param resultHandler main block

- (void)requestEffectVisionThumbnail:(NSString *)filePath
                     isSynchronous:(BOOL)isSynchronous
                        targetSize:(CGSize)targetSize
                     resultHandler:(void(^)(UIImage *image))resultHandler;

/// 根据模板id 获取模板信息 此接口是获取参数调节模板，效果插件模板信息
/// @param templateID 模板id
- (XYEffectPropertyInfoModel *)requestEffectPropertyInfoWithTemplateID:(UInt64)templateID;

- (NSArray <XYTemplateXtyInfo *> *)requestTemplateTextInfoWithTemplateID:(UInt64)templateID;

@end
