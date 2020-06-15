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
 * MV2PluginMgr.h
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

#ifdef __cplusplus
extern "C" {
#endif
    MRESULT MV2PluginMgr_Initialize(MHandle *phLog);
    
    MRESULT MV2PluginMgr_CreateInstance(MDWord dwModType, MDWord dwSubType, MHandle * phInstance);
    
    MRESULT MV2PluginMgr_ReleaseInstance(MDWord dwModType, MDWord dwSubType, MHandle hInstance);
    
    MRESULT MV2PluginMgr_Uninitialize(MHandle hLog);

	MRESULT MV2PluginMgr_SetHWDecLibPath(const MTChar* pszHWDecLib);

	MRESULT MV2PluginMgr_SetHWEncLibPath(const MTChar* pszHWEncLib);

	

#ifdef LOG_PERFORMANCE_PER
	MRESULT MV2WriteLog(MHandle hLog, MTChar *szSrc);
#endif //LOG_PERFORMANCE_PER
#ifdef __cplusplus
}
#endif

#endif	//_MV2PLUGINMGR_H_



 
