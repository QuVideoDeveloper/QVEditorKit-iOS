#ifndef ET_AUDIO_ANALYSIS_COMDEF_H
#define ET_AUDIO_ANALYSIS_COMDEF_H

#include "ampkpackerhead.h"

#define ASP_OUTPUT_MODE_DECIBEL		0//based on dB
#define ASP_OUTPUT_MODE_LINEAR		1	//not all asp support this mode
	



#define AUDIO_FREQUENCY_RANGE_NONE		0x00000000
#define AFR_LOW						0x00000001 //低频范围，具体取值范围，外部无需关心
#define AFR_MIDDLE					0x00000002 //中频范围，具体取值范围，外部无需关心
#define AFR_HIGH					0x00000004 //高频范围，具体取值范围，外部无需关心
#define AFR_ALL						0x00000007 //所有频率范围，具体取值范围，外部无需关心

/*
 *	Math Data Type:
 *		用以描述Math Function在处理过程中的涉及到的数据类型, 总体分为两种:
 *		1. real type ---- 有真实数据类型对应的
 *		2. virtual type ---- 语义上的描述，AudioAnalyzer内部会将其转化为真实数据类型, 只是为了模板配置方便
 *		
 *		定义的由来:
 *		模板配置时，给定某个MFT(见下文定义)，还需要给出InputDataType(但有可能是多级级联处理)
 *		第一级处理的输入是必须人为给出的，比如MDT_SPECTRUM 表示给定的是一个频谱数据，而且也肯定是RealType
 *		但是之后的几级处理的输入可直接用MDT_LAST_STEP_OUTPUT来表示, 说明是要直接复用上级输出，代码会将其解析成具体类型
 *
 *		RealType比较好理解，但对于VirtualType也不要困惑。
 *		不出意外，在外部模板配置时只需要知道MDT_LAST_STEP_OUTPUT 这一个VirtualType即可了，其他VirtualType是内部处理使用的
 */
#define MATH_DATE_TYPE_BASE				0x00000000
#define MATH_DATE_TYPE_NONE				(MATH_DATE_TYPE_BASE)

#define MDT_REAL_TYPE_BASE				(MATH_DATE_TYPE_BASE + 0x00000000)
#define MDT_FLOAT							(MATH_DATE_TYPE_BASE + 0x00010000) //0x00010000, 数据就是一个浮点型数据MFloat
#define MDT_SPECTRUM						(MATH_DATE_TYPE_BASE + 0x00020000) //0x00020000, 数据是ASP模块输出的ASP_FREQUENCE_SPECTRUM_RESULT
#define MDT_VOLUMN_SET						(MATH_DATE_TYPE_BASE + 0x00030000) //0x00030000, 数据是ASP模块输出的ASP_AMPLITUDE_DETECT_RESULT
#define MDT_ONSET_SET						(MATH_DATE_TYPE_BASE + 0x00040000) //0x00040000, 数据是ASP模块输出的ASP_ONSET_DETECTION_RESULT
#define MDT_FLOAT_GROUP					(MATH_DATE_TYPE_BASE + 0x00050000) //0x00050000, 数据时AA_FLOAT_GROUP

#define MDT_VIRTUAL_TYPE_BASE				(MATH_DATE_TYPE_BASE + 0x80000000)//0x80000000 //语义上的完整，不要将该值用于模板配置
#define MDT_LAST_STEP_OUTPUT				(MATH_DATE_TYPE_BASE + 0x80010000)//0x80010000
#define MDT_THIS_STEP_INPUT				(MATH_DATE_TYPE_BASE + 0x80020000)//0x80020000	
#define MDT_GENERIC						(MATH_DATE_TYPE_BASE + 0x80030000)//0x80030000, 泛型数据，先不要碰这种

#define MDT_MASK							0xFFFF0000	//"与或操作"的掩码
#define MDT_VIRTUAL_MASK					MDT_VIRTUAL_TYPE_BASE


/*
 *	Combo MDT:
 *		数据结构中包含不止一个值，而是包含了一串值。
 *		而对于Non Combo MDT， 目前只有MDT_FLOAT这种
 */
#define IS_COMBO_MDT(mdt)	\
		(MDT_SPECTRUM==(mdt) || MDT_VOLUMN_SET==(mdt) || MDT_ONSET_SET==(mdt) || MDT_FLOAT_GROUP==(mdt))


/*
 *	MFT_XXXX: (Math Function Type Macro Definition)
 *	MFP_XXXX:	 (Math Function Param Structure Definition)
 *		表示在数据处理过程所用到的各种数学处理函数, 原则上每种MFT都要搭配给出相应的MFP----即数学函数的参数
 *				MFT_A	<---->	MFP_A
 *				MFT_B	<---->	MFP_B
 *		但是像MAX,AVERAGE,ORIGINAL这种函数关系简单, 因此实际给出的相应MFP可以为空
 *
 *		其他MFT对应MFP如下:
 *			MFT_LINEAR_RANGE_TO_RANGE	对应数据结构	MFP_LINEAR_R2R
 *			.......
 *		设计思路:
 *			一种算法定下来后，其输出的数据类型就定下来了，因此MFT的数值定义中，包含了Output的数据类型的定义
 */
#define	MATH_FUNCTION_TYPE_NONE			0x00000000
#define	MFT_MAX								(MDT_FLOAT | 0x00000001) //0x00010001	语义上即取最大值
#define MFT_AVERAGE						(MDT_FLOAT | 0x00000002) //0x00010002	语义上即取平均值
#define MFT_LINEAR_RANGE_TO_RANGE		(MDT_FLOAT | 0x00000003) //0x00010003	[A-Min, A-Max]  <-----> [B-Min, B-Max], 这是一个线性映射，A,B代表了不同的描述项，比如把功率范围映射成Alpha范围
#define MFT_OUTPUT_DIRECT					(MDT_THIS_STEP_INPUT| 0x00000004) //0x80020004 语义上f(x[n]) = x[n], 即不对x[n]做任何数学处理
#define MFT_GROUP_LINEAR_RANGE_TO_RANGE	(MDT_FLOAT_GROUP 	| 0x00000005) //0x00050005 一串float值，每个都做线性映射
#define MFT_SPECTRUM_MERGE				(MDT_SPECTRUM 		| 0x00000006) //0x00020006 解决源频谱数据与目标数据频点不一样的问题----将多频点数据到合并到少频点数据


#define GET_MFT_OUTPUT_DATA_TYPE(MFT)	((MFT) & (MDT_MASK) )
#define IS_VIRTUAL_DATA_TYPE(dataType)	(MDT_VIRTUAL_MASK & (dataType))
#define IS_REAL_DATA_TYPE(dataType)		(!(IS_VIRTUAL_DATA_TYPE(dataType)))
			

#define AA_PROP_NONE						0x00000000
//#define AA_PROP_FINAL_RESULT_TYPE		0x00000001 //based on MDT_XXX which is the real type, 考虑到以后多路处理，单独开了个接口来取了
//#define AA_PROP_FREQUENCE_POINT_COUNT	0x00000002 //when do the analysis related to the frequence, you should know this

#define AA_PROCESS_NONE 0
#define AA_PROCESS_RUNNING 1
#define AA_PROCESS_FINSHED 2

typedef struct __tagMFP_LINEAR_R2R
{
	MFloat fInputMin;
	MFloat fInputMax;
	MFloat fOutputMin;
	MFloat fOutputMax;
}MFP_LINEAR_R2R; //Corresponding to MFT_LINEAR_RANGE_TO_RANGE

typedef struct __tagMFP_SPECTRUM_MERGE
{
	//it includes the DC component, when you argue it, you'd better take DC component to considered, so dwDstFrequencePoints = DC-Component + AC-Component-Count.
	MDWord dwDstFrequencePoints; 
	MDWord dwOutputMode; //
}MFP_SPECTRUM_MERGE;

typedef struct __tagAA_PROCEDURE_CONFIG
{
	MBool	bSubOutput; //预设的变量，用于后续做支路输出，现在暂时用不到
	MDWord 	dwInputMDT;	//input data source type, defined as MDT_, 用以说明来源
	MDWord 	dwMFT;	//defined as MFT_XXX
	MVoid	*pMFP;  //the date type is decided by dwMFT, and has the name as MFP_XXXX
	//MDWord  dwOutputType;	//用以标示输出类型, 给定输入源/MFT/MFP，输出类型就被决定了
}AA_PROCEDURE_CONFIG;


//This special procedure idx is for your convenience, it's usually used in the CAVUtils::GetProcedureOutputDataInfo()
#define BASIC_PROCESS_STEP_IDX	(0)
#define FINAL_PROCESS_STEP_IDX	(-1)


//一个AA，多个Target的情况下，必须dwTimeWindowWidth都一样
typedef struct __tagAA_PROCEDURE_TARGET
{
	MDWord dwAnalysisType;
	MDWord dwTimeWindowWidth; //based on millisecond, 与可视化的FPS有关，window越小，处理的时间单元越小，时间分辨率越高，可以使得FPS越大
	MDWord dwFrequenceRange; //AFR_XXX
	MDWord dwBasicOutputMode;//QASP_OUTPUT_MODE_XXX

	union {
		struct {
			MFloat fStartFP;//default is 1Hz
			MFloat fEndFP;	//default is -1Hz, whicn means max Frequence Point of that audio
			MDWord dwFPCount; //how many frequence points required
		}; //for spectrum param

	};

	MDWord dwPCCnt;
	AA_PROCEDURE_CONFIG *pPCList;//it means there may be several process steps

	//这个变量在AA init之后会被赋值，AA的调用者并不需要直接使用他，但是里面隐藏的一些东西，在其他接口会用到。
	//aa调用者只要传递一下这个Instance即可。调用者这不拥有此Instance的所有权，也不能释放它，这里只是暂存
	MHandle hInstance; 
}AA_PROCEDURE_TARGET; // AV = audio visualization

typedef MVoid (* FunAudioAnalysisCB) (MVoid * pData, MInt32 nDataLen,MVoid * pUserData);

typedef struct __tagAA_INIT_PARAM
{
	MTChar szAudioFile[AMVE_MAXPATH];
	AMVE_POSITION_RANGE_TYPE AudioRange;
	MBool bRepeatAudio;
	MDWord dwDstAudioLength; //因为repeat的缘故，引入这个变量
	MDWord dwDstStartPos;    //在storyboard中Effect起始的时间

	//现在出现了多个Target的情况，dwTimeWindowWidth被挪到了Target里，就是对同一个音频文件的不同的处理行为（频谱分析，音量分析等等，被作为多个Target）
	//但是先简单处理，不同的Target的dwTimeWindowWidth必须要一样
	AA_PROCEDURE_TARGET *pTargets;
	MDWord dwTargetCnt;
	MTChar szResDataFile[AMVE_MAXPATH]; //szResDataFile APP指定的结果文件的存储路径
	MBool bNewBuild;     //是否新解析一次，如果结果文件不存在或者现在的参数和结果文件中的参数不一致，内部会重新解析的。否则解析载入结果文件处理好的数据

	MD5ID  stAvConfigID; //参数标识，唯一性，主要由于直接比较target太麻烦了
}AA_INIT_PARAM;

/*
 *	AA_RESULT
 *	@param MFloat fMinValue: 
 *	@param MFloat fMaxValue:
 *		要告诉调用这结果的取值范围，但其对应实际含义要视dwRequiredMDT而定
 *		比如dwRequiredMDT = MDT_MFLOAT，其实际含义可能是alpha值，那么fMaxValue/fMinValue 指输出的alpha数值的最大值与最小值范围
 *		如果dwRequiredMDT = MDT_SPECTRUM, 此时输出的频谱结果中，所有频点功率的最大值与最小值范围
 *
 *	AudioAnalyzer会不停的扩展
 *		要考虑到以后没有最大最小值的范围，目前也只有最后一步为MFT_LINEAR_RANGE_TO_RANGE的有最大最小的概念
 */
typedef struct __tagAA_RESULT
{
	MDWord dwRequiredMDT; //MDT_XXXX, 所要求的Result的类型, used to identity the result data type which caller required, and AA module will judge if it's the right MDT
	MVoid* pValue; //pValue所对应的数据解构会因为不同dwRequiredMDT而不同
	MDWord dwValueSize;

	MFloat fMinValue;
	MFloat fMaxValue;//Value所指代的最大值与最小值
}AA_RESULT;



/*
 *	AA_RESULT_COLLECTION的来龙去脉:
 *		后来有一个需求，要让AudioAnalyzer给出一段时间范围内的分析结果，由此衍生出了带有"array"烙印的、新的数据结构AA_RESULT_COLLECTION
 */
typedef struct  __tagAA_RESULT_COLLECTION
{
	MDWord dwValueMDT;//it's MDT_XXXX defined above
	MDWord dwCapacity;//the max element count of array when allocate the array
	MDWord dwValidCount; //dwValidCount <= dwCapacity
	MDWord* TimeStampArray;//it's an array of MDWord count by dwValueCount
	MDWord* TimeSpanArray;//it's an array of MDWord count by dwValueCount
	MHandle* ValueHArray;//it's an array of MHandle count by dwValueCount, the element is an pointer which point to the target value struct.
}AA_RESULT_COLLECTION;


typedef struct __tagAA_FLOAT_GROUP
{
	MDWord dwCapacity;
	MFloat *pValue;
}AA_FLOAT_GROUP;




typedef struct __tagAA_SBC_INIT_PARAM
{
	MTChar szAudioFile[AMVE_MAXPATH];
	MBool	bRepeatAudio;
	AMVE_POSITION_RANGE_TYPE AudioRange;
	MDWord dwDstAudioLength;	

	MDWord dwTimeStep;//时间的步进，暂时没用
}AA_SBC_INIT_PARAM;

typedef struct __tagAA_ProcessCB_Data
{
	MInt32 totalTimeLen;
	MInt32 curTimePos;
    MInt32 TimeSpan;
	
	MInt32 status;
	MInt32 err;

    MInt32 targetIndex;
}AA_ProcessCB_Data;


typedef struct tagAnaTargetType
{
	int nTargetIndex;
   	int nTargetType;  //频率，音量
}AnaTargetType;


#endif	//endif ET_AUDIO_ANALYSIS_COMDEF_H





