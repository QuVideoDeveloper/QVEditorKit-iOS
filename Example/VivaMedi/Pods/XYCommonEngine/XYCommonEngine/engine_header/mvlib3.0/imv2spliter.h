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
 * imv2spliter.h
 *
 * The interface of media file( spliter ) in MVLIB2.0
 *
 * In this file, the interface IMV2Spliter has been defined. 
 * IMV2Spliter is a abstract interface for video file format spliter. 
 * all the video file format(mp4,asf...)should implement this interface
 *
 * Code History
 *    
 * --2004-07-26 Sh.F.Guo  (sguo@arcsoft.com.cn)
 * - initial version 
 * --2004-07-27 Sheng Han  (shan@arcsoft.com.cn)
 * - Review and modify 
 */

#ifndef _IMV2SPLITER_H_
#define _IMV2SPLITER_H_


#include "mv2comdef.h"
#include "mv2error.h"
#include "amoperatornew.h"
#include "mkernelobj.h"
//to specify seek by frame or the specifed frame
#define SEEK_NEXT_FRAME 0xFFFFFFFF
#define SEEK_PRE_FRAME  0xFFFFFFFE

#define READAUDIO_FLAG  0x1
#define READVIDEO_FLAG  0x2

class MMV2MediaSourceController;

///////////// IMV2Spliter  ////////////////////////////////
class IMV2Spliter  
 { 
 OVERLOAD_OPERATOR_NEW	 
 public: 
	 IMV2Spliter(){}
	 virtual ~IMV2Spliter(){}

	 /* Open 
	 * 
	 *	Description: 
	 *		Call this function to open the meida file or remote resource
	 *
	 *	Parameters: 
	 *		pURL		[in] 			pointer to the file or resource to be opened .
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *
	*/
	 virtual MRESULT Open( MVoid * pURL )  = 0 ; 
 
	 /* Close 
	 * 
	 *	Description: 
	 *		Call this function to close the current media file , 
	 *
	 *	Parameters: 
	 * 
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 */ 
	 virtual MRESULT Close( ) = 0   ; 

	 /* Reset 
	 * 
	 *	Description: 
	 *		Call this function to reset the file to the beginning sample
	 *
	 *	Parameters: 
	 * 		None
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 */ 
	 virtual MRESULT  Reset() = 0 ;
 
 

	/**
	 *	GetClipInfo
	 *		Get the general information of media file
	 *	
	 *	Parameter:
	 *		lpClipInfo			[out]		the general info of specified media file
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetClipInfo(LPMV2CLIPINFO  lpClipInfo) = 0;

	/**
	 *	GetAudioInfo
	 *		Get the audio  information of media file
	 *	
	 *	Parameter:
	 *		lpAudioInfo		[out]		the audio info of media file
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetAudioInfo(LPMV2AUDIOINFO lpAudioInfo) = 0;

	/**
	 *	GetVideoInfo
	 *		Get the video  information of media file
	 *	
	 *	Parameter:
	 *		lpVideoInfo		[out]		the video info of media file
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT GetVideoInfo(LPMV2VIDEOINFO lpVideoInfo) = 0;
 



	 /* ReadAudioFrame 
	 * 
	 *	Description: 
	 *		Call this function to read encoded audio data sequentially
	 *
	 *	Parameters: 
	 *		pFrameBuf					[in/out] 		the frame buffer which stores audio raw data on return
	 *		lBufSize	 					[in] 			the size of buffer
	 *		plReadSize					[out]  		the actually read data size 
	 *		pdwCurrentTimestamp			[out] 		the timestamp of current read audio frame. 
	 *		pdwTimeSpan					[out] 		the time span of this audio frame
 
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *      MV2_ERR_SPLITER_DATAEND  audio end
	 *		!MV2_ERR_NONE			fail
	 */

	 virtual MRESULT ReadAudioFrame(MByte * pFrameBuf, MLong lBufSize ,
									 MLong * plReadSize,MDWord * pdwCurrentTimestamp , MDWord * pdwTimeSpan ) =0 ; 
 
	 /* ReadVideoFrame 
	 * 
	 *	Description: 
	 *		Call this function to read one encoded video frame data sequentially
	 *
	 *	Parameters: 
	 *		pFrameBuf					[in/out] 		the frame buffer which stores the video frame raw data on return
	 *		lBufSize	 					[in] 			the size of buffer
	 *		plReadSize					[out]  		the actually read data size 
	 *		pdwCurrentTimestamp			[out] 		the timestamp of current read video frame. 
	 *		pdwTimeSpan					[out] 		the time span of this video frame
	 * 
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		MV2_ERR_SPLITER_DATAEND    video end
	 *		!MV2_ERR_NONE			fail
	 */
 
	 virtual MRESULT ReadVideoFrame(MByte * pFrameBuf, MLong lBufSize ,
									 MLong * plReadSize,MDWord * pdwCurrentTimestamp , 
									 MDWord * pdwTimeSpan,MBool *  pbIsSyncFrame = MNull ) =0 ; 
 
	 
	 /* SeekVideoFrame 
	 * 
	 *	Description: 
	 *		Call this function to seek the spliter  to the position of next video frame(synchronize frame) or the specified
	 *		frame( or synchronize frame)
	 *
	 *	Parameters: 
	 *		bSync 		[in] to specify whether to seek synchronize frame or not
	 *		pdwTimestamp	[in/out]
	 *				    SEEK_NEXT_FRAME:specify that this function seek to next 
	 *					frame or next synchronize frame,and return this frame's
	 *					 timestamp to pdwTimestamp
	 *				    other value:specify that this function seek to nearest
	 *					next synchronize frame before *pdwTimestamp,
	 *					and return this frame's timestamp to pdwTimestamp
	 *
	 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		return MV2_ERR_SPLITER_SEEKTOEND to specify that have seek to file end
	 *
	*/ 
	 virtual MRESULT SeekVideoFrame( MBool bSync , MDWord * pdwTimestamp) = 0 ;
 
	 /* SeekAudioFrame 
	 * 
	 *	Description: 
	 *		Call this function to seek the spliter  to the position of next audio frame or the specifed frame
	 *
	 *	Parameters: 
	 *		pdwTimestamp	[in/out]the in value of pdwTimeStamp as following	
	 *				    SEEK_NEXT_FRAME:specify that this function seek to next 
	 *					audio frame ,and return this frame's timestamp to pdwTimestamp
	 *				    other value:specify that this function seek to nearest
	 *					frame before *pdwTimestamp,and return this frame's timestamp to pdwTimestampthe 
	 *	
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		return MV2_ERR_SPLITER_SEEKTOEND to specify that have seek to file end
	 *
	*/ 
	 virtual MRESULT SeekAudioFrame( MDWord * pdwTimestamp ) = 0 ;

	 /* IsSeekAble 
	 * 
	 *	Description: 
	 *		Call this function to query whether  this  spliter can seek or not
	 *
	 *	Parameters: 
	 *		None
	 *	Return:
	 *		Returns MTrue if this spliter can be seeked,otherwise return MFalse  
	 *
	*/ 
	 virtual MBool IsSeekable( ) = 0 ;


	 /* QueryType 
	 * 
	 *	Description: 
	 *		Call this function to get the spliter  type  .
	 *
	 *	Parameters: 
	 *		pdwSpliterType 		[in/out] 		Pointer to a variable which will receive its spliter  type 
	 *										or query if the specified type is supported
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *
	*/
	 virtual MRESULT QueryType( MDWord * pdwSpliterType ) = 0 ; 
 

	 virtual MRESULT GetSourceControl( MMV2MediaSourceController ** ppSourceController) { return MV2_ERR_OPERATION_NOT_SUPPORT ;}; 	
	 
	 /**
	 *	GetConfig
	 *		Get the specified configuration from spliter
	 *	
	 *	Parameter:
	 *		dwCfgType		[in]	the configuration type
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
	 *	SetConfig
	 *		Set the specified configuration to spliter
	 *	
	 *	Parameter:
	 *		dwCfgType		[in]	the configuration type
	 *		pValue			[in]	the value, and it is correlative to specfied configuration type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT SetConfig (MDWord dwCfgType , MVoid * pValue) = 0;


	 /* OpenStream 
	 * 
	 *	Description: 
	 *		Call this function to open the media file from specified stream
	 *
	 *	Parameters: 
	 *		hStream		[in] 			handle of the stream .
	 *		dwFileType	[in]			
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *
	*/

	 virtual MRESULT OpenFromStream( MHandle hStream ) { return MV2_ERR_NONE; };
 
protected:
	CMMutex m_Mutex;
}; 
#endif//_IMV2SPLITER_H_
