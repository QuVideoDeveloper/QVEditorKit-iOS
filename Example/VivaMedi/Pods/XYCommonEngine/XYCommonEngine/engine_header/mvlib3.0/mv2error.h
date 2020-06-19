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
 * MV2Error.h
 *
 * Description:
 *
 *	The error code defined  in MVLIB2.0
 *
  *
 * History
 *    
 *  07.26.2004 Sheng Han(shan@arcsoft.com.cn )   
 * - initial version 
 *
 */



 #ifndef _MV2ERROR_H_
 #define _MV2ERROR_H_

#include "merror.h"

//success
#define MV2_ERR_NONE					0
//general error
#define MV2_ERR_GENERAL_BASE			0x0000
//player module
#define MV2_ERR_PLAYER_BASE				0x1000
//recorder module
#define MV2_ERR_RECORDER_BASE			0x2000
//media stream module
#define MV2_ERR_MEDIASTREAM_BASE		0x3000
//media file module
#define MV2_ERR_MEDIAFILE_BASE			0x4000
//media codec module
#define MV2_ERR_MEDIACODEC_BASE			0x5000
//camera module
#define MV2_ERR_CAMERA_BASE				0x6000
//display module
#define MV2_ERR_DISPLAY_BASE			0x7000
//drm module
#define MV2_ERR_DRM_BASE				0x8000
//next module starts with 0x8000

#define MV2_ERR_RTMP_BASE				0x9000

#define MV2_ERR_GIF_BASE				0xA000

#define MV2_ERR_RTMP_SOCKET				(MV2_ERR_RTMP_BASE + 0x0001)
#define MV2_ERR_RTMP_URL				(MV2_ERR_RTMP_BASE + 0x0002)
#define MV2_ERR_RTMP_CONNECT			(MV2_ERR_RTMP_BASE + 0x0003)
#define MV2_ERR_RTMP_STREAM				(MV2_ERR_RTMP_BASE + 0x0004)
#define MV2_ERR_RTMP_SPSPPS				(MV2_ERR_RTMP_BASE + 0x0005)
#define MV2_ERR_RTMP_SPECIFIC			(MV2_ERR_RTMP_BASE + 0x0006)
#define MV2_ERR_START_CODE              (MV2_ERR_RTMP_BASE + 0x0007)
#define MV2_ERR_RTMP_SEND               (MV2_ERR_RTMP_BASE + 0x0008)
#define MV2_ERR_RTMP_NET_WORSE_START    (MV2_ERR_RTMP_BASE + 0x0009)
#define MV2_ERR_RTMP_NET_WORSE_END      (MV2_ERR_RTMP_BASE + 0x000a)
		

/*=============================================

	General Error Define

=============================================*/

#define MV2_ERR_UNKOWN					(MV2_ERR_GENERAL_BASE+1)
#define MV2_ERR_INVALID_PARAM			(MV2_ERR_GENERAL_BASE+2)		//invlaid parameter
#define MV2_ERR_MEM_NOT_ENGOUGH			(MV2_ERR_GENERAL_BASE+3)		// not enough memory
#define MV2_ERR_OPERATION_NOT_SUPPORT	(MV2_ERR_GENERAL_BASE+4)		// the method (operation) not support
#define MV2_ERR_NOT_READY				(MV2_ERR_GENERAL_BASE+5)		// not ready for operation
#define MV2_ERR_NOT_FOUND				(MV2_ERR_GENERAL_BASE+6)		//plugin or module not found
#define MV2_ERR_MEM_ALLOC				(MV2_ERR_GENERAL_BASE+7)		//Memory alloc faulure
#define MV2_ERR_NOT_INIT				(MV2_ERR_GENERAL_BASE+8)		//Variable have not yet init
#define MV2_ERR_EVENT_CREATE			(MV2_ERR_GENERAL_BASE+9)		//Create event failure
#define MV2_ERR_EVENT_SET				(MV2_ERR_GENERAL_BASE+10)		//set event singal failure
#define MV2_ERR_EVENT_RESET				(MV2_ERR_GENERAL_BASE+11)		//reset event  failure
#define MV2_ERR_EVENT_CLOSE				(MV2_ERR_GENERAL_BASE+12)		//close event  failure
#define MV2_ERR_ASYNC_PROC				(MV2_ERR_GENERAL_BASE+13)		// it is a async process (used for async method call )
#define MV2_ERR_NOT_QUERYTYPE			(MV2_ERR_GENERAL_BASE+14)		//query type not same as the module type
#define MV2_ERR_LIMITED_EVALUATION		(MV2_ERR_GENERAL_BASE+15)
#define MV2_ERR_USER_ABORT				(MV2_ERR_GENERAL_BASE+16)		//User abortes the process 
#define MV2_ERR_STORAGE_UNENOUGH		(MV2_ERR_GENERAL_BASE+17)		//have not enough storage to save the file
#define MV2_ERR_HTTP_NETWORK            (MV2_ERR_GENERAL_BASE+18)       //net error
#define MV2_ERR_UNSUPPORTDRM			(MV2_ERR_GENERAL_BASE+19)       //the file have unsupported drm protection        
#define MV2_ERR_STREAM_NOT_SET			(MV2_ERR_GENERAL_BASE+20) 	//stream has not set to player
#define MV2_ERR_OPERATION_FAIL			(MV2_ERR_GENERAL_BASE+21)


#define MV2_ERR_GET_PLUGIN				(MV2_ERR_GENERAL_BASE+50)	//failure to get the plugin
#define MV2_ERR_GET_PLUGIN_INPUTSTREAM	(MV2_ERR_GET_PLUGIN+1)		//failure to get the Input stream plugin
#define MV2_ERR_GET_PLUGIN_CAMERA		(MV2_ERR_GET_PLUGIN+2)		//failure to get the Camera plugin

//for file I/O
#define MV2_ERR_FILESTREAM_COMMON		(MV2_ERR_GENERAL_BASE+0x100)
#define MV2_ERR_FILESTREAM_OPEN			(MV2_ERR_FILESTREAM_COMMON+1)
#define MV2_ERR_FILESTREAM_READ			(MV2_ERR_FILESTREAM_COMMON+2)
#define MV2_ERR_FILESTREAM_WRITE		(MV2_ERR_FILESTREAM_COMMON+3)
#define MV2_ERR_FILESTREAM_SEEK			(MV2_ERR_FILESTREAM_COMMON+4)
#define MV2_ERR_FILESTREAM_END			(MV2_ERR_FILESTREAM_COMMON+5)

//For Streaming error report
#define MV2_ERR_STREAMING_GENERAL_BASE	(MV2_ERR_GENERAL_BASE+0x200)
#define MV2_ERR_STREAMING_NETWORK_BASE	(MV2_ERR_GENERAL_BASE+0x300)
#define MV2_ERR_STREAMING_SERVER_BASE		(MV2_ERR_GENERAL_BASE+0x400)

//Streaming General Error Begin
#define MV2_ERR_STREAMING_G_UNKNOWN		(MV2_ERR_STREAMING_GENERAL_BASE + 1)

//Streaming General Error End

//Streaming Network Error Begin
#define MV2_ERR_STREAMING_N_TIMEOUT			(MV2_ERR_STREAMING_NETWORK_BASE + 1)

//Streaming Network Error End

//Streaming Server Error Begin
#define MV2_ERR_STREAMING_S_BAD_REQUEST								(MV2_ERR_STREAMING_SERVER_BASE + 1)	//400
#define MV2_ERR_STREAMING_S_FORBIDDEN									(MV2_ERR_STREAMING_SERVER_BASE + 2)//403
#define MV2_ERR_STREAMING_S_NOT_FOUND								(MV2_ERR_STREAMING_SERVER_BASE + 3)//404
#define MV2_ERR_STREAMING_S_INTERNAL_SERVER_ERROR			(MV2_ERR_STREAMING_SERVER_BASE + 4)//500
#define MV2_ERR_STREAMING_S_INCOMPLETE_SDP						(MV2_ERR_STREAMING_SERVER_BASE + 5)//SDP Parsing failed

//Streaming Server Error End

//Streaming Error Code end (MV2_ERR_GENERAL_BASE+0x500)


/*=============================================

	Player Error Define

=============================================*/
#define MV2_ERR_PLAYER_WRONG_STATE			(MV2_ERR_PLAYER_BASE+1)		// in the wrong state
#define MV2_ERR_PLAYER_THREAD_INIT			(MV2_ERR_PLAYER_BASE+2)		// thread of player init fail
#define MV2_ERR_PLAYER_SAME_VIDEO_FRAME		(MV2_ERR_PLAYER_BASE+3)		// access same video frame with previous
#define MV2_ERR_PLAYER_AUDIO_UNDERFLOW		(MV2_ERR_PLAYER_BASE+4)		// the audio stream is underflow(no audio data)
#define MV2_ERR_PLAYER_VIDEO_UNDERFLOW		(MV2_ERR_PLAYER_BASE+5)		// the video stream is underflow(no video data)

/*=============================================

	Recorder Error Define

=============================================*/
#define MV2_ERR_RECORDER_WRONG_STATE			(MV2_ERR_RECORDER_BASE+1)		// in the wrong state
#define MV2_ERR_RECORDER_THREAD_INIT			(MV2_ERR_RECORDER_BASE+2)		// thread of recorder init fail
#define MV2_ERR_RECORDER_AUDIO_OVERFLOW			(MV2_ERR_RECORDER_BASE+3)
#define MV2_ERR_RECORDER_AUDIO_UNDERFLOW		(MV2_ERR_RECORDER_BASE+4)

#define MV2_ERR_AUDIOINPUT_BASE					(MV2_ERR_RECORDER_BASE+0x100)	//base err for audio input
#define MV2_ERR_AUDIO_INPUT_OPEN				(MV2_ERR_AUDIOINPUT_BASE+1)		//audio input open failure
#define MV2_ERR_AUDIO_INPUT_CLOSE				(MV2_ERR_AUDIOINPUT_BASE+2)		//audio input close failure
#define MV2_ERR_AUDIO_INPUT_RECORDING			(MV2_ERR_AUDIOINPUT_BASE+3)		//audio input recording failure
#define MV2_ERR_AUDIO_INPUT_PAUSE				(MV2_ERR_AUDIOINPUT_BASE+4)		//audio input pause failure
#define MV2_ERR_AUDIO_INPUT_STOP				(MV2_ERR_AUDIOINPUT_BASE+5)		//audio input stop failure

/*=============================================

	Media stream Error Define

=============================================*/
//for output mediastream
#define MV2_ERR_MEDIASTREAM_VIDEOEND			(MV2_ERR_MEDIASTREAM_BASE+1)//video finish
#define MV2_ERR_MEDIASTREAM_AUDIOEND			(MV2_ERR_MEDIASTREAM_BASE+2)//audio finish
#define MV2_ERR_MEDIASTREAM_VIDEONOTREADY		(MV2_ERR_MEDIASTREAM_BASE+3)//Video data not ready
#define MV2_ERR_MEDIASTREAM_AUDIONOTREADY		(MV2_ERR_MEDIASTREAM_BASE+4)//Audio data not ready
#define MV2_ERR_MEDIASTREAM_AUDIODECODE 		(MV2_ERR_MEDIASTREAM_BASE+5)//Audio decode filure
#define MV2_ERR_MEDIASTREAM_AUDIOSEEK 	 		(MV2_ERR_MEDIASTREAM_BASE+6)//Audio seek filure
//only for amoi(1389) project
#define MV2_ERR_MEDIASTREAM_PP_INIT				(MV2_ERR_MEDIASTREAM_BASE+7)//can't init pp(post process)
#define MV2_ERR_MEDIASTREAM_TEXTEND				(MV2_ERR_MEDIASTREAM_BASE+8)//timed text finish
#define MV2_ERR_MEDIASTREAM_WRITER_HEADER		(MV2_ERR_MEDIASTREAM_BASE+9)//timed text finish


//for input mediastream
#define MV2_ERR_MEDIASTREAM_INPUT				(MV2_ERR_MEDIASTREAM_BASE+50)//Basic err for input stream
#define MV2_ERR_MEDIASTREAM_HAVESETVIDEOINFO	(MV2_ERR_MEDIASTREAM_INPUT+1)//have aleady set the video info to the input stream
#define MV2_ERR_MEDIASTREAM_VIDEOENCODE			(MV2_ERR_MEDIASTREAM_INPUT+2)//video encode error
#define MV2_ERR_MEDIASTREAM_AUDIOENCODE			(MV2_ERR_MEDIASTREAM_INPUT+3)//audio encode error
#define MV2_ERR_MEDIASTREAM_CILP_OVERFLOW		(MV2_ERR_MEDIASTREAM_INPUT+4)//Beyond by the max size of clip recorded.



/*=============================================

	Media stream Error Define --- for MIDI Stream

=============================================*/
#define MV2_ERR_MEDIASTREAM_MIDI_BASE			(MV2_ERR_MEDIASTREAM_BASE+0x800)//MIDI err base
#define MV2_ERR_MEDIASTREAM_MIDI_CLOSE			(MV2_ERR_MEDIASTREAM_MIDI_BASE+1)//midi close failure
#define MV2_ERR_MEDIASTREAM_MIDI_OPEN			(MV2_ERR_MEDIASTREAM_MIDI_BASE+2)//midi open handle failure
#define MV2_ERR_MEDIASTREAM_MIDI_SEEK			(MV2_ERR_MEDIASTREAM_MIDI_BASE+3)//seek the position failure
#define MV2_ERR_MEDIASTREAM_MIDI_GET_FORMAT 	(MV2_ERR_MEDIASTREAM_MIDI_BASE+4)//get the midi format failure
#define MV2_ERR_MEDIASTREAM_MIDI_GET_POSITION	(MV2_ERR_MEDIASTREAM_MIDI_BASE+5)//get the decode position failure
#define MV2_ERR_MEDIASTREAM_MIDI_DECODE			(MV2_ERR_MEDIASTREAM_MIDI_BASE+6)//decode the midi failure
#define MV2_ERR_MEDIASTREAM_MIDI_UNKOWN			(MV2_ERR_MEDIASTREAM_MIDI_BASE+7)//unkown err
#define MV2_ERR_MEDIASTREAM_MIDI_SETPATCH		(MV2_ERR_MEDIASTREAM_MIDI_BASE+7)//set midi patch path





/*=============================================

	Media file Error Define

=============================================*/
#define MV2_ENCODER_INIT_FAIL               (MV2_ERR_MEDIAFILE_BASE+1)
#define MV2_ERR_UNKNOWN_BOX					(MV2_ERR_MEDIAFILE_BASE+2)
#define MV2_ERR_BOX_ISNULL                  (MV2_ERR_MEDIAFILE_BASE+3)
#define MV2_ERR_NO_COPYRIGHTINFO            (MV2_ERR_MEDIAFILE_BASE+5)
#define MV2_ERR_NOTSUPPORT_FILE             (MV2_ERR_MEDIAFILE_BASE+6)
#define MV2_ERR_NO_ENTRY                    (MV2_ERR_MEDIAFILE_BASE+7)
#define MV2_ERR_NOTSUPPORT_CODEC 			(MV2_ERR_MEDIAFILE_BASE+8)            
#define MV2_ERR_SPLITER_SEEKTOEND			(MV2_ERR_MEDIAFILE_BASE+9) //inditify that have seeked to end
#define MV2_ERR_SPLITER_SEEK_ERROR			(MV2_ERR_MEDIAFILE_BASE+10)
#define MV2_ERR_SPLITER_ASME_NETWORK		(MV2_ERR_MEDIAFILE_BASE+11)
#define MV2_ERR_UNKOWNCONFIG                (MV2_ERR_MEDIAFILE_BASE+12)
#define MV2_ERR_SPLITER_DATAEND             (MV2_ERR_MEDIAFILE_BASE+13)
#define MV2_ERR_SPLITER_NEXT_PACKET_LOST	(MV2_ERR_MEDIAFILE_BASE+14)
#define MV2_ERR_SPLITER_PACKET_IN_FRAME_LOST (MV2_ERR_MEDIAFILE_BASE+15)
#define MV2_ERR_INPUT_BUFFER_UNDERFLOW		(MV2_ERR_MEDIAFILE_BASE+16)  //Input data buffer too small
#define MV2_ERR_OUTPUT_BUFFER_OVERFLOW		(MV2_ERR_MEDIAFILE_BASE+17)  //Output buffer too small

#define MV2_ERR_SPLITER_ALREADY_OPENED		(MV2_ERR_MEDIAFILE_BASE+18)
#define MV2_ERR_SPLITER_MEDIADATA			(MV2_ERR_MEDIAFILE_BASE+19)

#define MV2_ERR_MP4_COMMON					(MV2_ERR_MEDIAFILE_BASE+0x100)
#define MV2_ERR_MP4_HEADER					(MV2_ERR_MP4_COMMON+1)
#define MV2_ERR_MP4_MEDIADATA				(MV2_ERR_MP4_COMMON+2)

#define MV2_ERR_ASF_COMMON					(MV2_ERR_MEDIAFILE_BASE+0x200)
#define MV2_ERR_ASF_HEADER					(MV2_ERR_ASF_COMMON+1)
#define MV2_ERR_ASF_MEDIADATA				(MV2_ERR_ASF_COMMON+2)
//for amr spliter err
#define MV2_ERR_AMR_BASE					(MV2_ERR_MEDIAFILE_BASE+0x300)//base
#define MV2_ERR_AMR_COMMON					(MV2_ERR_AMR_BASE+0x1)//common base
#define MV2_ERR_AMR_OPEN_FILE				(MV2_ERR_AMR_BASE+0x2)//open the file err
#define MV2_ERR_AMR_READ_AMR_HEAD			(MV2_ERR_AMR_BASE+0x3)//read the amr head
#define MV2_ERR_AMR_NOT_AMR					(MV2_ERR_AMR_BASE+0x4)//the file is not amr format
#define MV2_ERR_AMR_READ					(MV2_ERR_AMR_BASE+0x5)//read file failure
#define MV2_ERR_AMR_SEEK					(MV2_ERR_AMR_BASE+0x6)//seek file failure

//for evc spliter err
#define MV2_ERR_EVC_BASE					(MV2_ERR_MEDIAFILE_BASE+0x300)//base
#define MV2_ERR_EVC_COMMON					(MV2_ERR_EVC_BASE+0x1)//common base
#define MV2_ERR_EVC_OPEN_FILE				(MV2_ERR_EVC_BASE+0x2)//open the file err
#define MV2_ERR_EVC_READ_EVC_HEAD			(MV2_ERR_EVC_BASE+0x3)//read the amr head
#define MV2_ERR_EVC_NOT_AMR					(MV2_ERR_EVC_BASE+0x4)//the file is not amr format
#define MV2_ERR_EVC_READ					(MV2_ERR_EVC_BASE+0x5)//read file failure
#define MV2_ERR_EVC_SEEK					(MV2_ERR_EVC_BASE+0x6)//seek file failure

//for amr spliter err
#define MV2_ERR_WAVE_BASE					(MV2_ERR_MEDIAFILE_BASE+0x400)//base
#define MV2_ERR_WAVE_COMMON					(MV2_ERR_WAVE_BASE+0x1)//common base
#define MV2_ERR_WAVE_READ					(MV2_ERR_WAVE_BASE+0x2)//read file failure

//for avi spliter err                                   
#define MV2_ERR_AVI_BASE					(MV2_ERR_MEDIAFILE_BASE+0x500)//base
#define MV2_ERR_AVI_RESET					(MV2_ERR_AVI_BASE+1)  //Reset error
#define MV2_ERR_AVI_OPEN					(MV2_ERR_AVI_BASE+2)  //Open media file error
#define MV2_ERR_AVI_CLOSE					(MV2_ERR_AVI_BASE+3)  //close media file error
#define MV2_ERR_AVI_GETFILEINFO				(MV2_ERR_AVI_BASE+4)  //Get file inforamtion error
#define MV2_ERR_AVI_GETVINFO				(MV2_ERR_AVI_BASE+5)  //Get Video inforamtion error
#define MV2_ERR_AVI_GETAINFO				(MV2_ERR_AVI_BASE+6)  //Get audio inforamtion error
#define MV2_ERR_AVI_READVIDEO				(MV2_ERR_AVI_BASE+7)  //read video frame error
#define MV2_ERR_AVI_READAUDIO				(MV2_ERR_AVI_BASE+8)  //read audio frame error
#define MV2_ERR_AVI_SEEKAUDIO				(MV2_ERR_AVI_BASE+9)  //read audio frame error
#define MV2_ERR_AVI_SEEKVIDEO				(MV2_ERR_AVI_BASE+10)  //read audio frame error
#define MV2_ERR_AVI_GETCONFIG				(MV2_ERR_AVI_BASE+11)  //GetConfig error
#define MV2_ERR_AVI_MEDIADATA				(MV2_ERR_AVI_BASE+12)  //

//for AAC error
#define MV2_ERR_AAC_BASE					(MV2_ERR_MEDIAFILE_BASE+0x600)//base
#define MV2_ERR_AAC_OPEN_FILE					(MV2_ERR_AAC_BASE+1)  //open file error
#define MV2_ERR_AAC_GET_INFO					(MV2_ERR_AAC_BASE+2)  //AAC file get info
#define MV2_ERR_AAC_READ_FRAME					(MV2_ERR_AAC_BASE+3)  //Read a frame error
#define MV2_ERR_AAC_FILE_FORMAT					(MV2_ERR_AAC_BASE+4)  //not support format
#define MV2_ERR_AAC_FILE_SEEK					(MV2_ERR_AAC_BASE+5)  //AAC SEEK ERROR
#define MV2_ERR_AAC_FILE_RESET					(MV2_ERR_AAC_BASE+6)  //Reset failure

//for  MP3 error
#define MV2_ERR_MP3_BASE					(MV2_ERR_MEDIAFILE_BASE+0x550)//base
#define MV2_ERR_MP3_OPEN_FILE				(MV2_ERR_MP3_BASE+1)  //open file error
#define MV2_ERR_MP3_GET_INFO				(MV2_ERR_MP3_BASE+2)  //MP3 file get info
#define MV2_ERR_MP3_READ_FRAME				(MV2_ERR_MP3_BASE+3)  //Read a frame error
#define MV2_ERR_MP3_FILE_FORMAT				(MV2_ERR_MP3_BASE+4)  //not support format
#define MV2_ERR_MP3_FILE_SEEK				(MV2_ERR_MP3_BASE+5)  //MP3 SEEK ERROR 



/*=============================================

	Display stream Error Define

=============================================*/
#define MV2_ERR_DISPLAY_ALREADY_INIT        (MV2_ERR_DISPLAY_BASE + 1)
#define MV2_ERR_DISPLAY_INIT_FAIL           (MV2_ERR_DISPLAY_BASE + 2)
#define MV2_ERR_DISPLAY_UNINIT_FAIL         (MV2_ERR_DISPLAY_BASE + 3)
#define MV2_ERR_DISPLAY_GAPI_FAIL           (MV2_ERR_DISPLAY_BASE + 4)
#define MV2_ERR_DISPLAY_NOT_INIT            (MV2_ERR_DISPLAY_BASE + 5)
#define MV2_ERR_DISPLAY_DEVICE_FAIL         (MV2_ERR_DISPLAY_BASE + 6)
#define MV2_ERR_DISPLAY_DRAW_FAIL           (MV2_ERR_DISPLAY_BASE + 7)
#define MV2_ERR_DISPLAY_SHOWOVERLAY_FAIL    (MV2_ERR_DISPLAY_BASE + 8)

//for audio output
#define MV2_ERR_AUDIO_BASE					(MV2_ERR_DISPLAY_BASE + 50)
#define MV2_ERR_AUDIO_OUTPUT_OPEN           (MV2_ERR_AUDIO_BASE + 1)		//the audio output open failure
#define MV2_ERR_AUDIO_OUTPUT_SETVOL         (MV2_ERR_AUDIO_BASE + 2)		//the audio output set volume failure
#define MV2_ERR_AUDIO_OUTPUT_GETVOL         (MV2_ERR_AUDIO_BASE + 3)		//the audio output get volume failure
#define MV2_ERR_AUDIO_OUTPUT_CLOSE          (MV2_ERR_AUDIO_BASE + 4)		//close the audio output failure
#define MV2_ERR_AUDIO_OUTPUT_PAUSE          (MV2_ERR_AUDIO_BASE + 5)		//pause the audio output failure
#define MV2_ERR_AUDIO_OUTPUT_STOP           (MV2_ERR_AUDIO_BASE + 6)		//stop the audio output failure
#define MV2_ERR_AUDIO_OUTPUT_PLAYING	    (MV2_ERR_AUDIO_BASE + 7)		//playing the audio output failure
#define MV2_ERR_AUDIO_OUTPUT_RESUME	    	(MV2_ERR_AUDIO_BASE + 8)		//resume the audio output failure
#define MV2_ERR_AUDIO_OUTPUT_NOAUIDOTRACK	(MV2_ERR_AUDIO_BASE + 9)		//Means there is no auido track in the file

/*=============================================

	media codec Error Define

=============================================*/
#define MV2_ERR_MEDIACODEC_GENERAL_BASE						(MV2_ERR_MEDIACODEC_BASE + 0x00)
#define MV2_ERR_MEDIACODEC_MPEG4_BASE						(MV2_ERR_MEDIACODEC_BASE + 0x100)
#define MV2_ERR_MEDIACODEC_H263_BASE						(MV2_ERR_MEDIACODEC_BASE + 0x200)
#define MV2_ERR_MEDIACODEC_AMR_BASE							(MV2_ERR_MEDIACODEC_BASE + 0x300)
#define MV2_ERR_MEDIACODEC_H264_BASE						(MV2_ERR_MEDIACODEC_BASE + 0x400)
#if defined(_SUPPORT_LINUX_)
#define MV2_ERR_MEDIACODEC_NVENCGL_BASE						(MV2_ERR_MEDIACODEC_BASE + 0x500)//nvidiaGLencoder.cpp
#define MV2_ERR_MEDIACODEC_NVENCODER_BASE					(MV2_ERR_MEDIACODEC_BASE + 0x600)//nvidiaGLencoder.cpp
#define MV2_ERR_MEDIACODEC_NVENCODERGL_BASE					(MV2_ERR_MEDIACODEC_BASE + 0x700)//nvidiaGLencoder.cpp
#define MV2_ERR_MEDIACODEC_NVIDIADECODER_BASE				(MV2_ERR_MEDIACODEC_BASE + 0x800)
#endif
/*=============================================

	media codec Error Define -- for general

=============================================*/

#define MV2_ERR_MEDIACODEC_GENERAL_UNKOWN					(MV2_ERR_MEDIACODEC_GENERAL_BASE + 1) //unkown error
#define MV2_ERR_MEDIACODEC_DECODE_FAILURE					(MV2_ERR_MEDIACODEC_GENERAL_BASE + 2) //decode failure
#define MV2_ERR_MEDIACODEC_ENCODE_FAILURE					(MV2_ERR_MEDIACODEC_GENERAL_BASE + 3) //encode failure
#define MV2_ERR_MEDIACODEC_NOT_INIT							(MV2_ERR_MEDIACODEC_GENERAL_BASE + 4) //not init the handle
#define MV2_ERR_MEDIACODEC_INIT_FAILURE						(MV2_ERR_MEDIACODEC_GENERAL_BASE + 5) //initialize is failure
#define MV2_ERR_MEDIACODEC_NOT_FOUND						(MV2_ERR_MEDIACODEC_GENERAL_BASE + 6) //not find the codec
#define MV2_ERR_MEDIACODEC_CALLBACK						    (MV2_ERR_MEDIACODEC_GENERAL_BASE + 7) //preprocess callback error
#define MV2_ERR_MEDIACODEC_UNSUPPORT					    (MV2_ERR_MEDIACODEC_GENERAL_BASE + 8) //codec unsupport
#define MV2_ERR_MEDIACODEC_FATAL						    (MV2_ERR_MEDIACODEC_GENERAL_BASE + 9) //fatal error
#define MV2_ERR_MEDIACODEC_MULTI_FRAME						(MV2_ERR_MEDIACODEC_GENERAL_BASE + 10)//multi frame output, for B-P frame
#define MV2_ERR_VIDEOCODEC_UNSUPPORT						(MV2_ERR_MEDIACODEC_GENERAL_BASE + 11)//Video codec Unsupport
#define MV2_ERR_AUDIOCODEC_UNSUPPORT						(MV2_ERR_MEDIACODEC_GENERAL_BASE + 12)//Audio codec Unsupport
#define MV2_ERR_MEDIACODEC_ASYNC							(MV2_ERR_MEDIACODEC_GENERAL_BASE + 13)//async codec,codec data will return via async callback
#define MV2_ERR_MEDIACODEC_HWDEC_EXCEPTION                  (MV2_ERR_MEDIACODEC_GENERAL_BASE + 14)
#define MV2_ERR_MEDIACODEC_HWENC_EXCEPTION                  (MV2_ERR_MEDIACODEC_GENERAL_BASE + 15)

/*=============================================

	media codec Error Define -- for mpeg4

=============================================*/
#define MV2_ERR_MEDIACODEC_MPEG4_SETDEBLOCK_FAILURE			(MV2_ERR_MEDIACODEC_MPEG4_BASE + 1) //MPEG4 Set deblock failure
#define MV2_ERR_MEDIACODEC_MPEG4_OPEN_FAILURE				(MV2_ERR_MEDIACODEC_MPEG4_BASE + 2) //MPEG4 Open failure
#define MV2_ERR_MEDIACODEC_MPEG4_GET_PARA_FAILURE			(MV2_ERR_MEDIACODEC_MPEG4_BASE + 3) //MPEG4 Get parameter failure
#define MV2_ERR_MEDIACODEC_MPEG4_CREATE_HANDLE_FAILURE		(MV2_ERR_MEDIACODEC_MPEG4_BASE + 4) //MPEG4 Create handle failure
/*=============================================

	media codec Error Define -- for h263

=============================================*/
#define MV2_ERR_MEDIACODEC_H263_SETDEBLOCK_FAILURE			(MV2_ERR_MEDIACODEC_H263_BASE + 1) //H263 Set deblock failure
#define MV2_ERR_MEDIACODEC_H263_GET_PARA_FAILURE			(MV2_ERR_MEDIACODEC_H263_BASE + 2) //H263 Get parameter failure
#define MV2_ERR_MEDIACODEC_H263_OPEN_FAILURE				(MV2_ERR_MEDIACODEC_H263_BASE + 3) //H263 Open failure
#define MV2_ERR_MEDIACODEC_H263_CREATE_HANDLE_FAILURE		(MV2_ERR_MEDIACODEC_H263_BASE + 4) //H263 Create handle failure

/*=============================================

	media codec Error Define -- for h264

=============================================*/
#define MV2_ERR_MEDIACODEC_H264_GET_PARA_FAILURE			(MV2_ERR_MEDIACODEC_H264_BASE + 1) //H264 Get parameter failure
#define MV2_ERR_MEDIACODEC_H264_OPEN_FAILURE				(MV2_ERR_MEDIACODEC_H264_BASE + 2) //H264 Open failure
#define MV2_ERR_MEDIACODEC_H264_CREATE_HANDLE_FAILURE		(MV2_ERR_MEDIACODEC_H264_BASE + 3) //H264 Create handle failure
#define MV2_ERR_MEDIACODEC_H264_INPUT_UNDERFLOW				(MV2_ERR_MEDIACODEC_H264_BASE + 4) //H264 input data underflow	
#define MV2_ERR_MEDIACODEC_H264_INPUT_OVERFLOW				(MV2_ERR_MEDIACODEC_H264_BASE + 5) //H264 input data overflow	

/*=============================================

	Camera Error Define 

=============================================*/
#define MV2_ERR_CAMERA_INIT_FAILURE			                (MV2_ERR_CAMERA_BASE + 1)   //Initalize failure
#define MV2_ERR_CAMERA_START_FAILURE			            (MV2_ERR_CAMERA_BASE + 2)   //Initalize failure
#define MV2_ERR_CAMERA_GETFRAME_FAILURE	                    (MV2_ERR_CAMERA_BASE + 3)   //Get frame data failure         
#define MV2_ERR_CAMERA_OPEN_FAILURE	                        (MV2_ERR_CAMERA_BASE + 4)   //open camera failure
#define MV2_ERR_CAMERA_CLOSE_FAILURE	                    (MV2_ERR_CAMERA_BASE + 5)   //close camera falilure
#define MV2_ERR_CAMERA_BUFEMPTY								(MV2_ERR_CAMERA_BASE + 6)   //Read buf empty
#define MV2_ERR_CAMERA_STATUS_INVALID						(MV2_ERR_CAMERA_BASE + 7)   //invalid status
#define MV2_ERR_CAMERA_CONFIGCAPTURE						(MV2_ERR_CAMERA_BASE + 8)   //config capture failure
#define MV2_ERR_CAMERA_NOTSUPPORT_PROPERTY					(MV2_ERR_CAMERA_BASE + 9)   //Camera not support this property set
#define MV2_ERR_CAMERA_PROPERTY								(MV2_ERR_CAMERA_BASE + 10)   //Camera's property set err
#define MV2_ERR_CAMERA_SHOWPREVIEW							(MV2_ERR_CAMERA_BASE + 11)   //start preview error
#define MV2_ERR_CAMERA_PARAM								(MV2_ERR_CAMERA_BASE + 12)   //set error param to camera
#define MV2_ERR_CAMERA_DURATION_EXCEEDED                    (MV2_ERR_CAMERA_BASE + 13)   //set error param to camera
#define MV2_ERR_CAMERA_SIZE_EXCEEDED						(MV2_ERR_CAMERA_BASE + 14)   //set error param to camera
#define MV2_ERR_CAMERA_DATA_UNSUPPORTED                     (MV2_ERR_CAMERA_BASE + 15)   //camera data type not supported

#define MV2_ERR_CAMERA_AVASSETWRITER_FAILURE                (MV2_ERR_CAMERA_BASE + 16)   //camera data type not supported
#define MV2_ERR_CAMERA_TIME_ERROR                           (MV2_ERR_CAMERA_BASE + 18)   //camera data type not supported
/*=============================================

	Drm Error Define 

=============================================*/
#define MV2_ERR_DRM_AGENTINIT_FAILURE			                (MV2_ERR_DRM_BASE + 1)   //Initalize failure
#define MV2_ERR_DRM_CANNOTGET_INIDATALENGTH						(MV2_ERR_DRM_BASE + 2)   //can't get the length of data to initial the drm agent





/*
 *     New definition of error segment for mediabase:
 *         if you add a new cpp-file to mediabase module, and need a new error-segment, please define it here
 *     PAY ATTENTION TO THIS:
 *         Usually, 256 error-definitions are enough for one cpp-file, so the error-segment step is 0x00000100
 *         If that's not enough, you can use two steps, or more steps...
 */
#define MBERR_AIFF_BASE (MERR_MEDIA_BASE) //0x00500000  mv2audioinputfromfile.cpp
//#define MBERR_TEST_A_BASE (MERR_MEDIA_BASE+0x00000100) //0x00500100
//#define MBERR_TEST_B_BASE (MERR_MEDIA_BASE+0x00000200) //0x00500200


#define MVLIB_ERR_BASE               0x00700000
#define MVLIB_ERR_NONE			     0

#define	MVLIB_ERR_PLT_CAP_BASE		(MVLIB_ERR_BASE + 0x10000)
#define	MVLIB_ERR_SW_AREADER_BASE		(MVLIB_ERR_BASE + 0x11000)
#define	MVLIB_ERR_SW_AREADER_WAV_BASE		(MVLIB_ERR_BASE + 0x12000)
#define	MVLIB_ERR_H264_UTIL_BASE		(MVLIB_ERR_BASE + 0x13000)
#define	MVLIB_ERR_H263_UTIL_BASE		(MVLIB_ERR_BASE + 0x14000)
#define	MVLIB_ERR_FF_SWS_BASE		(MVLIB_ERR_BASE + 0x15000)
#define	MVLIB_ERR_GIF_UTIL_BASE		(MVLIB_ERR_BASE + 0x16000)
#define	MVLIB_ERR_GIF_UTIL_IOS_BASE		(MVLIB_ERR_BASE + 0x17000)
#define	MVLIB_ERR_PNG_UTIL_IOS_BASE		(MVLIB_ERR_BASE + 0x18000)
#define	MVLIB_ERR_FF_DEC_BASE		(MVLIB_ERR_BASE + 0x19000)
#define	MVLIB_ERR_FF_ENC_BASE		(MVLIB_ERR_BASE + 0x1a000)
#define	MVLIB_ERR_H263_DEC_BASE		(MVLIB_ERR_BASE + 0x1b000)
#define	MVLIB_ERR_MPEG4_DEC_BASE		(MVLIB_ERR_BASE + 0x1c000)
#define	MVLIB_ERR_MPEG4_ENC_BASE		(MVLIB_ERR_BASE + 0x1d000)
#define	MVLIB_ERR_FAAC_ENC_BASE		(MVLIB_ERR_BASE + 0x1e000)
#define	MVLIB_ERR_FAAC_DEC_BASE		(MVLIB_ERR_BASE + 0x1f000)
#define	MVLIB_ERR_AVF_SPLT_BASE		(MVLIB_ERR_BASE + 0x20000)
#define	MVLIB_ERR_FF_MUX_BASE		(MVLIB_ERR_BASE + 0x21000)
#define	MVLIB_ERR_FF_SPLT_BASE		(MVLIB_ERR_BASE + 0x22000)
#define	MVLIB_ERR_GIF_MUX_BASE		(MVLIB_ERR_BASE + 0x23000)
#define	MVLIB_ERR_RTMP_MUX_BASE		(MVLIB_ERR_BASE + 0x24000)
#define	MVLIB_ERR_MIS_BASE		(MVLIB_ERR_BASE + 0x25000)
#define	MVLIB_ERR_MIS_IOS_BASE		(MVLIB_ERR_BASE + 0x26000)
#define	MVLIB_ERR_MOS_BASE		(MVLIB_ERR_BASE + 0x27000)
#define	MVLIB_ERR_MOS_IOS_BASE		(MVLIB_ERR_BASE + 0x28000)
#define	MVLIB_ERR_MOSM_BASE		(MVLIB_ERR_BASE + 0x29000)
#define	MVLIB_ERR_PLT_AO_BASE		(MVLIB_ERR_BASE + 0x2a000)
#define	MVLIB_ERR_PLAYER_BASE		(MVLIB_ERR_BASE + 0x2b000)
#define	MVLIB_ERR_PLAYER_UTIL_BASE		(MVLIB_ERR_BASE + 0x2c000)
#define	MVLIB_ERR_SPLAYER_BASE		(MVLIB_ERR_BASE + 0x2d000)
#define	MVLIB_ERR_V_AO_BASE		(MVLIB_ERR_BASE + 0x2e000)
#define	MVLIB_ERR_PLUGM_BASE		(MVLIB_ERR_BASE + 0x2f000)
#define	MVLIB_ERR_AIFF_BASE		(MVLIB_ERR_BASE + 0x30000)
#define	MVLIB_ERR_MISM_BASE		(MVLIB_ERR_BASE + 0x31000)
#define	MVLIB_ERR_PLT_AI_BASE		(MVLIB_ERR_BASE + 0x32000)
#define	MVLIB_ERR_REC_BASE		(MVLIB_ERR_BASE + 0x33000)
#define	MVLIB_ERR_REC_UTIL_BASE		(MVLIB_ERR_BASE + 0x34000)
#define	MVLIB_ERR_STAT_BASE		(MVLIB_ERR_BASE + 0x35000)
#define	MVLIB_ERR_RTMP_PUSH_IOS_BASE		(MVLIB_ERR_BASE + 0x36000)
#define	MVLIB_ERR_RTMP_PUSH_AVA_IOS_BASE		(MVLIB_ERR_BASE + 0x37000)
#define	MVLIB_ERR_RTMP_PUSH_VTB_BASE		(MVLIB_ERR_BASE + 0x38000)
#define	MVLIB_ERR_SSINK_BASE		(MVLIB_ERR_BASE + 0x39000)
#define	MVLIB_ERR_SSRC_BASE		(MVLIB_ERR_BASE + 0x3a000)
#define	MVLIB_ERR_HW_VREADER_BASE		(MVLIB_ERR_BASE + 0x3b000)
#define	MVLIB_ERR_HW_VREADER_POOL_BASE		(MVLIB_ERR_BASE + 0x3c000)
#define	MVLIB_ERR_HW_VWRITER_DLL_BASE		(MVLIB_ERR_BASE + 0x3d000)
#define	MVLIB_ERR_HW_VWRITER_BASE		(MVLIB_ERR_BASE + 0x3e000)
#define	MVLIB_ERR_SW_VREADER_BASE		(MVLIB_ERR_BASE + 0x3f000)
#define	MVLIB_ERR_SW_VWRITER_BASE		(MVLIB_ERR_BASE + 0x40000)
#define	MVLIB_ERR_CAMNG_BASE		(MVLIB_ERR_BASE + 0x41000)
#define	MVLIB_ERR_COMM_KO_LINUX_BASE		(MVLIB_ERR_BASE + 0x42000)
#define	MVLIB_ERR_COMM_AFP_BASE		(MVLIB_ERR_BASE + 0x43000)
#define	MVLIB_ERR_COMM_ALCK_BASE		(MVLIB_ERR_BASE + 0x44000)
#define	MVLIB_ERR_COMM_BM_BASE		(MVLIB_ERR_BASE + 0x45000)
#define	MVLIB_ERR_COMM_HF_BASE		(MVLIB_ERR_BASE + 0x46000)
#define	MVLIB_ERR_COMM_KO_BASE		(MVLIB_ERR_BASE + 0x47000)
#define	MVLIB_ERR_COMM_QB_BASE		(MVLIB_ERR_BASE + 0x48000)
#define	MVLIB_ERR_COMM_RA_BASE		(MVLIB_ERR_BASE + 0x49000)
#define	MVLIB_ERR_COMM_PM_BASE		(MVLIB_ERR_BASE + 0x4a000)
#define MVLIB_ERR_H265_UTIL_BASE    (MVLIB_ERR_BASE + 0x4b000)

#define MVLIB_ERR_MCAAC_DEC_BASE	(MVLIB_ERR_BASE + 0x4b000)
#define MVLIB_ERR_MCAAC_ENC_BASE	(MVLIB_ERR_BASE + 0x4c000)

#define MVLIB_ERR_MC_SPLT_BASE	(MVLIB_ERR_BASE + 0x4d000)
#define MVLIB_ERR_MC_MUX_BASE	(MVLIB_ERR_BASE + 0x4e000)
#define MVLIB_ERR_XYMP4_MUX_BASE	(MVLIB_ERR_BASE + 0x4f000)
#define MVLIB_MEDIA_HELP_IOS_BASE    (MVLIB_ERR_BASE + 0x51000)
#define MVLIB_MEDIA_INVERSE_IOS_BASE    (MVLIB_ERR_BASE + 0x52000)
#define MVLIB_MEDIA_INVERSE_DEC_THREAD_IOS_BASE    (MVLIB_ERR_BASE + 0x53000)
#define MVLIB_ERR_SWAP_CACHE_BASE    (MVLIB_ERR_BASE + 0x54000)
#define MVLIB_ERR_JPEG_DECODE_BASE  (MVLIB_ERR_BASE + 0x56000)

#endif
 
