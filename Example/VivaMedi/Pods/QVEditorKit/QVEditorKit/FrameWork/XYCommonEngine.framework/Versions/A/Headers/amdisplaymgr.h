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
#ifndef __AMDISPLAYMGR_H__
#define __AMDISPLAYMGR_H__

#include "amcomdef.h"
#include "amdisplay.h"

//Display Type
#define		M_DISPLAY_NULL					0x00000000
#define		M_DISPLAY_GDI					0x00000001
#define		M_DISPLAY_GAPI					0x00000002
#define		M_DISPLAY_RAW					0x00000003
#define		M_DISPLAY_PXA27X				0x00000004
#define		M_DISPLAY_DDRAW					0x00000005
#define		M_DISPLAY_S3C2442				0x00000006
#define		M_DISPLAY_2700G					0x00000007
#define		M_DISPLAY_S3C2443				0x00000008
#define		M_DISPLAY_GOFORCE				0x00000009
#define		M_DISPLAY_M830					0x00000010

typedef struct _tag_display_property_
{
	//get
	MLong	nScreenWidth;
	MLong	nScreenHeight;
	MBool	blIsFollowUi;
	MDWord	dwAlignedWidth;
	MDWord	dwAlignedHeight;
	MDWord	dwMaxOverlayStretch;
	MDWord	dwMinOverlayStretch;
	//get, set
	MDWord	dwColorSpace;
}MDISPLAYPROPERTY, *LPMDISPLAYPROPERTY;
typedef struct _tag_display_viewport_
{
	//set
	MHandle	hWnd;			
	MLong	nRotation;		//be based upon dwOrientation
	MDWord	dwReSizeAlg;
	MDWord	dwOrientation;
	//set, be based upon hWnd area
	//get, be based upon screen
	MLong	nXPos;			
	MLong	nYPos;
	MLong	nWidth;
	MLong	nHeight;
	//get
	MLong	nPitch;			//bytes
	MLong	nRealRotation;	//be based upon locked frame buffer
	//set, be based upon hWnd area
	MLong	nXPosOffBuff;
	MLong	nYPosOffBuff;
	MLong	nWidthOffBuff;
	MLong	nHeightOffBuff;				
}MDISPLAYVIEWPORT, *LPMDISPLAYVIEWPORT;


typedef struct _tag_display_color_key_
{
	//set	the key color
	MBool	bEnableColorKey;
	MDWord	dwKeyColor;
	//get
	MBool	bSupportColorKey;
}MDISPLAYCOLORKEY, *LPMDISPLAYCOLORKEY;

typedef struct _tag_display_transparence
{
	//set	the transparence
	MBool	bEnableTransparence;
	MDWord	dwTransparence;
	//get
	MBool	bSupportTransparence;
}MDISPLAYTRANSPARENCE, *LPMDISPLAYTRANSPARENCE;

typedef struct _tag_display_alphablending
{
	//set	the AlphaBlending
	MBool	bEnableAlphaBlending;
	MDWord	dwAlphaValue;
	MDWord	dwBlendingColorKey;
	//get
	MBool	bSupportAlphaBlending;
}MDISPLAYALPHABLENDING, *LPMDISPLAYALPHABLENDING;

typedef struct _tag_display_blitfx
{
	MDWord	dwDeblock;
	MDWord	dwDither;			//only for palner yuv to RGB16
	MLong	lBrightness;		//Value for brightness adjust, -128~127, 0 means adjust none
	MLong	lContrast;			//Value for contrast adjust, -128~127, 0 means adjust none
	MLong	lSaturation;		//Value for saturation adjust, -128~127, 0 means adjust none
}MDISPLAYBLITFX, *LPMDISPLAYBLITFX;

typedef	struct __tag_display_phsmem
{
	MBool	bUsePhsMem;
	MBool	bSupportPhsMem;
}MDISPLAYPHSMEM, *LPMDISPLAYPHSMEM;


#define	M_DISPLAY_PARAM_PROPERTY			0x00000001
#define	M_DISPLAY_PARAM_VIEWPORT			0x00000002
#define M_DISPLAY_PARAM_FULLSCREEN			0x00000003//the fullscreen flag
#define M_DISPLAY_PARAM_COLOR_KEY			0x00000004//the color key flag
#define M_DISPLAY_PARAM_TRANSPARENCE		0x00000005//the transparence key flag
#define M_DISPLAY_PARAM_ALPHABLENDING		0x00000006//the AlphaBlending key flag
#define M_DISPLAY_PARAM_BLITFX				0x00000007//the blit flag
#define M_DISPLAY_PARAM_PHSMEM				0x00000008			
	


#define	M_DISPLAY_ORIENTATION_NORMAL		0x00000000
#define	M_DISPLAY_ORIENTATION_LEFT_HANDLE	0x00000001
#define	M_DISPLAY_ORIENTATION_RIGHT_HANDLE	0x00000002


#define	M_DISPLAY_DIRECTION_ROTATE_0		M_DISPLAY_ORIENTATION_NORMAL
#define	M_DISPLAY_DIRECTION_ROTATE_90		M_DISPLAY_ORIENTATION_LEFT_HANDLE
#define	M_DISPLAY_DIRECTION_ROTATE_270		M_DISPLAY_ORIENTATION_RIGHT_HANDLE
#define	M_DISPLAY_DIRECTION_ROTATE_180		0x00000003


#define M_DISPLAY_MODE_DISALBE				0
#define M_DISPLAY_MODE_COLORKEY				1
#define M_DISPLAY_MODE_TRANSPARENCE			2




#ifdef __cplusplus
extern "C" {
#endif





MHandle MDisplayMgrCreateGDI();
MHandle MDisplayMgrCreateGAPI();
MHandle MDisplayMgrCreatePXA27X();
MHandle MDisplayMgrCreateOMAP();
MHandle MDisplayMgrCreateRAW();
MHandle MDisplayMgrCreateDDRAWCE();
MHandle MDisplayMgrCreateS3C2442();
MHandle MDisplayMgrCreateS3C2443();
MHandle MDisplayMgrCreate2700G();
MHandle MDisplayMgrCreateTITAN();
MHandle MDisplayMgrCreateGOFORCE();
MHandle MDisplayMgrCreateCRETA();
MHandle	MDisplayMgrCreateM830();



MHandle	MDisplayMgrCreate(MDWord dwDisplayType);
MRESULT	MDisplayMgrDelete(MHandle hDisplay);

MRESULT MDisplayMgrInit(MHandle hDisplay);
MRESULT MDisplayMgrUninit(MHandle hDisplay);
MRESULT MDisplayMgrUpdate(MHandle hDisplay);
MRESULT MDisplayMgrSetParam(MHandle hDisplay, MDWord dwParamID, MVoid* pParam, MDWord dwParamSize);
MRESULT MDisplayMgrGetParam(MHandle hDisplay, MDWord dwParamID, MVoid* pParam, MDWord dwParamSize);

MRESULT	MDisplayMgrEraseRect(MHandle hWnd, MRECT* prtErase, MCOLORREF bkColor);
MRESULT	MDisplayMgrEraseRectEx(MHandle hWnd, MRECT* prtErase, MCOLORREF bkColor, MBool bFullScreen);

MRESULT MDisplayMgrShow(MHandle hDisplay, MBool blShow);
MRESULT MDisplayMgrBlit(MHandle hDisplay, MDWord dwColorID, MByte* ppPlane[3], MLong pPitch[3], MRECT* prtSrc, MRECT* prtDst);


MHandle MDisplayMgrGlobalCreateS3C2443();
MHandle	MDisplayMgrGlobalCreatePXA27X();
MHandle	MDisplayMgrGlobalCreateGOFORCE();
MHandle	MDisplayMgrGlobalCreate(MDWord dwDisplayType);
MRESULT MDisplayMgrGlobalSelectMode(MHandle hGlobalDisplay, MDWord dwMode);
MRESULT	MDisplayMgrGlobalDelete(MHandle hGlobalDisplay);

#ifdef __cplusplus
}
#endif

#endif

