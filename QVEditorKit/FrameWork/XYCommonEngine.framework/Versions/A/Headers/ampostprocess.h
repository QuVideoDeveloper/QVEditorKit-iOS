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

#ifndef __AMPOSTPROCESS_H__
#define __AMPOSTPROCESS_H__

#include "amcomdef.h"

#if defined(__MPPSYMBIAN32__)
#include <e32def.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#if defined(__MPPSYMBIAN32__)
#define MPP_IMPORT IMPORT_C
#else
#define MPP_IMPORT
#endif

#define MPP_MAX_PLANES		3
	
//Resize Algorithms 
#define	MPP_RESIZE_NEAREST_NEIGHBOUR		0x001	//Nearest Neighbour Interpolation, high performance and low quality
#define	MPP_RESIZE_BILINEAR					0x002	//Bilinear Interpolation, high quality and low performance
#define	MPP_RESIZE_BICUBIC					0x004	//Reserved, Bicubic Interpolation

//Direction Flags
#define	MPP_DIRECTION_TRANSPOSE				0x001
#define	MPP_DIRECTION_FLIP_HORIZONTAL		0x002
#define	MPP_DIRECTION_FLIP_VERTICAL			0x004
#define	MPP_DIRECTION_ROTATE_90				(MPP_DIRECTION_TRANSPOSE | MPP_DIRECTION_FLIP_HORIZONTAL)		//Rotate 90° CW
#define	MPP_DIRECTION_ROTATE_180			(MPP_DIRECTION_FLIP_VERTICAL | MPP_DIRECTION_FLIP_HORIZONTAL)	//Rotate 180
#define	MPP_DIRECTION_ROTATE_270			(MPP_DIRECTION_TRANSPOSE | MPP_DIRECTION_FLIP_VERTICAL)			//Rotate 270° CW

//Processor Type
#define MPP_PROCESSOR_ARM7					0x001	//Reserved; ARM7 series
#define MPP_PROCESSOR_ARM9E					0x002	//ARM9 series with enhance DSP instruction, bilinear interpolation will get better performance
#define MPP_PROCESSOR_ARM11					0x003	//ARM11 series, bilinear interpolation will get better performance
#define MPP_PROCESSOR_XSCALE				0x004	//Intel XScale series, bilinear interpolation and non stretch convert will get better performance.
#define MPP_PROCESSOR_CORTEX_NEON          0x005   //support neon feature


//Performance Mode
#define MPP_PERFORMANCE_1X1					0x001	//Provide the normal performance
#define MPP_PERFORMANCE_2X2					0x002	//Provide the better performance
#define MPP_PERFORMANCE_4X4					0x003	//Provide the best performance
#define MPP_PERFORMANCE_8X8					0x004	//Provide the bestest performance
#define MPP_PERFORMANCE_AUTO				0x100	//Auto select performance mode, and will consume more memory

//Aspect Ratio
#define MPP_ASPECT_RATIO_FIT_IN				0x001	//Fit in
#define MPP_ASPECT_RATIO_FIT_OUT			0x002	//Fit out

//speciality




/********************************************************************************************************
YUV and YCbCr is not the same, YCbCr is a scaled and offset version of the YUV color space.
YUV and YCbCr has two standard, ITU-R BT.601 and ITU-R BT.709.
Usually in video standrad they use ITU-R BT.601 and YUV,in image standard they use ITU-R BT.601 and YCbCr.

YUV range:
+16  (219)
+128 (224)
+128 (224)

YCbCr range:
+0   (255)
+128 (255)
+128 (255)

ranges:
R,G,B,Y [0..1]
Cb,Cr   [-0.5..0.5]

Y' = Kr * R' + (1 - Kr - Kb) * G' + Kb * B'
Cb = 0.5 * (B' - Y') / (1 - Kb)
Cr = 0.5 * (R' - Y') / (1 - Kr)

Kb = 0.114
Kr = 0.299

ITU-R BT.601
    Y'= 0.299   *R' + 0.587   *G' + 0.114   *B'
    Cb=-0.168736*R' - 0.331264*G' + 0.5     *B'
    Cr= 0.5     *R' - 0.418688*G' - 0.081312*B'

    R'= Y'            + 1.403*Cr
    G'= Y' - 0.344*Cb - 0.714*Cr
    B'= Y' + 1.773*Cb 

Kb = 0.0722
Kr = 0.2126

ITU-R BT.709
    Y'= 0.2215*R' + 0.7154*G' + 0.0721*B'
    Cb=-0.1145*R' - 0.3855*G' + 0.5000*B'
    Cr= 0.5016*R' - 0.4556*G' - 0.0459*B'

    R'= Y'             + 1.5701*Cr
    G'= Y' - 0.1870*Cb - 0.4664*Cr
    B'= Y' - 1.8556*Cb 
*********************************************************************************************************/

typedef struct __tag_mblitfx
{
	MDWord	dwReSizeAlg;		//Nearest Neighbor or Bilinear
	MDWord	dwDirection;		//Also support combine directions, for example: MPP_DIRECTION_ROTATE_90
	MDWord	dwProcessorType;	//Specifies the processor type, if you don't know plaease set it to 0
	MDWord	dwPerformanceMode;	//MPP_PERFORMANCE_4X4 will provide the best performance, but input parameter must satisfy more condition
	MDWord	dwAspectRatio;		//Fit in, fit out or stretching or compressing the bitmap to fit the dimensions of the destination rectangle
	MDWord	dwDither;			//only for palner yuv to RGB16
	MLong	lBrightness;		//Value for brightness adjust, -128~127, 0 means adjust none
	MLong	lContrast;			//Value for contrast adjust, -128~127, 0 means adjust none
	MLong	lSaturation;		//Value for saturation adjust, -128~127, 0 means adjust none
	MPOINT	SrcRSP;				//Reserved; sets this value to zero
	MPOINT	DstRSP;				//Reserved; sets this value to zero
	MRECT	rtSrc;				//Reserved; sets this value to zero
	MDWord  dwAlpha;            //Value for Alpha,available when yuv to RGB32
} MBLITFX, *LPMBLITFX;

typedef struct __tag_mrgbquad
{
	MByte	byBlue;		//Specifies the intensity of blue in the color
	MByte	byGreen;	//Specifies the intensity of green in the color
	MByte	byRed;		//Specifies the intensity of red in the color
	MByte	byReserved;	//Reserved; sets this value to zero
} MRGBQUAD, *LPMRGBQUAD;


typedef struct __tag_mpafpixel
{
	MDWord		dwSpaceID;		//ID of color space, sample: MPAF_RGB16_R5G6B5, MPAF_RGB24_R8G8B8, MPAF_I420, (MPAF_I420| MPAF_BT601_YCBCR)
	MDWord		dwWidth;		//Specifies the width of the bitmap, in pixels
	MDWord		dwHeight;		//Specifies the height of the bitmap, in pixels
	LPMRGBQUAD 	pPalette;
} MPAFPIXEL, *LPMPAFPIXEL;


MPP_IMPORT MRESULT	MPPCreate(MPAFPIXEL *pDstPixel, MPAFPIXEL *pSrcPixel, MBLITFX *pFX, MHandle* );

MPP_IMPORT MRESULT	MPPAlign(MHandle hPP, MRECT *pDstRect, MRECT *pSrcRect);

MPP_IMPORT MRESULT MPProcess(MHandle hPP, MByte *ppDst[MPP_MAX_PLANES], MRECT *pDstRect, MLong pDstPitch[MPP_MAX_PLANES],
					MByte *ppSrc[MPP_MAX_PLANES], MLong pSrcPitch[MPP_MAX_PLANES]);

MPP_IMPORT MRESULT MPProcessEx(MHandle hPP, MByte *ppDst[MPP_MAX_PLANES], MPOINT* pDstPtrPos, MRECT *pDstRect, MLong pDstPitch[MPP_MAX_PLANES],
					MByte *ppSrc[MPP_MAX_PLANES], MLong pSrcPitch[MPP_MAX_PLANES]);

MPP_IMPORT MVoid	MPPDestroy(MHandle hPP);

//get post process version information
MPP_IMPORT MRESULT PostProcessGetVersionInfo (MDWord* pdwRelease, MDWord* pdwMajor, MDWord* pdwMinor, MTChar* pszPatch, MDWord dwLen);


#ifdef __cplusplus
}
#endif


#endif

