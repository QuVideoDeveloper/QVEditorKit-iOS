#ifndef		__STYLEFILEHEAD_H_H
#define		__STYLEFILEHEAD_H_H 

#include "ampkpackerinterface.h"


#define TEMPLATE_NAME_MAX_LENGTH		128
#define TEMPLATE_FILE_EXT_NAME			_MMT(".xyt")
#define QVET_ENGINE_VERSION				0x00050005		//QVET_ENGINE_VERSION是对模板解析处理引擎的版本标示，如果模板版本>模板引擎版本，则判定为不支持
#define XYPT_TAGID			 			'XYTP'
#define QVET_SENIOR_TEXT_VERSION             0x30000         //区分动画字幕和普通bubble字幕的版本号
#define QVET_SENIOR_VIDEO_FRAME_VERSION      0x30000         //高级版本的贴纸/水印等video frame
#define QVET_SENIOR_TEXT_SUPPORT_MUL_TEXIT_VERSION 0x31000
//template source format
#define QVET_TEMPLATE_SOURCE_FORMAT_NONE		0x00000000
#define QVET_TEMPLATE_SOURCE_FORMAT_JPEG		0x00000001
#define QVET_TEMPLATE_SOURCE_FORMAT_PNG			0x00000002
#define QVET_TEMPLATE_SOURCE_FORMAT_MPO			0x00000003
#define QVET_TEMPLATE_SOURCE_FORMAT_FIXED_COLOR 0x00000004
#define QVET_TEMPLATE_SOURCE_FORMAT_MP4			0x00000005
#define QVET_TEMPLATE_SOURCE_FORMAT_SVG			0x00000006
#define QVET_TEMPLATE_SOURCE_FORMAT_RAW_GRAY8	0x00000007
#define QVET_TEMPLATE_SOURCE_FORMAT_TRC			0x00000008
//#define QVET_TEMPLATE_SOURCE_FORMAT_CAMERA		0x00000009
#define QVET_TEMPLATE_SOURCE_FORMAT_RAW_RGB24   0x0000000a
#define QVET_TEMPLATE_SOURCE_FORMAT_RAW_RGBA    0x0000000b
#define QVET_TEMPLATE_SOURCE_FORMAT_GIF			0x0000000C	
#define QVET_TEMPLATE_SOURCE_FORMAT_BUBBLE		0x0000000D  //bubble并不是指文件类型是bubble，只是说明这个template类型是bubble，具体bubble模板所采用的文件类型的差异性都隐藏在bubble engine里处理
#define QVET_TEMPLATE_SOURCE_FORMAT_WEBP		0x0000000E
#define QVET_TEMPLATE_SOURCE_FORMAT_KTX			0x0000000F
#define QVET_TEMPLATE_SOURCE_FORMAT_PKM			0x00000010
#define	QVET_TEMPLATE_SOURCE_FORMAT_ASTC		0x00000011
#define QVET_TEMPLATE_SOURCE_FORMAT_CLIP			0x00010001
#define QVET_TEMPLATE_SOURCE_FORMAT_TRACK			0x00010002
#define QVET_TEMPLATE_SOURCE_FORMAT_EXTERNAL_FILE	0x00010003
#define QVET_TEMPLATE_SOURCE_FORMAT_WORK_BUFFER		0x00010004
#define QVET_TEMPLATE_SOURCE_FORMAT_FRAME_BUFFER	0x00010005


//the macro of MPO settings
#define QVET_MPO_TYPE_TRANSITION	0x00000001
#define QVET_MPO_TYPE_CLIP			0x00000002
#define QVET_MPO_TYPE_FRAME			0x00000003

//the macro of effect settings
#define QVET_EFFECT_FRAME_TYPE_RESAMPLE	0x00000001
#define QVET_EFFECT_FRAME_TYPE_MOVE		0x00000002
#define QVET_EFFECT_FRAME_TYPE_MPO		0x00000003
#define QVET_EFFECT_FRAME_ALPHA_MASK	0x10000000

extern const MByte Default_Serial_no[];

typedef struct 
{
	MDWord dwPkgId;			//'XYTP'
	MDWord dwTemplateType;	//theme, transition, etc.
	MDWord dwTemplateVersion;	//This is the template version
	MDWord dwAppMatchVersion;	//This identifies the lowest app version which can support this template，仅供app查询用判断用
	MD5ID  TCMD5;	//TC = Template Content 这个值是模板打包完成之后，对整个模板文件生成一个MD5，然后再写到模板文件头的; 它是模板原生态内容的一个特征码
	MD5ID  TVMD5;	//TV = Template Validity 某些特殊的模板需要带上设备的特征，以防用户随意copy模板到其他设备上
	MLong  lTemplateNameLen;	//MStrlen of template name
	MByte  templateName[TEMPLATE_NAME_MAX_LENGTH];
	MDWord dwReserved;
}QVET_TEMPLATE_INFO;

typedef struct 
{
	MDWord dwMPOType;
	MDWord dwFormat;
	MDWord dwMaskCount;
	MDWord dwDuration;
	MDWord dwWidth;
	MDWord dwHeight;
	MDWord dwCoverCount;
	MDWord dwBackCoverCount;
	MDWord dwReserved[6];
} QVET_TEMPLATE_MPO_SETTINGS;

#define QVTP_LAYOUT_MODE_NUMBER				9

#define QVTP_LAYOUT_MODE_NONE				0x00000000
#define QVTP_LAYOUT_MODE_PORTRAIT			0x00000001
#define QVTP_LAYOUT_MODE_LANDSCAPE			0x00000002
#define QVTP_LAYOUT_MODE_W3_H4				QVTP_LAYOUT_MODE_PORTRAIT
#define QVTP_LAYOUT_MODE_W4_H3				QVTP_LAYOUT_MODE_LANDSCAPE
#define QVTP_LAYOUT_MODE_W9_H16				0x00000004
#define QVTP_LAYOUT_MODE_W16_H9				0x00000008
#define QVTP_LAYOUT_MODE_W1_H1				0x00000010
#define QVTP_LAYOUT_MODE_W9_H18             0x00000020
#define QVTP_LAYOUT_MODE_W18_H9				0x00000040
#define QVTP_LAYOUT_MODE_W3_H2              0x00000080
#define QVTP_LAYOUT_MODE_W2_H3              0x00000100


#define QVTP_FILE_ID_INVALID				0
#define QVTP_FILE_ID_INFOFILE				1
#define QVTP_FILE_ID_STYLEFILE				2
#define QVTP_FILE_ID_THUMBFILE				3
#define QVTP_FILE_ID_SAMPLEFILE				4
#define QVTP_FILE_ID_COVER_IMAGEFILE		3000

//一般认为模板里原先默认配置的都是横屏的
#define QVTP_FILE_ID_STYLEFILE_PORTRAIT		5
#define QVTP_FILE_ID_STYLEFILE_LANDSCAPE	QVTP_FILE_ID_STYLEFILE	
#define QVTP_FILE_ID_INFOFILE_PORTRAIT		6
#define QVTP_FILE_ID_INFOFILE_LANDSCAPE		QVTP_FILE_ID_INFOFILE
#define QVTP_FILE_ID_PROJECT_XML			7
#define QVTP_FILE_ID_PROJECT_DATA			8
#define QVTP_FILE_ID_FRAME					9
#define QVTP_FILE_ID_FRAME_MASK				10
#define QVTP_FILE_ID_BUBBLE_FILE			11
#define QVTP_FILE_ID_EXAMPLE_FILE			11
#define QVTP_FILE_ID_DEMO_EXAMPLE_FILE		12

#define QVTP_FILE_ID_STYLEFILE_W3_H4		QVTP_FILE_ID_STYLEFILE_PORTRAIT	 //5
#define QVTP_FILE_ID_STYLEFILE_W4_H3		QVTP_FILE_ID_STYLEFILE_LANDSCAPE //=QVTP_FILE_ID_STYLEFILE	2
#define QVTP_FILE_ID_STYLEFILE_W9_H16		13
#define QVTP_FILE_ID_STYLEFILE_W16_H9		14
#define QVTP_FILE_ID_STYLEFILE_W1_H1		18
#define QVTP_FILE_ID_STYLEFILE_W9_H18		21
#define QVTP_FILE_ID_STYLEFILE_W18_H9		22
#define QVTP_FILE_ID_STYLEFILE_W3_H2        23
#define QVTP_FILE_ID_STYLEFILE_W2_H3        24


#define QVTP_FILE_ID_INFOFILE_W3_H4			QVTP_FILE_ID_INFOFILE_PORTRAIT
#define QVTP_FILE_ID_INFOFILE_W4_H3			QVTP_FILE_ID_INFOFILE_LANDSCAPE
#define QVTP_FILE_ID_INFOFILE_W9_H16		15
#define QVTP_FILE_ID_INFOFILE_W16_H9		16
#define QVTP_FILE_ID_INFOFILE_W1_H1			17
#define QVTP_FILE_ID_INFOFILE_W9_H18		19
#define QVTP_FILE_ID_INFOFILE_W18_H9		20
#define QVTP_FILE_ID_INFOFILE_W3_H2         25
#define QVTP_FILE_ID_INFOFILE_W2_H3         26


#define QVTP_FILE_ID_LAYOUT_MAP				100
#define QVTP_FILE_ID_HITTEST				101
#define QVTP_FILE_ID_CAMERA_PIP_STYLE		102
#define QVTP_FILE_ID_THEME_CACHE_CFG_FILE	103
#define	QVTP_FILE_ID_ECHO_CFG_FILE			104
#define QVTP_FILE_ID_SCENE_CFG_FILE			105				
#define QVTP_FILE_ID_FREEZE_FRAME_PARAM     106   //静止帧配置文件id
#define QVTP_FILE_ID_STYLE_MAP_BASE			200
//audio visualization config xml file id
#define QVTP_FILE_ID_AV_FILE_BASE			300 
#define QVTP_FILE_ID_AV_CONFIG_W4_H3			(QVTP_FILE_ID_AV_FILE_BASE+0)//300
#define QVTP_FILE_ID_AV_CONFIG_W3_H4			(QVTP_FILE_ID_AV_FILE_BASE+1)//301
#define QVTP_FILE_ID_AV_CONFIG_W16_H9		(QVTP_FILE_ID_AV_FILE_BASE+2)//302
#define QVTP_FILE_ID_AV_CONFIG_W9_H16		(QVTP_FILE_ID_AV_FILE_BASE+3)//303
#define QVTP_FILE_ID_AV_CONFIG_W1_H1			(QVTP_FILE_ID_AV_FILE_BASE+4)//304
#define QVTP_FILE_ID_AV_CONFIG_W18_H9           (QVTP_FILE_ID_AV_FILE_BASE+5)//305
#define QVTP_FILE_ID_AV_CONFIG_W9_H18           (QVTP_FILE_ID_AV_FILE_BASE+6)//306
#define QVTP_FILE_ID_AV_CONFIG_W3_H2            (QVTP_FILE_ID_AV_FILE_BASE+7)//307
#define QVTP_FILE_ID_AV_CONFIG_W2_H3            (QVTP_FILE_ID_AV_FILE_BASE+8)//308

#define QVTP_FILE_ID_MUSIC					1000
#define QVTP_FILE_ID_LRC                    1001
#define QVTP_FILE_ID_AV_EFFECT_PLUGIN_XML			1002


#define QVTP_FILE_ID_USER					8000
#define QVTP_FILE_ID_USER_TEXT_ANIMATIN		8001
 
#define QVPK_FILE_FORMAT_UNKNOWN		0
#define QVPK_FILE_FORMAT_JPEG		'JPEG'
#define QVPK_FILE_FORMAT_JPG		'JPG '
#define QVPK_FILE_FORMAT_SVG		'SVG '
#define QVPK_FILE_FORMAT_MP4		'MP4 '
#define QVPK_FILE_FORMAT_SWF		'SWF '
#define QVPK_FILE_FORMAT_PNG		'PNG '
#define QVPK_FILE_FORMAT_BMP		'BMP '
#define QVPK_FILE_FORMAT_GIF		'GIF '
#define QVPK_FILE_FORMAT_MPO		'MPO '
#define QVPK_FILE_FORMAT_WMV		'WMV '
#define QVPK_FILE_FORMAT_3GP		'3GP '
#define QVPK_FILE_FORMAT_3G2		'3G2 '
#define QVPK_FILE_FORMAT_K3G		'K3G '
#define QVPK_FILE_FORMAT_M4A		'M4A '
#define QVPK_FILE_FORMAT_SKM		'SKM '
#define QVPK_FILE_FORMAT_AVI		'AVI '
#define QVPK_FILE_FORMAT_ASF		'ASF '
#define QVPK_FILE_FORMAT_QCP		'QCP '
#define QVPK_FILE_FORMAT_AAC		'AAC '
#define QVPK_FILE_FORMAT_MP3		'MP3 '
#define QVPK_FILE_FORMAT_AMR		'AMR '
#define QVPK_FILE_FORMAT_XYT		'XYT '
#define QVPK_FILE_FORMAT_WMA		'WMA '
#define QVPK_FILE_FORMAT_TRCE		'TRCE' //it's the lyrics file from the third-party
#define QVPK_FILE_FORMAT_WEBP		'WEBP'
#define QVPK_FILE_FORMAT_KTX		'KTX '
#define QVPK_FILE_FORMAT_PKM		'PKM '
#define QVPK_FILE_FORMAT_ASTC		'ASTC'
//raw buffer
#define QVPK_FILE_FORMAT_I420		'I420'
#define QVPK_FILE_FORMAT_RGB32		'R32 '
#define QVPK_FILE_FORMAT_RGB24		'R24 '
#define QVPK_FILE_FORMAT_RGB16		'R16 '
#define QVPK_FILE_FORMAT_GREY		'GREY'
//Solid color
#define QVPK_FILE_FORMAT_SOLID_COLOR	'SCLR'
//QVPK File ID
#define QVPK_FILE_FORMAT_PKID		'PKID'
#define QVPK_FILE_FORMAT_LZ4        'LZ4 '   
#define QVPK_FILE_FORMAT_LYRIC      'LRC '
// typedef struct 
// {
// 	MDWord dwFileTag;		      //'QVPK'
// 	MDWord dwVersion;
// 	MDWord dwFileCount;			  
// 	MDWord dwPackageInfoSize;    
// } QVET_PACKAGE_HEADER;

// typedef struct 
// {
// 	MBool  bDetached;
// 	MDWord dwFileId; //item id
// 	MDWord dwFormat; //jpeg, mp4, 3gp, etc.
// 	MDWord dwOffset;
// 	MDWord dwLength;
// } QVET_PACKAGE_ITEM_INFO;

/************************************************************************

|-------------------|
| File Header       |---------------> QVET_PACKAGE_HEADER
|-------------------|
| File_1 info       |-----|
|-------------------|     |
| File_2 info       |     |       
|-------------------|     |---------> QVET_PACKAGE_ITEM_INFO       
| ......            |     |
|-------------------|     | 
| File_n info       |     |
|-------------------|-----|
| File_1 data       |
|-------------------|
| File_2 data       |
|-------------------|
| .......           |
|-------------------|
| File_n data       |
|-------------------|

************************************************************************/



#endif
