#ifndef ET_AUDIO_ANALYSIS_DUAL_LIST_H
#define ET_AUDIO_ANALYSIS_DUAL_LIST_H


#include "etaudioanalysisinternaldef.h"


#define AADL_PROP_NONE					0x00000000
#define AADL_PROP_TIME_INTERVAL		(AADL_PROP_NONE+1)
#define AADL_PROP_NODE_VALUE_MDT		(AADL_PROP_NONE+2)

/*
 *	CQVETAudioAnalysisDualList
 *		Version:	
 *			-- Init by jgong @2016.02.26 
 *
 *	用于数据生产和消费双链表。加工好的待消费数据，都置于contentlist；消费过的数据，已经没用了，要及时还到empty-content list
 */
 
class CVEDualList;
class CQVETAudioAnalysisDualList : public CVEDualList
{

public:
	CQVETAudioAnalysisDualList();
	virtual ~CQVETAudioAnalysisDualList();

	

public:	
	//overrided function
	virtual MVoid*	GetContentElement();		//means Element contains something we are interested in
	virtual MRESULT	AddToContentList(MVoid* pElement);

	virtual MRESULT SetProp(MDWord dwPropType, MVoid* pValue, MDWord dwValueSize);
	virtual MRESULT GetProp(MDWord dwPropType, MVoid* pValue, MDWord dwValueSize);

	
	/*
	 * MDWord *pdwCacheStartedTS:
	 *		返回Cache数据的起始TimeStamp
	 */
	MVoid* PeekResult(MDWord dwTimeStamp, MDWord *pdwCacheStartedTS, MDWord *pdwResultIdx/*, MDWord *pdwContent*/);
	MRESULT CleanContentNode(MDWord dwCnt2Clean);//从第一个开始把dwCnt2Clean个带Content的Node清理成备用EmptyNode
	MRESULT CleanAllContentNode();


	/*
	 * By Jonathan @2016.07.14
	 * 	New interface addeed to meat the requirement of particle-system targeting on new audio-visualization feature.
	 */
	MRESULT InquireResultCollectionInfoByTimeRange(MDWord dwTimeStamp, MDWord dwDuration, AAIT_RESULT_COLLECTION_INFO *pInfo/*out*/);
	MVoid* 	PeekResultByIdx(MDWord dwResultIdx);

	MRESULT GetFMax(MFloat & fMax);
	MRESULT GetFAver(MFloat & fAver);
	MRESULT GetFMin(MFloat & fMin);
	MRESULT GetResFMax(MFloat & fAbsMax);

	//对于浮点数据的一些统计处理
	MVoid FloatStatProcess(AAIT_FINAL_RESULT * pNewRes);

	//对于浮点数据数据的一些统计
	MVoid FloatGroupStatProcess(AAIT_FINAL_RESULT * pNewRes);

	MVoid SetStatOriginValue(AAIT_FINAL_RESULT * pNewRes);
	MVoid DataStatProcess(AAIT_FINAL_RESULT * pNewRes);
private:
	MDWord m_dwResultStartedTS;
	MDWord m_dwEndTS;
	MDWord m_dwTimeInterval; //这是一个与外部模块约定好的值，外部其他模块在处理PCM时，都会按这个interval为单位进行处理
	MDWord m_dwNodeValueMDT;

	MFloat m_fDataMax;     //记录如果是浮点型时候的原数据最大值
	MFloat m_fDataMin;     //记录如果是浮点型时候的原数据最小值
	MFloat m_fAverData;       //记录如果是浮点型时候的原数据均值

	MFloat m_fResDataMax;  //平滑后数据的最大值
};




#endif //ET_AUDIO_ANALYSIS_DUAL_LIST_H



