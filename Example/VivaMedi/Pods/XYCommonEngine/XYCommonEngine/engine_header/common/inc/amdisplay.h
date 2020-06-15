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
#ifndef __AMDISPLAY_H__
#define __AMDISPLAY_H__

#include "amcomdef.h"

#ifdef MSIZE
#undef MSIZE
#endif

//Bitmap Type
//31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
//Bits[31:28]	Type
//Bits[27:24]	Bit Counts
//Bits[23:14]	Reserved
//RGB
//Bits[13:12]	RGB or BGR
//Bits[11:08]	R bits
//Bits[07:04]	G bits
//Bits[03:00]	B bits
//YUV(YCbCr)
//Bits[13:12]	ITU-R BT.601 or ITU-R BT.709, YUV or YCbCr
//Bits[11:08]	YUV Type
//Bits[07:04]	Horizontal subsampling interval of UV
//Bits[03:00]	Vertical subsampleing interval of UV
#define		MPAF_MAKE_R(n)	((n-1)<<4*2)
#define		MPAF_MAKE_G(n)	((n-1)<<4*1)
#define		MPAF_MAKE_B(n)	((n-1)<<4*0)

#define		MPAF_MAKE_H(n)	((n-1)<<4*1)
#define		MPAF_MAKE_V(n)	((n-1)<<4*0)

//Bits[31:28]	Type
#define		MPAF_RGB_BASE			0X10000000
#define		MPAF_RGBT_BASE			0X20000000
#define		MPAF_RGBA_BASE			0X30000000
#define		MPAF_RGBP_BASE			0X40000000
#define		MPAF_YUV_BASE			0X50000000
#define		MPAF_GRAY_BASE			0X60000000
#define		MPAF_OTHERS				0X70000000
#define		MPAF_RG_BASE			0x80000000
#define		MPAF_CT_BASE			0x90000000
//Bits[27:24]	Bit Counts
#define		MPAF_1BITS				0X01000000
#define		MPAF_2BITS				0X02000000
#define		MPAF_4BITS				0X03000000
#define		MPAF_8BITS				0X04000000
#define		MPAF_16BITS				0X05000000
#define		MPAF_24BITS				0X06000000
#define		MPAF_32BITS				0X07000000
//Bits[14:14]	XXXA or AXXX
#define		MPAF_XXXA				0X00004000
//Bits[13:12]	RGB or BGR
#define		MPAF_BGR				0X00001000
//Bits[13:12]	ITU-R BT.601 or ITU-R BT.709, YUV or YCbCr
//YUV and YCbCr is not the same, YCbCr is a scaled and offset version of the YUV color space.
//YUV and YCbCr has two standard, ITU-R BT.601 and ITU-R BT.709.
//Usually in video standrad they use ITU-R BT.601 and YUV,in image standard they use ITU-R BT.601 and YCbCr.
#define		MPAF_BT601_YUV			0X00000000
#define		MPAF_BT601_YCBCR		0X00001000
#define		MPAF_BT709_YUV			0X00002000
#define		MPAF_BT709_YCBCR		0X00003000
//Bits[11:08]	YUV Type
#define		MPAF_YUV_PLANAR			0X00000800
#define		MPAF_YUV_UVY			0X00000400
#define		MPAF_YUV_VU				0X00000200
#define		MPAF_YUV_Y1Y0			0X00000100




#define		MPAF_RGB1_PAL			(MPAF_RGBP_BASE | MPAF_1BITS)
#define		MPAF_RGB4_PAL			(MPAF_RGBP_BASE | MPAF_4BITS)
#define		MPAF_RGB8_PAL			(MPAF_RGBP_BASE | MPAF_8BITS)

//	31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00 


//													 R  R  R  R  R  G  G  G  G  G  G  B  B  B  B  B 
#define		MPAF_RGB16_R5G6B5		(MPAF_RGB_BASE | MPAF_16BITS | MPAF_MAKE_R(5) | MPAF_MAKE_G(6) | MPAF_MAKE_B(5))
//													 X  R  R  R  R  R  G  G  G  G  G  B  B  B  B  B  
#define		MPAF_RGB16_R5G5B5		(MPAF_RGB_BASE | MPAF_16BITS | MPAF_MAKE_R(5) | MPAF_MAKE_G(5) | MPAF_MAKE_B(5))
//													 X  X  X  X  R  R  R  R  G  G  G  G  B  B  B  B 
#define		MPAF_RGB16_R4G4B4		(MPAF_RGB_BASE | MPAF_16BITS | MPAF_MAKE_R(4) | MPAF_MAKE_G(4) | MPAF_MAKE_B(4))
//													 T  R  R  R  R  R  G  G  G  G  G  B  B  B  B  B  
#define		MPAF_RGB16_TR5G5B5		(MPAF_RGBT_BASE | MPAF_16BITS | MPAF_MAKE_R(5) | MPAF_MAKE_G(5) | MPAF_MAKE_B(5))
//													 B  B  B  B  B  G  G  G  G  G  G  R  R  R  R  R  
#define		MPAF_RGB16_B5G6R5		(MPAF_BGR | MPAF_RGB16_R5G6B5)
//													 X  B  B  B  B  B  G  G  G  G  G  R  R  R  R  R   
#define		MPAF_RGB16_B5G5R5		(MPAF_BGR | MPAF_RGB16_R5G5B5)
//													 X  X  X  X  B  B  B  B  G  G  G  G  R  R  R  R  
#define		MPAF_RGB16_B4G4R4		(MPAF_BGR | MPAF_RGB16_R4G4B4)


//							 R	R  R  R	 R	R  R  R  G  G  G  G  G  G  G  G  B  B  B  B  B  B  B  B 
#define		MPAF_RGB24_R8G8B8		(MPAF_RGB_BASE | MPAF_24BITS | MPAF_MAKE_R(8) | MPAF_MAKE_G(8) | MPAF_MAKE_B(8))
//							 X	X  X  X	 X	X  R  R  R  R  R  R  G  G  G  G  G  G  B  B  B  B  B  B  
#define		MPAF_RGB24_R6G6B6		(MPAF_RGB_BASE | MPAF_24BITS | MPAF_MAKE_R(6) | MPAF_MAKE_G(6) | MPAF_MAKE_B(6))
//							 X	X  X  X	 X	T  R  R  R  R  R  R  G  G  G  G  G  G  B  B  B  B  B  B  
#define		MPAF_RGB24_TR6G6B6		(MPAF_RGBT_BASE | MPAF_24BITS | MPAF_MAKE_R(5) | MPAF_MAKE_G(5) | MPAF_MAKE_B(5))
//							 B  B  B  B  B  B  B  B  G  G  G  G  G  G  G  G  R	R  R  R	 R	R  R  R 
#define		MPAF_RGB24_B8G8R8		(MPAF_BGR | MPAF_RGB24_R8G8B8)
//							 X	X  X  X	 X	X  B  B  B  B  B  B  G  G  G  G  G  G  R  R  R  R  R  R 
#define		MPAF_RGB24_B6G6R6		(MPAF_BGR | MPAF_RGB24_R6G6B6)

//	 X	X  X  X	 X	X  X  X	 R	R  R  R	 R	R  R  R  G  G  G  G  G  G  G  G  B  B  B  B  B  B  B  B  
#define		MPAF_RGB32_R8G8B8		(MPAF_RGB_BASE | MPAF_32BITS | MPAF_MAKE_R(8) | MPAF_MAKE_G(8) | MPAF_MAKE_B(8))
//	 A	A  A  A	 A	A  A  A	 R	R  R  R	 R	R  R  R  G  G  G  G  G  G  G  G  B  B  B  B  B  B  B  B  
#define		MPAF_RGB32_A8R8G8B8		(MPAF_RGBA_BASE | MPAF_32BITS | MPAF_MAKE_R(8) | MPAF_MAKE_G(8) | MPAF_MAKE_B(8))
//	 X	X  X  X	 X	X  X  X	 B  B  B  B  B  B  B  B  G  G  G  G  G  G  G  G  R	R  R  R	 R	R  R  R  
#define		MPAF_RGB32_B8G8R8		(MPAF_BGR | MPAF_RGB32_R8G8B8)
//	 B  B  B  B  B  B  B  B  G  G  G  G  G  G  G  G  R	R  R  R	 R	R  R  R  A	A  A  A	 A	A  A  A
#define		MPAF_RGB32_B8G8R8A8		(MPAF_BGR | MPAF_RGB32_A8R8G8B8)

//	 R	R  R  R	 R	R  R  R  G  G  G  G  G  G  G  G  B  B  B  B  B  B  B  B  A	A  A  A	 A	A  A  A
#define     MPAF_RGB32_R8G8B8A8    (MPAF_XXXA | MPAF_RGB32_A8R8G8B8)
//	 A	A  A  A	 A	A  A  A	 B  B  B  B  B  B  B  B  G  G  G  G  G  G  G  G  R	R  R  R	 R	R  R  R  
#define     MPAF_RGB32_A8B8G8R8    (MPAF_BGR | MPAF_RGB32_R8G8B8A8)



//			Y0, U0, V0																				
#define		MPAF_YUV				(MPAF_YUV_BASE | MPAF_MAKE_H(1) | MPAF_MAKE_V(1))
//			Y0, V0, U0																				
#define		MPAF_YVU				(MPAF_YUV | MPAF_YUV_VU)
//			U0, V0, Y0																				
#define		MPAF_UVY				(MPAF_YUV | MPAF_YUV_UVY)
//			V0, U0, Y0																				
#define		MPAF_VUY				(MPAF_YUV | MPAF_YUV_VU | MPAF_YUV_UVY)

//			Y0, U0, Y1, V0																			
#define		MPAF_YUYV				(MPAF_YUV_BASE | MPAF_MAKE_H(2) | MPAF_MAKE_V(1))
//			Y0, V0, Y1, U0																			
#define		MPAF_YVYU				(MPAF_YUYV | MPAF_YUV_VU)
//			U0, Y0, V0, Y1																			
#define		MPAF_UYVY				(MPAF_YUYV | MPAF_YUV_UVY)
//			V0, Y0, U0, Y1																			
#define		MPAF_VYUY				(MPAF_YUYV | MPAF_YUV_VU | MPAF_YUV_UVY)
//			Y1, U0, Y0, V0																			
#define		MPAF_YUYV2				(MPAF_YUYV | MPAF_YUV_Y1Y0)
//			Y1, V0, Y0, U0																			
#define		MPAF_YVYU2				(MPAF_YVYU | MPAF_YUV_Y1Y0)
//			U0, Y1, V0, Y0																			
#define		MPAF_UYVY2				(MPAF_UYVY | MPAF_YUV_Y1Y0)
//			V0, Y1, U0, Y0																			
#define		MPAF_VYUY2				(MPAF_VYUY | MPAF_YUV_Y1Y0)

#define		MPAF_CMY                  (0x10000000)

#define		MPAF_CMYK				(MPAF_CMY | MPAF_I420)
//8 bit Y plane followed by 8 bit 2x2 subsampled U and V planes
#define		MPAF_I420				(MPAF_YUV_BASE | MPAF_YUV_PLANAR | MPAF_MAKE_H(2) | MPAF_MAKE_V(2))
//8 bit Y plane followed by 8 bit 1x2 subsampled U and V planes
#define		MPAF_I422V				(MPAF_YUV_BASE | MPAF_YUV_PLANAR | MPAF_MAKE_H(1) | MPAF_MAKE_V(2))
//8 bit Y plane followed by 8 bit 2x1 subsampled U and V planes
#define		MPAF_I422H				(MPAF_YUV_BASE | MPAF_YUV_PLANAR | MPAF_MAKE_H(2) | MPAF_MAKE_V(1))
//8 bit Y plane followed by 8 bit U and V planes
#define		MPAF_I444				(MPAF_YUV_BASE | MPAF_YUV_PLANAR | MPAF_MAKE_H(1) | MPAF_MAKE_V(1))
//8 bit Y plane followed by 8 bit 2x2 subsampled V and U planes
#define		MPAF_YV12				(MPAF_I420 | MPAF_YUV_VU)
//8 bit Y plane followed by 8 bit 1x2 subsampled V and U planes	
#define		MPAF_YV16V				(MPAF_I422V | MPAF_YUV_VU)
//8 bit Y plane followed by 8 bit 2x1 subsampled V and U planes
#define		MPAF_YV16H				(MPAF_I422H | MPAF_YUV_VU)
//8 bit Y plane followed by 8 bit V and U planes
#define		MPAF_YV24				(MPAF_I444 | MPAF_YUV_VU)

//Y sample at every pixel, U and V sampled at every fourth pixel horizontally on each line 
#define		MPAF_Y41PH				(MPAF_YUV_BASE | MPAF_YUV_PLANAR | MPAF_MAKE_H(4) | MPAF_MAKE_V(1))
//Y sample at every pixel, U and V sampled at every fourth pixel vertical on each line 
#define		MPAF_Y41PV				(MPAF_YUV_BASE | MPAF_YUV_PLANAR | MPAF_MAKE_H(1) | MPAF_MAKE_V(4))

//Y sample at every pixel, U and V sampled at every two pixels horizontally on each line 
//and at every fourth pixels in vertical
#define		MPAF_YH2V4				(MPAF_YUV_BASE | MPAF_YUV_PLANAR | MPAF_MAKE_H(2) | MPAF_MAKE_V(4))

#define		MPAF_GRAY1				(MPAF_GRAY_BASE | MPAF_1BITS)
#define		MPAF_GRAY2				(MPAF_GRAY_BASE | MPAF_2BITS)
#define		MPAF_GRAY4				(MPAF_GRAY_BASE | MPAF_4BITS)
#define		MPAF_GRAY8				(MPAF_GRAY_BASE | MPAF_8BITS)
#define		MPAF_GRAY16				(MPAF_GRAY_BASE | MPAF_16BITS)

#define		MPAF_OTHERS_DCT			(MPAF_OTHERS | 0x01)
//8 bit Y plane followed by 8 bit 2x2 interleaved V/U plane 
#define		MPAF_OTHERS_NV21		(MPAF_OTHERS | 0x02)
#define		MPAF_OTHERS_NV12		(MPAF_OTHERS | 0x03)

#define     MPAF_YUV422_SEMIPLANAR  (MPAF_OTHERS | 0x04)
#define     MPAF_YVU422_SEMIPLANAR  (MPAF_OTHERS | 0x05)
#define     MPAF_OTHERS_NV12TILE    (MPAF_OTHERS | 0x06)
#define     MPAF_OTHERS_YYUV        (MPAF_OTHERS | 0x08)
#define		MPAF_OTHERS_TEXTURE		(MPAF_OTHERS | 0x09)

#define		MPAF_SIGNED				0x4000
#define		MPAF_R_BASE				MPAF_GRAY_BASE
#define		MPAF_R16				(MPAF_R_BASE | MPAF_16BITS)
#define		MPAF_R16_R16			(MPAF_R16 | MPAF_MAKE_R(16))
#define		MPAF_R16_R16U			(MPAF_R16_R16)
#define		MPAF_R16_R16S			(MPAF_R16_R16 | MPAF_SIGNED)

#define		MPAF_RG32				(MPAF_RG_BASE | MPAF_32BITS)
#define		MPAF_RG32_R16G16		(MPAF_RG32 | MPAF_MAKE_R(16) | MPAF_MAKE_G(16))
#define		MPAF_RG32_R16G16U		(MPAF_RG32_R16G16)
#define		MPAF_RG32_R16G16S		(MPAF_RG32_R16G16 | MPAF_SIGNED)

#define		MPAF_CT_ETC_BIT			0x10000
#define		MPAF_CT_ASTC_BIT		0x20000

#define		MPAF_CT_ETC1_BIT		0x1000
#define		MPAF_CT_ETC2_BIT		0x2000
#define		MPAF_CT_ETC				(MPAF_CT_BASE | MPAF_CT_ETC_BIT)
#define		MPAF_CT_ETC1			(MPAF_CT_ETC | MPAF_CT_ETC1_BIT)
#define		MPAF_CT_ETC2			(MPAF_CT_ETC | MPAF_CT_ETC2_BIT)

#define		MPAF_ETC1_RGB8			(MPAF_CT_ETC1 | 0x100)
#define		MPAF_ETC2_RGB8			(MPAF_CT_ETC2 | 0x100)
#define		MPAF_ETC2_SRGB8			(MPAF_CT_ETC2 | 0x200)
#define		MPAF_ETC2_RGBA8			(MPAF_CT_ETC2 | 0x300)
#define		MPAF_ETC2_SRGBA8		(MPAF_CT_ETC2 | 0x400)
#define		MPAF_ETC2_RGB8A1		(MPAF_CT_ETC2 | 0x500)
#define		MPAF_ETC2_SRGB8A1		(MPAF_CT_ETC2 | 0x600)
#define		MPAF_ETC2_R11_EAC		(MPAF_CT_ETC2 | 0x700)
#define		MPAF_ETC2_R11S_EAC		(MPAF_CT_ETC2 | 0x800)
#define		MPAF_ETC2_RG11_EAC		(MPAF_CT_ETC2 | 0x900)
#define		MPAF_ETC2_RG11S_EAC		(MPAF_CT_ETC2 | 0xA00)


#define		MPAF_ASTC_RGBA_BIT		0x1000
#define		MPAF_ASTC_SRGBA_BIT		0x2000
#define		MPAF_ASTC_RGBA_3D_BIT	0x3000
#define		MPAF_ASTC_SRGBA_3D_BIT	0x4000
#define		MPAF_CT_ASTC			(MPAF_CT_BASE | MPAF_CT_ASTC_BIT)
#define		MPAF_CT_ASTC_RGBA		(MPAF_CT_ASTC | MPAF_ASTC_RGBA_BIT)
#define		MPAF_CT_ASTC_SRGBA		(MPAF_CT_ASTC | MPAF_ASTC_SRGBA_BIT)
#define		MPAF_CT_ASTC_RGBA_3D	(MPAF_CT_ASTC | MPAF_ASTC_RGBA_3D_BIT)
#define		MPAF_CT_ASTC_SRGBA_3D	(MPAF_CT_ASTC | MPAF_ASTC_SRGBA_3D_BIT)

#define		MPAF_ASTC_RGBA_4x4		(MPAF_CT_ASTC_RGBA | 0x100)
#define		MPAF_ASTC_RGBA_5x4		(MPAF_CT_ASTC_RGBA | 0x200)
#define		MPAF_ASTC_RGBA_5x5		(MPAF_CT_ASTC_RGBA | 0x300)
#define		MPAF_ASTC_RGBA_6x5		(MPAF_CT_ASTC_RGBA | 0x400)
#define		MPAF_ASTC_RGBA_6x6		(MPAF_CT_ASTC_RGBA | 0x500)
#define		MPAF_ASTC_RGBA_8x5		(MPAF_CT_ASTC_RGBA | 0x600)
#define		MPAF_ASTC_RGBA_8x6		(MPAF_CT_ASTC_RGBA | 0x700)
#define		MPAF_ASTC_RGBA_8x8		(MPAF_CT_ASTC_RGBA | 0x800)
#define		MPAF_ASTC_RGBA_10x5		(MPAF_CT_ASTC_RGBA | 0x900)
#define		MPAF_ASTC_RGBA_10x6		(MPAF_CT_ASTC_RGBA | 0xA00)
#define		MPAF_ASTC_RGBA_10x8		(MPAF_CT_ASTC_RGBA | 0xB00)
#define		MPAF_ASTC_RGBA_10x10	(MPAF_CT_ASTC_RGBA | 0xC00)
#define		MPAF_ASTC_RGBA_12x10	(MPAF_CT_ASTC_RGBA | 0xD00)
#define		MPAF_ASTC_RGBA_12x12	(MPAF_CT_ASTC_RGBA | 0xE00)

#define		MPAF_ASTC_SRGBA_4x4		(MPAF_CT_ASTC_SRGBA | 0x100)
#define		MPAF_ASTC_SRGBA_5x4		(MPAF_CT_ASTC_SRGBA | 0x200)
#define		MPAF_ASTC_SRGBA_5x5		(MPAF_CT_ASTC_SRGBA | 0x300)
#define		MPAF_ASTC_SRGBA_6x5		(MPAF_CT_ASTC_SRGBA | 0x400)
#define		MPAF_ASTC_SRGBA_6x6		(MPAF_CT_ASTC_SRGBA | 0x500)
#define		MPAF_ASTC_SRGBA_8x5		(MPAF_CT_ASTC_SRGBA | 0x600)
#define		MPAF_ASTC_SRGBA_8x6		(MPAF_CT_ASTC_SRGBA | 0x700)
#define		MPAF_ASTC_SRGBA_8x8		(MPAF_CT_ASTC_SRGBA | 0x800)
#define		MPAF_ASTC_SRGBA_10x5	(MPAF_CT_ASTC_SRGBA | 0x900)
#define		MPAF_ASTC_SRGBA_10x6	(MPAF_CT_ASTC_SRGBA | 0xA00)
#define		MPAF_ASTC_SRGBA_10x8	(MPAF_CT_ASTC_SRGBA | 0xB00)
#define		MPAF_ASTC_SRGBA_10x10	(MPAF_CT_ASTC_SRGBA | 0xC00)
#define		MPAF_ASTC_SRGBA_12x10	(MPAF_CT_ASTC_SRGBA | 0xD00)
#define		MPAF_ASTC_SRGBA_12x12	(MPAF_CT_ASTC_SRGBA | 0xE00)

#define		MPAF_ASTC_RGBA_3x3x3	(MPAF_CT_ASTC_RGBA_3D | 0x100)
#define		MPAF_ASTC_RGBA_4x3x3	(MPAF_CT_ASTC_RGBA_3D | 0x200)
#define		MPAF_ASTC_RGBA_4x4x3	(MPAF_CT_ASTC_RGBA_3D | 0x300)
#define		MPAF_ASTC_RGBA_4x4x4	(MPAF_CT_ASTC_RGBA_3D | 0x400)
#define		MPAF_ASTC_RGBA_5x4x4	(MPAF_CT_ASTC_RGBA_3D | 0x500)
#define		MPAF_ASTC_RGBA_5x5x4	(MPAF_CT_ASTC_RGBA_3D | 0x600)
#define		MPAF_ASTC_RGBA_5x5x5	(MPAF_CT_ASTC_RGBA_3D | 0x700)
#define		MPAF_ASTC_RGBA_6x5x5	(MPAF_CT_ASTC_RGBA_3D | 0x800)
#define		MPAF_ASTC_RGBA_6x6x5	(MPAF_CT_ASTC_RGBA_3D | 0x900)
#define		MPAF_ASTC_RGBA_6x6x6	(MPAF_CT_ASTC_RGBA_3D | 0xA00)

#define		MPAF_ASTC_SRGBA_3x3x3	(MPAF_CT_ASTC_SRGBA_3D | 0x100)
#define		MPAF_ASTC_SRGBA_4x3x3	(MPAF_CT_ASTC_SRGBA_3D | 0x200)
#define		MPAF_ASTC_SRGBA_4x4x3	(MPAF_CT_ASTC_SRGBA_3D | 0x300)
#define		MPAF_ASTC_SRGBA_4x4x4	(MPAF_CT_ASTC_SRGBA_3D | 0x400)
#define		MPAF_ASTC_SRGBA_5x4x4	(MPAF_CT_ASTC_SRGBA_3D | 0x500)
#define		MPAF_ASTC_SRGBA_5x5x4	(MPAF_CT_ASTC_SRGBA_3D | 0x600)
#define		MPAF_ASTC_SRGBA_5x5x5	(MPAF_CT_ASTC_SRGBA_3D | 0x700)
#define		MPAF_ASTC_SRGBA_6x5x5	(MPAF_CT_ASTC_SRGBA_3D | 0x800)
#define		MPAF_ASTC_SRGBA_6x6x5	(MPAF_CT_ASTC_SRGBA_3D | 0x900)
#define		MPAF_ASTC_SRGBA_6x6x6	(MPAF_CT_ASTC_SRGBA_3D | 0xA00)

#define		MRGB(r,g,b)			(((0xFF&(b))<<16) | ((0xFF&(g))<<8) | (0xFF&(r)))
#define		MRGBA(r,g,b,a)		(((0xFF&(a))<<24) | ((0xFF&(b))<<16) | ((0xFF&(g))<<8) | (0xFF&(r)))
#define		MRGB_R(rgb)         ((rgb)&0x00FF)
#define		MRGB_G(rgb)         (((rgb)>>8)&0x00FF)
#define		MRGB_B(rgb)         (((rgb)>>16)&0x00FF)
#define		MRGBA_A(rgb)        (((rgb)>>24)&0x00FF)

 

typedef struct __tag_size
{
	MLong	cx;
	MLong	cy;
}MSIZE, *LPMSIZE;



#define		MPAF_MAX_PLANES			3


typedef struct __tag_MBITMAP
{
	MDWord	dwPixelArrayFormat;
	MLong	lWidth;
	MLong	lHeight;
	union {
		MLong	lPitch[MPAF_MAX_PLANES];
		struct {
			MLong wStride;	// width stride
			MLong lLayers;	// layer number or image depth
			MLong lStride;	// layer stride or depth pitch
		};
		struct {
			MLong lDataSize;
			MLong lLayerNum;
			MLong lPadding1;
		};
	};
	MByte*	pPlane[MPAF_MAX_PLANES];
}MBITMAP, *LPMBITMAP;

 



typedef enum __tag_malignment
{
	MALIGNMENT_NONE = 0x00000000,
	MALIGNMENT_LEFT,
	MALIGNMENT_RIGHT,
	MALIGNMENT_TOP,
	MALIGNMENT_BOTTOM,
	MALIGNMENT_CENTERED
} MALIGNMENT;


#define 	MFONTFACE_NORMAL	0x00000000
#define 	MFONTFACE_BOLD		0x00000001
#define 	MFONTFACE_ITALIC	0x00000002
#define 	MFONTFACE_UNDERLINE	0x00000004


typedef struct __tag_mdisplay_info
{			
	MBool				bSupportNormalDisplay;
	MBool				bSupportOverlay;
	MDWord				emNormalCSType;
	MDWord				emOverlayCSType;
	MDWord				dwWidth;
	MDWord				dwHeight;
} MDISPLAYINFO;


typedef struct __tag_mtext_renderstyle
{			
	MDWord				dwFontFace;
	MDWord				dwFontSize;
	MDWord				dwTextColor;
	MDWord				dwBackColor;
	MALIGNMENT			horizAlignment;
	MALIGNMENT			vertAligntment;
} MTEXTRENDERSTYLE;

#ifdef __cplusplus
extern "C" {
#endif

MHandle MCreateDisplayContext(MHandle env, MHandle surface);
MVoid MDestroyDisplayContext(MHandle hDisplayContext);

MRESULT MQueryDisplayInfo(MDISPLAYINFO *pDisplayInfo);
MHandle MDisplayInitialize(MHandle hDisplayContext);
MRESULT MDisplayUninitialize(MHandle hDisplay);
MRESULT MDisplayUpdate(MHandle hDisplay, MByte* pFrameBuf, MDWord dwFrameLen, MRECT* pRect);
MHandle MOverlayInitialize(MHandle hOverlayContext, MRECT * pOverlayRect);
MRESULT MOverlayUninitialize(MHandle hOverlay);
MBITMAP *MOverlayLock(MHandle hOverlay);
MRESULT MOverlayUnlock(MHandle hOverlay);
MRESULT MOverlayUpdate(MHandle hOVerlay, MRECT *pRect);
MRESULT MOverlaySetRegion(MHandle hOverlay, MRECT* pDisplayRect, MRECT* pBitmapRect);
MHandle MTextRendererInitialize(MHandle hDisplayContext, MRECT *prectText);
MRESULT MTextRendererUninitialize(MHandle hRenderer);
MRESULT MTextRendererRender(MHandle hRenderer, MVoid* szText, MDWord szLen, MRECT* pRectShow);
MRESULT MTextRendererSetStyle(MHandle hRenderer, MTEXTRENDERSTYLE* pStyle);


#ifdef __cplusplus
}
#endif










































































/*********************************************************************************
**********************************************************************************
**************Removed following struct which have been deprecated**************
**********************************************************************************
**********************************************************************************/

typedef enum __tag_pixel_array_format
{
	PAF_R8G8B8					= 0x00000001,
	PAF_B8G8R8					= 0x2,
	PAF_R6G6B6					= 0x3,
	PAF_B6G6R6					= 0x4,
	PAF_R5G6B5					= 0x5,
	PAF_B5G6R5					= 0x6,
	PAF_YVYU					= 0x7,
	PAF_YUYV					= 0x8,
	PAF_UYVY					= 0x9,
	PAF_VYUY					= 0xA,
	PAF_YCrYCb					= 0xB,
	PAF_YCbYCr					= 0xC,
	PAF_CrYCbY					= 0xD,
	PAF_CbYCrY					= 0xE,
	PAF_YUV420PL				= 0xF,
	PAF_YUV422PL				= 0x10,
	PAF_R4G4B4					= 0x11,
	PAF_GREY					= 0x12,
	PAF_YUV422VPL				= 0x13,
	PAF_YUV422HPL				= 0x14,
	PAF_YUV444PL				= 0x15,
	PAF_INDEX1					= 0x16,
	PAF_INDEX2					= 0x17,
	PAF_INDEX4					= 0x18,
	PAF_INDEX8					= 0x19,
	PAF_GRAY1					= 0x1A,
	PAF_GRAY2					= 0x1B,
	PAF_GRAY4					= 0x1C,
	PAF_GRAY8					= 0x1D,
	PAF_GRAY16					= 0x1E,
	PAF_B5G5R5					= 0x1F,
	PAF_R5G5B5					= 0x20,
	PAF_B4G4R4					= 0x21,
	PAF_A8B8G8R8				= 0x22,
	PAF_A8R8G8B8				= 0x23,
	PAF_R8G8B8A8				= 0x24,
	PAF_B8G8R8A8				= 0x25,
	PAF_DCT						= 0x26,
	PAF_YV12					= 0x27,
	PAF_UYVY2					= 0x28,
	PAF_VYUY2					= 0x29,
	PAF_YUV411HPL				= 0x2A,
	PAF_YUV411VPL				= 0x2B,
	PAF_TEXTURE				= 0x2C
} PIXELARRAYFORMAT;

#endif

