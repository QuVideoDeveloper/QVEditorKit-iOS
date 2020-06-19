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
* imv2videowriter.h
*
*
* History
*2012-03-14 Initial version yfeng    
*
*
*/
#ifndef _IMV2_VIDOE_WRITER_H_
#define _IMV2_VIDOE_WRITER_H_

class IMV2VideoWriter
{
    OVERLOAD_OPERATOR_NEW	
public: 
    IMV2VideoWriter(){}

    virtual ~IMV2VideoWriter(){}

    /********************************************************************
    Function:
    Init,Init the video writer,allocate node
    Parameter:
    Input:
    pInFormat:input format
    
    Output:
    None
    Return value:
    MERR_NONE:If init successfully
    Other:If  init fail
    *********************************************************************/
    virtual MRESULT Init(TRANSCODER_VIDEOFORMAT* pInFormat) = 0;

    /********************************************************************
    Function:
    Open,start the video writer,allocate hardware resource
    Parameter:
    Input:
    None

    Output:
    None
    Return value:
    MERR_NONE:If open successfully
    Other:If  open fail
    *********************************************************************/
    virtual MRESULT Open() = 0;

    /********************************************************************
    Function:
    Close,close the video writer,release hardware resource
    Parameter:
    Input:
    None

    Output:
    None
    Return value:
    None
    *********************************************************************/
    virtual MVoid Close() = 0;


    /********************************************************************
    Function:
    DeInit,deinit the video writer,release node
    Parameter:
    Input:
    None

    Output:
    None
    Return value:
    None
    *********************************************************************/
    virtual MVoid DeInit() = 0;

    /********************************************************************
    Function:
    Reset,reset the video writer,flush in/out port data
    Parameter:
    Input:
    None

    Output:
    None
    Return value:
    MERR_NONE:If reset successfully
    Other:If  reset fail
    *********************************************************************/
    virtual  MRESULT Reset() = 0;

    /********************************************************************
    Function:
    SetConfig,setParam to the video writer
    Parameter:
    Input:
    dwCfgType:Configuration index
    pValue:Config value

    Output:
    None
    Return value:
    MERR_NONE:If set successfully
    Other:If  set fail
    *********************************************************************/
    virtual MRESULT SetConfig(MDWord dwCfgType, MVoid* pValue) = 0;

    /********************************************************************
    Function:
    GetConfig,getParam from the video writer
    Parameter:
    Input:
    dwCfgType:Configuration index
    pValue:Config value

    Output:
    pValue:Config value
    Return value:
    MERR_NONE:If get successfully
    Other:If  get fail
    *********************************************************************/
    virtual MRESULT GetConfig(MDWord dwCfgType, MVoid* pValue) = 0;

    /********************************************************************
    Function:
    SetInputFormat,set input format to the video writer
    Parameter:
    Input:
    pInFormat:Input format

    Output:
    None
    Return value:
    MERR_NONE:If set successfully
    Other:If  set fail
    *********************************************************************/
    virtual MRESULT SetInputFormat(TRANSCODER_VIDEOFORMAT* pInFormat) = 0;

    
    /********************************************************************
    Function:
    ReadVideoFrame,read video frame from the video writer
    Parameter:
    Input:
    lBufSize:Frame buffer size

    Output:
    pFrameBuf:Frame buffer
    pFrameInfo:Frame info
    pdwCurrentTimestamp:frame time stamp
    pdwTimeSpan:frame time span
	pbIsSyncFrame:whether is a key frame

    Return value:
    MERR_NONE:If read successfully
    Other:If  read fail
    *********************************************************************/
    virtual MRESULT ReadVideoFrame(MByte* pFrameBuf, MLong lBufSize, LPMV2FRAMEINFO pFrameInfo,\
        MDWord* pdwCurrentTimestamp, MDWord* pdwTimeSpan,MBool* pbIsSyncFrame = MNull) = 0;


    /********************************************************************
    Function:
    RegisterReadVideoFrameCallback,register read yuv data callback to the video writer
    Parameter:
    Input:
    pCallback:Read video frame callback
    pObj:Callback user data
  
    Output:
    None
    Return value:
    MERR_NONE:If register successfully
    Other:If  register fail
    *********************************************************************/
    virtual MRESULT RegisterReadVideoFrameCallback(PFNREADVIDEOFRAMECALLBACK pCallback,MVoid * pObj) = 0;

    /********************************************************************
    Function:
    QueryCapbility,query whether hw encoder supported
    Parameter:
    Input:
    None

    Output:
    None
    Return value:
    MTrue:If support
    MFalse:If  not support
    *********************************************************************/
    virtual MBool QueryCapbility() = 0;

    /********************************************************************
    Function:
    ProcStart,start pulll data thread
    Parameter:
    Input:
    None

    Output:
    None
    Return value:
    MERR_NONE:If start success
    Other:If  start fail
    *********************************************************************/
    virtual MRESULT ProcStart() = 0;

	/********************************************************************
    Function:
    SeekVideo,seek video
    Parameter:
    Input:
    pdwSeekTime:seek video time stamp

    Output:
    pdwSeekTime:seek video time stamp

    Return value:
    MERR_NONE:If write input data successfully
    Other:If write input data fail
    *********************************************************************/
    virtual MRESULT SeekVideo(MDWord* pdwSeekTime) = 0; 
};
#endif