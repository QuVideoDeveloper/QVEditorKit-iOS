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
 * MV2Recorder.h
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
 
#ifndef _MV2RECORDER_INTERFACE_
#define _MV2RECORDER_INTERFACE_

#include "mv2comdef.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef	__SYMBIAN32__
	#define AMVAPI	EXPORT_C
#else
	#ifndef AMVAPI
		#ifdef AMVRECORDER_EXPORTS
			#define AMVAPI	__declspec(dllexport)
		#else
			#define AMVAPI 
		#endif
	#endif
#endif 

////////////////// initialize and destroy

/**
 *	AMV_Recorder_Initialize
 *		Initialize the handle of recorder manager.
 *	
 *	Parameter:
 *		phRecorderMgr		[in/out]	The handle of recorder manager handle. Input a pointer of handle, 
 *								the returned handle value will be the  initialized recorder manager handle
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *	
 *	Remark:
 *		The initial interface must be called once ahead of other recorder interfaces, 
 *		and the returned recorder manager handle should pass to all other implemented recorder interfaces
 *				
 */
AMVAPI MRESULT AMV_Recorder_Initialize(MHandle* phRecorderMgr);

/**
 *	AMV_Recorder_Destroy
 *		Destroy the handle of recorder manager. 
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *	
 *	Remark:
 *		The destroy interface must be called while exiting recorder program.
 *				
 */
AMVAPI MRESULT AMV_Recorder_Destroy(MHandle hRecorderMgr);
////////////////Create and Close /////////////////////

/**
 *	AMV_Recorder_Create
 *		Create with the specified file to store recoded A/V data
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *		szFile			[in]		The specified  file
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_Create(MHandle hRecorderMgr, MVoid * szFile );


/**
 *	AMV_Recorder_Close
 *		Close the recorder
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_Close(MHandle hRecorderMgr); 




////////////// File and media info setting/////////////////////


/**
 *	AMV_Recorder_SetClipInfo
 *		Set the general info to the recorded clip
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *		lpClipInfo		[in]		the clip info
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_SetClipInfo(MHandle hRecorderMgr, LPMV2CLIPINFO  lpClipInfo);


/**
 *	AMV_Recorder_SetAudioInfo
 *		Set the audio codec info to the recorded clip
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *		lpAudioInfo		[in]		the audio codec info
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_SetAudioInfo(MHandle hRecorderMgr, LPMV2AUDIOINFO lpAudioInfo);

 
/**
 *	AMV_Recorder_SetVideoInfo
 *		Set the video codec info to the recorded clip
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *		lpVideoInfo		[in]		the audio codec info
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_SetVideoInfo(MHandle hRecorderMgr, LPMV2VIDEOINFO lpVideoInfo); 


//////////////////callback function registeration///////////////////////

/**
 *	AMV_Recorder_RegisterRecorderCallback
 *		Register recorder callback function
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *		pRecorderCallback	[In]		the function point of recorder callback
 *		lUserData		[In]		user data which will be passed with callback function
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_RegisterRecorderCallback (MHandle hRecorderMgr, PFNMV2RECORDERCALLBACK pRecorderCallback, MLong lUserData ); 



///////////////////Recorder control///////////////////////////////////////

/**
 *	AMV_Recorder_Record
 *		Start to record for the created or paused clip
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_Record(MHandle hRecorderMgr); 	

/**
 *	Pause
 *		Pause the recorder
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_Pause(MHandle hRecorderMgr);


/**
 *	Stop
 *		Stop the recorder
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_Stop(MHandle hRecorderMgr); 	

/**
 *	Stop
 *		Set the preview status
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *		bTurnOn			[in]		whether turn on the preview
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		Before first turning on the preview , user should call SetConfig to set the preview parameter
 *				
 */
AMVAPI MRESULT AMV_Recorder_SetPreview(MHandle hRecorderMgr, MBool bTurnOn ); 

//////////////// recorder configuration ////////////////////////////////

/**
 *	SetConfig
 *		Set the specified configuation to recorder
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *		dwCfgType		[in]		the configuration type
 *		pValue			[in]		the value, and it is correlative to specfied configuration type
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_SetConfig(MHandle hRecorderMgr, MDWord dwCfgType , MVoid * pValue);

/**
 *	GetConfig
 *		Get the specified configuration of recorder
 *	
 *	Parameter:
 *		hRecorderMgr		[in]		Recorder manager handle created by AMV_Recorder_Initialize interface
 *		dwCfgType		[in]		the configuration type
 *		pValue			[out]		the value, and it is correlative to specfied configuration type
 *
 *	Return:
 *		MV2_ERR_NONE		success
 *		!MV2_ERR_NONE		fail
 *
 *	Remark:
 *		None
 *				
 */
AMVAPI MRESULT AMV_Recorder_GetConfig (MHandle hRecorderMgr, MDWord dwCfgType , MVoid * pValue);

#ifdef __cplusplus
}
#endif


#endif//_MV2RECORDER_INTERFACE_
