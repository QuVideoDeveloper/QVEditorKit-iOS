#ifndef ETAVCOMDEF_H
#define ETAVCOMDEF_H



//#include "veinc.h"
#include "gcs_comdef.h"


typedef struct __tagGCS_XML_DRIVEN_INFO
{
	MDWord dwCI;//Changeable Identifier, refer to GCS_CHANGEABLE_CATEGORY_NONE in gcs_gcddef.h for more info
	MDWord dwTargeIdx; //corresponding to the 
	MDWord dwDataCnt;//简要举例: 如果是频谱，且256个频点数据，dwDataCnt=256; 如果是MFloat输出，则dwDataCnt=1
	MDWord dwDataIdx;//简要举例: 如果是频谱，且使用第三个频点数据，则dwDataIdx=2; 如果是MFloat输出，则dwDataIdx=0

	MDWord dwGD; ////GD_XXXXXXX
	
	COORDINATE_DESCRIPTOR DeltaBaseData;//related to CI-Delta-Mode
}GCS_XML_DRIVEN_INFO;


typedef struct __tagGCS_XML_OBJ_CONFIG
{
	MDWord 	dwType;
	MBool	bVisible;
	MBool   bForGroupConnecting;

	
	SOURCE_PARAM SrcParam;
	COORDINATE_DESCRIPTOR MaxSize;
	MDWord dwMaxSizeGD;	//GD_XXXXXXX

	COORDINATE_DESCRIPTOR MinSize;
	MDWord dwMinSizeGD; //GD_XXXXX

	MDWord	dwAlignment;
	COORDINATE_DESCRIPTOR RotateAnchor;
	MDWord 	dwRotateAnchorGD;//GD_XXXXXXX
	MFloat	fRotation;

	COORDINATE_DESCRIPTOR AnchorInFather;
	MDWord	dwAnchorInFatherGD;//GD_XXXXXXX

	MDWord 	dwDICount;
	GCS_XML_DRIVEN_INFO *pDIList;
}GCS_XML_OBJ_CONFIG;



/*
 *	GCS_XML_CONTAINER_CONFIG
 *		这是对Container几何数据的描述，正式init时还需给出RA，所以要在Init前要先准备好RA
 */
typedef struct __tagGCS_XML_CONTAINER_CONFIG
{
	MDWord dwType;
	
	MBool 	bConnectObj;	
	MDWord	dwConnectGD;
	LINE_STYLE ConnectStyle;

	OVERALL_RENDER_STYLE  OverallStyle;//for all the sub-graphic in the container, it's different from the overall-style in LINE_STYLE
	
	COORDINATE_DESCRIPTOR AnchorPoint;
	MDWord	dwAnchorPointGD;	//GD_XXXXXXX
	
	COORDINATE_DESCRIPTOR FatherOWC; //move from object init param, 这是container所特有的属性，并不是所有graphic子类都需要
	MDWord	dwFatherOWCGD;	//GD_XXXXXXX

//	MDWord dwSubCtnCount;
//	GCS_XML_CONTAINER_CONFIG *pSubCtnList;

	MFloat fRotation;

	MDWord dwSubObjCount;
	GCS_XML_OBJ_CONFIG *pSubObjList;
}GCS_XML_CONTAINER_CONFIG;


typedef struct __tagGCS_XML_BASIC_CONFIG
{
	/*
		bHasRefGD: 
			xml里是否有归一化描述的。
		
		这个是一个帮助提高代码效率的标志量，只针对哪些在“初始化时”就可以确定的几何参数。
				----即在初始化时给定BGSize就能确定的几何参数，比如一个矩形的长宽的"最大值"，这种值在初始化时就确定是最佳方案。
		对于运行时才能确定的几何参数，不受这个标志量约束。
				----要运行时才能根据归一化确定的几何参数都是跟AudioAnalyzer输出有关的。
				----比如，一个矩形的高度，是受某个音频参量控制的
				----目前只有GCS_DRIVEN_INFO才会涉及
	*/

	MBool bHasRefGD;

	//for input/output texture config in sessioncore
	MDWord dwInputOriType;
	MBool  bDrawInput2Output;
	
	MDWord dwOutputOriType;
}GCS_XML_BASIC_CONFIG;


//GD = Geometric Description
#define GD_BASE_ON_PIXEL						0	//基于像素的描述，"非"归一化描述
#define GD_NORMALIZED_REF_BG_X_Y_SEPARATED	1	//实际x,y各自参考BG的相应的x，y
#define GD_NORMALIZED_REF_BG_X				2	//归一化描述，参考BG的X尺寸
#define GD_NORMALIZED_REF_BG_Y				3
#define GD_NORMALIZED_REF_BG_MIN_X_AND_Y	4
#define GD_NORMALIZED_REF_BG_MAX_X_AND_Y	5







/************************************************************************
 ***********************       Music Feature       **********************
 ************************************************************************/




typedef struct __tagMF_ONSET_DATA
{
	MDWord *timePos;
	MFloat *weight;
	MDWord  cnt;
	MDWord capacity;


	MFloat dvMean;//delta vol mean
	MFloat dvDev;//delta vol deviation

	//for debug:
	MFloat *absVol;
	MFloat *deltaVol;
	//MFloat *deltaVolSecond;
	MDWord *spanCovered; //the time span covered by one onset
	MBool  *toBeLoud;

	MBool *smallAbsVol;
	MBool *smallDeltaVol;
	MBool *smallSpanCovered;
}MF_ONSET_DATA;


typedef struct __tagMF_VOLUME_DATA
{
	MDWord *timePos;
	MFloat *value;

	MBool   isOnDB;

	MDWord oriTimeSpan;
	MFloat oriMaxValue; //源自原始音量的最大值
	MFloat oriMinValue; //源自原始音量的最小值
	
	MDWord cnt;
	MDWord capacity;

}MF_VOLUME_DATA;

typedef struct __tagAA_PARSER_HEAD
{
	AMVE_POSITION_RANGE_TYPE AudioRange;
	MBool bRepeatAudio;
}AA_PARSER_HEAD;

#define DO_NOTHING      (0)
#define CONSTANT


#define ENABLE_ONSET_PICK_STRATEGY_1
//#define ENABLE_ONSET_PICK_STRATEGY_2






#endif
