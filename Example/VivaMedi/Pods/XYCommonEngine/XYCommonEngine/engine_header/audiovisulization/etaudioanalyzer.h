#ifndef ET_AUDIO_ANALYZER_H
#define ET_AUDIO_ANALYZER_H

class CMThread;



#include "etaudioanalysiscomdef.h"
#include "etaudioanalysisinternaldef.h"
#include "veduallist.h"
#include "etaudioanalysisduallist.h"
#include "etaatarget.h"
#include "qvasp.h"
#include <map>


/*
 *	Audio Analysis级联处理的有关概念:
 *
 *							|			|
 *							|			|
 *						MethodFunc	MethodParam
 *							|			|
 *							V			V
 *						+----------------------+
 *                      |                      |
 *    ---Input Data-----> |   Process Dark Box   | ------Output Data----->
 *		(DataType)		|					   |		(DataType)
 *						+----------------------+
 *
 *
 *  逻辑上每一级都有如上形式，一定算法MethodFunc确定了，其输出的DataType也确定了。
 *  因此一个重点是MethodFunc的宏定义中会包含OutputData的Type
 *
 *  对于黑箱处理，几个端口的相互关联关系如下:
 *					
 *	 MethodFunc	---+---强关联，决定形式和内容------> Output Data
 *		^		   |
 * 		|		   +---强关联，决定形式和内容------> Method Param
 *		|
 *	   弱关联(决定形式，但不决定内容)
 *		|
 *		|
 *		V
 *	 InputData
 *
 */



class CQVETAAStreamBufferCache;
class CQVETAAParser;
class CQVETAADataPacker;
class CQVETAudioAnalyzerMgr;
class CQVETAudioAnalyzer;

typedef struct tag_AudioAnaInsKey
{
	MTChar szAudioPath[AMVE_MAXPATH];
	MD5ID  stAvConfigID;
	AMVE_POSITION_RANGE_TYPE audioRange;

	bool operator == (const tag_AudioAnaInsKey & other) {
		bool bRet = false;
		tag_AudioAnaInsKey * pCmp = const_cast<tag_AudioAnaInsKey *>(&other);

		if (MMemCmp(this, pCmp, sizeof(tag_AudioAnaInsKey)) == 0)
		{
			bRet = true;
		}

		return bRet;
	}

	bool operator < (const tag_AudioAnaInsKey & other) const {
		bool bRet = false;
		tag_AudioAnaInsKey * pCmp = const_cast<tag_AudioAnaInsKey *>(&other);
		tag_AudioAnaInsKey * pThis = const_cast<tag_AudioAnaInsKey *>(this);
		if (MMemCmp(pThis, pCmp, sizeof(tag_AudioAnaInsKey)) < 0)
		{
			bRet = true;
		}

		return bRet;
	}
}AudioAnaInsKey;

typedef struct tag_AudioAnaInsValue
{
	CQVETAudioAnalyzer * pAna;
	MDWord dwRefCount;
}AudioAnaInsValue;

#define MULTI_TARGET	//用以说明某函数以后会做多路处理扩展
#define FUNC_OPTIMIZABLE	//used to identify the function is optimizable in the feature

/*
 *	class CQVETAudioAnalyzer
 *		Description:
 *			This AudioAnalyzer is based on ASP module, but more than ASP module. (ASP=Audio Signal Processing)
 *			It can give the normal analysis result of audio signal, and also you can set the secondary process rule to order it
 *			to performan more calculation or transformation based on the ASP module's result.
 *			
 *			The direct result analyzed by ASP is base on the physical description and music theory.
 *			For example: audio volume, spectrum, onset....
 *			But the secondary process can give you more than those, as long as you set the the rule you want
 *			For example: the video alpha value, the physical object space postion, the water flow speed.....
 *
 *			That's also the AudioAnalyzer's design goal--make it possible that the audio data can drive other data process.
 *		Version:
 *			1. Initilized version @2016.02.19 by Jonathan.
 *			2. Change framework and work-flow @2016.03.29 by Jonathan. 
 *			   Now the CQVETAudioAnalyzer would be better to be renamed to CQVETAudioAnalysisScheduler,
 *			   because now the main duty of this class is to perform analysis scheduling, and it doesn't perform exact analysis job anymore.
 *			   The exact analysis job has been carried by CQVETAATarget
 *			   ----(of course the CQVETAATarget should also be rename to a better name to show its duty, such as analyzer. ^_^)
 *
 *
 * 
 */
class CQVETAudioAnalyzer : public CMThread
{
	friend class CAVUtils;

	OVERLOAD_OPERATOR_NEW
public:
	CQVETAudioAnalyzer();
	virtual ~CQVETAudioAnalyzer();

	/*
	 * Init()
	 * 	dwASPType: 	refer to QASP_TYPE_XXXXX defined in qvasp.h
	 *				QASP_TYPE_FREQUENCE_ANALYSIS   <-->	AA_SPECTRUM_SETTING
	 *				............
	 */
	MRESULT Init(AA_INIT_PARAM *pParam);
	MVoid	Uninit();

	MRESULT SetProp(MDWord dwPropType, MVoid* pProp, MDWord dwPropSize);//暂不支持
	MRESULT GetProp(MDWord dwPropType, MVoid* pProp, MDWord dwPropSize);//暂不支持

	MVoid SetAnalysisProcessCB(FunAudioAnalysisCB pCB,MVoid * pUserData);
	/*
	 *	GetAnalysisResult:
	 *		阻塞模式
	 *		目前暂时只有audio spectrum analysis result, 且init时给出的dwOutputValueMFT也就只有MFT_LINEAR_RANGE_TO_RANGE这一种
	 *		所以目前的result的数据实体为MFloat
	 *
	 *	pAAResult->dwRequiredMDT: MDT_XXXX, 所要求的Result的类型
	 *	dwTargetIdx: 按模板配置，可能会同时要做多路处理，用此变量标明要用哪路
	 *
	 *	@param dwTimeStamp 是AA audio的dst时间，无论是否有trim，都是从0开始，内部会做转换
	 *
	 *	GetAnalysisResult_NonBlockMode:
	 *		非阻塞模式
	 */
	MULTI_TARGET MRESULT GetAnalysisResult(MDWord dwTimeStamp, MDWord dwTargetIdx, AA_RESULT *pAAResult);
	MULTI_TARGET MRESULT GetAnalysisResult_NonBlockMode(MDWord dwTimeStamp, MDWord dwTargetIdx, AA_RESULT *pAAResult);
	MULTI_TARGET MRESULT GetTargetFinalReulstType(MDWord dwTargetIdx, MDWord *pdwType);


	/*
	 *	GetAnalysisResultByTimeRange: 阻塞模式
	 *	GetAnalysisResultByTimeRange_NonBlockMode: 非阻塞模式
	 *		计划赶不上变化，就这样迎来了新需求!
	 *		AA_RESULT_COLLECTION的所有权为CQVETAudioAnalyzer所有，使用权(只读)归调用者所有。其内存空间及生命周期由CQVETAudioAnalyzer维护。
	 *		CQVETAudioAnalyzer内部会视情况动态扩展RESULT_LIST。
	 *
	 *	GetAnalysisResultByTimeRange_NonBlockMode()接口内部逻辑:
	 *		1. 如果要求10秒数据，但请求时只有2秒的数据，此时会返回那仅有的2秒数据。
	 *		2. 如果一点数据都没有，则返回错误。
	 */
	MULTI_TARGET MRESULT GetAnalysisResultByTimeRange(MDWord dwTimePos, MDWord dwDuration, 
														MDWord dwTargetIdx, AA_RESULT_COLLECTION** ppResult);
	MULTI_TARGET MRESULT GetAnalysisResultByTimeRange_NonBlockMode(MDWord dwTimePos, MDWord dwDuration, 
																		MDWord dwTargetIdx, AA_RESULT_COLLECTION** ppResult);

	/*
	 *	CreateProcessRealTypeData用于替换CAVUtils::CreateRealTypeData()
	 *	背景: AV频谱引入后，频点数由设计决定，已经不是原来的ASP模块内定。因此原有Create函数已无法满足要求，需要扩展
	 *	软件设计形态: 源头在模板，各种配置都由模板给定----模板直接决定的AA里Target的各个参数，因此最终CreateRealTypeData的所需信息
	 *				应该来自Target。因此取道AA，创建所需数据
	 */
	MULTI_TARGET MRESULT CreateProcessRealTypeData(	MDWord dwTargetIdx/*in*/, MDWord dwProcessStepIdx/*in*/, 
														MVoid **ppData/*out*/, MDWord *pdwDataType/*out*/, MDWord *pdwDataSize/*out*/);

	MVoid ReceiveTargetNotify(const AAIT_FINAL_RESULT * pNode, MDWord dwRealType, MInt32 nTargetIndex);

	//目前所有的Target的窗口长度都是一样的
	MInt32 GetTimeWindowWidth();

	MRESULT MakeAmpEndValue(CQVETAATarget * pTarget, MFloat fOriValue, MDWord dwIndex, MDWord dwTimeStamp ,MFloat & fRes);

	MRESULT GetAnaKey(AudioAnaInsKey & key);
public:
	static CQVETAudioAnalyzerMgr * GetAnaMgrIns();
	static MVoid DestroyAnaMgrIns();
private:
//	MRESULT PrepareContext(AA_PROCEDURE_TARGET *pTargets, MDWord dwTargetCnt);

	
	//for thread operation
	MRESULT StartAnalyzingThread();
	MVoid	StopAnalyzingThread();

	virtual MDWord Run();
	MDWord	GetNextAction();
	MRESULT DoAnalysis(); //没有doResume, resume就是DoAnlysis; 同时，简化线程状态机，一进来就进入Analyzing态
	MRESULT DoFlush2ThisTimePosNearBy();		
 

//	MRESULT CleanPossiblePartCache(MDWord dwCurUsedNodeIdx);//这个函数需要在AA调用者线程调用，只要条件满足就会做清理，否则直接返回
	AAIT_FINAL_RESULT* WaitRequiedTimeStamp(MDWord dwTargetIdx, MDWord dwTimeStamp);//基于peak方式的wait
	AAIT_FINAL_RESULT* WaitRequiredResultIdx(MDWord dwTargetIdx, MLong lResultIdx); //这个函数是随着GetAnalysisResultByTimeRange一起引入的
	MRESULT Flush2ThisTimePosNearBy(MDWord dwTargetIdx, MDWord dwTimeStamp);	

	/*
	 *	遇到一个问题: 模板配置TimeWindow20ms，而mp3一帧为26ms，而CMV2MediaOutputStream没有cache，如果直接问其要20ms数据，造成6ms数据被cache在decoder里
	 *	会触发后续一系列问题，所以在AudioAnalyzer里做个大Cache
	 */
 	MRESULT GetWindowPCMFromBigCache(	MByte *pBuf, MDWord dwBufLen, MDWord *pdwDataGot,
 											MDWord *pdwTimeStamp, MDWord *pdwTimeSpan);

	MRESULT PrepareWorkStuff();
	MRESULT GetPCMData4Target(MDWord dwTargetIdx, QVET_BUFFER *pBuf);
	
	MRESULT FillDataByParser();
	MRESULT InitDataSource(AA_INIT_PARAM *pParam);
private:
	static CQVETAudioAnalyzerMgr * g_AudioAnaMgr;

	MTChar	m_pszAudioFile[AMVE_MAXPATH];
	AMVE_POSITION_RANGE_TYPE m_SrcAudioRange;
	MD5ID   m_avConfigID;
	MBool	m_bRepeatAudio;
	MDWord  m_dwDstAudioLength;//综合考量repeat之后的总长度
	MDWord  m_dwDstStartPos;   //storyboard上的起始时间点

	CQVETAAStreamBufferCache *m_pSBC;
	MRESULT *m_pSBCErrList;

	MV2AUDIOINFO	m_SrcAudioInfo;	
	QVET_BUFFER		m_BigCache;
	QVET_BUFFER		*m_pTargetBufList;//每个TargetBuf都是复用了BigCache			



	CQVETAATarget	**m_pTargets;
	AA_RESULT_COLLECTION *m_pCollectionList;//这是一个基于"非旁路输出"的变量，list count=m_dwTargetCnt，只有在"时域"获取模式下才会用到，"非时域"情况下有外部准备数据
	MDWord 			m_dwTargetCnt;//Ctx的Cnt与Target一致
	//category: procedure stuff

	MDWord	m_dwTimeWindowWidth; //based on millisecond，虽然Target里有，但这里再保留一份，方便使用

	//about Thread
	MDWord	m_dwCurStatus;
	MDWord  m_dwRequiredStatus;
	CMEvent m_StatusUpdatedEvent;
	CMEvent	m_Event;
	MRESULT m_LastRunError;
	MBool	m_bFlushed;
//	MDWord	m_dwFlushPos;
	AAIT_FLUSH_OP_INFO	m_FlushInfo;

	MDWord	m_dwCurTimePos; //区别stream的时间，引入repeat之后，m_dwCurTimes与从stream里read出来的时间可能会是y=ax+b的关系了, 它是综合repeat和srcrange之后的结果
	MDWord	m_bStreanEnd;
	MRESULT m_dwStreamReadFatalErr;//用于包容底层MVLib Stream错误，暂时不用了
	
	MBool m_bJustLoadResFile;   //仅仅是将结果文件载入进来而不进行数据的解析
	CQVETAAParser * m_pParser;
	CQVETAADataPacker * m_pPacker;

	MDWord m_testCount;

	MVoid * m_pUserData;
	FunAudioAnalysisCB m_pAnaProcessCB;
};


class CQVETAudioAnalyzerMgr
{
public:
	CQVETAudioAnalyzerMgr();
	~CQVETAudioAnalyzerMgr();

	CQVETAudioAnalyzer * GetOrMakeAudioAna(AA_INIT_PARAM & iniParam);
	MVoid ReleaseAudioAna(CQVETAudioAnalyzer * pAna);

private:
	std::map<AudioAnaInsKey, AudioAnaInsValue> m_MapAudioAna;
};



#endif //ET_AUDIO_ANALYZER_H
