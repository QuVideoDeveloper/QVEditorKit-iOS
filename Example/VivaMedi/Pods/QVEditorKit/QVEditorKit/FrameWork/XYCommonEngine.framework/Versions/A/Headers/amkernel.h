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
	
#ifndef __AMKENREL_H__
#define __AMKENREL_H__

#include "amcomdef.h"
#include "merror.h"

#ifndef MWAIT_INFINITE
#define MWAIT_INFINITE		(~0)
#endif


#define MTHREAD_PRIORITY_NORMAL					0
#define MTHREAD_PRIORITY_ABOVE_NORMAL			1
#define MTHREAD_PRIORITY_HIGHEST				2
#define MTHREAD_PRIORITY_BELOW_NORMAL		   -1
#define MTHREAD_PRIORITY_BELOW_LOWEST		   -2

		 
#ifdef __cplusplus
extern "C" {
#endif


MHandle		MMutexCreate();
MRESULT		MMutexDestroy(MHandle hMutex);
MRESULT		MMutexLock(MHandle hMutex);
MRESULT		MMutexUnlock(MHandle hMutex);
 

MHandle		MEventCreate(MBool bAutoReset);
MRESULT		MEventDestroy(MHandle hEvent);
MRESULT		MEventWait(MHandle hEvent, MDWord dwTimeOut);
MRESULT		MEventSignal(MHandle hEvent);
MRESULT		MEventReset(MHandle hEvent);



MHandle		MSemCreate(MVoid* pSemName, MLong lInitCount, MLong lMaxCount);
MRESULT		MSemWait(MHandle hSem);
MRESULT		MSemRelease(MHandle hSem);
MRESULT		MSemDestroy(MHandle hSem);


typedef		MDWord	(*MThreadProc)(MVoid* lpPara);
MHandle		MThreadCreate(MThreadProc proc, MVoid* lpPara);
MHandle		MThreadCreateEx(MChar* szThreadName, MThreadProc proc, MVoid* lpPara);
MRESULT		MThreadDestory(MHandle hThread);
MRESULT		MThreadExit(MHandle hThread);
MRESULT		MThreadSleep(MHandle hThread, MDWord dwMilliseconds);
MRESULT		MThreadResume(MHandle hThread);
MRESULT		MThreadSuspend(MHandle hThread);
MRESULT		MThreadSetPriority(MHandle hThread, MLong lPriority);


MDWord		MGetCurTimeStamp();
MDWord		MGetCurTimeStampHiRes();

#ifdef __cplusplus
}
#endif


#endif

