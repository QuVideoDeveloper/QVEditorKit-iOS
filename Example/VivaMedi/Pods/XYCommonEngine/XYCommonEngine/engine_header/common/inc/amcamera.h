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

#ifndef __AMCAMERA_H__
#define __AMCAMERA_H__

#include "amplat.h"
#include "amcomdef.h"
#include "amdisplay.h"


#define MCAM_PREVIEW_ROTATE_0		0		
#define MCAM_PREVIEW_ROTATE_90		90
#define MCAM_PREVIEW_ROTATE_180		180
#define MCAM_PREVIEW_ROTATE_270		270

typedef struct {			
	MDWord dwCaptureWidth;
	MDWord dwCaptureHeight;
	MDWord	dwFramePerSecond;
	PIXELARRAYFORMAT emPixelFormat;
} MCAMERAPARAM,* LPCAMERAPARAM;


typedef struct {				
	MHandle hDisplayContext;
	MRECT	rtPreview;
	MDWord  dwRotate;
} MCAMPREVIEW,* LPCAMPREVIEW;


#define	MCAMERA_PROPERTY_BRIGHTNESS		0x00000000
#define	MCAMERA_PROPERTY_CONTRAST		0x00000001
#define	MCAMERA_PROPERTY_ZOOM			0x00000002
#define	MCAMERA_PROPERTY_WHITEBALANCE	0x00000004
#define MCAMERA_PROPERTY_EFFECTS		0x00000006
#define MCAMERA_PROPERTY_SATURATION		0x00000007
#define MCAMERA_PROPERTY_EXPOSURE		0x00000008
#define MCAMERA_PROPERTY_SHARPNESS		0x00000009
#define MCAMERA_PROPERTY_TX_LIST			0x0000000A	//
#define MCAMERA_PROPERTY_TX_FOR_DRAW		0x0000000B	//
#define MCAMERA_PROPERTY_TX_FOR_ENC		0x0000000C	//tx is drawn and is ready for encoding
#define MCAMERA_PROPERTY_CAPTURE_MODE	0x0000000D	//
#define MCAMERA_PROPERTY_TX_LIST_FOR_SW	0x0000000E	//
#define MCAMERA_PROPERTY_OEM			0x10000000


#define MCAM_CAPTURE_MODE_NONE		(0)
#define MCAM_CAPTURE_MODE_YUV420		(1) //operation based on YUV420
#define MCAM_CAPTURE_MODE_TEXTURE	(2)	//operation based on texture, texture is created outside, and set to MCamera



typedef struct tagMCAMERAPROPERTY
{
	MDWord	dwType;
	
	MInt64	lValue; //by jgong@2019.11.04: mod from MLong to MVoid* to be compatible with 64bit system
	MInt64	lMinValue;
	MInt64 lMaxValue;
	
}MCAMERAPROPERTY, * LPMCAMERAPROPERTY;


typedef struct __tagQCAMERA_TEXTURE_LIST
{
	MHandle *pTxList;
	MDWord	dwCount;
}QCAMERA_TEXTURE_LIST;



#define	MCAMERA_WB_AUTO			0x00000000  
#define	MCAMERA_WB_INCANDESCENT	0x00000001  
#define	MCAMERA_WB_TWILIGHT		0x00000002  
#define	MCAMERA_WB_FLUORESCENT	0x00000004  
#define	MCAMERA_WB_SUNLIGHT		0x00000008  
#define	MCAMERA_WB_CLOUDY		0x00000010  
#define	MCAMERA_WB_SHADE		0x00000020  





#ifdef __cplusplus
extern "C" {
#endif

MHandle MCameraInitialize (MLong lCamRef);

MRESULT MCameraUninitialize(MHandle hCamera);

MRESULT MCameraGetCamParam(MHandle hCamera, MCAMERAPARAM * pCamParam);

MRESULT MCameraSetCamParam(MHandle hCamera, MCAMERAPARAM * pCamParam);

MRESULT MCameraGetPreviewParam(MHandle hCamera, MCAMPREVIEW * pPreviewParam);

MRESULT MCameraSetPreviewParam(MHandle hCamera, MCAMPREVIEW * pPreviewParam);

MRESULT MCameraPreview(MHandle hCamera,MBool bPreviewOn);

MRESULT MCameraCaptureStart(MHandle hCamera);

MRESULT MCameraCaptureStop(MHandle hCamera);

MRESULT MCameraCaptureFrameStart(MHandle hCamera,MByte ** ppFrameBuf);

MRESULT MCameraCaptureFrameEnd(MHandle hCamera);

MRESULT MCameraSetProperty(MHandle hCamera, MCAMERAPROPERTY * pCamProperty); 

MRESULT MCameraGetProperty(MHandle hCamera, MCAMERAPROPERTY * pCamProperty); 

#ifdef __cplusplus
}
#endif


#endif

