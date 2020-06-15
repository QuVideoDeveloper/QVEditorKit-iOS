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


//Created by DCH for output debug info.

#ifndef __DEBUG_ANDROID_H__
#define __DEBUG_ANDROID_H__


//#define ENABLE_LOGGER_LEVEL_0_0	//LOGGER0_0 is use-free for all the log, you can use it at anywhere you want


/***************************************************************
*	This log-level is planned by jgong@2012.06.05
*	All the log-level has not been applied to mvlib and ve-sessioncore.
*	But it will be done someday in the future.....
****************************************************************/

/*
*	ENABLE_LOGGER_LEVEL_1_X  is the log-level which is related to mvlib
*/
//#define ENABLE_LEVEL_LOGGER1_1	//stream                 log  in mvlib
//#define ENABLE_LEVEL_LOGGER1_2	//codec and filelayer log in mvlib
//#define ENABLE_LEVEL_LOGGER1_3 //play-engine           log in mvlib
//#define ENABLE_LEVEL_LOGGER1_4	//streamsink and streamsource         log in mvlib
//extend the log level by yourself here.....

/*
*	ENABLE_LOGGER_LEVEL_2_X  is the log-level which is related to ve-sessioncore
*/
//#define ENABLE_LOGGER_LEVEL_2_1
//#define ENABLE_LOGGER_LEVEL_2_2
//#define ENABLE_LOGGER_LEVEL_2_3
//extend the log level by yourself here.....


#ifdef  ENABLE_LOGGER_LEVEL_0_0
	#ifdef __cplusplus
	extern "C" 
	{
	#endif
		#if defined(WIN32)
 			#define LOGGER00
			#define LOGERR00
			#define LOG_FUNCTION_NAME
		#else
			#include "qvlog.h"
			#define LOG_FUNCTION_NAME    //LOGD(" %s#Calling %s()#\r\n",  __FILE__,  __FUNCTION__);
			#define LOG_NDEBUG 0
			#define LOG_TAG "VE_ADK_LOG"
			#define LOGGER00	LOGD
			#define LOGERR00	LOGE
		#endif
	#ifdef __cplusplus
	}
	#endif

#else
	#define LOGGER00
	#define LOGERR00
	#define LOG_FUNCTION_NAME
#endif //ENABLE_LOGGER



#endif //__DEBUG_LOG_H__
