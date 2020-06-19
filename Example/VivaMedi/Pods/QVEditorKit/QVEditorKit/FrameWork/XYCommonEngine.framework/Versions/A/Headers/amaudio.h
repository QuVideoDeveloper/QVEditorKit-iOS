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
*---------------------------------------------------------------------------------------------*/


#ifndef __AMAUDIO_H__
#define __AMAUDIO_H__

#include "amcomdef.h"
#include "merror.h"


#define MAUDIO_FORMAT_PCM					0x00000001
#define MAUDIO_FORMAT_AMR					0x00000002
#define MAUDIO_FORMAT_QCELP					0x00000004

#define MAUDIO_CHANNEL_MONO					0x00000001
#define MAUDIO_CHANNEL_STERO				0x00000002

#define MAUDIO_SAMPLERATE_8000				0x00000001
#define MAUDIO_SAMPLERATE_11025				0x00000002
#define MAUDIO_SAMPLERATE_12000				0x00000004
#define MAUDIO_SAMPLERATE_16000				0x00000008
#define MAUDIO_SAMPLERATE_22050				0x00000010
#define MAUDIO_SAMPLERATE_24000				0x00000020
#define MAUDIO_SAMPLERATE_32000				0x00000040
#define MAUDIO_SAMPLERATE_36000				0x00000080
#define MAUDIO_SAMPLERATE_44100				0x00000100
#define MAUDIO_SAMPLERATE_48000				0x00000200

#define MAUDIO_BITPERSAMPLE_8				0x00000001
#define MAUDIO_BITPERSAMPLE_16				0x00000002

	
typedef struct __tag_maudio_param
{			
	MDWord	dwFormatType;
	MDWord	dwChannel;
	MDWord	dwBitsPerSample;
	MDWord	dwBlockAlign;
	MDWord	dwSamplingRate;
} MAUDIOPARAM;


typedef enum __tag_maudio_status
{
    MAOPENED,
	MAPLAYING,
	MARECORDING,
	MAPAUSED,
	MASTOPPED,
	MACLOSED,
	MADIED
} MAUDIOSTATUS;


#ifdef __cplusplus
extern "C" {
#endif


typedef MVoid (*MAUDIOPLAYDONECB)(MVoid* pUserData);
MHandle MAudioFileInit(MVoid* szAudioFile, MAUDIOPLAYDONECB pfnAudioPlayDoneCB, MVoid* pUserData);
MRESULT MAudioFileUninit(MHandle hAudio);
MRESULT MAudioFilePlay(MHandle hAudio);
MRESULT MAudioFilePause(MHandle hAudio);
MRESULT MAudioFileStop(MHandle hAudio);
MRESULT MAudioFileSetVolume(MHandle hAudio, MLong lVolume);
MRESULT MAudioFileGetVolume(MHandle hAudio, MLong* plVolume);


typedef MRESULT (* MFNAUDIOCALLBACK)(MByte* pAudioDataBuffer, MLong* lAudioDataLen, MAUDIOSTATUS status, MVoid* pParam);


MRESULT MAudioOutQueryInfo(MAUDIOPARAM* pAudioParam);
MHandle MAudioOutInitialize(MAUDIOPARAM* pAudioParam, MDWord dwBufLen, MFNAUDIOCALLBACK fnAudioCallback, MVoid* pParam);
MRESULT MAudioOutUninitialize(MHandle hAudio);
MRESULT MAudioOutPlay(MHandle hAudio);
MRESULT MAudioOutPause(MHandle hAudio);
MRESULT MAudioOutStop(MHandle hAudio);
MRESULT MAudioOutGetPosition(MHandle hAudio, MDWord * pdwPosition);
MRESULT MAudioOutSetVolume(MHandle hAudio, MLong lVolume);
MRESULT MAudioOutGetVolume(MHandle hAudio, MLong* plVolume);


MRESULT MAudioInQueryInfo(MAUDIOPARAM* pAudioParam);
MHandle MAudioInInitialize(MAUDIOPARAM* pAudioParam, MDWord dwBufLen, MFNAUDIOCALLBACK fnAudioCallback, MVoid* pParam);
MRESULT MAudioInUninitialize(MHandle hAudio);
MRESULT MAudioInRecord(MHandle hAudio);
MRESULT MAudioInPause(MHandle hAudio);
MRESULT MAudioInStop(MHandle hAudio);
MRESULT MAudioInGetConfig(MHandle hAudio, MDWord dwCfgType, MVoid* pValue, MDWord dwValueSize);
MRESULT MAudioInSetConfig(MHandle hAudio, MDWord dwCfgType, MVoid* pValue, MDWord dwValueSize);


#ifdef __cplusplus
  }
#endif

#endif

