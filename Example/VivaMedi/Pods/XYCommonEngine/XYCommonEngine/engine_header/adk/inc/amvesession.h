
/*
* File Name:	amvesession.h					
*
*/

#ifndef _AMVE_SESSION_H_
#define _AMVE_SESSION_H_

#include "amvedef.h"
#include "amvebase.h"

#ifdef __cplusplus
extern "C"
{
#endif

//utility functions
//interface to check if file is editable or not


MRESULT QVET_GetWMTagFromFile(MTChar *videoFile, MTChar *tag, MDWord bufLen);

MDWord QVET_GetEngineVersion();

MRESULT QVET_GetTRCLyricsInfo(MTChar *pszTRC, QVET_TRCFILE_DECRYPTOR *pTRCDec, QVET_TRC_LYRICS_INFO* pInfo/*out*/);

MRESULT	AMVE_IsFileEditable(
							  MHandle hSessionContext,
							  MVoid *szURL,
							  MDWord dwFlag,
							  MBool *pbEditable, 
							  MDWord *pUnsupportType);

//interface to get information of input video
MRESULT AMVE_GetVideoInfo(
							MHandle					hSessionContext,
							MVoid					*szSrcVideo,
							AMVE_VIDEO_INFO_TYPE	*pVideoInfo);

MRESULT AMVE_GetVideoInfoEx(
							MHandle					hSessionContext,
							MVoid					*szSrcVideo,
							AMVE_VIDEO_INFO_TYPE	*pVideoInfo,
							AMVE_SOURCE_EXT_INFO	*pExtInfo);

MRESULT AMVE_GetSourceExtInfo(MTChar *pszFile, 
						MHandle hSessionCtx, 
						AMVE_SOURCE_EXT_INFO* pExtInfo);
//for svg
//interface to generate svg file
MRESULT AMVE_GenerateSVGFile(MVoid	*pszSVGFile,
							 	AMVE_BUBBLETEXT_INFO_TYPE	*pBubbleInfo,
							 	MSIZE *pPosInfoArray/*in,out*/, 
							 	MDWord dwArrayCount/*in*/);

//AMVE_GenerateSVGFileEx is used for bubble template, the template file name is stored in pBubbleInfo
//dwLayoutMode: QVTP_LAYOUT_MODE_XXXXX
MRESULT AMVE_GenerateSVGFileFromTemplate(MDWord dwLayoutMode, MVoid * pszSVGFile, 
											AMVE_BUBBLETEXT_INFO_TYPE *pBubbleInfo, MDWord *pdwTxtLine/*out*/,
											MSIZE *pPosInfoArray/*in,out*/, MDWord dwArrayCount/*in*/);

MRESULT AMVE_GetSVGOriginalSize(MTChar *pszSVG, MSIZE *pSize);

//interface to get data of svg file
MRESULT AMVE_GetSVGThumbnail(
							 MHandle						hSessionContext,
							 MBITMAP						*pSVGBitmap,
							 AMVE_BUBBLETEXT_SOURCE_TYPE	*pBubbleSource,
							 MDWord							dwContentWidth, 
							 MDWord							dwContentHeight);

MRESULT AMVE_GetBubbleThumbnailByTemplate(MHandle hSessionCtx, 
												MBITMAP *pBmp, 
												AMVE_BUBBLETEXT_SOURCE_TYPE* pBubbleSrc,
												MSIZE *pBGSize, //bg video frame size
												MSIZE *pContentSize, //bubble content size
												MDWord dwTimeStamp); 
#if WIN32
		
MRESULT AMVE_EffectThumbnailMgrCreate(MHandle *phThumbnailMgr,
											MHandle hSessionCtx, 
											MSIZE *pBGSize,
											MHandle hDc);
#else
MRESULT AMVE_EffectThumbnailMgrCreate(MHandle *phThumbnailMgr,
	MHandle hSessionCtx,
	MSIZE *pBGSize);
#endif

MRESULT AMVE_EffectGetThumbnail(MHandle hThumbnailMgr,
							MInt64 llTemplateID,
							MBITMAP *pBmp, MDWord dwTimeStamp);


MRESULT AMVE_GetTextThumbnail(MHandle hThumbnailMgr,
											AMVE_BUBBLETEXT_SOURCE_TYPE* pBubbleSrc,
											MDWord  dwTextCount,
											MBITMAP *pBmp,
											MSIZE contextSize, 
											MDWord dwTimeStamp);


MRESULT AMVE_EffectThumbnailMgrDestroy(MHandle hThumbnailMgr);

//interface to estimate the end time of generated file according to input parameters
MRESULT AMVE_GetProducerEndTime(
								MVoid					*pszSrcVideo, 
								MDWord					dwStartTime, 
								MDWord					dwMaxSize, 
								AMVE_VIDEO_INFO_TYPE	*pProperty, 
								MDWord					*pdwEndTime);

MRESULT AMVE_GetThemeCover(
                                MHandle                     hSessionContext,
                                MVoid                       *pTemplate,
                                MDWord                      dwSourceCount,
                                AMVE_MEDIA_SOURCE_TYPE      *pSourceList,
                                MDWord                      dwWidth, 
                                MDWord                      dwHeight, 
                                MVoid                       *pCoverFile);


MRESULT AMVE_SetEnableHWDecoderPool(
							MHandle					hSessionContext,
							MBool					bEnable);

MRESULT AMVE_ReleaseAllHWDecoder(MHandle hSessionContext);

MRESULT AMVE_GetVHWDecoderCount(MHandle hSessionContext,MLong* plCount);

MRESULT AMVE_GetHWCodecCap(MTChar* pszXMLFile, MDWord* pdwMAXHWDecCount,MBool* pbEncSupported,
	                                 MDWord* pdwVImportFormat,MBool* bBetaTestedFlag,MTChar* pszGPURender);


MRESULT AMVE_GetAnimatedFrameInfo(MHandle hSessionCtx, MTChar* szFrameFile, MSIZE* pBGSize, QVET_ANIMATED_FRAME_TEMPLATE_INFO* pInfo);

MRESULT AMVE_GetAnimatedFrameBitmap(MHandle hSessionCtx, MTChar* szFrameFile, MDWord dwPos, MBITMAP* pBitmap);

MRESULT AMVE_GetAnimatePointSettings(MHandle hEffect,MSIZE* pBGSize,MVoid** ppSettings);

MRESULT AMVE_GetPasterFacialInfo(MHandle hSessionCtx, MTChar* szFrameFile,AMVE_PASTER_FACIAL_INFO* pFacialInfo);
MRESULT QVET_GetTemplateParamData(MHandle hSessionCtx, MTChar* szTemplateFile, MLong lCfgIndex, MSIZE* pResolution, AMVE_USER_DATA_TYPE* pTPMData);

MVoid	QVET_PrintWin32DebugLog(MTChar *format, ...);
//macro for session register
#define MVE_REGISTER_PLAYER() \
	AMCM_RegisterEx(__hCMgr, AMVE_PLAYER, 0, 0, 0, AMVE_CreatePlayerSession)

#define MVE_REGISTER_STORYBOARD() \
	AMCM_RegisterEx(__hCMgr, AMVE_STORYBOARD, 0, 0, 0, AMVE_CreateStoryboardSession)	

#define MVE_REGISTER_SLIDESHOW() \
	AMCM_RegisterEx(__hCMgr, AMVE_SLIDESHOW, 0, 0, 0, AMVE_CreateSlideShowSession)

#define MVE_REGISTER_PRODUCER() \
	AMCM_RegisterEx(__hCMgr, AMVE_PRODUCER, 0, 0, 0, AMVE_CreateProducerSession)


#define MVE_REGISTER_AUDIOPROVIDER() \
	AMCM_RegisterEx(__hCMgr,AMVE_AUDIOPROVIDER,0,0,0,AMVE_CreateAudioProviderSession)

//The interfaces for session context
MRESULT AMVE_SessionContextCreate(MHandle hCMgr, MHandle* phContext);

MRESULT AMVE_SessionContextDestroy(MHandle hContext);

MRESULT AMVE_SessionContextSetProp(MHandle hContext, MDWord dwPropId, MVoid* pData, MDWord dwSize);

MRESULT AMVE_SessionContextGetProp(MHandle hContext, MDWord dwPropId, MVoid* pData, MDWord* pdwSize);

//The interfaces for clip
MRESULT AMVE_ClipCreate(MHandle hSessionContext, AMVE_MEDIA_SOURCE_TYPE* pSource, MHandle* phClip); 

MRESULT AMVE_ClipCreateWithInfo(MHandle hSessionContext, AMVE_MEDIA_SOURCE_TYPE* pSource, MDWord dwClipType,
								AMVE_VIDEO_INFO_TYPE *pVideoInfo, AMVE_SOURCE_EXT_INFO *pExtInfo, MHandle* phClip);

MRESULT AMVE_ClipReplaceSource(AMVE_MEDIA_SOURCE_TYPE* pSource, MHandle hClip, AMVE_POSITION_RANGE_TYPE stSrcRange,AMVE_POSITION_RANGE_TYPE stTrimRange);

MRESULT AMVE_ClipDestroy(MHandle hClip); 

MRESULT	AMVE_ClipSetProp(MHandle hClip, MDWord dwPropId, MVoid* pData, MDWord dwSize); 

MRESULT	AMVE_ClipGetProp(MHandle hClip, MDWord dwPropId, MVoid* pData, MDWord* pdwSize);

#ifdef WIN32
MRESULT AMVE_ClipThumbnailMgrCreate(MHandle hDC, MHandle hClip, MDWord dwStreamWidth, MDWord dwStreamHeight, MDWord dwResizeMode, MBool bOnlyOriginalClip, MHandle *phThumbnailMgr/*in, out*/);

MRESULT AMVE_ClipPrimalThumbnailMgrCreate(MHandle hDC, MHandle hClip, MDWord dwStreamWidth, MDWord dwStreamHeight, MDWord dwResizeMode, MBool bOnlyOriginalClip, MHandle *phThumbnailMgr/*in, out*/);
#else
MRESULT AMVE_ClipThumbnailMgrCreate(MHandle hClip, MDWord dwStreamWidth, MDWord dwStreamHeight, MDWord dwResizeMode, MBool bOnlyOriginalClip, MHandle *phThumbnailMgr/*in, out*/);

MRESULT AMVE_ClipPrimalThumbnailMgrCreate(MHandle hClip, MDWord dwStreamWidth, MDWord dwStreamHeight, MDWord dwResizeMode, MBool bOnlyOriginalClip, MHandle *phThumbnailMgr/*in, out*/);

#endif
MRESULT AMVE_ClipThumbnailMgrDestroy(MHandle hThumbnailMgr);

MRESULT AMVE_ClipGetThumbnail(MHandle hThumbnailMgr, MBITMAP* pBitmap/*in, out*/, MDWord dwPosition, MBool bSkipBlackFrame);

MRESULT AMVE_ClipGetOriThumbnail(MHandle hThumbnailMgr, MBITMAP* pBitmap/*in, out*/, MDWord dwPosition, MBool bSkipBlackFrame);

MRESULT AMVE_ClipGetKeyframe(MHandle hThumbnailMgr, MBITMAP* pBitmap/*in, out*/, MDWord dwPosition, MBool bSkipBlackFrame, MDWord dwDecoderUsageType);

/*
* 功能：
*    从thumbnail manager获取关键帧位置,必须在调用过AMVE_ClipThumbnailMgrCreate or AMVE_ClipPrimalThumbnailMgrCreate
*    以及AMVE_ClipGetThumbnail or AMVE_ClipGetKeyframe后才能调用
* 参数：
*    In hThumbnailMgr: thumbnail manager句柄
*    In/Out: pdwPosition,输入当前的时间点，输出关键帧位置
*    In: bNext 为MTrue表示取下一个关键帧位置，为MFalse表示取前一个关键帧位置
*        如果当前position是关键帧位置，bNext==MTrue会返回当前position,bNext=MFales会返回前一个关键帧时间
* 返回值:
*    成功返回QVET_ERR_NONE,否则返回错误码
*/
MRESULT AMVE_ClipGetKeyFramePositionFromThumbnailMgr(MHandle hThumbnailMgr,MDWord* pdwPosition,MBool bNext);

MRESULT AMVE_ClipExtractThumbnail(MHandle hThumbnailMgr, MBITMAP* pBitmap);

MRESULT AMVE_ClipFreeThumbnail(MBITMAP* pBitmap);

MRESULT AMVE_ExtractAudioSample(MHandle hClip, 
								MDWord dwPosition,
								MDWord dwMilliseconds,
						        MByte  *pLeftSampleBuf,
						        MDWord *pdwLeftBufLen,/*in, out*/
						        MByte  *pRightSampleBuf,
						        MDWord *pdwRightBufLen,/*in, out*/
						        MDWord *pdwSampleCount/*in, out*/);

MRESULT AMVE_ClipEffectCreate(MHandle hSessionContext, MDWord dwEffectTrackType, MDWord dwGroupID, MFloat fLayerID, MDWord dwEffectType, MHandle* phEffect);

MRESULT AMVE_ClipInsertEffect(MHandle hClip, MHandle hEffect);

MRESULT AMVE_ClipRemoveEffect(MHandle hClip, MHandle hEffect);

MRESULT AMVE_ClipDestroyEffect(MHandle hEffect);

MRESULT AMVE_ClipGetEffectCount(MHandle hClip, MDWord dwEffectTrackType, MDWord dwGroupID, MDWord* pdwCount);

MRESULT AMVE_ClipGetEffect(MHandle hClip, MDWord dwEffectTrackType, MDWord dwGroupID, MDWord dwIndex, MHandle* phEffect);

MRESULT AMVE_ClipGetEffectByUuid(MHandle hClip, MTChar *pszUuid, MHandle *phEffect);

MRESULT AMVE_ClipMoveEffect(MHandle hClip, MHandle hEffect, MDWord dwIndex);

MRESULT AMVE_ClipDuplicate(MHandle hSrcClip, MHandle* phDstClip);

//The interfaces for scene's clip
MRESULT AMVE_ClipCreateWithScene(MHandle hSessionContext, MInt64 llTemplateID, MSIZE* pResolution, MHandle* phClip);

MRESULT AMVE_ClipGetSceneElementCount(MHandle hClip, MDWord* pdwCount);

MRESULT AMVE_ClipGetSceneElementRegion(MHandle hClip, MDWord dwElemIndex, MRECT* prcRegion);

MRESULT AMVE_ClipGetSceneElementFocusImageID(MHandle hClip, MDWord dwElemIndex, MDWord* pdwImageID);

MRESULT AMVE_ClipGetSceneTemplate(MHandle hClip, MInt64* pllTemplateID);

MRESULT AMVE_ClipSetSceneTemplate(MHandle hClip, MInt64 llTemplateID, MSIZE* pResolution);

MRESULT AMVE_ClipGetSceneElementSource(MHandle hClip, MDWord dwElemIndex, MHandle* phStoryboardSession);

MRESULT AMVE_ClipSetSceneElementSource(MHandle hClip, MDWord dwElemIndex, MHandle hStoryboardSession);

MRESULT AMVE_ClipSwapSceneElementSource(MHandle hClip, MDWord dwElemIndex1, MDWord dwElemIndex2);

MRESULT AMVE_ClipGetSceneElementIndexByPoint(MHandle hClip, MPOINT* pPoint, MLong* plIndex);

MRESULT AMVE_ClipGetSceneElementTipsLocation(MHandle hClip, MDWord dwElemIndex, MPOINT* pPoint);

MRESULT AMVE_ClipGetSceneElementSourceAlignment(MHandle hClip, MDWord dwElemIndex, MDWord* pdwAlignment);

MRESULT AMVE_ClipSetSceneExternalSource(MHandle hClip, MDWord dwIndex, QVET_EFFECT_EXTERNAL_SOURCE* pExtSrc);

MRESULT AMVE_ClipGetSceneExternalSource(MHandle hClip, MDWord dwIndex, QVET_EFFECT_EXTERNAL_SOURCE* pExtSrc);

//The interfaces for cover
MRESULT AMVE_CoverGetTitleCount(MHandle hCover, MDWord* pdwCount);

MRESULT AMVE_CoverGetTitleDefaultInfo(MHandle hCover, MDWord dwIndex, MDWord dwLanguageID, QVET_COVER_TITLE_INFO* pInfo);

MRESULT AMVE_CoverGetTitle(MHandle hClip, MDWord dwIndex, AMVE_BUBBLETEXT_SOURCE_TYPE *pTextSource);

MRESULT AMVE_CoverSetTitle(MHandle hClip, MDWord dwIndex, AMVE_BUBBLETEXT_SOURCE_TYPE *pTextSource);

MRESULT AMVE_CoverGetTitleUserData(MHandle hCover, MDWord dwIndex, AMVE_USER_DATA_TYPE* pUserData);

MRESULT AMVE_CoverSetTitleUserData(MHandle hCover, MDWord dwIndex, AMVE_USER_DATA_TYPE* pUserData);

MRESULT AMVE_CoverGetTitleLayerID(MHandle hCover, MDWord dwIndex, MFloat* pfLayerID);

MRESULT AMVE_CoverGetTitleEffect(MHandle hCover, MDWord dwIndex, MHandle* phEffect);
    
//The interfaces for effect
MRESULT AMVE_EffectSetProp(MHandle hEffect, MDWord dwPropId, MVoid* pData, MDWord dwSize);

MRESULT AMVE_EffectGetProp(MHandle hEffect, MDWord dwPropId, MVoid* pData, MDWord* pdwSize);

MRESULT AMVE_EffectDuplicate(MHandle hEffect, MHandle* pEffect);


MRESULT AMVE_EffectGetRegionInfo(MHandle hEffect, MDWord dwTimeStamp, QVET_EFFECT_DISPLAY_INFO* pInfo);

MRESULT AMVE_EffectSetExternalSource(MHandle hEffect, MDWord dwIndex, QVET_EFFECT_EXTERNAL_SOURCE* pExtSrc);

MRESULT AMVE_EffectGetExternalSource(MHandle hEffect, MDWord dwIndex, QVET_EFFECT_EXTERNAL_SOURCE* pExtSrc);


/*
 * 轨迹新需求：以list方式实现，每个元素都是QVET_TRAJECTORY_DATA
 */
#define AMVE_EFFECT_TRAJECTORY_IDX_HEAD        	(0)
#define AMVE_EFFECT_TRAJECTORY_IDX_TAIL        	(-1)
MDWord AMVE_EffectGetTrajectoryCount(MHandle hEffect);
MRESULT AMVE_EffectGetTrajectory(MHandle hEffect, MDWord trIdx, QVET_TRAJECTORY_DATA **trData);
MRESULT AMVE_EffectInsertNewTrajectory(MHandle hEffect, MDWord trIdx, QVET_TRAJECTORY_DATA *trData);
MRESULT AMVE_EffectUpdateTrajectory(MHandle hEffect, MDWord trIdx, QVET_TRAJECTORY_DATA *trData);
MRESULT AMVE_EffectRemoveTrajectory(MHandle hEffect, MDWord trIdx);
MRESULT AMVE_EffectRemoveAllTrajectory(MHandle hEffect);

MRESULT AMVE_EffectGetKeyFrameTransformValue(MHandle hEffect, MDWord dwTimestamp, QVET_KEYFRAME_TRANSFORM_VALUE* pValue);
MRESULT AMVE_EffectGetKeyFrameTransformPosValue(MHandle hEffect, MDWord dwTimestamp, QVET_KEYFRAME_TRANSFORM_POS_VALUE* pValue);
MRESULT AMVE_EffectGetKeyFrameTransformRotationValue(MHandle hEffect, MDWord dwTimestamp, QVET_KEYFRAME_TRANSFORM_ROTATION_VALUE* pValue);
MRESULT AMVE_EffectGetKeyFrameTransformScaleValue(MHandle hEffect, MDWord dwTimestamp, QVET_KEYFRAME_TRANSFORM_SCALE_VALUE* pValue);

MRESULT AMVE_EffectGetKeyFrameMaskValue(MHandle hEffect, MDWord dwTimestamp, QVET_KEYFRAME_MASK_VALUE* pValue);
MRESULT AMVE_EffectGetKeyFrameLevelValue(MHandle hEffect, MDWord dwTimestamp, QVET_KEYFRAME_FLOAT_VALUE* pValue);
MRESULT AMVE_EffectGetKeyFrameUniformValue(MHandle hEffect, MDWord dwTimestamp, MTChar* pUniform, QVET_KEYFRAME_UNIFORM_VALUE* pValue);
MRESULT AMVE_EffectGetKeyFrameColorCurveValue(MHandle hEffect, MDWord dwTimestamp, QVET_COLOR_CURVE_OUT_VALUE* pValue);



MRESULT AMVE_EffectGetCurrentValueForKeyFrameTransform(const QVET_KEYFRAME_TRANSFORM_DATA* pData, MDWord dwTimestamp, QVET_KEYFRAME_TRANSFORM_VALUE* pValue);
MRESULT AMVE_EffectGetCurrentValueForKeyFrameTransformPos(const QVET_KEYFRAME_TRANSFORM_POS_DATA* pData, MDWord dwTimestamp, QVET_KEYFRAME_TRANSFORM_POS_VALUE* pValue);

MRESULT AMVE_EffectGetTemplateIdArray(MHandle hEffect, QVET_TEMPLATE_ID_ARRAY *pValue);

MRESULT AMVE_EffectSetTemplateIdArray(MHandle hEffect, QVET_TEMPLATE_ID_ARRAY *pValue);


//The interfaces for stream
MRESULT AMVE_StreamOpen(AMVE_STREAM_SOURCE_TYPE* pSource, AMVE_STREAM_PARAM_TYPE* pParam, MHandle *phStream);

MRESULT AMVE_StreamClose(MHandle hStream); 

MVoid AMVE_StreamSetBGColor(MHandle hStream, MDWord clrBG);

MDWord AMVE_StreamGetBGColor(MHandle hStream);

MRESULT AMVE_StreamSetAlkFilePath(MHandle hStream,MTChar* pszAlkFilePath);

MRESULT AMVE_RegisterHWDecQueryCallBack(MHandle hSessionContext);

MDWord AMVE_GetProjectVersion(MTChar* pszFilePath);



MRESULT AMVE_GetTextAnimationThumbnail(MHandle hSessionContext,AMVE_TEXTANIMATION_SOURCE_TYPE* pTASource,MSIZE* pBGSize,MBITMAP* pBmp);

/*
    pBMP 输入的bitmap,颜色空间是rgba
    pdwColor 输出的背景颜色，颜色空间是rgba
    pdwPos 输出的颜色坐标点，长度是2的MDWord数组
	pColorType 输出的色相信息
return : 纯色返回MTrue,非纯色返回MFalse
*/
MBool AMVE_IsPureBG(MBITMAP* pBMP, MDWord* pdwColor, MPOINT* pdwPos, MInt8* pColorType);

/**************************************************************************/
#define CALL_AMVE_FUNC(h, IName, fnFunc) \
			(MNull == (h)) ? QVET_ERR_COMMON_CALLFN_INVALID_PARAM : GET_VFPTR((h), IName)->fnFunc

//The interfaces for base session.
#define AMVES_SessionInit(hSession, pInitParam) \
			(CALL_AMVE_FUNC(hSession, MBase, fnInit)(hSession, pInitParam))

#define AMVES_SessionDestroy(hSession) \
			(CALL_AMVE_FUNC(hSession, MBase, fnDestroy)(hSession))

#define AMVES_SessionGetTypeID(hSession, pID) \
			(CALL_AMVE_FUNC(hSession, MBase, fnGetTypeID)(hSession, pID))

#define AMVES_SessionGetVersionInfo(hSession, pdwRelease, pdwMajor, pdwMinor, pszVersion, dwVersionLen) \
			(CALL_AMVE_FUNC(hSession, MBase, fnGetVersionInfo)(hSession, pdwRelease, pdwMajor, pdwMinor, pszVersion, dwVersionLen))

//The interfaces for AMVE base session
#define AMVES_SessionReset(hSession) \
			(CALL_AMVE_FUNC(hSession, MAMVEBaseSession, fnReset)(hSession))

#define AMVES_SessionSetDisplayContext(hSession, lpDisplayContext) \
			(CALL_AMVE_FUNC(hSession, MAMVEBaseSession, fnSetDisplayContext)(hSession, lpDisplayContext))

#define AMVES_SessionGetDisplayContext(hSession, lpDisplayContext) \
			(CALL_AMVE_FUNC(hSession, MAMVEBaseSession, fnGetDisplayContext)(hSession, lpDisplayContext))

#define AMVES_SessionDisplayRefresh(hSession) \
			(CALL_AMVE_FUNC(hSession, MAMVEBaseSession, fnDisplayRefresh)(hSession))

#define AMVES_SessionGetState(hSession, pParam) \
			(CALL_AMVE_FUNC(hSession, MAMVEBaseSession, fnGetState)(hSession, pParam))

#define AMVES_SessionSetProp(hSession, dwPropId, pData, lDataSize) \
			(CALL_AMVE_FUNC(hSession, MAMVEBaseSession, fnSetProp)(hSession, dwPropId, pData, lDataSize))

#define AMVES_SessionGetProp(hSession, dwPropId, pData, plDataSize) \
			(CALL_AMVE_FUNC(hSession, MAMVEBaseSession, fnGetProp)(hSession, dwPropId, pData, plDataSize))

//The interfaces for player session
#define AMVES_PlayerActiveStream(hSession, hStream,dwPos,bSyncSeek) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnActiveStream)(hSession, hStream,dwPos,bSyncSeek))

#define AMVES_PlayerDeActiveStream(hSession) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnDeActiveStream)(hSession))

#define AMVES_PlayerPlay(hSession) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerPlay)(hSession))

#define AMVES_PlayerPause(hSession) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerPause)(hSession))

#define AMVES_PlayerStop(hSession) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerStop)(hSession))

#define AMVES_PlayerSeekTo(hSession, dwPos) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerSeekTo)(hSession, dwPos))

#define AMVES_PlayerSyncSeekTo(hSession, dwPos) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerSyncSeekTo)(hSession, dwPos))

#define AMVES_PlayerSetMode(hSession, dwMode) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerSetMode)(hSession, dwMode))

#define AMVES_PlayerSetVolume(hSession, dwValue) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerSetVolume)(hSession, dwValue))

#define AMVES_PlayerDisableTrack(hSession, dwTrackType, bDisabled) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerDisableTrack)(hSession, dwTrackType, bDisabled))

#define AMVES_PlayerGetCurFrame(hSession, pBitmap) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerGetCurFrame)(hSession, pBitmap))

#define AMVES_PlayerGetCurEffectFrame(hSession, dwTimeStamp, hEffect,pBitmap) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerGetCurEffectFrame)(hSession, dwTimeStamp, hEffect, pBitmap))

#define AMVES_PlayerGetCurClipOriFrame(hSession, hClip,pBitmap) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerGetCurClipOriFrame)(hSession, hClip, pBitmap))
			
#define AMVES_PlayerDisableDisplay(hSession, bDisabled) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerDisableDisplay)(hSession, bDisabled))

#define AMVES_PlayerAudioRestart(hSession) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerAudioRestart)(hSession))

#define AMVES_PlayerIsSeekable(hSession, dwPos, pbIsSeekable) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerIsSeekable)(hSession, dwPos, pbIsSeekable))

#define AMVES_PlayerRefreshStream(hSession, hClip, dwOpCode, hEffect) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerRefreshStream)(hSession, hClip, dwOpCode, hEffect))

#define AMVES_PlayerGetViewport(hSession, prcViewport) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerGetViewport)(hSession, prcViewport))



//effect lock之后，更新hEffect2Lock以及layerID 比 hEffect2Lock大 effect，再refresh display，会比较高效——针对会频繁修改effect的rect，频繁displayrefresh的case
#define AMVES_PlayerLockStuffUnderEffect(hSession, hEffect2Lock) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerLockStuffUnderEffect)(hSession, hEffect2Lock))

#define AMVES_PlayerUnlockStuffUnderEffect(hSession, hEffect2Lock) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerUnlockStuffUnderEffect)(hSession, hEffect2Lock))


/*
 *	opType:   AMVE_PS_OP_REFRESH_AUDIO
 *
 */
#define AMVES_PlayerPerformOperation(hSession, opType, opParam) \
			(CALL_AMVE_FUNC(hSession, MAMVEPlayerSession, fnPlayerPerformOperation)(hSession, opType, opParam))








//The interfaces for storyboard session
#define AMVES_StoryboardGetDuration(hSession, pdwDuration) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetDuration)(hSession, pdwDuration))
		
#define AMVES_StoryboardGetClipCount(hSession, pdwCount) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetClipCount)(hSession, pdwCount))

#define AMVES_StoryboardInsertClip(hSession, hClip, dwIndex) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardInsertClip)(hSession, hClip, dwIndex))

#define AMVES_StoryboardRemoveClip(hSession, hClip) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardRemoveClip)(hSession, hClip))

#define AMVES_StoryboardRemoveAllClip(hSession) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardRemoveAllClip)(hSession))

#define AMVES_StoryboardMoveClip(hSession, hClip, dwIndex) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardMoveClip)(hSession, hClip, dwIndex))

#define AMVES_StoryboardGetClip(hSession, dwIndex, phClip) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetClip)(hSession, dwIndex, phClip))

#define AMVES_StoryboardGetClipByUuid(hSession, pszUuid, phClip) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetClipByUuid)(hSession, pszUuid, phClip))

#define AMVES_StoryboardGetDataClip(hSession, phDataClip) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetData)(hSession, phDataClip))

#define AMVES_StoryboardLoadProject(hSession, pProjectFile, fnCallback, pUserData) \
	    (CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardLoadProject)(hSession, pProjectFile, fnCallback, pUserData))

#define AMVES_StoryboardSaveProject(hSession, pProjectFile, fnCallback, pUserData) \
	    (CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardSaveProject)(hSession, pProjectFile, fnCallback, pUserData))

#define AMVES_StoryboardCancelProject(hSession) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardCancelProject)(hSession))

#define AMVES_StoryboardApplyTheme(hSession, pThemeFile, fnCallback, pUserData) \
	    (CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardApplyTheme)(hSession, pThemeFile, fnCallback, pUserData))

#define AMVES_StoryboardGetClipPositionByTime(hSession, dwTime, pClipPosition) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetClipPositionByTime)(hSession, dwTime, pClipPosition))

#define AMVES_StoryboardGetClipPositionArrayByTime(hSession, dwTime, pClipPosition, dwInCount, pdwOutCount) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetClipPositionArrayByTime)(hSession, dwTime, pClipPosition, dwInCount, pdwOutCount))

		
#define AMVES_StoryboardGetClipPositionByIndex(hSession, dwIndex, pClipPosition) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetClipPositionByIndex)(hSession, dwIndex, pClipPosition))


#define AMVES_StoryboardGetTimeByClipPosition(hSession, pClipPosition, pdwTime) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetTimeByClipPosition)(hSession, pClipPosition, pdwTime))

#define AMVES_StoryboardGetClipIndexByClipPosition(hSession, pClipPosition, plIndex) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetClipIndexByClipPosition)(hSession, pClipPosition, plIndex))

#define AMVES_StoryboardApplyTrim(hSession) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardApplyTrim)(hSession))

#define AMVES_StoryboardConvertRangeOriginalToDst(hSession, pOriRange, pDstRange) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardConvertRangeOriginalToDst)(hSession, pOriRange, pDstRange))

#define AMVES_StoryboardGetTranstionTimeRange(hSession, dwClipIndex, pTimeRange) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetTransitionTimeRange)(hSession, dwClipIndex, pTimeRange))

#define AMVES_StoryboardGetTranstionInfo(hSession, dwClipIndex, pTransInfo) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetTransitionInfo)(hSession, dwClipIndex, pTransInfo))
		
#define AMVES_StoryboardGetProjectEngineVersion(hSession, pszProjectPath) \
			(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetProjectEngineVersion)(hSession, pszProjectPath))


#define AMVES_StoryboardGetClipTimeRange(hSession, dwClipIndex, pTimeRange) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardGetClipTimeRange)(hSession, dwClipIndex, pTimeRange))

#define AMVES_StoryboardSetLyricThemeAVParam(hSession, pLyricThemeParam) \
	    (CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardSetLyricThemeAVParam)(hSession, pLyricThemeParam))

#define AMVES_StoryboardSetLyricThemeClipTransLation(hSession, nThemeTemplateID) \
		(CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardSetLyricThemeClipTransLation)(hSession, nThemeTemplateID))

#define AMVES_StoryboardLoadProjectData(hSession, pProjectFile, fnCallback, pUserData) \
	    (CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardLoadProjectData)(hSession, pProjectFile, fnCallback, pUserData))

#define AMVES_StoryboardFetchProjectData(hSession, data) \
	    (CALL_AMVE_FUNC(hSession, MAMVEStoryboardSession, fnStoryboardFetchProjectData)(hSession, data))
			
//The interfaces for SlideShow session
#define AMVES_SlideShowInsertSource(hSession, pSrcNode) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowInsertSource)(hSession, pSrcNode))

#define AMVES_SlideShowRemoveSource(hSession, dwSrcIdx) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowRemoveSource)(hSession, dwSrcIdx))

#define AMVES_SlideShowGetSourceCount(hSession, pdwCount) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowGetSourceCount)(hSession, pdwCount))

#define AMVES_SlideShowGetSource(hSession, dwSrcIdx,pSourceInfoNode) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowGetSource)(hSession, dwSrcIdx,pSourceInfoNode))

#define AMVES_SlideShowSetMusic(hSession, pMusic, pSrcRange) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowSetMusic)(hSession, pMusic, pSrcRange))

#define AMVES_SlideShowGetMusic(hSession, pPathBuf, pdwBufLen, pSrcRange) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowGetMusic)(hSession, pPathBuf, pdwBufLen, pSrcRange))

#define AMVES_SlideShowSetTheme(hSession, llThemeID) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowSetTheme)(hSession, llThemeID))

#define AMVES_SlideShowGetTheme(hSession, pllThemeID) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowGetTheme)(hSession, pllThemeID))

#define AMVES_SlideShowMakeStoryboard(hSession, fnCallback, pUserData,pSize) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowMakeStoryboard)(hSession, fnCallback, pUserData,pSize))

#define AMVES_SlideShowReMakeStoryboard(hSession) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowReMakeStoryboard)(hSession))

#define AMVES_SlideShowCancleMakeStoryboard(hSession) \
	    (CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowCancleMakeStoryboard)(hSession)) 

#define AMVES_SlideShowGetStoryboard(hSession, phStoryboard) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowGetStoryboard)(hSession, phStoryboard))

#define AMVES_SlideShowLoadProject(hSession, pProjectFile, fnCallback, pUserData) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowLoadProject)(hSession, pProjectFile, fnCallback, pUserData))

#define AMVES_SlideShowSaveProject(hSession, pProjectFile, fnCallback, pUserData) \
		(CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowSaveProject)(hSession, pProjectFile, fnCallback, pUserData))

#define AMVES_SlideShowSetMute(hSession,bMute) \
	    (CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowSetMute)(hSession,bMute))

#define AMVES_SlideShowGetMute(hSession) \
	    (CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowGetMute)(hSession))

#define AMVES_SlideShowGetDefaultMusic(hSession, pPathBuf, pdwBufLen) \
	    (CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowGetDefaultMusic)(hSession, pPathBuf, pdwBufLen))

#define AMVES_SlideShowDetectFace(hSession,pImgNode) \
	     (CALL_AMVE_FUNC(hSession, MAMVESlideShowSession, fnSlideShowDetectFace)(hSession, pImgNode))

#define AMVES_SlideShowGetVirtualSrcInfoNodeList(hSession,ppVirtualSrcInfoNode,pdwNodeCount) \
	     (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowGetVirtualSrcInfoNodeList)(hSession,ppVirtualSrcInfoNode,pdwNodeCount))

#define AMVES_SlideShowUpdateVirtualSrcFaceCenter(hSession,dwVirtualSrcIndex,pFaceCenter) \
	    (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowUpdateVirtualSrcFaceCenter) (hSession,dwVirtualSrcIndex,pFaceCenter))
    
#define AMVES_SlideShowDuplicateStoryboard(hSession,phDupStbSession) \
        (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowDuplicateStoryboard) (hSession,phDupStbSession))

#define AMVES_SlideShowSetVirtualSrcTrimRange(hSession,dwVirtualSrcIndex,pTrimRange,bPlayToEnd) \
	    (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowSetVirtualSrcTrimRange) (hSession,dwVirtualSrcIndex,pTrimRange,bPlayToEnd))

#define AMVES_SlideShowUpdateVirtualSource(hSession,dwVirtualSrcIndex,pSrcInfoNode) \
	     (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowUpdateVirtualSource) (hSession,dwVirtualSrcIndex,pSrcInfoNode))

#define AMVES_SlideShowCanInsertVideoSource(hSession,dwVirtualSrcIndex) \
	     (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowCanInsertVideoSource) (hSession,dwVirtualSrcIndex))

#define AMVES_SlideShowRefreshSourceList(hSession) \
	     (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowRefreshSourceList) (hSession))

#define AMVES_SlideShowSetVirtualSourceTransformPara(hSession,dwVirtualSrcIndex,pTransformPara) \
        (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowSetVirtualSourceTransformPara) (hSession,dwVirtualSrcIndex,pTransformPara))

#define AMVES_SlideShowSetVirtualSourceTransformFlag(hSession,dwVirtualSrcIndex,bTransformFalg) \
        (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowSetVirtualSourceTransformFlag) (hSession,dwVirtualSrcIndex,bTransformFalg))


#define AMVES_SlideShowClearOrgSourceInfoList(hSession) \
	     (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowClearOrgSourceInfoList) (hSession))

#define AMVES_SlideShowGetOrgSourceCount(hSession,pdwCount) \
	     (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowGetOrgSourceCount) (hSession,pdwCount))

#define AMVES_SlideShowGetOrgSource(hSession,dwSrcIdx,pSourceInfoNode) \
	     (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowGetOrgSource) (hSession,dwSrcIdx,pSourceInfoNode))

#define AMVES_SlideShowGetVirtualNodeOrgScaleValue(hSession,dwVirtualSrcIndex) \
	     (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowGetOrgVirtualNodeScaleValue) (hSession,dwVirtualSrcIndex))
	     
#define AMVES_SlideShowMoveVirtualSource(hSession,dwSrcIndex, dwDstIndex) \
			 (CALL_AMVE_FUNC(hSession,MAMVESlideShowSession,fnSlideShowMoveVirtualSource) (hSession,dwSrcIndex, dwDstIndex))


//The interfaces for producer session
#define AMVES_ProducerActiveStream(hSession, hStream) \
			(CALL_AMVE_FUNC(hSession, MAMVEProducerSession, fnActiveStream)(hSession, hStream))

#define AMVES_ProducerDeActiveStream(hSession) \
			(CALL_AMVE_FUNC(hSession, MAMVEProducerSession, fnDeActiveStream)(hSession))
			

#define AMVES_ProducerStart(hSession) \
		(CALL_AMVE_FUNC(hSession, MAMVEProducerSession, fnProducerStart)(hSession))

#define AMVES_ProducerPause(hSession) \
		(CALL_AMVE_FUNC(hSession, MAMVEProducerSession, fnProducerPause)(hSession))

#define AMVES_ProducerResume(hSession) \
		(CALL_AMVE_FUNC(hSession, MAMVEProducerSession, fnProducerResume)(hSession))

#define AMVES_ProducerStop(hSession) \
		(CALL_AMVE_FUNC(hSession, MAMVEProducerSession, fnProducerStop)(hSession))

#define AMVES_ProducerCancel(hSession) \
		(CALL_AMVE_FUNC(hSession, MAMVEProducerSession, fnProducerCancel)(hSession))

#define AMVES_ProducerSetCpuOverloadLevel(hSession, dwCpuOverloadLevel) \
		(CALL_AMVE_FUNC(hSession, MAMVEProducerSession, fnProducerSetCpuOverloadLevel)(hSession, dwCpuOverloadLevel))

#define AMVES_ProducerSetThreadPriority(hSession, lPriority) \
		(CALL_AMVE_FUNC(hSession, MAMVEProducerSession, fnProducerSetThreadPriority)(hSession, lPriority))


#define AMVES_AudioProviderActiveStream(hSession, hStream) \
	      (CALL_AMVE_FUNC(hSession, MAMVEAudioProviderSession, fnActiveStream)(hSession, hStream))

#define AMVES_AudioProviderDeActiveStream(hSession) \
	      (CALL_AMVE_FUNC(hSession, MAMVEAudioProviderSession, fnDeActiveStream)(hSession))

#define AMVES_AudioProviderStart(hSession) \
           (CALL_AMVE_FUNC(hSession, MAMVEAudioProviderSession, fnAudioProviderStart)(hSession))

#define AMVES_AudioProviderPause(hSession) \
	       (CALL_AMVE_FUNC(hSession, MAMVEAudioProviderSession, fnAudioProviderPause)(hSession))

#define AMVES_AudioProviderResume(hSession) \
	       (CALL_AMVE_FUNC(hSession, MAMVEAudioProviderSession, fnAudioProviderResume)(hSession))

#define AMVES_AudioProviderStop(hSession) \
	       (CALL_AMVE_FUNC(hSession, MAMVEAudioProviderSession, fnAudioProviderStop)(hSession))

#define AMVES_AudioProviderCancel(hSession) \
	       (CALL_AMVE_FUNC(hSession, MAMVEAudioProviderSession, fnAudioProviderCancel)(hSession))




MHandle QVET_WMDetectorCreate(MHandle hSessionCtx, QVET_WM_DETECT_PARAM *param);
MVoid	 QVET_WMDetectorDestroy(MHandle hD);
MRESULT QVET_WMDetectorStart(MHandle hD);
MRESULT QVET_WMDetectorPause(MHandle hD);
MRESULT QVET_WMDetectorResume(MHandle hD);
MRESULT QVET_WMDetectorStop(MHandle hD);





/*
 *	PCME = PCM Extractor, it's used for extracting pcm from mediafile
 */
MHandle QVET_PCMECreate(MHandle hSessionCtx, QVET_PCME_PARAM *param);
MVoid	 QVET_PCMEDestroy(MHandle h);
MRESULT QVET_PCMEStart(MHandle h);
MRESULT QVET_PCMEStop(MHandle h);
MRESULT QVET_PCMEResume(MHandle h);
MRESULT QVET_PCMEPause(MHandle h);






#ifdef __cplusplus
}
#endif

#endif //_AMVE_SESSION_H_
