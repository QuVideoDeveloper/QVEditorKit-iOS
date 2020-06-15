/*
*
* History
*    
* 2015/08/25, yxiong
* - Init version.
*
*/
#ifndef _QVET_TPM_ENGINE_H_
#define _QVET_TPM_ENGINE_H_

#define QVET_TPM_TYPE_DIVA		1

#ifdef __cplusplus
extern "C"
{
#endif

	//the interfaces for template_param, TPM=template_param
	MRESULT QVTPM_Create(MHandle hSessionCtx, MTChar* szTemplateFile, MLong lCfgIndex, MSIZE* pResolution, MHandle* phMaker);

	MRESULT QVTPM_Refresh(MHandle hMaker);

	MRESULT QVTPM_GetData(MHandle hMaker, MByte* pData, MDWord* pdwDataLen);

	MRESULT QVTPM_GetObject(MHandle hMaker, MHandle* phObject);

	MRESULT QVTPM_Destroy(MHandle hMaker);

#ifdef __cplusplus
}
#endif

#endif // _QVET_TPM_ENGINE_H_
