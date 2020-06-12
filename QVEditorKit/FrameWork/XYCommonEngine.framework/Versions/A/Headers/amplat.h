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


#ifndef __AMPLAT_H__
#define __AMPLAT_H__

#include "amcomdef.h"
#include "amstring.h"
#include "ammem.h"
#include "amstream.h"


#define		MDEBUGMASK_NONE			0x00000000
#define		MDEBUGMASK_MEMORY		0x00000001
#define		MDEBUGMASK_FILE			0x00000002

typedef struct __tag_plat_config
{
	MDWord	dwConfigSize;
	MDWord	dwFlag;
	MDWord	dwDebugMask;
	MVoid*	pDebugFile;
	MDWord	dwLogMask;
	MVoid*	pLogFile;
	MDWord	dwTraceMask;
}MPLATCONFIG, *LPMPLATCONFIG;

#ifdef __cplusplus
extern "C" {
#endif

MRESULT		MPlatInitialize(LPMPLATCONFIG);
MRESULT		MPlatUninitialize();

#ifdef __cplusplus
}
#endif


#endif

