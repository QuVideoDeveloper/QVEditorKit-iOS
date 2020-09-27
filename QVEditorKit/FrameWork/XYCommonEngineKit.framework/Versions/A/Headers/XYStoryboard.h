//
//  XYStoryboard.h
//  XiaoYing
//
//  Created by xuxinyuan on 13-4-26.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//

#import "AnimatedFrameInfo.h"
#import <XYCommonEngine/CXiaoYingInc.h>
#import "XYMultiTextInfo.h"
#import "StickerInfo.h"
#import "TextInfo.h"
#import "XYAMVELoadStoryboardDelegateToBlock.h"
#import "XYAMVESaveStoryboardDelegateToBlock.h"
#import "XYAMVELoadStoryboardDataDelegateToBlock.h"
#import "XYClipDataItem.h"
#import "XYEngine.h"
#import "XYEngineDef.h"
#import <Foundation/Foundation.h>
#import "XYPlayerView.h"
#import "QVEngineDataSourceProtocol.h"

@class XYEffectPropertyInfoModel;



#pragma mark - Delegate定义
/**
 该回调用于将引擎中定义的格式化字符串（例如：%date%），根据业务需求替换成具体内容
 */
@protocol XYStoryboardEditTextParserDelegate <NSObject>

- (NSString *)onParseText:(NSString *)formatText;

@end

/**
 为了EngineKit不依赖于Template，因此需要处理模版时，通过这个delegate回调出去以获取模版路径
 */
@protocol XYStoryboardTemplateDelegate <NSObject>

- (NSString *)onGetTemplateFilePathWithID:(UInt64)templateID;
- (UInt64)onGetTemplateIDWithTemplateFilePath:(NSString *)TemplateFilePath;

- (NSInteger)onGetThemeCoverPositionByThemeId:(UInt64)themeId;
/// 根据模板id 获取模板信息 此接口是获取参数调节模板，效果插件模板信息
/// @param templateID 模板id
- (XYEffectPropertyInfoModel *)onGetEffectPropertyInfoWithTemplateID:(UInt64)templateID;
@end

@interface XYStoryboardSaveConfig : NSObject

@property (nonatomic, copy) NSString * _Nullable prjFilePath;


@end

#pragma mark - XYStoryboard类
/**
 引擎封装层最主要的类
 */
@interface XYStoryboard : NSObject <AMVESessionStateDelegate, AMVEThemeOptDelegate>
@property (weak, nonatomic) XYPlayerView *playView;
@property (nonatomic, weak) CXiaoYingPlayerSession *playSeesion;
@property (nonatomic, strong) UIImage *collogeCutOutImage;
@property (nonatomic, weak) id <QVEngineDataSourceProtocol> dataSource;
@property (copy, nonatomic) NSString *languageCode;//语言
//引擎这边的CXiaoYingStoryBoardSession
@property (nonatomic, strong) CXiaoYingStoryBoardSession *cXiaoYingStoryBoardSession;
//当前工程文件的全路径
@property (nonatomic, copy) NSString *currentProjectFullFilePath;
//字符串解析delegate
@property (nonatomic, weak) id<XYStoryboardEditTextParserDelegate> textParserDelegate;

@property (nonatomic, weak) id<QVEngineDataSourceProtocol> textDataSourceDelegate;
/// 是否开启日志的打印
@property (nonatomic, assign) BOOL isPrintLog;


//模版解析delegate
@property (nonatomic, weak) id<XYStoryboardTemplateDelegate> templateDelegate;
//Storyboard是否被修改
@property (nonatomic) BOOL isModified;
@property (nonatomic) BOOL isUseStuffClip;
//封面压缩率（百分比）
@property (nonatomic) int coverCompressQualityParam;

//如果切换到SlideShowSession 在调用小影的工程需 调 initXYStoryBoard
@property (nonatomic) BOOL isSlideShowSession;

@property (nonatomic) BOOL isInBackground;

#pragma mark - Storyboard相关
/**
 该单例为当前编辑中的Storyboard
 */
+ (XYStoryboard *)sharedXYStoryboard;
+ (BOOL)isLastWorkedPrjExsit:(NSString *)prjFilePath;
- (void)initAll;
- (MRESULT)setUserData:(NSString *)strUserData;
- (NSString *)getUserData;
- (NSString *)getClipData:(CXiaoYingClip *)clip;
- (void)setStoryboardSession:(CXiaoYingStoryBoardSession *)storyboardSession;
- (void)renewStoryboardSession;
- (MRESULT)initXYStoryBoard;
- (MRESULT)unInitXYStoryBoard;
- (MRESULT)unInitAutoEditStoryBoard;
- (UInt32)getDuration;
- (MRESULT)setStoryboardTrimRange:(MDWord)startPos
                           endPos:(MDWord)endPos;
- (AMVE_POSITION_RANGE_TYPE)getStoryboradTrimRange;
- (MRESULT)applyStoryboardTrim;
- (AMVE_VIDEO_INFO_TYPE)getVideoInfo;
- (void)saveProjectThumbnails:(NSString *)filePath thumbPos:(UInt64)thumbPos;
- (MRESULT)saveStoryboardWithSaveConfigBlock:(XYStoryboardSaveConfig *_Nonnull (^)(XYStoryboardSaveConfig * saveConfig))saveConfigBlock
                               completeBlock:(SAVE_COMPLETE_BLOCK)completeBlock;
- (void)loadLastWorkedPrj:(NSString *)prjFilePath;
- (MRESULT)loadStoryboard:(NSString *)prjFilePath block:(LOAD_COMPLETE_BLOCK)block;
- (MRESULT)reloadCurrentStoryboard:(LOAD_COMPLETE_BLOCK)block;
- (MRESULT)reloadBackupStoryboard:(LOAD_COMPLETE_BLOCK)block;
- (void)upgradeCurrentStoryboard;
- (CXiaoYingStoryBoardSession *)getStoryboardSession;
- (MHandle)getStoryboardHSession;
- (CXiaoYingClip *)getDataClip;
- (void)setModified:(BOOL)modified;
- (BOOL)IsModified;
- (MRESULT)backupStoryboard:(NSString *)prjFilePath block:(SAVE_COMPLETE_BLOCK)block;
- (MRESULT)backupStoryboard:(NSString *)prjFilePath saveThumbnails:(BOOL)saveThumbnails block:(SAVE_COMPLETE_BLOCK)block;
+ (void)deleteBackup:(NSString *)prjFilePath;
- (MRESULT)setOutputResolution:(MPOINT *)pStbSize;
- (MRESULT)getOutputResolution:(MPOINT *)pStbSize;
- (CGSize)getExportSize;
- (CGSize)getHDExportSize;
- (CGSize)getHDRecommededExportSizeFromMinimumWidth:(CGFloat)minimumWidth;
- (BOOL)updateStoryboardSize:(BOOL)isPhotoMV;
- (MPOINT)getStoryboardOriginalSize:(BOOL)isPhotoMV;
- (BOOL)updateStoryboardSize:(BOOL)isPhotoMV isAppliedEffects:(BOOL)isAppliedEffects;

- (MPOINT)updateStoryboardSizeWithInputWidth:(CGFloat)width inputScale:(MSIZE)inputScale isPhotoMV:(BOOL)isPhotoMV isAppliedEffects:(BOOL)isAppliedEffects downScale:(BOOL)downScale;
- (MPOINT)updateStoryboardSizeWithInputWidth:(CGFloat)width inputScale:(MSIZE)inputScale isPhotoMV:(BOOL)isPhotoMV downScale:(BOOL)downScale;

- (BOOL)isHDStoryboard;
- (BOOL)isStoryboardSizeLargerOrEqualTo:(CGSize)targetSize;


#pragma mark - Thumbnail related

#pragma mark - Text bubble related
- (CGSize)getTemplateTextOriginalSize:(NSString *)templateFilePath
                         previewFrame:(CGRect)previewFrame
                               bHasBG:(MBool *)bHasBG
                          bIsAnimated:(MBool *)bIsAnimated
                           dwBGFormat:(MDWord *)dwBGFormat;
- (TextInfo *)getTemplateTextInfo:(NSString *)templateFilePath
                     previewFrame:(CGRect)previewFrame
                        inputText:(NSString *)inputText;
- (CXiaoYingEffect *)setTextEffectWithMultiTextInfo:(XYMultiTextInfo *)multiTextInfo layerId:(float)layerId;
- (MRESULT)setTextEffectByMultiTextInfo:(XYMultiTextInfo *)multiTextInfo effect:(CXiaoYingEffect *)pEffect;
- (UIImage *)getTextThumb:(TextInfo *)textInfo multiply:(int)multiply maxWidth:(int)maxWidth block:(void (^)(CGSize bubbleSize))block;

#pragma mark - Sticker ralated

//- (MultiTextInfo *)getMultiTemplateTextInfo:(NSString *)templateFilePath previewFrame:(CGRect)previewFrame inputTexts:(NSArray<NSString *> *)inputTexts caculateTemplateid:(MInt64 (^)(NSString *templateItemPath))caculateBlock;

- (StickerInfo *)getTemplateStickerInfo:(NSString *)templateFilePath previewFrame:(CGRect)previewFrame;

- (StickerInfo *)getTemplateStickerInfoByPath:(NSString *)path previewFrame:(CGRect)previewFrame;

- (UIImage *)getStickerThumb:(StickerInfo *)stickerInfo;

- (StickerInfo *)getStoryboardStickerInfo:(CXiaoYingEffect *)effect;

- (CXiaoYingEffect *)setSticker:(StickerInfo *)stickerInfo layerID:(MFloat)layerID groupID:(MDWord)groupID;

- (MRESULT)updateStickerInfo:(StickerInfo *)stickerInfo toEffect:(CXiaoYingEffect *)effect;

#pragma mark - Mosaic related
- (StickerInfo *)getMosaicInfoByPath:(NSString *)path previewFrame:(CGRect)previewFrame;

- (UIImage *)getMosaicThumb:(StickerInfo *)stickerInfo;

- (StickerInfo *)getStoryboardMosaicInfo:(CXiaoYingEffect *)effect;

- (CXiaoYingEffect *)setMosaic:(StickerInfo *)stickerInfo layerID:(MFloat)layerID groupID:(MDWord)groupID;

- (MRESULT)updateMosaicInfo:(StickerInfo *)stickerInfo toEffect:(CXiaoYingEffect *)effect;

#pragma mark - watermark related
- (CXiaoYingEffect *)setwatermarkInfo:(StickerInfo *)stickerInfo layerID:(MFloat)layerID groupID:(MDWord)groupID;

#pragma mark - Animated frame related
- (AnimatedFrameInfo *)getTemplateAnimatedFrameInfo:(NSString *)templateFilePath
                                       previewFrame:(CGRect)previewFrame;
- (MRESULT)setAnimatedFrame:(AnimatedFrameInfo *)animatedFrameInfo;
- (AnimatedFrameInfo *)getStoryboardAnimatedFrameInfo:(CXiaoYingEffect *)effect;

#pragma mark - Theme related
- (MRESULT)setTheme:(NSString *)pNSPath;
- (MInt64)getThemeID;
- (NSString *)getThemePath;
- (CXiaoYingCover *)getCover:(MDWord)property;
- (MDWord)getCoverDuration:(CXiaoYingCover *)cover;
- (MDWord)getCoverTitleIndex:(CXiaoYingCover *)cover
                        time:(MDWord)dwTime;
- (TextInfo *)getCoverTextInfo:(CXiaoYingCover *)cover
                    titleIndex:(MDWord)dwTitleIndex
                     viewFrame:(CGRect)viewFrame;

- (TextInfo *)getStoryboardTextInfo:(CXiaoYingEffect *)effect
                          viewFrame:(CGRect)viewFrame;
//！如果viewFram 传的size是 （0,0） 就不计算大小 几位置 但是可以用TextInfo.rcRegionRatio 计算出位子大小
- (XYMultiTextInfo *)getStoryboardMultiTextInfo:(CXiaoYingEffect *)effect
                          viewFrame:(CGRect)viewFrame;
- (void)updateCoverText:(CXiaoYingCover *)cover
               textInfo:(TextInfo *)textInfo
                   text:(NSString *)text
             titleIndex:(MDWord)dwTitleIndex;
- (void)updateStoryboardText:(CXiaoYingEffect *)effect
                    textInfo:(TextInfo *)textInfo
                        text:(NSString *)text;
- (NSMutableArray *)getAllThemeTextInfosWithViewFrame:(CGRect)viewFrame;
- (NSMutableArray *)getAllThemeMultiTextInfosWithViewFrame:(CGRect)viewFrame;
- (CXiaoYingEffect *)setThemeTextWithTextInfo:(TextInfo *)textInfo;
- (void)showStoryboardTextLayer:(CXiaoYingEffect *)effect
                      showLayer:(BOOL)showLayer
                 playbackModule:(id)playbackModule __attribute__((deprecated("do not use this method ")));
#pragma mark - Audio related
- (MBool)isStoryboadPrimalAudioDisabled;
- (MBool)isClipPrimalAudioDisabled:(CXiaoYingClip *)clip;
- (MRESULT)disableStoryboadPrimalAudio:(MBool)disable;
- (MRESULT)disableClipPrimalAudio:(CXiaoYingClip *)clip disable:(BOOL)disable;
- (MRESULT)disableClipEffectAudio:(CXiaoYingClip *)clip disable:(BOOL)disable;

- (MBool)audioIsRepeatEffect:(CXiaoYingEffect *)pEffect;

- (MRESULT)setAudioRepeatEffect:(CXiaoYingEffect *)pEffect isRepeatON:(MBool)isRepeatON;

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
           identifier:(NSString *)identifier;

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
               identifier:(NSString *)identifier;

- (void)setAudioRange:(MDWord)audioClipIndex
    audioTrimStartPos:(MDWord)audioTrimStartPos
      audioTrimLength:(MDWord)audioTrimLength
   storyBoardStartPos:(MDWord)storyBoardStartPos
     storyBoardLength:(MDWord)storyBoardLength
              groupID:(MDWord)groupID
              layerID:(MDWord)layerID;

- (void)setClipAudioRange:(CXiaoYingClip *)clip
           audioClipIndex:(MDWord)audioClipIndex
        audioTrimStartPos:(MDWord)audioTrimStartPos
          audioTrimLength:(MDWord)audioTrimLength
               dwStartPos:(MDWord)dwStartPos
                 dwLength:(MDWord)dwLength
                  groupID:(MDWord)groupID
                  layerID:(MDWord)layerID;

- (AMVE_POSITION_RANGE_TYPE)getAudioRange:(MDWord)audioClipIndex
                                  groupID:(MDWord)groupID
                                  layerID:(MDWord)layerID;

- (AMVE_POSITION_RANGE_TYPE)getClipAudioRange:(CXiaoYingClip *)clip
                               audioClipIndex:(MDWord)audioClipIndex
                                      groupID:(MDWord)groupID
                                      layerID:(MDWord)layerID;

- (AMVE_POSITION_RANGE_TYPE)getAudioTrimRange:(MDWord)audioClipIndex
                                      groupID:(MDWord)groupID
                                      layerID:(MDWord)layerID;

- (AMVE_POSITION_RANGE_TYPE)getClipAudioTrimRange:(CXiaoYingClip *)clip
                                   audioClipIndex:(MDWord)audioClipIndex
                                          groupID:(MDWord)groupID
                                          layerID:(MDWord)layerID;

- (MDWord)getAudioVolume:(CXiaoYingEffect *)effect
                 groupID:(MDWord)groupID
                 layerID:(MDWord)layerID;

- (void)setAudioVolume:(CXiaoYingEffect *)effect
                volume:(MDWord)volume
               groupID:(MDWord)groupID
               layerID:(MDWord)layerID;

- (MDWord)getAudioVolumeByIndex:(MDWord)audioClipIndex
                        groupID:(MDWord)groupID
                        layerID:(MDWord)layerID;

- (void)setAudioVolumeByIndex:(MDWord)audioClipIndex
                       volume:(MDWord)volume
                      groupID:(MDWord)groupID
                      layerID:(MDWord)layerID;

- (NSString *)getAudioFilePath:(CXiaoYingEffect *)effect;

- (NSString *)getAudioTitle:(CXiaoYingEffect *)effect;

+ (NSString *)createIdentifier;


- (void)muteAudio:(CXiaoYingEffect *)effect mute:(MBool)mute;

- (BOOL)isAudioMute:(CXiaoYingEffect *)effect;

- (BOOL)isAudioMuteByIndex:(MDWord)audioClipIndex groupID:(MDWord)groupID layerID:(MDWord)layerID;

- (void)muteAudioByIndex:(MDWord)audioClipIndex mute:(MBool)mute groupID:(MDWord)groupID layerID:(MDWord)layerID;

#pragma mark - BGM related
- (void)setBGM:(NSString *)musicFilePath audioTitle:(NSString *)audioTitle;
- (void)setBGM:(NSString *)musicFilePath audioTrimStartPos:(MDWord)audioTrimStartPos audioTrimLength:(MDWord)audioTrimLength audioTitle:(NSString *)audioTitle;
- (NSString *)getBGMPath;
- (AMVE_POSITION_RANGE_TYPE)getBGMAudioRangeInfo;
- (void)removeBGM;
- (void)setBGMVolume:(MDWord)volume;
- (MDWord)getBGMVolume;
- (void)muteBGM:(MBool)mute;
- (BOOL)isBGMMute;
- (void)setVideoSoundVolume:(MLong)volume;
- (MLong)getVideoSoundVolume;
- (void)resetBGM;
- (void)setBGMFadeIsfadeInElseFadeOut:(BOOL)isfadeInElseFadeOut closeFade:(BOOL)closeFade pEffect:(CXiaoYingEffect *)pEffect fadeDuration:(MDWord)fadeDuration dwLength:(MDWord)dwLength;
- (BOOL)getBGMFadeIsfadeInElseFadeOut:(BOOL)isfadeInElseFadeOut pEffect:(CXiaoYingEffect *)pEffect;
#pragma mark - Dub related
- (void)setDub:(NSString *)voiceFilePath startPos:(MDWord)startPos length:(MDWord)length audioTitle:(NSString *)audioTitle;
- (void)setDubRange:(MDWord)voiceClipIndex startPos:(MDWord)startPos;
- (NSString *)getDubPath:(MDWord)voiceClipIndex;
- (void)removeDub:(MDWord)voiceClipIndex;
- (void)setDubVolume:(MDWord)voiceClipIndex volume:(MDWord)volume;
- (MDWord)getDubVolume:(MDWord)voiceClipIndex;
- (AMVE_POSITION_RANGE_TYPE)getDubRange:(MDWord)voiceClipIndex;
- (MDWord)getDubCount;
- (MPOINT)getFitInSize:(MSIZE)ClipSize;
- (AMVE_VIDEO_INFO_TYPE)getVideoInfoWithClipIndex:(int)index;
- (CXiaoYingEffect *)getEffectByClipIndex:(int)index trackType:(MDWord)dwTrackType groupID:(MDWord)groupID;
//视频缩放背景调节
- (MRESULT)setEffectPropertyWithDwPropertyID:(MDWord)dwPropertyID pValue:(MVoid *)pValue clipIndex:(int)clipIndex;
//设置背景图片
- (CXiaoYingEffect *)setEffectVideoBackImageWidthPhotoPath:(NSString *)photoPath clipIndex:(int)clipIndex;
//获取 clip设置的背景图片
- (NSString *)getEffectClipBackImagePhotoPathWithClipIndex:(int)clipIndex;
//获取设置的背景图片的结构体
- (MRESULT)getExternalSourceWithClipIndex:(int)clipIndex source:(QVET_EFFECT_EXTERNAL_SOURCE *)source;
//获取工程比例的参数
- (MRESULT)getEffectPropertyWithDwPropertyID:(MDWord)dwPropertyID pValue:(MVoid *)pValue clipIndex:(int)clipIndex;
// dwPropertyID ： 此功能仅暂时用做 图片动画
- (MRESULT)setEffectPropertyWithPropertyID:(MDWord)dwPropertyID pValue:(MVoid *)pValue clipIndex:(int)clipIndex trackType:(MDWord)trackType groupID:(MDWord)groupID;
//获取 PropertyID 对应的值
- (MRESULT)getEffectPropertyWithDwPropertyID:(MDWord)dwPropertyID pValue:(MVoid *)pValue clipIndex:(int)clipIndex trackType:(MDWord)trackType groupID:(MDWord)groupID;
//获取工程是否选着了某个比例
- (MBool)isRatioSelected;
//保存选着了某个比例
- (void)setPropRatioSelected:(MBool)isSettedRatio;
//设置变声
- (void)setVoiceChangeValueWithClipIndex:(MDWord)clipIndex audioPitch:(float)audioPitch;
//获取变声值
- (float)getVoiceChangeValueWithClipIndex:(MDWord)clipIndex;

//设置效果的变声
- (void)setEffctVoiceChangeValueWithEffect:(CXiaoYingEffect *)pEffect audioPitch:(float)audioPitch;
//获取效果的变声
- (float)getEffctVoiceChangeValueWithEffect:(CXiaoYingEffect *)pEffect;
//关键帧相关
- (MRESULT)setKeyframeData:(NSMutableArray <CXiaoYingKeyFrameTransformValue *>*)keyFrameArray
                 effect:(CXiaoYingEffect *)effect;
- (NSArray<CXiaoYingKeyFrameTransformValue *> *)getKeyframeData:(CXiaoYingEffect *)effect;
- (MLong)geteEffectKeyframeBaseWidthWithEffect:(CXiaoYingEffect *)effect;
- (MLong)geteEffectKeyframeBaseHeightWithEffect:(CXiaoYingEffect *)effect;
//关键帧相关的effect的宽高比例发生变化时，需要更新一下OriginRegion
- (MRESULT)updateKeyframeTransformOriginRegion:(MRECT)originRegion effect:(CXiaoYingEffect *)effect;

- (CXiaoYingStoryBoardSession *)duplicate;

- (BOOL)isSetOriginVolume;
- (MRESULT)updateClipOriginVolume:(MFloat)volume;
- (MFloat)clipOriginVolume;

- (BOOL)isSetBgmVolume;
- (MRESULT)updateClipBgmVolume:(MFloat)volume;
- (MFloat)clipBgmVolume;

- (MFloat)audioVolumeEffectIndex:(int)index trackType:(MDWord)dwTrackType groupID:(MDWord)groupID;
- (MRESULT)updateAudioVolumeEffectIndex:(int)index trackType:(MDWord)dwTrackType groupID:(MDWord)groupID volumeValue:(MFloat)volumeValue;
- (MRESULT)updateAudiGainWithPEffect:(CXiaoYingEffect *)pEffect volumeValue:(MFloat)volumeValue;
- (MFloat)clipOriginVolume:(NSInteger)clipIndex;
- (MFloat)clipOriginVolumeWithPClip:(CXiaoYingClip *)pClip;
- (MRESULT)updateClipVolume:(NSInteger)clipIndex volumeValue:(MFloat)volumeValue;
- (MRESULT)updateClipVolumeWithPClip:(CXiaoYingClip *)clip volumeValue:(MFloat)volumeValue;
- (NSString *)getClipIdentifier:(CXiaoYingClip *)clip;
- (MRESULT)setClipIdentifier:(CXiaoYingClip *)clip identifier:(NSString *)identifier;
- (int)getLayoutMode:(int)width height:(int)height;
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
                         identifier:(NSString *)identifier;

#pragma mark - Text

- (CGSize)measureStandardTextSize:(AMVE_BUBBLETEXT_SOURCE_TYPE *)bubbleSource
             textTemplateFilePath:(NSString *)textTemplateFilePath
                      previewSize:(CGSize)previewSize;

- (AMVE_BUBBLETEXT_SOURCE_TYPE *)bubbleSourceWithTextTemplateID:(NSInteger)textTemplateID
                                                           text:(NSString *)text
                                                   textFontName:(NSString *)textFontName
                                                  textAlignment:(NSInteger)textAlignment
                                               textEnableEffect:(BOOL)textEnableEffect
                                               textShadowXShift:(CGFloat)textShadowXShift
                                               textShadowYShift:(CGFloat)textShadowYShift
                                              textStrokePercent:(CGFloat)textStrokePercent;

- (BOOL)isAnimatedText:(NSInteger)templateID;

#pragma mark - 8.0.0 Clip
- (NSInteger)setClipSourceRange:(CXiaoYingClip *)cXiaoYingClip sourceRange:(AMVE_POSITION_RANGE_TYPE)sourceRange;

- (AMVE_POSITION_RANGE_TYPE)getClipSourceRangeByClip:(CXiaoYingClip *)cXiaoYingClip;

- (NSInteger)setClipTrimRange:(CXiaoYingClip *)cXiaoYingClip trimRange:(AMVE_POSITION_RANGE_TYPE)trimRange;

- (AMVE_POSITION_RANGE_TYPE)getClipTrimRangeByClip:(CXiaoYingClip *)cXiaoYingClip;

- (AMVE_POSITION_RANGE_TYPE)getClipTrimRangeByIndex:(MDWord)dwIndex;

- (AMVE_POSITION_RANGE_TYPE)getClipTrimRange:(MDWord)dwIndex;//老代码用，暂时保留

- (MPOINT)calFitSize:(MSIZE)inputScale width:(CGFloat)width isPhotoMV:(BOOL)isPhotoMV isAppliedEffects:(BOOL)isAppliedEffects;

- (void)setAudioTitle:(CXiaoYingEffect *)pEffect audioTitle:(NSString *)audioTitle;

- (void)replaceAudioMusicFilePath:(NSString *)musicFilePath pEffect:(CXiaoYingEffect *)pEffect;

- (void)setAudioNSX:(CXiaoYingClip *)clip on:(BOOL)on;

- (BOOL)isAudioNSXOn:(CXiaoYingClip *)clip;

- (UIImage *)getStickerThumb:(StickerInfo *)stickerInfo size:(CGSize)size;

- (void)updateAudioRawRangeStartPos:(MDWord)rawStartPos
                          rawLength:(MDWord)rawLength
                            pEffect:(CXiaoYingEffect *)pEffect;
- (NSDictionary *)fetchProjectVersionInfo;


#pragma mark - 8.0.8
- (void)fetchProjectTemplates:(NSString *)prjFilePath
                     complete:(void (^)(NSInteger errorCode, NSArray <NSNumber *> *templates))complete;

- (MSIZE)getThemeInnerBestSize:(NSString *)themePath;

//- (AMVE_MUL_BUBBLETEXT_INFO *)fetchTemplateMultiTextInfo:(NSString *)templatePath;

- (NSString *)fetchLanguageCode;//向外部获取语言

+ (void)printLog:(NSString *)log errorCode:(NSInteger)errorCode;

- (void)updateEffectGroupID:(CXiaoYingEffect *)pEffect groupID:(MDWord)groupID;


@end
