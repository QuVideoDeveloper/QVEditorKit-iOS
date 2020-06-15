#ifndef  QVSINGDETECTOR_H
#define  QVSINGDETECTOR_H


#include "amvedef.h"
#include "qvasp.h"

class CMThread;
class IMV2MediaOutputStream;
class CVEAudioEditorEngine;



/*
 *	QVSingDetector
 *		it's an envelope of asp's sing detector which involves in thread.
 */
class QVSingDetector : public CMThread
{
public:
	QVSingDetector();
	virtual ~QVSingDetector();


	MRESULT init(QVET_SD_PARAM *param);
	MVoid	 uninit();

	MRESULT start();
	MRESULT pause();
	MRESULT resume();	
	MRESULT stop();

protected:
    virtual MDWord Run();

private:
	MBool	 canNotCarryOn(){ return m_lastRunErr ? MTrue : MFalse;}
	MRESULT startThread();
	MRESULT	 stopThread();

	MDWord   getNextAction();
	MRESULT doProcess();
	MRESULT doPause();
	MRESULT doStop();

	MVoid   doCallback(MDWord timeProcessed,
						MDWord status, MRESULT err, ASP_SAD_RESULT *result);


private:
    MRESULT CheckParam(MV2AUDIOINFO srcAudioInfo, QVET_SD_PARAM *param);
	MRESULT DuplicateSDParam(QVET_SD_PARAM *src, QVET_SD_PARAM *dst);
	MRESULT PrepareAspAndWorkBuf();
	MRESULT ProcessBGM();

	MRESULT PrepareASPSampleBuf(ASP_SAMPLE_BUF_S *p, MDWord capacity);
	MVoid   FreeASPSampleBuf(ASP_SAMPLE_BUF_S *p, MBool bFreeStruct = MFalse);

private:
	QVET_SD_PARAM		mParam;

	IMV2MediaOutputStream *mStream;
	CVEAudioEditorEngine     *mResampler;
	MHandle mhAsp;
	AUDIO_SAMPLE_INFO mOriginalAudioInfo;
	AUDIO_SAMPLE_INFO mProcessAudioInfo;
	MV2AUDIOINFO m_srcInfo;  //only for convenienct
	MV2AUDIOINFO m_dstInfo;//only for convenienct
	
	MBool mIsBGMDone;
	MDWord mAudioReadLen; //ms
	MBool mIsEnd;


	//for thread mode
	CMEvent	 m_StatusUpdatedEvent;
	MDWord m_requiredStatus;
	MDWord m_curStatus;
	MBool 	m_bStarted;
	
	MRESULT m_lastRunErr;


	ASP_SAMPLE_BUF_B mBuf4Dec;	//for decoding, after decoding there may need to be resampled
	ASP_SAMPLE_BUF_B mBuf4Asp;	


	//for benchmark
	MDWord mDbgStep1TC;
	MDWord mDbgStep2TC;	
	MDWord mDbgStepCnt;

	MDWord mDbgThreadAndCBTC; //CB = callback
	MDWord mDbgThreadAndCBTS; //CB = callback
	MDWord mDbgThreadAndCBCnt; //CB = callback

	MDWord mDbgBGMProcessTC;
};




#endif //endif of QVSINGDETECTOR_H





