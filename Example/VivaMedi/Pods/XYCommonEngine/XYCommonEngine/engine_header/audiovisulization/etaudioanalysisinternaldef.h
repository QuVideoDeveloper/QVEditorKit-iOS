#ifndef ET_AUDIO_ANALYSIS_INTERNAL_DEF_H
#define ET_AUDIO_ANALYSIS_INTERNAL_DEF_H


 /***************************************************************************************
 ***********************        Audio Drives Visual Content        **********************
 ****************************************************************************************/

 
/********************************Audio Analyzer 内部数据结构定义********************************/
//AAIT = Audio Analysis Internal

/*
 *	AAIT_PROCEDURE_STEP:
 *		AAIT_PROCEDURE_STEP is transformated from AA_PROCEDURE_CONFIG, one on one!
 */
typedef struct __tagAAIT_PROCEDURE_STEP
{
	MDWord dwInputMDT;	//MDT=Math Data Type

	MDWord dwMFT;
	MVoid *pMFP;

	MDWord dwOutputMDT;
	MVoid *pOutput;	//本级处理结果存储于本级，供下级处理所用，但结果的所有权归本级所有, such as:MFloat, ASP_FREQUENCE_SPECTRUM_RESULT,ASP_AMPLITUDE_DETECT_RESULT,ASP_ONSET_DETECTION_RESULT...
}AAIT_PROCEDURE_STEP;


typedef struct __tagAAIT_FINAL_RESULT
{
	MDWord dwTimePos;
	MDWord dwTimeSpan; //how long this result coverd in the time field
	MDWord dwMDT; //MDT_XXXX, used to identify the pValue type
	MVoid  *pValue; //外部要求不同的MFT，会导致不同数据类型的pValue

	MVoid * pResValue; //经过处理后的本时间节点的数据值

}AAIT_FINAL_RESULT;//取名有待商榷，但这个数据结构是用于描述经过(多步)处理后的、并且存放于duallist的数据结构


/*
 *	AAIT_RESULT_COLLECTION_INFO数据结构产生的背景:
 *		中途出现了新的需求: 给定分析器一段时间范围，然后audio分析器要给出与之相应的分析result list。
 *		这个数据结构，是用于在先查询当前result cache里的相关信息的，然后根据此信息跟进相应的代码逻辑。
 */
typedef struct __tagAAIT_RESULT_COLLECTION_INFO
{
	MDWord dwValueMDT; //result中value的MDT

	MLong lStartIdx; //如果=-1, 表示没有满足要求的result，此时dwValidCnt应是相应的0。
	MDWord dwValidCnt;//如果=0，说明没有有效的result，lStartIdx也应相应的为-1。
	MDWord dwCntShouldBe;//这个变量要=0,唯一的可能就是外部所查询的时段已经超出了audio选定范围。

	MDWord dwCacheStartedTS;//缓存数据的起始时间值
	MDWord dwCacheEndTS;
}AAIT_RESULT_COLLECTION_INFO;



typedef struct __tagAAIT_FLUSH_OP_INFO
{
	MDWord dwTargetIdx;
	MDWord dwFlushPos;
}AAIT_FLUSH_OP_INFO;


#define ETAA_MAX(x,y)	((x)>(y)?(x):(y))
#define ETAA_MIN(x,y)	((x)<(y)?(x):(y))

#define INVALID_INDEX	(-1)


#endif	//ET_AUDIO_ANALYSIS_INTERNAL_DEF_H







