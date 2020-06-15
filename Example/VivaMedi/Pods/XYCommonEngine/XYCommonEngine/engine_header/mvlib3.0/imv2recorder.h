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
 * imv2recorder.h
 *
 * 	The interface of recorder module in MVLIB2.0
 *
 *	This interface defines the recording control , preview setting 
 *	and other configuration methods of video recorder  for the application layer
 *     which wants to record a specified video clip.
 *
 * Code History
 *    
 * --2004-07-23 Sh.F.Guo  (sguo@arcsoft.com.cn)
 * - initial version
 *
 * --2004-07-26 Sheng Han  (shan@arcsoft.com.cn)
 * - Review and modify
 *	
 *
 */
 
#ifndef _IMV2RECORDER_INTERFACE_
#define _IMV2RECORDER_INTERFACE_

#include "mv2comdef.h"
#include "amoperatornew.h"
class IMV2Recorder
 { 
 OVERLOAD_OPERATOR_NEW
 public: 
	 IMV2Recorder(){}
	 virtual ~IMV2Recorder(){}

	////////////////Create and Close /////////////////////
	
	/**
	 *	Create
	 *		Create with the specified file to store recoded A/V data
	 *	
	 *	Parameter:
	 *		szFile			[in]		The specified  file
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT Create(MVoid * szFile ) = 0;

 
	/**
	 *	Create
	 *		Close the recorder
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
	 virtual MRESULT Close(  ) =0; 




	////////////// File and media info setting/////////////////////


	/**
	 *	SetClipInfo
	 *		Set the general info to the recorded clip
	 *	
	 *	Parameter:
	 *		lpClipInfo			[in]		the clip info
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT SetClipInfo(LPMV2CLIPINFO  lpClipInfo) = 0 ;

 
	/**
	 *	SetAudioInfo
	 *		Set the audio codec info to the recorded clip
	 *	
	 *	Parameter:
	 *		lpAudioInfo			[in]		the audio codec info
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT SetAudioInfo(LPMV2AUDIOINFO lpAudioInfo) = 0 ;

	 
	/**
	 *	SetVideoInfo
	 *		Set the video codec info to the recorded clip
	 *	
	 *	Parameter:
	 *		lpVideoInfo			[in]		the audio codec info
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
 	virtual MRESULT SetVideoInfo( LPMV2VIDEOINFO lpVideoInfo) =0 ; 


	//////////////////callback function registeration///////////////////////

	/**
	 *	RegisterRecorderCallback
	 *		Register recorder callback function
	 *	
	 *	Parameter:
	 *		pRecorderCallback		[In]		the function point of recorder callback
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
	 virtual MRESULT RegisterRecorderCallback (  PFNMV2RECORDERCALLBACK pRecorderCallback, MVoid* lUserData ) = 0 ; 



	///////////////////Recorder control///////////////////////////////////////
	
	/**
	 *	Record
	 *		Start to record for the created or paused clip
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
 	 virtual MRESULT Record() = 0; 	

	/**
	 *	Pause
	 *		Pause the recorder
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
	 *		Stop the recorder
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
	 *	Stop
	 *		Set the preview status
	 *	
	 *	Parameter:
	 *		bTurnOn			[in]		whether turn on the preview
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		Before first turning on the preview , user should call SetConfig to set the preview parameter
	 *				
	 */
 	 virtual MRESULT SetPreview( MBool bTurnOn ) = 0 ; 

	//////////////// recorder configuration ////////////////////////////////

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

}; 
#endif//_IMV2RECORDER_INTERFACE_
