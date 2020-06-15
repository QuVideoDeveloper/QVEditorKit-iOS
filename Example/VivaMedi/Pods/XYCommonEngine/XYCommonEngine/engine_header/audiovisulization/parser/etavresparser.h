#ifndef ET_AUDIO_ANALYSIS_PARSER_H
#define ET_AUDIO_ANALYSIS_PARSER_H

#include "amvedef.h"
#include "etavcomdef.h"
#include "cJSON.h"
#include "etaudioanalysisinternaldef.h"
#include "etaudioanalysiscomdef.h"

// 负责把结果数据从文件解析成结构。每个target都以下面的方式存储
// main_head : 开始的pos, len ，is repeat，音频可视化模板ID（确认target一致）   ---------公用参数，APP可能发生调整的
// target :
//         target_head:index,结果目标类型(音量还是频谱),输出类型（用来确定DATA里的结构），步长(目前一个模板中的Target的步长一样)            ----------Target参数，模板里面写死的
//         target_data:一个个数据（如果json能放二进制就能文件Seek了，暂时还是全部读进内存（暂时不会太大，要是后面真的不能完整读进内存，就单独搞个文件，这边就存个路径），时间计算根据顺序）。

class CQVETAATarget;

typedef struct __tagTargetDataContainer
{
	MInt32 nTargetIndex;
	MInt32 nDataIndex;
	MDWord dwRealType;
	MVoid * pOutData;  //从base64解析出的数据值
	MInt32 nOutRealLen;   //解析输出的数据长度

	MVoid * stAARes;   //将解析出的内存数据组合成的AAResult,目前仅支持flat和flatGroup。最终结果目前就这两种
}TargetDataContainer;

class CQVETAAParser
{
public:
	CQVETAAParser();
	~CQVETAAParser();

	MBool SetParseFile(const MTChar * szPath);

	MBool SetParseData(const MTChar * szBuf);

	MBool GetMainHead(AA_PARSER_HEAD & stHead);  //仅仅解析出头部参数

	MInt32 GetTargetNum();
	//不存在的时候返回-1
	MInt32 GetTargetDataNum(MInt32 nTargetIndex);

	MBool GetTargetHead(AA_PROCEDURE_TARGET & targetInfo, MDWord & dwResType, MInt32 nTargetIndex);
	//根据target的index，以及数据的位置，获取FinalData
	MBool GetTargetData(TargetDataContainer & ct);
	MVoid FreeTargetData(TargetDataContainer & ct);

private:
	cJSON * m_pParserJson;
};

#endif