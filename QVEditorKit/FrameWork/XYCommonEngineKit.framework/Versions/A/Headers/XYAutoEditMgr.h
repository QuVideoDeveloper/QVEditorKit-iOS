//
//  XYAutoEditMgr.h
//  
//
//  Created by xuxinyuan on 7/21/15.
//
//

#import <Foundation/Foundation.h>
#import "CXiaoYingSlideShowSession.h"
#import "QVEngineDataSourceProtocol.h"
#import "XYEngineStructClass.h"

@class XYSlideShowThemeTextInfo;
@class XYSlideShowThemeTextScene;
@class XYSlideShowMedia;
@class XYSlideShowSourceNode;
@class XYSlideShowSourceNodeScene;
@class XYPlayerView;
NS_ASSUME_NONNULL_BEGIN

typedef void (^AE_COMPLETE_BLOCK)(UInt32 result, id _Nullable userData);
typedef void (^AEProgressBlock)(NSUInteger doneNum, NSUInteger totalNum);


@protocol XYAutoEditMgrDataSource <NSObject>

@required

- (NSString*)transformText:(NSString*)originalText;

@end

@interface AEMakeStoryboardDelegateToBlock : NSObject  <AMVESessionStateDelegate>

@property (atomic,strong) AE_COMPLETE_BLOCK _Nullable completeBlock;
@property (atomic,strong) AEProgressBlock _Nullable detectFaceProgressBlock;

@end

@interface AELoadStoryboardDelegateToBlock : NSObject  <AMVESessionStateDelegate>

@property (atomic,strong) AE_COMPLETE_BLOCK _Nullable completeBlock;

@end

@interface AESaveStoryboardDelegateToBlock : NSObject  <AMVESessionStateDelegate>

@property (atomic,strong) AE_COMPLETE_BLOCK _Nullable completeBlock;

@end

@interface XYAutoEditMgr : NSObject

@property (nonatomic, weak) id <XYAutoEditMgrDataSource> dataSource;
@property (nonatomic, weak) id<QVEngineDataSourceProtocol> textDataSourceDelegate;
@property (nonatomic, weak) XYPlayerView *editorPlayerView;
@property (nonatomic,strong) CXiaoYingSlideShowSession * _Nullable slideShowSession;
@property (nonatomic,strong) AEMakeStoryboardDelegateToBlock * aeMakeStoryboardDelegateToBlock;
@property (nonatomic,strong) AELoadStoryboardDelegateToBlock * aeLoadStoryboardDelegateToBlock;
@property (nonatomic,strong) AESaveStoryboardDelegateToBlock * aeSaveStoryboardDelegateToBlock;

@property (nonatomic) SInt32 defaultStoryboardWidth;
@property (nonatomic) SInt32 defaultStoryboardHeight;

@property (nonatomic) SInt32 hdStoryboardWidth;
@property (nonatomic) SInt32 hdStoryboardHeight;
@property (nonatomic, assign) BOOL isPortraitScreen;//竖屏

+ (XYAutoEditMgr * _Nonnull) sharedInstance;

- (void)unInitSlideShowSession;
- (void)reInitSlideShowSession;

- (CGSize)getExportSizeWithIsPortraitScreen:(BOOL)isPortraitScreen;

- (MRESULT)setOutputResolution:(MPOINT *)pStbSize;
- (MRESULT)getOutputResolution:(MPOINT *)pStbSize;

- (NSInteger)DetectFace:(XYSlideShowMedia *)imageInfoNode;

- (void)insertImage:(XYSlideShowMedia *)imageInfoNode;
- (XYSlideShowMedia * _Nullable)getImageAtIndex:(UInt32)index;
- (NSArray<XYSlideShowMedia *> *)getSourceInfoNodeArray;
- (XYSlideShowMedia *_Nullable)getOriginalSourceInfoNodeAtIndex:(UInt32)index;
- (NSArray<XYSlideShowMedia *> *)getOriginalSourceInfoNodeArray;
- (void)makeStoryboard:(NSString *)fullLanguage
            resolution:(CGSize)resolution
         completeBlock:(AE_COMPLETE_BLOCK)completeBlock detectFaceProgress:(AEProgressBlock _Nullable)progressBlock;
- (CXiaoYingStoryBoardSession * _Nullable)getStoryboardSession;
- (CXiaoYingStoryBoardSession *)duplicateStoryboard;

- (void)loadProject:(NSString *)projectFilePath completeBlock:(AE_COMPLETE_BLOCK)completeBlock;
- (void)saveProject:(NSString *)projectFilePath completeBlock:(AE_COMPLETE_BLOCK)completeBlock;
- (SInt32)setTheme:(UInt64)themeID;
- (UInt64)getThemeID;
- (SInt32)setMusic:(NSString*) musicFilePath musicRange:(CXIAOYING_POSITION_RANGE_TYPE *)musicRange;
- (NSString* _Nullable)getMusic;
- (NSString *)getDefaultMusic;
- (SInt32)getMusicRange:(CXIAOYING_POSITION_RANGE_TYPE *)musicRange;
- (CXIAOYING_POSITION_RANGE_TYPE)getMusicRange;
- (SInt32)setMute:(BOOL)mute;
- (BOOL)getMute;
- (SInt32)getMixPersent;
- (SInt32)setMixPersent:(SInt32)persent;
- (BOOL)getClipCurrentAudioStatusWithClipIndex:(int)clipIndex;
- (void)setClipsAudioDisabledWithClipsIndex:(int)clipsIndex isDisabled:(BOOL)isDisabled;

- (BOOL)getClipCurrentPanZoomIsOpenWithClip:(CXiaoYingClip *)clip;
- (void)setClipCurrentPanZoomIsOpenWithClip:(CXiaoYingClip *)clip isDisabled:(BOOL)isDisabled;
- (void)setPreviewVCNodePanZoomIsOpen:(CXiaoYingVirtualSourceInfoNode *)virtualNode panzoomFlag:(BOOL)applyPanzoom;

- (XYClipPadding)getClipCropRegionWithClipIndex:(int)clipIndex;
- (SInt32)setClipCropRegionWithClipIndex:(int)clipsIndex clipRegion:(CXIAOYING_RECT)clipRegion;
- (SInt32)setVirtualSrcCropRegion:(XYSlideShowSourceNode *)virtualSourceInfoNode cropRegion:(CXIAOYING_RECT)cropRegion;
- (SInt32)setRectTransParam:(CXIAOYING_TRANSFORM_PARAMETERS *)transformPram cropRegion:(CXIAOYING_RECT)cropRegion angle:(float)angle;
- (SInt32)setVirtualSourceTransformParaWithInfoNode:(CXiaoYingVirtualSourceInfoNode *)infoNode transformPara:(CXIAOYING_TRANSFORM_PARAMETERS)transformPara;//保存编辑到工程

#pragma mark - theme text

- (NSArray<XYSlideShowThemeTextScene *> *)getThemeTextSceneArray;
- (void)setThemeText:(XYSlideShowThemeTextInfo *)themeTextInfo;

#pragma mark - virtual image edit

- (void)refreshVirtualSourceInfo;

- (void)clearOriginSourceInfoList;

- (NSArray<XYSlideShowSourceNode *> *)getVirtualImgInfoNodeArray;

- (NSArray<XYSlideShowSourceNodeScene *> *)slideShowSourceNodeSceneArray;

- (BOOL)updateVirtualImageFaceCenter:(XYSlideShowSourceNode *)vImageInfoNode
                         faceCenterX:(NSInteger)faceCenterX
                         faceCenterY:(NSInteger)faceCenterY;

- (BOOL)updateVirtualSourceInfoNodeTrimRange:(XYSlideShowSourceNode *)node
                                   trimRange:(CXIAOYING_POSITION_RANGE_TYPE)range
                                   playToEnd:(BOOL)playToEnd;

- (BOOL)updateVirtualSource:(XYSlideShowSourceNode *)virtualSource
                 sourceInfo:(XYSlideShowMedia *)sourceInfoNode;

- (BOOL)canInsertVideo:(XYSlideShowSourceNode *)virtualSourceNode;

#pragma mark - helper 

+ (BOOL)isOldDevice;

- (CXIAOYING_TRANSFORM_PARAMETERS)transformParaWithIndex:(int)index;

- (MFloat)getVirtualNodeOrgScaleValue:(UInt32)uiVirtualIndex;

- (MRESULT)setSlideShowSessionSceneResolution:(MPOINT *)pStbSize;

- (void)moveVirtualSource:(UInt32)dwSrcIndex dwDstIndex:(UInt32)dwDstIndex;



@end

NS_ASSUME_NONNULL_END
