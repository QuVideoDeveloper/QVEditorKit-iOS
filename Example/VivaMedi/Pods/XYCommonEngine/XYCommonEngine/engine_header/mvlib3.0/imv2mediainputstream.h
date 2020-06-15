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
 * imv2mediainputstream.h
 *
 * The interface of media stream(input stream) module in MVLIB2.0
 *
 * In this file, the interface IMV2MediaInputStream has been defined. 
 * IMV2MediaInputStream is a abstract interface for media input stream . 
 *
 * Code History
 *    
 * --2004-07-26 Sh.F.Guo  (sguo@arcsoft.com.cn)
 * - initial version 
 *
 * --2004-07-27 Sheng Han  (shan@arcsoft.com.cn)
 * - initial version 
 */


 
#ifndef _IMV2MEDIAINPUTSTREAM_H_
#define _IMV2MEDIAINPUTSTREAM_H_

#include "mv2comdef.h"
#include "amoperatornew.h"
class MMV2MediaTransmitterController;
class IMV2MediaInputStream  
 { 
 OVERLOAD_OPERATOR_NEW
 public: 
	 IMV2MediaInputStream(){}
	 virtual ~IMV2MediaInputStream(){}

	 ////////////////Create and Close /////////////////////
	 /* Create 
	 * 
	 *	Description: 
	 *		Call this function to create a mediainputstream use the specifed file name  
	 *
	 *	Parameters: 
	 *		pFilePath : 		[in] 			pointer to the file name used to create the  mediainputstream.
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 */
	 virtual MRESULT Create( MVoid * pFilePath )  = 0 ; 
 
	 /* Close
	 * 
	 *	Description: 
	 *		Call this function to close the current mediainputstream , 
	 *
	 *	Parameters: 
	 * 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT Close( ) = 0   ; 

	////////////// File and media info setting/////////////////////

	/* SetClipInfo 
	 * 
	 *	Description: 
	 *		Call this function to set file system's param to the mediainputstream
	 *
	 *	Parameters: 
	 * 		pClipInfo 	[in] 			pointer to a  file info used to specify the 
	 8					  			meidainput's file system's param 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT SetClipInfo ( LPMV2CLIPINFO  pClipInfo)  = 0  ; 
 
	 /* SetVideoInfo 
	 * 
	 *	Description: 
	 *		Call this function to set the video codec info to the mediainputstream
	 *
	 *	Parameters: 
	 * 		pVideoInfo 	[in] 			pointer to a video codec info used to set the
	 *								mediainputstream's video's param 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */

	 virtual MRESULT SetVideoInfo (  LPMV2VIDEOINFO pVideoInfo ) = 0 ;

	/* SetAudioInfo 
	 * 
	 *	Description: 
	 *		Call this function to set the audio codec info to the mediainputstream
	 *
	 *	Parameters: 
	 * 		pAudioInfo 	[in] 			pointer to a audio codec info used to set the
	 *								mediainputstream's audio's param 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */ 
	 virtual MRESULT SetAudioInfo( LPMV2AUDIOINFO pAudioInfo ) = 0   ; 

	 ////////////// audio and video frame write/////////////////////

	/*	WriteAudioFrame 
	 * 
	 *	Description: 
	 *		Call this function to write audio frame data to the mediainputstream
	 *
	 *	Parameters: 
	 *		pFrameData 		[in] 			pointer to the buffer to contain audio raw  data 
	 *		lDataSize			[in]  		the size of audio raw data 
	 *		plWritedSize 		[out] 		the actually written size 
	 *		dwTimeSpan		[in]			the time span of this audio data
	 *			  
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */

	 virtual MRESULT WriteAudioFrame ( MByte * pFrameData, MLong lDataSize , MLong * plWrittenSize, MDWord dwTimeSpan) =0 ;  
 
 	 /* WriteVideoFrame 
	 * 
	 *	Description: 
	 *		Call this function to write one video frame raw data to the mediainputstream 
	 *
	 *	Parameters: 
	 *		pFrameData 			[in] 				pointer to the buffer of one video frame raw data
	 *		lDataSize 			[in] 				the size of video frame raw data 
	 *		dwTimestamp 			[in] 				the current timestamp for this frame
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		Pass pFrameData with NULL means the user wants to write an empty video frame
	 *
	 *
	 */
	 virtual MRESULT WriteVideoFrame (MByte * pFrameData, MLong  lDataSize ,  MDWord  dwTimestamp) =0; 


	 /* GetCurrentDumpSize 
	 * 
	 *	Description: 
	 *		Call this function to get the size of the mediainputstream have dumped  to stream current time
	 *
	 *	Parameters: 
	 *      	pllSizeDump 			[out] 		to receive the size that have dumped
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
	 * 		Call this function to query the mediainputstream type  .
	 *
	 *	Parameters: 
	 *		pdwMISType 		[in/out]				Pointer to a variable which will receive its mediainputstream type.
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT QueryType( MDWord * pdwMISType ) =0 ; 

	 /**
	 *	SetConfig
	 *		Set the specified configuation to recorder
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
	 *		Get the specified configuration of recorder
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

	virtual MRESULT  SetPMU() { return MV2_ERR_OPERATION_NOT_SUPPORT;} ;
	
	virtual MRESULT GetTransmitterControl(MMV2MediaTransmitterController **ppMediaController){return MV2_ERR_OPERATION_NOT_SUPPORT;}  
}; 
#endif//_IMV2MEDIAINPUTSTREAM_H_
