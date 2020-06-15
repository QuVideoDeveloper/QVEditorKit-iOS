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

#ifndef __AMMEMD_H__
#define __AMMEMD_H__

#include "amcomdef.h"

#ifdef __cplusplus
extern "C" {
#endif


MVoid*	MMemAlloc_Debug(MHandle hContext, MLong lSize, const MChar* szFileName, MLong lLine);

MVoid*	MMemRealloc_Debug(MHandle hContext, MVoid* pMem, MLong lSize, const MChar* szFileName, MLong lLine);

MVoid	MMemFree_Debug(MHandle hContext, MVoid* pMem, const MChar* szFileName, MLong lLine);

MVoid	MMemCpy_Debug(MVoid* dst, const MVoid* src, MLong lSize, const MChar* szFileName, MLong lLine);

MVoid	MMemMove_Debug(MVoid* dst, MVoid* src, MLong lSize, const MChar* szFileName, MLong lLine);

MVoid	MMemSet_Debug(MVoid* pMem, MByte byVal, MLong lSize, const MChar* szFileName, MLong lLine);


#ifdef M_DEBUG

#define MMemAlloc(hContext, lSize)			MMemAlloc_Debug((hContext), (lSize), __FILE__, __LINE__)
#define MMemFree(hContext, pMem)			MMemFree_Debug((hContext), (pMem), __FILE__, __LINE__)
#define	MMemRealloc(hContext, pMem, lSize)	MMemRealloc_Debug((hContext), (pMem), (lSize), __FILE__, __LINE__)
#define	MMemCpy(dst, src, lSize)			MMemCpy_Debug((dst), (src), (lSize), __FILE__, __LINE__)
#define	MMemMove(dst, src, lSize)			MMemMove_Debug((dst), (src), (lSize), __FILE__, __LINE__)
#define	MMemSet(pMem, byVal, lSize)			MMemSet_Debug((pMem), (byVal), (lSize), __FILE__, __LINE__)

#endif

#ifdef __cplusplus
}
#endif

#endif//	__AMMEMD_H__
