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
 * MV2CameraParam.h
 *
 * Description:
 *
 *	The common used marco and structure  in camera
  *
 *
 * History
 *    
 *  04.02.2005 Sh.F.Guo(sguo@arcsoft.com.cn )   
 * - initial version 
 *
 */

#ifndef _MV2CAMERAPARAM_H_
#define _MV2CAMERAPARAM_H_

#include "amcomdef.h"

typedef struct tagMV2_CAMERAPARAM
{
	MDWord dwWidth;		//  Width of the captured video
	MDWord dwHeight;		//  Height of the captured video	
	MDWord dwFPS;			// Frame rate,video need
} MV2CAMERAPARAM, * LPMV2CAMERAPARAM;

//macros for camera property  type
#define	MV2_CAMERA_PROPERTY_BRIGHTNESS		0x00000000  //type  For set camera brightness
#define	MV2_CAMERA_PROPERTY_CONTRAST		0x00000001  //type  For set camera Contrast
#define	MV2_CAMERA_PROPERTY_ZOOM			0x00000002  //type  For set camera ZOOM
#define	MV2_CAMERA_PROPERTY_WHITEBALANCE	0x00000004  //type  For set camera Whitebalance
#define	MV2_CAMERA_PROPERTY_VIDEOINFO		0x00000005  //only for AMOI 
#define MV2_CAMERA_PROPERTY_EFFECTS			0x00000006
#define MV2_CAMERA_PROPERTY_SATURATION		0x00000007
#define MV2_CAMERA_PROPERTY_EXPOSURE		0x00000008
#define MV2_CAMERA_PROPERTY_SHARPNESS		0x00000009
#define MV2_CAMERA_VIDEO_STABILIZE			0x0000000A
#define MV2_CAMERA_VIDEO_DENOISE			0x0000000B

typedef struct tagMV2_CAMERAPROPERTY
{
	MDWord	dwType;		// camera property type, see macros for property type
	MInt64 	lValue;		// camera property value, see macros for relative property value
	MInt64	lMinValue;	// this value is used only for query
	MInt64	lMaxValue;	// this value is used only for query
	
}MV2CAMERAPROPERTY, * LPMV2CAMERAPROPERTY;

//macro for whitebalance value
#define	MV2_CAMERA_WB_AUTO		0x00000000  
#define	MV2_CAMERA_WB_INCANDESCENT	0x00000001  
#define	MV2_CAMERA_WB_TWILIGHT		0x00000002  
#define	MV2_CAMERA_WB_FLUORESCENT	0x00000004  
#define	MV2_CAMERA_WB_SUNLIGHT		0x00000008  
#define	MV2_CAMERA_WB_CLOUDY		0x00000010  
#define	MV2_CAMERA_WB_SHADE		0x00000020  




//macros for captured image type
#define	MV2_CAMERA_IMAGE_RAWDATA		0x00000000  // captured image is raw data
#define	MV2_CAMERA_IMAGE_JPGDATA		0x00000001  // captured image is jpg data
#define	MV2_CAMERA_IMAGE_FILE			0x00000002  // captured image is saved in a file

/////////////////////////////
//	structs for capture image
typedef struct tagMV2_CAMERA_IMAGE
{
	MDWord	dwType;		// image type, see macros for image type
	MPVoid	pValue;		// captured image data's base pointer or file path name's pointer 
	MLong	lImageSize;	// captured image data's size or file path size, based in byte
}MV2CAMERAIMAGE, * LPMV2CAMERAIMAGE;


#endif
 
