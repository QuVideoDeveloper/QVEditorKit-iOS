#ifndef _MV2PLATFORM_H_
#define _MV2PLATFORM_H_

#define _PLATFORM_V2_
#ifdef   _PLATFORM_V2_

//*********************amplat.h*******************************
#if !defined(__SYMBIAN32__) && !defined(__WIN32__) && !defined(_BREW_OS_) && !defined(_PALM_OS_) && !defined(_WINCE_) && !defined(_PURE_ADS_) && !defined(_LINUX_) && !defined(_CUST_PLAT_) && !defined(_AGERE_)
#error Please specify a platform!
#endif
#if !defined(M_WIDE_CHAR) && defined(_WINCE_)
#error Please add macro M_WIDE_CHAR to your project setting!
#endif

#ifdef __SYMBIAN32__
#ifdef __cplusplus
#include <e32def.h>
#include <e32std.h>
#include <f32file.h> 
#include <sys\unistd.h> 
#include <coeutils.h>
#include <eikfutil.h>
#endif
#include "stddef.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#endif

#ifdef _PALM_OS_
#include <Palmos.h>
#include <VFSMgr.h>
#include <sys_types.h>
typedef UInt32 LocalID;
#endif

#ifdef _WINCE_
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <windows.h>
#endif

#ifdef __WIN32__
#include <stdio.h>
#include <stdlib.h>
#ifndef __USING_SOCKET__
#include <windows.h>
#endif
#include <tchar.h>
#endif

#ifdef _BREW_OS_
#include "AEEStdLib.h"
#endif

#if	defined(_PURE_ADS_)
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#endif

#if	defined(_CUST_PLAT_)
#endif

#ifdef	_LINUX_
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#ifdef M_WIDE_CHAR
#include <wchar.h>
#endif
#endif

#ifdef	_AGERE_
#ifdef __cplusplus
extern "C" {
#endif
#include "portab.h"
#include "sysprim.h"
#include "syslib.h"
#include "uiftimer.h"
#include "hfs.h"
#ifdef __cplusplus
}
#endif
#endif
//*********************end of amplat.h*******************************


//*********************amcomdef.h*******************************
#ifndef MDIR_CHAR
	#if  defined (_BREW_OS_) || defined (_PALM_OS_) || defined (_LINUX_) || defined(_AGERE_)
		#define MDIR_CHAR  '/'
		#define MDIR_STR   _MMT("/")
	#elif  defined (_WINCE_) || defined(__WIN32__) || defined(__SYMBIAN32__) || defined(_PURE_ADS_) || defined(_CUST_PLAT_)
		#define MDIR_CHAR  '\\'
		#define MDIR_STR   _MMT("\\")
	#endif
#endif

typedef unsigned char		MEnum8;
typedef unsigned short		MEnum16;
typedef char				MSignedEnum8;
typedef short				MSignedEnum16;

#ifndef _BREW_OS_
	#ifndef	MAX
		#define MAX(x,y) (((x)>=(y))?(x):(y))
	#endif
	#ifndef	MIN
		#define MIN(x,y) (((x)<=(y))?(x):(y))
	#endif
#endif

#define CCPY(_pc1,_cpc2) (*(_pc1) = *(_cpc2))
//*********************end of amcomdef.h*******************************


//*********************amstream.h*******************************
//replace with MStreamFileExists
#ifdef		M_WIDE_CHAR 
	#define	MStreamIsFileExist		MStreamFileExistsW
#else
	#define	MStreamIsFileExist		MStreamFileExistsS
#endif 

#endif  //_PLATFORM_V2_

//*********************end of amstream.h*******************************

#endif	//_MV2PLATFORM_H_