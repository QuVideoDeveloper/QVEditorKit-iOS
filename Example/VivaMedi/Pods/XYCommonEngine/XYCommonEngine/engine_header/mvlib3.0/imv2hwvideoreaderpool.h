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
 * ivevideoreader.h
 *
 *
 * History
 *    
 * 2009-07-14 
 * - Init version
 * Code Review
 *
 */

#ifndef __IMV2_HW_VIDEO_READER_POOL_H_
#define __IMV2_HW_VIDEO_READER_POOL_H_

class IMV2VideoReader;

typedef MDWord (*PFNGETMAXHWDECOUNTCALLBACK) (MHandle hSessionContext,MDWord dwVideoType,MSIZE* pSize,MBool bInterlace);
typedef MBool (*PFNGETHWENCCAPCALLBACK) (MHandle hSessionContext,MDWord dwVideoType,MSIZE* pSize);


typedef struct _tag_VideoReaderParam
{
    MVoid* pSplitter;
	MTChar* pszFileName;
	MDWord dwUseCodecType;
	MHandle hGLContext;
	MHandle hSurfaceTexture;
	MBool bForPlay;
	MBool bDownScale;
	MSIZE exportSize;
	MBool bFrameMode; //是否是画中画视频贴纸模式
}VIDEOREADERPARAM;


class IMV2HWVideoReaderPool
{ 
OVERLOAD_OPERATOR_NEW	
public: 
	IMV2HWVideoReaderPool(){}
	 
	virtual ~IMV2HWVideoReaderPool(){}

	virtual IMV2VideoReader* GetHWDecoderInstance(VIDEOREADERPARAM* pVideoReaderParam,MBool* pbHWException)=0;
	virtual MRESULT CloseHWDecoderInstance(IMV2VideoReader* pReader)=0;	
	virtual MBool  CheckIsValidate(IMV2VideoReader* pVideoReader,VIDEOREADERPARAM* pVideoReaderParam)=0;
	virtual MVoid EnableHWDecoder()=0;
	virtual MVoid DisableHWDecoder()=0;
	virtual MRESULT Flush()=0;
	//bOnlyUsed表示只统计正在使用的reader
	virtual MRESULT GetCount(MLong* plCount,MBool bOnlyUsed)=0;


	virtual MRESULT Flush(MHandle hGLContext) = 0;

	virtual MBool IsTextureUsedByHWDecoder(MHandle hTexture) = 0;

	virtual MRESULT RegisgerQueryCapCallBack(PFNGETMAXHWDECOUNTCALLBACK pGetMAXDecCountCbk,MVoid* pUserData) = 0;

	virtual MVoid SetJNIHelper(MHandle hJNIHelper) = 0;

    /*
	* 功能：
	*	将reader设置为Free状态
	* 参数：
	*	In pReader,需要设置为free状态的reader
	*返回值:
	*     成功返回MVLIB_ERR_NONE,否则返回错误码
	*/
	virtual MRESULT SetDecoderInstanceAsFree(IMV2VideoReader* pReader) = 0;

   /*
	* 功能：
	*	释放闲置不用的reader
	* 参数：
	*	In hGLContext,当前的opengl context
	*   In pszFileName,将要创建的reader对应的file name,如果有可以复用的，会保留
	*返回值:
	*     成功返回MVLIB_ERR_NONE,否则返回错误码
	*/
	virtual MRESULT ReleaseFreeInstance(MHandle hGLContext,MVoid* pszFileName) = 0;
}; 

#endif // __IMV2_HW_VIDEO_READER_POOL_H_

