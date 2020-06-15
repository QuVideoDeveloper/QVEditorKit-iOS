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
 * IMV2Player.h
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



#ifndef _IMV2PLAYER_H_
#define _IMV2PLAYER_H_

#include "mv2comdef.h"
#include "amoperatornew.h"


class IMV2Player 
{
OVERLOAD_OPERATOR_NEW
public:

	IMV2Player (){}
	virtual ~IMV2Player(){}



	////////////////// Open and Close ////////////////////////////

	/**
	 *	Open
	 *		Open the clip via a specifed URL
	 *	
	 *	Parameter:
	 *		szURL			[in]		the URL of the specifed URL resource
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *	
	 *	Remark:
	 *		support standard URL format , for example:
	 *		"file://c:\\ddd.3gp" means a local file.
	 *		"RTSP://www.333.com/33.mp4" means a RTSP resource
	 *		"HTTP://www.333.com/333.mp4" means a HTTP resource
	 *				
	 */
	virtual MRESULT Open(MVoid * szURL) = 0;

	/**
	 *	Close
	 *		Close the clip resource , the state wil switch to inital status
	 *	
	 *	Parameter:
	 *		None
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		Call this function to close the media stream and release related resources				
	 */
	virtual MRESULT Close() = 0;


	/////////////  File and Media Info ///////////////////////////


	/**
	 *	GetClipInfo
	 *		Get the general information of media clip
	 *	
	 *	Parameter:
	 *		szURL			[In]			the clip URL ,NULL to get info of current opened clip
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
	virtual MRESULT GetClipInfo(MVoid * szURL , LPMV2CLIPINFO  lpClipInfo) = 0;

	/**
	 *	GetAudioInfo
	 *		Get the audio  information of media clip
	 *	
	 *	Parameter:
	 *		szURL			[In]			the clip URL ,NULL to get info of current opened clip
	 *		lpAudioInfo		[out]		the audio info of specified media clip
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetAudioInfo(MVoid * szURL , LPMV2AUDIOINFO lpAudioInfo) = 0;


	/**
	 *	GetVideoInfo
	 *		Get the video  information of media clip
	 *	
	 *	Parameter:
	 *		szURL			[In]			the clip URL ,NULL to get info of current opened clip
	 *		lpVideoInfo		[out]		the video info of specified media clip
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetVideoInfo(MVoid * szURL, LPMV2VIDEOINFO lpVideoInfo) = 0;

	
	/////////////////////// Callback registeration //////////////////////////

	/**
	 *	RegisterPlayerCallback
	 *		Register player callback function
	 *	
	 *	Parameter:
	 *		pPlayerCallback			[In]		the function point of playback callback
	 *		lUserData				[In]		user data which will be passed with callback function
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT RegisterPlayerCallback(PFNMV2PLAYERCALLBACK pPlayerCallback , MHandle hUserData) = 0;


	/////////////////////////// playback control ////////////////////////////////////

	/**
	 *	Play
	 *		Start to playback the opened clip or paused clip
	 *	
	 *	Parameter:
	 *		None
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT Play() = 0;

	/**
	 *	Pause
	 *		Try to pause playing clip
	 *	
	 *	Parameter:
	 *		None
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT Pause() = 0;

	/**
	 *	Stop
	 *		Try to stop the playing clip
	 *	
	 *	Parameter:
	 *		None
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT Stop() = 0;

	/**
	 *	Seek
	 *		Seek the clip to the specified position
	 *	
	 *	Parameter:
	 *		dwTime		[in]			the position in ms whcih wants to seek to 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT Seek(MDWord dwTime) = 0;

	/**
	 *	SetVolume
	 *		Set the current audio volume
	 *	
	 *	Parameter:
	 *		lVolume		[in]			the volume which wants to be set 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		For lVolume, 0 means mute , 100 means maximum volume
	 *				
	 */
	virtual MRESULT SetVolume(MLong lVolume) = 0;

	/**
	 *	GetVolume
	 *		Set the current audio volume
	 *	
	 *	Parameter:
	 *		lVolume		[out]		the current audio volume 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		For lVolume, 0 means mute , 100 means maximum volume
	 *				
	 */
	virtual MRESULT GetVolume(MLong *lVolume) = 0;

	/**
	 *	GetPosition 
	 *		Get the current position of clip
	 *	
	 *	Parameter:
	 *		dwPosition		[out]		the current playback position 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetPosition(MDWord *dwPosition) = 0;


	/**
	 *	GetPlaybackStatus 
	 *		Get the current status of player
	 *	
	 *	Parameter:
	 *		dwStatus		[out]		the current playback status 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetPlaybackStatus(MDWord *dwStatus) = 0;


	////////////////////////visual frame data access/////////////////////////////////
	
	/**
	 *	GetLastPlayedFrame
	 *		Get the data of last played frame, this function only can be called in pause or stop state
	 *	
	 *	Parameter:
	 *		pFrameBuf		[in]		the buffer of frame
	 *		lpFrameInfo		[in/out]	the info of frame 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		Pass pFrameBuf as NULL to query current frame info which is returned in lpFrameInfo
	 *				
	 */
	virtual MRESULT GetLastPlayedFrame( MByte* pFrameBuf , LPMV2FRAMEINFO lpFrameInfo) = 0;


	/**
	 *	GetLastEffectFrame
	 *		Get the data of last played Effect frame, this function only can be called in pause or stop state
	 *	
	 *	Parameter:
	 *		pFrameBuf		[in]		the buffer of frame
	 *		dwTimeStamp		[in]		timestamp of effect
	 *		hEffect	        [in]        effect
	 *		lpFrameInfo 	[in/out]	the info of frame 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		Pass pFrameBuf as NULL to query current frame info which is returned in lpFrameInfo
	 *				
	 */
	virtual  MRESULT GetLastEffectFrame(MByte *pFrameBuf, MDWord dwTimeStamp,  MHandle hEffect, LPMV2FRAMEINFO lpFrameInfo) = 0;

	virtual MRESULT GetLastClipFrame(MByte *pFrameBuf, MHandle hClip, LPMV2FRAMEINFO lpFrameInfo) = 0;
	/**
	 *	GetThumbnail
	 *		Get the thumbnail data of the clip
	 *	
	 *	Parameter:
	 *		szURL			[in]			the clip URL ,NULL to get thumbnail of current opened clip 
	 *		pFrameBuf		[in]			the buffer of frame
	 *		lpFrameInfo		[in/out]		the info of frame 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		Pass pFrameBuf as NULL to query thumbnail  frame info which is returned in lpFrameInfo
	 *				
	 */
	virtual MRESULT GetThumbnail( MVoid * szURL , MByte* pFrameBuf , LPMV2FRAMEINFO lpFrameInfo) = 0;


	///////////////////////player configuration /////////////////////////////////
	
	/**
	 *	SetConfig
	 *		Set the specified configuation to player
	 *	
	 *	Parameter:
	 *		dwCfgType		[in]		the configuration type
	 *		pValue			[in]		the value, and it is correlative to specfied configuration type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT SetConfig(MDWord dwCfgType , MVoid * pValue) = 0;

	/**
	 *	GetConfig
	 *		Get the specified configuration of player
	 *	
	 *	Parameter:
	 *		dwCfgType		[in]		the configuration type
	 *		pValue			[out]	the value, and it is correlative to specfied configuration type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetConfig (MDWord dwCfgType , MVoid * pValue) = 0;

	/**
	 *	RefreshDisplay
	 *		re-draw the last played frame on screen
	 *	
	 *	Parameter:
	 *		N/A
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT RefreshDisplay() = 0;

	/**
	 *	OpenFromStream
	 *		Open the clip via a stream handle
	 *	
	 *	Parameter:
	 *		hStream			[in]		the stream handle of the clip file
	 *		dwFileType		[in]		the file type of the clip
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 * 
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT OpenFromStream( MHandle hStream, MDWord dwFileType ) = 0;

	/**
	 *	GetClipInfoFromStream
	 *		Get the general information of media clip from stream
	 *	
	 *	Parameter:
	 *		hStream			[in]		the stream handle of the clip file
	 *		dwFileType		[in]		the file type of the clip
	 *		lpClipInfo		[out]		the general info of specified media clip
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetClipInfoFromStream( MHandle hStream, MDWord dwFileType, LPMV2CLIPINFO lpClipInfo ) = 0;

	/**
	 *	GetAudioInfoFromStream
	 *		Get the audio  information of media clip from stream
	 *	
	 *	Parameter:
	 *		hStream			[in]		the stream handle of the clip file
	 *		dwFileType		[in]		the file type of the clip
	 *		lpAudioInfo		[out]		the audio info of specified media clip
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetAudioInfoFromStream( MHandle hStream, MDWord dwFileType, LPMV2AUDIOINFO lpAudioInfo ) = 0;

	/**
	 *	GetVideoInfoFromStream
	 *		Get the video  information of media clip from stream
	 *	
	 *	Parameter:
	 *		hStream			[in]		the stream handle of the clip file
	 *		dwFileType		[in]		the file type of the clip
	 *		lpVideoInfo		[out]		the video info of specified media clip
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetVideoInfoFromStream( MHandle hStream, MDWord dwFileType, LPMV2VIDEOINFO lpVideoInfo ) = 0;

	/**
	 *	GetThumbnailFromStreamFromStream
	 *		Get the thumbnail data of the clip from stream
	 *	
	 *	Parameter:
	 *		hStream			[in]		the stream handle of the clip file
	 *		dwFileType		[in]		the file type of the clip
	 *		pFrameBuf		[in]			the buffer of frame
	 *		lpFrameInfo		[in/out]		the info of frame 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		Pass pFrameBuf as NULL to query thumbnail  frame info which is returned in lpFrameInfo
	 *				
	 */
	virtual MRESULT GetThumbnailFromStream( MHandle hStream, MDWord dwFileType, MByte* pFrameBuf, LPMV2FRAMEINFO lpFrameInfo ) = 0;



	/**
	 *	PerformOperation
	 *		perform the operation which is non-standard
	 *	Parameter:
	 *		opType		[in]	MV2_OP_TYPE_XXX  defined in mv2comdef.h
	 *		opData		[in]	depend on opType, refer to mv2comdef.h for more info
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	virtual MRESULT PerformOperation(MDWord opType, MVoid* opData) = 0;

};






#endif	//_IMV2PLAYER_H_



