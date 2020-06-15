
#ifndef		__QVPK_PACKER_INTERFACE_H_H
#define		__QVPK_PACKER_INTERFACE_H_H 

#include "amstream.h"
#include "amstring.h"
#include "ampkpackerhead.h"



/************************************************************************

|-------------------|
| Package Header    |---------------> AMPK_PACKAGE_HEADER_TYPE
|-------------------|
| Package info      |
|-------------------|
| File_1 info       |-----|
|-------------------|     |
| File_2 info       |     |       
|-------------------|     |---------> QVET_PACKAGE_ITEM_INFO       
| ......            |     |
|-------------------|     | 
| File_n info       |     |
|-------------------|-----|
| File_1 data       |
|-------------------|
| File_2 data       |
|-------------------|
| .......           |
|-------------------|
| File_n data       |
|-------------------|

************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

/*the interfaces for packer*/
MRESULT QVPK_CreatePacker(const MVoid *pPackageFile, MVoid *pPkgInfo, MDWord dwInfoSize, \
						  MDWord dwFileCount, MDWord dwFileVersion, MHandle *phPacker/*out*/);

MRESULT QVPK_DestroyPacker(MHandle hPacker);

MRESULT QVPK_AddFile(MHandle hPacker, MVoid *pFile, MDWord dwFormat, MDWord dwFileId, MDWord dwEncrypt);

MRESULT QVPK_AddFileStream(MHandle hPacker, HMSTREAM hFileStream, MDWord dwFormat, MDWord dwFileId, MDWord dwEncrypt);

MRESULT QVPK_AddFileWithMemory(MHandle hPacker, MVoid *pMemory, MDWord dwMemorySize, MDWord dwFormat, MDWord dwFileId, MDWord dwEncrypt);


/*the interfaces for unpacker*/
MRESULT QVPK_CreateUnpacker(MHandle hStream, MHandle *phUnpacker/*out*/);

MRESULT QVPK_DestroyUnpacker(MHandle hUnpacker);

MRESULT QVPK_GetPackageHeader(MHandle hUnpacker, QVET_PACKAGE_HEADER* pHeader/*out*/);

MRESULT QVPK_GetPackageInfo(MHandle hUnpacker, MVoid * pInfo/*out*/, MDWord *pdwInfoSize/*out*/);

MRESULT QVPK_GetFileInfo(MHandle hUnpacker, MDWord dwFileId, QVET_PACKAGE_ITEM_INFO * pInfo/*out*/);

MRESULT QVPK_ExtractToFile(MHandle hUnpacker, MDWord dwFileId, const MVoid *pOutFile/*in*/);

MRESULT QVPK_ExtractToMemory(MHandle hUnpacker, MDWord dwFileId, MVoid *pMemory/*out*/, MDWord *pdwMemSize/*in,out*/);

MRESULT QVPK_IsSerialNoValid(MHandle hUnpacker, MByte *pszSerialNo, MLong lSerailLen, MBool *pbValid);

/*MRESULT QVPK_CreateUnPackerStreamOperator(MHandle hUnpacker, MDWord dwFileId, MHandle *phOperator);

MRESULT QVPK_ReadDataByUnPackerStreamOperator(MHandle hUnpacker, MHandle hOperator, MVoid *pData, MDWord dwDataLen);

MRESULT QVPK_DestroyUnPackerStreamOperator(MHandle hUnpacker, MHandle hOperator);*/

MRESULT QVPK_BuildMd5Key(MByte* pData, MLong lDataSize, MByte* pSerialNo, MLong lSerailLen, MD5ID* pKey);

//DetachFile has defect due to the MStream platform lib
//MRESULT QVPK_DetachFile(MHandle hUnpacker, MDWord dwFileId, MVoid *pOutFile/*out*/);

/*
*	dwMD5Type:
*		QVPK_MD5TYPE_TC or QVPK_MD5TYPE_TV
*/
MRESULT QVPK_AddMd5ToTemplate(MTChar *pszTemplateFile, MDWord dwMD5Type, MD5ID *pMD5);	//dwMD5Type: QVET_STYLE_MD5TYPE_XXXX

#ifdef __cplusplus
}
#endif


#endif //end of the AMPKPackerInterface.h 

