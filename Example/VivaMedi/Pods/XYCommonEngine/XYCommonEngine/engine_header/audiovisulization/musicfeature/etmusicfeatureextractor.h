#ifndef ETMUSICFEATUREEXTRACTOR_H
#define ETMUSICFEATUREEXTRACTOR_H


#include "amvedef.h"
#include "qvasp.h"


class CMThread;
class CMusicFeatureDescriptor;
class IMV2MediaOutputStream;
class CVEAudioEditorEngine;
class CMusicFeatureExtractor : public CMThread
{
public:
	CMusicFeatureExtractor();
	virtual ~CMusicFeatureExtractor();


public:
	MRESULT init(MFE_PARAM *param);	
	MVoid    uninit();	

	MRESULT start();
	MRESULT pause();
	MRESULT resume();	
	MRESULT stop();




	MRESULT refine(); //not used, designed for future feature


protected:
    virtual MDWord Run();	


private:
	MBool	 canNotCarryOn(){ return m_lastRunErr ? MTrue : MFalse;}
	MRESULT startThread();
	MRESULT	 stopThread();



	MDWord   getNextAction();
	MRESULT doProcess();	//如果有SD，要先做SD	
	MRESULT doPause();
	MRESULT doStop();
	MVoid    doCallback(MDWord timeProcessed, MDWord status, MRESULT err);



	MRESULT processSDBGM();


    MRESULT checkMFEParam(MV2AUDIOINFO srcAudioInfo, MFE_PARAM *param);
	MRESULT prepareWorkBuf();
	MRESULT prepareDetector(MDWord feature);	//????????????看一下函数实现??????????????????????
	MRESULT duplicateMFEParam(MFE_PARAM *src, MFE_PARAM *dst);
	MVoid    freeMFEParam(MFE_PARAM *param);

private:
	MFE_PARAM mParam;      //!release


	MHandle mOD; //onset detector     //!release
	MHandle mVD; //volumn detector     //!release
	MHandle mSD; //sing detector
//	MHandle mTD; //tempo detector


	IMV2MediaOutputStream *mAudioStream;         //!release,    init函数里，要最先创建，因为要取audioinfo，后面要用
	CVEAudioEditorEngine     *mResampler;         //!release
	AUDIO_SAMPLE_INFO mOriginalAudioInfo;
	AUDIO_SAMPLE_INFO mProcessAudioInfo;	//mProcessAudioInfo 完全有可能与mOriginalAudioInfo一样
	MV2AUDIOINFO m_srcInfo;  //only for convenienct
	MV2AUDIOINFO m_dstInfo;//only for convenienct， 完全有可能与m_srcInfo一样


	MBool mIsBGMDone; //for sing detection
	MDWord mAudioReadLen; //ms
	MBool mIsDataEnd;


	//for thread mode
	CMEvent	 m_StatusUpdatedEvent;
	MDWord m_requiredStatus;
	MDWord m_curStatus;
	MBool 	m_bStarted;
	
	MRESULT m_lastRunErr;


	//有关Buf的创建流程，参见SingDetector
	ASP_SAMPLE_BUF_B mBuf4Dec;	     //!release
	ASP_SAMPLE_BUF_B mBuf4Asp;       //!release
	
};




#endif




