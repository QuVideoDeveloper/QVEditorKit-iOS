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
 * imv2muxer.h
 *
 * The interface of Medie file ( muxer) module of MVLIB2.0
 *
 * In this file, the interface IMV2Muxer has been defined. 
 * IMV2Muxer is a abstract interface for video file format muxer. 
 * all the video file format(mp4,asf...)should implement this interface
 *
 * Code History
 *    
 * --2004-07-26 Sh.F.Guo  (sguo@arcsoft.com.cn)
 * - initial version 
 * --2004-07-27 Sheng Han  (shan@arcsoft.com.cn)
 * - Review and modify 
 */
#ifndef _IMV2MUXER_H_
#define _IMV2MUXER_H_

#include "mv2comdef.h"
#include "mv2error.h"
#include "amoperatornew.h"

class MMV2MediaTransmitterController;

class IMV2Muxer  
 { 
 OVERLOAD_OPERATOR_NEW 
 public: 
	 IMV2Muxer(){}
	 virtual ~IMV2Muxer(){}

	 /* Create 
	 * 
	 *	Description: 
	 *		Call this function to create the muxer use the specify file param  
	 *
	 *	Parameters: 
	 *		pFilePath 		[in] 			pointer to the file param used to create the muxer .
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	*/
	 virtual MRESULT Create( MVoid * pFilePath )  = 0 ; 
 
	 /* Close 
	 * 
	 *	Description: 
	 *		Call this function to close the current muxer , 
	 *
	 *	Parameters: 
	 * 
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	*/ 

	 virtual MRESULT Close( ) = 0   ; 

	/* SetClipInfo 
	 * 
	 *	Description: 
	 *		Call this function to set file system's param to media file
	 *
	 *	Parameters: 
	 * 		pClipInfo 	[in] 			pointer to the  file info used to specify the media file
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT SetClipInfo ( LPMV2CLIPINFO  pClipInfo)  = 0  ; 
 
	 /* SetVideoInfo 
	 * 
	 *	Description: 
	 *		Call this function to set the video codec info to media file
	 *
	 *	Parameters: 
	 * 		pVideoInfo 	[in] 			pointer to a video codec info used to set the media file
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */

	 virtual MRESULT SetVideoInfo (  LPMV2VIDEOINFO pVideoInfo ) = 0 ;

	/* SetAudioInfo 
	 * 
	 *	Description: 
	 *		Call this function to set the audio codec info to media file
	 *
	 *	Parameters: 
	 * 		pAudioInfo 	[in] 			pointer to a audio codec info used to set the media file
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */ 
	 virtual MRESULT SetAudioInfo( LPMV2AUDIOINFO pAudioInfo ) = 0   ; 


	 /* DumpAudioFrame 
	 * 
	 *	Description: 
	 *		Call this function to dump encoded  audio data to the media file 
	 *
	 *	Parameters: 
	 * 		pAudioData 		[in] 			pointer to the encoded audio data 
	 *		lDataSize  		[in] 			the size of the audio data 
	 *		dwTimeSpan		[in]			the time span of this audio data
	 *	
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	*/ 
	 virtual MRESULT DumpAudioFrame (MByte * pAudioData, MLong lDataSize , MDWord dwTimeSpan ) =0 ;
 
 
	 /* DumpVideoFrame 
	 * 
	 *	Description: 
	 *		Call this function to dump encoded video data to the media file 
	 *
	 *	Parameters: 
	 * 		pVideoData 		[in] 			pointer to the encoded video data 
	 *		lDataSize  		[in] 			the size of the video data
	 *		bNotSyncSample	[in] 			the frame is sync frame or not
	 *		dwTimestamp		[in]			specify the timestamp of this frame 
	 *           dwTimeSpan          [in]                specify the duration of this frame
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	*/ 
	 virtual MRESULT DumpVideoFrame (MByte * pVideoData, MLong lDataSize,
 										MBool bNotSyncSample , MDWord dwTimestamp,MDWord dwTimeSpan) =0 ; 
 
 

	 /* GetCurrentDumpSize 
	 * 
	 *	Description: 
	 *		Call this function to get the size of the mediainputstream have dumped  to stream current time
	 *
	 *	Parameters: 
	 *      	pllSizeDump 	[out] 		to receive the size that have dumped
	 *	 
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	*/ 
	 virtual MRESULT  GetCurrentDumpSize( MInt64 * pllSizeDump) = 0 ;
 

	 /* QueryType 
	 * 
	 *	Description: 
	 *		Call this function to get the muxer  type  .
	 *
	 *	Parameters: 
	 *		pdwMuxerType 		[in/out] 		Pointer to a variable which will receive its muxer  type
 	 *										or query if the specified type is supported
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	*/
	 virtual MRESULT QueryType( MDWord * pdwMuxerType ) =0 ; 
	 
	 /**
	 *	SetConfig
	 *		Set the specified configuration to muxer
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

		/**
	 *	GetConfig
	 *		Get the specified configuration from muxer
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
	virtual MRESULT GetConfig (MDWord dwCfgType , MVoid * pValue) = 0 ;

	virtual MRESULT GetTransmitterControl(MMV2MediaTransmitterController **ppMediaController) { return MV2_ERR_OPERATION_NOT_SUPPORT; }

}; 

#endif//_IMV2MUXER_H_
