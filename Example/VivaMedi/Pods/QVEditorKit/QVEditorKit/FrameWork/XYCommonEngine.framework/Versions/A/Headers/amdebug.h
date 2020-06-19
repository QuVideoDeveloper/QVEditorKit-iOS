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

#ifndef __AMDEBUG_H__
#define __AMDEBUG_H__


#include "amcomdef.h"


typedef struct __tag_log_config
{
	MDWord	dwConfigSize;
	MBool	bLogEnable;
	MBool	bBufferable;
	MDWord	dwMask;
}MLOGCONFIG, *LPMLOGCONFIG;

#ifdef __cplusplus
extern "C" {
#endif


#ifdef M_WIDE_CHAR
	#define MTRACE				MTRACEW
	#define MLOGOPEN			MLOGOPENW
	#define MLOG				MLOGW
#else
	#define MTRACE				MTRACES
	#define MLOGOPEN			MLOGOPENS
	#define MLOG				MLOGS
#endif


#ifdef M_TRACE
	#define	MTRACES					MTraceS
	#define	MTRACEW					MTraceW
#else
	#ifdef __cplusplus
		extern __inline	MVoid MTraceVoidS(MDWord, MChar *, ...){}
		extern __inline	MVoid MTraceVoidW(MDWord, MWChar *, ...){}
	#else
		#if	defined(__GCC32__) || defined(__GCCE__) || defined(__GNUC__)
			static __inline	MVoid MTraceVoidS(MDWord dwMask, MChar *szFormat, ...){}
			static __inline	MVoid MTraceVoidW(MDWord dwMask, MWChar *szFormat, ...){}
		#else
			extern __inline	MVoid MTraceVoidS(MDWord dwMask, MChar *szFormat, ...){}
			extern __inline	MVoid MTraceVoidW(MDWord dwMask, MWChar *szFormat, ...){}
		#endif
	#endif	
	#define	MTRACES					MTraceVoidS
	#define	MTRACEW					MTraceVoidW
#endif

#ifdef	M_ASSERT
	#define MASSERT				MAssert
#else
	#define MASSERT(x)		((MVoid)0)
#endif

#ifdef M_LOG
	#define MLOGOPENS			MLogOpenS
	#define MLOGOPENW			MLogOpenW
	#define MLOGCLOSE			MLogClose
	#define	MLOGS				MLogS
	#define	MLOGW				MLogW
	#define MLOGDUMP			MLogDump
	#define	MLOGFLUSH			MLogFlush
	#define	MLOGSETCONFIG		MLogSetConfig
	#define MLOGGETCONFIG		MLogGetConfig
#else
	#ifdef __cplusplus
		extern __inline	MVoid MLogVoidS(MHandle, MDWord, MChar *, ...){}
		extern __inline	MVoid MLogVoidW(MHandle, MDWord, MWChar *, ...){}
	#else
		#if	defined(__GCC32__) || defined(__GCCE__) || defined(__GNUC__)
			static __inline	MVoid MLogVoidS(MHandle hLog, MDWord dwMask, MChar *szFormat, ...){}
			static __inline	MVoid MLogVoidW(MHandle hLog, MDWord dwMask, MWChar *szFormat, ...){}
		#else
			extern __inline	MVoid MLogVoidS(MHandle hLog, MDWord dwMask, MChar *szFormat, ...){}
			extern __inline	MVoid MLogVoidW(MHandle hLog, MDWord dwMask, MWChar *szFormat, ...){}
		#endif
	#endif
	#define MLOGOPENS(p,pp)		((MVoid)0)
	#define MLOGOPENW(p,pp)		((MVoid)0)
	#define MLOGCLOSE(h)			((MVoid)0)
	#define MLOGDUMP(h,d,p,l)		((MVoid)0)
	#define	MLOGFLUSH(h)			((MVoid)0)
	#define	MLOGSETCONFIG(h,p)		((MVoid)0)
	#define MLOGGETCONFIG(H,p)		((MVoid)0)
	#define	MLOGS					MLogVoidS
	#define	MLOGW					MLogVoidW
#endif


MVoid		MTraceS(MDWord dwMask, MChar *szFormat, ...);
MVoid		MTraceW(MDWord dwMask, MWChar *szFormat, ...);
MVoid		MAssert(MLong expression);
MVoid		MLogOpenS(MVoid* szLogFile, MHandle *phLog);
MVoid		MLogOpenW(MVoid* szLogFile, MHandle *phLog);
MVoid		MLogClose(MHandle hLog);
MVoid		MLogS(MHandle hLog, MDWord dwMask, MChar* szFormat, ...);
MVoid		MLogW(MHandle hLog, MDWord dwMask, MWChar* szFormat, ...);
MVoid		MLogDump(MHandle hLog, MDWord dwMask, MVoid* pData, MLong lBufLen);
MVoid		MLogFlush(MHandle hLog);
MVoid		MLogSetConfig(MHandle hLog, MLOGCONFIG* pLogConfig);
MVoid		MLogGetConfig(MHandle hLog, MLOGCONFIG* pLogConfig);



























/*********************************************************************************
**********************************************************************************
**************Removed following functions which have been deprecated**************
**********************************************************************************
**********************************************************************************/


#ifdef M_DEBUG
#define MLOGGERRESTART			MLoggerRestart
#define MLOGGER					MLogger
#define MLOGGERSTR				MLoggerStr
#define MLOGGERINT				MLoggerInt
#define MLOGGERINTASHEX			MLoggerIntAsHex
#define MLOGGERDATA				MLoggerData
#define MLOGGERPROCSTART		MLoggerProcessStart
#define MLOGGERPROCEND			MLoggerProcessEnd
#else
#ifdef __cplusplus
#if defined(__IPHONE__)
static __inline	MVoid MLoggerVoid(MTChar *, ...){}
#else
extern __inline	MVoid MLoggerVoid(MTChar *, ...){}
#endif
#else
#if defined(__IPHONE__)
static __inline	MVoid MLoggerVoid(MTChar * szFormat, ...){}
#else
extern __inline	MVoid MLoggerVoid(MTChar * szFormat, ...){}
#endif
#endif
#define MLOGGERRESTART()		((void)0)
#define MLOGGER					MLoggerVoid
#define MLOGGERSTR(p)			((void)0)
#define MLOGGERINT(n)			((void)0)
#define MLOGGERINTASHEX(n)		((void)0)
#define MLOGGERDATA(p,n)		((void)0)
#define MLOGGERPROCSTART(p)		0
#define MLOGGERPROCEND(p,n)		((void)0)
#endif
MVoid	MLoggerRestart();
MVoid	MLogger(MTChar * szFormat  , ...);
MVoid	MLoggerStr(MTChar * szStr);
MVoid	MLoggerInt(MLong nInt);
MVoid	MLoggerIntAsHex(MLong nInt);
MVoid	MLoggerData(MVoid* pData , MLong nDataBuf);
MDWord	MLoggerProcessStart(MTChar * szMsg);
MVoid	MLoggerProcessEnd(MTChar * szMsg , MDWord dwStartTimestamp);

#define AMASSERT(x) 	((MVoid)0)

#ifdef __cplusplus
}
#endif


#endif

