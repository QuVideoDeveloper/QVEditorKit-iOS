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
 * imv2camera.h
 *
 * The interface of camera catpure module in MVLIB2.0
 *
 * In this file, the interface IMV2Camera has been defined. 
 * IMV2Camera is a abstract interface for camera. camera moudle should implement this interface
 *
 * Code History
 *    
 * --2004-07-23 Sh.F.Guo  (sguo@arcsoft.com.cn)
 * - initial version 
 * --2004-07-27 Sheng Han  (shan@arcsoft.com.cn)
 * - Review and modify 
 *
 */
 
#ifndef _IMV2CAMERA_INTERFACE_
#define _IMV2CAMERA_INTERFACE_

#include "mv2comdef.h"
#include "mv2timemgr.h"
#include "mv2cameraparam.h"
#include "amoperatornew.h"


class IMV2Camera
 { 
 OVERLOAD_OPERATOR_NEW
 public: 
	 IMV2Camera(){}
	 virtual ~IMV2Camera(){}

	 /*	Open 
	 * 
	 *	Description: 
	 *		Call this function to open the camera
	 *
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
		
	 virtual MRESULT Open() = 0;

 
	 /*	Close 
	 * 
	 *	Description: 
	 *		Call this function to close the camera  
	 *
	 *Parameters: 
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT Close(  ) =0; 



	 /* SetCamParam 
	 * 
	 *	Description: 
	 *		Call this function to set the param for the camera. 
	 *
	 *	Parameters: 
	 *		pCamParam : 	[in] 			Pointer to the param to set the camera param.
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */

	virtual MRESULT SetCamParam(LPMV2CAMERAPARAM pCamParam) = 0 ;

 
	 /*	SetPreviewParam 
	 * 
	 *	Description: 
	 *		Call this function to set the relative param with the camera preview. 
	 *
	 *	Parameters: 
	 *		pCamParam : 	[in] 			Pointer to the param to set the preview param.
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT SetPreviewParam(LPMV2PREVIEWPARAM pPreviewParam) = 0 ;

	 /*	SetProperty 
	 * 
	 *	Description: 
	 *		Call this function to set the property(such whitebalance,brightness,
	 * 		contrastness, zoom, ...) for the camera .
	 *
	 *	Parameters: 
	 *		pCamProperty 		[in]			pointer to the MV2CAMERAPROPERTY  structure to set the camera's property
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
 
	 virtual MRESULT SetProperty( LPMV2CAMERAPROPERTY pCamProperty ) =0 ; 

	 /*	GetProperty 
	 * 
	 *	Description: 
	 *		Call this function to get the property(such whitebalance,brightness,
	 * 		contrastness, zoom, ...) from the camera .
	 *
	 *	Parameters: 
	 *		pCamProperty 		[out]		pointer to the MV2CAMERAPROPERTY  structure to receive  the camera's property
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
 
	 virtual MRESULT GetProperty( LPMV2CAMERAPROPERTY pCamProperty ) =0 ; 

	 /*	ShowPreview 
	 * 
	 *	Description: 
	 *		Call this function to set the preview On/Off  .
	 *
	 *	Parameters: 
	 *		bShow 			[in] 				MTrue to set preview on,MFalse to set the preview off
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT ShowPreview( MBool bShow ) =0 ; 


	 /* VideoStreamStart 
	 * 
	 *	Description: 
	 *		Call this function to start video stream recording
	 *
	 *	Parameters: 
	 *		
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
 
	 virtual MRESULT VideoStreamStart (  ) = 0 ; 

	 /* VideoStreamPause 
	 * 
	 *	Description: 
	 *		Call this function to pause video stream recording
	 *
	 *	Parameters: 
	 *		
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
 
	 virtual MRESULT VideoStreamPause(  ) = 0 ; 

	 /* VideoStreamStop 
	 * 
	 *	Description: 
	 *		Call this function to stop video stream recording
	 *
	 *	Parameters: 
	 *		
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	 virtual MRESULT VideoStreamStop(  ) = 0 ; 


	/* CaptureFrame 
	 * 
	 *	Description: 
	 *		Call this function to capture one video frame data, the data format is YUV4:1:1 
	 *
	 *	Parameters: 
	 *		ppFrameBuf			[in/out] 		pointer to the pointer of the buffer contain captured video frame data 
	 *		lpFrameInfo 			[out]    		pointer to info of the captured frame 
	 * 
	 *		pdwFrameTimeStamp   [out]			to record this frame's time stamp
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */
	  virtual MRESULT CaptureFrame(MByte **ppFrameBuf, LPMV2FRAMEINFO lpFrameInfo,MDWord * pdwFrameTimeStamp) = 0; 

	/////////////////the following interfaces for still image capture/////////////////////
	 
	 /* StillImageQuery 
	 * 
	 *	Description: 
	 *		this function is used to query image capture parameters.
	 *
	 *	Parameters: 
	 *		pCamImage :	 		[out] 		pointer to camera image struct.  
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 * Remark:
	 *  this function should be called before StillImageCapture, dwType and lImageSize will be
	 *  returned in pCamImage, application should allocate pValue in pCamImage according to them.
	 *
	 */		 				
 
	 virtual MRESULT StillImageQuery( LPMV2CAMERAIMAGE pCamImage) = 0 ;

	 /* StillImageCapture 
	 * 
	 *	Description: 
	 *		this function is used to capture image. 
	 *
	 *	Parameters: 
	 *		pCamImage :	 		[in/out] 		pointer to camera image  struct.  
	 * 
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 * Remark:
	 *  captured raw image data will be filled in pValue in pCamImage on success.
	 *
	 */ 
	  virtual MRESULT StillImageCapture(LPMV2CAMERAIMAGE pCamImage) = 0; 

	 /*	StillImageDump 
	 * 
	 *	Description: 
	 *		this function is used to dump captured image data to a specified JPEG file. 
	 *
	 *  Parameters: 
	 *		pDstFilePath :	 		[in] 			pointer to the full file path of captured image, file type is JPEG.  
	 * 
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 */ 
 
	 virtual MRESULT StillImageDump(MPVoid pDstFilePath) = 0 ; 

	 virtual MVoid SetTimeMgr(CMV2TimeMgr *pTimeMgr){};
}; 

#endif //_IMV2CAMERA_INTERFACE_
