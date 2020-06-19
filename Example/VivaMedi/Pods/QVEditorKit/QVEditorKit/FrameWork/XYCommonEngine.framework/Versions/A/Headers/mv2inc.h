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
 * MVInc.h
 *
 *	This file include common headfile file in MV2Lib
 * 	Notes: this file is just for internail using, DO NOT EXPORT TO SDK USER!!!!!!!
 * Code History 
 *    
 * -- 2004-07-28 Sh.F.Guo  (sguo@arcsoft.com.cn)
 * - initial version 
 *	from mvlib1.0
 *
 */
 
#ifndef _MV2INC_H_
#define _MV2INC_H_

#include "mv2platform.h"
#include "amplat.h"
#include "amcomdef.h"
#include "amstream.h"
#include "amstring.h"
#include "ammem.h"
#include "amutil.h"
#include "amini.h"
#include "amdebug.h"
#include "amoperatornew.h"


#include "mv2error.h"
#include "mv2comdef.h"
#include "mv2config.h"
#ifndef _PALM_OS_68K_
#include "mlog.h"
#include "mhelpfunc.h"
#endif //_PALM_OS_68K_
// declaration for platform independent 

#include "debug_android.h"
#include "amkernel.h"
#ifdef	_PALM_OS_
#undef 	MMemAlloc
#undef	MMemFree
#define MMemAlloc				MHugeMemAlloc
#define MMemFree				MHugeMemFree
#endif

#if defined(_WINCE_) || defined(__WIN32__)

#define     MVSleep				Sleep 

#define		MVWvsprintf			wvsprintf 
 
#elif defined (_PALM_OS_)
#define		MVWvsprintf			StrVPrintF 
#endif


#ifdef	__SYMBIAN32__


#endif

#include "mbenchmark.h"
#include "mv2hijackfunction.h"
#endif //_MV2INC_H_
