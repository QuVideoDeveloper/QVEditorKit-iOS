#ifndef _MV2FUNCTIONANALYSIS_H_
#define _MV2FUNCTIONANALYSIS_H_

#include "amcomdef.h"

typedef struct _tag_FunctionAnalysis
{
	MDWord dwCbSize;	//struct bytes size,because parameter is variant
	MDWord dwFuncID;	//function ID
	MDWord dwTimestamp;	// timestamp  of funcntio called
	MDWord dwParams[1];	//dwParam[] is variant size	array
	/*	
	parameter format,per-parameter be storaged as 32bits
	param 1: 1th parameter of function 
	param 2: 2th parameter of function
	...
	param n
	return value: storage value of function,if not return value,do not recoder this parameter to file
	other info for need to analysis.
	parameter count = (dwCbSize - 4(dwCbSize) - 4(dwFucID) - 4(dwTimestamp))/4 
	*/
}MV2_FUNCTION_ANALYSIS, *LPMV2_FUNCTION_ANALYSIS;


#define FUNCTION_ANALYSIS_STRUCT_MIM_COUNT		3		//dwCbSize,dwFuncID,dwTimestamp
#ifdef __cplusplus
extern "C"
{
#endif//__cplusplus

	//analysis for Stream operation
	MVoid* MV2_MStreamOpenFromFile(const MVoid *file_para, MWord mode);
	MLong MV2_MStreamRead(MVoid* stream_handle, MPVoid buf, MLong size);
	MLong MV2_MStreamWrite(MVoid* stream_handle, MPVoid buf, MLong size);
	MLong MV2_MStreamSeek(MVoid* stream_handle, MShort start, MLong offset);

	//analysis for for mem operation
	MVoid* MV2_MMemAlloc(MHandle hContext, MLong size);	
	MVoid MV2_MMemCpy(MPVoid dst, const MVoid* src, MLong size);
#ifdef __cplusplus
}
#endif// __cplusplus

#endif//_MV2FUNCTIONANALYSIS_H_