#ifndef __AMIMAGEPROCESS_H__
#define __AMIMAGEPROCESS_H__

#include "amcomdef.h"
#include "amdisplay.h"

#if defined(__MIPSYMBIAN32__)
#include <e32def.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#if defined(__MIPSYMBIAN32__)
	#define MIP_IMPORT IMPORT_C
#else
	#define MIP_IMPORT
#endif

#define MIP_IN
#define MIP_OUT
#define MIP_INOUT
#define MIP_FORMULA_SZIE (sizeof(MLong) * 4 * 3)
#define MIP_AUTOFIX_FORMULA_SIZE (sizeof(MLong) * 30) 

//Processor Type
#define MIP_PROCESSOR_ARM7					0x001	//Reserved; ARM7 series
#define MIP_PROCESSOR_ARM9E					0x002	//ARM9 series with enhance DSP instruction, bilinear interpolation will get better performance
#define MIP_PROCESSOR_ARM11					0x003	//ARM11 series, bilinear interpolation will get better performance
#define MIP_PROCESSOR_XSCALE				0x004	//Intel XScale series, bilinear interpolation and non stretch convert will get better performance.

//error code
#define MERR_UNMERGEABLE					(MERR_BASIC_BASE+0x100)

#define MIP_EID_BASE					0x1000
#define	MIP_EID_MERGE					(MIP_EID_BASE + (1<<8))
#define	MIP_EID_FILLCOLOR				(MIP_EID_BASE + (2<<8))
#define	MIP_EID_BRIGHTNESS_CONTRAST		(MIP_EID_BASE + (3<<8))
#define	MIP_EID_HUE_SATURATION 			(MIP_EID_BASE + (4<<8))
#define	MIP_EID_GAMMA					(MIP_EID_BASE + (5<<8))
#define	MIP_EID_AUTOLEVEL				(MIP_EID_BASE + (6<<8))
#define	MIP_EID_GRAY					(MIP_EID_BASE + (7<<8))
#define	MIP_EID_NEGATIVE				(MIP_EID_BASE + (8<<8))
#define	MIP_EID_SEPIA					(MIP_EID_BASE + (9<<8))
#define	MIP_EID_SHARPEN		 			(MIP_EID_BASE + (10<<8)) 
#define	MIP_EID_BLUR					(MIP_EID_BASE + (11<<8)) 
#define	MIP_EID_DESPECKLE				(MIP_EID_BASE + (12<<8)) 
#define	MIP_EID_EMBOSS					(MIP_EID_BASE + (13<<8)) 
#define	MIP_EID_SKETCH					(MIP_EID_BASE + (14<<8)) 
#define	MIP_EID_COLORCHANNEL			(MIP_EID_BASE + (15<<8)) 
#define	MIP_EID_DITHER		 			(MIP_EID_BASE + (16<<8)) 
#define	MIP_EID_SOLARIZE				(MIP_EID_BASE + (17<<8)) 
#define MIP_EID_OILPAINTING				(MIP_EID_BASE + (18<<8)) 
#define MIP_EID_PINCH					(MIP_EID_BASE + (19<<8)) 
#define MIP_EID_DENOISE					(MIP_EID_BASE + (20<<8)) 
#define MIP_EID_WARPING					(MIP_EID_BASE + (21<<8)) 
#define MIP_EID_NOISE					(MIP_EID_BASE + (22<<8))

#define MIP_EID_OLDPHOTO				(MIP_EID_BASE + (23<<8))
#define MIP_EID_GRAYNEGATIVE			(MIP_EID_BASE + (24<<8))
#define MIP_EID_BULGE					(MIP_EID_BASE + (25<<8))
#define MIP_EID_MIRROR					(MIP_EID_BASE + (26<<8))
#define MIP_EID_SPOTLIGHT				(MIP_EID_BASE + (27<<8))
#define MIP_EID_STAMP					(MIP_EID_BASE + (28<<8))
#define MIP_EID_POSTERIZE				(MIP_EID_BASE + (29<<8))
#define MIP_EID_COLORBOOST				(MIP_EID_BASE + (30<<8))
#define MIP_EID_MOONLIGHT				(MIP_EID_BASE + (31<<8))
#define MIP_EID_FOG						(MIP_EID_BASE + (32<<8))
#define MIP_EID_FOCUS					(MIP_EID_BASE + (33<<8))
#define MIP_EID_FROSTEDGLASS			(MIP_EID_BASE + (34<<8))
#define MIP_EID_ANTIQUE					(MIP_EID_BASE + (35<<8))
#define MIP_EID_GLOW					(MIP_EID_BASE + (36<<8))
#define MIP_EID_CARTOON					(MIP_EID_BASE + (37<<8))
#define MIP_EID_GLASSFILTER				(MIP_EID_BASE + (38<<8))
#define MIP_EID_PUZZLE					(MIP_EID_BASE + (39<<8))
#define MIP_EID_3D_GRID					(MIP_EID_BASE + (40<<8))
#define MIP_EID_SURFACE					(MIP_EID_BASE + (41<<8))
#define MIP_EID_SPLASH					(MIP_EID_BASE + (42<<8))
#define MIP_EID_RAINDROP				(MIP_EID_BASE + (43<<8))
#define MIP_EID_NEON					(MIP_EID_BASE + (44<<8))
#define MIP_EID_FIRELIGHT				(MIP_EID_BASE + (45<<8))
#define MIP_EID_CHARCOAL				(MIP_EID_BASE + (46<<8))
#define MIP_EID_WATERCOLOR				(MIP_EID_BASE + (47<<8))//added bu lbzhao
#define MIP_EID_FLAME					(MIP_EID_BASE + (48<<8))
#define MIP_EID_WATERDROPS				(MIP_EID_BASE + (49<<8))
#define MIP_EID_MOSAIC					(MIP_EID_BASE + (50<<8))
#define MIP_EID_LAKE					(MIP_EID_BASE + (51<<8))

#define MIP_EID_STRAIGHTEN				(MIP_EID_BASE + (52<<8))

#define MIP_EID_AUTOCONTRAST			(MIP_EID_BASE + (53<<8))
#define MIP_EID_AUTOCOLOR				(MIP_EID_BASE + (54<<8))
#define MIP_EID_AUTOEXPOSURE			(MIP_EID_BASE + (55<<8))

#define MIP_EID_WARMCOLOR				(MIP_EID_BASE + (56<<8))
#define MIP_EID_COLDCOLOR				(MIP_EID_BASE + (57<<8))
#define MIP_EID_HIGHLIGHTSSHADOWS		(MIP_EID_BASE + (58<<8))
#define MIP_EID_WHITEBALANCE			(MIP_EID_BASE + (59<<8))
#define MIP_EID_FOCALWHITEBLACK			(MIP_EID_BASE + (60<<8))
#define MIP_EID_DYNAMICLIGHTING			(MIP_EID_BASE + (61<<8))
#define MIP_EID_MOONNIGHT               (MIP_EID_BASE + (62<<8))//added for moon night
#define MIP_EID_GPEN                    (MIP_EID_BASE + (63<<8))//added for G pen
#define MIP_EID_VIVID                   (MIP_EID_BASE + (64<<8))//added for vivid
#define MIP_EID_LOMO                    (MIP_EID_BASE + (65<<8))//added for lomo
#define MIP_EID_DIFFUSE                 (MIP_EID_BASE + (66<<8))//added for diffuse
#define MIP_EID_MILKY                   (MIP_EID_BASE + (67<<8))//added for milky
#define MIP_EID_AUTOFIX                 (MIP_EID_BASE + (68<<8))
#define MIP_EID_AUTOFIX_BRIGHTNESS      (MIP_EID_BASE + (69<<8))
#define MIP_EID_HALFTONE                (MIP_EID_BASE + (70<<8))
#define MIP_EID_PMDENOISE				(MIP_EID_BASE + (71<<8))//added for pmdenoise
#define MIP_EID_SINGLECOLOR				(MIP_EID_BASE + (72<<8))//added for singlecolor
#define MIP_EID_KALEIDOSCOPE			(MIP_EID_BASE + (73<<8))
#define MIP_EID_FISHEYE					(MIP_EID_BASE + (74<<8))
#define MIP_EID_POLAROID				(MIP_EID_BASE + (75<<8))
#define MIP_EID_MINIATURE				(MIP_EID_BASE + (76<<8))
#define MIP_EID_PARTIALCOLOR			(MIP_EID_BASE + (77<<8))
#define MIP_EID_NOSTALGIC				(MIP_EID_BASE + (78<<8))
#define MIP_EID_VINTAGE					(MIP_EID_BASE + (79<<8))
#define MIP_EID_DEEPQUITE				(MIP_EID_BASE + (80<<8))
#define MIP_EID_COLDBLUE				(MIP_EID_BASE + (81<<8))
#define MIP_EID_GOTHIC					(MIP_EID_BASE + (82<<8))
#define MIP_EID_PURPLE					(MIP_EID_BASE + (83<<8))
#define MIP_EID_VINTAGEBLACKWHITE		(MIP_EID_BASE + (84<<8))
#define MIP_EID_FISHEYEMAGNIFIER		(MIP_EID_BASE + (85<<8))
#define MIP_EID_FOURCOLORPOSTER			(MIP_EID_BASE + (86<<8))
#define MIP_EID_COLORGRADIENT			(MIP_EID_BASE + (87<<8))
#define MIP_EID_POP						(MIP_EID_BASE + (88<<8))	
#define MIP_EID_SUNNY					(MIP_EID_BASE + (89<<8))
#define MIP_EID_CURVEBRIGHTNESS			(MIP_EID_BASE + (90<<8))
#define MIP_EID_NEWSKETCH				(MIP_EID_BASE + (91<<8))
#define MIP_EID_SUNSET					(MIP_EID_BASE + (92<<8))
#define MIP_EID_NEWEMBOSS				(MIP_EID_BASE + (93<<8))

#define  MIP_STRAIGHTEN_HIGHSPEED 0
#define  MIP_STRAIGHTEN_HIGHQUALITY 1


//typedef enum __tag_wbtype { 
//	ASSHOT, AUTOWB, DAYLIGHT, CLOUDY, SHADE, TUNGSTEN, FLUORESCENT, FLASH, CUSTOMWB
//}MWBTYPE;
//for white balance
#define  ASSHOT       0x00
#define  AUTOWB       0x01
#define  DAYLIGHT     0x02
#define  CLOUDY       0x03
#define  SHADE        0x04
#define  TUNGSTEN     0x05
#define  FLUORESCENT  0x06
#define  FLASH        0x07
#define  CUSTOMWB     0x08

//typedef enum _tag_lomotype
//{
//	LOMO_WARMCOLOR,LOMO_COLDCOLOR,LOMO_DARKCORNER
//}LomoType;
//for lomo type
#define  LOMO_WARMCOLOR       0x00
#define  LOMO_COLDCOLOR       0x01
#define  LOMO_DARKCORNER      0x02
#define  LOMO_MAGIC           0x03
#define  LOMO_SOFT			  0x04

typedef struct __tag_mippixel
{
	MDWord		dwSpaceID;		//ID of color space, sample: MPAF_RGB16_R5G6B5, MPAF_RGB24_R8G8B8, MPAF_I420, (MPAF_I420| MPAF_BT601_YCBCR)
	MLong		lWidth;		//Specifies the width of the bitmap, in pixels
	MLong		lHeight;		//Specifies the height of the bitmap, in pixels
} MIPPIXEL, *LPIPFPIXEL;

typedef struct __tag_mipdata
{
	MByte		*pPlane[MPAF_MAX_PLANES];
	MLong		lPitch[MPAF_MAX_PLANES];
} MIPData, *LPIPData;

typedef struct __tag_mergefillcolorparam 
{
	MDWord	dwTransparent;//for fillcolor and merge only 0 to 100
	MDWord	dwFillColor;//for fillcolor only 
}MergeFillcolorPARAM;
typedef struct __tag_bricontrastparam 
{
	MLong	lBrightness;//Value for brightness adjust, -100~100, 0 means adjust none
	MLong	lContrast;	//Value for contrast adjust, -100~100, 0 means adjust none
}BriContrastPARAM;
typedef struct __tag_huesaturationparam 
{
	MLong	lHue;//-180~180, 0 means adjust none
	MLong	lSaturation;//-100~100, 0 means adjust none
}HueSaturationPARAM;

typedef struct __tag_sketchparam 
{
	MLong	lSketchThreshold;//0~255 80 for normal
	MLong	IsGray;//0 or 1:stand for color or gray
}SketchPARAM;
typedef struct __tag_embossparam 
{
	MLong	lDepth ;//1~255 the intensity of effect 
	MLong	IsGray;//0 is color emboss 
	//MLong	lClrAction ;//set the color value 
	//MLong	lDirection ;//1~8;eight direction
}EmbossPARAM;

typedef struct __tag_diffuseparam 
{
	MLong	lSize ;//1~20 the intensity of effect 
}DiffusePARAM;

typedef struct _tag_lomoparam
{
    MDWord lType;
	MLong lOriginX;
	MLong lOriginY;
	MLong lRadiusW;
	MLong lRadiusH;
}LomoPARAM;
typedef struct __tag_surfaceparam
{	
	MBITMAP bmpMask;	
	MDWord  dwSurfaceLevel;//0 ,1, 2
}SurfacePARAM;

typedef struct __tag_halftoneparam
{	
	MBITMAP halftoneMask;	
	MLong  dwPatternSize;//(-10 ~ 10)
}HALFTONEPARAM;

typedef struct __tag_focusparam
{	
	MLong  lFocusRadius;//1~
	MLong  lFocusCentX;//0 ~ ImageWidth
	MLong  lFocusCentY;//0 ~ ImageHeight
	
}FOCUSPARAM;
typedef struct __tag_warpparam
{	
	MDWord  IsInflate;
	MLong	lWarpIntensity;//1~20
}WarpPARAM;
// for new
typedef struct __tag_autoprocessparam
{
	MLong	lAutoProFormula[12];
}AutoProcessPARAM;
typedef struct __tag_colorchannelparam
{
	MLong	lR; //-100~100
	MLong	lG; //-100~100
	MLong	lB; //-100~100
}ColorChannelPARAM;

typedef struct __tag_sharpenparam
{
	MLong SharpenALPHA; //0~100
}SharpenPARAM;

typedef struct __tag_blurparam
{
	MLong lBlurSize;//1~60
}BlurPARAM;

typedef struct __tag_oilpaintparam
{
	MLong lOilPaintDepth;//2~15
}OilPaintPARAM;

typedef struct __tag_noiseparam
{
	MLong lNoiseIntensity;//1~32
}NoisePARAM;

typedef struct __tag_posterizeparam
{
	MLong lPosterizeLevel;//2~10
}PosterizePARAM;

typedef struct __tag_m3dgridparam
{
	MLong l3DGridSize;//2~
}M3DGridPARAM;

typedef struct __tag_straightenparam
{
	MLong lStraightenAngle;//-15~15
	MDWord dwQualityOrSpeed;//MIP_STRAIGHTEN_HIGHSPEED or MIP_STRAIGHTEN_HIGHQUALITY
}StraightenPARAM;

typedef struct __tag_mosaicparam
{
	MLong lMosaicSize;//2~12
}MosaicPARAM;

typedef struct __tag_cartoonparam
{
	MLong lCartoonDepth;//1-7
	MLong lCartoonThre;//2-20; 6 is best
}CartoonPARAM;

typedef struct __tag_stampparam
{
	MLong lStampDepth;//1-7
	MLong lStampThre;//2-20; 6 is best
}StampPARAM;

typedef struct __tag_highlightshadowparam
{
	MLong lHighlights;//-100~100
	MLong lLights;//-100~100
	MLong lDarks;//-100~100
	MLong lShadows;//-100~100
}HighlightShadowPARAM;

typedef struct __tag_spotlightparam
{	
	MLong  lSpotLightRadius;//1~
	MLong  lSpotLightCentX;//0 ~ ImageWidth
	MLong  lSpotLightCentY;//0 ~ ImageHeight
}SpotLightPARAM;

typedef struct __tag_focalwhiteblackparam
{	
	MLong  lFocalWBRadius;//1~
	MLong  lFocalWBCentX;//0 ~ ImageWidth
	MLong  lFocalWBCentY;//0 ~ ImageHeight
}FocalWhiteBlackPARAM;

typedef struct  __tag_whitebalanceparam
{
	MDWord emWBtype;
	MLong lTemperature;//2000~12000
	MLong lTint;//-150~150
}WhiteBalancePARAM;

typedef struct __tag_dynamiclightparam {
	MLong		lSceneKey;			// The destination luminance of scene (0~100)
	MLong		lShadowInt;			// The destination intensity of shadow area (0~100)
	MByte		pGrayMap[256];      // The parameter of Outputing [256 Byte]
}DynamicLightPARAM;

typedef struct _tag_AutoFixParam
{
	MBool IsAutoLevel;

	MBool IsAutoColorBalance;
	MLong lColorBalanceRed;                 //-100 ~ 100
	MLong lColorBalanceGreen;				//-100 ~ 100
	MLong lColorBalanceBlue;				//-100 ~ 100

	MBool IsAutoSaturation;
	MLong lSaturationPara;		//-100 ~ 100

	MBool IsAutoBrightness;
	MLong lBriPara;				//-100 ~ 100

	MBool IsAutoContrast;
	MLong lConMax;					//0 ~ 511
	MLong lConMin;					//-256 ~ 255

	MBool IsAutoSharp;
	MLong lSharpPara;			//0 ~ 100      

	MLong lShadow;				//0 ~ 100
	MLong lLuminance;			//-100 ~ 0

	MBool IsDeNoise;
	MVoid *ConfigAddr;
	MLong ConfigSize;

}AUTOFIXPARAM, *LPAUTOFIXPARAM;

typedef struct __tag_effectinfo
{
	MDWord	dwEffectID;
	MVoid	*pEffect;
	MDWord	dwParamSize;
}MEffectInfo;

typedef struct __tag_mipfx
{
	MEffectInfo	*pEffectInfo;//effect list
	MDWord		dwEffectCount;//number of effect
	MDWord		dwProcessorType; //set the processor type
}MIPFX, *LPMIPFX;

//typedef struct __tag_mipfx
//{
//	MDWord		*pEffectID;//effect list
//	MVoid		**pEffectParam;
//	MDWord		dwEffectCount;//number of effect 
//	MDWord		dwProcessorType; //set the processor type
//}MIPFX, *LPMIPFX;

typedef struct __tag_miprect
{
	MRECT	rtSrc;
	MPOINT	ptFore;
	MPOINT	ptMask;
}MIPRECT, *LPMIPRECT;//set the rect witch you want process

typedef struct _tag_autofixbrightness 
{
	MLong lbrightness;
}AutoFixBrightness;

/////////////////////////////////////added for pmdenoise
typedef struct __tag_exif
{
	MDWord dwTime[2];
	MWord wISO;
} EXIF,*LPEXIF;

typedef struct _tag_denoise
{
	EXIF    pExif;
	MLong   lRParam;//0~100
	MLong	lGParam;//0~100
	MLong	lBParam;//0~100
	MLong	lNoiseParam;//0~100
	
}PMDENOISE,*LPPMDENOISE;

typedef struct _tag_noiseparam
{
	MLong   lRParam;//0~100
	MLong	lGParam;//0~100
	MLong	lBParam;//0~100
	MLong	lNoiseParam;//0~100
}NOISEPARAM,*LPNOISEPARAM;

typedef struct  _tag_colorparam
{
	MByte bRYBegin;			//0-255
	MByte bGUBegin;			//0-255
	MByte bBVBegin;			//0-255
	MByte bRYEnd;			//0-255
	MByte bGUEnd;			//0-255
	MByte bBVEnd;			//0-255
	MByte bAlpha;			//0-255
}SINGLECOLORPARAM, *LPSINGLECOLORPARAM;

typedef struct  _tag_kaleidoscopeparam
{
	MLong lAngle;			
	MDWord dwR;
	MDWord dwMode;//0 无明暗,1 明暗,2原图亮
	MPOINT postion;
}KALEIDOSCOPEPARAM, *LPKALEIDOSCOPEPARAM;

typedef struct  _tag_PointColor
{
	MByte RorY;			// 0 - 255
	MByte GorU;			// 0 - 255
	MByte BorV;			// 0 - 255
}POINTCOLOR, *LPPOINTCOLOR;

typedef struct  _tag_partialcolorparam
{
	POINTCOLOR*	pColor;					// preserve multi colors value: RGB or YUV
	MLong				lColorCount;			// preserve colors count
	MLong				lHue;						// preserve color hue range [ 0, 100 ]
}PARTIALCOLORPARAM, *LPPARTIALCOLORPARAM;

typedef struct  _tag_miniatureparam
{
	MLong lAngle; //旋转角度,对应矩形模式
	MDWord dwMode; //模式：圆1、矩形0
	MDWord dwBlurMode; //gauss 1, rect 0
	MLong lSaturation;//0~60
	MLong lContrast;//0~100
	MDWord dwClearRange; //清晰范围
	MDWord dwTranRange;//过渡范围
	MDWord dwNoiseGrade; //模糊等级
	MPOINT postion; //处理位置
}MINIATUREPARAM, *LPMINIATUREPARAM;

typedef struct  _tag_polaroidparam
{
	MDWord dwColorMode; //0 综合，1 绿色，2黄色，3红色
	MDWord dwCornerMode; //0不加暗角，1加暗角
	MLong lOriginX;
	MLong lOriginY;
	MLong lRadiusW;
	MLong lRadiusH;
}POLAROIDPARAM, *LPPOLAROIDPARAM;

typedef struct  _tag_vividaram
{
	MDWord lVividGrade;//0~80

}VIVIDPARAM, *LPVIVIDPARAM;

typedef struct  _tag_fisheyeparam
{
	MDWord lTranGrade;//0~150
	
}FISHEYEPARAM, *LPFISHEYEPARAM;

typedef struct  _tag_nostalgicparam
{
	MDWord dwCornerMode; //0不加暗角，1加暗角
	MLong lOriginX;
	MLong lOriginY;
	MLong lRadiusW;
	MLong lRadiusH;
}NOSTALGICPARAM, *LPNOSTALGICPARAM;

typedef struct  _tag_vintageparam
{
	MDWord dwCornerMode; //0不加暗角，1加暗角
	MLong lOriginX;
	MLong lOriginY;
	MLong lRadiusW;
	MLong lRadiusH;
}VINTAGEPARAM, *LPVINTAGEPARAM;

typedef struct  _tag_deepquiteparam
{
	MDWord dwCornerMode; //0不加暗角，1加暗角
	MLong lOriginX;
	MLong lOriginY;
	MLong lRadiusW;
	MLong lRadiusH;
}DEEPQUITEPARAM, *LPDEEPQUITEPARAM;

typedef struct  _tag_coldblueparam
{
	MDWord dwCornerMode; //0不加暗角，1加暗角
	MLong lOriginX;
	MLong lOriginY;
	MLong lRadiusW;
	MLong lRadiusH;
}COLDBLUEPARAM, *LPCOLDBLUEPARAM;

typedef struct  _tag_gothicparam
{
	MDWord dwCornerMode; //0不加暗角，1加暗角
	MLong lOriginX;
	MLong lOriginY;
	MLong lRadiusW;
	MLong lRadiusH;
}GOTHICPARAM, *LPGOTHICPARAM;

typedef struct  _tag_purpleparam
{
	MDWord dwCornerMode; //0不加暗角，1加暗角
	MLong lOriginX;
	MLong lOriginY;
	MLong lRadiusW;
	MLong lRadiusH;
}PURPLEPARAM, *LPPURPLEPARAM;

typedef struct  _tag_vintageblackwhiteparam
{
	MDWord dwCornerMode; //0不加暗角，1加暗角
	MLong lOriginX;
	MLong lOriginY;
	MLong lRadiusW;
	MLong lRadiusH;
}VINTAGEBLACKWHITEPARAM, *LPVINTAGEBLACKWHITEPARAM;


typedef struct  _tag_fisheyemagnifierparam
{
	MLong lOriginX;
	MLong lOriginY;
	MLong lRadius;
	
}FISHEYEMAGNIFIERPARAM, *LPFISHEYEMAGNIFIERPARAM;

typedef struct  _tag_fourcolorposterparam
{
	MDWord dwPosterMode;	// 四色组合的模式，对应0到4，缺省为0
	MDWord dwThreshold;		// 黑色和彩色之间的分界阈值，0到255之间，缺省为128
}FOURCOLORPOSTERPARAM, *LPFOURCOLORPOSTERPARAM;

typedef struct  _tag_colorgradientparam
{
	MLong lColorOffset;//0~360
	
}COLORGRADIENTPARAM, *LPCOLORGRADIENTPARAM;

typedef struct  _tag_curvebrightnessparam
{
	MLong lbrightness;//-30~30
	
}CURVEBEIGHTNESSPARAM, *LPCURVEBRIGHTNESSPARAM;

typedef struct __tag_newsketchparam
{
	MLong lThreshold;//0~
}NewSketchPARAM;

typedef struct __tag_newembossparam 
{
	MLong	lDepth ;//1~255 the intensity of effect 
}NewEmbossPARAM;

//////////////////////////////////////////

#define MIP_HISTOGRAM_RGB      0x01
#define MIP_HISTOGRAM_GRAY     0x02

#define MIP_HISTOGRAMPLANES    0x04

//get the Histogram for auto effect
MIP_IMPORT MRESULT MIP_GetHistogram(MBITMAP *pBitmapData,MDWord dwEffectID, MLong* pHistogram);
//get the matrix of autolevel
MIP_IMPORT MRESULT MIP_GetAutoProcessFormula(MLong* pHistogram,MDWord dwEffectID, MLong* pFormula);
MIP_IMPORT MRESULT MIP_GetAutoColorFormula(MBITMAP *pBitmapData, MLong* pHistogram,MLong* pFormula);

MIP_IMPORT MRESULT MIP_GetAutoWBPara(MBITMAP *pBitmapData,MLong* temperature, MLong* tint);

MIP_IMPORT MRESULT MIP_GetDLightPara(MBITMAP *pBitmapData,MLong lLunminance, MLong lShadow, MVoid* pMap);

MIP_IMPORT MRESULT	MIP_GetAutoFixPara(MBITMAP *pBitmapData,AUTOFIXPARAM *AutoFixPara,MLong* pFormula);

MIP_IMPORT MRESULT	MIP_GetAutoBrightnessPara(MBITMAP *pBitmapData,AutoFixBrightness* pFormula);

//get the Histogram for all effect
MIP_IMPORT MRESULT MIP_GetCommonHistogram(MBITMAP *pBitmapData,MDWord Histogram_ID, MLong* pHistogram[MIP_HISTOGRAMPLANES]);

// help function
//rtDst Out max rect
//trSrc Out Max rect
MIP_IMPORT MRESULT MIPCalcRect(MIP_IN MHandle HIP, MIP_INOUT MRECT *rtDst, MIP_INOUT MRECT *rtSrc);
MIP_IMPORT MRESULT MIPCalcRectReset(MIP_IN MHandle HIP);
MIP_IMPORT MBool  	MIPMergeable(MDWord dwSpaceID, MIPFX *FX);
MIP_IMPORT MBool  	MIPIsSupEffMerge(MDWord dwPreEffectID,MDWord dwNextEffectID);
MIP_IMPORT MBool  	MIPIsSupport(MDWord dwPixFormat, MDWord dwEffectID);
MIP_IMPORT MBool	MIPIsSameInOutArea(MDWord dwEffectID);

//Effect Process
MIP_IMPORT MRESULT MIPCreate(MIP_IN MIPPIXEL *pDstPixel, MIP_IN MIPPIXEL *pSrcPixel, MIPFX *FX, MIP_OUT MHandle *pHIP);
MIP_IMPORT MRESULT MIPProcess(MIP_IN MHandle HIP, MIP_IN MIPData *pDst, MIP_IN MIPData *pSrc, MIP_INOUT MRECT *pRECT);
MIP_IMPORT MRESULT MIPDestroy(MIP_IN MHandle HIP);
MIP_IMPORT MRESULT MIPGetMaxOutLine(MIP_IN MHandle HIP,MIP_IN MDWord dwMaxInputLines, MIP_OUT MDWord *pMaxLines);

//for merge and fillcolor
MIP_IMPORT MRESULT MIPCreateMerge(MIP_IN MIPPIXEL *pDstPixel, MIP_IN MIPPIXEL *pSrcPixel, MIP_IN MIPPIXEL *pForePixel, MIP_IN MIPPIXEL *pMaskPixel, 
				  MIP_IN MIPFX *FX, MIP_OUT MHandle *pHIP);
MIP_IMPORT MRESULT MIPMerge(MIP_IN MHandle HIP, MIP_IN MIPData *pDst, MIP_IN MIPData *pSrc, MIP_IN MIPData *pFore, MIP_IN MIPData *pMask, 
				   MIP_IN MIPRECT *pRtBuffer);
MIP_IMPORT MRESULT MIPDestroyMerge(MIP_IN MHandle HIP);
MIP_IMPORT MRESULT MIPFreeMemory(MIP_IN MHandle HIP);

//get image process version information
MIP_IMPORT MRESULT ImageProcessGetVersionInfo (MDWord* pdwRelease, MDWord* pdwMajor, MDWord* pdwMinor, MTChar* pszPatch, MDWord dwLen);

//pmdenoise analyse
MIP_IMPORT MRESULT DenoiseUpdate(MIP_IN MHandle HIP, MIP_IN NOISEPARAM NoiseParam);
MIP_IMPORT MRESULT GetDenoiseRt(MIP_IN MHandle HIP, MIP_IN MBITMAP *pResampleBitmap,MIP_OUT MRECT *pSrcBitRect);
MIP_IMPORT MRESULT DenoiseAnalyse(MIP_IN MHandle HIP, MIP_IN MBITMAP *pRtBitmap, MIP_OUT NOISEPARAM *NoiseParam);

#ifdef __cplusplus
}
#endif

#endif
