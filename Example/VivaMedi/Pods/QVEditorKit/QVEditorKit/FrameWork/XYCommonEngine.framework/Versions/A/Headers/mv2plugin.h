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
 * MV2Module.h
 *
 * Description:
 *
 *	The interface of modules access operations of MV2LIB2.0.
 *	Each module in MVLIB2.0 should implement this interface 
 *
 *
 * History
 *    
 *  07.27.2004 Sheng Han(shan@arcsoft.com.cn )   
 * - initial version 
 *
 */


#ifndef _MV2MODULE_H_
#define _MV2MODULE_H_
#include "amoperatornew.h"



#if defined ( _WINCE_) || defined(__WIN32__) || defined(__SYMBIAN32__)
	#ifdef PLUGINDLL_EXPORTS
	#define PLUGINDLL __declspec(dllexport)
	#else
	#define PLUGINDLL __declspec(dllimport)
	#endif
#else 
	#define PLUGINDLL
#endif
	
#ifdef __cplusplus
extern "C" {
#endif

PLUGINDLL	MRESULT		MV_GetPlugin(MHandle*);
PLUGINDLL	MRESULT		MV_ReleasePlugin(MHandle);

#ifdef __cplusplus
}
#endif


class IMV2Plugin {
OVERLOAD_OPERATOR_NEW
public:
	IMV2Plugin(){}
	virtual ~IMV2Plugin(){}


	/**
	 *	QueryType
	 *		Query whether the specified main type is supported
	 *	
	 *	Parameter:
	 *		dwModType			[in]		the plugin main type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			supported
	 *		MV2_ERR_NOT_FOUND		not supported
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT QueryType( MDWord dwModType) = 0;

	/**
	 *	QuerySubType
	 *		Query whether the specified sub type is supported
	 *	
	 *	Parameter:
	 *		dwModSubType			[in]		the plugin sub type
	 *
	 *	Return:
	 *		MV2_ERR_NONE			supported
	 *		MV2_ERR_NOT_FOUND		not supported
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT QuerySubType(MDWord dwModSubType) = 0;

	/**
	 *	CreateInstance
	 *		Create the instance by the specified main and sub type
	 *	
	 *	Parameter:
	 *		dwModType				[in]		the plugin main type
	 *		dwModSubType			[in]		the plugin sub type
	 *		phInstance				[out]	the instance on return if the specified plugin is found
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT CreateInstance(MDWord dwModType , MDWord dwModSubType , MHandle * phInstance) = 0;

	/**
	 *	ReleaseInstance
	 *		Release the specified  instance
	 *	
	 *	Parameter:
	 *		dwModType				[in]		the plugin main type
	 *		dwModSubType			[in]		the plugin sub type
	 *		hInstance				[in]		the specified  instance
	 *
	 *	Return:
	 *		MV2_ERR_NONE			success
	 *		!MV2_ERR_NONE			fail
	 *
	 *	Remark:
	 *		None
	 *				
	 */
	virtual MRESULT ReleaseInstance(MDWord dwModType , MDWord dwModSubType ,MHandle hInstance) = 0;
	

	
};


#endif	//_MV2MODULE_H_



 
