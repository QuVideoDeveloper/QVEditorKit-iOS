//
//  XYAutoEditMgr.m
//  
//
//  Created by xuxinyuan on 7/21/15.
//
//

#import "XYAutoEditMgr.h"
#import "XYSlideShowMedia.h"
#import "XYSlideShowThemeTextInfo.h"
#import "XYThemeTextScene.h"
#import "XYSlideShowSourceNode.h"
#import "XYVideoScene.h"
#import "XYStoryboard.h"
#import "NSNumber+Language.h"
#import <XYCategory/XYCategory.h>
#import "XYDefaultParseThemeText.h"

//#import "SDiOSVersion.h"

#define APP_DOCUMENT_DIRECTORY         \
[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]
#define APP_PUBLIC_PATH               \
[NSString stringWithFormat:@"%@/public",APP_DOCUMENT_DIRECTORY]
#define APP_PROJECT_PATH                \
[NSString stringWithFormat:@"%@/projects/",APP_PUBLIC_PATH]

@implementation AEMakeStoryboardDelegateToBlock

- (MDWord) AMVESessionStateCallBack : (AMVE_CBDATA_TYPE*) pCBData
{
//    NSLog(@"AEMakeStoryboardDelegateToBlock AMVESessionStateCallBack status=%u errCode=0x%x doneNum=%u totalNum=%u",pCBData->dwStatus, pCBData->dwErrorCode, pCBData->dwCurTime, pCBData->dwDuration);
    if (pCBData) {
        NSUInteger doneNum = (NSUInteger)pCBData->dwCurTime;
        NSUInteger totalNum = (NSUInteger)pCBData->dwDuration;
        if (doneNum != 0 && totalNum != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_detectFaceProgressBlock) {
                    _detectFaceProgressBlock(doneNum, totalNum);
                    if (pCBData->dwStatus == QVET_SLIDESHOW_SESSION_STATUS_FACE_DETECT) {
                        _detectFaceProgressBlock = nil;
                    }
                }
            });
        }
    }
    if (pCBData && pCBData->dwStatus == QVET_SLIDESHOW_SESSION_STATUS_STOPPED){
         UInt32 errCode = pCBData->dwErrorCode;
         dispatch_async(dispatch_get_main_queue(), ^{
             if(_completeBlock){
                 _completeBlock(errCode,nil);
                 _completeBlock = nil;
#ifdef DEBUG
                 if(errCode != MERR_NONE){
                     UIAlertView *alertView = [[UIAlertView alloc] init];
                     alertView.message = [NSString stringWithFormat:@"Error 0x%x",(unsigned int)errCode];
                     [alertView addButtonWithTitle:@"Close"];
                     [alertView show];
                 }
#endif
             }
         });
    }
    return 0;
}

@end

@implementation AELoadStoryboardDelegateToBlock

- (MDWord) AMVESessionStateCallBack : (AMVE_CBDATA_TYPE*) pCBData
{
//    NSLog(@"AELoadStoryboardDelegateToBlock AMVESessionStateCallBack status=%u errCode=0x%x",pCBData->dwStatus, pCBData->dwErrorCode);
    if (pCBData && pCBData->dwStatus == AMVE_SESSION_STATUS_STOPPED){
        UInt32 errCode = pCBData->dwErrorCode;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_completeBlock){
                _completeBlock(errCode,nil);
                _completeBlock = nil;
#ifdef DEBUG
                //0x8fe005: template missing
                if(errCode != MERR_NONE
                   && errCode != 0x8b100f
                   && errCode != 0x88d00c
                    && errCode != 0x8fe005){
                    UIAlertView *alertView = [[UIAlertView alloc] init];
                    alertView.message = [NSString stringWithFormat:@"Error 0x%x",(unsigned int)errCode];
                    [alertView addButtonWithTitle:@"Close"];
                    [alertView show];
                }
#endif
            }
        });
    }
    return 0;
}

@end



@implementation AESaveStoryboardDelegateToBlock

- (MDWord) AMVESessionStateCallBack : (AMVE_CBDATA_TYPE*) pCBData
{
//    NSLog(@"[AE]AESaveStoryboardDelegateToBlock AMVESessionStateCallBack status=%u errCode=0x%x",pCBData->dwStatus, pCBData->dwErrorCode);
    if (pCBData && pCBData->dwStatus == AMVE_SESSION_STATUS_STOPPED){
        UInt32 errCode = pCBData->dwErrorCode;
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_completeBlock){
                _completeBlock(errCode,nil);
                _completeBlock = nil;
#ifdef DEBUG
                if(errCode != MERR_NONE){
                    UIAlertView *alertView = [[UIAlertView alloc] init];
                    alertView.message = [NSString stringWithFormat:@"Error 0x%x",(unsigned int)errCode];
                    [alertView addButtonWithTitle:@"Close"];
                    [alertView show];
                }
#endif
            }
        });
    }
    return 0;
}

@end

@interface XYAutoEditMgr () <CXiaoyingTextTransformer>

@end

@implementation XYAutoEditMgr{
    BOOL _isdidUninitSlideShowSession;
}

+ (XYAutoEditMgr *) sharedInstance {
    static XYAutoEditMgr *instance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        instance = [[XYAutoEditMgr alloc] init];
        [instance initAll];
    });
    return instance;
}

- (void)initAll
{
    if ([XYAutoEditMgr isOldDevice]) {//老机型老逻辑不变,新机型导出默认提到720p，vip用户提到1080p
        _defaultStoryboardWidth = 640;
        _defaultStoryboardHeight = 360;
        _hdStoryboardWidth = 1280;
        _hdStoryboardHeight = 720;
    }else{
        _defaultStoryboardWidth = 1280;
        _defaultStoryboardHeight = 720;
        _hdStoryboardWidth = 1920;
        _hdStoryboardHeight = 1080;
    }
    
//    [[XYStoryboard sharedXYStoryboard] setStoryboardDefaultSize:_defaultStoryboardWidth height:_defaultStoryboardHeight];Sunshine
    
    
    _aeMakeStoryboardDelegateToBlock = [[AEMakeStoryboardDelegateToBlock alloc] init];
    _aeLoadStoryboardDelegateToBlock = [[AELoadStoryboardDelegateToBlock alloc] init];
    _aeSaveStoryboardDelegateToBlock = [[AESaveStoryboardDelegateToBlock alloc] init];
    
    _slideShowSession = [[CXiaoYingSlideShowSession alloc] init];
    [_slideShowSession Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] SessionStateHandler:self.aeMakeStoryboardDelegateToBlock];

    
    [[XYEngine sharedXYEngine] setTextTransformer:self];
}

- (CGSize)getExportSizeWithIsPortraitScreen:(BOOL)isPortraitScreen;{
    if (!isPortraitScreen){
        return CGSizeMake(_defaultStoryboardWidth, _defaultStoryboardHeight);
    }else{
        return CGSizeMake(_defaultStoryboardHeight, _defaultStoryboardWidth);
    }
}

- (void)unInitSlideShowSession
{
    [_slideShowSession UnInit];
    _slideShowSession = nil;
    _isdidUninitSlideShowSession = YES;
}

- (void)reInitSlideShowSession
{
    _isdidUninitSlideShowSession = NO;
    if(_slideShowSession) {
        [_slideShowSession UnInit];
    }
    _slideShowSession = [[CXiaoYingSlideShowSession alloc] init];
    [_slideShowSession Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] SessionStateHandler:nil];
}


- (MRESULT)setOutputResolution:(MPOINT *)pStbSize {
    if (nil == self.slideShowSession)
        return QVET_ERR_APP_FAIL;
    
    MRESULT res = [self.slideShowSession setProperty:AMVE_PROP_SLIDESHOW_OUTPUT_RESOLUTION Value:pStbSize];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setOutputResolution err=0x%lx", res);
    }
    return res;
}

- (MRESULT)getOutputResolution:(MPOINT *)pStbSize {
    if (nil == self.slideShowSession)
        return QVET_ERR_APP_FAIL;
    
    MRESULT res = [self.slideShowSession getProperty:AMVE_PROP_SLIDESHOW_OUTPUT_RESOLUTION Value:pStbSize];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard getOutputResolution err=0x%lx", res);
    }
    return res;
}

- (NSInteger)DetectFace:(XYSlideShowMedia *)imageInfoNode
{
    SInt32 res = [_slideShowSession DetectFace:imageInfoNode.sourceInfoNode];
    if (res) {
        NSLog(@"[AE]DetectFace failed res=0x%x imageFilePath=%@",(int)res,imageInfoNode.mediaPath);
    }
    return (NSInteger)res;
}

- (void)insertImage:(XYSlideShowMedia *)imageInfoNode
{
    SInt32 res = [_slideShowSession InsertSource:imageInfoNode.sourceInfoNode];
    if(res){
        NSLog(@"[AE]InsertImage failed res=0x%x imageFilePath=%@",(int)res,imageInfoNode.mediaPath);
    }
}

- (XYSlideShowMedia *)getImageAtIndex:(UInt32)index
{
    CXiaoYingSourceInfoNode *cnode = [_slideShowSession GetSource:index];
    if (cnode == nil) {
        return nil;
    }
    XYSlideShowMedia *node = [[XYSlideShowMedia alloc] initWithNode:cnode];
    return node;
}

- (NSArray<XYSlideShowMedia *> *)getSourceInfoNodeArray
{
    UInt32 imageCount = 0;
    NSMutableArray<XYSlideShowMedia *> *sourceInfoNodeArray = [NSMutableArray array];
    SInt32 res = [_slideShowSession GetSourceCount:&imageCount];
    if (res != 0) {
        NSLog(@"[CXiaoYingSlideShowSession GetImageCount] error: 0x%x", (int)res);
        return sourceInfoNodeArray;
    }
    for (UInt32 i = 0 ; i < imageCount; i++) {
        XYSlideShowMedia *node = [self getImageAtIndex:i];
        if (node != nil) {
            [sourceInfoNodeArray addObject:node];
        }
    }
    return sourceInfoNodeArray;
}

- (XYSlideShowMedia *)getOriginalSourceInfoNodeAtIndex:(UInt32)index
{
    CXiaoYingSourceInfoNode *cnode = [_slideShowSession GetOrgSource:index];
    if (cnode == nil) {
        return nil;
    }
    XYSlideShowMedia *node = [[XYSlideShowMedia alloc] initWithNode:cnode];
    return node;
}

- (NSArray<XYSlideShowMedia *> *)getOriginalSourceInfoNodeArray
{
    UInt32 imageCount = 0;
    NSMutableArray<XYSlideShowMedia *> *sourceInfoNodeArray = [NSMutableArray array];
    SInt32 res = [_slideShowSession GetOrgSourceCount:&imageCount];
    if (res != 0) {
        NSLog(@"[CXiaoYingSlideShowSession GetOrgSourceCount] error: 0x%x", (int)res);
        return sourceInfoNodeArray;
    }
    for (UInt32 i = 0 ; i < imageCount; i++) {
        XYSlideShowMedia *node = [self getOriginalSourceInfoNodeAtIndex:i];
        if (node != nil) {
            [sourceInfoNodeArray addObject:node];
        }
    }
    return sourceInfoNodeArray;
}

- (void)makeStoryboard:(NSString *)fullLanguage completeBlock:(AE_COMPLETE_BLOCK)completeBlock detectFaceProgress:(AEProgressBlock _Nullable)progressBlock
{
    [XYStoryboard sharedXYStoryboard].isSlideShowSession = YES;
    MDWord dwResampleMode = AMVE_RESAMPLE_MODE_UPSCALE_FITIN;
    [_slideShowSession setProperty:AMVE_PROP_CLIP_RESAMPLE_MODE Value:&dwResampleMode];
    MDWord languageID = (MDWord)[NSNumber xy_getLanguageID:fullLanguage];
    [_slideShowSession setProperty:AMVE_PROP_SLIDESHOW_LANGUAGE_ID Value:&languageID];
    _aeMakeStoryboardDelegateToBlock.completeBlock = completeBlock;
    _aeMakeStoryboardDelegateToBlock.detectFaceProgressBlock = progressBlock;
    CGSize exportSize = [self getExportSizeWithIsPortraitScreen:self.isPortraitScreen];
    CXIAOYING_SIZE xySize = {0};
    xySize.x = (SInt32)exportSize.width;
    xySize.y = (SInt32)exportSize.height;
    SInt32 res = [_slideShowSession MakeStoryboard:&xySize SessionStateHandler:_aeMakeStoryboardDelegateToBlock ThemeOperationHandler:[XYStoryboard sharedXYStoryboard]];
    if(res){
        NSLog(@"[AE]MakeStoryboard failed res=0x%x",(int)res);
    }
}

- (CXiaoYingStoryBoardSession *)getStoryboardSession
{
    CXiaoYingStoryBoardSession *pStoryboardSession = nil;
    SInt32 res = [_slideShowSession GetStoryboard:&pStoryboardSession];
    if(res){
        NSLog(@"[AE]GetStoryboard failed res=0x%x",(int)res);
    }
    return pStoryboardSession;
}

- (CXiaoYingStoryBoardSession *)duplicateStoryboard
{
    CXiaoYingStoryBoardSession *storyboard;
    MRESULT res = [_slideShowSession DuplicateStoryboard:&storyboard];
    if (res) {
        NSLog(@"[AE] [CXiaoYingSlideShowSession DuplicateStoryboard:] error, res = 0x%x,", res);
    }
    return storyboard;
}

- (void)loadProject:(NSString *)projectFilePath completeBlock:(AE_COMPLETE_BLOCK)completeBlock
{
    [XYStoryboard sharedXYStoryboard].isSlideShowSession = YES;
    _aeLoadStoryboardDelegateToBlock.completeBlock = completeBlock;
    SInt32 res = [_slideShowSession LoadProject:projectFilePath SessionStateHandler:_aeLoadStoryboardDelegateToBlock];
    if(res){
        NSLog(@"[AE]LoadProject failed res=0x%x projectFilePath=%@",(int)res,projectFilePath);
    }
}

- (void)saveProject:(NSString *)projectFilePath completeBlock:(AE_COMPLETE_BLOCK)completeBlock
{
    [NSFileManager xy_createFolderWithPath:APP_PROJECT_PATH];
    _aeSaveStoryboardDelegateToBlock.completeBlock = completeBlock;
    SInt32 res = [_slideShowSession SaveProject:projectFilePath SessionStateHandler:_aeSaveStoryboardDelegateToBlock];
    if(res){
        NSLog(@"[AE]SaveProject failed res=0x%x",(int)res);
    }
}

- (SInt32)setTheme:(UInt64)themeID
{
    SInt32 res = [_slideShowSession SetTheme:themeID];
    if(res){
        NSLog(@"[AE]SetTheme failed res=0x%x",(int)res);
    }
    [self setBgmFadeIn];
    return res;
}

//Return 0 if get themeID failed
- (UInt64)getThemeID
{
    UInt64 themeID = 0;
    SInt32 res = [_slideShowSession GetTheme:&themeID];
    if(res){
        NSLog(@"[AE]GetTheme failed res=0x%x",(int)res);
        themeID = 0;
    }
    return themeID;
}

- (SInt32)setMusic : (NSString*) musicFilePath
      musicRange : (CXIAOYING_POSITION_RANGE_TYPE *)musicRange;
{
    SInt32 res = [_slideShowSession SetMusic:musicFilePath MusicRange:musicRange];
    if(res){
        NSLog(@"[AE]SetMusic failed res=0x%x",(int)res);
    }
    [self setBgmFadeIn];
    return res;
}

- (NSString*)getMusic
{
    return [_slideShowSession GetMusic];
}

- (NSString *)getDefaultMusic
{
    return [_slideShowSession GetDefaultMusic];
}

- (SInt32)getMusicRange:(CXIAOYING_POSITION_RANGE_TYPE *)musicRange
{
    SInt32 res = [_slideShowSession GetMusicRange:musicRange];
    if(res){
        NSLog(@"[AE]getMusicRange failed res=0x%x",(int)res);
    }
    return res;
}

- (CXIAOYING_POSITION_RANGE_TYPE)getMusicRange
{
    CXIAOYING_POSITION_RANGE_TYPE range = {0,0};
    SInt32 res = [_slideShowSession GetMusicRange:&range];
    if(res){
        NSLog(@"[AE]getMusicRange failed res=0x%x",(int)res);
    }
    return range;
}

- (SInt32)setMute:(BOOL)mute
{
    SInt32 res = [_slideShowSession SetMute:mute];
    if(res){
        NSLog(@"[AE]setMute failed res=0x%x",(int)res);
    }
    return res;
}

- (BOOL)getMute
{
    return [_slideShowSession GetMute];
}

- (SInt32)setBgmFadeIn
{
    AMVE_FADE_PARAM_TYPE fadeInParam = {0};
    fadeInParam.dwDuration = 2000;
    fadeInParam.dwStartPercent = 0;
    fadeInParam.dwEndPercent = 100;
    
    AMVE_FADE_PARAM_TYPE fadeOutParam = {0};
    fadeOutParam.dwDuration = 2000;
    fadeOutParam.dwStartPercent = 100;
    fadeOutParam.dwEndPercent = 0;
    SInt32 res = [_slideShowSession setProperty:AMVE_PROP_SLIDESHOW_MUSIC_FADEIN Value:&fadeInParam];
    if(res){
        NSLog(@"[AE]AMVE_PROP_SLIDESHOW_MUSIC_FADEIN failed res=0x%x",(int)res);
    }
    res = [_slideShowSession setProperty:AMVE_PROP_SLIDESHOW_MUSIC_FADEOUT Value:&fadeOutParam];
    if(res){
        NSLog(@"[AE]AMVE_PROP_SLIDESHOW_MUSIC_FADEOUT failed res=0x%x",(int)res);
    }
    return res;
}

- (NSArray<XYThemeTextScene*> *)getThemeTextSceneArray
{
    NSArray *textAnimationInfoArray = [_slideShowSession GetTextAnimationInfoArray];
    NSMutableArray<XYThemeTextScene *> * _Nonnull themeTextSceneArray = [NSMutableArray array];
    for (CXiaoYingTextAnimationInfo *textAnimationInfo in textAnimationInfoArray) {
        XYSlideShowThemeTextInfo *themeTextInfo = [[XYSlideShowThemeTextInfo alloc] initWithTextAnimationInfo:textAnimationInfo];
        XYThemeTextScene *lastScene = [themeTextSceneArray lastObject];
        if (lastScene && lastScene.position == themeTextInfo.position) {
            [lastScene.themeTextInfoArray addObject:themeTextInfo];
        }else{
            XYThemeTextScene *scene = [[XYThemeTextScene alloc] initWithPosition:themeTextInfo.position];
            [scene.themeTextInfoArray addObject:themeTextInfo];
            [themeTextSceneArray addObject:scene];
            
        }
    }
    return themeTextSceneArray;
}

- (void)setThemeText:(XYSlideShowThemeTextInfo *)themeTextInfo
{
    [_slideShowSession SetTextAnimationInfo:themeTextInfo.textAnimationInfo];
}

#pragma mark - CXiaoyingTextTransformer

- (NSString*)TransformText : (NSString*) pstrOrgText
                     Param : (AMVE_TEXT_TRANSFORM_PARAM*)pParam {
    if (_isdidUninitSlideShowSession) {
        return pstrOrgText;
    } else{
        NSLog(@"需要实现字符转译需要实现字符转译需要实现字符转译需要实现字符转译需要实现字符转译需要实现字符转译需要实现字符转译需要实现字符转译需要实现字符转译");
//        NSAssert(self.dataSource != nil, @"需要实现字符转译");
        if ([self.dataSource respondsToSelector:@selector(transformText:)]) {
          return [self.dataSource transformText:pstrOrgText];
        }  else if ([self.textDataSourceDelegate respondsToSelector:@selector(textPrepare:)]) {
            return [XYDefaultParseThemeText parse:pstrOrgText delegate:self.textDataSourceDelegate];
        }else {
            return pstrOrgText;
        }
    }
}

#pragma mark - virtual image edit

- (void)refreshVirtualSourceInfo
{
    MRESULT res = [_slideShowSession RefreshSourceList];
    if (res) {
        NSLog(@"[AE] [CXiaoYingSlideShowSession RefreshSourceList] error. res = 0x%x", res);
    }
}

- (void)clearOriginSourceInfoList{
    MRESULT res = [_slideShowSession ClearOrgSourceInfoList];
    if (res) {
        NSLog(@"[AE] [CXiaoYingSlideShowSession RefreshSourceList] error. res = 0x%x", res);
    }
}

- (NSArray<XYVideoScene *> *)videoSceneArray
{
    NSMutableArray<XYVideoScene *> *videoSceneArray = [NSMutableArray array];
    NSArray<XYSlideShowSourceNode *> *virtualSourceInfoNodeArray = [self getVirtualImgInfoNodeArray];
    for (XYSlideShowSourceNode *node in virtualSourceInfoNodeArray) {
        XYVideoScene *lastScene = [videoSceneArray lastObject];
        if (lastScene && lastScene.sceneIndex == node.sceneIndex) {
            [lastScene addSourceInfoNode:node];
        }else{
            XYVideoScene *scene = [[XYVideoScene alloc] init];
            scene.sceneIndex = node.sceneIndex;
            [scene addSourceInfoNode:node];
            [videoSceneArray addObject:scene];
        }
    }
//    NSArray<CXiaoYingVirtualSourceInfoNode *> *cXiaoYingNodeArray = [_slideShowSession GetVirtualSrcInfoNodeArray];
//    
//    for (CXiaoYingVirtualSourceInfoNode *engineVirtualNode in cXiaoYingNodeArray) {
//        XYVirtualSourceInfoNode *node = [[XYVirtualSourceInfoNode alloc] initWithVSourceInfoNode:engineVirtualNode];
//        CXiaoYingSourceInfoNode *engineRealNode = [_slideShowSession GetSource: engineVirtualNode.uiRealSrcIndex];
//        node.rotation = engineRealNode.uiRotation;
//        XYVideoScene *lastScene = [videoSceneArray lastObject];
//        if (lastScene && lastScene.sceneIndex == node.sceneIndex) {
//            [lastScene addSourceInfoNode:node];
//        }else{
//            XYVideoScene *scene = [[XYVideoScene alloc] init];
//            scene.sceneIndex = node.sceneIndex;
//            [scene addSourceInfoNode:node];
//            [videoSceneArray addObject:scene];
//        }
//    }
    return videoSceneArray;
}

- (NSArray<XYSlideShowSourceNode *> *)getVirtualImgInfoNodeArray{
    NSArray *cXiaoYingNodeArray = [_slideShowSession GetVirtualSrcInfoNodeArray];
    NSMutableArray<XYSlideShowSourceNode *> *xyNodeArray = [NSMutableArray array];
    [cXiaoYingNodeArray enumerateObjectsUsingBlock:^(CXiaoYingVirtualSourceInfoNode *virtualNode, NSUInteger idx, BOOL * _Nonnull stop) {
        XYSlideShowSourceNode *xyVirtualNode = [[XYSlideShowSourceNode alloc] initWithVSourceInfoNode:virtualNode];
        CXiaoYingSourceInfoNode *realNode = [_slideShowSession GetSource: virtualNode.uiRealSrcIndex];
        xyVirtualNode.rotation = realNode.uiRotation;
        xyVirtualNode.idx = idx;
        [xyNodeArray addObject:xyVirtualNode];
    }];
    return xyNodeArray;
}

- (CXIAOYING_TRANSFORM_PARAMETERS)transformParaWithIndex:(int)index{
  
    NSArray *cXiaoYingNodeArray = [_slideShowSession GetVirtualSrcInfoNodeArray];
    if (index < cXiaoYingNodeArray.count) {
            CXiaoYingVirtualSourceInfoNode *model = [cXiaoYingNodeArray objectAtIndex:index];
        return model.TransformPara;
    }else{
        CXIAOYING_TRANSFORM_PARAMETERS parame = {0};
        return parame;
    }

}
- (BOOL)updateVirtualImageFaceCenter:(XYSlideShowSourceNode *)vImageInfoNode faceCenterX:(NSInteger)faceCenterX faceCenterY:(NSInteger)faceCenterY{
    MRESULT res = [_slideShowSession UpdateVirtualSrcFaceCenter:vImageInfoNode.vSourceInfoNode FaceCenterX:(SInt32)faceCenterX FaceCenterY:(SInt32)faceCenterY];
    if (res) {
        NSLog(@"[AE] [CXiaoYingSlideShowSession updateVirtualImageFaceCenter:focusCenterX:focusCenterY:] error. res=0x%x", res);
    }
    return res == MERR_NONE;
}

- (BOOL)updateVirtualSourceInfoNodeTrimRange:(XYSlideShowSourceNode *)node trimRange:(CXIAOYING_POSITION_RANGE_TYPE)range playToEnd:(BOOL)playToEnd
{
    MRESULT res = [_slideShowSession SetVirtualSrcTrimRange:node.vSourceInfoNode TrimRange:&range PlayToEndFlag:playToEnd];
    if (res) {
        NSLog(@"[AE] [CXiaoYingSlideShowSession SetVirtualSrcTrimRange:TrimRange:PlayToEndFlag:] error. res = 0x%x",res);
    }
    return res == MERR_NONE;
}

- (BOOL)updateVirtualSource:(XYSlideShowSourceNode *)virtualSource sourceInfo:(XYSlideShowMedia *)sourceInfoNode
{
    MRESULT res = [_slideShowSession UpdateVirtualSource:virtualSource.vSourceInfoNode SourceInfo:sourceInfoNode.sourceInfoNode];
    if (res) {
        NSLog(@"[AE] [CXiaoYingSlideShowSession UpdateVirtualSource:SourceInfo:] error. res = 0x%x",res);
    }
    return res == MERR_NONE;
}

- (BOOL)canInsertVideo:(XYSlideShowSourceNode *)virtualSourceNode
{
    return [_slideShowSession CanInsertVideoSource:virtualSourceNode.vSourceInfoNode];
}

/**
 *  混合音量
 *
 *  @return bool
 */
- (SInt32)getMixPersent
{
    SInt32 mixPersent = 0;
    [_slideShowSession getProperty:AMVE_PROP_SLIDESHOW_AUDIO_MIX_PERCENT Value:&mixPersent];
    return mixPersent;
}

/**
 *  设置音量
 *
 *  @param persent 0-100
 *
 *  @return YES or NO
 */
- (SInt32)setMixPersent:(SInt32)persent{
    return [_slideShowSession setProperty:AMVE_PROP_SLIDESHOW_AUDIO_MIX_PERCENT Value:&persent];
}

/**
 *  Get current clip audio status
 *
 *  @param clipIndex clip index
 *
 *  @return YES or NO
 */
- (BOOL)getClipCurrentAudioStatusWithClipIndex:(int)clipIndex{
    MBool isDisabled;
    CXiaoYingStoryBoardSession *session = [self getStoryboardSession];
    if(session == nil){
        return NO;
    }
    CXiaoYingClip *clip = [session getClip:clipIndex];
    if (clip == nil) {
        return NO;
    }
    
    [clip getProperty:AMVE_PROP_CLIP_AUDIO_DISABLED PropertyData:&isDisabled];
    //[[[self getStoryboardSession] getClip:clipIndex] getProperty:AMVE_PROP_CLIP_AUDIO_DISABLED PropertyData:&isDisabled];
    return isDisabled;
}

/**
 *  Set clip close or open volume
 *
 *  @param clipsIndex ClipIndex
 */
- (void)setClipsAudioDisabledWithClipsIndex:(int)clipsIndex isDisabled:(BOOL)isDisabled{
    
    MBool bDisabled = isDisabled;
    SInt32 res = [[[self getStoryboardSession] getClip:clipsIndex] setProperty:AMVE_PROP_CLIP_AUDIO_DISABLED PropertyData:&bDisabled];
    if(res){
        NSLog(@"%x",(int)res);
    }
}

/**
 *  Set current clip panzoom status
 *
 *  @param clipIndex clip index
 *
 *  @return YES or NO
 */
- (void)setClipCurrentPanZoomIsOpenWithClip:(CXiaoYingClip *)clip isDisabled:(BOOL)isDisabled{
    MBool bDisabled = isDisabled;
    SInt32 res = [clip setProperty:AMVE_PROP_CLIP_PANZOOM_DISABLED PropertyData:&bDisabled];
    if (res){
        NSLog(@"%x",(int)res);
    }
}

/**
 *  Get current clip panzoom status
 *
 *  @param clipIndex clip index
 *
 *  @return YES or NO
 */
- (BOOL)getClipCurrentPanZoomIsOpenWithClip:(CXiaoYingClip *)clip{
    MBool isDisabled;
    [clip getProperty:AMVE_PROP_CLIP_PANZOOM_DISABLED PropertyData:&isDisabled];
    return isDisabled;
}

/**
 *  Set current node panzoom status
 *
 *  @param node isPanzoom
 *
 *  @return YES or NO
 */
- (void)setPreviewVCNodePanZoomIsOpen:(CXiaoYingVirtualSourceInfoNode *)virtualNode panzoomFlag:(BOOL)applyPanzoom{
    SInt32 res = [_slideShowSession SetVirtualSrcTransformFlag:virtualNode TransformFlag:applyPanzoom];//sunshine
                  if (res){
        NSLog(@"%x",(int)res);
    }
}

/**
 setRect2TransParam
*/
- (SInt32)setRectTransParam:(CXIAOYING_TRANSFORM_PARAMETERS *)transformPram cropRegion:(CXIAOYING_RECT)cropRegion angle:(float)angle{
   SInt32 res = [_slideShowSession SetRect2TransParam:&cropRegion angle:angle TransformPara:(transformPram)];
    return res;
}

/**
 setVirtualSourceTransformPara
 */
- (SInt32)setVirtualSourceTransformParaWithInfoNode:(CXiaoYingVirtualSourceInfoNode *)infoNode transformPara:(CXIAOYING_TRANSFORM_PARAMETERS)transformPara{
    SInt32 res = [_slideShowSession SetVirtualSrcTransformPara:infoNode TransformPara:&transformPara];
    return res;
}


/**
 *  Set clip crop region
 *
 *  @param clipsIndex clip index
 *  @param clipRegion clip region
 *
 *  @return res
 */
- (SInt32)setClipCropRegionWithClipIndex:(int)clipsIndex clipRegion:(CXIAOYING_RECT)clipRegion{
    SInt32 res = [[[self getStoryboardSession] getClip:clipsIndex] setProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&clipRegion];
    return res;
}

/**
 *  Get clip crop region with clip index
 *
 *  @param clipIndex slip index
 *
 *  @return XYClipPadding
 */
- (XYClipPadding)getClipCropRegionWithClipIndex:(int)clipIndex{
    CXIAOYING_RECT rect;
    SInt32 res = [[[self getStoryboardSession] getClip:clipIndex] getProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&rect];
    if(res){
        NSLog(@"get Clip Crop Region result is %x",(int)res);
    }
    XYClipPadding clipPadding;
    clipPadding.top = rect.siTop;
    clipPadding.bottom = rect.siBottom;
    clipPadding.left = rect.siLeft;
    clipPadding.right = rect.siRight;
    return clipPadding;
}

+ (BOOL)isOldDevice{//Sunshine
//    DeviceVersion deviceVersion = [SDiOSVersion deviceVersion];
//    if (deviceVersion <= iPhone5C && deviceVersion >= iPhone4) {
//        return YES;
//    }
//    if (deviceVersion <= iPad3 && deviceVersion >= iPad1) {
//        return YES;
//    }
//    if (deviceVersion <= iPodTouch5Gen && deviceVersion >= iPodTouch1Gen) {
//        return YES;
//    }
    return NO;
}

- (MFloat)getVirtualNodeOrgScaleValue:(UInt32)uiVirtualIndex {
  return [self.slideShowSession GetVirtualNodeOrgScaleValue:uiVirtualIndex];
}

- (MRESULT)setSlideShowSessionSceneResolution:(MPOINT *)pStbSize {
    if (nil == self.slideShowSession)
        return QVET_ERR_APP_FAIL;
    
    MRESULT res = [self.slideShowSession setProperty:AMVE_PROP_SLIDESHOW_SCENE_RESOLUTION Value:pStbSize];
    if (res) {
        NSLog(@"[ENGINE]XYStoryboard setOutputResolution err=0x%lx", res);
    }
    return res;
}

- (void)moveVirtualSource:(UInt32)dwSrcIndex dwDstIndex:(UInt32)dwDstIndex {
    if (dwDstIndex > dwSrcIndex) {
        dwDstIndex++;
    }
    [self.slideShowSession MoveVirtualSource:dwSrcIndex DstPosition:dwDstIndex];
}

@end
