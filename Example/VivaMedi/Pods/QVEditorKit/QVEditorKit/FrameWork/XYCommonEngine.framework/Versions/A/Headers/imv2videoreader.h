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
 * imv2videoreader.h
 *
 *
 * History
 *    
 * 2011-09-14 
 * - Init version
 * Code Review
 *
 */

#ifndef _IMV2_VIDEO_READER_H_
#define _IMV2_VIDEO_READER_H_
class IMV2Spliter;



class IMV2VideoReader
{ 
OVERLOAD_OPERATOR_NEW	
public: 
	IMV2VideoReader(){}
	 
	virtual ~IMV2VideoReader(){}
	 
	virtual MRESULT Open(IMV2Spliter* pSplitter)=0; 

    virtual MRESULT Close()=0; 

	virtual MRESULT Init(IMV2Spliter* pSplitter,MTChar* pszFileName = MNull)=0;

	virtual MRESULT DeInit()=0;  

	virtual MRESULT Reset()=0; 

	virtual MRESULT GetVideoInfo(LPMV2VIDEOINFO lpVideoInfo)=0;

	virtual MRESULT ReadVideoFrame(MByte* pFrameBuf, MLong lBufSize, LPMV2FRAMEINFO pFrameInfo,\
									MDWord* pdwCurrentTimestamp, MDWord* pdwTimeSpan)=0;  

    virtual MRESULT ReadVideoFrame(MByte** ppFrameBuf, MLong lBufSize, LPMV2FRAMEINFO pFrameInfo,\
                                   MDWord* pdwCurrentTimestamp, MDWord* pdwTimeSpan)=0;   

	virtual MRESULT SeekVideo(MDWord* pdwSeekTime)=0;

	virtual MRESULT SetConfig(MDWord dwCfgType, MVoid* pValue)=0;

	virtual MRESULT GetConfig(MDWord dwCfgType, MVoid* pValue)=0;

	virtual MRESULT SetPostProcess(MVoid* pPP) = 0;

	virtual IMV2Spliter* GetSplitter()=0;

	virtual MRESULT ResetDecoder(MTChar* pszFileName)=0;

	virtual MRESULT Pause()=0;

    virtual MBool QueryCapbility() = 0;

//Add for video transcoder
    virtual MRESULT Init(TRANSCODER_VIDEOFORMAT* pInFormat) = 0;

    virtual MRESULT Open() = 0;

    virtual MRESULT SetInputFormat(TRANSCODER_VIDEOFORMAT* pInFormat) = 0;

    virtual MRESULT RegisterReadVideoFrameCallback(PFNREADVIDEOFRAMECALLBACK pCallback,MVoid * pObj) = 0;

}; 

#endif // _IVE_VIDEO_READER_H_
