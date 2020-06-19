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
/*
 * File Name:	amimgdef.h					
 *
 * Reference:
 *
 * Description: Define some common structures, constants, callback prototype, and so on for image components.
 * 
 * 
 */


#ifndef	_AMIMGDEF_H_
#define	_AMIMGDEF_H_
#include "amdisplay.h"

#ifdef __cplusplus
extern "C"
{
#endif

/*******************************************************************************/
#define	AMCT_PHOTOVIEWER				0X90840320
#define	AMCT_GIFPLAYER					0X90840321
#define	AMCT_SLIDESHOW					0X90840322
#define	AMCT_THUMBNAILENGINE			0X90840323

#define AMCT_PHOTOEDITOR				0X90840311
#define AMCT_ET_BASICEDITING			0X90840330
#define AMCT_ET_FRAME					0X90840331
#define AMCT_ET_OVERLAY					0X90840332
#define AMCT_ET_SPECIALEFFECT			0X90840333
#define AMCT_ET_PHOTOENHANCEMENT		0X90840334
#define AMCT_ET_DRAWING					0X90840335
#define AMCT_ET_REDEYE                  0X90840336
#define AMCT_ET_FRAME2                  0X90840337


/*******************************************************************************/ 
#define AM_ZOOM_FITIN					0XFFFFFFF1
#define AM_ZOOM_FITOUT					0XFFFFFFF2

#define AMPE_CLR_TRANSPARENT			0XFFFFFFFF

/*******************************************************************************/
#define AM_COORDINATE_SYS_IMG			0X00A00001
#define AM_COORDINATE_SYS_SCREEN		0X00A00002

/*******************************************************************************/
#define	AM_FIT_NORMAL					0X00A00010
#define AM_FIT_BEST_CW					0X00A00011
#define AM_FIT_BEST_CCW					0X00A00012

/*******************************************************************************/
#define AM_PROP_MAXRAM					0X00A60001
#define	AM_PROP_AUTOREFRESH				0X00A60002
#define AM_PROP_COORDINATE_SYS			0X00A60003
#define AM_PROP_FITMODE					0X00A60004
#define AM_PROP_BLURPAN					0X00A60005
#define AM_PROP_TRANSITION_EFFECT		0X00A60006
#define AM_PROP_THUMB_FILECACHE_ENABLE	0X00A60007
#define	AM_PROP_THUMB_CACHE_FOLDER		0X00A60008
#define AM_PROP_SCREEN_ORIENTATION		0X00A60009
#define AM_PROP_AMTE_HANDLE_THUMBNAIL	0X00A6000A
#define AM_PROP_AMTE_HANDLE_LARGEIMAGE	0X00A6000B
#define AM_PROP_ALLOW_TRANS_DATA_OUT	0X00A6000C
#define AM_PROP_MAX_DISP_CONTEXT_SIZE	0X00A6000D
#define AM_PROP_FILELIST_UID			0X00A6000E
#define AM_PROP_INTERNAL_TASK_DRIVER	0X00A6000F
#define AM_PROP_CACHETASK_ENABLE		0X00A60010
#define AM_PROP_TESHARE_CACHEFOLDER     0X00A60011
#define AM_PROP_LIMIT_CACHE_SIZE        0X00A60012

#define AMTE_PROP_KEEP_EXIF_ORG_SIZE	0X00A61001 // whether to resample exif thumbnail
#define AMTE_PROP_OUTPUT_DIB_SIZE       0X00A61002 // use this to resample cache data
#define AMTE_PROP_ALLOW_DEC_EXIF_THUMB	0X00A61003 // allow decode from exif
#define AMTE_PROP_DISP_MODE				0X00A61004 // display AM_ZOOM_FITIN or AM_ZOOM_FITOUT thumbnail
#define AMTE_PROP_THUMB_SIZE_GROUP		0X00A61005
#define AMTE_PROP_LOCK_SYNC_GET_DATA	0X00A61006 // lock function must get thumbnail data or decode error

//AMPV_PROP_NAVIGATETRANSITION is only compatible for the old version, don't use it. Please find AM_PROP_TRANSITION_EFFECT for the same usage
#define AMPV_PROP_NAVIGATETRANSITION	0X00A62000
#define AMPV_PROP_FILMSTRIP				0X00A62001
#define AMPV_PROP_ZOOMEFFECT			0X00A62002
#define AMPV_PROP_THUMB_SIZE			0X00A62003
//AMPV_PROP_DEVICE_SCREEN_SIZE is only compatible for the old version, don't use it. Please find AM_PROP_MAX_DISP_CONTEXT_SIZE for the same usage
#define AMPV_PROP_DEVICE_SCREEN_SIZE	0X00A62004
#define	AMPV_PROP_FILMSTRIP_ICON		0X00A62005
#define AMPV_PROP_IMAGE_ERR_ICON		0X00A62006
#define AMPV_PROP_IMG_THUMBNAIL			0X00A62007
#define AMPV_PROP_FITIN_BEFORE_READY	0X00A62008
#define AMPV_PROP_CUSTDRAW				0X00A62009
#define AMPV_PROP_CUSTICON				0X00A6200A
#define AMPV_PROP_ZOOM_MAX_LEVEL		0X00A6200B
#define AMPV_PROP_ZOOM_MIN_LEVEL		0X00A6200C
#define AMPV_PROP_ORG_THUMBNAIL			0X00A6200D
#define AMPV_PROP_ALPHA_FILE_LIST		0X00A6200E
#define AMPV_PROP_AUTOPLAY_GIF			0X00A6200F
#define AMPV_PROP_ACTIVATED_DRM_ICON	0X00A62010
#define AMPV_PROP_EXPIRED_DRM_ICON		0X00A62011

#define AMSL_PROP_TRANSITION_DURATION	0X00A64100
#define AMSL_PROP_IMAGE_DRATION			0X00A64101
#define AMSL_PROP_ALPHA_FOLDER			0X00A64102
#define AMSL_PROP_LOOP					0X00A64103

#define AMPE_PROP_UNDO_MAXSTEP			0X00A6D001


/*******************************************************************************/
#define AMTE_MSG_THUMB_READY			0X00A71000
#define AMTE_MSG_DECODER_ERROR			0X00A71001

#define AMPV_MSG_BROWSING				0X00A72000
#define AMPV_MSG_PANNING				0X00A72001
#define AMPV_MSG_ZOOMING				0X00A72002
#define AMPV_MSG_TO_DISPLAY				0X00A72003
#define AMPV_MSG_FILMSTRIP_BROWSING		0X00A72004
#define AMPV_MSG_EXPIRED_DRM			0X00A72005

#define AMGP_MSG_PLAY_END				0X00A73000

#define AMSL_MSG_PLAY_END				0X00A74000
#define AMSL_MSG_PLAY_NEWSLIDE			0X00A74001

#define AMPE_MSG_PROGRESS				0X00A7D001

#define AM_MSG_ASYNC_ERR                0X00A7E000
/*******************************************************************************/
#define AM_TRANS_NONE					0X00A82000
#define AM_TRANS_PAN					0X00A82001

#define AM_TRANS_PAN_ZOOM				0X00A84100
#define AM_TRANS_CROSSFADE				0X00A84101
#define AM_TRANS_ALPHA					0X00A84102

//AM_TRANS_NO is only compatible for the old version, don't use it. Please find AM_TRANS_NONE for the same usage
#define AM_TRANS_NO						AM_TRANS_NONE


/*******************************************************************************/
#define AMPV_OPT_PREVIMG				0X00A92100
#define AMPV_OPT_NEXTIMG				0X00A92101
#define AMPV_OPT_PAN_LEFT				0X00A92200
#define AMPV_OPT_PAN_RIGHT				0X00A92201
#define AMPV_OPT_PAN_UP					0X00A92202
#define AMPV_OPT_PAN_DOWN				0X00A92203
#define AMPV_OPT_ZOOM_IN				0X00A92300
#define AMPV_OPT_ZOOM_OUT				0X00A92301

/*******************************************************************************/
#define AMPV_CUST_ERRORICON				0x00A92500
#define AMPV_CUST_WAITICON				0x00A92501

/*******************************************************************************/
/* Special effect type IDs                                                     */
/*******************************************************************************/
#define AMPE_SE_NONE					0X00AAD300
#define AMPE_SE_BLACKWHITE				0X00AAD301
#define AMPE_SE_NEGATIVE				0X00AAD302
#define AMPE_SE_OLDPHOTE				0X00AAD303
#define AMPE_SE_SHARPEN					0X00AAD304
#define AMPE_SE_BLUR					0X00AAD305
#define	AMPE_SE_DESPECKLE				0X00AAD306
#define	AMPE_SE_GRAYEMBOSS				0X00AAD307
#define	AMPE_SE_COLOREMBOSS				0X00AAD308
#define	AMPE_SE_GRAYSKETCH				0X00AAD309
#define	AMPE_SE_COLORSKETCH				0X00AAD30A
#define	AMPE_SE_COLORCHANNEL_R			0X00AAD30B
#define	AMPE_SE_COLORCHANNEL_G			0X00AAD30C
#define	AMPE_SE_COLORCHANNEL_B			0X00AAD30D
#define	AMPE_SE_DITHER					0X00AAD30E
#define	AMPE_SE_SOLARIZE				0X00AAD30F
#define	AMPE_SE_OILPAINTING				0X00AAD310
#define	AMPE_SE_COLORCHANNEL_RGB		0X00AAD311
#define	AMPE_SE_POSTERIZE				0X00AAD312

/*******************************************************************************/
/* Photo enhancement type IDs                                                     */
/*******************************************************************************/
#define AMPE_EN_AUTOLEVEL				0X00AAD400
#define AMPE_EN_AUTOCOLOR				0X00AAD401
#define AMPE_EN_AUTOBRIGHTNESSCONTRAST	0X00AAD402
#define AMPE_EN_FILLLIGHTING			0X00AAD403

/*******************************************************************************/
/* Photo Pen type IDs                                                     */
/*******************************************************************************/
#define AMPE_PEN_SOLID					0X00AAD600
#define AMPE_PEN_DASH					0X00AAD601
#define AMPE_PEN_DOT					0X00AAD602
#define AMPE_PEN_DASHLONG_DOT			0X00AAD603
#define AMPE_PEN_DASHLONG_DOT_DOT		0X00AAD604

/*******************************************************************************/
#define AMPE_BRUSH_SOLID				0X00AAD620

/*******************************************************************************/
#define AMPE_SHAPE_PENCIL				0X00AAD6B0
#define AMPE_SHAPE_LINE					0X00AAD6B1
#define AMPE_SHAPE_RECTANGLE			0X00AAD6B2
#define AMPE_SHAPE_CIRCLE				0X00AAD6B3
#define AMPE_SHAPE_ELLIPSE				0X00AAD6B4
/*******************************************************************************/






/*******************************************************************************/
/* Define the display callback functions                                       */
/*******************************************************************************/
typedef MRESULT (*AM_FNBITBLT) (
	MBITMAP* pBmpOffScreen,
	MRECT* pRectToUpdate,
	MVoid* pUserData 
	);
typedef MRESULT (*AM_FNERASEBKGND) (
	MBITMAP* pBmpOffScreen,
	MRECT* pRectToUpdate,
	MVoid* pUserData 
	);
typedef MRESULT (*AM_FNOFFSCREENBUFFERLOCK)(
	MBITMAP** ppBmpOffScreen,
	MLong	lDispWidth,
	MLong	lDispHeight,
	MVoid*	pUserData
	);
typedef MRESULT (*AM_FNOFFSCREENBUFFERUNLOCK)(
	MBITMAP*	pBmpOffScreen,
	MVoid*		pUserData
	);
typedef MRESULT (*AM_FNNOTIFY) (
	MDWord		dwMsg,
	MDWord		dwParam,
	MVoid* 		pUserData
	);

/*******************************************************************************/
typedef struct _tagAM_DISPLAY_CONTEXT{
	MLong lDisplayWidth;
	MLong lDisplayHeight;
	MDWord dwPixelArrayFormat;
	AM_FNERASEBKGND fnEraseBkgnd;
	AM_FNBITBLT fnBitBlt;
	AM_FNOFFSCREENBUFFERLOCK fnOffScreenBufferLock;
	AM_FNOFFSCREENBUFFERUNLOCK fnOffScreenBufferUnlock;
	MVoid* pUserData;
} AM_DISPLAY_CONTEXT, *LPAM_DISPLAY_CONTEXT;
/*******************************************************************************/








/*******************************************************************************/
/* Define the file list callback functions                                     */
/*******************************************************************************/
typedef MRESULT (*AM_FNGETFILECOUNT) (
	MLong* plCount,
	MVoid* pUserData
	);
typedef MRESULT (*AM_FNGETCURINDEX) (
	MLong* plIndex,
	MVoid* pUserData
	);
typedef MRESULT (*AM_FNGETFILENAME) (
	MLong lIndex,
	MVoid* pszFileName, 
	MVoid* pUserData
	);
/*******************************************************************************/
typedef struct _tagAM_FILELIST_CALLBACK {
	AM_FNGETFILECOUNT 	fnGetFileCount ; 
	AM_FNGETCURINDEX  	fnGetCurIndex ; 
	AM_FNGETFILENAME  	fnGetFileName ; 
	MVoid* 				pUserData;
} AM_FILELIST_CALLBACK, *LPAM_FILELIST_CALLBACK; 

/*******************************************************************************/
/* The initialization parameters structure for thumbnail rendering engine      */
/*******************************************************************************/
typedef struct 
{
	MDWord		dwPAF;
	MLong 		lThumbWidth;
	MLong		lThumbHeight;
	AM_FILELIST_CALLBACK  FileListCallBack;
} AMTE_INIT_PARAM, *LPAMTE_INIT_PARAM;

typedef struct _tagAMTE_THUMBINFO 
{
	MDWord	dwImageFormat;
	MLong	lOrgWidth;
	MLong	lOrgHeight;
	MDWord	dwZoom;
	MBool	bFromExif;
	MBool	bDRMImage;
	MBool	bDRMExpired;
} AMTE_THUMBINFO, *LPAMTE_THUMBINFO;

/*******************************************************************************/
/* The state structure for the photo viewer component                          */
/*******************************************************************************/
typedef struct _tagAMPV_STATE {
	MLong 				lImgWidth;
	MLong				lImgHeight;
	MRECT				rtImgDisplayRect;
	MBool				bIsFitIn;
	MDWord 				dwZoom;
	MLong				lImgIndex; 
	MLong				lImageOrientationToScreen;
} AMPV_STATE, *LPAMPV_STATE; 
/*******************************************************************************/

/*******************************************************************************/
/* Define the callback functions for the photo viewer                          */
/*******************************************************************************/
typedef MRESULT (*AMPV_FNGETDISPRECT)(
	MDWord		dwIndex,
	MRECT*		pRect,
	MVoid*		pUserData 
	);

typedef MRESULT (*AMPV_FNCUSTDRAW)(
	MBITMAP*	pBmpOffScreen,
	MDWord		dwIndex,
	MVoid*		pUserData 
	);

typedef struct _tagAMPVCustDraw
{
	AMPV_FNGETDISPRECT	fnGetDispRect;
	AMPV_FNCUSTDRAW		fnCustDraw;
	MVoid*				pUserData;
}AMPV_CUSTOM_DRAW;

typedef MRESULT (*AMPV_FNGETCUSTICON)(
	MBITMAP**	phBmpIcon,
	MDWord		dwIndex,
	MDWord		dwType,
	MVoid*		pUserData 
	);

typedef struct _tagAMPVCustIcon
{
	AMPV_FNGETCUSTICON	fnGetCustIcon;
	MVoid*				pUserData;
} AMPV_CUSTOM_ICON;


/*******************************************************************************/
/* The state structure of the photo editor component                           */
/*******************************************************************************/
typedef struct _tagAMPE_STATE {
	MLong				lImgWidth;
	MLong 				lImgHeight; 
	MRECT				rtImgDisplayRect;
	MBool				bIsFitIn;
	MDWord 				dwZoom;
	MDWord				dwUndoSteps;
	MDWord				dwRedoSteps;
} AMPE_STATE, *LPAMPE_STATE;


/*******************************************************************************/
/* Define the text callback functions                                          */
/*******************************************************************************/
typedef struct _tagAMPE_TEXTINFO *LPAMPE_TEXTINFO;

typedef MRESULT (*AMPE_FNDRAWTEXT)(
	LPAMPE_TEXTINFO	ptxtInfo,
	MBITMAP** 		ppBmpTextMask,
	MVoid* 			pUserData
	);

typedef MRESULT (*AMPE_FNFREETEXT)(
	MBITMAP* 	pBmpTextMask,
	MVoid* 		pUserData
	);

/*******************************************************************************/
/* The text information structure for the text feature of overlay tool         */
/*******************************************************************************/
typedef struct _tagAMPE_TEXTINFO {
	MTChar*			pszText;
	MCOLORREF		clrTxt;
	MLong			lDegree;	//clockwise degree
	MLong			lFlipFlag;	//The flag for flipping, 0: no flip, 1: horizontal flip, 2: vertical flip
	AMPE_FNDRAWTEXT	fnDrawText;
	AMPE_FNFREETEXT	fnFreeText;
	MVoid*			pUserData;
} AMPE_TEXTINFO;

typedef struct _tagAMPE_OVERLAYINFO {
	MLong lOrgWidth; 
	MLong lOrgHeight; 
	MLong lDegree; 
	MLong lFlipFlag; 
} AMPE_OVERLAYINFO, *LPAMPE_OVERLAYINFO;

/*******************************************************************************/
/*  The brush & pen styles for the drawing tool                                */
/*******************************************************************************/
typedef struct _tagAMPE_BRUSH {
	MCOLORREF		clrBrushColor;
	MDWord		dwStyle;
} AMPE_BRUSH, *LPAMPE_BRUSH;

typedef struct _tagAMPE_PEN {
	MLong		lPenThickness;
	MCOLORREF		clrPenColor;
	MDWord		dwStyle;
} AMPE_PEN, *LPAMPE_PEN;
/*******************************************************************************/


#ifdef __cplusplus
}
#endif

#endif /*#ifndef _AMIMGDEF_H_ */


/*End of file*/


