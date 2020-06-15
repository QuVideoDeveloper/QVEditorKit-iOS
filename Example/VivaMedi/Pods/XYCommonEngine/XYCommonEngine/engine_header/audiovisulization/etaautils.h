#ifndef ETAA_UTILS_H
#define ETAA_UTILS_H


class CQVETAAUtils
{
private:
	CQVETAAUtils(){}
	~CQVETAAUtils(){}

public:
	static MRESULT GetPCMTimeSpan(MV2AUDIOINFO *pAudioInfo, MDWord dwBytes, MFloat *pfTimeSpan/*millisecond*/);
	static MRESULT GetPCMBytes(MV2AUDIOINFO *pAudioInfo, MDWord dwTimeSpan, MFloat *pfBytes, MBool *pbHasDecimal = MNull);

};




#endif
