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
*---------------------------------------------------------------------------------------------*/
/*
 * adkutils.h
 *
 * interface for the Cadkutils class.
 *
 *
 * Code History
 *    
 * --2005-8-26 Weiren Sun ( wrsun@arcsoft.com.cn )
 *   initial version 
 *
 * Code Review
 *
 *
 */


#ifndef _ADKUTILS_H_
#define _ADKUTILS_H_

#ifdef __cplusplus
extern "C" {
#endif
	
#ifndef ABS
#define ABS(x) ((x)>=0?(x):-(x))
#endif //ABS


#define ADK_SAFEFREE(hMemContext, pBuff) \
	if(pBuff) { MMemFree((hMemContext), (pBuff)); (pBuff) = MNull;}

#define ADK_RGB16(r, g, b)					(MWord)((((b)>>3)&0X1F) | ((((MWord)(g))<<3)&0X07E0) | ((((MWord)(r))<<8)&0XF800))

#ifndef LINE_BYTES
#define LINE_BYTES(Width, BitCnt)    ((((MLong)(Width) * (BitCnt) + 31) >> 5) * 4)
#endif

#define AM_FILETYPE_UNKNOW	00
#define AM_FILETYPE_JPEG		01
#define AM_FILETYPE_BMP		02
#define AM_FILETYPE_GIF		03
#define AM_FILETYPE_PNG		04
#define AM_FILETYPE_SWF		05



#define IS_BACKSPLASH(ch)	('/' == (ch) || '\\' == (ch))

MRESULT ADK_FormatVersionInfo(MDWord dwRelease, 
							  MDWord dwMajor, 
							  MDWord dwMinor,
							  MTChar* pszPatch,
							  MTChar* pszVersion, 
							  MDWord dwVersionLen);

MRESULT ADKUTILS_GetVersionInfo(MDWord* pdwRelease,
								MDWord* pdwMajor,
								MDWord* pdwMinor,
								MTChar* pszVersion,
								MDWord  dwVersionLen);

MLong	ADK_GetColorDepth(MDWord dwPixelArrayFormat);
MLong	ADK_GetPixelBytes(MDWord dwPixelArrayFormat);

MTChar* ADK_GetFileExt(MTChar* pszItemText);
MRESULT ADK_SplitFullPath(MHandle hMemContext, MTChar* pszFullPath, MTChar* pszDir, MTChar* pszTitle, MTChar* pszExt);
MRESULT ADK_GetFitinSize(PMRECT prcClient, PMRECT prcPhoto, MLong* plZoomRatio);


/*for math functions.*/
#if defined(ADK_MATH_FLOAT_FPU)
#define ADK_Multiply(x,y)				(MLong)(((float)(x) * (float)(y))/0x8000)
#define ADK_Divide(dividend,divisor)	((divisor)==0?0x7FFFFFFF:(MLong)(((float)(dividend) / (float)(divisor))*0x8000))
#else
MLong ADK_Multiply(MLong x, MLong y);
MLong ADK_Divide(MLong dividend, MLong divisor);
MLong ADK_SQRT(MDWord high ,MDWord low);
MLong ADK_LENTH(MLong x ,MLong y);
#endif /*ADK_MATH_FLOAT_FPU*/


#ifdef __cplusplus
}
#endif


#endif /*_ADKUTILS_H_*/
