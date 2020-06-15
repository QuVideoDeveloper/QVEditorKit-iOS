
/*
 * File Name:	amvebase.h					
 *
 * Reference:
 *
 * Description: This file define the structs and consts App will use.
 * 
 * History:	
 *
 * CodeReview Log:
 * 
 */

#ifndef _AMVE_BASE_H_
#define _AMVE_BASE_H_

#ifdef __cplusplus
extern "C"
{
#endif

MRESULT AMVE_CreatePlayerSession		(MHandle hIMgr,	MHandle* phSession);
MRESULT AMVE_CreateStoryboardSession	(MHandle hIMgr, MHandle* phSession);
MRESULT AMVE_DuplicateStoryboardSession (MHandle* pSrcSession, MHandle* pDstSession);
MRESULT AMVE_CreateSlideShowSession		(MHandle hIMgr, MHandle* phSession);
MRESULT AMVE_CreateProducerSession		(MHandle hIMgr, MHandle* phSession);
MRESULT AMVE_CreateAudioProviderSession(MHandle hIMgr,MHandle * phSession);

//define the structure for base session.
#define MINH_MAMVEBase() \
	MINH_MBase(); \
	MRESULT	(*fnReset)					(MHandle); \
	MRESULT	(*fnSetDisplayContext)		(MHandle, QVET_RENDER_CONTEXT_TYPE*); \
	MRESULT (*fnGetDisplayContext)		(MHandle, QVET_RENDER_CONTEXT_TYPE*); \
	MRESULT	(*fnDisplayRefresh)			(MHandle); \
	MRESULT	(*fnGetState)				(MHandle, MVoid*); \
	MRESULT (*fnSetProp)				(MHandle, MDWord, MVoid*, MDWord); \
	MRESULT (*fnGetProp)				(MHandle, MDWord, MVoid*, MDWord*)

MINF(MAMVEBaseSession)
{
	MINH_MAMVEBase();
};

//define the structure for player session.
#define MINH_MAMVEPLAYER() \
	MINH_MAMVEBase(); \
    MRESULT (*fnActiveStream)				(MHandle, MHandle,MDWord,MBool); \
    MRESULT (*fnDeActiveStream)				(MHandle); \
	MRESULT (*fnPlayerPlay)					(MHandle); \
	MRESULT (*fnPlayerPause)				(MHandle); \
	MRESULT (*fnPlayerStop)					(MHandle); \
	MRESULT (*fnPlayerSeekTo)				(MHandle, MDWord); \
	MRESULT (*fnPlayerSyncSeekTo)			(MHandle, MDWord); \
	MRESULT (*fnPlayerSetMode)				(MHandle, MDWord); \
	MRESULT (*fnPlayerSetVolume)			(MHandle, MDWord); \
	MRESULT	(*fnPlayerDisableTrack)			(MHandle, MDWord, MBool); \
	MRESULT (*fnPlayerGetCurFrame)			(MHandle, MBITMAP*); \
	MRESULT (*fnPlayerGetCurEffectFrame)	(MHandle, MDWord, MHandle, MBITMAP*); \
	MRESULT (*fnPlayerDisableDisplay)		(MHandle, MBool); \
	MRESULT (*fnPlayerAudioRestart)			(MHandle); \
	MRESULT (*fnPlayerIsSeekable)			(MHandle, MDWord, MBool*); \
	MRESULT (*fnPlayerGetFramePosition)		(MHandle, MDWord, MDWord, MDWord*); \
	MRESULT (*fnPlayerRefreshStream)		(MHandle, MHandle, MDWord, MHandle); \
	MRESULT (*fnPlayerGetViewport)			(MHandle, MRECT*); \
	MRESULT (*fnPlayerLockStuffUnderEffect) 		(MHandle, MHandle); \
	MRESULT (*fnPlayerUnlockStuffUnderEffect) 	(MHandle, MHandle); \
	MRESULT (*fnPlayerPerformOperation)		(MHandle, MDWord, MVoid*); \
	MRESULT (*fnPlayerGetCurClipOriFrame)	(MHandle, MHandle, MBITMAP*);
MINF(MAMVEPlayerSession)
{
	MINH_MAMVEPLAYER();
};

//define the structure for storyboard session.
#define MINH_MAMVESTORYBOARD() \
	MINH_MAMVEBase(); \
	MRESULT (*fnStoryboardGetDuration)		    (MHandle, MDWord*); \
	MRESULT (*fnStoryboardGetClipCount)			(MHandle, MDWord*); \
	MRESULT (*fnStoryboardInsertClip)			(MHandle, MHandle, MDWord); \
	MRESULT (*fnStoryboardRemoveClip)			(MHandle, MHandle); \
	MRESULT (*fnStoryboardRemoveAllClip)		(MHandle); \
	MRESULT (*fnStoryboardMoveClip)			    (MHandle, MHandle, MDWord); \
	MRESULT (*fnStoryboardGetClip)			    (MHandle, MDWord, MHandle*); \
	MRESULT (*fnStoryboardGetClipByUuid)		(MHandle, MTChar*, MHandle*); \
	MRESULT (*fnStoryboardGetCurClipIndex)		(MHandle, MDWord*); \
	MRESULT (*fnStoryboardSetCurClipIndex)		(MHandle, MDWord); \
    MRESULT (*fnStoryboardGetData)              (MHandle, MHandle*); \
	MRESULT (*fnStoryboardLoadProject)          (MHandle, MVoid*, AMVE_FNSTATUSCALLBACK, MVoid*); \
    MRESULT (*fnStoryboardSaveProject)          (MHandle, MVoid*, AMVE_FNSTATUSCALLBACK, MVoid*); \
	MRESULT	(*fnStoryboardCancelProject)		(MHandle); \
	MRESULT (*fnStoryboardFlushCache)			(MHandle); \
	MRESULT (*fnStoryboardApplyTheme)           (MHandle, MVoid*, AMVE_FNSTATUSCALLBACK, MVoid*); \
	MRESULT (*fnStoryboardGetClipPositionByTime)	(MHandle, MDWord, QVET_CLIP_POSITION*); \
	MRESULT (*fnStoryboardGetClipPositionArrayByTime)	(MHandle, MDWord, QVET_CLIP_POSITION*, MDWord, MDWord*); \
	MRESULT (*fnStoryboardGetClipPositionByIndex)	(MHandle, MDWord, QVET_CLIP_POSITION*); \
	MRESULT (*fnStoryboardGetTimeByClipPosition)	(MHandle, QVET_CLIP_POSITION*, MDWord*); \
	MRESULT (*fnStoryboardGetClipIndexByClipPosition) (MHandle, QVET_CLIP_POSITION*, MLong*); \
	MRESULT (*fnStoryboardApplyTrim)			(MHandle); \
	MRESULT (*fnStoryboardConvertRangeOriginalToDst)  (MHandle, AMVE_POSITION_RANGE_TYPE*, AMVE_POSITION_RANGE_TYPE*); \
	MRESULT (*fnStoryboardGetTransitionTimeRange)  (MHandle, MDWord, AMVE_POSITION_RANGE_TYPE*); \
	MRESULT (*fnStoryboardGetClipTimeRange) (MHandle, MDWord, AMVE_POSITION_RANGE_TYPE*); \
	MRESULT (*fnStoryboardSetLyricThemeAVParam) (MHandle ,MVoid * ); \
	MRESULT (*fnStoryboardSetLyricThemeClipTransLation) (MHandle hSession, MInt64 nThemeTempletID); \
	MRESULT (*fnStoryboardLoadProjectData)          (MHandle, MVoid*, AMVE_FNSTATUSCALLBACK, MVoid*); \
    MRESULT (*fnStoryboardFetchProjectData)          (MHandle, AMVE_STORYBOARD_PROJECT_DATA*); \
    MRESULT (*fnStoryboardGetTransitionInfo)  (MHandle, MDWord, AMVE_TRANSITION_TYPE*); \
    MDWord (*fnStoryboardGetProjectEngineVersion)  (MHandle, MChar*);
	
MINF(MAMVEStoryboardSession)
{
	MINH_MAMVESTORYBOARD();
};

//SlideShow session vfptr
//define the structure for SlideShow session.
#define MINH_MAMVESLIDESHOW() \
	MINH_MAMVEBase(); \
	MRESULT (*fnSlideShowInsertSource)       (MHandle, QVET_SLSH_SOURCE_INFO_NODE*); \
	MRESULT (*fnSlideShowRemoveSource)		(MHandle, MDWord); \
	MRESULT (*fnSlideShowGetSourceCount)     (MHandle, MDWord*); \
	MRESULT (*fnSlideShowGetSource)			(MHandle, MDWord, QVET_SLSH_SOURCE_INFO_NODE*); \
	MRESULT (*fnSlideShowSetMusic)			(MHandle, MVoid*, AMVE_POSITION_RANGE_TYPE*); \
	MRESULT (*fnSlideShowGetMusic)			(MHandle, MVoid*, MDWord*, AMVE_POSITION_RANGE_TYPE*); \
	MRESULT (*fnSlideShowSetTheme)			(MHandle, MInt64); \
	MRESULT (*fnSlideShowGetTheme)			(MHandle, MInt64*); \
	MRESULT (*fnSlideShowMakeStoryboard)	(MHandle, AMVE_FNSTATUSCALLBACK, MVoid*,MSIZE*); \
	MRESULT (*fnSlideShowReMakeStoryboard)  (MHandle); \
	MRESULT (*fnSlideShowCancleMakeStoryboard) (MHandle); \
	MRESULT (*fnSlideShowGetStoryboard)     (MHandle, MHandle*); \
	MRESULT (*fnSlideShowLoadProject)       (MHandle, MVoid*, AMVE_FNSTATUSCALLBACK, MVoid*); \
    MRESULT (*fnSlideShowSaveProject)       (MHandle, MVoid*, AMVE_FNSTATUSCALLBACK, MVoid*); \
    MRESULT (*fnSlideShowSetMute)           (MHandle,MBool); \
    MBool   (*fnSlideShowGetMute)           (MHandle); \
    MRESULT (*fnSlideShowGetDefaultMusic)   (MHandle,MVoid*, MDWord*); \
    MRESULT (*fnSlideShowDetectFace)        (MHandle,QVET_SLSH_SOURCE_INFO_NODE*); \
    MRESULT (*fnSlideShowGetVirtualSrcInfoNodeList) (MHandle,QVET_SLSH_VIRTUAL_SOURCE_INFO_NODE**,MDWord*); \
    MRESULT (*fnSlideShowUpdateVirtualSrcFaceCenter) (MHandle,MDWord,MPOINT*); \
    MRESULT (*fnSlideShowDuplicateStoryboard) (MHandle,MHandle*); \
    MRESULT (*fnSlideShowSetVirtualSrcTrimRange) (MHandle,MDWord,AMVE_POSITION_RANGE_TYPE*,MBool); \
    MRESULT (*fnSlideShowUpdateVirtualSource) (MHandle,MDWord,QVET_SLSH_SOURCE_INFO_NODE*); \
    MBool   (*fnSlideShowCanInsertVideoSource) (MHandle,MDWord); \
    MRESULT (*fnSlideShowRefreshSourceList) (MHandle); \
    MRESULT (*fnSlideShowSetVirtualSourceTransformPara) (MHandle,MDWord,QVET_TRANSFORM_PARAMETERS*); \
    MRESULT (*fnSlideShowSetVirtualSourceTransformFlag) (MHandle,MDWord,MBool); \
    MRESULT (*fnSlideShowClearOrgSourceInfoList) (MHandle); \
    MRESULT (*fnSlideShowGetOrgSourceCount) (MHandle,MDWord*); \
    MRESULT (*fnSlideShowGetOrgSource) (MHandle,MDWord,QVET_SLSH_SOURCE_INFO_NODE*); \
    MFloat  (*fnSlideShowGetOrgVirtualNodeScaleValue) (MHandle,MDWord); \
	MRESULT	(*fnSlideShowMoveVirtualSource) (MHandle,MDWord, MDWord);
    


MINF(MAMVESlideShowSession)
{
	MINH_MAMVESLIDESHOW();
};

//define the structure for producer session.
#define MINH_MAMVEPRODUCER() \
	MINH_MAMVEBase(); \
    MRESULT (*fnActiveStream)			(MHandle, MHandle); \
    MRESULT (*fnDeActiveStream)		(MHandle); \
	MRESULT (*fnProducerStart)		(MHandle); \
	MRESULT (*fnProducerPause)		(MHandle); \
	MRESULT (*fnProducerResume)		(MHandle); \
	MRESULT (*fnProducerStop)		(MHandle); \
	MRESULT (*fnProducerCancel)		(MHandle); \
	MRESULT (*fnProducerSetCpuOverloadLevel)	(MHandle, MDWord); \
	MRESULT (*fnProducerSetThreadPriority) 		(MHandle, MLong)

MINF(MAMVEProducerSession)
{
	MINH_MAMVEPRODUCER();
};

#define MINH_MAMVEAUDIOPROVIDER() \
	MINH_MAMVEBase(); \
	MRESULT (*fnActiveStream)			(MHandle, MHandle); \
    MRESULT (*fnDeActiveStream)		    (MHandle); \
    MRESULT (*fnAudioProviderStart)     (MHandle); \
    MRESULT (*fnAudioProviderPause)		(MHandle); \
	MRESULT (*fnAudioProviderResume)	(MHandle); \
    MRESULT (*fnAudioProviderStop)      (MHandle); \
    MRESULT (*fnAudioProviderCancel)	(MHandle); 

MINF(MAMVEAudioProviderSession)
{
    MINH_MAMVEAUDIOPROVIDER();
};

#ifdef __cplusplus
}
#endif

#endif //_AMVE_BASE_H_
