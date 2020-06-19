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
 * mv2config.h
 *
 * Description:
 *
 *	The configuration type definition in MVLIB2.0
 *
 *
 * History
 *    
 *  07.29.2004 Sheng Han(shan@arcsoft.com.cn )   
 * - initial version 
 *
 */

 #ifndef _MV2CONFIG_H_
 #define _MV2CONFIG_H_



///////////////configuration type ID for common usage /////////

#define MV2_CFG_COMMON_BASE				0x00000000
#define MV2_CFG_COMMON_END				0x00ffffff
#define MV2_CFG_COMMON_BASE_EX			0x00800000		//added by cfchen for MVLIB2.5Ex version



/*=====================================
ID:
	MV2_CFG_COMMON_ROTATE
	
Descrpition:
	for frame rotate

Value type:
	MDWord*
Note:
	the valid values are  MV2_ROTATE_0,MV2_ROTATE_90,MV2_ROTATE_180, MV2_ROTATE_270
=======================================*/
#define MV2_CFG_COMMON_ROTATE			(MV2_CFG_COMMON_BASE+1)		

/*=====================================
ID:
	MV2_CFG_COMMON_PMU_ENABLE
	
Descrpition:
	to enable/disable pmu

Value type:
	MBool*
Note:
	MTrue to enable pmu, MFalse to disable it(defaultly enable)
=======================================*/
#define MV2_CFG_COMMON_PMU_ENABLE		(MV2_CFG_COMMON_BASE+2)	

/*=====================================
ID:
	MV2_CFG_COMMON_PREPROCESS
	
Descrpition:
	for set preprocess information

Value type:
	MV2PREPROCESSINFO*
Note:
=======================================*/

#define MV2_CFG_COMMON_PREPROCESS			(MV2_CFG_COMMON_BASE+3)					

/*=====================================
ID:
	MV2_CFG_SCREEN_MODE
	
Descrpition:
	for set current screen mode

Value type:
	MLong*
Note:
=======================================*/
#define MV2_CFG_ORIENTATION_MODE 		     (MV2_CFG_COMMON_BASE+4)

/*=====================================
ID:
	MV2_CFG_COMMON_SEEK_MODE
	
Descrpition:
	for set seek mode

Value type:
	MLong*
Note:
=======================================*/
#define MV2_CFG_COMMON_SEEK_MODE 		        (MV2_CFG_COMMON_BASE+5)
/*=====================================
ID:
	MV2_CFG_COMMON_SHAREDMEM
	
Descrpition:
	for set shared memory mode

Value type:
	LPMV2SHAREDBUFF*
Note:
=======================================*/

#define MV2_CFG_COMMON_SHAREDMEM		(MV2_CFG_COMMON_BASE+6)

/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_EDITOR_VOLUME
	
Descrpition:
	for Set/Get Digital Volume

Value type:
	MLong*
Note:
=======================================*/

#define MV2_CFG_COMMON_AUDIO_EDITOR_VOLUME		(MV2_CFG_COMMON_BASE+7)

/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_EDITOR_FADE
	
Descrpition:
	Audio Fade in /out

Value type:
	LPMV2AUDIOFADE
Note:
=======================================*/

#define MV2_CFG_COMMON_AUDIO_EDITOR_FADE			(MV2_CFG_COMMON_BASE+8)


/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_EDITOR_CHANNEL
	
Descrpition:
	control the Audio Channels 

Value type:
	MLong*
Note:
=======================================*/
#define MV2_CFG_COMMON_AUDIO_EDITOR_CHANNEL		(MV2_CFG_COMMON_BASE+9)


/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_EDITOR_AUTO_NORMALIZE
	
Descrpition:
	Open or Close the AutoNormalize Switch

Value type:
	MBool*
Note:
=======================================*/
#define MV2_CFG_COMMON_AUDIO_EDITOR_AUTO_NORMALIZE		(MV2_CFG_COMMON_BASE+10)

/*=====================================
ID:
	MV2_CFG_COMMON_ASF_HEADEROBJECT
	
Descrpition:
	get or set the asf header object

Value type:
	MByte*
Note:
=======================================*/

#define MV2_CFG_COMMON_ASF_HEADEROBJECT		(MV2_CFG_COMMON_BASE+11)

/*=====================================
ID:
	MV2_CFG_COMMON_AUDIOOUT_SWITHCH
	
Descrpition:
	to switch the audio output device during playback

Value type:
	MLong*
Note:
=======================================*/

#define MV2_CFG_COMMON_AUDIOOUT_SWITHCH		(MV2_CFG_COMMON_BASE+12)


/*=====================================
ID:
	MV2_CFG_COMMON_SELECT_DEVICE
	
Descrpition:
	select device to render

Value type:
	MDWord*,about device ID define ,refer to mv2comdef.h
Note:
=======================================*/
#define MV2_CFG_COMMON_SELECT_DEVICE		(MV2_CFG_COMMON_BASE+13)

/*=====================================
ID:
	MV2_CFG_COMMON_BENCHMARK_RESULT
	
Descrpition:
	retrieve mvlib benchmark result

Value type:
	MV2BENCHMARKRESULT*,refer to mv2comdef.h
Note:
=======================================*/
#define MV2_CFG_COMMON_BENCHMARK_RESULT		(MV2_CFG_COMMON_BASE+14)


/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_MODE
	
Description:
	Multi-thread:	MV2_CFG_AUDIO_MODE_MULTITHREAD
		The PlayerThread own the audio thread.
	Single-thread:	MV2_CFG_AUDIO_MODE_NORMAL
		Application which create the Player own the audio component(not thread). All resource
		for audio is create and close by process.
Value type:
	MDWord*
Note:
=======================================*/
#define MV2_CFG_COMMON_AUDIO_MODE		(MV2_CFG_COMMON_BASE+15)

/*=====================================
ID:
	MV2_CFG_COMMON_AUDIOSPECDATA
	
Descrpition:
	 Get audio specific information and data
Value type:
	MV2SPECFICINFO * ; 
Note:
    for set and get
    =======================================*/
#define MV2_CFG_COMMON_AUDIOSPECDATA		(MV2_CFG_COMMON_BASE+16)


/*=====================================
ID:
	MV2_CFG_COMMON_VIDEOSPECDATA
	
Descrpition:
	 Get video specific information and data
Value type:
	MV2SPECFICDATA * ; 
Note:
    for set and get
    =======================================*/
#define MV2_CFG_COMMON_VIDEOSPECDATA		(MV2_CFG_COMMON_BASE+17)


/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_EQPARAM
	
Descrpition:
	 to set or get EQ param ,now only support by mp3/aac
Value type:
	MV2EQPARAM * ; 
Note:
    for set and get
    =======================================*/
#define MV2_CFG_COMMON_AUDIO_EQPARAM		(MV2_CFG_COMMON_BASE+18)

/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_EQSPECTRUM
	
Descrpition:
	 to get the spectrum value from audio decoder(now only support mp3/aac) when 
	 decode data with EQ disposal 
Value type:
	MV2EQSPECTRUM * ; 
Note:
    for get
    =======================================*/
#define MV2_CFG_COMMON_AUDIO_EQSPECTRUM		(MV2_CFG_COMMON_BASE+19)

/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_EQ_ENABLE
	
Descrpition:
	 to enable or disable EQ function
Value type:
	MBool* ; 
Note:
    for set
    =======================================*/
#define MV2_CFG_COMMON_AUDIO_EQ_ENABLE		(MV2_CFG_COMMON_BASE+20)


/*=====================================
ID:
	MV2_CFG_COMMON_CLOCK
	
Descrpition:
	 For get/set the timemgr manager.
Value type:
	MHANDLE; 
Note:
    for set
    =======================================*/
#define MV2_CFG_COMMON_CLOCK						(MV2_CFG_COMMON_BASE+21)


/*=====================================
 next item defined for MVLIB2.5Ex version
=====================================*/


/*=====================================
ID:
	MV2_CFG_COMMON_AUDIODEVICE_RESET
	
Descrpition:
	 to enable or disable EQ function
Value type:
	MBool* ; 
Note:
    for set
    =======================================*/
#define MV2_CFG_COMMON_AUDIODEVICE_RESET		(MV2_CFG_COMMON_BASE+22)
#define MV2_CFG_AUDIO_EFFECT					(MV2_CFG_COMMON_BASE+23)


#define MV2_CFG_AUDIO_REFRESH_HANDLE        (MV2_CFG_COMMON_BASE+24)


//Add for VP
/*=====================================
ID:
MV2_CFG_COMMON_FRAMETIMEINFO

Descrpition:
to set frame timestamp to decoder and retain from it
as sometime the decoder may buffer several out-of-order frames
Value type:
MV2_FRAME_TIMEINFO* ; 
Note:
for set/get
=======================================*/
#define MV2_CFG_COMMON_FRAMETIMEINFO        (MV2_CFG_COMMON_BASE+25)



#define MV2_CFG_AUDIO_TIME_STAMP				(MV2_CFG_COMMON_BASE+26)


#define MV2_CFG_AUDIO_INPUT_PCM_SRCFILE		(MV2_CFG_COMMON_BASE+27)

#define MV2_CFG_COMMON_BE_RTMP				(MV2_CFG_COMMON_BASE+28)
 
#define MV2_CFG_COMMON_FLIP_STATE           (MV2_CFG_COMMON_BASE+29)

#define MV2_CFG_COMMON_MUXER           		(MV2_CFG_COMMON_BASE+30)

#define MV2_CFG_I_FRAME_INTERVAL_TIME		(MV2_CFG_COMMON_BASE+31)


/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_BUFFER_SIZE
	
Descrpition:
	 to set/get audio buffer size
Value type:
	MDWord* ; 
Note:
    for set/get
=======================================*/
#define MV2_CFG_COMMON_AUDIO_BUFFER_SIZE		(MV2_CFG_COMMON_BASE_EX + 1)

/*=====================================
ID:
	MV2_CFG_COMMON_ASYNCCODEC_CALLBACK
	
Descrpition:
	 to set async codec callback parameter
Value type:
	MV2CFGASYNCCODECCBPARAM* ; 
Note:
    for set
=======================================*/
#define MV2_CFG_COMMON_ASYNCCODEC_CALLBACK		(MV2_CFG_COMMON_BASE_EX + 2)


/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_HW_CODEC
	
Descripition:
	MV2MediaOutputStream:set flag whether supported audio hardware codec,MBool*
	audioout:get flag whether supported audio hardware codec, [in/out]
						for input: (MDWord*)&dwCodecType,do device suporte the codec?
						for output: return supported result, (MBool*)
Value type:
	
Note:
    for get/set 
=======================================*/
#define MV2_CFG_COMMON_AUDIO_HW_CODEC			(MV2_CFG_COMMON_BASE_EX + 3)

/*=====================================
ID:
	MV2_CFG_COMMON_VIDEO_HW_CODEC
	
Descripition:
	MV2MediaOutputStream:set flag whether supported audio hardware codec,MBool*
	display:get flag whether supported audio hardware codec, [in/out]
						for input: (MDWord*)&dwCodecType,do device suporte the codec?
						for output: return supported result, (MBool*)
Value type:
	MBool
Note:
    for get/set 
=======================================*/
#define MV2_CFG_COMMON_VIDEO_HW_CODEC			(MV2_CFG_COMMON_BASE_EX + 4)


/*=====================================
ID:
	MV2_CFG_COMMON_ASYNC_AUDIO_CODEC_INPUT_FRAMES
	
Descripition:
	for get flag,get the numbers that we can get output after input how mush frames
Value type:
	MDWord*
Note:
    for get
=======================================*/
#define MV2_CFG_COMMON_ASYNC_CODEC_INPUT_FRAMES_AUDIO	(MV2_CFG_COMMON_BASE_EX + 5)

/*=====================================
ID:
	MV2_CFG_COMMON_ASYNC_AUDIO_CODEC_INPUT_FRAMES
	
Descripition:
	for get flag,get the numbers that we can get output after input how mush frames
Value type:
	MDWord*
Note:
    for get
=======================================*/
#define MV2_CFG_COMMON_ASYNC_CODEC_INPUT_FRAMES_VIDEO	(MV2_CFG_COMMON_BASE_EX + 6)

/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_CODEC_PROC_FLAG
	
Descripition:
	only for Gethumbnail(),video codec is decoding?
Value type:
	MBool*
Note:
    set/get,only for async codec
=======================================*/
#define MV2_CFG_COMMON_AUDIO_CODEC_PROC_FLAG	(MV2_CFG_COMMON_BASE_EX + 7)


/*=====================================
ID:
	MV2_CFG_COMMON_VIDEO_CODEC_PROC_FLAG
	
Descripition:
	only for Gethumbnail(),video codec is decoding?
Value type:
	MBool*
Note:
    set/get,only for async codec
=======================================*/
#define MV2_CFG_COMMON_VIDEO_CODEC_PROC_FLAG	(MV2_CFG_COMMON_BASE_EX + 8)


/*=====================================
ID:
	MV2_CFG_COMMON_AUDIO_CODEC_TYPE
	
Descripition:
	get audio codec type
Value type:
	MDWord*
Note:
    only get audio codec type(in file level) from mediaoutstream
=======================================*/
#define MV2_CFG_COMMON_AUDIO_CODEC_TYPE		(MV2_CFG_COMMON_BASE_EX + 9)

/*=====================================
ID:
	MV2_CFG_COMMON_VIDEO_CODEC_TYPE
	
Descripition:
	get video codec type
Value type:
	MDWord*
Note:
    only get video codec type from mediaoutstream
=======================================*/
#define MV2_CFG_COMMON_VIDEO_CODEC_TYPE		(MV2_CFG_COMMON_BASE_EX + 10)

/*=====================================
ID:
	MV2_CFG_COMMON_OEM_PARAM
	
Descrpition:
	 set oem display param.we can use this ID to setting oem parameter
Value type:
	MV2_OEM_PARAM* ; 
Note:
    for set
=======================================*/
#define MV2_CFG_COMMON_OEM_PARAM				(MV2_CFG_COMMON_BASE_EX + 11)


/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_LOAD_CODEC
	
Descrpition:
	 set this ID to enable load codec flag and load codec
Value type:
	MBool* ; 
Note:
    for set
=======================================*/
#define MV2_CFG_MEDIASTREAM_LOAD_CODEC				(MV2_CFG_COMMON_BASE_EX + 12)


////////////configuration type ID for player //////////////////

#define MV2_CFG_PLAYER_BASE				0x01000000
#define MV2_CFG_PLAYER_END				0x01ffffff
	

/*=====================================
ID:
	MV2_CFG_PLAYER_STARTPOS
	
Descrpition:
	the start position for playback in ms

Value type:
	MDWord*			
=======================================*/
#define MV2_CFG_PLAYER_STARTPOS			(MV2_CFG_PLAYER_BASE+2)		

/*=====================================
ID:
	MV2_CFG_PLAYER_ENDPOS
	
Descrpition:
	the end position for playback in ms, 

Value type:
	MDWord*

Note:
	(~0) means playing to the actually end of clip
=======================================*/
#define MV2_CFG_PLAYER_ENDPOS			(MV2_CFG_PLAYER_BASE+3)		


/*=====================================
ID:
	MV2_CFG_PLAYER_MODE
	
Descrpition:
	the player mode, now support normal , manual and fast forward mode 

Value type:
	LPMV2PLAYERMODE

Note:
=======================================*/
#define MV2_CFG_PLAYER_MODE				(MV2_CFG_PLAYER_BASE+4)	

/*=====================================
ID:
	MV2_CFG_PLAYER_SEEK_AUDIO_FIRST
	
Descrpition:
	the player seek mode. Defaultly MTrue, the result of seekaudio is used as the input of seekvideo.

Value type:
	MBool *

Note:
=======================================*/
#define MV2_CFG_PLAYER_SEEK_AUDIO_FIRST	(MV2_CFG_PLAYER_BASE+5)

/*=====================================
ID:
	MV2_CFG_PLAYER_DISABLE_OPTION
	
Descrpition:
	disable video/audio/text items in the clip.

Value type:
	MDWord*

Note:
	the valid value should base on macro of player disable option defined in mv2comdef.h
=======================================*/
#define MV2_CFG_PLAYER_DISABLE_OPTION	(MV2_CFG_PLAYER_BASE+8)	

/*=====================================
ID:
	MV2_CFG_PLAYER_AUDIODEVICE
	
Descrpition:
	get/set audio output device handle

Value type:
	MDWord*

Note:
	the valid value should base on macro of player disable option defined in mv2comdef.h
=======================================*/

#define MV2_CFG_PLAYER_AUDIODEVICE		(MV2_CFG_PLAYER_BASE+9)	

/*=====================================
ID:
	MV2_CFG_PLAYER_HTTPINFO
	
Descrpition:
	for get http donwload info, only for palm os

Value type:
	MV2HTTPCALLBACKDATA*

Note:
	the valid value should base on macro of player disable option defined in mv2comdef.h
=======================================*/

#define MV2_CFG_PLAYER_HTTPINFO			(MV2_CFG_PLAYER_BASE+10)
	
/*=====================================
ID:
	MV2_CFG_PLAYER_LOOPTIMES
	
Descrpition:
	to set the player playing loopback times  

Value type:
	MDWord *

Note:
	value = 0xFFFFFFFF:the player loopback playing infinite times,until user call
			  AMV_Player_Stop to stop the loopback playing 
		 > 0 : player lopback playing times
		 = 0 : invalid value
=======================================*/

#define MV2_CFG_PLAYER_LOOPTIMES			(MV2_CFG_PLAYER_BASE+11)

/*=====================================
ID:
	MV2_CFG_PLAYER_AUDIO_DEVICE_ERROR
	
Descrpition:
	get/set audio output device error

Value type:
	MLong*

Note:
	audio device error 
=======================================*/

#define MV2_CFG_PLAYER_AUDIO_DEVICE_ERROR		(MV2_CFG_PLAYER_BASE+12)

/*=====================================
ID:
	MV2_CFG_PLAYER_AUDIO_DEVICE_RESET
	
Descrpition:
	set audio output device RESET flag

Value type:
	MNull
Note:
	
=======================================*/

#define MV2_CFG_PLAYER_AUDIO_DEVICE_RESET		(MV2_CFG_PLAYER_BASE+13)

/*=====================================
ID:
	MV2_CFG_PLAYER_ENABLE_FRAMECALLBACK
	
Descrpition:
	Enable/disable the frame callback which is called when every video frame is decoded, only for brew IMediaTotal

Value type:
	MBool 
Note:
	
=======================================*/

#define MV2_CFG_PLAYER_ENABLE_FRAMECALLBACK		(MV2_CFG_PLAYER_BASE+14)


/*=====================================
ID:
	MV2_CFG_LOG_CONFIGURE
	
Descrpition:
	set the configuration of logger. Turn ON/OFF Logger on run time.

Value type:
	MV2LOGCONFIG *
Note:
	
=======================================*/
#define	MV2_CFG_LOG_CONFIGURE					(MV2_CFG_PLAYER_BASE+15)

/*=====================================
ID:
	MV2_CFG_PLAYER_ASYNC_INIT
	
Descrpition:
	Query the init proc is async or sync.

Value type:
	MBool 
Note:
	
=======================================*/
#define MV2_CFG_PLAYER_ASYNC_INIT				(MV2_CFG_PLAYER_BASE+16)

/*=====================================
ID:
	MV2_CFG_PLAYER_INIT_END
	
Descrpition:
	Query the init proc is end.

Value type:
	MBool 
Note:
	
=======================================*/
#define MV2_CFG_PLAYER_INIT_END					(MV2_CFG_PLAYER_BASE+17)

/*=====================================
ID:
	MV2_CFG_PLAYER_SET_OUTPUTSTREAM
	
Descrpition:
	Set outputstream and player.

Value type:
	MNull
Note:
	
=======================================*/
#define MV2_CFG_PLAYER_SET_OUTPUTSTREAM		(MV2_CFG_PLAYER_BASE+18)

/*=====================================
ID:
	MV2_CFG_SPECTRUM_CALLBACK
	
Description:
	set the callback function. app get the spectrum.

Value type:
	MLong *
Note:
	
=======================================*/
#define	MV2_CFG_SPECTRUM_CALLBACK					(MV2_CFG_PLAYER_BASE+19)

#define	MV2_CFG_SPECTRUM_NUMBER						(MV2_CFG_PLAYER_BASE+20)

/*=====================================
ID:
MV2_CFG_PLAY_FORCE_STOP

Description:
for the play state == Opened, we can't stop it as usually

Value type:

Note:

=======================================*/
#define	MV2_CFG_PLAY_FORCE_STOP				(MV2_CFG_PLAYER_BASE+21)

/*=====================================
ID:
MV2_CFG_PLAYER_SET_HIGH_PRIORITY

Description:
set the thread priority of player engine

Value type:
MBool

Note:
for set only, MFalse by default
=======================================*/
#define	MV2_CFG_PLAYER_SET_HIGH_PRIORITY   (MV2_CFG_PLAYER_BASE+22)

/*=====================================
ID:
MV2_CFG_PLAYER_SET_EXTERNAL_DISPLAY

Description:
Set a callback function to retrieve output video frames for rendering, bypassing the internal display module

Value type:
PFNMV2VIDEODATACALLBACK

Note:
for set only, MNull by default
=======================================*/
#define	MV2_CFG_PLAYER_SET_EXTERNAL_DISPLAY   (MV2_CFG_PLAYER_BASE+23)

#define MV2_CFG_PLUGINMGR_HDL	(MV2_CFG_PLAYER_BASE+24)

#define MV2_CFG_PLAYER_CODEC_MODE	         (MV2_CFG_PLAYER_BASE + 25 )

#define MV2_CFG_PLAYER_AUDIO_PLAYED_TIMESTAMP		(MV2_CFG_PLAYER_BASE + 26 ) //audio设备实际播放过的时间戳，[0, duration]

#define MV2_CFG_PLAYER_DISCONNECT_STREAM		(MV2_CFG_PLAYER_BASE + 27)

/*=====================================
ID:
MV2_CFG_PLAYER_GIF_MODE

Descrpition:
the player GIF mode, Is Set Gif Preview Fps

Value type:
	AMVE_PLAYGIFFPS_5, AMVE_PLAYGIFFPS_10, AMVE_PLAYGIFFPS_15

Note:
=======================================*/
#define MV2_CFG_PLAYER_PREVIEW_FPS				(MV2_CFG_PLAYER_BASE+28)	

#define MV2_CFG_PLAYER_VIDEO_PLAYED_TIMESTAMP   (MV2_CFG_PLAYER_BASE+29)


#define MV2_CFG_PLAYER_CALLBACK_DELTA    (MV2_CFG_PLAYER_BASE + 30)



///////////configuration type ID for recorder //////////////////

#define MV2_CFG_RECORDER_BASE				0x02000000
#define MV2_CFG_RECORDER_END				0x02ffffff

/*=====================================
ID:
	MV2_CFG_RECORDER_PREVIEW
	
Descrpition:
	For preview parameter config

Value type:
	LPMV2PREVIEWPARAM
Note:
	It MUST be set before preview on  for some camera device 
=======================================*/
#define MV2_CFG_RECORDER_PREVIEW		(MV2_CFG_RECORDER_BASE+1)

/*=====================================
ID:
	MV2_CFG_RECORDER_MAXCLIPSIZE
	
Descrpition:
	For max clip size config for recorder

Value type:
	MDWord*
Note:
	unit is byte
=======================================*/
#define MV2_CFG_RECORDER_MAXCLIPSIZE			(MV2_CFG_RECORDER_BASE+2)

/*=====================================
ID:
	MV2_CFG_RECORDER_CAPTURE_AUDIO
	
Descrpition:
	set/get whether audio is (to be) captured

Value type:
	MBool*

Note:
	temporarily turn on/off audio device without affect clipinfo, 
	currently for POS (or other rt applications) only
=======================================*/
#define MV2_CFG_RECORDER_CAPTURE_AUDIO			(MV2_CFG_RECORDER_BASE+3)
#define MV2_CFG_RECORDER_CAPTURE_VIDEO			(MV2_CFG_RECORDER_BASE+4)

/*=====================================
ID:
	MV2_CFG_RECORDER_AUDIO_MUTE
	
Descrpition:
	to set audio mute or not during recodering

Value type:
	MBool*

=======================================*/
#define MV2_CFG_RECORDER_AUDIO_MUTE				(MV2_CFG_RECORDER_BASE+5)


/*
*	MV2_CFG_RECORDER_SECTION_FIRST_FRAME_TIMESTAMP
*		表示start 或是 resume后成功capture到的第一帧 time stamp
*/
#define MV2_CFG_RECORDER_SECTION_FIRST_FRAME_TIMESTAMP	(MV2_CFG_RECORDER_BASE+6)

/*
 *	MV2_CFG_RECORDER_PCM_FILE_SRC
 *		表示录制的文件中的音频来自其他audiofile, 而非audiodevice
 *   Value type:
 *		MTChar*
 */
//#define MV2_CFG_RECORDER_PCM_FILE_SRC	(MV2_CFG_RECORDER_BASE+7)

#define MV2_CFG_RECORDER_DUBBING_INFO	(MV2_CFG_RECORDER_BASE+8)

#define MV2_CFG_RECORDER_CE_FPS_ADAPTER	(MV2_CFG_RECORDER_BASE+9)

#define MV2_CFG_RECORDER_CE_BE_RTMP		(MV2_CFG_RECORDER_BASE+10)

#define MV2_CFG_RECORDER_CE_TIME_STAMP	(MV2_CFG_RECORDER_BASE+11)


//////////configuration type ID for media stream//////////////

#define MV2_CFG_MEDIASTREAM_BASE			0x03000000
#define MV2_CFG_MEDIASTREAM_END			0x04ffffff

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_FRAMEINFO
	
Descrpition:
	for set/get frame info for a media stream 
Value type:
	LPMV2FRAMEINFO
Note:
    
    =======================================*/
#define MV2_CFG_MEDIASTREAM_FRAMEINFO       (MV2_CFG_MEDIASTREAM_BASE+1)



/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_COLORSPACE
	
Descrpition:
	for get color space from a media stream 
Value type:
	MDWord * 
Note:
    only for get 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_COLORSPACE       (MV2_CFG_MEDIASTREAM_BASE+2)


/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_AUDIOFRAMESIZE
	
Descrpition:
	for get audio frame size for minimum buffer size allocation
Value type:
	MLong * 
Note:
    only for get 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_AUDIOFRAMESIZE       (MV2_CFG_MEDIASTREAM_BASE+3)


/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_VIDEOFRAMESIZE
	
Descrpition:
	for get video frame size for minimum buffer size allocation
Value type:
	MLong * 
Note:
    only for get 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_VIDEOFRAMESIZE       (MV2_CFG_MEDIASTREAM_BASE+4)

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_CLIPINFO
	
Descrpition:
	for getting clip info
Value type:
	LPMV2CLIPINFO
Note:
    only for get from mediainputstream
    =======================================*/
#define MV2_CFG_MEDIASTREAM_CLIPINFO		(MV2_CFG_MEDIASTREAM_BASE+5)

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_AUDIOINFO
	
Descrpition:
	for getting audio info
Value type:
	LPMV2AUDIOINFO 
Note:
    only for get from mediainputstream 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_AUDIOINFO		(MV2_CFG_MEDIASTREAM_BASE+6)

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_RECORDEDSIZE
	
Descrpition:
	get recorded size as recorder callback data
Value type:
	MDWord * 
Note:
    only for get from cmv2mediainputstream 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_RECORDEDSIZE	(MV2_CFG_MEDIASTREAM_BASE+7)

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_CALLBACK
	
Descrpition:
	Set callback function for MV2MediaOutputStream
Value type:
	MDWord* 
Note:
    only for set 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_CALLBACK        (MV2_CFG_MEDIASTREAM_BASE + 8)

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_LOAD_FOR_PLAY
	
Descripition:
	Set flag to notify the media stream whether need create the decoder instance.
Value type:
	MBool
Note:
    only for set 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_LOAD_FOR_PLAY       (MV2_CFG_MEDIASTREAM_BASE + 9)

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_SPLITER_TYPE
	
Descripition:
	for get spliter type
Value type:
	MDWord
Note:
    only for get 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_SPLITER_TYPE       (MV2_CFG_MEDIASTREAM_BASE + 10)

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_IS_OPENED
	
Descripition:
	for get whether the spliter type has been parsered
Value type:
	MBool
Note:
    only for get 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_IS_OPENED			(MV2_CFG_MEDIASTREAM_BASE + 11)

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_CODECERRSET
	
Descripition:
	for get the error set, which point either audio or video codec is invalid.
Value type:
	MDWord
Note:
    only for get 
   Codec Error Set for LoadDecoder.
	0x00000000000000AV		
	if A is set, Audio codec is unavailable;
	if V is set, Video codec is unavailable.
    =======================================*/
#define MV2_CFG_MEDIASTREAM_CODECERRSET			(MV2_CFG_MEDIASTREAM_BASE + 12)


/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_NEEDINTERNALPAUSE
	
Descripition:
    Tell the player whether need internal pause for transition data prepare
Value type:
	MBool
Note:
    only for get 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_NEEDINTERNALPAUSE			(MV2_CFG_MEDIASTREAM_BASE + 13)


/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_RENDER_VIEWPORT
	
Descrpition:
	for get the view port of stream render.
Value type:
	MRECT
Note:
    only for set 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_RENDER_VIEWPORT			(MV2_CFG_MEDIASTREAM_BASE + 14)


/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_UNINIT_RENDER_ENGINE
	
Descrpition:
	This config will order the stream to do the un-initialization of render engine.
	For now, we are using OpenGL to achieve the rendering. and the OpenGL is encapsulated into "QVET render engine" 
	In SessionCore, The "Stream" sticks to the render engine because of data-flow,
	so we put the render engine in the stream
Value type:
	MNull
Note:
    only for set 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_UNINIT_RENDER_ENGINE			(MV2_CFG_MEDIASTREAM_BASE + 15)

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_SHOW_LAYER
	
Description:
    Tell the player show or hide one layer
Value type:
	MV2_SHOWLAYER_PARAM
Note:
    only for set 
    =======================================*/
//#define MV2_CFG_MEDIASTREAM_SHOW_LAYER						(MV2_CFG_MEDIASTREAM_BASE + 16)


/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_REFRESH_STREAM
	
Description:
    Tell the player the stream will be refresh.
Value type:
	MV2_REFRESH_EFFECT_PARAM
Note:
    only for set 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_REFRESH_STREAM					(MV2_CFG_MEDIASTREAM_BASE + 17)

/*=====================================
ID:
	MV2_CFG_MEDIASTREAM_UPDATE_RENDER_ENGINE
	
Description:
    Tell the player the render engine will be updated.
Value type:
	MV2DISPLAYPARAM
Note:
    only for set 
    =======================================*/
#define MV2_CFG_MEDIASTREAM_UPDATE_RENDER_ENGINE			(MV2_CFG_MEDIASTREAM_BASE + 18)

/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_SET_DISPLAYFBO
 
 Description:
 Tell the renderengine create display fbo
 Value type:
 MBool
 Note:
 only for set
 =======================================*/
#define MV2_CFG_MEDIASTREAM_SET_DISPLAYFBO                  (MV2_CFG_MEDIASTREAM_BASE + 19)

/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_THUMBNAIL_MODE
 
 Description:
 Set mediaoutputstream enter thumbnail mode
 Value type:
 MBool
 Note:
 only for set
 =======================================*/
#define MV2_CFG_MEDIASTREAM_THUMBNAIL_MODE                  (MV2_CFG_MEDIASTREAM_BASE + 20)


/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_PLAY_PAUSE
 
 Description:
 Add for surface texture output stream,set the mediaplayer statue to play/pause
 Value type:
 MBool
 Note:
 only for set
 =======================================*/

#define MV2_CFG_MEDIASTREAM_PLAY_PAUSE                      (MV2_CFG_MEDIASTREAM_BASE + 21)


/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_GLCONTEXT
 
 Description:
 Add for set opengl context
 Value type:
 MHandle
 Note:
 only for set
 =======================================*/

#define MV2_CFG_MEDIASTREAM_GLCONTEXT                       (MV2_CFG_MEDIASTREAM_BASE + 22)



/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_NOREADTARGETDATA
 
 Description:
 Add for set do not read texture target data flag
 Value type:
 MBool
 Note:
 only for set
 =======================================*/

#define MV2_CFG_MEDIASTREAM_NOREADTARGETDATA                (MV2_CFG_MEDIASTREAM_BASE + 23)

/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_SURFACETEXTURE_HANDLE
 
 Description:
 Add for set surfacetexture handle
 Value type:
 MHandle
 Note:
 only for set
 =======================================*/

#define MV2_CFG_MEDIASTREAM_SURFACETEXTURE_HANDLE           (MV2_CFG_MEDIASTREAM_BASE + 24)  


/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_SOURCE_INFO
 
 Description:
 Add for get video source info
 Value type:
 MV2VIDEOINFO
 Note:
 only for get
 =======================================*/

#define MV2_CFG_MEDIASTREAM_SOURCE_INFO                     (MV2_CFG_MEDIASTREAM_BASE + 25)  

/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_NEED_REFRESH_DATA
 
 Description:
 Set the flag for data refreshing.
 Value type:
 MBool
 Note:
 only for set
 =======================================*/

#define MV2_CFG_MEDIASTREAM_NEED_REFRESH_DATA               (MV2_CFG_MEDIASTREAM_BASE + 26)  

/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_EFFECT_SUPPORT_CROP
 
 Description:
 Set the crop flag for multiinputfilter outputstream
 Value type:
 MBool
 Note:
 only for set
 =======================================*/

#define MV2_CFG_MEDIASTREAM_EFFECT_SUPPORT_CROP             (MV2_CFG_MEDIASTREAM_BASE + 27)


/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_READONCE_FLAG
 
 Description:
 Set the read flag for sub effect stream
 Value type:
 MBool
 Note:
 only for get/set
 =======================================*/

#define MV2_CFG_MEDIASTREAM_READONCE_FLAG					(MV2_CFG_MEDIASTREAM_BASE + 28)


/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_IS_FORWARD
 
 Description:
 Set the direction for stream
 Value type:
 MBool
 Note:
 only for get/set
 =======================================*/

#define MV2_CFG_MEDIASTREAM_IS_FORWARD					(MV2_CFG_MEDIASTREAM_BASE + 29)


/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_AUDIO_ANALYZER
 
 Description:
 Set the audio analyzer for stream
 Value type:
 MVoid*
 Note:
 only for get/set
 =======================================*/

#define MV2_CFG_MEDIASTREAM_AUDIO_ANALYZER              (MV2_CFG_MEDIASTREAM_BASE + 30)


#define MV2_CFG_MEDIASTREAM_AUDIO_ANALYZER_PARAM		(MV2_CFG_MEDIASTREAM_BASE + 31)


#define MV2_CFG_MEDIASTREAM_IS_NEW_VIDEO_FRAME			(MV2_CFG_MEDIASTREAM_BASE + 32)

#define MV2_CFG_MEDIASTREAM_FILE_NAME					(MV2_CFG_MEDIASTREAM_BASE + 33)

#define MV2_CFG_MEDIASTREAM_CUR_VIDEO_TIME              (MV2_CFG_MEDIASTREAM_BASE + 34)

#define MV2_CFG_MEDIASTREAM_IS_RAWDATA_MODE				(MV2_CFG_MEDIASTREAM_BASE + 35)

/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_REVERSE_HWENC
 
 Description:
  倒序导出硬件编码模式
 Value type:
 MBool*
 Note:
 only for get/set
 =======================================*/
#define MV2_CFG_MEDIASTREAM_REVERSE_HWENC                (MV2_CFG_MEDIASTREAM_BASE + 36)

/*=====================================
 ID:
 MV2_CFG_MEDIASTREAM_VIDEO_INFO
 
 Description:
    当前video stream的video info
 Value type:
 LPMV2VIDEOINFO
 Note:
 only for get/set
 =======================================*/

#define MV2_CFG_MEDIASTREAM_VIDEO_INFO                    (MV2_CFG_MEDIASTREAM_BASE + 37)


//reopen audio in the stream, it's only for veoutputstream.cpp
#define MV2_CFG_MEDIASTREAM_REOPEN_AUDIO				(MV2_CFG_MEDIASTREAM_BASE + 38)


//get m_frameData 浅拷贝
#define MV2_CFG_MEDIASTREAM_VIDEOFRAMEDATA			       (MV2_CFG_MEDIASTREAM_BASE + 39)


//MOOV add in mp4 file's tail
#define MV2_CFG_MEDIASTREAM_NO_NETWORK                       (MV2_CFG_MEDIASTREAM_BASE + 40)

//获取下视频的旋转角度
#define MV2_CFG_MEDIASTREAM_VIDEO_ROTATE                           (MV2_CFG_MEDIASTREAM_BASE + 41)

#define MV2_CFG_MEDIASTREAM_REVERSE_MODE               (MV2_CFG_MEDIASTREAM_BASE + 42)



/////////configuration type ID for media file //////////////////
#define MV2_CFG_MEDIAFILE_BASE			0x05000000
#define MV2_CFG_MEDIAFILE_END				0x06ffffff


/*=====================================
ID:
	MV2_CFG_SPLITER_AUDIOFRAMEDURATION
	
Descrpition:
	for get one audio frame duration from a spliter
Value type:
	MDWord * 
Note:
    only for get 
    =======================================*/
#define MV2_CFG_SPLITER_AUDIOFRAMEDURATION       (MV2_CFG_MEDIAFILE_BASE+1)

/*=====================================
ID:
	MV2_CFG_SPLITER_ASME_SETPARAM
	
Descrpition:
	set parameter for ASME
Value type:
	MV2ASMEPARAM *
Note:
    NONE
    =======================================*/
#define MV2_CFG_SPLITER_ASME_SETPARAM       (MV2_CFG_MEDIAFILE_BASE + 2)

/*=====================================
ID:
	MV2_CFG_SPLITER_ASME_GETSTATISTICS
	
Descrpition:
	get play statistics data from ASME
Value type:
	MV2ASMESTATISTIC *
Note:
    NONE
    =======================================*/
#define MV2_CFG_SPLITER_ASME_GETSTATISTICS	(MV2_CFG_MEDIAFILE_BASE + 3)

/*=====================================
ID:
	MV2_CFG_SPLITER_SYNCFRAMECOUNT
	
Descrpition:
	for get sync frame total count
Value type:
	MDWord * 
Note:
    only for get 
    =======================================*/
#define MV2_CFG_SPLITER_SYNCFRAMECOUNT		(MV2_CFG_MEDIAFILE_BASE + 4)

/*=====================================
ID:
	MV2_CFG_SPLITER_BATTACHINFO
	
Descrpition:
	 Whether attach specific information in first frame
Value type:
	Bool *; 
Note:
    only for set 
    =======================================*/
#define MV2_CFG_SPLITER_BATTACHINFO			(MV2_CFG_MEDIAFILE_BASE + 6)

/*=====================================
ID:
	MV2_CFG_SPLITER_GETSPECIFICINFO
	
Descrpition:
	 Get specific information 
Value type:
	MV2SPECFICINFO * ; 
Note:
    only for set 
    =======================================*/
#define MV2_CFG_SPLITER_GETSPECIFICINFO			(MV2_CFG_MEDIAFILE_BASE + 7)


/*=====================================
ID:
	MV2_CFG_SPLITER_SETSPECIFICINFO
	
Descrpition:
	 Set specific information 
Value type:
	MV2SPECFICINFO * ; 
Note:
    only for set 
    =======================================*/
#define MV2_CFG_MUXER_SETSPECIFICINFO			(MV2_CFG_MEDIAFILE_BASE + 8)

/*=====================================
ID:
	MV2_CFG_SPLITER_SETROTATE
	
Descrpition:
	Set rotate flag(.asf && mpeg1 file support this flag)
Value type:
	MDWord* 
Note:
    only for set 
    =======================================*/
#define MV2_CFG_SPLITER_SETROTATE			(MV2_CFG_MEDIAFILE_BASE + 9)

/*=====================================
ID:
MV2_CFG_SPLITER_AACINFO

Descrpition:
Get aac codec info
Value type:
* 
Note:
only for get 
=======================================*/
#define MV2_CFG_SPLITER_GETAACINFO            (MV2_CFG_MEDIAFILE_BASE + 11)

/*=====================================
ID:
MV2_CFG_SPLITER_GETNEXTKEYTIME

Descrpition:
Get next key frame time
Value type:
* 
Note:
only for get 
=======================================*/
#define MV2_CFG_SPLITER_GETNEXTKEYTIME            (MV2_CFG_MEDIAFILE_BASE + 12)

/*=====================================
ID:
MV2_CFG_MEDIAFILE_IS_SEEKABLE

Descrpition:
Determine if the current file is seek-able
Value type:
MBool * 
Note:
only for get 
=======================================*/
#define MV2_CFG_MEDIAFILE_IS_SEEKABLE				(MV2_CFG_MEDIAFILE_BASE + 13)


/*=====================================
ID:
MV2_CFG_MEDIAFILE_TAG

Descrpition:
For getting media id tag
Value type:
MV2MEDIATAG **
Note:
only for get
all memory blocks are allocated inside spliters and are freed when Close() is called
=======================================*/
#define MV2_CFG_MEDIAFILE_TAG						(MV2_CFG_MEDIAFILE_BASE + 14)

/*=====================================
ID:
MV2_CFG_SPLITER_ASME_TRANSPORTTYPE

Descrpition:

Value type:
TransportType*
Note:

=======================================*/
#define MV2_CFG_SPLITER_ASME_TRANSPORTTYPE			(MV2_CFG_MEDIAFILE_BASE + 15)

/*=====================================
ID:
MV2_CFG_SPLITER_ASME_XNETWORKTYPE

Descrpition:

Value type:
XNetworkType*
Note:

=======================================*/
#define MV2_CFG_SPLITER_ASME_XNETWORKTYPE						(MV2_CFG_MEDIAFILE_BASE + 16)

/*====================================================
ID:
	MV2_CFG_MUXER_GETTEXTSOURCE
	
Description:
	 Get extend interface for muxer
Value type:
	CInPutTextSource ** ; 
Note:
    only for get 
=======================================================*/
#define MV2_CFG_MUXER_GETHEADINFOSIZE							(MV2_CFG_MEDIAFILE_BASE + 17)

/*====================================================
ID:
	MV2_CFG_MUXER_RTCPCALLBACK
	
Description:
	a callback from rtcp to app
Value type:
	MVoid *; 
=======================================================*/
#define MV2_CFG_MUXER_RTCPCALLBACK								(MV2_CFG_MEDIAFILE_BASE + 18)

/*====================================================
ID:
	MV2_CFG_SPLITER_BUFFERINGTIME
	
Description:
	for set http stream buffering time
Value type:
	MDWord*; 
=======================================================*/
#define MV2_CFG_SPLITER_BUFFERINGTIME							(MV2_CFG_MEDIAFILE_BASE + 19)

/*====================================================
ID:
	MV2_CFG_MUXER_AMRSAMPLETIME
	
Description:
	for set MP4 Amr audio sample time
Value type:
	MDWord*; 
=======================================================*/
#define MV2_CFG_MUXER_AMRSAMPLETIME							    (MV2_CFG_MEDIAFILE_BASE + 20)

/*====================================================
ID:
	MV2_CFG_MEDIAFILE_ONIDLE_PROC
	
Description:
	get pointer to the on-idle procedure of mediafile layer (if exist)
	to make it work by calling it periodically
Value type:
	LPMV2CALLBACK*; 
Note:
	fot get only
=======================================================*/
#define	MV2_CFG_MEDIAFILE_ONIDLE_PROC							(MV2_CFG_MEDIAFILE_BASE + 21)

/*====================================================
ID:
	MV2_CFG_MEDIAFILE_TRACKSIZE
	
Description:
	get the specified track size
Value type:
	LPMV2TRACKSIZE*; 
Note:
	fot get only
=======================================================*/
#define	MV2_CFG_MEDIAFILE_TRACKSIZE								(MV2_CFG_MEDIAFILE_BASE + 22)
/*====================================================
ID:
	MV2_CFG_SPLITER_ASME_OPTIONS
	
Description:
	set/get the ASME options
Value type:
	LPMV2ASME_OPTINOS
Note:
	None
=======================================================*/

#define MV2_CFG_SPLITER_ASME_OPTIONS							(MV2_CFG_MEDIAFILE_BASE + 23)

/*====================================================
ID:
	MV2_CFG_SPLITER_INTERNAL_AUDIO
	
Description:
	set/get the internal audio codec type
Value type:
	MDWord*
Note:
	None
=======================================================*/

#define MV2_CFG_SPLITER_INTERNAL_AUDIO							(MV2_CFG_MEDIAFILE_BASE + 24)

/*====================================================
ID:
	MV2_CFG_SPLITER_INTERNAL_VIDEO
	
Description:
	set/get the internal video codec type
Value type:
	MDWord*
Note:
	None
=======================================================*/

#define MV2_CFG_SPLITER_INTERNAL_VIDEO							(MV2_CFG_MEDIAFILE_BASE + 25)

/*====================================================
ID:
	MV2_CFG_MEDIAFILE_RTP_PARAM
	
Description:
	set the ARTP(for IMS) parameters
Value type:
	LPMV2RTPPARAM
Note:
	None
=======================================================*/

#define MV2_CFG_MEDIAFILE_RTP_PARAM								(MV2_CFG_MEDIAFILE_BASE + 26)

/*====================================================
ID:
MV2_CFG_MEDIAFILE_TEMPFILE

  Description:
  set the temp url for http download
  Value type:
  file_para *; 
  Note:
  fot set only
=======================================================*/
#define	MV2_CFG_MEDIAFILE_TEMPFILE								(MV2_CFG_MEDIAFILE_BASE + 27)

/*====================================================
ID:
MV2_CFG_MEDIAFILE_HTTPCALLBACK

  Description:
  set the http download call back
  Value type:
  LPMV2HTTPCALLBACK; 
  Note:
  fot set only
=======================================================*/
#define	MV2_CFG_MEDIAFILE_HTTPCALLBACK							(MV2_CFG_MEDIAFILE_BASE + 28)

/*====================================================
ID:
MV2_CFG_SPLITER_MULTITRACK

  Description:
	get multiple track info from spliter
  Value type:
  LPMV2MULTITRACKINFO; 
  Note:
  fot get only
=======================================================*/
#define MV2_CFG_SPLITER_MULTITRACK								(MV2_CFG_MEDIAFILE_BASE + 29)

/*====================================================
ID:
MV2_CFG_SPLITER_SELECTTRACK

  Description:
	set selected tracks to multiple track spliter
  Value type:
  LPMV2SELECTTRACK; 
  Note:
  none
=======================================================*/
#define MV2_CFG_SPLITER_SELECTTRACK								(MV2_CFG_MEDIAFILE_BASE + 30)

/*====================================================
ID:
MV2_CFG_SPLITER_AACSPECIFICINFO

  Description:
	Get AAC specific info from spliter layer
  Value type:
  MHandle; 
  Note:
  none
=======================================================*/

#define MV2_CFG_SPLITER_AACSPECIFICINFO							(MV2_CFG_MEDIAFILE_BASE + 31)

/*====================================================
ID:
MV2_CFG_CREATEANDMODIFY_TIME

  Description:
	Get and set create and modify time 
  Value type:
  MV2FILETIME; 
  Note:
  none
=======================================================*/

#define MV2_CFG_CREATEANDMODIFY_TIME							(MV2_CFG_MEDIAFILE_BASE + 32)

/*====================================================
ID:
MV2_CFG_DOCOMO_DRM

  Description:
	Set and Get Docomo drm
  Value type:
  MWord; 
  Note:
  none
=======================================================*/

#define MV2_CFG_DOCOMO_DRM										(MV2_CFG_MEDIAFILE_BASE + 33)

/*====================================================
ID:
	MV2_CFG_USERDATA

  Description:
	Set and get user data
  Value type:
  MV2USERDATA; 
  Note:
  none
=======================================================*/

#define MV2_CFG_USERDATA										(MV2_CFG_MEDIAFILE_BASE + 34)

/*====================================================
ID:
	MV2_CFG_SPLITER_ISSEEKABLE

  Description:
	Get whether the seek pos can be seeked to
  Value type:
  MDWord; 
  Note:
  none
=======================================================*/

#define MV2_CFG_SPLITER_ISSEEKABLE								(MV2_CFG_MEDIAFILE_BASE + 35)  //get whether the seek pos has been download. value is MDWord,if 0, the pos can't be seeked to.

/*====================================================
ID:
	MV2_CFG_SPLITER_SYNCSEEKTYPE

  Description:
	for setting the sync seek direction, previous or next;
  Value type:
  MDWord; 
  Note:
  none
=======================================================*/

#define MV2_CFG_SPLITER_SYNCSEEKTYPE								(MV2_CFG_MEDIAFILE_BASE + 36)  

/*====================================================
ID:
	MV2_CFG_SPLITER_TRACK_NEEDLESS

  Description:
	for set the spliter to turn on/off a track(video/audio/text),namely the 
	spliter needn't to supply this track data anymore,it is useful for stream
	source spliter
  Value type:
  MV2TRACKSTATUS *;  
  Note:
  none
=======================================================*/

#define MV2_CFG_SPLITER_TRACKSTATUS								(MV2_CFG_MEDIAFILE_BASE + 37)  

/*====================================================
ID:
	MV2_CFG_SPLITER_TRACK_NEEDLESS

  Description:
	for the sync seek direction, previous or next;
  Value type:
  MDWord; 
  Note:
  none
=======================================================*/

#define MV2_CFG_SPLITER_TRACK_TURNON								(MV2_CFG_MEDIAFILE_BASE + 38)  

/*====================================================
ID:
	MV2_CFG_SPLITER_HTTP_PROXY

  Description:
	for setting the http proxy url
  Value type:
  MV2PROXYPARAM*; 
  Note:
  none
=======================================================*/

#define MV2_CFG_SPLITER_HTTP_PROXY								(MV2_CFG_MEDIAFILE_BASE + 39) 

/*=====================================

ID:
  
	MV2_CFG_SPLITTER_NETWARE_INFO
	
Descrpition:	  
	for set netware information to socket	
Value type:		  
	MV2NETWAREINFO *
Note:
				  
=======================================*/

#define MV2_CFG_SPLITTER_NETWARE_INFO							(MV2_CFG_MEDIAFILE_BASE + 40)         

/*=====================================

ID:
  
	MV2_CFG_SPLITTER_SKIPTOFRAME
	
	
Descrpition:	  
	for skip the frames	
Value type:		  
	MDWord * position
Note:
				  
=======================================*/

#define MV2_CFG_SPLITTER_SKIPTOFRAME							(MV2_CFG_MEDIAFILE_BASE + 41) 
/*====================================================
ID:
	MV2_CFG_SPLITTER_ASME_CONVIA

  Description:
	for setting the network of connecting via
  Value type:
  MV2*; 
  Note:
  none
=======================================================*/
#define MV2_CFG_SPLITTER_ASME_CONVIA							(MV2_CFG_MEDIAFILE_BASE + 42)  

/*====================================================
ID:
	MV2_CFG_SPLITTER_ASME_LOGGER

  Description:
	For switching the logger of ASME Module.
  Value type:
  MDWord*; 
  Note:
	MV2_ASMELOG_LEVEL_NONE etc
=======================================================*/
#define MV2_CFG_SPLITTER_ASME_LOGGER							(MV2_CFG_MEDIAFILE_BASE + 43)  

/*====================================================
ID:
	MV2_CFG_SPLITER_ASME_PORT
	
Description:
	set the ASME video and audio port
Value type:
	LPMV2ASMEPORT
Note:
	None
=======================================================*/

#define MV2_CFG_SPLITER_ASME_PORT								(MV2_CFG_MEDIAFILE_BASE + 44)

/*====================================================
ID:
	MV2_CFG_SPLITER_ASME_USERAGENT
	
Description:
	set the ASME user agent
Value type:
	MTChar*
Note:
	None
=======================================================*/

#define MV2_CFG_SPLITER_ASME_USERAGENT								(MV2_CFG_MEDIAFILE_BASE + 45)

/*====================================================
ID:
	MV2_CFG_SPLITER_ASME_LOG_PATH
	
Description:
	set the ASME Logger path
Value type:
	MTChar*
Note:
	None
=======================================================*/

#define MV2_CFG_SPLITER_ASME_LOG_PATH								(MV2_CFG_MEDIAFILE_BASE + 46)

/*====================================================
ID:
	MV2_CFG_SPLITER_ASME_GET_NEXT_FRAMEPOS
	
Description:
	Get the next frame position from ASME
Value type:
	MDWord*
Note:
	None
=======================================================*/
#define MV2_CFG_SPLITER_ASME_GET_NEXT_FRAMEPOS							(MV2_CFG_MEDIAFILE_BASE + 47)

/*====================================================
ID:
MV2_CFG_SPLITER_ASME_PORT_RANGE

Description:
Set the Port for asme spliter
Value type:
MDWord*
Note:
None
=======================================================*/

#define MV2_CFG_SPLITER_ASME_PORT_RANGE								(MV2_CFG_MEDIAFILE_BASE + 48)

/*====================================================
ID:
	MV2_CFG_MUXER_SET_CACHESIZE

  Description:
	set the muxer cache size.
  Value type:
  MDWord*; 
  Note:
	MV2_ASMELOG_LEVEL_NONE etc
=======================================================*/
#define MV2_CFG_MUXER_SET_CACHESIZE							(MV2_CFG_MEDIAFILE_BASE + 49) 

/*====================================================
ID:
MV2_CFG_SPLITER_TOTALFRAMECOUNT

Description:
get the total frame counts.
Value type:
MDWord*; 
Note:
None
=======================================================*/
#define MV2_CFG_SPLITER_TOTALFRAMECOUNT						(MV2_CFG_MEDIAFILE_BASE + 50) 

/*====================================================

ID:
	MV2_CFG_SPLITER_MAXFPS
	
Description:
	for get the maximum fps of video
Value type:
	MDWord*; 
=======================================================*/

#define MV2_CFG_SPLITER_MAXFPS										(MV2_CFG_MEDIAFILE_BASE + 51)
/*====================================================
ID:
	MV2_CFG_SPLITER_MINFPS
	
Description:
	for get the minimum fps of video
Value type:
	MDWord*; 
=======================================================*/
#define MV2_CFG_SPLITER_MINFPS										(MV2_CFG_MEDIAFILE_BASE + 52)

#define MV2_CFG_SPLITER_GETVFRAMECOUNT								(MV2_CFG_MEDIAFILE_BASE + 53)

/*====================================================
ID:
	MV2_CFG_SPLITER_CURSYNCFRAME
	
Description:
	for set duration of the last video frame
Value type:
	MDWord*; 
=======================================================*/

#define MV2_CFG_SPLITER_CURSYNCFRAME							    (MV2_CFG_MEDIAFILE_BASE + 54)

/*====================================================
ID:
	MV2_CFG_SPLITER_DISSYNCHEADER

  Description:
	for disable the adts aac sync header
  Value type:
  MBool; 
  Note:
  none
=======================================================*/

#define MV2_CFG_SPLITER_DISSYNCHEADER								(MV2_CFG_MEDIAFILE_BASE + 55)  

/*====================================================
ID:
	MV2_CFG_MUXER_LASTVFDURATION
	
Description:
	for set duration of the last video frame
Value type:
	MDWord*; 
=======================================================*/

#define MV2_CFG_MUXER_LASTVFDURATION							    (MV2_CFG_MEDIAFILE_BASE + 56)
/*=====================================
ID:
MV2_CFG_SPLITER_GETPLAYCONTROL

Description:
Get play control if it is FastTrack
Value type:
* 
Note:
only for get 
=======================================*/
#define MV2_CFG_SPLITER_GETPLAYCONTROL									(MV2_CFG_MEDIAFILE_BASE + 57)
/*=====================================
ID:
MV2_CFG_SPLITER_GETPREVKEYTIME

Descrpition:
Get previous key frame time
Value type:
* 
Note:
only for get 
=======================================*/
#define MV2_CFG_SPLITER_GETPREVKEYTIME									(MV2_CFG_MEDIAFILE_BASE + 58)

#define MV2_CFG_ROTATION_ANGLE_DEGREES									(MV2_CFG_MEDIAFILE_BASE + 59)
/*====================================================
ID:
MV2_CFG_SPLITER_SET_LINK_INFO	

Description:
Value type:

Note:
fot set only
=======================================================*/
#define MV2_CFG_SPLITER_SET_LINK_INFO			(MV2_CFG_MEDIAFILE_BASE + 66)

#define MV2_CFG_MEDIAFILE_SET_LAST_HTTPURL		(MV2_CFG_MEDIAFILE_BASE + 67)

#define MV2_CFG_SPLITTER_HTTP_USERAGENT			(MV2_CFG_MEDIAFILE_BASE + 68)
/*=====================================
ID:
MV2_CFG_SPLITER_MINIOPENTYPE

Description:
mini open a avi file.
Value type:
MDWord*; 
Note:
None
=======================================================*/
#define MV2_CFG_SPLITER_MINIOPENTYPE						(MV2_CFG_MEDIAFILE_BASE + 70) 
#define MV2_CFG_SPLITER_GETFRAMETYPE						(MV2_CFG_MEDIAFILE_BASE + 71)

/*=====================================
ID:
MV2_CFG_MEDIAFILE_SAVE

Descrpition:
Get last save file name
Value type:
* 
Note:
only for get 
=======================================*/
#define MV2_CFG_MEDIAFILE_SAVE								(MV2_CFG_MEDIAFILE_BASE + 71)
#define MV2_CFG_MEDIAFILE_GETFILENAME						(MV2_CFG_MEDIAFILE_BASE + 72)
#define MV2_CFG_SPLITER_ASME_PROXY							(MV2_CFG_MEDIAFILE_BASE + 73)
/*====================================================
ID:
MV2_CFG_MEDIAFILE_DELETE_LASTEST

Description:
delete the last media file
Value type:

Note:
fot set only
=======================================================*/
#define	MV2_CFG_MEDIAFILE_DELETE_LASTEST					(MV2_CFG_MEDIAFILE_BASE + 74)

/*====================================================
ID:
MV2_CFG_GET_ASME_ERROR_INFO

Description:
delete the last media file
Value type:

Note:
fot set only
=======================================================*/
#define MV2_CFG_GET_ASME_ERROR_INFO							(MV2_CFG_MEDIAFILE_BASE + 75)

/*====================================================
ID:
MV2_CFG_SET_ASME_SUPPORT_3GPP	

Description:
Value type:

Note:
fot set only =======================================================*/
//#define	MV2_CFG_SET_ASME_SUPPORT_3GPP		(MV2_CFG_MEDIAFILE_BASE + 76)

/*====================================================
ID:
MV2_CFG_SET_ASME_SUPPORT_NAT	

Description:
Value type:

Note:
fot set only =======================================================*/
#define	MV2_CFG_SET_ASME_NAT		(MV2_CFG_MEDIAFILE_BASE + 77)

/*====================================================
ID:
MV2_CFG_SET_ASME_REQUEST_TIMEOUT	

Description:
Value type:

Note:
fot set only =======================================================*/
//#define	MV2_CFG_SET_ASME_REQUEST_TIMEOUT		(MV2_CFG_MEDIAFILE_BASE + 78)

/*====================================================
ID:
MV2_CFG_SET_ASME_DATA_TIMEOUT	

Description:
Value type:

Note:
fot set only =======================================================*/
//#define	MV2_CFG_SET_ASME_DATA_TIMEOUT		(MV2_CFG_MEDIAFILE_BASE + 79)
/*====================================================
ID:
MV2_CFG_SET_ASME_LOG_MODE	

Description:
Value type:

Note:
fot set only =======================================================*/
//#define	MV2_CFG_SET_ASME_LOG_MODE		(MV2_CFG_MEDIAFILE_BASE + 80)

/*====================================================
ID:
MV2_CFG_SET_ASME_ADDTIONAL_CONFIG	

Description:
Value type:

Note:
fot set only
=======================================================*/
#define	MV2_CFG_SET_ASME_ADDITIONAL_CONFIG		(MV2_CFG_MEDIAFILE_BASE + 81)


/*====================================================
ID:
MV2_CFG_MEDIAFILE_GETFILESTATUS	

Description:
Value type:

Note:
fot set only
=======================================================*/
#define MV2_CFG_MEDIAFILE_GETFILESTATUS			(MV2_CFG_MEDIAFILE_BASE + 82)

#define MV2_CFG_MEDIAFILE_IS_SUPPORT_SOURCE		(MV2_CFG_MEDIAFILE_BASE + 83)

#define MV2_CFG_MEDIAFILE_STREAMSOURCE			(MV2_CFG_MEDIAFILE_BASE + 84)

/*====================================================
ID:
MV2_CFG_GET_ASME_SESSION_INFO	

Description:
Value type: ASME_SESSION_INFO*

Note:
fot set only
=======================================================*/
#define MV2_CFG_GET_ASME_SESSION_INFO			(MV2_CFG_MEDIAFILE_BASE + 85)
/*====================================================
ID:
MV2_CFG_SPLITER_GET_ASME_LASTERROR	

Description:
Value type:	MDWord

Note:
for get only
=======================================================*/
#define MV2_CFG_SPLITER_GET_ASME_LASTERROR (MV2_CFG_MEDIAFILE_BASE + 86)

/*====================================================
ID:
MV2_CFG_SPLITER_ASME_SESSIONID	

Description:
Value type:	MChar*

Note:
for set/get
=======================================================*/
#define MV2_CFG_SPLITER_ASME_SESSIONID (MV2_CFG_MEDIAFILE_BASE + 87)

/*====================================================
ID:
MV2_CFG_SPLITER_ASME_SESSION_TIMEOUT	

Description:
Value type:	MDWord*

Note:
for get
=======================================================*/
#define MV2_CFG_SPLITER_ASME_SESSION_TIMEOUT (MV2_CFG_MEDIAFILE_BASE + 88)

/*====================================================
ID:
MV2_CFG_SPLITER_ASME_START_TIMESTAMP	

Description:
Value type:	MDWord*

Note:
for get
=======================================================*/
#define MV2_CFG_SPLITER_ASME_START_TIMESTAMP (MV2_CFG_MEDIAFILE_BASE + 89)


/*====================================================
ID:
MV2_CFG_SPLITER_ASME_CUR_FRAME_RTP_INFO	

Description:
Value type:	ASME_FRAME_RTP_INFO*

Note:
for get
=======================================================*/
#define MV2_CFG_SPLITER_ASME_CUR_FRAME_RTP_INFO (MV2_CFG_MEDIAFILE_BASE + 90)
#define	MV2_CFG_MEDIAFILE_CTEMPFILE								(MV2_CFG_MEDIAFILE_BASE + 91)
#define MV2_CFG_SPLITER_ACODEC_CONTEXT          (MV2_CFG_MEDIAFILE_BASE + 92)
#define MV2_CFG_SPLITER_VCODEC_CONTEXT          (MV2_CFG_MEDIAFILE_BASE + 93)

#define MV2_CFG_MUXER_MOOV_SIZE               (MV2_CFG_MEDIAFILE_BASE + 94)

#define MV2_CFG_SPLITER_LAST_VFRAMETIME          (MV2_CFG_MEDIAFILE_BASE + 95)

#define MV2_CFG_SPLITER_VFRAMETIME               (MV2_CFG_MEDIAFILE_BASE + 96)

#define MV2_CFG_MUXER_NEEDASYNCDUMP              (MV2_CFG_MEDIAFILE_BASE + 97)

#define MV2_CFG_SPLITER_NEXT_VFRAMETIME          (MV2_CFG_MEDIAFILE_BASE + 98)

#define MV2_CFG_SPLITER_VFRAMETIMESPAN           (MV2_CFG_MEDIAFILE_BASE + 99)

#define MV2_CFG_SPLITER_NEAR_NEXT_KEY_FRAME_TIME (MV2_CFG_MEDIAFILE_BASE + 100)

#define MV2_CFG_MUXER_CONTEXT_DATA               (MV2_CFG_MEDIAFILE_BASE + 101)

#define MV2_CFG_DRM_ISDRMFILE							(MV2_CFG_MEDIAFILE_BASE + 200)
#define MV2_CFG_DRM_INIDATA_LENGTH				(MV2_CFG_MEDIAFILE_BASE + 202)
#define MV2_CFG_DRM_INIDATA								(MV2_CFG_MEDIAFILE_BASE + 201)
#define MV2_CFG_DRM_SETHANDLE							(MV2_CFG_MEDIAFILE_BASE + 203)
#define MV2_CFG_DRM_SETVIDEO_DECFUNC			(MV2_CFG_MEDIAFILE_BASE + 204)
#define MV2_CFG_DRM_SETAUDIO_DECFUNC			(MV2_CFG_MEDIAFILE_BASE + 205)

#define MV2_CFG_MUXER_AUDIO_TIME			    (MV2_CFG_MEDIAFILE_BASE + 206)

#define MV2_CFG_MUXER_SPS_PPS			    (MV2_CFG_MEDIAFILE_BASE + 207)

#define MV2_CFG_MUXER_MAX_FPS			    (MV2_CFG_MEDIAFILE_BASE + 208)
#define MV2_CFG_USE_VIDEO_TOOL_BOX			    (MV2_CFG_MEDIAFILE_BASE + 209)
#define MV2_CFG_ANNEXB_MODE			    (MV2_CFG_MEDIAFILE_BASE + 210)


#define MV2_CFG_SEND_VIDEO_TIME_COST		(MV2_CFG_MEDIAFILE_BASE+211)
#define MV2_CFG_SEND_AUDIO_TIME_COST		(MV2_CFG_MEDIAFILE_BASE+212)
#define MV2_CFG_SEND_MAX_AUDIO_CACHE		(MV2_CFG_MEDIAFILE_BASE+213)
#define MV2_CFG_ENABLE_RTMP_BITRATE_ADAPTION		(MV2_CFG_MEDIAFILE_BASE+214)

#define MV2_CFG_CLIP_INFO								(MV2_CFG_MEDIAFILE_BASE+215)


#define MV2_CFG_MEDIAFILE_WM_METADATA					(MV2_CFG_MEDIAFILE_BASE+216)

#define MV2_CFG_EXTRACT_AUDIO_FLAG						(MV2_CFG_MEDIAFILE_BASE+217)

#define	MV2_CFG_SPLITER_ACODEC_SAMPLE_FMT					(MV2_CFG_MEDIAFILE_BASE+218)

#define	MV2_CFG_STREAM_UPDATE_DRAW_BACKGROUND			(MV2_CFG_MEDIAFILE_BASE+220) // 用来设置stream是否需要效果画到底图上

#define MV2_CFG_AVERAGE_GOP_TIME                        (MV2_CFG_MEDIAFILE_BASE+221)


///////configuration type ID for display//////////////////////
#define MV2_CFG_DISPLAY_BASE				0x09000000
#define MV2_CFG_DISPLAY_END				0x09ffffff

/*=====================================
ID:
	MV2_CFG_DISPLAY_PARAM
	
Descrpition:
	for display agent parameter configuration
Value type:
	LPMV2DISPLAYPARAM
=======================================*/
#define MV2_CFG_DISPLAY_PARAM       (MV2_CFG_DISPLAY_BASE+1)

/*=====================================
ID:
	MV2_CFG_DISPLAY_COLORSPACE
	
Descrpition:
	for getting the current color space of display agent
Value type:
	MDWord*
Note:
    Only for get
=======================================*/
#define MV2_CFG_DISPLAY_COLORSPACE       (MV2_CFG_DISPLAY_BASE+2)

/*=====================================
ID:
	MV2_CFG_DISPLAY_STATUS
	
Descrpition:
	for set display on/off,MTrue to turn the display on ,MFalse to turn off the display
Value type:
	MBool*
Note:
    Only for get
=======================================*/
#define MV2_CFG_DISPLAY_STATUS       (MV2_CFG_DISPLAY_BASE+3)

/*=====================================
ID:
	MV2_CFG_DISPLAY_CLIPINFO
	
Descrpition:
	for set clip width & height
Value type:
	MRECT *
Note:
	width = right - left; height = bottom - top
=======================================*/
#define MV2_CFG_DISPLAY_CLIPINFO		(MV2_CFG_DISPLAY_BASE+4)

/*=====================================
ID:
	MV2_CFG_DISPLAY_PREPROCESSED
	
Descrpition:
	for set whether codec has preprocessed 
Value type:
	MBool *
Note:
=======================================*/
#define MV2_CFG_DISPLAY_PREPROCESSED	(MV2_CFG_DISPLAY_BASE+5)

/*=====================================
ID:
	MV2_CFG_DIAPLAY_TAILPROCESS
	
Descrpition:
	for set tail process info
Value type:
	MV2PREPROCESSINFO *
Note:
=======================================*/
#define MV2_CFG_DIAPLAY_TAILPROCESS	(MV2_CFG_DISPLAY_BASE+6)

/*=====================================
ID:
	MV2_CFG_DISPLAY_OUTPUT
	
Descrpition:
	for display output device 
Value type:
	MDWord *
Note:
=======================================*/
#define MV2_CFG_DISPLAY_OUTPUT	(MV2_CFG_DISPLAY_BASE+7)

/*=====================================
ID:
	MV2_CFG_DISPLAY_REDRAW
	
Descrpition:
	for Draw current frame by DC
Value type:
	MV2DISPCURFRAMEINFO *
Note:
=======================================*/
#define MV2_CFG_DISPLAY_REDRAW	(MV2_CFG_DISPLAY_BASE+8)
 
/*=====================================
ID:
	MV2_CFG_DIAPLAY_SETGAPI
	
Descrpition:
	for WinCE Platform and Draw by Game api
Value type:
	GameApiObject *
Note:
=======================================*/
#define MV2_CFG_DIAPLAY_SETGAPI	(MV2_CFG_DISPLAY_BASE+9)

/*=====================================
ID:
	MV2_CFG_DISPLAY_OPERATION_MODE
	
Value type:
	MLong *
Note:
=======================================*/
#define MV2_CFG_DISPLAY_OPERATION_MODE	(MV2_CFG_DISPLAY_BASE+10)

/*=====================================
ID:
	MV2_CFG_DISPLAY_FULLSCREEN_MODE
	
Value type:
	MBool *
Note:
=======================================*/
#define MV2_CFG_DISPLAY_FULLSCREEN_MODE	(MV2_CFG_DISPLAY_BASE+11)

/*=====================================
ID:
	MV2_CFG_DISPLAY_SWITCH
	
Descrpition:
	 switch display handle. off(MFalse) means low display, on means high display
Value type:
	MBool * ; 
Note:
    for set
    =======================================*/
#define MV2_CFG_DISPLAY_SWITCH			(MV2_CFG_DISPLAY_BASE+12)

/*=====================================
ID:
	MV2_CFG_DISPLAY_ZOOM
	
Descrpition:
	Zoom base value is 100, > 100 means ZoomIn, < 100 means ZoomOut
Value type:
	MDWord * ; 
Note:
    for set / get
    =======================================*/
#define MV2_CFG_DISPLAY_ZOOM			(MV2_CFG_DISPLAY_BASE+13)


/*=====================================
ID:
	MV2_CFG_DISPLAY_FRAMEINFO
	
Descrpition:
	Set Frame Info to display before drawing the first frame
Value type:
	MV2FRAMEINFO* 
Note:
    for set / get
    =======================================*/
#define MV2_CFG_DISPLAY_FRAMEINFO			(MV2_CFG_DISPLAY_BASE+14)

/*=====================================
ID:
	MV2_CFG_DISPLAY_RESAMPLE_ALG
	
Descrpition:
	Set/Get the current display Resize algorith for resample
Value type:
	MDWord* 
Note:
    for set / get
    =======================================*/
#define	MV2_CFG_DISPLAY_RESAMPLE_ALG			(MV2_CFG_DISPLAY_BASE+15)


/*====================================================
ID:
MV2_CFG_DISPLAY_RESET_OVERLAY

Description:
reset the OVERLAY handle
Value type:
MDWord*
Note:
None
=======================================================*/

#define MV2_CFG_DISPLAY_RESET_OVERLAY								(MV2_CFG_DISPLAY_BASE + 16)
/*====================================================
ID:
MV2_CFG_DISPLAY_RESUME_ACTIVE

Description:
reset the GOFORCE5500 handle when app become active
Value type:
MDWord*
Note:
None
=======================================================*/

#define MV2_CFG_DISPLAY_RESUME_ACTIVE								(MV2_CFG_DISPLAY_BASE + 17)

#define MV2_CFG_DISPLAY_BLITCB										(MV2_CFG_DISPLAY_BASE + 18)
/*=====================================
ID:
	MV2_CFG_DISPLAY_DRAWCLIP_RECT
	
Descrpition:
	 for display agent view port
Value type:
	MBool * ; 
Note:
    for set
    =======================================*/
#define MV2_CFG_DISPLAY_DRAWCLIP_RECT								(MV2_CFG_DISPLAY_BASE + 19)


/*====================================================
ID:
MV2_CFG_DISPLAY_BLIT

Description:
Display effect 
Value type:
MDWord*
Note:
None
=======================================================*/
#define MV2_CFG_DISPLAY_BLIT (MV2_CFG_DISPLAY_BASE + 20)
/*====================================================
ID:
MV2_CFG_DISPLAY_CHOOSE

Description:
Display choose type 
Value type:
MDWord*
Note:
None
=======================================================*/
#define MV2_CFG_DISPLAY_CHOOSE (MV2_CFG_DISPLAY_BASE + 21)
/*====================================================
ID:
MV2_CFG_DISPLAY_CROP

Description:
Value type:
MDWord*
Note:
None
=======================================================*/
#define MV2_CFG_DISPLAY_CROP 		(MV2_CFG_DISPLAY_BASE + 22)


/*
*	MV2_CFG_DISPLAY_REFRESH
*		Use this config to make a order of refreshing display
*/
#define MV2_CFG_DISPLAY_REFRESH	(MV2_CFG_DISPLAY_BASE + 23)

//////////configuration type ID for camera/////////////////
#define MV2_CFG_CAMERA_BASE				0x10000000
#define MV2_CFG_CAMERA_END				0x10ffffff

/*=====================================
ID:
	MV2_CFG_CAMERA_PARAM
	
Descrpition:
	for camera parameter configuration
Value type:
	LPMV2CAMERAPARAM
=======================================*/
#define	MV2_CFG_CAMERA_PARAM			(MV2_CFG_CAMERA_BASE+1)

/*=====================================
ID:
	MV2_CFG_CAMERA_PROPERTY
	
Descrpition:
	for camera property configuration
Value type:
	LPMV2CAMERAPROPERTY
=======================================*/
#define MV2_CFG_CAMERA_PROPERTY			(MV2_CFG_CAMERA_BASE+2)


/*
 *	MV2_CFG_CAMERA_TX_FOR_DRAW is correspongding to MCAMERA_PROPERTY_TX_FOR_DRAW
 */
#define MV2_CFG_CAMERA_TX_FOR_DRAW		(MV2_CFG_CAMERA_BASE+3)

/*
 *	MV2_CFG_CAMERA_TX_FOR_ENC is correspongding to MCAMERA_PROPERTY_TX_FOR_ENC
 */
#define MV2_CFG_CAMERA_TX_FOR_ENC		(MV2_CFG_CAMERA_BASE+4)


/*
 *	MV2_CFG_CAMERA_TX_LIST is correspongding to MCAMERA_PROPERTY_TX_LIST
 */
#define MV2_CFG_CAMERA_TX_LIST			(MV2_CFG_CAMERA_BASE+5)

#define MV2_CFG_CAMERA_TX_LIST_FOR_SW			(MV2_CFG_CAMERA_BASE+6)

#define MV2_CFG_AUDIO_PITCH             (MV2_CFG_CAMERA_BASE+7)

#define MV2_CFG_CODEC_BASE				0x11000000
#define MV2_CFG_CODEC_END				0x11ffffff

/*=====================================
ID:
	MV2_CFG_CODEC_VIDEOINFO
	
Descrpition:
	For video decoder parameter config
	this param to set/get the video codec info
Value type:
	LPMV2VIDEOINFO
Note:
	Use to set the video param to the video decoder output dim 
=======================================*/
#define MV2_CFG_CODEC_VIDEOINFO			(MV2_CFG_CODEC_BASE+1)


/*=====================================
ID:
	MV2_CFG_DECODER_REGION
	
Descrpition:
	For video decoder parameter config
	this param to set the codec output region,when the image size is not
	same as the region,the codec should best fit in this region

Value type:
	LPMRECT
Note:
	Use to set the video param to the video decoder output dim 
=======================================*/
#define MV2_CFG_CODEC_REGION			(MV2_CFG_CODEC_BASE+2)

/*=====================================
ID:
	MV2_CFG_DECODER_DEBLOCK
	
Descrpition:
	For video decoder parameter config
	this param to set the video decoder postprocess(deblock)on/off

Value type:
	MBool * 
Note:
	Use to set the video param to the video codec 
=======================================*/
#define MV2_CFG_CODEC_DEBLOCK			(MV2_CFG_CODEC_BASE+3)


/*=====================================
ID:
	MV2_CFG_CODEC_AUDIOINFO
	
Descrpition:
	For Video decoder parameter config
	this param to set/get the audio codec 

Value type:
	LPMV2AUDIOINFO
Note:
	None

=======================================*/
#define MV2_CFG_CODEC_AUDIOINFO			(MV2_CFG_CODEC_BASE+4)

/*=====================================
ID:
	MV2_CFG_CODEC_GETSAFESIZE
	
Descrpition:
	to get the safe size of one frame from the codec
	
Value type:
	MDWord * 
Note:
	None
=======================================*/
#define MV2_CFG_CODEC_GETSAFESIZE			(MV2_CFG_CODEC_BASE+5)

/*=====================================
ID:
	MV2_CFG_CODEC_QUALITY
	
Descrpition:
	to set the quality to the encoder
	
Value type:
	MDWord * 
Note:
	None
=======================================*/
#define MV2_CFG_CODEC_QUALITY			(MV2_CFG_CODEC_BASE+6)



/*=====================================
ID:
	MV2_CFG_CODEC_SPECIAL_INFO
	
Descrpition:
	For special info setting of codecs

Value type:
	MVoid* (point to codec-dependent info struct)

Note:
	only for set

=======================================*/
#define MV2_CFG_CODEC_SPECIAL_INFO		(MV2_CFG_CODEC_BASE+7)

//get the min in buffer size that a special codec need ;
//Value type: : MLong * 
#define MV2_CFG_CODEC_MININBUFSIZE		(MV2_CFG_CODEC_BASE + 8) 
//get the min out buffer size that a special codec need;
//Value type: : MLong * 
#define MV2_CFG_CODEC_MINOUTBUFSIZE		(MV2_CFG_CODEC_BASE + 9) 

//For Midi stream parameter config,this param to set the midi the path of patch files
//Value type: MVoid* 
#define MV2_CFG_MIDI_PATCH_PATH			(MV2_CFG_CODEC_BASE+10)

//For set aac codec info
//Value type: MVoid* 
#define MV2_CFG_CODEC_AAC_INFO			(MV2_CFG_CODEC_BASE+11)


/*=====================================
ID:
	MV2_CFG_CODEC_CALLBACK
	
Descrpition:
	for set codec preprocess callback

Value type:
	MV2PREPROCESSCALLBACK*
Note:
=======================================*/

#define MV2_CFG_CODEC_CALLBACK		     (MV2_CFG_CODEC_BASE+12)

//for mpeg4(or other) resync marker(encoding only)
//Value type: MDWord*
#define	MV2_CFG_CODEC_VIDEO_ENC_PACKETLEN			(MV2_CFG_CODEC_BASE+13)

//mpeg4 encoding parameter
//Value type: MDWord*
#define	MV2_CFG_CODEC_VIDEO_ENC_DELAY				(MV2_CFG_CODEC_BASE+14)

//mpeg4 encoding parameter
//Value type: MDWord*
#define	MV2_CFG_CODEC_VIDEO_ENC_FRAMERATE			(MV2_CFG_CODEC_BASE+15)

//mpeg4 encoding parameter
//Value type: MDWord*
#define	MV2_CFG_CODEC_VIDEO_ENC_BITRATE				(MV2_CFG_CODEC_BASE+16)

#define MV2_CFG_CODEC_UPDATESHAREDMEM				(MV2_CFG_CODEC_BASE+17)

#define MV2_CFG_CODEC_MPEG4H263_CHOICE              (MV2_CFG_CODEC_BASE+18)

#define MV2_CFG_CODEC_AAC_SPECIFIC_INFO				(MV2_CFG_CODEC_BASE+19)

#define MV2_CFG_CODEC_MULTI_FRAME					(MV2_CFG_CODEC_BASE+20)

//aac encoding parameter
//Value type: MDWord* 	0 for raw, 1 for adts, 2 for adif
#define MV2_CFG_CODEC_AACENC_HEADERTYPE				(MV2_CFG_CODEC_BASE+21)

//aac encoding parameter
//Value type: MBool* 	0 for mono, 1 for stereo
#define MV2_CFG_CODEC_AACENC_OUT_MONO				(MV2_CFG_CODEC_BASE+22)

//support for mpeg4_h263_dec from SH
#define MV2_CFG_CODEC_DISPLAY_ALL     				(MV2_CFG_CODEC_BASE+23)  /* bool */
#define MV2_CFG_CODEC_VIDEO_ENC_INSERTIVOP			(MV2_CFG_CODEC_BASE+24)

#define MV2_CFG_CODEC_VIDEO_ENC_TIMEINCRESL			(MV2_CFG_CODEC_BASE+25)

///////configuration type ID for mp3 encoder//////////////////////////////////
#define MV2_CFG_CODEC_MP3ENC_FRAME_DURATION			(MV2_CFG_CODEC_BASE + 26)

#define MV2_CFG_CODEC_VIDEO_ENC_IFRAME_INTERVAL		(MV2_CFG_CODEC_BASE+27)

#define MV2_CFG_CODEC_SPLITER_MUXER					(MV2_CFG_CODEC_BASE+28)

////////configuration type ID for encode iframeinterval//////////////////////////////
#define MV2_CFG_CODEC_ENCODE_IFRAMEINTERVAL			(MV2_CFG_CODEC_BASE+29)

/*Get CODEC color space
  [decoder]:decoded data color space
  [encoder]:supported color space of the input data
*/
#define MV2_CFG_CODEC_COLORSPACE                   (MV2_CFG_CODEC_BASE+30)

#define MV2_CFG_CODEC_VIDEO_FRAMETYPE              (MV2_CFG_CODEC_BASE+31)

#define MV2_CFG_CODEC_SUPPORT_SKIP_FRAME           (MV2_CFG_CODEC_BASE+32)

#define MV2_CFG_CODEC_INPUT_FRAMETYPE              (MV2_CFG_CODEC_BASE+33)

#define MV2_CFG_CODEC_ENC_PROFILE                  (MV2_CFG_CODEC_BASE+34)

#define MV2_CFG_CODEC_ENC_LEVEL                    (MV2_CFG_CODEC_BASE+35)

#define MV2_CFG_CODEC_SPLITTER_INSTANCE            (MV2_CFG_CODEC_BASE+36)

#define MV2_CFG_CODEC_SURFACE_HANDLE               (MV2_CFG_CODEC_BASE+37)


#define MV2_CFG_CODEC_REMAIN_VIDEO_SEEK_TIME       (MV2_CFG_CODEC_BASE+38)

#define MV2_CFG_CODEC_PREPARE_MODE                 (MV2_CFG_CODEC_BASE+39)

#define MV2_CFG_CODEC_END_OF_STREAM                (MV2_CFG_CODEC_BASE+40)


#define MV2_CFG_CODEC_JNI_HELPER                   (MV2_CFG_CODEC_BASE+41)

#define MV2_CFG_CODEC_RTMP_MODE                   (MV2_CFG_CODEC_BASE+42)

#define MV2_CFG_CODEC_GPU_RENDER                   (MV2_CFG_CODEC_BASE+43)

#define MV2_CFG_CODEC_COMPONENT_NAME               (MV2_CFG_CODEC_BASE+44)

#define MV2_CFG_CODEC_CUR_VIDEO_TIME               (MV2_CFG_CODEC_BASE+45)

#define MV2_CFG_CODEC_VIDEO_PTS                    (MV2_CFG_CODEC_BASE+46)

#define MV2_CFG_CODEC_VIDEO_DTS                    (MV2_CFG_CODEC_BASE+47)

#define MV2_CFG_CODEC_SET_BITRATE                  (MV2_CFG_CODEC_BASE+48)

#define MV2_CFG_CODEC_HW_EXCEPTION                 (MV2_CFG_CODEC_BASE+49)

#define MV2_CFG_CODEC_AVPACKET					   (MV2_CFG_CODEC_BASE+50)

#define MV2_CFG_CODEC_ENCODE_COLOR_SPACE		   (MV2_CFG_CODEC_BASE+51)

#define MV2_CFG_CODEC_RECORD_MODE                  (MV2_CFG_CODEC_BASE+52)

#define MV2_CFG_CODEC_BITRATE_MODE                 (MV2_CFG_CODEC_BASE+53)

#define MV2_CFG_CODEC_DOWN_SCALE                   (MV2_CFG_CODEC_BASE+54)

#if defined(_SUPPORT_LINUX_)
#define MV2_CFG_CODEC_GPU_NO                       (MV2_CFG_CODEC_BASE+60)

#define MV2_CFG_CODEC_USE_GPU                      (MV2_CFG_CODEC_BASE+61)

#define MV2_CFG_CODEC_SET_RENDER_ENGINE_CONTEXT    (MV2_CFG_CODEC_BASE+62)

#define MV2_CFG_CODEC_SET_CUDA_CONTEXT             (MV2_CFG_CODEC_BASE+63)

#define MV2_CFG_CODEC_SET_NVJPEG_CONTEXT           (MV2_CFG_CODEC_BASE+64)

#endif

#define MV2_CFG_CODEC_SEEK_DST_TIME                (MV2_CFG_CODEC_BASE+65) 


#define MV2_CFG_CODEC_REQUEST_KEY_FRAME            (MV2_CFG_CODEC_BASE+66) 

#define MV2_CFG_CODEC_HAS_B_FRAMES                 (MV2_CFG_CODEC_BASE+67) 

#define MV2_CFG_CODEC_FILE_NAME                    (MV2_CFG_CODEC_BASE+68) 

#define MV2_CFG_CODEC_NEED_UPDATE_VIDEO_FRAME      (MV2_CFG_CODEC_BASE+69) 

#define MV2_CFG_CODEC_IS_SAME_SUB_STREAM           (MV2_CFG_CODEC_BASE+70) 

//Add freeze frame stream config
#define MV2_CFG_FREEZE_FRAME_BASE				   0x12000000
#define MV2_CFG_FREEZE_FRAME_END				   0x12ffffff


#define MV2_CFG_FFRAMESTREAM_CACHE_STATUS          (MV2_CFG_FREEZE_FRAME_BASE + 1)
#define MV2_CFG_FFRAMESTREAM_SETTING_INITED        (MV2_CFG_FREEZE_FRAME_BASE + 2)


////////configuration type ID for custom/////////////////
#define MV2_CFG_CUSTOM_BASE				0x80000000	// the base for custom configuration

#define MV2_CFG_CUSTOM_V_GET_SPLITER_DATA			(MV2_CFG_CUSTOM_BASE+1)

#define MV2_CFG_CUSTOM_V_ONLY_GET_TIME				(MV2_CFG_CUSTOM_BASE+2)

#define MV2_CFG_CUSTOM_A_GET_SPLITER_DATA			(MV2_CFG_CUSTOM_BASE+3)

#define MV2_CFG_CUSTOM_A_ONLY_GET_TIME				(MV2_CFG_CUSTOM_BASE+4)

#define MV2_CFG_CUSTOM_IS_KEY_FRAME					(MV2_CFG_CUSTOM_BASE+5)

#define MV2_CFG_CUSTOM_LAST_CORR_DATA			    (MV2_CFG_CUSTOM_BASE+6)

#define MV2_CFG_CUSTOM_LOAD_VIDEO					(MV2_CFG_CUSTOM_BASE+7)

#define MV2_CFG_CUSTOM_LOAD_AUDIO					(MV2_CFG_CUSTOM_BASE+8)

#define MV2_CFG_CUSTOM_CLIP_NO_TRANS				(MV2_CFG_CUSTOM_BASE+9)

//reopen audio device
#define MV2_CFG_CUSTOM_AUDIO_REFRESH_HANDLE			(MV2_CFG_CUSTOM_BASE+10)

//Get Dump log handle
#define MV2_CFG_CUSTOM_GET_LOG_HANDLE				(MV2_CFG_CUSTOM_BASE+11)

//display resize mode
#define MV2_CFG_CUSTOM_DISPLAY_RESIZE_MODE			(MV2_CFG_CUSTOM_BASE+12)

//aac codec type
#define MV2_CFG_CUSTOM_AAC_CODEC_TYPE				(MV2_CFG_CUSTOM_BASE+13)

#define MV2_CFG_CUSTOM_SPLITER_BATTACHINFO			(MV2_CFG_CUSTOM_BASE+14)

#define MV2_CFG_CUSTOM_DISPLAY_RECREATE				(MV2_CFG_CUSTOM_BASE+15)

#define MV2_CFG_CUSTOM_SPLITTER_NORMAL_OUT			(MV2_CFG_CUSTOM_BASE+16)

#define MV2_CFG_CUSTOM_TEMP_FILE_PATH				(MV2_CFG_CUSTOM_BASE+17)

#define MV2_CFG_CUSTOM_H264_SPECIAL_INFO			(MV2_CFG_CUSTOM_BASE+18)
#define MV2_CFG_CUSTOM_H264_PARSE_INFO				(MV2_CFG_CUSTOM_BASE+19)
#define MV2_CFG_CUSTOM_AVC_LENGTH					(MV2_CFG_CUSTOM_BASE+20)

#define MV2_CFG_CUSTOM_DST_TIME_IS_SEEKABLE			(MV2_CFG_CUSTOM_BASE+21)
//Get the time stamp of first video frame.
//The first time stamp of several file does not begin from zero, see BUG061641 
#define MV2_CFG_CUSTOM_VIDEO_FIRST_TIMESTAMP		(MV2_CFG_CUSTOM_BASE+22)

#define MV2_CFG_CUSTOM_PLAYER_DO_SYNC_SEEK			(MV2_CFG_CUSTOM_BASE+23)

#define MV2_CFG_CUSTOM_MEDIASTREAM_USE_HW_CODEC		(MV2_CFG_CUSTOM_BASE+24)

#define MV2_CFG_CUSTOM_MEDIASTREAM_USE_CODEC_TYPE		(MV2_CFG_CUSTOM_BASE+25)

#define MV2_CFG_CUSTOM_MEDIASTREAM_USE_THUMBNAILMODE		(MV2_CFG_CUSTOM_BASE+26)


  
#define MV2_CFG_CUSTOM_HWVIDEOREADER_AVCPROFILE			(MV2_CFG_CUSTOM_BASE+27)

#define MV2_CFG_CUSTOM_VIDEO_TARGET_INFO				(MV2_CFG_CUSTOM_BASE+28)

#define MV2_CFG_CUSTOM_VIDEO_SKIP_DISPLAY				(MV2_CFG_CUSTOM_BASE+29)

#define MV2_CFG_CUSTOM_VIDEO_NEXT_FRAME_TIMESTAMP					(MV2_CFG_CUSTOM_BASE+30)    

#define MV2_CFG_CUSTOM_PLAYER_RANGE						(MV2_CFG_CUSTOM_BASE+31) 

//小影记需求是场景时间长，用户插入的视频端，需要循环播放，所以添加此宏控制
#define MV2_CFG_CUSTOM_VIDEO_LOOP_PLAY_MODE           (MV2_CFG_CUSTOM_BASE + 32)

/*=====================================
ID:
	MV2_CFG_CUSTOM_VIDEO_PP_THREAD
	
Descrpition:
	 set this ID to indicate if need to start 
	 a thread to do post process
Value type:
	MBool* :true -> means start new thread to do post process 
			false ->means do not use thread to do post process
Note:
    for set
=======================================*/
#define MV2_CFG_CUSTOM_VIDEO_PP_THREAD					(MV2_CFG_CUSTOM_BASE + 32)

/*=====================================
ID:
	MV2_CFG_CUSTOM_VIDEO_PP_PROCESSOR_TYPE
	
Descrpition:
	 set this ID to confirm the PP processor type
Value type:
	MDWord* : such as 
			  MPP_PROCESSOR_ARM11/MPP_PROCESSOR_CORTEX_NEON
Note:
    for set
=======================================*/
#define MV2_CFG_CUSTOM_VIDEO_PP_PROCESSOR_TYPE			(MV2_CFG_CUSTOM_BASE + 33)

#define MV2_CFG_CUSTOM_TIME_SCALE                       (MV2_CFG_CUSTOM_BASE + 34)

#define MV2_CFG_CUSTOM_CLIP_END_TIME                    (MV2_CFG_CUSTOM_BASE + 35)


#define MV2_CFG_CUSTOM_MEDIASTREAM_USE_SURFACETEXTURE   (MV2_CFG_CUSTOM_BASE + 36)

#define MV2_CFG_MEDIASTREAM_IS_TRANSITION_CLIP          (MV2_CFG_CUSTOM_BASE + 37)

#define MV2_CFG_MEDIASTREAM_UPDATE_SURFACETEXTURE       (MV2_CFG_CUSTOM_BASE + 38)

#define MV2_CFG_MEDIASTREAM_REFRESH_FLAG                (MV2_CFG_CUSTOM_BASE + 39)

#define MV2_CFG_MEDIASTREAM_FACE_DT_HANDLE              (MV2_CFG_CUSTOM_BASE + 40)

#define MV2_CFG_MEDIASTREAM_IS_NEED_FACEDT              (MV2_CFG_CUSTOM_BASE + 41)

#define MV2_CFG_MEDIASTREAM_FACEDT_INTERVAL             (MV2_CFG_CUSTOM_BASE + 42)

#define MV2_CFG_MEDIASTREAM_FACEDT_ALK_FILE             (MV2_CFG_CUSTOM_BASE + 43)

#define MV2_CFG_MEDIASTREAM_LAST_VIDEO_FRAME            (MV2_CFG_CUSTOM_BASE + 44)

#define MV2_CFG_MEDIASTREAM_LAST_VIDEO_FRAME_INFO       (MV2_CFG_CUSTOM_BASE + 45)

#define MV2_CFG_MEDIASTREAM_IS_OT_MODE                  (MV2_CFG_CUSTOM_BASE + 46)

#define MV2_CFG_CUSTOM_IS_FRAME_MODE                    (MV2_CFG_CUSTOM_BASE + 47)

#define MV2_CFG_CUSTOM_FINISH_OPENGL                    (MV2_CFG_CUSTOM_BASE + 48)

#define MV2_CFG_CUSTOM_REFRESH_TRACK_TIME               (MV2_CFG_CUSTOM_BASE + 49)

#define MV2_CFG_CUSTOM_SET_BLEND_ALPHA					(MV2_CFG_CUSTOM_BASE + 50)

#define MV2_CFG_CUSTOM_FACE_INDEX                       (MV2_CFG_CUSTOM_BASE + 51)

#define MV2_CFG_CUSTOM_AUDIO_SOURCE_CALLBACK            (MV2_CFG_CUSTOM_BASE + 52)

#define MV2_CFG_CUSTOM_AUDIO_SOURCE_DATA                (MV2_CFG_CUSTOM_BASE + 53)

#define MV2_CFG_CUSTOM_3D_HIT_TEST                      (MV2_CFG_CUSTOM_BASE + 54)

#define MV2_CFG_CUSTOM_3D_TRANSLATE                     (MV2_CFG_CUSTOM_BASE + 55)

#define MV2_CFG_CUSTOM_3D_ROTATE                        (MV2_CFG_CUSTOM_BASE + 56)

#define MV2_CFG_CUSTOM_3D_SCALE                         (MV2_CFG_CUSTOM_BASE + 57)

#define MV2_CFG_CUSTOM_3D_TRANSLATE_CUR                 (MV2_CFG_CUSTOM_BASE + 58)

#define MV2_CFG_CUSTOM_3D_ROTATE_CUR                    (MV2_CFG_CUSTOM_BASE + 59)

#define MV2_CFG_CUSTOM_3D_SCALE_CUR                     (MV2_CFG_CUSTOM_BASE + 60)

#define MV2_CFG_CUSTOM_WM_USER_CODE                     (MV2_CFG_CUSTOM_BASE + 61)

#define MV2_CFG_CUSTOM_WM_HIDER_INTERVAL                (MV2_CFG_CUSTOM_BASE + 62)

#define MV2_CFG_CUSTOM_3D_BOUNDBOX                      (MV2_CFG_CUSTOM_BASE + 63)

#define MV2_CFG_CUSTOM_EXPORT_VIDEO_SIZE                (MV2_CFG_CUSTOM_BASE + 64)

#define MV2_CFG_CUSTOM_EXPORT_AUDIO_ONLY                (MV2_CFG_CUSTOM_BASE + 65)
#define MV2_CFG_CUSTOM_STREAM_FRAME_SIZE                (MV2_CFG_CUSTOM_BASE + 66)

#define MV2_CFG_CUSTOM_DISTURB_PREPARE                  (MV2_CFG_CUSTOM_BASE + 67)

#define MV2_CFG_CUSTOM_RENDER_API                       (MV2_CFG_CUSTOM_BASE + 68)

#define MV2_CFG_CUSTOM_WM_HIDER                         (MV2_CFG_CUSTOM_BASE + 69)

#define MV2_CFG_CUSTOM_LOCK_TEXTURE                     (MV2_CFG_CUSTOM_BASE + 70) 

#define MV2_CFG_CUSTOM_UNLOCK_TEXTURE                   (MV2_CFG_CUSTOM_BASE + 71) 

#define MV2_CFG_CUSTOM_EFFECT_STREAM                    (MV2_CFG_CUSTOM_BASE + 72) 

//bound box of animation text
#define MV2_CFG_CUSTOM_TEXT_BOUND                       (MV2_CFG_CUSTOM_BASE + 73)

#define MV2_CFG_CUSTOM_DISTURB_SEEK_CBDATA              (MV2_CFG_CUSTOM_BASE + 74)

#define MV2_CFG_CUSTOM_CUR_STORYBOARD_INFO              (MV2_CFG_CUSTOM_BASE + 75)
 
#define MV2_CFG_CUSTOM_CUR_CLIP_INFO                    (MV2_CFG_CUSTOM_BASE + 76)
 
#define MV2_CFG_CUSTOM_CUR_TRANSITION_CLIP_INFO         (MV2_CFG_CUSTOM_BASE + 77)
 
#define MV2_CFG_CUSTOM_CUR_EFFECT_INFO_LIST             (MV2_CFG_CUSTOM_BASE + 78)

#define MV2_CFG_CUSTOM_INVERSE_PLAY_FLAG                (MV2_CFG_CUSTOM_BASE + 79)

#define MV2_CFG_CUSTOM_TIMERANGE                        (MV2_CFG_CUSTOM_BASE + 80)

#define MV2_CFG_CUSTOM_FRAME_MODE                       (MV2_CFG_CUSTOM_BASE + 81)

//用来获取指定effect的绘制底图的相关信息
#define MV2_CFG_MEDIASTREAM_LAST_EFFECT_FRAME                (MV2_CFG_CUSTOM_BASE + 82)

//用来获取指定effect的绘制底图的frame
#define MV2_CFG_MEDIASTREAM_LAST_EFFECT_FRAME_INFO           (MV2_CFG_CUSTOM_BASE + 83)

//判断当前时间点是否在转场中或者下一帧是否是转场
#define MV2_CFG_CUSTOM_IS_NEAR_TRANSITION               (MV2_CFG_CUSTOM_BASE + 84) 

#define MV2_CFG_CUSTOM_USE_ONLY_SINGLE_SCENE               (MV2_CFG_CUSTOM_BASE + 85) 
#define MV2_CFG_CUSTOM_REALY_READER_TYPE               (MV2_CFG_CUSTOM_BASE + 87) 

#define MV2_CFG_REAL_TEXTURE_SIZE                         (MV2_CFG_CUSTOM_BASE + 88)

#define MV2_CFG_CUSTOM_IS_INVERSE_PLAY                   (MV2_CFG_CUSTOM_BASE + 89)

//获取某个时刻的clip的原始底图
#define MV2_CFG_MEDIASTREAM_CLIP_LAST_ORI_VIDEO_FRAME            	 (MV2_CFG_CUSTOM_BASE + 90)

#define MV2_CFG_MEDIASTREAM_CLIP_LAST_ORI_VIDEO_FRAME_INFO            (MV2_CFG_CUSTOM_BASE + 91)

#define MV2_CFG_CUSTOM_VIDEO_MUTI_SOURCE_MODE           (MV2_CFG_CUSTOM_BASE + 92)//场景按照多场景分配源

#if defined(_SUPPORT_LINUX_) 
#define MV2_CFG_CUSTOM_EXTERNAL_TEXTURE                 (MV2_CFG_CUSTOM_BASE + 101)
 
#define MV2_CFG_CUSTOM_EXTERNAL_ORIGNAL_TEXTURE         (MV2_CFG_CUSTOM_BASE + 102)
 
#define MV2_CFG_CUSTOM_ORIGNAL_MEDIA_STREAM             (MV2_CFG_CUSTOM_BASE + 103)
 
#define MV2_CFG_CUSTOM_SLSH_MULTIVIDEO_MODE             (MV2_CFG_CUSTOM_BASE + 104)
#endif

 #endif	//_MV2CONFIG_H_



