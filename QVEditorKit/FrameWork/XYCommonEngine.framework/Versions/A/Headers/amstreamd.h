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

#ifndef __AMSTREAMD_H__
#define __AMSTREAMD_H__

#include "amcomdef.h"


#ifdef __cplusplus
extern "C" {
#endif

HMSTREAM	MStreamFileCreateS_Debug(const MVoid* file_para, const MChar* szFileName, MLong lLine);
HMSTREAM	MStreamFileCreateW_Debug(const MVoid* file_para, const MChar* szFileName, MLong lLine);

HMSTREAM	MStreamOpenFromFileS_Debug(const MVoid *file_para, MWord mode, \
									   const MChar* szFileName, MLong lLine);
HMSTREAM	MStreamOpenFromFileW_Debug(const MVoid *file_para, MWord mode, \
									   const MChar* szFileName, MLong lLine);

HMSTREAM	MStreamOpenFromMemoryBlock_Debug(MVoid* pMem, MLong lMemSize, \
											 const MChar* szFileName, MLong lLine);

HMSTREAM	QStreamOpenFromStreamBlock_Debug(HMSTREAM hStream, MLong lPos,  MLong lLength, \
											 const MChar* szFileName, MLong lLine);

MBool		MStreamClose_Debug(HMSTREAM hStream, const MChar* szFileName, MLong lLine);

MLong		MStreamRead_Debug(HMSTREAM stream_handle, MPVoid buf, MLong size, \
							  const MChar* szFileName, MLong lLine);

MLong		MStreamWrite_Debug(HMSTREAM stream_handle, MPVoid buf, MLong size, \
							   const MChar* szFileName, MLong lLine);

MLong		MStreamSeek_Debug(HMSTREAM stream_handle, MShort start, MLong offset, \
							  const MChar* szFileName, MLong lLine);

MLong		MStreamTell_Debug(HMSTREAM hStream, const MChar* szFileName, MLong lLine);

MLong		MStreamGetSize_Debug(HMSTREAM hStream, const MChar* szFileName, MLong lLine);


#ifdef M_DEBUG
#define	MStreamFileCreateS(file_para)				MStreamFileCreateS_Debug((file_para), __FILE__, __LINE__)
#define	MStreamFileCreateW(file_para)				MStreamFileCreateW_Debug((file_para), __FILE__, __LINE__)
#define	MStreamOpenFromFileS(file_para, mode)		MStreamOpenFromFileS_Debug((file_para), (mode), __FILE__, __LINE__)
#define	MStreamOpenFromFileW(file_para, mode)		MStreamOpenFromFileW_Debug((file_para), (mode), __FILE__, __LINE__)
#define	MStreamOpenFromMemoryBlock(pMem, lMemSize)	MStreamOpenFromMemoryBlock_Debug((pMem), (lMemSize), __FILE__, __LINE__)
#define MStreamClose(hStream)						MStreamClose_Debug((hStream), __FILE__, __LINE__)
#define	MStreamRead(hStream, buf, lSize)			MStreamRead_Debug((hStream), (buf), (lSize), __FILE__, __LINE__)
#define	MStreamWrite(hStream, buf, lSize)			MStreamWrite_Debug((hStream), (buf), (lSize), __FILE__, __LINE__)
#define	MStreamSeek(hStream, start, offset)			MStreamSeek_Debug((hStream), (start), (offset), __FILE__, __LINE__)
#define MStreamTell(hStream)						MStreamTell_Debug((hStream), __FILE__, __LINE__)
#define	MStreamGetSize(hStream)						MStreamGetSize_Debug((hStream), __FILE__, __LINE__)
#define QStreamOpenFromStreamBlock(hStream, lPos, lLength) QStreamOpenFromStreamBlock_Debug((hStream), (lPos), (lLength), __FILE__, __LINE__)

#endif

#ifdef __cplusplus
}
#endif

#endif
