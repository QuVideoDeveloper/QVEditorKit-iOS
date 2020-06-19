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
 * IMV2Display.h
 *
 * Description:
 *
 *	The interface of display module in MVLIB2.0
 *
 *	This interface defines the video rendering functionality which displays the video frame on
 *	the screen of the different device. this module is device dependent. each implmentation
 * 	should inherit from this interface.
 *
 * History
 *    
 *  07.26.2004 Sheng Han(shan@arcsoft.com.cn )   
 * - initial version 
 *
 */


 #ifndef _IMV2DISPLAY_H_
 #define _IMV2DISPLAY_H_

 #include "mv2comdef.h"
 #include "amoperatornew.h"

class IMV2Display {
OVERLOAD_OPERATOR_NEW
public:
    IMV2Display() {};

    virtual ~IMV2Display() {};
	
	/**
	 *	Init
	 *		Initialize the display agent with the specifed parameter
	 *	
	 *	Parameter:
	 *		pDisplayParam			[in]		the parameter of the display
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *	
	 *	Remark:
	 *		the display parameter is an original one , the user can reset it using SetDisplayParam
	 *				
	 */
	virtual MRESULT Init(LPMV2DISPLAYPARAM pDisplayParam) = 0;

	/**
	 *	Uninit
	 *		Uninitialize the display agent and release resources
	 *	
	 *	Parameter:
	 *		None
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *	
	 *	Remark:
	 *				
	 */
	virtual MRESULT Uninit() = 0;


	/**
	 *	DrawFrame
	 *		Draw the frame on the display agent with the specified data and info
	 *	
	 *	Parameter:
	 *		pBuf					[in]			the buffer of frame
	 *		pFrameInfo			[in]			the info of the frame
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *	
	 *	Remark:
	 *				
	 */
	virtual MRESULT DrawFrame( MByte* pBuf , LPMV2FRAMEINFO pFrameInfo) = 0;

	/**
	 *	ShowDisplayOverlay
	 *		Turn on or off the display overlay 
	 *	
	 *	Parameter:
	 *		bShow				[in]			MTrue means turn on , MFalse means turn off
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *	
	 *	Remark:
	 *		it should be called when the pause of  the playback
	 *				
	 */
	virtual MRESULT ShowDisplayOverlay(MBool bShow) = 0;

	/**
	 *	SetDisplayParam
	 *		Set the parameter of display agent
	 *	
	 *	Parameter:
	 *		dwParamID				[in]			the type ID of the parameter
	 *		value					[in]			the parameter value for the specified type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *	
	 *	Remark:
	 *		
	 *				
	 */
	virtual MRESULT SetDisplayParam(MDWord dwParamID , MVoid * value) = 0;

	/**
	 *	GetDisplayParam
	 *		get the parameter of display agent
	 *	
	 *	Parameter:
	 *		dwParamID				[in]			the type ID of the parameter
	 *		value					[out]		the parameter value on return for the specified type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *	
	 *	Remark:
	 *		
	 *				
	 */
	virtual MRESULT GetDisplayParam(MDWord dwParamID , MVoid * value) = 0;
	
	/**
	 *	SetConfig
	 *		Set the specified configuration to displayer
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
	
 };
 






 #endif //_IMV2DISPLAY_H_

