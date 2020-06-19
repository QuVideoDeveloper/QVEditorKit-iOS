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

#ifndef _MV2_HIJACK_FUNCTION_H_
#define _MV2_HIJACK_FUNCTION_H_

#include "mv2functionanalysis.h"

#ifdef EN_ANALYSIS_STREAM_FUNCTION

	#ifdef MStreamOpenFromFile
		#undef MStreamOpenFromFile		
	#endif//MStreamOpenFromFile
	#define MStreamOpenFromFile 		MV2_MStreamOpenFromFile
	
	#ifdef MStreamRead
		#undef MStreamRead
	#endif//MStreamRead
	#define MStreamRead					MV2_MStreamRead

	#ifdef MStreamWrite
		#undef MStreamWrite
	#endif//MStreamWrite
	#define MStreamWrite				MV2_MStreamWrite

	#ifdef MStreamSeek
		#undef MStreamSeek
	#endif//MStreamSeek
	#define MStreamSeek					MV2_MStreamSeek
#endif//EN_ANALYSIS_STREAM_FUNCTION


#ifdef EN_ANALYSIS_MEM_FUNCTION
	#ifdef MMemCpy	
		#undef MMemCpy	
	#endif//MMemCpy	
	#define MMemCpy						MV2_MMemCpy

	#ifdef MMemAlloc	
		#undef MMemAlloc	
	#endif//MMemAlloc
	#define MMemAlloc					MV2_MMemAlloc
#endif//EN_ANALYSIS_MEM_FUNCTION

#endif//_MV2_HIJACK_FUNCTION_H_