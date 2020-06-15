#ifndef ET_AA_TARGET_H
#define ET_AA_TARGET_H


#include "etaudioanalysiscomdef.h"
#include "etaudioanalysisinternaldef.h"
#include "veduallist.h"
#include "etaudioanalysisduallist.h"
#include "qvasp.h"

#define AATG_CONFIG_NONE						(0x00000000)
#define AATG_CONFIG_INPUT_SAMPLE_INFO		(AATG_CONFIG_NONE+1)
#define AATG_CONFIG_TOTAL_AUDIO_DURATION	(AATG_CONFIG_NONE+2)

#define FUNC_EXPANDABLE	//it's only a tag to identify that if the function is possible to expand when new feature is comming

typedef MVoid(*FunNotifyDataCB) (const AAIT_FINAL_RESULT * pNode, MDWord dwRealType,MInt32 nTargetIndex, MVoid * pUserData);

class CQVETAATarget
{
friend class CAVUtils;
friend class CQVETAudioAnalyzer;

//	OVERLOAD_OPERATOR_NEW

public:
	CQVETAATarget();
	virtual ~CQVETAATarget();

	MRESULT Init(AA_PROCEDURE_TARGET *pTarget/*in,out*/);
	MVoid   Uninit();

	//for writting thread    
	/*
	 * Function:
	 *	 to perform analysis on PCM data
	 * Param:
	 *    	[in] pData is the pcm src data
	 *		[out] dwSrcCnt is the pcm src count
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */
	MRESULT PerformanAnalysis(MByte *pData[], MDWord dwSrcCnt, MDWord dwNumBytes, MDWord dwTimeStamp, MDWord dwTimeSpan);

	/*
	 * Function:
	 *	 to make it simple, function will judge if the clean operation will be performed
	 * Param:
	 *    	[in] dwCurUsedNodeIdx is used to judge how many cache need to be cleaned now
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */	
	MRESULT CleanPossiblePartCache(MDWord dwCurUsedNodeIdx);	

	/*
	 * Function:
	 *	 to get the final procedure step for using
	 * Param:
	 *    	null
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */	
	AAIT_PROCEDURE_STEP* GetFinalPS();
	MDWord GetCacheCapacity(){return m_dwCacheCapacity;}


	MRESULT SetConfig(MDWord dwCfg, MVoid *pValue, MDWord dwValueSize);


	//for read thread
	MVoid* PeekResult(MDWord dwTimeStamp, MDWord *pdwCacheStartedTS, MDWord *pdwResultIdx/*, MDWord *pdwContent*/); //peek一眼最后的处理结果
	MRESULT GetFinalReulstType(MDWord *pdwType);//查询最后一步处理的结果类型
	MRESULT CleanAllContentNode();
	MBool	HasEmptyResult();//结果cache是否都已经满了，如果满了，外部则不应该再送数据进来

	//仅在Group_float和float作为结果时是有意义的 bOrigin代表是原始值得最大值，还是处理值得最大值
	MRESULT GetMaxDataFloat(MFloat & fMax, MBool bOrigin);

	MDWord GetAnalysisType()
	{ 
		return m_dwType;
	}



	/*
	 * By Jonathan @2016.07.14
	 * 	New interface addeed to meat the requirement of particle-system targeting on new audio-visualization feature.
	 */
	MRESULT InquireResultCollectionInfoByTimeRange(MDWord dwTimeStamp, MDWord dwDuration, AAIT_RESULT_COLLECTION_INFO *pInfo/*out*/);
	MVoid* 	PeekResultByIdx(MDWord dwResultIdx);


	/*
	 *	CreateRTD:
	 *		1. dwStepIdx=0表示基本ASP处理那步，procedure_list里给出的一系列处理的idx从1开始;每一步处理都会有和output；这个接口是给CAVUtils::CreateRealTypeData()服务的
	 *		   用以创建相关数据类型
	 *		2. target每一个步骤会涉及不同的RealDataType，每一种RealData创建需要不同的辅助信息。
	 *		3. 如果只是孤立的创建RealData，用户完全可以自己去MMemAlloc，不用管辅助信息。
	 *		4. 考虑到上层调用者的统一性，开放了CreateRealData接口，并开放了这个获取辅助信息的接口(外部调用者其实也不用关心具体辅助信息是什么)
	 *		   这样上层调用者就不用关系具体细节，只要组合调用就可以了
	 *		5. 这个函数要在Target成功Init之后才能调用
	 *		最终这个接口，会被外部调用者通过audioanalyzer间接调用
	 *
	 *		具体分析如下:
	 * 			MDT_FLOAT			Null
	 * 			MDT_SPECTRUM		需要FrequencePoints，可能是模板配置死的，也有可能是ASP的默认值
	 * 			MDT_VOLUMN_SET	需要知道Set的capacity，（来自pTarget->m_dwADCapacity；进一步又来自于QVAmplitudeDetector，目前不会动态调整）
	 * 			MDT_ONSET_SET		需要知道ODCapacity (来自pTarget->m_dwODCapacity；进一步又来自于QVOnsetDetector，目前QVOnsetDetector没有开放动态调整ODCapacity；是写死的)
	 * 			MDT_FLOAT_GROUP	需要知道Count，是由模板配置死的
	 *
	 *	It's Process, not Procedure，so Basic ASP is included
	 */

	FUNC_EXPANDABLE MRESULT CreateRTD(MDWord dwProcessIdx/*in*/, MVoid **ppData/*out*/, MDWord *pdwType/*out*/, MDWord *pdwDataSize/*out*/);
	MRESULT GetASPConfig(MDWord dwASPCfg, MVoid *pValue, MDWord dwCfgSize);


	MVoid SetNotifyDataCB(FunNotifyDataCB pCB, MVoid * pUserData, MInt32 nIndexTarget);
	MRESULT InsertResultDataToTarget(MVoid * pResData, MDWord dwTimeStamp, MDWord dwTimeSpan);

private:
	MRESULT ProcessBasicASPAnalysis(MByte *pData[], MDWord dwSrcCnt, MDWord dwNumBytes, MVoid **ppStepOutput);
	MRESULT ProcessProcedureStep(MVoid *pStepInput, MDWord dwStepIdx, MVoid **ppStepOutput);
	

	MRESULT PrepareProcedureStuff(AA_PROCEDURE_TARGET *pTargetParam);
	MRESULT PrepareQASP(AA_PROCEDURE_TARGET *pTargetParam);
	MRESULT PrepareProcedureStepList(MDWord dwCfgCnt/*in*/, AA_PROCEDURE_CONFIG *CfgList);
	MRESULT PrepareFinalResultCache(AAIT_PROCEDURE_STEP *pFinalStep);

	MVoid	DestroyFinalResultCache();
	MVoid	DestroyProcedureStepList();
	FUNC_EXPANDABLE MVoid DestroyQASP();
	MVoid	DestroyProcedureStuff();//1.destroy ASP, 2.clean ps list, 3.clean cache



//	FUNC_EXPANDABLE MVoid	FreeProcedureStepList(MDWord dwPSCnt, AAIT_PROCEDURE_STEP *PSList);
	//typedef MVoid* 	(*CREATE_ElEMENT_FUNC)(MVoid* pUserData);
	//typedef MRESULT	(*DESTROY_ElEMENT_FUNC)(MVoid *pElement);
	inline static MVoid*	u_CreateFinalResultNode(MVoid* pUserData);
	inline static MRESULT	u_DestroyFinalResultNode(MVoid* pElement);


	FUNC_EXPANDABLE MRESULT	TranslateProcedureInputMDT(MDWord dwLastOutputMDT, MDWord dwThisMFT, MDWord *pdwThisInputMDT/*in,out*/);
	FUNC_EXPANDABLE MRESULT	TranslateProcedureOutputMDT(MDWord dwInputMDT, MDWord dwMFT, MDWord *pdwOutputMDT/*out*/);

	
	//for cascade process

//	FUNC_EXPANDABLE MRESULT DoProcedureStep(MVoid *pStepInput, MDWord dwStepIdx, MVoid **ppStepOutput);
	FUNC_EXPANDABLE MRESULT DoMFTMax(MVoid *pInputData, MDWord dwInputMDT, MVoid *pMFP, MDWord dwOutputMDT, MVoid *pOutput);
	FUNC_EXPANDABLE MRESULT DoMFTAverage(MVoid *pInputData, MDWord dwInputMDT, MVoid *pMFP, MDWord dwOutputMDT, MVoid *pOutput);
	FUNC_EXPANDABLE MRESULT DoMFTLinearRange2Range(MVoid *pInputData, MDWord dwInputMDT, MVoid *pMFP, MDWord dwOutputMDT, MVoid *pOutput);
	FUNC_EXPANDABLE MRESULT DoMFTOutputDirect(MVoid *pInputData, MDWord dwInputMDT, MVoid *pMFP, MDWord dwOutputMDT, MVoid *pOutput);
	MRESULT DoMFTSpectrumMerge(MVoid *pInputData, MDWord dwInputMDT, MVoid *pMFP, MDWord dwOutputMDT, MVoid *pOutput);
	FUNC_EXPANDABLE MRESULT DoMFTGroupLinearRange2Range(MVoid *pInputData, MDWord dwInputMDT, MVoid *pMFP, MDWord dwOutputMDT, MVoid *pOutput);


	/*
	 * 	GetProcedureOutputComboValueCount的处理与PrepareProcedureStepList以及CreateRTD()有关系。
	 * 	如果处理中涉及到PreviousPSIdx的话，PrepareProcedureStepList中已经实现准备好了.
	 *	该函数只针对Spectrum,VolumnSet,OnsetSet,FloatGroup等数据结构类型
	 *
	 *	!!!!是Procedure,not Process所以不包含Basic ASP
	 */
	FUNC_EXPANDABLE MDWord GetProcedureOutputComboValueCount(MDWord dwProcedureIdx);
	FUNC_EXPANDABLE MDWord GetBasicASPOutputComboValueCount(MDWord *pdwMDT/*out*/);

	MVoid	dbg_PrintProcedureStepList();
private:	
	MDWord	m_dwType;//used to identify the processing type
	MDWord	m_dwTimeWindowWidth; //based on millisecond
	MDWord	m_dwFrequenceRange;
	MDWord  m_dwOutputMode; //basic asp output mode: QASP_OUTPUT_MODE_XXX
	MHandle m_hASP;
	MVoid 	*m_pASPOutput; //ASP模块的分析结果，不同的QASP_TYPE_XXX 对应不同的ASP_XXXX_RESULT	

	MDWord	m_dwADCapacity; //音量分析结果的容量，方便使用
	MDWord	m_dwODCapacity; //onset 分析结果容量，方便使用
		
	CQVETAudioAnalysisDualList		*m_pDualList;
	MDWord	m_dwCacheCapacity; //DualList最多能装几个有效结果
	MDWord	m_dwPSCnt;
	AAIT_PROCEDURE_STEP *m_PSList; //transformed from PCList in InitParam given by caller

	MDWord  m_dwAudioDuration; //audio total length
	AUDIO_SAMPLE_INFO m_InputSampleInfo;

	//解析数据通知，主要这个很不方便在函数调用中返回，才用个回调
	FunNotifyDataCB m_pFunNotify;
	MVoid * m_pUserData;
	MInt32 m_nTargetIndex;
};



#endif
