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
 * IMV2MediaOutputStream.h
 *
 * The interface of media stream(output stream) module in MVLIB2.0
 *
 * In this file, the interface IMV2meidaoutputstream has been defined. 
 * IMV2MediaOutputStream is a abstract interface for media output stream . 
 *
 * Code History
 *    
 * --2004-07-26 Sh.F.Guo  (sguo@arcsoft.com.cn)
 * - initial version 
 * --2004-07-27 Sheng Han  (shan@arcsoft.com.cn)
 * - initial version 
 */
#ifndef _IMV2MEDIAOUTPUTSTREAM_H_
#define _IMV2MEDIAOUTPUTSTREAM_H_

#include "mv2comdef.h"
#include "amoperatornew.h"

class MMV2MediaSourceController;
class CMV2PerformanceMonitorUnit;
class IMV2MediaOutputStream  
 { 
 OVERLOAD_OPERATOR_NEW;
 public: 
	 IMV2MediaOutputStream(){
		InitSkipFrameMode();
	 }
	 virtual ~IMV2MediaOutputStream(){}

	 //////////////////////open and close//////////////////////////////////
	 /* Open 
	 * 
	 *	Description: 
	 *		Call this function to open a mediaoutputstream use the specifed file name  
	 *
	 *	Parameters: 
	 *		pURL : 			[in] 			the URL of the specifed stream to open
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
	 virtual MRESULT Open( MVoid * pURL )  = 0 ; 
 
	 /* Close 
	 * 
	 *	Description: 
	 *		Call this function to close the current mediaoutputstream , 
	 *
	 *	Parameters: 
	 * 
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
	 *		Call this function to reset the mediaoutputstream to the beginning .
	 *
	 *	Parameters: 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 */
	 virtual MRESULT Reset( ) =0 ; 

	/////////////  File and Media Info ///////////////////////////

	/**
	 *	GetClipInfo
	 *		Get the general information of media output stream
	 *	
	 *	Parameter:
	 *		lpClipInfo			[out]		the general info of specified media output stream
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
	 *		Get the audio  information of media output stream
	 *	
	 *	Parameter:
	 *		lpAudioInfo		[out]		the audio info of media output stream
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
	 *		Get the video  information of media output stream
	 *	
	 *	Parameter:
	 *		lpVideoInfo		[out]		the video info of media output stream
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


	 /////////////  frame decode  ///////////////////////////

	 /* ReadVideoFrame 
	 * 
	 *	Description: 
	 *		Call this function to read one video frame raw data sequentially
	 *
	 *	Parameters: 
	 *		pFrameBuf					[in/out] 		the frame buffer which stores the video frame raw data on return
	 *		lBufSize	 					[in] 			the size of buffer
	 *		pFrameInfo					[out]  		the info of this video frame data
	 *		pdwCurrentTimestamp			[out] 		the timestamp of current read video frame. 
	 *		pdwTimeSpan					[out] 		the time span of this video frame
	 * 
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
 
	 virtual MRESULT ReadVideoFrame(MByte * pFrameBuf, MLong lBufSize ,
									 LPMV2FRAMEINFO pFrameInfo,MDWord * pdwCurrentTimestamp , MDWord * pdwTimeSpan ) =0 ; 
 
	 /* ReadAudioFrame 
	 * 
	 *	Description: 
	 *		Call this function to read audio raw data sequentially
	 *
	 *	Parameters: 
	 *		pFrameBuf					[in/out] 		the frame buffer which stores audio raw data on return
	 *		lBufSize	 					[in] 			the size of buffer
	 *		plReadSize					[out]  		the actually read data size 
	 *		pdwCurrentTimestamp			[out] 		the timestamp of current read audio frame. 
	 *		pdwTimeSpan					[out] 		the time span of this audio frame
 
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */

	 virtual MRESULT ReadAudioFrame(MByte * pFrameBuf, MLong lBufSize ,
									 MLong * plReadSize,MDWord * pdwCurrentTimestamp , MDWord * pdwTimeSpan ) =0 ; 


	///////////////////seek operation//////////////////////////////////////

	/* IsSeekable 
	 * 
	 *	Description: 
	 *		Call this function to query whether  this  mediaoutputstream can seek or not
	 *
	 *	Parameters: 
	 *		None
	 *	Return:
	 *		Returns MTrue if this spliter can be seeked,otherwise return MFalse  
	 *
	*/ 
	 virtual MBool IsSeekable( ) = 0 ;



	 /* SeekVideo 
	 * 
	 *	Description: 
	 *		Seek the video track to the specified position
	 *
	 *	Parameters: 
	 *		pdwSeekTime					[in/out] 		the request position passed in and the actually position on return
 	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT SeekVideo( MDWord * pdwSeekTime) = 0;


	 /* SeekAudio 
	 * 
	 *	Description: 
	 *		Seek the audio  track to the specified position
	 *
	 *	Parameters: 
	 *		pdwSeekTime					[in/out] 		the request position passed in and the actually position on return
        * 
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT SeekAudio( MDWord * pdwSeekTime) = 0;
	 

	 /* QueryType 
	 * 
	 *	Description: 
	 *		Call this function to get the meidaoutputstream type  .
	 *
	 *	Parameters: 
	 *		pdwMOSType 		[in/out] 		Pointer to a variable which will receive its mediaoutstream type.
 	 *									or query if the specified type is supported
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT QueryType( MDWord * pdwMOSType ) =0 ; 
	 
	 /**
	 *	SetConfig
	 *		Set the specified configuation to mediaoutputstream
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
	 *		Get the specified configuration of mediaoutputstream
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

	virtual MRESULT GetSourceControl(MMV2MediaSourceController ** ppSourceController  ) { return MV2_ERR_OPERATION_NOT_SUPPORT ;};  
	 
	virtual MRESULT  SetPMU(CMV2PerformanceMonitorUnit *pPMU) {return MV2_ERR_OPERATION_NOT_SUPPORT ; };

	 /* OpenStream
	 * 
	 *	Description: 
	 *		Call this function to open a mediaoutputstream use the specifed file stream handle  
	 *
	 *	Parameters: 
	 *		hStream : 			[in] 			the handle of the specifed stream to open
	 *		dwFileType			[in]			the file type of the clip
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

 	 virtual MVoid InitSkipFrameMode(){m_bSkipVideoFrame = MFalse;}



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
	 virtual MRESULT PerformOperation(MDWord opType, MVoid* opData) {return MV2_ERR_OPERATION_NOT_SUPPORT;}
	 
protected:
	MBool	m_bSkipVideoFrame;
	//m_bSkipVideoFrame means the frame doesn't need to be show in the screen. 
	//it wii be decided by the outputstreammgr in mvlib, and it will be set level by level into the different AMVE stream 

}; 
#endif//_IMV2MEDIAOUTPUTSTREAM_H_
