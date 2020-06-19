
/*
 * File Name:	amvestyleutils.h					
 *
 * Reference:
 *
 * Description: This file define the consts and APIs for style, App will use.
 * 
 * History:	
 *
 * CodeReview Log:
 * 
 */

#ifndef _AMVE_STYLE_UTILS_H_
#define _AMVE_STYLE_UTILS_H_

#include "amcomdef.h"
#include "ampkpackerhead.h"

//Constants are used to identify the session type.
#define AMVE_STYLE_MODE_NONE				0x00000000
#define AMVE_STYLE_MODE_THEME				0x00000001 //Theme template
#define AMVE_STYLE_MODE_COVER				0x00000002 //Theme cover
#define AMVE_STYLE_MODE_TRANSITION			0x00000003 //Transition template
#define AMVE_STYLE_MODE_EFFECT				0x00000004 //Image Effect template,AMVE_EFFECT_TYPE_VIDEO_IE
#define AMVE_STYLE_MODE_PASTER_FRAME		0x00000005 //Paster template, AMVE_EFFECT_TYPE_VIDEO_FRAME
#define AMVE_STYLE_MODE_ANIMATED_FRAME		0x00000006 //FX,AMVE_EFFECT_TYPE_VIDEO_FRAME
#define AMVE_STYLE_MODE_MUSIC				0x00000007 //AMVE_EFFECT_TYPE_AUDIO_FRAME
#define AMVE_STYLE_MODE_POSTER				0x00000008 //added by jgong, this is new Type for Poster-template
#define AMVE_STYLE_MODE_BUBBLE_FRAME		0x00000009 //AMVE_EFFECT_TYPE_VIDEO_FRAME for traditional bubble template,
                                                         //AMVE_EFFECT_TYPE_VIDEO_IE for text animation
#define AMVE_STYLE_MODE_TRANSITION_FRAME	0x0000000A
#define AMVE_STYLE_MODE_WATER_MARK			0x0000000B
#define AMVE_STYLE_MODE_SCENE				0x0000000C
#define AMVE_STYLE_MODE_SOUND_EFFECT		0x0000000D
#define AMVE_STYLE_MODE_CLIP				0x0000000E
#define AMVE_STYLE_MODE_DIVA				0x0000000F	
#define AMVE_STYLE_MODE_TEXT_ANIMATION      0x00000010 //add by yfeng,text animation,not used now,
                                                       //still using AMVE_STYLE_MODE_BUBBLE_FRAME
#define AMVE_STYLE_MODE_PASTER_COMBO        0x00000011 //paster combo,add for vivasam
#define AMVE_STYLE_MODE_FREEZE_FRAME        0x00000012 //Freeze frame,AMVE_EFFECT_TYPE_FREEZE_FRAME
#define AMVE_STYLE_MODE_LYRIC               0x00000013 //Lyric teamplate,bombined with text animation templates
#define AMVE_STYLE_MODE_COMBO_IE            0x00000014 //AMVE_EFFECT_TYPE_COMBO_VIDEO_IE

//是否需要这个定义，回头再看
#define AMVE_STYLE_MODE_GRAFFITI			0x00000015 //may include 2D picture material and partical material at the same time, similar to the combo effect

#define AMVE_STYLE_MODE_ALL					0xFFFFFFFF

#define AMVE_DIVA_SUB_TYPE_LYRIC			0x00000000
#define AMVE_DIVA_SUB_TYPE_FILTER			0x00000001
#define AMVE_DIVA_EFFECT_SUB_TYPE_BG		0x00000001
#define AMVE_DIVA_SUB_TYPE_FREEZE_FRAME     0x00000002

#define AMVE_PASTER_SUB_TYPE_NORMAL         0x00000000
#define AMVE_PASTER_SUB_TYPE_FACIAL         0x00000001
#define AMVE_PASTER_SUB_TYPE_FACIAL_ATTACH  0x00000002
#define AMVE_COMBO_PASTER_SUB_TYPE_NORMAL   0x00000000
#define AMVE_COMBO_PASTER_SUB_TYPE_FACIAL   0x00000001
#define AMVE_FX_SUB_TYPE_NORMAL             0x00000000
#define AMVE_FX_SUB_TYPE_SINGING            0x00000001
#define AMVE_FX_SUB_TYPE_DANCING            0x00000002
#define AMVE_FX_SUB_TYPE_SELFIE             0x00000003
#define AMVE_IE_SUB_TYPE_NORMAL             0x00000000
#define AMVE_IE_SUB_TYPE_FUNNY              0x00000001
#define AMVE_IE_SUB_TYPE_FB_POSTPROCESS     0x00000002
#define AMVE_IE_SUB_TYPE_FB_PREPROCESS      0x00000003
#define AMVE_IE_SUB_TYPE_TEXT_ANIMATION     0x00000004
#define AMVE_IE_SUB_TYPE_FACE_DEFORMATION   0x00000005
#define AMVE_IE_SUB_TYPE_GRAFFITI     		0x00000008


#define AMVE_STYLE_MODE_MPO_PACKAGE			0x00002710

#define AMVE_STYLE_TEXT_EDITABLE_NONE		0x00000000
#define AMVE_STYLE_TEXT_EDITABLE_REGION	    0x00000001
#define AMVE_STYLE_TEXT_EDITABLE_SIZE		0x00000002
#define AMVE_STYLE_TEXT_EDITABLE_COLOR		0x00000004
#define AMVE_STYLE_TEXT_EDITABLE_ALIGNMENT  0x00000008
#define AMVE_STYLE_TEXT_EDITABLE_ROTATE     0x00000010
#define AMVE_STYLE_TEXT_EDITABLE_FONT       0x00000020
#define AMVE_STYLE_TEXT_EDITABLE_SHADOW     0x00000040
#define AMVE_STYLE_TEXT_EDITABLE_STORKE     0x00000080
#define AMVE_STYLE_TEXT_EDITABLE_ALL        (AMVE_STYLE_TEXT_EDITABLE_REGION|\
	                                         AMVE_STYLE_TEXT_EDITABLE_SIZE|\
	                                         AMVE_STYLE_TEXT_EDITABLE_COLOR|\
	                                         AMVE_STYLE_TEXT_EDITABLE_ALIGNMENT|\
	                                         AMVE_STYLE_TEXT_EDITABLE_ROTATE|\
	                                         AMVE_STYLE_TEXT_EDITABLE_FONT|\
	                                         AMVE_STYLE_TEXT_EDITABLE_SHADOW|\
	                                         AMVE_STYLE_TEXT_EDITABLE_STORKE)

#define AMVE_STYLE_TEXT_ALIGNMENT_NONE		0x00000000
#define AMVE_STYLE_TEXT_ALIGNMENT_FREE_STYLE	AMVE_STYLE_TEXT_ALIGNMENT_NONE
#define AMVE_STYLE_TEXT_ALIGNMENT_LEFT		0x00000001
#define AMVE_STYLE_TEXT_ALIGNMENT_RIGHT		0x00000002
#define AMVE_STYLE_TEXT_ALIGNMENT_TOP		0x00000004
#define AMVE_STYLE_TEXT_ALIGNMENT_BOTTOM    0x00000008
#define AMVE_STYLE_TEXT_ALIGNMENT_MIDDLE	0x00000010	//建议不要用这个了，用这个代替: AMVE_STYLE_TEXT_ALIGNMENT_HOR_CENTER | AMVE_STYLE_TEXT_ALIGNMENT_VER_CENTER
#define AMVE_STYLE_TEXT_ALIGNMENT_HOR_CENTER   0x00000020 //added by jgong: 用于区分之前简单的middle
#define AMVE_STYLE_TEXT_ALIGNMENT_VER_CENTER   0x00000040 //added by jgong: 用于区分之前简单的middle
#define AMVE_STYLE_TEXT_ALIGNMENT_HOR_FULLFILL 0x00000080
#define AMVE_STYLE_TEXT_ALIGNMENT_VER_FULLFILL 0x00000100
#define AMVE_STYLE_TEXT_ALIGNMENT_UNDER_CENTER 0x00000200
#define AMVE_STYLE_TEXT_ALIGNMENT_ABOVE_CENTER 0x00000400
#define AMVE_STYLE_TEXT_ALIGNMENT_MIN_EDGE     0x00001000
#define AMVE_STYLE_TEXT_ALIGNMENT_MAX_EDGE     0x00002000


#define AMVE_STYLE_COVER_TYPE_COMPOSED_PIC      0x00000001
#define AMVE_STYLE_COVER_TYPE_SINGLE_MEDIA		0x00000002

#define QVET_TEXT_STYLE_NONE                0x00000000
#define QVET_TEXT_STYLE_NORMAL              0x00000001
#define QVET_TEXT_STYLE_BOLD                0x00000002
#define QVET_TEXT_STYLE_ITALIC              0x00000003

#define QVET_STYLE_MUSIC_FILE_ID			1000
#define QVET_STYLE_LRC_FILE_ID              1001
#define QVET_STYLE_DEMO_EXAMPLE_FILE_ID		12

#define QVET_STYLE_EXPRESSION_START_MUSIC_FILE_ID   1002   //表情触发音频文件ID
#define QVET_STYLE_PASTER_LOOP_MUISC_FILE_ID        1003   //贴纸应用后循环播放得音频文件ID
#define QVET_STYLE_FILTER_CAHNGEABLE_PIC_ID         1004   //滤镜当中可由用户调节大小位置的图片的ID

#define GET_TEMPLATE_TYPE(llTemplateID)		((MDWord)((llTemplateID>>56)&0x1F))
#define GET_TEMPLATE_SUB_TYPE(llTemplateID) 		(  (MDWord)( (llTemplateID>>19)&0x1FF)   )


#define IS_FACIAL_PASTER_TEMPLATE(llTemplateID)         ((llTemplateID&0x1f0000000ff80000) == 0x0500000000080000)
#define IS_FACIAL_ATTCH_PASTER_TEMPLATE(llTemplateID)   ((llTemplateID&0x1f0000000ff80000) == 0x0500000000100000)
#define IS_FACE_DEFORMATION_IE_TEMPLATE(llTemplateID)   ((llTemplateID&0x1f0000000ff80000) == 0x0400000000280000)
#define IS_FACE_3DMM_IE_TEMPLATE(llTemplateID)			((llTemplateID&0x1f0000000ff80000) == 0x0400000000480000)
#define IS_OT_PASTER_TEMPLATE(llTemplateID)             ((llTemplateID&0x1f0000000ff80000) == 0x0500000000180000)
#define IS_DIVA_FREEZE_FRAME_TEMPLATE(llTemplateID)     ((llTemplateID&0x1f0000000ff80000) == 0x0F00000000100000)
#define IS_SEGMENT_IE_TEMPALTE(llTemplateID)            ((llTemplateID&0x1f0000000ff80000) == 0x0400000000580000)









typedef struct _tagCoverTitleInfo
{
	MInt64 llTemplateID;
	MDWord dwStartPos;
	MDWord dwEndPos;
	MFloat fLayerID;
	MTChar szDefaultText[QVET_BUBBLE_TEXT_MAX_LENGTH];
} MTITLEINFO;

typedef struct _tagCoverEffectInfo
{
	MInt64 llTemplateID;
	MDWord dwStartPos;
	MDWord dwLength;
	MFloat fLayerID;
} MCOVEREFFECTINFO;

typedef struct __tag_coverinfo
{
    MBool bHaveTransition;
	MBool bHaveEffect;
	MInt64 llCoverID;

    MDWord dwType;
	MDWord dwCoverDuration;
	MDWord dwDefaultFPS;

	MDWord dwTitleCount;
	MTITLEINFO* pTitleInfo;
	
    MInt64 llTransitionID;
	MDWord dwTransDuration;
	MDWord dwTransConfigureIndex;
	MDWord dwTransAnimatedCfg;

	MDWord dwEffectCount;
	MCOVEREFFECTINFO* pEffectInfo;
	
	MDWord dwResampleMode; //AMVE_RESAMPLE_MODE_XXXXXX
}MCOVERINFO, *PMCOVERINFO;

typedef struct __tag_finderparam
{
	MTChar* pPath;
	MInt64 llThemeID;
	MDWord dwStyleMode;
//	MBool  bListCommon;
	MVoid* pSerialNo;
	MLong  lSerialNoLen;
}MFINDERPARAM, *PMFINDERPARAM;

typedef struct __tag_themeinfo
{
    MBool bHaveCover;
    MBool bHaveBackCover;
    MInt64 llCoverID;
    MInt64 llBackCoverID;
}MTHEMEINFO, *PMTHEMEINFO;


typedef struct __tagQVET_TRANSITION_INFO
{
	MDWord dwDuration;
	MDWord dwEditable;
	MDWord dwAudioFileID;	//Transition模板进行了扩展，转场也能带上设计的audio
}QVET_TRANSITION_INFO;

typedef struct 
{
	MInt64 llTemplateID;		//64位模板ID
	MDWord dwSubTemplateID;		//子模板在模板文件里的File ID，0表示不是子模板的文件
	MDWord dwFileID;			//文件在模板（或者子模板）里的File ID
	MTChar szFileName[AMVE_MAXPATH];
} QVET_EXTERNAL_ITEM_INFO;

typedef struct
{
	MDWord dwVipLevel;
	MDWord dwDuration;
	MDWord dwIntervalTime;
	MDWord dwNickNameCfgID;	//nick name的动画配置文件的id，0表示没有nick name不显示
	MBool bHasImageFile;
} QVET_WATERMARK_INFO;





//对应libqvpen.h里的QVpenType
#define QPEN_SPACE_REQUIREMENT_NONE						0
#define QPEN_SPACE_REQUIREMENT_2D						1
#define QPEN_SPACE_REQUIREMENT_3D_RIBBON				2
#define QPEN_SPACE_REQUIREMENT_3D_CYLINDER              3


#define QPEN_MATERIAL_NONE								0
//#define OPEN_MATERIAL_CUSTOMIZABLE						0x00010000 //not deployed yet
#define QPEN_MATERIAL_COLOR								0x00000001 //基于线条颜色粗细
#define QPEN_MATERIAL_2D								0x00000002 //模板配置不可修改

typedef struct __tagQVET_PEN_XML_SETTING
{
	MDWord version;

	
	MDWord spaceType;    //QPEN_SPACE_REQUIREMENT_XXX
	MBool  needAR;

	MDWord materialType;  //QPEN_MATERIAL_XXX
	MFloat maxLength;

	struct {
		MFloat start_rgba[4]; //RGBA, transformed from the MDWord in xml
        MFloat end_rgba[4]; //RGBA, transformed from the MDWord in xml
        MDWord cirColor;
        MFloat roughness;
        MFloat metalness;
		MFloat width;
	}material_color;
    
	struct {
		MDWord picID; //id of picture packed in the xyt
        MDWord normalPicId;
        MDWord roughnessPicId;
        MDWord metalnessPicId;
        MDWord heightPicId;
	}material_2D;


	MDWord  outTxID;
    MDWord  clearTarget;
    MDWord  renderSource;
    
}QVET_PEN_XML_SETTING;


typedef struct __tagQVET_RIPPLE_XML_SETTING
{
	MDWord  version;
	MDWord  rippleType;    //QVRIPPLE_SPACE_REQUIREMENT_XXX
	MDWord  rippleSize;
	MDWord  inTxID;
	MDWord  outTxID;
	MDWord  clearTarget;
	MDWord  renderSource;
}QVET_RIPPLE_XML_SETTING;


#ifdef __cplusplus
extern "C"
{
#endif

//Style's finder APIs
MRESULT AMVE_StyleFinderCreate(MFINDERPARAM* pParam, MHandle *phFinder);
MRESULT AMVE_StyleFinderDestory(MHandle hFinder);
MRESULT AMVE_StyleFinderUpdate(MHandle hFinder);
MRESULT AMVE_StyleFinderGetCount(MHandle hFinder, MDWord *pdwCount);
MRESULT AMVE_StyleFinderGetFileName(MHandle hFinder, MDWord dwIndex, MVoid *pStyleFile/*out*/, MDWord *pdwBufLen);
MRESULT AMVE_StyleFinderGetID(MHandle hFinder, MDWord dwIndex, MInt64* pllID);



//Style's Info and Data APIs
MRESULT AMVE_StyleCreate(const MVoid *pStyleFile, MDWord dwBGLayoutMode, const MVoid *pszSerialNo, 
						 MDWord dwSerialLen/*dwSerialLen=MStrlen(pszSerialNo)*sizeof(MTChar)*/, MHandle *phStyle);

MRESULT AMVE_StyleDestory(MHandle hStyle);

MRESULT AMVE_StyleGetVersion(MHandle hStyle, MDWord *pdwVersion);

//MRESULT AMVE_StyleGetTitle(MHandle hStyle, MDWord dwLanguageId, MTChar *pszTitle, MDWord *pdwLen);

/*
*	AMVE_StyleGetTemplateName() 是用于替换  AMVE_StyleGetTitle()，函数更名目的:
*	1. 明确函数意义
*	2. 与其他几个模板函数用意进行明确的区分(原函数 名很容易让人搞混)
*	PS:
*	目前只是engine C/JAVA 函数名改了一下，内部的相关变量即函数还是带有"Title"字眼---- 内部如果要改，改动较大，所以先改外部接口命名，让engine调用者能够比较明确的区分
*/
MRESULT AMVE_StyleGetTemplateName(MHandle hStyle, MDWord dwLanguageId, MTChar *pszTitle, MDWord *pdwLen);


MRESULT AMVE_StyleGetDescription(MHandle hStyle,MDWord dwLanguageId, MTChar *pDescription, MDWord *pdwLen);
MRESULT AMVE_StyleGetMode(MHandle hStyle, MDWord *pdwMode);
MRESULT AMVE_StyleGetThumbnail(MHandle hContext, MHandle hStyle, MDWord dwFormat, MBITMAP *pBitMap/*in,out*/, 
							   MDWord dwWidth, MDWord dwHeight);
MRESULT AMVE_StyleFreeThumbnail(MHandle hStyle, MBITMAP *pBitMap);
MRESULT AMVE_StyleGetPreviewData(MHandle hStyle, MHandle hStoryboard, AMVE_FNSTATUSCALLBACK fnCallback, MVoid* pUserData);


MRESULT AMVE_StyleExtractExampleFile(MHandle hStyle, MTChar* szExampleFile);

MRESULT AMVE_StyleGetID(MHandle hStyle, MInt64 *pllID);

MRESULT AMVE_StyleGetDummyFlag(MHandle hStyle, MBool* pbDummy);

MRESULT AMVE_StyleGetTransInfo(MHandle hStyle, QVET_TRANSITION_INFO *pTransInfo);

MRESULT AMVE_StyleGetThemeInfo(MHandle hStyle, MTHEMEINFO *pThemeInfo);

MRESULT AMVE_StyleHasIPEffect(MTChar *pszTemplate, MDWord dwFrameW, MDWord dwFrameH, MBool *pbHas);

MRESULT AMVE_StyleGetBubbleInfo(MHandle hStyle, MDWord dwLanguageID, MSIZE* pBGSize, QVET_BUBBLE_TEMPLATE_INFO* pInfo);

MRESULT AMVE_StyleGetWaterMarkInfo(MHandle hStyle, QVET_WATERMARK_INFO* pWaterMarkInfo);

MRESULT AMVE_StyleGetAnimatedFrameInfo(MHandle hStyle, MSIZE* pBGSize, QVET_ANIMATED_FRAME_TEMPLATE_INFO* pInfo);
    
MRESULT AMVE_StyleGetPasterPitchInfo(MHandle hStyle, MFloat * pfPitch);

MRESULT AMVE_StyleGetSwitchInfo(MHandle hStyle, QVET_PASTE_SWITCH_INFO* pInfo);
MRESULT AMVE_StyleGetSceneInfo(MHandle hStyle, MSIZE* pBGSize, QVET_SCENE_INFO_CFG* pInfoCfg);

MDWord AMVE_StyleGetSceneDuration(MHandle hStyle);

//External finder's API
MRESULT AMVE_StyleGetExternalFileCount(MHandle hStyle, MDWord* pdwCount);

MRESULT	AMVE_StyleGetExternalFileInfos(MHandle hStyle, QVET_EXTERNAL_ITEM_INFO* pInfos, MDWord dwCount);

MRESULT AMVE_StyleGetSupportedLayouts(MHandle hStyle, MLong* plLayouts);

//Categroy's API
MRESULT AMVE_StyleGetCategroyID(MHandle hStyle, MDWord* pdwCateID);

MRESULT AMVE_StyleGetConfigureCount(MHandle hStyle, MDWord* pdwCount);

MRESULT AMVE_StyleHasRamdomParam(MHandle hStyle, MBool* pbHas);

MRESULT AMVE_StyleMeasureBubble(QVET_BUBBLE_TEMPLATE_INFO* pBTInfo, /*in*/
									  MTChar *pszText,
						              MSIZE* pBGPixelSize, /*in*/
						              MTChar* pszAuxiliaryFont, /*in*/
						              MSIZE* pBubbleSize /*out*/);
    
MRESULT AMVE_StyleGetThumbnailItem(MHandle hStyle, MHandle* phItem);

MVoid AMVE_StyleCloseItem(MHandle hStyle,MHandle hItem);
    
MRESULT AMVE_StyleGetStreamFromItem(MHandle hItem,MHandle* phStream);
MRESULT AMVE_StyleGetCategroySubType(MHandle hStyle,MDWord *pdwSubType);

MRESULT AMVE_StyleGetSubPasterID(MHandle hStyle,MInt64** ppSubPasterID,MDWord* pdwCount);

MRESULT AMVE_StyleGetFrameSizeRefList(MHandle hStyle,QVET_FRAME_SIZE_REF_LIST* pFrameSizeRefList);

MRESULT AMVE_StyleGetPasterFacialInfo(MHandle hStyle,AMVE_PASTER_FACIAL_INFO* pFacialInfo);

MRESULT AMVE_StyleIsAudioVisualizationTemplate(MHandle hStyle, MBool *pbIsAVT);

MRESULT AMVE_StyleGetInfoVersion(MHandle hStyle,MDWord* pdwVersion);


MRESULT AMVE_StyleGetTextAnimateInfoTextSettings(MHandle hStyle,MDWord dwLanguageID,MDWord dwParamID,
		                                                     QVET_TEXT_ANIMATE_INFO_TEXT_SETTTINGS* pSettings);

MRESULT AMVE_StyleGetFrameSPInfo(MHandle hStyle,QVET_FRAME_SP_INFO* pFrameSPInfo);

MRESULT AMVE_StyleGetDefBubbleTextSourceByID(MHandle hStyle,MSIZE* pBGSize, MDWord dwParamID, AMVE_BUBBLETEXT_SOURCE_TYPE* pBubbleSource);

MRESULT AMVE_StyleGetDefBubbleTextSource(MHandle hStyle,MSIZE* pBGSize,AMVE_BUBBLETEXT_SOURCE_TYPE* pBubbleSource);
    
MRESULT AMVE_StyleGetFreezeFrameBasicInfo(MHandle hStyle,QVET_FREEZE_FRAME_BASICINFO* pInfo);

MRESULT AMVE_StyleGetPasterOTInfo(MHandle hStyle,QVET_PASTER_OBJECT_TRACKING_INFO* pOTInfo);

MRESULT AMVE_StyleIsOTSupportTemplate(MHandle hStyle,MBool* pbIsOTSupport);

MRESULT AMVE_StyleGetExpressionInfo(MHandle hStyle,AMVE_EFFECT_EXPRESSION_INFO* pExpressionInfo);
    
MRESULT AMVE_StyleGetPasterABFaceInfo(MHandle hStyle,AMVE_EFFECT_ABFACE_INFO* pABFaceInfo);

MRESULT AMVE_StyleGet3DMaterialList(MHandle hStyle,QVET_3D_MATERIAL_LIST* p3DMaterialList);

MRESULT AMVE_StyleGetFilterDuration(MHandle hStyle,MDWord* pDuration);

MRESULT AMVE_StyleIsEmptyTemplate(MHandle hStyle,MBool* pbEmpty);
//Create style parser to parse style.xml
MRESULT AMVE_StyleParserCreate(const MVoid *pStyleFile, MDWord dwBGLayoutMode,MHandle* phStyleParser);
MRESULT AMVE_StyleParseDestory(MHandle hStyleParser);


//Get filter input & output color space for filter
MRESULT AMVE_StyleParserGetFilterInOutColorSpace(MHandle hStyleParser,MDWord* pdwInColor,MDWord* pdwOutColor);

MRESULT AMVE_StyleGetMulBubbleTextInfo(MHandle hStyle, MHandle hSessionCtx, MSIZE* pBGSize, MDWord dwLanguageID, AMVE_MUL_BUBBLETEXT_INFO *pMulTextInfo);

MRESULT AMVE_StyleGetBubbleAnimationInfo(MHandle hSessionCtx, MHandle hStyle, MDWord dwLanguageID, MSIZE* pBGSize, MDWord dwParamID, QVET_BUBBLE_TEMPLATE_INFO* pInfo);

QVET_THEME_SCECFG_SETTINGS* AMVE_StyleGetSlideShowSceCfgInfo(MHandle hStyle);

MVoid AMVE_StyleFreeSlideShowSceCfgInfo(QVET_THEME_SCECFG_SETTINGS* pSettings);


MBool AMVE_StyleIsSlideShowTheme(MHandle hStyle);

MBool AMVE_StyleIsFixedSizeTheme(MHandle hStyle);

MRESULT AMVE_StyleGetThemeExportSize(MHandle hStyle, MSIZE * pExportSize);

MRESULT AMVE_StyleGetThemeCoverPosition(MHandle hStyle,MDWord* pdwPosition);

MBool AMVE_StyleIsARTemplate(MHandle hStyle);

MRESULT AMVE_StyleGetEffectPreviewInfo(MHandle hStyle, QEVT_EFFECT_PREVIEW_INFO *pPreviewPosition);

//注意释放
MRESULT AMVE_StylePasterGetThemeMusicTempIDs(MHandle hStyle, MInt64 ** ppArrayTemIDs, MDWord * pArraySize);

MBool AMVE_StyleBubbleIsAdujestAlpha(MHandle hSessionCtx, MInt64 llTemplate, MSIZE bgSize);//判断字幕模板能不能调节alpha
#ifdef __cplusplus
}
#endif

#endif	// _AMVE_STYLE_UTILS_H_

