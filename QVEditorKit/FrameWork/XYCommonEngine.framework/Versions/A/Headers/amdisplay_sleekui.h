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
#ifndef __AMDISPLAY_SLEEKUI_H__
#define __AMDISPLAY_SLEEKUI_H__

#include "amcomdef.h"
#include "amdisplay.h"

#ifdef __cplusplus
extern "C" {
#endif

MHandle MCreateDisplayContext(MHandle env, MHandle surface);
MVoid MDestroyDisplayContext(MHandle hDisplayContext);

MRESULT MQueryDisplayInfo_SleekUI(MHandle hDisplayContext, MDISPLAYINFO *pDisplayInfo);
MHandle MDisplayInitialize_SleekUI(MHandle hDisplayContext);
MRESULT MDisplayUninitialize_SleekUI(MHandle hDisplay);
MRESULT MDisplayUpdate_SleekUI(MHandle hDisplay, MByte* pFrameBuf, MDWord dwFrameLen, MRECT* pRect);
MHandle MOverlayInitialize_SleekUI(MHandle hOverlayContext, MRECT * pOverlayRect);
MRESULT MOverlayUninitialize_SleekUI(MHandle hOverlay);
MBITMAP * MOverlayLock_SleekUI(MHandle hOverlay);
MRESULT MOverlayUnlock_SleekUI(MHandle hOverlay);
MRESULT MOverlayUpdate_SleekUI(MHandle hOVerlay, MRECT *pRect);

#ifdef __cplusplus
}
#endif

#endif

