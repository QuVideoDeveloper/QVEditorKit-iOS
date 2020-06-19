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

#ifndef __IMV2RTMPSTREAMPUSH_H_
#define __IMV2RTMPSTREAMPUSH_H_

#include <iostream>
#import <AudioToolbox/AudioConverter.h>
//using namespace std;

#define DUMP_SEND_VIDEO 0

#if (DUMP_SEND_VIDEO == 1)
MDWord  m_gStartLen = 4;
MByte   m_gStartCode[] = "\0\0\0\1";
#endif

#define MV3_STREAM_PUSH_CFG_BASE			0x00000000
#define MV3_STREAM_PUSH_CFG_MUTE			(MV3_STREAM_PUSH_CFG_BASE + 1)
#define MV3_STREAM_PUSH_CFG_FLIP			(MV3_STREAM_PUSH_CFG_BASE + 2)
#define MV3_STREAM_PUSH_CFG_FRAME_RATE		(MV3_STREAM_PUSH_CFG_BASE + 3)
#define MV3_STREAM_PUSH_CFG_BACK_GROUND		(MV3_STREAM_PUSH_CFG_BASE + 4)
#define MV3_STREAM_PUSH_CFG_ENC_BPS			(MV3_STREAM_PUSH_CFG_BASE + 5)

#define STREAM_PUSH_BACK_GROUND_NULL    0
#define STREAM_PUSH_BACK_GROUND         1
#define STREAM_PUSH_FORE_GROUND         2



#define BIT_PER_FRAME           (450000 / 20)

typedef struct _ParaSet
{
    MByte     *data;
    MDWord     size;
} ParaSet;

typedef struct _RTMPMetadata_1       // CQD.?????? 此处与 rtmpmuxer.h 中 _RTMPMetadata 是同一定义，后面考虑放到同一文件中；
{
    // video, must be h264 type
    MDWord    nSPSLen;
    MByte    *SPS;
    MDWord    nPPSLen;
    MByte    *PPS;
} RTMPMetadata_1, *LPRTMPMetadata_1;


class IMV2RTMPStreamPush
{
public:
    IMV2RTMPStreamPush();
    virtual ~IMV2RTMPStreamPush();
    
    MRESULT Init(MDWord dwPCMSampleRate, MDWord dwPCMChannels,
                 MBool bHasAudio, MDWord dwVideoBitrate, MDWord frame_w,
                 MDWord frame_h,MDWord dwRotation,
                 MDWord fps,
                 const MChar *pFileName);
    MRESULT Uninit();
    
    MRESULT ProcessingAudioDataAsync(CMSampleBufferRef samplebuffer);           // 处理音频
    MRESULT CreateAudioConverter();
    
    virtual MRESULT Create() = 0;
    virtual MRESULT PushVideoBuffer(CMSampleBufferRef VideoFrame) = 0;       // 将摄像头采集数据写入文件，并调用 rtmpmuxer->DumpMuxer; 数据入队列；
    virtual MRESULT PrepareExportStuff(MHandle hGLContext, CMSampleBufferRef VideoFrame, MHandle *hExpTx) = 0;       // 获取纹理
    virtual MRESULT SetConfig(MDWord dwCfgType,MVoid* pValue) = 0;
    virtual MRESULT GetConfig(MDWord dwCfgType,MVoid* pValue) = 0;
	
   
public:
    IMV2Muxer             *m_pRtmpMuxer;
    MHandle                m_hExpTx;
    MHandle                m_hTargetTx;
    MDWord                 m_dwFrameW;
    MDWord                 m_dwFrameH;
    MDWord                 m_dwRotation;
    MDWord                 m_dwFrameRate;
    MBool                  m_bStarted;
    MDWord                 m_dwVideoStartTime;
    MBool                  m_bVideoParameterSet;
    MHandle                m_hGLContext;
    MBool                  m_bMute;
    MBool                  m_bFlipFlag;
    
    ParaSet                m_sps;
    ParaSet                m_pps;
    
    RTMPMetadata_1         m_metadata;
    MDWord                 m_dwVideoBitrate;
    
#if (DUMP_SEND_VIDEO == 1)
    MBool                  m_bWriteSPSPPS;
    MHandle                m_hVideoFile;
#endif
    volatile MBool         m_bRTMPSendFail;
    MBool                  m_bBackgroundToForeground;
    MInt64                 m_dwAudioPauseDurationTotal;
    
private:
    
    MV2VIDEOINFO           m_videoInfo;
    MV2AUDIOINFO           m_audioInfo;

    // 音频
    MByte                 *m_pAudioPCMBuf;
    MByte                 *m_pAudioAACBuf;
    
    MDWord                 m_dwAudioPCMBufSize;    
    MDWord                 m_dwAudioAACBufSize;

    AudioConverterRef      m_audioConverter;
    
    MInt64                 m_llPCMEncodeSampleTotal;
    MDWord                 m_dwPCMSampleRate;
    MDWord                 m_dwPCMChannels;
    
    MDWord                 m_dwOutPCMChannels;
    MDWord                 m_dwBitsPerChannel;
    MDWord                 m_dwAudioBitrate;
    
    MDWord                 m_dwOutputPacketMaxSize;
    MDWord                 m_dwBytesPerSample;
    
    MByte                 *m_pCachedPCMData;
    MDWord                 m_dwBytesRemain;
    MDWord                 m_dwPCMEncodeSize;
    MInt64                 m_dwAudioLastTimeStamp;
    MInt64                 m_dwAudioLastDur;
    
};
#endif /* defined(__IMV2RTMPStreamPush__) */
