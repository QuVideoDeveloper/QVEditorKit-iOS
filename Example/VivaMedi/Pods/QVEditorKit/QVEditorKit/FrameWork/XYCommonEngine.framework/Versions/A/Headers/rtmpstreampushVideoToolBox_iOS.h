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

#ifndef __RTMPSTREAMPUSH_VIDEOTOOLBOX_H__
#define __RTMPSTREAMPUSH_VIDEOTOOLBOX_H__

#include <iostream>
//using namespace std;
#include "imv2rtmpstreampushiOS.h"

#include "QVStatistic.h"
#include "QVFPSStatistic.h"

#define MV3_STREAM_PUSH_CFG_BASE     0x00000000
#define MV3_STREAM_PUSH_CFG_MUTE     (MV3_STREAM_PUSH_CFG_BASE + 1)
#define MV3_STREAM_PUSH_CFG_FLIP     (MV3_STREAM_PUSH_CFG_BASE + 2)
#define MV3_STREAM_PUSH_CFG_FRAME_RATE     (MV3_STREAM_PUSH_CFG_BASE + 3)



class RTMPStreamPushVideoToolBox : public IMV2RTMPStreamPush
{
public:
    RTMPStreamPushVideoToolBox();
    ~RTMPStreamPushVideoToolBox();
    
    MRESULT Create();
    
    // Input is expecting a CVPixelBufferRef
    MRESULT PushVideoBuffer(CMSampleBufferRef VideoFrame);       // 将摄像头采集数据写入文件，并调用 rtmpmuxer->DumpMuxer; 数据入队列；
    MRESULT PrepareExportStuff(MHandle hGLContext, CMSampleBufferRef VideoFrame, MHandle *hExpTx);       // 获取纹理
    
    MRESULT SetConfig(MDWord dwCfgType,MVoid* pValue);
    
    MRESULT GetConfig(MDWord dwCfgType,MVoid* pValue);
    
    MRESULT TeardownCompressionSession();
    
private:
      
private:    
    CMMutex                m_encodeMutex;
    void*                  m_pCompressionSession;
	CVPixelBufferRef       m_ExportSharedDstPB; //This pixel buf is get from AV-Foundatation-pool and used by RE and AV-Foundation export
    MDWord                 m_dwBackgroundStatus;
    QVStatistic*        m_pRtmpStat;
    QVFPSStatistic      m_camFPS;
  

};
#endif /* defined(__RTMPStreamPush__) */
