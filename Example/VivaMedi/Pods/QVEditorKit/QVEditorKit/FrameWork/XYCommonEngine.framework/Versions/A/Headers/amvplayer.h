/*----------------------------------------------------------------------------------------------
*
* This file is ArcSoft's property. It contains ArcSoft's trade secret, proprietary and 		
* confidential information. 
* 
* The information and code contained in this file is only for authorized ArcSoft employees 
* to design, create, modify, or review.
* 
* DO NOT DISTRIBUTE, DO NOT DUPLICATE OR TRANSMIT IN ANY FORM WITHOUT PROPER AUTHORIZATION.
* 
* If you are not an intended recipient of this file, you must not copy, distribute, modify, 
* or take any action in reliance on it. 
* 
* If you have received this file in error, please immediately notify ArcSoft and 
* permanently delete the original and any copy of any file and any printout thereof.
*
*-------------------------------------------------------------------------------------------------*/

/*
 * MV2Player.h
 *
 * Description:
 *
 *	The interface of player module in MVLIB2.0
 *
 *	This interface defines the media control , media info, media data access,
 *	and other configuration methods of video playback for the application layer
 *     which wants to play a specified video clip.
 *
 * History
 *    
 *  07.23.2004 Sheng Han(shan@arcsoft.com.cn )   
 * - initial version 
 *
 */



#ifndef _MV2PLAYER_H_
#define _MV2PLAYER_H_

#include "mv2comdef.h"


#ifdef __cplusplus
extern "C" {
#endif

#ifdef	__SYMBIAN32__
	#define AMVAPI	EXPORT_C
#else
	#ifndef AMVAPI
		#ifdef AMVPLAYER_EXPORTS
			#define AMVAPI	__declspec(dllexport)
		#else
			#define AMVAPI 
		#endif
	#endif
#endif 

	
////////////////// initialize and destroy

/**
 *	AMV_Player_Initialize
 *		Initialize the handle of player manager
 *	
 *	Parameter:
 *		phPlayerMgr			[in/out]	The handle of player manager. Input a pointer of handle, 
 								the returned handle value will be the initialized player manager handle.
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *	
 *	Remark:
 *		The initial interface must be called once ahead of other player interfaces, 
 *		and the returned player manager handle should pass to all other implemented player interface. 
 *				
 */
AMVAPI MRESULT AMV_Player_Initialize(MHandle* phPlayerMgr);

/**
 *	AMV_Player_Destroy
 *		Destroy the handle of player manager 
 *	
 *	Parameter:
 *		phPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface.
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *	
 *	Remark:
 *		The destroy interface must be called while exiting player program.
 *				
 */
AMVAPI MRESULT AMV_Player_Destroy(MHandle hPlayerMgr);

////////////////// Open and Close ////////////////////////////

/**
 *	AMV_Player_Open
 *		Open the clip via a specifed URL
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		szURL				[in]		the URL of the specifed URL resource
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *	
 *	Remark:
 *		support standard URL format 
 *				
 */
AMVAPI MRESULT AMV_Player_Open(MHandle hPlayerMgr, MVoid * szURL);

/**
 *	AMV_Player_Close
 *		Close the clip resource , the state wil switch to inital status
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		Call this function to close the media stream and release related resources				
 */
AMVAPI MRESULT AMV_Player_Close(MHandle hPlayerMgr);


/////////////  File and Media Info ///////////////////////////


/**
 *	AMV_Player_GetClipInfo
 *		Get the general information of media clip
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		szURL				[In]		the clip URL ,NULL to get info of current opened clip
 *		lpClipInfo			[out]		the general info of specified media clip
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_GetClipInfo(MHandle hPlayerMgr, MVoid * szURL , LPMV2CLIPINFO  lpClipInfo);

/**
 *	AMV_Player_GetAudioInfo
 *		Get the audio  information of media clip
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		szURL				[In]		the clip URL ,NULL to get info of current opened clip
 *		lpAudioInfo			[out]		the audio info of specified media clip
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_GetAudioInfo(MHandle hPlayerMgr, MVoid * szURL , LPMV2AUDIOINFO lpAudioInfo);

/**
 *	AMV_Player_GetVideoInfo
 *		Get the video  information of media clip
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		szURL				[In]		the clip URL ,NULL to get info of current opened clip
 *		lpVideoInfo			[out]		the video info of specified media clip
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_GetVideoInfo(MHandle hPlayerMgr, MVoid * szURL, LPMV2VIDEOINFO lpVideoInfo);


/////////////////////// Callback registeration //////////////////////////

/**
 *	AMV_Player_RegisterPlayerCallback
 *		Register player callback function
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		pPlayerCallback			[In]		the function point of playback callback
 *		lUserData			[In]			user data which will be passed with callback function
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_RegisterPlayerCallback(MHandle hPlayerMgr, PFNMV2PLAYERCALLBACK pPlayerCallback , MLong lUserData);


/////////////////////////// playback control ////////////////////////////////////

/**
 *	AMV_Player_Play
 *		Start to playback the opened clip or paused clip
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_Play(MHandle hPlayerMgr);

/**
 *	AMV_Player_Pause
 *		Try to pause playing clip
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_Pause(MHandle hPlayerMgr);

/**
 *	AMV_Player_Stop
 *		Try to stop the playing clip
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_Stop(MHandle hPlayerMgr);

/**
 *	AMV_Player_Seek
 *		Seek the clip to the specified position
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		dwTime				[in]		the position in ms whcih wants to seek to 
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_Seek(MHandle hPlayerMgr, MDWord dwTime);

/**
 *	AMV_Player_SetVolume
 *		Set the current audio volume
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		lVolume				[in]		the volume which wants to be set 
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		For lVolume, 0 means mute , 100 means maximum volume
 *				
 */
AMVAPI MRESULT AMV_Player_SetVolume(MHandle hPlayerMgr, MLong lVolume);

/**
 *	AMV_Player_GetVolume
 *		Set the current audio volume
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		lVolume				[out]		the current audio volume 
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		For lVolume, 0 means mute , 100 means maximum volume
 *				
 */
AMVAPI MRESULT AMV_Player_GetVolume(MHandle hPlayerMgr, MLong* lVolume);

/**
 *	AMV_Player_GetPosition 
 *		Get the current position of clip
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		dwPosition			[out]		the current playback position 
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_GetPosition(MHandle hPlayerMgr, MDWord *dwPosition);


/**
 *	AMV_Player_GetPlaybackStatus 
 *		Get the current status of player
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		dwStatus			[out]		the current playback status 
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_GetPlaybackStatus(MHandle hPlayerMgr, MDWord *dwStatus);


////////////////////////visual frame data access/////////////////////////////////

/**
 *	AMV_Player_GetLastPlayedFrame
 *		Get the data of last played frame, this function only can be called in pause or stop state
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		pFrameBuf			[in]		the buffer of frame
 *		lpFrameInfo			[in/out]	the info of frame 
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		Pass pFrameBuf as NULL to query current frame info which is returned in lpFrameInfo
 *				
 */
AMVAPI MRESULT AMV_Player_GetLastPlayedFrame(MHandle hPlayerMgr, MByte* pFrameBuf , LPMV2FRAMEINFO lpFrameInfo);

/**
 *	AMV_Player_GetThumbnail
 *		Get the thumbnail data of the clip
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		szURL				[in]		the clip URL ,NULL to get thumbnail of current opened clip 
 *		pFrameBuf			[in]		the buffer of frame
 *		lpFrameInfo			[in/out]	the info of frame 
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		Pass pFrameBuf as NULL to query thumbnail  frame info which is returned in lpFrameInfo
 *				
 */
AMVAPI MRESULT AMV_Player_GetThumbnail(MHandle hPlayerMgr, MVoid * szURL , MByte* pFrameBuf , LPMV2FRAMEINFO lpFrameInfo);

///////////////////////player configuration /////////////////////////////////

/**
 *	AMV_Player_SetConfig
 *		Set the specified configuation to player
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		dwCfgType			[in]		the configuration type
 *		pValue				[in]		the value, and it is correlative to specfied configuration type
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_SetConfig(MHandle hPlayerMgr, MDWord dwCfgType , MVoid * pValue);

/**
 *	AMV_Player_GetConfig
 *		Get the specified configuration of player
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *		dwCfgType			[in]		the configuration type
 *		pValue				[out]		the value, and it is correlative to specfied configuration type
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Player_GetConfig (MHandle hPlayerMgr, MDWord dwCfgType , MVoid * pValue);

/**
 *	AMV_Player_RefreshDisplay
 *		Tell the player to draw the last played frame
 *	
 *	Parameter:
 *		hPlayerMgr			[in]		Player manager handle created by AMV_Player_Initialize interface
 *
 *	Return:
 *		MV2_ERR_NONE			success
 *		!MV2_ERR_NONE			fail
 *
 *	Remark:
 *		currently available for palm overlay only
 *				
 */
AMVAPI MRESULT AMV_Player_RefreshDisplay(MHandle hPlayerMgr);

#ifdef __cplusplus
}
#endif

#endif	//_MV2PLAYER_H_



