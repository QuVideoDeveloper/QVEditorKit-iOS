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
 * mv2pluginmgr.h
 *
 * Description:
 *
 *	
 *	
 *
 *
 * History
 *    
 *  07.30.2004 Junming Lv 
 * - initial version 
 *
 */


#ifndef _MV2PLUGINMGR_H_
#define _MV2PLUGINMGR_H_

#if defined ( _WINCE_) || defined(__WIN32__) || defined(__SYMBIAN32__)
	#ifdef PLUGINMGRLL_EXPORTS
	#define PLUGINMGRDLL_API __declspec(dllexport)
	#else
	#define PLUGINMGRDLL_API __declspec(dllimport)
	#endif
#else 
	#define PLUGINMGRDLL_API
#endif

#ifdef __cplusplus
extern "C" {
#endif
PLUGINMGRDLL_API MRESULT MV2PluginMgr_Initialize(MHandle *phLog);

PLUGINMGRDLL_API MRESULT MV2PluginMgr_CreateInstance(MDWord dwModType, MDWord dwSubType, MHandle * phInstance);

PLUGINMGRDLL_API MRESULT MV2PluginMgr_ReleaseInstance(MDWord dwModType, MDWord dwSubType, MHandle hInstance);

PLUGINMGRDLL_API MRESULT MV2PluginMgr_Uninitialize(MHandle hLog);


PLUGINMGRDLL_API MRESULT MV2PluginMgr_SetHWDecLibPath(const MTChar* pszHWDecLib);

PLUGINMGRDLL_API MRESULT MV2PluginMgr_SetHWEncLibPath(const MTChar* pszHWEncLib);


#ifdef LOG_PERFORMANCE_PER
PLUGINMGRDLL_API MRESULT MV2WriteLog(MHandle hLog, MTChar *szSrc);
#endif //LOG_PERFORMANCE_PER
#ifdef __cplusplus
}
#endif

#endif	//_MV2PLUGINMGR_H_



 
