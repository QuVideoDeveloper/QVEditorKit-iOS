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
*---------------------------------------------------------------------------------------------*/

#ifndef __AMTIMER_H__
#define __AMTIMER_H__

#include "amcomdef.h"
#include "merror.h"

#ifdef __cplusplus
extern "C" {
#endif


typedef MVoid (*MTIMERPROC)(MVoid* pUserData);
MRESULT MTimerCreate(MHandle* phTimer);
MRESULT MTimerDestroy(MHandle hTimer);
MRESULT MTimerSet(MHandle hTimer, MDWord dwTimeElapsed, MTIMERPROC pfnTimerProc, MVoid* pUserData);
MRESULT MTimerSetEx(MHandle hTimer, MDWord dwTimeElapsed, MBool bRepeat, MTIMERPROC pfnTimerProc, MVoid* pUserData);
MRESULT MTimerCancel(MHandle hTimer);



#ifdef __cplusplus
  }
#endif

#endif 
