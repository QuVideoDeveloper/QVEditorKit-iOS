/*******************************************************************************
 
Copyright(c) ArcSoft, All right reserved.
 
This file is ArcSoft's property. It contains ArcSoft's trade secret, proprietary 
and confidential information. 
 
The information and code contained in this file is only for authorized ArcSoft 
employees to design, create, modify, or review.
 
DO NOT DISTRIBUTE, DO NOT DUPLICATE OR TRANSMIT IN ANY FORM WITHOUT PROPER 
AUTHORIZATION.
 
If you are not an intended recipient of this file, you must not copy, 
distribute, modify, or take any action in reliance on it. 
 
If you have received this file in error, please immediately notify ArcSoft and 
permanently delete the original and any copy of any file and any printout 
thereof.
 
*******************************************************************************/
#ifndef __ARCSOFT_AMDRM_H__
#define __ARCSOFT_AMDRM_H__
 
#include "amcomdef.h"
 
#define AM_DRM_CONFIG_SETSTRD   1
#define AM_DRM_CONFIG_GETCONTEXTLEN  2
 
#define AM_DRM_REGISTRATION_CODE_BYTES  9
 
#ifdef __cplusplus
extern "C" {
#endif
 
MHandle DRM_InitSystem();
MRESULT DRM_Destroy(MHandle hdrm);
//MRESULT DRM_GetHeadChunk(MHandle hander);
MRESULT DRM_InitPlayback(MHandle hdrm,MByte* pstrdBuf);
MRESULT DRM_QueryRentalStatus(MHandle hdrm,MUInt8* prentalMessageFlag,MUInt8* puseLimit,MUInt8* puseCount);
MRESULT DRM_SetRandomSample(MHandle hdrm,MDWord atimes);
MRESULT DRM_QueryCgmsa(MHandle hdrm,MUInt8* pcgmsaSignal);
MRESULT DRM_QueryAcptb(MHandle hdrm,MUInt8* pacptbSignal);
MRESULT DRM_QueryDigitalProtection(MHandle hdrm,MUInt8* pdigitalProtectionSignal);
MRESULT DRM_CommitPlayback(MHandle hdrm);
MRESULT DRM_DecryptVideo(MHandle hdrm,MByte * pbuffer,MDWord asize,MByte* drmDD);
MRESULT DRM_DecryptAudio(MHandle hdrm,MByte * pbuffer,MDWord asize);
MRESULT DRM_GetRegistrationCodeString(MHandle hdrm,MTChar * registrationCodeString);
MRESULT DRM_DataLoadSaveDrmMemory(MByte * marshalledMemory,MDWord marshalledMemoryLength);
MRESULT DRM_DataLoadLoadDrmMemory(MByte * marshalledMemory,MDWord marshalledMemoryLength);
MRESULT DRM_SetConfig(MHandle hdrm,MDWord id,MVoid* aparam1,MVoid* aparam2);
MRESULT DRM_GetConfig(MHandle hdrm,MDWord id,MVoid* aparam1,MVoid* aparam2);
 
#ifdef __cplusplus
}
#endif
 
#endif

