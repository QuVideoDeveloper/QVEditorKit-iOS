#ifndef ET_AV_UTILS_H
#define ET_AV_UTILS_H


#include "qvasp.h"
#include "etavcomdef.h"
//#include "eteffectplugincomdef.h"

#define FUNC_EXPANDABLE	//it's only a tag to identify that if the function is possible to expand when new feature is comming


/*
 *	CAVUtils
 *		this class supplies utils function to make the main code routine more explict and smart
 */
class CAVUtils
{
private:
	CAVUtils(){}
	virtual ~CAVUtils(){}

public:
	/********************for audio analyzer********************/
	static MRESULT 	DuplicateTargetList(AA_PROCEDURE_TARGET *pSrcList, MDWord dwSrcCnt, AA_PROCEDURE_TARGET **ppDstList);
	static MVoid 	DestroyTargetList(AA_PROCEDURE_TARGET *pList, MDWord dwCnt);

	static MRESULT 	DuplicatePCList(AA_PROCEDURE_CONFIG *pSrcList, MDWord dwSrcCnt, AA_PROCEDURE_CONFIG **ppDstList);
	static MVoid 	DestroyPCList(AA_PROCEDURE_CONFIG *pList, MDWord dwCnt);

	static MVoid  	DestroyResultList(AA_RESULT *pResList, MDWord dwResCnt, MBool bFreeList);

	static ASP_FREQUENCE_SPECTRUM_RESULT * NewASPSpectrumResult(MDWord dwCapacity);
	static MVoid FreeASPSpectrumResult(ASP_FREQUENCE_SPECTRUM_RESULT *pResult, MBool bFreeStruct);

	static ASP_AMPLITUDE_DETECT_RESULT* NewASPAmplitudeResult(MDWord dwCapacity);
	static MRESULT expandASPVolumnResult(ASP_AMPLITUDE_DETECT_RESULT *p, MDWord capacity);
	static MVoid  FreeASPAmplitudeResult(ASP_AMPLITUDE_DETECT_RESULT* pResult, MBool bFreeStruct);

	static ASP_ONSET_DETECTION_RESULT* NewASPOnsetResult(MDWord dwCapacity);
	static MRESULT expandASPOnsetResult(ASP_ONSET_DETECTION_RESULT *p, MDWord capacity);//	
	static MVoid  FreeASPOnsetResult(ASP_ONSET_DETECTION_RESULT* pResult, MBool bFreeStruct);

	static AA_FLOAT_GROUP* NewFloatGroup(MDWord dwCapacity);
	static MVoid  FreeFloatGroup(AA_FLOAT_GROUP* pGroup, MBool bFreeStruct);


	static MRESULT expandSADResult(ASP_SAD_RESULT *p, MDWord capacity);
	static MVoid    freeSADResult(ASP_SAD_RESULT *p, MBool bFreeStruct = MFalse);

	static MRESULT prepareMFOnsetData(MF_ONSET_DATA *hbd, MDWord capacity);
	static MVoid   freeMFOnsetData(MF_ONSET_DATA *hbd, MBool bFreeStruct = MFalse);
	static MRESULT copyMFOnsetData(MF_ONSET_DATA *src, MF_ONSET_DATA *dst);

	static MRESULT prepareMFVolumeData(MF_VOLUME_DATA *v, MDWord capacity);
	static MVoid  freeMFVolumeData(MF_VOLUME_DATA *v, MBool bFreeStruct = MFalse);

	static MRESULT	PrepareAAResultCollection(MDWord dwMDT, MDWord dwCapacity, MVoid *pTargetInstance, AA_RESULT_COLLECTION *pCollection/*in,out*/);
	static MVoid	FreeAAResultCollection(AA_RESULT_COLLECTION *pCollection, MBool bFreeStruct=MFalse);
	
	FUNC_EXPANDABLE static MRESULT	CloneMFP(MDWord dwMFT, MVoid* pSrcMFP, MVoid **ppDstMFP);//也具备Create功能
	FUNC_EXPANDABLE static MVoid	DestroyMFP(MDWord dwMFT, MVoid* pMFP);
	FUNC_EXPANDABLE static MRESULT	CreateMFP(MDWord dwMFT, MVoid** ppMFP);

	/*
	 *	pAdditionInfo:
    	 *		用以创建RealTypeData的额外信息与数据，目前传入Init过的CQVETAudioAnalyzer实例即可
    	 *		这种设计不是很好，以后MathXXX相关的所有东西都要剥离出去，用一个独立模块来封装，
	 */

	FUNC_EXPANDABLE static MVoid	DestoryRealTypeData(MDWord dwRealDataType, MVoid *pData);
	FUNC_EXPANDABLE static MRESULT 	CopyRealTypeData(MDWord dwMDT, MVoid* pSrc, MVoid* pDst);
	FUNC_EXPANDABLE static MDWord 	GetMDTSize(MDWord dwMDT);

	FUNC_EXPANDABLE static MRESULT TranslateQASPARTypeAndSize(MDWord dwASPType, MDWord *pdwARType, MDWord *pdwARSize);

	FUNC_EXPANDABLE static MVoid dbg_GetMFPString(MDWord dwMFT, MVoid* pMFP, MTChar *pszInfo/*in, out*/);





	static MRESULT PrepareASPSampleBuf(ASP_SAMPLE_BUF_B *p, MDWord capacity);
	static MRESULT PrepareASPSampleBuf(ASP_SAMPLE_BUF_S *p, MDWord capacity);
	static MRESULT PrepareASPSampleBuf(ASP_SAMPLE_BUF_F *p, MDWord capacity);
	static MVoid FreeASPSampleBuf(ASP_SAMPLE_BUF_B *p, MBool bFreeStruct=MFalse);
	static MVoid FreeASPSampleBuf(ASP_SAMPLE_BUF_S *p, MBool bFreeStruct=MFalse);
	static MVoid FreeASPSampleBuf(ASP_SAMPLE_BUF_F *p, MBool bFreeStruct=MFalse);		



//	static MRESULT prepareTimePositions(TIME_POSITIONS *tp, MDWord capacity);
//	static MVoid    freeTimePositions(TIME_POSITIONS *tp, MBool bFreeStruct=MFalse);
//	static MVoid	freeTimePositionsList(TIME_POSITIONS *list, MDWord cnt, MBool bFreeStruct=MFalse);


	static CONSTANT MTChar* transMS2CEFormat(MDWord timePos);


	/**********************for av gcs **********************/
	static MRESULT  BreedGCSObjCfgList(GCS_XML_OBJ_CONFIG *pSrcList, MDWord dwCount, GCS_XML_OBJ_CONFIG **ppDstList);
	static MRESULT  CopyGCSObjCfg(GCS_XML_OBJ_CONFIG *pSrc, GCS_XML_OBJ_CONFIG *pDst);
	static MVoid	DestroyGCSObjCfgList(GCS_XML_OBJ_CONFIG *pList, MDWord dwCount, MBool bFreeRoot=MFalse);
	static MVoid	DestroyGCSObjCfg(GCS_XML_OBJ_CONFIG *pCfg, MBool bFreeRoot=MFalse);

	
	static MRESULT  BreedGCSContainerCfgList(GCS_XML_CONTAINER_CONFIG *pSrcList, MDWord dwCount, GCS_XML_CONTAINER_CONFIG **ppDstList);
	static MRESULT  CopyGCSContainer(GCS_XML_CONTAINER_CONFIG *pSrc, GCS_XML_CONTAINER_CONFIG *pDst);
	static MVoid	DestroyGCSContainerCfgList(GCS_XML_CONTAINER_CONFIG *pList, MDWord dwCount, MBool bFreeRoot=MFalse);
	static MVoid	DestroyGCSContainerCfg(GCS_XML_CONTAINER_CONFIG *pCfg, MBool bFreeRoot=MFalse);


	static MRESULT  BreedGCSDrivenInfoList(GCS_XML_DRIVEN_INFO *pSrcList, MDWord dwCount, GCS_XML_DRIVEN_INFO **ppDstList);

	FUNC_EXPANDABLE static MRESULT  CopyGCSSrcParam(SOURCE_PARAM *pSrc, SOURCE_PARAM *pDst);
	FUNC_EXPANDABLE static MVoid 	DestroyGCSSrcParam(SOURCE_PARAM *pParam, MBool bFreeRoot=MFalse);

	static MRESULT ReviseAAInitParam(AA_INIT_PARAM *pParam);
	/*
	 * HR: Human Readable
	 */
	static MVoid	dbg_PrintHRGCSContainerCfgList(GCS_XML_CONTAINER_CONFIG *pCtnList, MDWord dwCtnCount);
	static MVoid	dbg_PrintHRGCSContainerCfg(GCS_XML_CONTAINER_CONFIG *pCtnCfg, const MTChar *prefix);
	static MVoid	dbg_PrintHRGCSObjectCfg(GCS_XML_OBJ_CONFIG *pObjCfg, const MTChar *prefix);
	static MVoid	dbg_PrintHRGCSObjectDICfg(GCS_XML_DRIVEN_INFO *pDI, const MTChar *prefix);
	static const MTChar* dbg_TransGD2String(MDWord dwGD); //必须返回非空字符串指针
	static const MTChar* dbg_TransCDModelType2String(MDWord dwModelType);
};


#endif



