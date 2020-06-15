         /*----------------------------------------------------------------------------------------------
*
* This file is ArcSoft's property. It contains ArcSoft's trade secret, proprietary and 		
* confidential information. 
* 
* The information and code contained in this file is only for authorized ArcSoft employees 
* to design, create, modify, or review.
* 
* DO NOT DISTRIBUTE, DO NOT DUPLICATE OR TRANSMIT IN ANY FORM WITHOUT PROPER AUTHORIZATION.
* 
* If you are not an intended recipient of this file, you must not copy, distribute, modify, 
* or take any action in reliance on it. 
* 
* If you have received this file in error, please immediately notify ArcSoft and 
* permanently delete the original and any copy of any file and any printout thereof.
*
*-------------------------------------------------------------------------------------------------*/
/*
 * iveaudioreader.h
 *
 *
 * History
 *    
 * 2009-07-14 
 * - Init version
 * Code Review
 *
 */

#ifndef _IVE_AUDIO_READER_H_
#define _IVE_AUDIO_READER_H_

class IMV2Spliter;

class IMV2AudioReader
{ 
OVERLOAD_OPERATOR_NEW	
public: 
	IMV2AudioReader() { m_pSpliter = MNull; }
	 
	virtual ~IMV2AudioReader(){}
	 
	virtual MRESULT Open(IMV2Spliter* pSplitter)=0; 
 
	virtual MRESULT Close()=0; 

	virtual MRESULT Reset()=0; 

	virtual MRESULT GetAudioInfo(LPMV2AUDIOINFO lpAudioInfo)=0;

	virtual MRESULT ReadAudioFrame(MByte * pFrameBuf, MLong lBufSize, MLong * plReadSize,\
								   MDWord* pdwCurrentTimestamp, MDWord * pdwTimeSpan)=0; 

	virtual MRESULT SeekAudio(MDWord * pdwSeekTime)=0;

	virtual MRESULT SetConfig(MDWord dwCfgType, MVoid * pValue)=0;

	virtual MRESULT GetConfig(MDWord dwCfgType, MVoid * pValue)=0;

protected:
	IMV2Spliter* m_pSpliter; 
}; 

#endif // _IVE_AUDIO_READER_H_