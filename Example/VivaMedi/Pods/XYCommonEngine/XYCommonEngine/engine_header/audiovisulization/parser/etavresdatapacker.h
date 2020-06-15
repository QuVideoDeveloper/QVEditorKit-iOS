#ifndef ET_AUDIO_ANALYSIS_PACKER_H
#define ET_AUDIO_ANALYSIS_PACKER_H

#include "amvedef.h"
#include "cJSON.h"
#include "etavcomdef.h"
#include "etaudioanalysisinternaldef.h"
#include "etaudioanalysiscomdef.h"

class CQVETAATarget;

class CQVETAADataPacker
{
public:
	CQVETAADataPacker();
	~CQVETAADataPacker();

	//写入的文件路径
	void SetFilePath(const MTChar * szPath);

	MBool SetMainHead(const AA_PARSER_HEAD * pHead);

	MBool AddTargetHead(const AA_PROCEDURE_TARGET * pTarget, MInt32 nIndex);

	MBool AddTargetData(MInt32 nTargetIndex, const MVoid * pData, MDWord dwRealType);

	MBool WriteToFile();
	

private:
	cJSON * m_pPackerJson;
	MTChar m_szFilePath[AMVE_MAXPATH];
};

#endif