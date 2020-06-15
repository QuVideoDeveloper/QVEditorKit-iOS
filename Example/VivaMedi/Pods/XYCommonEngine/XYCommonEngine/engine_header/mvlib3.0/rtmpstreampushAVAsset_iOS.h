/*
 
 Video Core
 Copyright (c) 2014 James G. Hurley
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

/*
 *  iOS::RTMPStreamPush transform :: Takes a CVPixelBufferRef input and outputs H264 NAL Units.
 *
 *
 */

#ifndef __RTMPStreamPushAVASSET_H__
#define __RTMPStreamPushAVASSET_H__

#include <iostream>
//using namespace std;
#include "imv2rtmpstreampushiOS.h"

#define MV3_STREAM_PUSH_CFG_BASE     0x00000000
#define MV3_STREAM_PUSH_CFG_MUTE     (MV3_STREAM_PUSH_CFG_BASE + 1)
#define MV3_STREAM_PUSH_CFG_FLIP     (MV3_STREAM_PUSH_CFG_BASE + 2)
#define MV3_STREAM_PUSH_CFG_FRAME_RATE     (MV3_STREAM_PUSH_CFG_BASE + 3)




class RTMPStreamPushAVAsset : public IMV2RTMPStreamPush
{
public:
    RTMPStreamPushAVAsset();
    ~RTMPStreamPushAVAsset();
    
    MRESULT Create();
    
    // Input is expecting a CVPixelBufferRef
    MRESULT PushVideoBuffer(CMSampleBufferRef VideoFrame);       // 将摄像头采集数据写入文件，并调用 rtmpmuxer->DumpMuxer; 数据入队列；
    MRESULT PrepareExportStuff(MHandle hGLContext, CMSampleBufferRef VideoFrame, MHandle *hExpTx);       // 获取纹理
    

    MRESULT SendVideoFrame(MBool bLoop, MDWord dwID);

    MRESULT SetConfig(MDWord dwCfgType,MVoid* pValue);
    
    MRESULT GetConfig(MDWord dwCfgType,MVoid* pValue);
    
    
private:
    MRESULT SetupWriter(MDWord writer);
    MRESULT SwapWriters(MBool force = MFalse);
    MVoid   TeardownWriter(MDWord writer);
    MVoid   ExtractSpsAndPps(MDWord writer);
    
private:
    AVAssetWriter                           *m_assetWriters[2];
    AVAssetWriterInputPixelBufferAdaptor    *m_pAssetWriterIPBAdaptor[2];
    CVPixelBufferRef                         m_ExportSharedDstPB[2]; //This pixel buf is get from AV-Foundatation-pool and used by RE and AV-Foundation export
    AVAssetWriterInput                      *m_pAssetWriterVI[2];
    MDWord                                   m_dwVideoFrameCoded[2];
    MDWord                                   m_dwVideoFrameSend[2];

	
    
    
  
    CMPtrArray             m_VTimeList[2];
    CMMutex                m_VTimeMutex;
    
    MChar                 *m_tmpFile[2];
    
    MLong                  m_dwLastFilePos[2];
    
    CMEvent               *m_pSendFinishedEvent[2];
    CMEvent               *m_pAVAssetCreatedEvent[2];
    
    
    
    MBool                  m_bCurFileSend;
    
    
    MDWord                 m_dwFrameNumPerFile;
    

    MBool                  m_bCurrentWriter;
    MBool                  m_bAVSessionStarted[2];
};
#endif /* defined(__RTMPStreamPush__) */
