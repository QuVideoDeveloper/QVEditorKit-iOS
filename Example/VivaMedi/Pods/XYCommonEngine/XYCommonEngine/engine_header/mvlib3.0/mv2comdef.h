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
 * mv2comdef.h
 *
 * Description:
 *
 *	The common used marco and structure  in MVLIB2.0
 *
 *
 * History
 *    
 *  07.26.2004 Sheng Han(shan@arcsoft.com.cn )   
 * - initial version 
 *
 */

 #ifndef _MV2COMDEF_H_
 #define _MV2COMDEF_H_

#include "amcomdef.h"
#include "amstring.h"

#ifndef MVLIB_MAXPATH
	#if defined (_LINUX_) || (__IPHONE__)
		#define MVLIB_MAXPATH 1024
	#elif defined(_WINCE_)
		#define MVLIB_MAXPATH 260
	#else
		#define MVLIB_MAXPATH 256
	#endif //(_LINUX_)
#endif


#ifdef __cplusplus
extern "C"
{
#endif //__cplusplus
////////// Supported module type ID in MVLIB2.0 //////////////

#define MAX_SEND_TIME_COST      1000    // ms

#define MV2_MODULE_TYPE_PLAYER						'plyr'	//1886157170	//player module with IMV2Player interface
#define MV2_MODULE_TYPE_RECORDER					'recd'	//1919247204	//recorder module with IMV2Recorder interface
#define MV2_MODULE_TYPE_DISPLAY						'disp'	//1684632432	//display module with IMV2Display interface
#define MV2_MODULE_TYPE_CAMERA						'camr'	//1667329394	//camera module with IMV2Camera interface
#define MV2_MODULE_TYPE_OUTPUTSTREAM					'outs'  //output stream main type

#define MV2_MODULE_TYPE_MEDIAINPUTSTREAM				'mips'	//1835626611	//media  inputstream module with IMV2MediaInputStream interface
#define MV2_MODULE_TYPE_SPLITER						'splt'	//1936747636	// media file spliter module with IMV2Spliter interface
#define MV2_MODULE_TYPE_MUXER						'muxr'	//1836415090	// media file muxer module with INV2Muxer interface
#define MV2_MODULE_TYPE_ENCODER						'encd'	//1701733220	// media encoder module with IMV2Encoder interface
#define MV2_MODULE_TYPE_DECODER						'decd'	//1684366180	// media decoder module with IMV2Decoder interface
#define MV2_MODULE_TYPE_AMOI_DECODER				'deca'	//1684366177	// only for amoi(1389) project 
#define MV2_MODULE_TYPE_VIDEO_READER				'vrdr'	//IMV2VideoReader
#define MV2_MODULE_TYPE_AUDIO_READER				'ardr'	//IMV2AudioReader

//for Video writer
#define MV2_MODULE_TYPE_VIDEO_WRITER				'vwtr'     //1987540082 IMV2VideoWriter

#define MV2_WRITER_TYPE_HW							'whw'	  //7825527 hw writer
#define MV2_WRITER_TYPE_SW							'wsw'	  //7828343 sw writer

//subtype for reader
#define MV2_READER_TYPE_SW							'sw'	//sw
#define MV2_READER_TYPE_SW_WAV						'wav '
#define MV2_READER_TYPE_HW							'hw'	//hw
#define MV2_READER_TYPE_HW_POOL						'hwpl'	//hw

//use h/w or s/w codec
#define MV2_USE_HW_CODEC_ONLY		                   0x00000001
#define MV2_USE_SW_CODEC_ONLY                     	   0x00000002
#define MV2_USE_HW_CODEC_AUTO					       0x00000004
#define MV2_USE_THUMBNAIL        					   0x00000008
#define MV2_USE_PLAYBACK_THUMBNAIL         			   0x00000010

//subtype for outputstream
#define MV2_MODULE_TYPE_MIDOUTPUTSTREAM			    'mid '	//1835623456  //media outputstream module iwth IMV2MediaOutputStream interface
#define MV2_MODULE_TYPE_MIDIOUTPUTSTREAM			'midi'	//1835623529  //media outputstream module iwth IMV2MediaOutputStream interface
#define MV2_MODULE_TYPE_AACOUTPUTSTREAM				'aac '	////1633772320  //media outputstream module iwth IMV2MediaOutputStream interface
#define MV2_MODULE_TYPE_MEDIAOUTPUTSTREAM			'mops'	//1836019827
#define MV2_MODULE_TYPE_MP3OUTPUTSTREAM				'mp3 '	//1836069664	//media outputstream module iwth IMV2MediaOutputStream interface
#define MV2_MODULE_TYPE_AMOI_MEDIAOUTPUTSTREAM		'mopa'	//1836019809 // only for amoi(1389) project 
#define MV2_MODULE_TYPE_INVERSE_MEDIAOUTPUTSTREAM   'imo'   //倒序播放类
//subtype for camera
#define MV2_CAMERA_TYPE_AMOI                        		'amoi' //1634561897

//drm type
#define MV2_DRMTYPE_NONE							'null'	//no drm
#define MV2_DRMTYPE_DIVX							'divx'	//divx drm
#define MV2_DRMTYPE_OMA1							'oma1'	//oma 1.0
#define MV2_DRMTYPE_OMA2							'oma2'	//oma 2.0
#define MV2_DRMTYPE_OMA21							'om21'	//oma 2.1

// for stream push
#define MV2_MODULE_TYPE_STREAM_PUSH							'streampush'	//oma 2.1
    
/////////////// MARCO //////////////////////////

/*=====================================

	Media file format marco

=======================================*/
#define MV2_FILE_TYPE_UNKNOWN		0
#define MV2_FILE_TYPE_MP4			'mp4 ' //1836069920
#define MV2_FILE_TYPE_3GP			'3gp ' //862416928
#define MV2_FILE_TYPE_3GPP			'3gpp'
#define MV2_FILE_TYPE_3G2			'3g2 ' //862401056
#define MV2_FILE_TYPE_MOV			'mov ' //1836021280
#define MV2_FILE_TYPE_ASF			'asf ' //1634952736
#define MV2_FILE_TYPE_AVI			'avi ' //1635150112
#define MV2_FILE_TYPE_MIDI			'mid ' //1835623456
#define MV2_FILE_TYPE_AMR			'amr ' //1634562592
//#define MV2_FILE_TYPE_XYT			'xyt ' //
#define MV2_FILE_TYPE_WAVE			'wav ' //2002875936
#define MV2_FILE_TYPE_MP3			'mp3 ' //1836069664
#define MV2_FILE_TYPE_AAC			'aac ' //1633772320
#define MV2_FILE_TYPE_ASME			'asme' //1634954597
#define MV2_FILE_TYPE_MPG			'mpg ' //1836082976
#define MV2_FILE_TYPE_M4A			'm4a ' //1832149280
#define MV2_FILE_TYPE_ARTP			'artp' //1634890864
#define MV2_FILE_TYPE_AWB			'awb ' //1635213856
#define MV2_FILE_TYPE_QCP			'qcp ' //1902342176
#define MV2_FILE_TYPE_WMA			'wma ' //2003656992
#define MV2_FILE_TYPE_M4V			'm4v ' //1832154656
#define MV2_FILE_TYPE_DTV			'dtv ' //1685354016
#define MV2_FILE_TYPE_DVBH			'dvbh' //1685480040
#define MV2_FILE_TYPE_DMBT			'dmbt' //1684890228
#define MV2_FILE_TYPE_WMV			'wmv ' //2003662368
#define MV2_FILE_TYPE_OGG			'ogg ' //1869047584
#define MV2_FILE_TYPE_EVC			'evc ' //1702257440
#define MV2_FILE_TYPE_FLV			'flv ' //1718384160
#define MV2_FILE_TYPE_DIVX			'divx' //1684633208
#define MV2_FILE_TYPE_SKM			'skm ' //1936420128
#define MV2_FILE_TYPE_K3G			'k3g ' //1798530848
#define MV2_FILE_TYPE_CCR			'ccr ' //1667461664
#define MV2_FILE_TYPE_PVX			'pvx ' //1886812192
#define MV2_FILE_TYPE_3GPP			'3gpp' //862417008
#define MV2_FILE_TYPE_ASSETURL_AUDIO 'asta'
#define MV2_FILE_TYPE_ASSETURL_VIDEO 'astv'
#define MV2_FILE_TYPE_IPODURL_AUDIO  'ipoa'
#define MV2_FILE_TYPE_IPODURL_VIDEO  'ipov'   
#define MV2_FILE_TYPE_GIF            'gif '
#define MV2_FILE_TYPE_RTMP           'rtmp'	// 1920232816
#define MV2_FILE_TYPE_RAWDATA			'raw '
#define MV2_FILE_TYPE_LYRIC          'lrc '

#define MV2_STREAMING_TYPE_ONDEMAND		'sodm'
#define MV2_STREAMING_TYPE_LIVE					'sliv'

#define MV2_STREAMPUSH_AVASSETWRITER           'avwr'	// 1769235826
#define MV2_STREAMPUSH_VIDEOTOOLBOX            'vtbx'	// 1816293240
/*=====================================

	Media codec  marco

=======================================*/

// visula codec
#define MV2_CODEC_TYPE_UNDEFINED      		0
#define MV2_CODEC_TYPE_MPEG4V_SP		'm4vs' //1832154739
#define MV2_CODEC_TYPE_MPEG4V_ASP		'm4va' //1832154721
#define	MV2_CODEC_TYPE_MSMPEG4V2		'mp42' //mp43
#define	MV2_CODEC_TYPE_MSMPEG4V1		'mp41' //mp43
#define MV2_CODEC_TYPE_H263				'263 ' //842412832
#define MV2_CODEC_TYPE_H264				'264 ' //842413088
#define MV2_CODEC_TYPE_RGB24			'rgb '
#define MV2_CODEC_TYPE_I420			    'i420'
#define MV2_CODEC_TYPE_H265             '265 '

#define MV2_CODEC_TYPE_MJPEG			'mjpg' //1835692135
#define MV2_CODEC_TYPE_MPEG1			'mpg1' //
#define MV2_CODEC_TYPE_MPEG2			'mpg2' // add for qiuhao DTV
#define MV2_CODEC_TYPE_DX50			    'dx50' //1685599536
#define MV2_CODEC_TYPE_XVID 		    'xvid' //2021026148
#define MV2_CODEC_TYPE_YUV420           'y420' // for yuv420
#define MV2_CODEC_TYPE_WMV				'wmv ' //wmv
#define MV2_CODEC_TYPE_WMV7				'wmv7' //2003662391
#define MV2_CODEC_TYPE_WMV8				'wmv8' //2003662392
#define MV2_CODEC_TYPE_WMV9				'wmv9' //2003662393
#define MV2_CODEC_TYPE_WVC1             'wvc1'
#define MV2_CODEC_TYPE_DIVX			    'divx' //1684633208
#define MV2_CODEC_TYPE_DIV3				'div3' //1684633139

// audio and speech codec
#define MV2_CODEC_TYPE_AMRNB			'amrn' //1634562670
#define MV2_CODEC_TYPE_AMRWB			'amrw' //1634562679
#define MV2_CODEC_TYPE_IMAADPCM			'imaa' //1768776033
#define MV2_CODEC_TYPE_MSADPCM			'msad' //1836278116
#define MV2_CODEC_TYPE_MP3				'mp3 ' //1836069664
#define MV2_CODEC_TYPE_AAC				'aac ' //1633772320
#define MV2_CODEC_TYPE_AAC_HE_V1		'hev1' //1751479857
#define MV2_CODEC_TYPE_AAC_HE_V2		'hev2' //1751479858
#define MV2_CODEC_TYPE_MPEG4A			'm4a ' //1832149280
#define MV2_CODEC_TYPE_QCELP			'qcp ' //1902342176
#define MV2_CODEC_TYPE_EVRC				'evrc' //1702261347
#define MV2_CODEC_TYPE_PCM				'pcm ' //1885564192
#define MV2_CODEC_TYPE_MIDI				'mid ' //1835623456
#define MV2_CODEC_TYPE_MP2				'mp2 ' //
#define MV2_CODEC_TYPE_GSM610			'gsm6' //1735617846
#define MV2_CODEC_TYPE_WMA_V1			'wmv1'	//2003662385,Windows Media v1 
#define MV2_CODEC_TYPE_WMA_V2			'wmv2'	//2003662386,Windows Media v2
#define MV2_CODEC_TYPE_WMA_9PRO			'wm9p'	//2003646832,Windows Media 9 Professional
#define MV2_CODEC_TYPE_WMA_9LOS			'wm9l'	//2003646828,Windows Media 9 Lossless
#define MV2_CODEC_TYPE_BSAC				'bsac'	//1651728739,bsac
#define MV2_CODEC_TYPE_OGG				'ogg '	//
#define MV2_CODEC_TYPE_EVRC				'evrc'	//
#define MV2_CODEC_TYPE_AC3				'ac3 '	//
#define MV2_CODEC_TYPE_DTS				'dts '  //1685353248
#define MV2_CODEC_TYPE_S263				's263' //1932670515
#define MV2_CODEC_TYPE_DVX3				'div3' //1684633139
#define MV2_CODEC_TYPE_DVX4				'div4' //1684633140
#define	MV2_CODEC_TYPE_MSMPEG4V3		'mp43' //mp43
#define	MV2_CODEC_TYPE_MP4V			    'mp4v' //mp4v
//support multiple codec type
#define	MV2_CODEC_TYPE_MULTIPLE			'mult' 
#define MV2_CODEC_TYPE_GIF              'gif '	// 1734960672
#define MV2_CODEC_TYPE_PNG              'png '
#define MV2_CODEC_TYPE_M4A              'm4a '	// 1832149280



/*=====================================

	Color space  marco

=======================================*/

#define MV2_COLOR_SPACE_UNKNOWN			0			//unknow
#define MV2_COLOR_SPACE_YUV420PL		0x01		//yuv planar 420
#define MV2_COLOR_SPACE_YUV422PL		0x02		//yuv planar 422
#define MV2_COLOR_SPACE_YUV444PL		0x04		//yuv planar 444
#define MV2_COLOR_SPACE_QCOM_SEMIPL     0x08
#define MV2_COLOR_SPACE_NV12            0x10
#define MV2_COLOR_SPACE_NV21            0x20
#define MV2_COLOR_SPACE_NV12T           0x40


#define MV2_COLOR_SPACE_RGB24			0x0100
#define MV2_COLOR_SPACE_RGB565			0x0200		
#define MV2_COLOR_SPACE_RGB565GAPI		0x0400
#define MV2_COLOR_SPACE_RGB555			0x0800
#define MV2_COLOR_SPACE_YUV422			0x1000		//YUV422 PACKER :YUYV
#define MV2_COLOR_SPACE_RGB12			0x2000
#define MV2_COLOR_SPACE_RGB32			0x4000
#define MV2_COLOR_SPACE_GRAY8			0x8000
#define MV2_COLOR_SPACE_TEXTURE         0x10000
#define MV2_COLOR_SPACE_SAMPLEBUF       0x20000
#define MV2_COLOR_SPACE_WORKBUF			0x40000
#define MV2_COLOR_SPACE_SURFACE         0x80000
#define MV2_COLOR_SPACE_BGR8	        0x100000

/*=====================================

	Rotate  marco

=======================================*/
#define MV2_ROTATE_0                   0
#define MV2_ROTATE_90                   90
#define MV2_ROTATE_180                  180
#define MV2_ROTATE_270                  270

/*=====================================
	Screen Mode  marco
=======================================*/
#define MV2_ORIENTATION_NORMAL				0
#define MV2_ORIENTATION_LEFT_HANDLE			1
#define MV2_ORIENTATION_RIGHT_HANDLE		2
#define MV2_ORIENTATION_REVERSAL			3

/*=====================================
	Display Operation Mode  marco
=======================================*/
#define  DISP_FITIN_CENTER_CROP             0
#define  DISP_UPSCALE_FITIN_CENTER_CROP     1
#define  DISP_FULL_QVGA						2
#define  DISP_FITIN_BOTTOM_CROP				3
#define  DISP_UPSCALE_FITOUT_CENTER_CROP	4
#define  DISP_UPSCALE_STRETCH				5

/*=====================================

	player status  marco

=======================================*/

#define MV2_STATE_PLAYER_NULL					0
#define MV2_STATE_PLAYER_OPENED				1
#define MV2_STATE_PLAYER_PLAYING				2
#define MV2_STATE_PLAYER_PAUSE				3
#define MV2_STATE_PLAYER_BUFFERING			4
#define MV2_STATE_PLAYER_SEEKING				5
#define MV2_STATE_PLAYER_STOPPED				6
#define MV2_STATE_PLAYER_OPENING				7
#define MV2_STATE_PLAYER_STOPPING			8
//#define MV2_STATE_PLAYER_RE_CREATED				9	//RE = render engine
#define MV2_STATE_PLAYER_RE_DESTORYED		10	//RE = render engine
#define MV2_STATE_PLAYER_RE_UPDATED			11	//RE = render engine
#define MV2_STATE_PLAYER_DISCONNECT_STREAM  12
/*=====================================

	recorder status  marco

=======================================*/

#define MV2_STATE_RECORDER_NULL					0
#define MV2_STATE_RECORDER_CREATED				1
#define MV2_STATE_RECORDER_RECORDING			2
#define MV2_STATE_RECORDER_PAUSE				3
#define MV2_STATE_RECORDER_STOPPED				4
#define MV2_STATE_RECORDER_UPDATERENDERENGINE   5
#define MV2_STATE_RECORDER_DESTORYRENDERENGINE  6

/*=====================================

	Camera status  marco

=======================================*/
#define MV2_STATE_CAMERA_RECORDING				0
#define MV2_STATE_CAMERA_PAUSE					1
#define MV2_STATE_CAMERA_STOPPED				2
#define MV2_STATE_CAMERA_PREVIEWING				3

// macro for AMR  mode
#define AMR_MODE_MR475  1		/* AMR 5.15 kbps */
#define AMR_MODE_MR515	2		/* AMR 5.15 kbps */
#define AMR_MODE_MR59	3		/* AMR 5.9  kbps */
#define AMR_MODE_MR67	4		/* AMR 6.7  kbps */
#define AMR_MODE_MR74	5		/* AMR 7.4  kbps */
#define AMR_MODE_MR795	6		/* AMR 7.95 kbps */
#define AMR_MODE_MR102	7		/* AMR 10.2 kbps */
#define AMR_MODE_MR122	8		/* AMR 12.2 kbps */

/*=====================================

	player mode  marco

=======================================*/
#define MV2_PLAYER_MODE_NORMAL			0	//can switch to either ff mode or rew mode
#define MV2_PLAYER_MODE_MANUAL			1	//cannot switch to other modes
#define MV2_PLAYER_MODE_FASTFORWARD		2	//can switch to or from normal mode
#define MV2_PLAYER_MODE_REWIND			3	//can switch to or from normal mode
#define MV2_PLAYER_MODE_BENCHMARK		4	//cannot switch to other modes





/*=====================================

	player disable option macro

=======================================*/
#define MV2_PLAYER_DISABLE_NO			0
#define MV2_PLAYER_DISABLE_AUDIO		1
#define MV2_PLAYER_DISABLE_VIDEO		2
#define MV2_PLAYER_ENABLE_AUDIO			3
#define MV2_PLAYER_ENABLE_VIDEO			4


/*=====================================

	display output device option macro

=======================================*/
#define MV2_DISPLAY_OUTPUT_NORMAL		0 	//default normal display device,for example framebuffer
#define MV2_DISPLAY_OUTPUT_AV			1	//display output device:AV-OUT

/*=====================================
	
	  shared memory block flag option macro
 
=====================================*/
#define MV2_SHAREDMEM_READONLY		0
#define MV2_SHAREDMEM_WRITABLE		1
#define MV2_SHAREDMEM_NOUSED		2


/*=====================================

	seek mode  marco

=======================================*/

#define MV2_SEEK_MODE_NORMAL		0	
#define MV2_SEEK_MODE_SYNC			1	
#define MV2_SEEK_MODE_AUTO			2

#define	MV2_SEEKSYNC_PRE			0
#define	MV2_SEEKSYNC_NEXT			1	


/*=====================================

	for MV2_CFG_COMMON_SELECT_DEVICE
	Device ID define
=======================================*/
#define MV2_DEVICE_VIRTUAL_BASE				((MDWord)1<<31)
#define MV2_DEVICE_VIDEO_RENDER_VIRTUAL		(MV2_DEVICE_VIRTUAL_BASE + 1)	//virtual video render device
#define MV2_DEVICE_AUDIO_RENDER_VIRTUAL		(MV2_DEVICE_VIRTUAL_BASE + 2)	//virtual video render device
#define MV2_DEVICE_VIDEO_CODEC_VIRTUAL		(MV2_DEVICE_VIRTUAL_BASE + 3)	//virtual video CODEC device
#define MV2_DEVICE_AUDIO_CODEC_VIRTUAL		(MV2_DEVICE_VIRTUAL_BASE + 4)	//virtual video CODEC device

#define MV2_DEVICE_VIDEO_RENDER_DEFAULT		1							//default video render device
#define MV2_DEVICE_AUDIO_RENDER_DEFAULT		2							//default video render device
#define MV2_DEVICE_VIDEO_CODEC_DEFAULT		3							//default video CODEC device
#define MV2_DEVICE_AUDIO_CODEC_DEFAULT		4							//default video CODEC device

/*=====================================

	for MV2_CFG_COMMON_AUDIO_MODE
	Multi-thread:	MV2_CFG_AUDIO_MODE_MULTITHREAD
		The PlayerThread own the audio thread.
	Single-thread:	MV2_CFG_AUDIO_MODE_NORMAL
		Application which create the Player own the audio component(not thread). All resource
		for audio is create and close by process.
=======================================*/
#define MV2_AUDIO_MODE_NORMAL						1
#define MV2_AUDIO_MODE_MULTITHREAD				2


//for common aspect ratio
#define ARC_ASPECT_RATIO_UNKNOWN				0
#define ARC_ASPECT_RATIO_4_3					1
#define ARC_ASPECT_RATIO_16_9					2
#define ARC_ASPECT_RATIO_100_221				3
/*=====================================


 //new feature, support file type probe
 /*======================================================================================================*/
#define PROTOCOL_UNKNOW		0
#define PROTOCOL_FILE		1
#define PROTOCOL_HTTP		2
#define PROTOCOL_RTSP		3
#define PROTOCOL_MMS		4
#define PROTOCOL_MOS		5
#define PROTOCOL_DTV		6
#define PROTOCOL_FASTTRACK	7
#define PROTOCOL_FD         8
#define PROTOCOL_PLAYLIST	9
#define PROTOCOL_DOWNLOAD	10
#define PROTOCOL_ASSETSLIB  11
    




/////////////// STRUCTURE ///////////////////////

typedef struct _SourcePara
{
    MTChar* szUrl;
    MDWord dwProtocolType;	// protocol type
    MDWord dwSplitterType;	// splitter type
    MDWord dwSize;			// data size
} SourcePara;


typedef struct _tag_MV2_DUBBING_INFO
{
	MTChar szDubbingFile[MVLIB_MAXPATH];
	MDWord dwStartPos;
	MDWord dwLength;
}MV2_DUBBING_INFO;


/*=====================================

	Media Clip Information structure 

=======================================*/
typedef struct _tag_clip_info {
	MDWord 	dwFileType;			// the clip file format
	MDWord 	dwDuration;			// the playback duration of clip in ms
	MDWord 	dwWidth;			// the width of picture of clip , 0 if audio only
	MDWord 	dwHeight;			// the height of picture of clip , 0 if audio only
	MDWord 	dwBitrate;			// the average data bitrate of clip in bit
	MDWord 	dwIntervalTime;		// the average interval time of frame in ms ( FPS =  1000/dwIntervalTime), 0 if audio only
	MBool	bHasAudio;			// has audio in this clip?
	MBool	bHasVideo;			// has video in this clip?
	MDWord  cbSize;				// size in bytes  of extra information of specifal clip format , the default is 0
}MV2CLIPINFO , *LPMV2CLIPINFO;


/*=====================================

	Audio Information structure 

=======================================*/
typedef struct _tag_audio_info {
	MDWord 	dwAudioType;		// the audio codec type
	MDWord  dwDuration;			// the audio track duration of clip in ms
	MDWord	dwChannel;			// the number of channels of aduio , 1 for mono , 2 for stereo
	MDWord	dwBitsPerSample;		// the bit depth of audio , 8 or 16
	MDWord	dwBlockAlign;			// the block alignment is the minimum atomic unit of data for the audio codec  type(unit is byte)
	MDWord  dwSamplingRate;	// the sampling rate of audio
	MDWord  dwBitrate;			// the bitrate of audio  track in bit
	MDWord  cbSize;				// size in bytes of extra information of specifal audio codec type
	MLong	lAudioSampleFormat;
}MV2AUDIOINFO ,  *LPMV2AUDIOINFO;

/*
typedef struct Midi_Playback_Settings {
	MDWord	nOutputRate;	//the output sampling rate: one value of  AAT_RATE
	MDWord	nOutputBits;	//the output sampling bit depth:one value of  AAT_SIZE
	MDWord	nOutputChannel; //the output sampling channels:one value of  AAT_RATE
	MLong	nMaxPolyphony;  //the maximum polyphony number when playback;
}Midi_Playback_Settings;
*/

//amr audio extend info

typedef struct _tag_amr_audio_info {
	MDWord  dwMode; //the amr mode codec modes
	
	MDWord  dwFramePerSample;//defines the number of frames to be considered as 'one sample' inside the 3GP file
				//This number shall be greater than 0 and less than 16. A value of 1 means each frame 
				//is treated as one sample
	
}MV2ARMEXTENDINFO ,  * LPMV2ARMEXTENDINFO;


/*=====================================

	Video  Information structure 

=======================================*/
typedef struct _tag_video_info {
	MDWord	dwVideoType;		// the video codec type
	MDWord	dwDuration;			// the video track duration of clip in ms
	MDWord	dwPicWidth;			// the picture width
	MDWord  dwPicHeight;		// the picture height
	MDWord  dwFPS;				// the FPS by average of video track
	MDWord  dwBitrate;			// the bitrate of video track in bit
	MDWord	cbSize;				// size in bytes of extra information of specifal video codec type	
}MV2VIDEOINFO,*LPMV2VIDEOINFO;

typedef struct _tag_specfic_info {
	MByte*	pInfoBuf;		    //buf for information
	MLong	lBufSize;			//buf size	
}MV2SPECFICINFO,*LPMV2SPECFICINFO;

typedef struct _tagSPECFICDATA{
	MByte*	pSpecificInfo;		    //buffer for specific info
	MDWord	dwInfoSize;			    //specific info size
	MByte*  pAttachFrame;           //buffer for attached frame data
	MDWord  dwFrameSize;			//attached frame data
	MDWord  dwFrameCount;			//attached frame count;
}MV2SPECFICDATA,*LPMV2SPECFICDATA;

/*=====================================

	Frame  Information structure 

=======================================*/
typedef struct _tag_frame_info {
	MDWord	dwWidth;			// the width of frame
	MDWord  dwHeight;			// the height of frame
	MDWord 	dwLength;			// the frame lenght in bytes 
	MDWord  dwCSType;			// the color space type of frame
	MDWord	dwRotation;			// the roation angel
}MV2FRAMEINFO , *LPMV2FRAMEINFO;



/*=====================================

	playback display parameter structure 

=======================================*/
typedef struct _tag_display_param {
	MDWord		dwRenderTarget;					//Screen or buf
	MHandle		hDisplayDeviceHandle;			// display device dependent, for example , if using a GDI display rendering , it should be an instance of  HWND
	MRECT  		rectScreen;						// the region of screen, 严格的描述应该是rectDstTarget，因为有可能不是screen而是buf
	MRECT  		rectClip;						// the region of clip
	MCOLORREF	colorBackground;
	MDWord		dwRotation;
	MDWord		dwResampleMode;
}MV2DISPLAYPARAM , *LPMV2DISPLAYPARAM;

/*=====================================
 current frame information
=======================================*/
typedef struct _tag_display_cur_frame_info {
	MByte*		pBuf;
	MV2FRAMEINFO frameinfo;
}MV2DISPCURFRAMEINFO , *LPMV2DISPCURFRAMEINFO;

/*=====================================

	the structure of symbian displayDeviceHandle in MV2DISPLAYPARAM 

=======================================*/
typedef struct _tag_symbian_display_device
{
	MHandle		pScreenDevice;  //the type of CFbsScreenDevice*
	MHandle		pGc;			//the type of CFbsBitGc*
	MHandle		pFbsBitMap;		//the type of CFbsBitmap*, pFbsBitMap should be as large as Drawed Screen
}MV2SymbianDisplayDevice,*LPMV2SymbianDisplayDevice;

/*=====================================

	playback mode parameter structure 

=======================================*/
// when dwMode == MV2_PLAYER_MODE_MANUAL, 
//	the value of lParam is ignored.
// when dwMode == MV2_PLAYER_MODE_NORMAL, 
//	lParam == 0 means normal playing, 1 means i-frame only playing.
// when dwMode == MV2_PLAYER_MODE_FASTFORWARD, 
//	lParam should be 2 or 4, other value is ignored.
// when dwMode == MV2_PLAYER_MODE_REWIND, 
//	lParam == 0 means i=frame only rewind, other value's not been supported yet.
typedef struct _tag_player_mode {
	MDWord		dwMode;							// play mode
	MLong		lParam;
}MV2PLAYERMODE , *LPMV2PLAYERMODE;



/*=====================================

	Player callback data structure 

=======================================*/
typedef struct _tag_player_callback_data {
	// status 
	MDWord	dwStatus;				//playback status 
	MRESULT resStatus;				// the result code of current status, for example , if unexcepect error occurs , the callback will be called with the STOP status and an error code
	MDWord	dwStatusData1;			//for playing status , this param means current playback position , for buffering status , it means current buffering position 
	MDWord	dwStatusData2;			//for playing status , this param means total playback duration , for buffering status , it means total bufferring size
	MDWord  dwReason;				//reason for operations,eg: play、pause
	MHandle hStream;				//media stream handle
	//video frame data
	MByte* 	pFrameBuf;				// the buffer of current frame data
	MDWord	dwFrameLen;			// frame len
	MDWord	dwCSType;				// color space type
	MDWord	dwWidth;				// width of frame
	MDWord	dwHeight;				// height of frame
	MBool	bDraw;					// MTrue means the frame needs to be drawn by application layer
	MDWord  dwLastDrawnFrameTS;		//Last Drawn Frame TimeStamp
	MDWord  dwLastDrawnFrameTSP;	//Last Drawn Frame TimeSpan
	MDWord  dwOrignalSeekTime;      //seek orignal time, just only apply seek mode,update value
}MV2PLAYERCBDATA, *LPMV2PLAYERCBDATA;

/*=======================================
async codec callback data
=======================================*/
typedef struct
{
	MByte*  pbyIn;				//original input data buffer
	MLong   lOriInSize;			//original input data buffer size
	MLong   lInUsed;			//used data byte size for this codec call
	MByte*  pbyOut;				//data of decoder result 
	MLong   lOriOutSize;			//original output data buffer size
	MLong   lOutUsed;			//valid bytes in pOut
	MBool	bVideoCodec;		//MTrue:video codec type,MFalse:audio codec type
	MRESULT resCodec;			//codec result	
}MV2ASYNCCODECCBDATA, *LPMV2ASYNCCODECCBDATA;

typedef enum _enum_AdditionalConfigType
{
    ASME_3GPP_HEADER_ENABLE = 0,	//bool
    ASME_NADU_ENABLE,				//bool
    ASME_XR_ENABLE,					//bool
    ASME_RESUME_WITH_RANGE,			//bool	
    ASME_DISABLE_PAUSE,				//bool	
    ASME_SEND_EXTRA_PACKET,			//bool	
    ASME_START_WITH_KEYFRAME,		//bool	
    ASME_DISMISS_INCOMPLETE_FRAME,	//bool
    ASME_RTSP_REQUEST_TIMEOUT,		//dword, second
    ASME_RTP_DATA_TIMEOUT,			//dword, second
    ASME_LOG_FLUSH_MODE,			//bool
    ASME_APPEND_UAPROF_TO_ALLREQ,	//bool
    ASME_RTCP_INTERVAL,				//dword, millisecond
    ASME_DISMISS_BEFORE_KEY_FRAME_WHEN_LIVE,	//bool
    ASME_ALLOW_READ_WHEN_ERROR,					//bool
    ASME_RTSP_KEEP_ALIVE_WHEN_PAUSED,			//bool
    ASME_SEND_BANDWIDTH_IN_REQ,					//bit
    ASME_USE_SESSION_TIMEOUT,		//bool
    ASME_BR_ENABLE,					//bool
    ASME_LOCAL_BUFF_SEEK			//dword, 0/1/2
}MV2ASMEADDITIONALCONFIGTYPE;


/**
 *	PFNMV2ASYNCCODECCALLBACK
 *		playback callback function for app layer to update the status
 *	
 *	Parameter:
 *		lpPlaybackData			[out]			the async codec  callback data
 *		lUserData				[in]			the user defined data
 *
 *	Return:
 *		None
 *
 *	Remark:
 *						
 */
typedef MVoid  (*PFNMV2ASYNCCODECCALLBACK) (LPMV2ASYNCCODECCBDATA lpAsyncCodecCBData , MLong lUserData);


/*=======================================
async codec callback setconfig parameter
=======================================*/
typedef struct
{
	PFNMV2ASYNCCODECCALLBACK pfnCB;
	MLong				     lUserData;
}MV2CFGASYNCCODECCBPARAM;

/*=======================================
recorder preview parameter structure 
=======================================*/

typedef	struct _tag_preview_param{
	MHandle		hPrewviewDeviceHandle;			//preview device dependent, for example , if using a GDI display rendering , it should be an instance of  HWND
	MRECT		rectScreen;				//the region of background screen
	MRECT		rectPreview;				//the region of preview area
	MDWord 		dwRotate;				//the roation angel for camera preview:MV2_ROTATE_0,MV2_ROTATE_90,MV2_ROTATE_180,MV2_ROTATE_270
}MV2PREVIEWPARAM, * LPMV2PREVIEWPARAM;

typedef struct RecordStats{
	MDWord dwOriCamFPS;
	MDWord dwCamFPS;
	MInt64 llVSendBPS;
	MInt64 llASendBPS;
	MInt64 llVEncBPS;
	MInt64 llAEncBPS;
	MInt64 llVSWEncTime;
	MDWord llReadTexPixel;
}RecordStats;

/*=====================================

	recorder callback data structure 

=======================================*/
typedef struct _tag_recorder_callback_data {
	MDWord	dwStatus;				//recorder status
	MRESULT resStatus;				// // the result code of current status, for example , if unexcepect error occurs , the callback will be called with the STOP status and an error code
	MDWord	dwRecordedTime;		//recorded time
	MDWord	dwTotalEstimatedTime;	//The total estimatedTime
	MDWord	dwRecordedSize;			// the current recorded data size

//	MDWord  dwFrameFlag;	//QVET_FRAME_FLAG_NONE, QVET_FRAME_FLAG_SECTION_START, QVET_FRAME_FLAG_SECTION_END
	MDWord  dwVFrameTS;		//Video Frame Time Stamp, 定义时的含义是 某个even发生时(start record/running/puase/resume/stop.....) 即将dump到文件的时间戳
	MBool bUpdateRecordStat;
	RecordStats stRecordStat;
}MV2RECORDERCBDATA, *LPMV2RECORDERCBDATA;

/*=====================================

	ASME configure parameter structure

=======================================*/
typedef struct _tag_asme_param {
	MDWord	dwRTPPort;				//rtp port
	MDWord	dwLeastTime;			//the timepoint switch from play state to buffer state
	MDWord	dwPlayTime;				//the timepoint switch from buffer state to play state
	MDWord	dwMostTime;				//the most buffered media length
	MDWord	dwBandwidth;			//specify the bandwidth in bytes
}MV2ASMEPARAM, *LPMV2ASMEPARAM;

typedef enum _enum_XNetworkType
{
	ASME_UNKNOWN_NETWORK,
	ASME_IS2000,
	ASME_EVDO
}MV2ASMEXNETWORKTYPE,*LPMV2ASMEXNETWORKTYPE;

/* about transport type used by the player */
typedef enum _enum_TransportType
{
	ASME_AUTOMATIC,
	ASME_DIRECT_UDP,
	ASME_INTERLEAVED,
	ASME_NAT_TRAVERSAL	
}MV2ASMETRANSPORTTYPE,*LPMV2ASMETRANSPORTTYPE;

typedef struct _tag_asme_option {
	MDWord dwRTPPort;						//rtp port 
	MDWord dwLeastTime;						//the time point switch from play state to buffer state
	MDWord dwPlayTime;						//the time point switch from buffer state to play state
	MDWord dwMostTime;						//the most buffered media length
	MDWord dwBandwidth;						//specify the bandwidth in bytes
	MDWord dwConnectTimeout;				//time out for TCP connect 
	MDWord dwTransportType;					//transport type, tcp, udp, udp over nat 
	MDWord dwXNetworType;
	MTChar* pUAProf;
}MV2ASMEOPTIONS , *LPMV2ASMEOPTIONS ;

typedef struct _tag_asme_port {
	MDWord dwRTPAPort;						//rtp audio port 
	MDWord dwRTPVPort;						//rtp video port 
}MV2ASMEPORT , *LPMV2ASMEPORT ;

typedef struct _tag_asme_port_range_param {
	MDWord dwPortRangeFrom;						
	MDWord dwPortRangeTo;
	MDWord dwRTPPortRangeRetryCount;
}MV2ASMEPORTRANGEPARAM , *LPMV2ASMEPORTRANGEPARAM ;

typedef struct 
{
	MVoid*		pData;
	MDWord	dwTypeSize;
}MV2ASMECONVIA, * LPMV2ASMECONVIA;

/*=====================================

	ASME statistic data structure

=======================================*/
typedef struct _tag_asme_statistic {
	MDWord	dwVideoReceivedPacket;
	MDWord	dwVideoBufferedPacket;
    MDWord	dwVideoLostedPacket;
	MDWord	dwAudioReceivedPacket;
	MDWord	dwAudioBufferedPacket;
	MDWord	dwAudioLostedPacket;
	MDWord dwVideoRecvRate;
	MDWord dwAudioRecvRate;
}MV2ASMESTATISTIC, *LPMV2ASMESTATISTIC;

typedef struct tag_MV2_FRAME_TIMEINFO{
    MDWord dwTimestamp;
    MDWord dwDuration;
}MV2_FRAME_TIMEINFO;

typedef struct tag_MV2_FRAME_TYPEINFO {
    MByte* pBitstream;
    MDWord dwBitstreamLen;
    MDWord dwFrameType;
    MBool  bSkippable;
}MV2_FRAME_TYPEINFO;

typedef struct  _tagASME_ADDITIONAL_CONFIG{
    MDWord	cbSize;
    MDWord*	dwConfigs;
}ASME_ADDITIONAL_CONFIG;

typedef struct tag_MV2_TIMERANGE{
    MDWord dwPos;
    MDWord dwLen;
}MV2_TIMERANGE;

////////////// CALLBACK FUNCTION //////////////////

/*=====================================

	Player callback function 

=======================================*/

/**
 *	PFNMV2PLAYERCALLBACK
 *		playback callback function for app layer to update the status
 *	
 *	Parameter:
 *		lpPlaybackData			[in]			the playback callback data
 *		lUserData				[in]			the user defined data
 *
 *	Return:
 *		None
 *
 *	Remark:
 *						
 */

typedef MVoid  (*PFNMV2PLAYERCALLBACK) ( LPMV2PLAYERCBDATA lpPlaybackData , MHandle hUserData);



/*=====================================

	Recorder callback function 

=======================================*/

/**
 *	PFNMV2RECORDERCALLBACK
 *		recorder callback function for app layer to update the status
 *	
 *	Parameter:
 *		lpRecorderData			[in]			the recorder callback data
 *		lUserData				[in]			the user defined data
 *
 *	Return:
 *		None
 *
 *	Remark:
 *						
 */
typedef MVoid  (*PFNMV2RECORDERCALLBACK) ( LPMV2RECORDERCBDATA lpRecorderData , MVoid* lUserData);

/**
 *	PFNMV2COMMONCALLBACK
 *		common callback function
 *	
 *	Parameter:
 *		lUserData				[in]			the user defined data
 *      pReserved               [in/out]        reserved for future use
 *
 *	Return:
 *		MRESULT
 *
 *	Remark:
 *						
 */
typedef MRESULT (*PFNMV2COMMONCALLBACK) (MVoid* pReserved, MVoid* lUserData);

/*=====================================

	the callback struct used for SetConfig function to set a callback function
    and the user data

=======================================*/
typedef struct _tag_callback {
    PFNMV2COMMONCALLBACK fnCallback;
    MVoid*  pUserData;
} MV2CALLBACK, *LPMV2CALLBACK;


//for set preprocess information
typedef struct _tag_preprocess_info{
	MDWord  dwResWidth;
	MDWord  dwResHeight;
	MDWord  dwRotation;
	MRECT   rtCropRect;       
}MV2PREPROCESSINFO , *LPMV2PREPROCESSINFO;

typedef enum 
{
	MV2_ENC_TYPE_ISO_8859_1,	//latin-1
	MV2_ENC_TYPE_UTF_16,
	MV2_ENC_TYPE_UTF_16BE,
	MV2_ENC_TYPE_UTF_8
}MV2_ID_ENCODING_TYPE;

typedef struct
{
	MLong encoding;
	MLong length;
	MByte *content;
}MV2_ID_FIELD;

typedef struct _tag_id_extra_info
{
	MByte			language[3];
	MByte			reserved;					//for making 4-byte alignment
	MV2_ID_FIELD	strings;
	struct _tag_id_extra_info	*next_comment;
}MV2_ID_EXTRA_INFO;

typedef struct
{
	MLong order;
	MLong total;
}MV2_ID_TRACK;

typedef struct
{
	MWord tag_version;
	MByte major;
	MByte revision;
}MV2_ID3_version;

typedef struct
{
	MV2_ID_FIELD description;
	MV2_ID_FIELD url;		//encoding or URL is always AA_ID3_TYPE_ISO_8859_1
}MV2_ID3_url;

typedef struct
{
	MV2_ID_TRACK			track;
	MLong					year;
	MV2_ID_FIELD			title;
	MV2_ID_FIELD			artist;
	MV2_ID_FIELD			album;	
	MV2_ID_FIELD			genre;
	MV2_ID_EXTRA_INFO		exinfo;	
	//rating
	MV2_ID_FIELD			copyright;
	MV2_ID_FIELD			composer;
	//description
	MV2_ID3_version			version;
	MV2_ID3_url				urlLink;
}MV2MEDIATAG, *LPMV2MEDIATAG;

typedef struct __tag_rtp_url{
	MTChar	identifier[8];	/* = _MMT("artp://")*/
	MChar	address[128];
	MWord	localAudioPort;
	MWord	localVideoPort;
	MWord	remoteAudioPort;
	MWord	remoteVideoPort;
	MV2CLIPINFO	 clipInfo;
	MV2VIDEOINFO videoInfo;
	MV2AUDIOINFO audioInfo;
}MV2RTPPARAM, *LPMV2RTPPARAM;

typedef struct
{
	MDWord dwBuffSize;		//shared total size of pYpUpV. pY,PU,PV are continuous memory
	MDWord dwOffset;	
	MDWord dwYStride;
	MDWord dwUVStride;     //dwUVStride =  dwYStride / 2;
	MDWord dwWidth;
	MDWord dwHeight;
	MDWord dwFlag1;         //value 0 read only, and is current image; others write able 
	MDWord dwFlag2;
	MByte* pY1;
	MByte* pU1;
	MByte* pV1;
	MByte* pY2;
	MByte* pU2;
	MByte* pV2;
}MV2SHAREDBUFF, *LPMV2SHAREDBUFF;

//define for track type
#define MV2_TRACK_TYPE_VIDEO			1
#define MV2_TRACK_TYPE_AUDIO			2
#define MV2_TRACK_TYPE_TEXT				3
//for get track size from spliter
typedef struct _tag_track_size{
	MDWord  dwTrackType;  // for input track type
	MDWord  dwTrackSize;  // for output track size     
}MV2TRACKSIZE , *LPMV2TRACKSIZE;

//for to 
typedef struct _tag_track_status{
	MDWord  dwTrackType;  // track type
	MBool   bEnable;	  // MTrue:to enable the dwTrackType track,MFalse to disable it    
}MV2TRACKSTATUS , *LPMV2TRACKSTATUS;

//Add by yzhang(yzhang@arcsoft.com.cn)
//Define for AudioEditor
#define MV2_AUDIO_CHANNEL_NONE		0
#define MV2_AUDIO_CHANNEL_LEFT			1
#define MV2_AUDIO_CHANNEL_RIGHT		2
#define MV2_AUDIO_CHANNEL_BOTH		3

//Fade In/Out 
typedef struct tag_MV2_Fade_Param {
	MDWord 		dwFadeDuration;
	MLong		lInitialAmp;		//percent
    MLong		lFinalAmp;
	MLong		isFadeIn;
}MV2AUDIOFADE, * LPMV2AUDIOFADE;


/*======================================
	define for progressive-download
=======================================*/

//define file type:
#define MV2_DOWNLOAD_TYPE_UNKONW         0
#define MV2_DOWNLOAD_TYPE_NORMAL         1
#define MV2_DOWNLOAD_TYPE_PROGRESSIVE    2

//http download callback data
typedef struct _tag_MV2HttpCallbackData{
	MDWord      dwTotalSize;  
	MDWord		dwDownloadSize;
	MDWord      dwCachePercent;
	MDWord      dwStatus;
	MDWord      dwBitrate;
	MRESULT     resLastErr;
	MDWord      dwDownloadType;   //whether is progressive download file
	MDWord      dwMaxSeekPos;     //the max time can seek to
}MV2HTTPCALLBACKDATA, *LPMV2HTTPCALLBACKDATA;

typedef MRESULT (*PFMV2HTTPCALLBACK) (LPMV2HTTPCALLBACKDATA pCallbackData, MLong lUserData);

//http download callback data
typedef struct _tag_MV2HttpCallback{
	MLong				UserData;  
	PFMV2HTTPCALLBACK   pCallBack;
}MV2HTTPCALLBACK, *LPMV2HTTPCALLBACK;
//support multi-track
typedef struct _tag_multitrack_info {
	MDWord dwTrackType;     // indicate audio or video track,
	MDWord dwIndex;	
	MVoid*  pTrackInfo;     //if it is video track, pTrackInfo is the pointer of video info structure; if it is audio track, pTrackInfo is the pointer of aduio info structure	
} MV2MULTITRACKINFO, *LPMV2MULTITRACKINFO;

typedef struct _tag_select_track {	
	MDWord  dwVideoIndex;   //if 0, do not select any video track. Valid track value should be bigger than 0	
	MDWord  dwAudioIndex;   //if 0, do not select any audio track. Valid track value should be bigger than 0	
} MV2SELECTTRACK, *LPMV2SELECTTRACK;

//support extern info from mp4
//for set and get create time and modify time
typedef struct _tag_MV2FileTime{
	MDWord	dwCreateTime;  
	MDWord  dwModifyTime;
}MV2FILETIME, *LPMV2FILETIME;

//define for user data type
#define  MV2_USERDATA_COPYRIGHT			'cprt'
#define	 MV2_USERDATA_AUTHOR			'auth'
#define	 MV2_USERDATA_TITLE				'titl'
#define  MV2_USERDATA_DESCRIPTION		'dscp'


#define  MV2_METADATA_WATERMARK_KEY			"description"

//for get and set user data
typedef struct _tag_MV2UserDataAtom{
	MDWord  dwType;  
	MDWord  dwLanguage;
	MDWord  dwStrLen;
	MByte*  pString;
}MV2USERDATAATOM, *LPMV2USERDATAATOM;

typedef struct _tag_MV2UserData{
	LPMV2USERDATAATOM	 pUserData;  
	MDWord               dwCount;
}MV2USERDATA, *LPMV2USERDATA;

#define MV2_BENCHMARKITEM_DATA_TYPE_AVG				0		//benchmark data type of average
#define MV2_BENCHMARKITEM_DATA_TYPE_MIN				1		//benchmark data type of min
#define MV2_BENCHMARKITEM_DATA_TYPE_MAX				2		//benchmark data type of max

#define MV2_BENCHMARKITEM_ID_NUMS					18

#define MV2_BENCHMARKITEM_ID_AUDIO_FILEIO			0		//benchmark item ID of audio File IO
#define MV2_BENCHMARKITEM_ID_VIDEO_FILEIO			1		//benchmark item ID of video File IO
#define MV2_BENCHMARKITEM_ID_AUDIO_POST_PROCESS		2		//benchmark item ID of audio post-process
#define MV2_BENCHMARKITEM_ID_VIDEO_POST_PROCESS		3		//benchmark item ID of video post-process
#define MV2_BENCHMARKITEM_ID_AUDIO_CODEC			4		//benchmark item ID of audio codec
#define MV2_BENCHMARKITEM_ID_VIDEO_CODEC			5		//benchmark item ID of video codec
#define MV2_BENCHMARKITEM_ID_VIDEO_RENDER			6		//benchmark item ID of video render
#define MV2_BENCHMARKITEM_ID_VIDEO_CAPTURE			7		//benchmark item ID of video capture,for DV
#define MV2_BENCHMARKITEM_ID_MVLIB_CONSUMED			8		//benchmark item ID of Engine cost

#define MV2_BENCHMARKITEM_ID_AUDIO_RENDER			9		//benchmark item ID of audio render
#define MV2_BENCHMARKITEM_ID_CALLBACK_APP			10		//benchmark item ID of callback app
#define MV2_BENCHMARKITEM_ID_BENCH_TIME				11		//benchmark item ID of recording bencmark time
#define MV2_BENCHMARKITEM_ID_AUDIO_CAPTURE			12		//benchmark item ID of audio capture,for DV


#define MV2_BENCHMARKITEM_ID_AUDIO_DUMP             13      //benchmark item ID of audio dump
#define MV2_BENCHMARKITEM_ID_AUDIO_ENCODE           14      //benchmark item ID of audio encode
#define MV2_BENCHMARKITEM_ID_VIDEO_DUMP             15      //benchmark item ID of video dump
#define MV2_BENCHMARKITEM_ID_VIDEO_ENCODE           16      //benchmark item ID of video encode

#define MV2_BENCHMARKITEM_ID_RESERVED2				17


typedef struct _tag_MV2BenchmarkItem
{
	MDWord dwValue;				//ms,time consumed of benchmark item,for average data type,it is gathering span
	MDWord dwTimestamp;			//ms,timestamp of even happened,for average data type,it is gathering tickcount.
	MVoid* pParam;				//reserve
}MV2BENCHMARKITEM, *LPMV2BENCHMARKITEM;

typedef struct tagMV2BenchmarkResult
{
	MDWord dwCbSize;					//struct len,version control.
	MDWord dwDataType;					//request to return benchmark data type,avg/min/max
	MV2BENCHMARKITEM bmItem[MV2_BENCHMARKITEM_ID_NUMS];
}MV2BENCHMARKRESULT, *LPMV2BENCHMARKRESULT;


//below param for EQ 
#define		MV2_EQ_BAND_COUNT    5              //the count of EQ bandDB
#define		MV2_SPECTRUM_COUNT   50				//the count of spectrum
//macro for EQ Mode
#define		MV2_EQ_MODE_DEFAULT					0
#define		MV2_EQ_MODE_ROCK					1
#define		MV2_EQ_MODE_POP						2
#define		MV2_EQ_MODE_FULL_BASS				3
#define		MV2_EQ_MODE_FULL_TREBLE				4
#define		MV2_EQ_MODE_FULL_BASS_AND_TREBLE	5
#define		MV2_EQ_MODE_COUNTRY					6
#define		MV2_EQ_MODE_JAZZ					7
#define		MV2_EQ_MODE_CLASSICAL				8
#define		MV2_EQ_MODE_BLUES					9
#define		MV2_EQ_MODE_DANCE					10
#define		MV2_EQ_MODE_CUSTOM					0xffffffff

typedef struct _tagMV2EQPARAM {
	MDWord dwEQMode; 
	MDWord dwBandNum;//band number 
	MLong  szBandDB[MV2_EQ_BAND_COUNT]; //gain db for each band index (from 0~(dwBandNum-1))
}MV2EQPARAM;

typedef struct _tagMV2EQSPECTRUM {
	MDWord	dwSpecNum;//Spectrum Number	
	MLong   szSpecData[MV2_SPECTRUM_COUNT]; //Spectrum value for each Spectrum index(from 0~(dwSpecNum-1)) ,total is Spectrum Number value
}MV2EQSPECTRUM;
//end for EQ param


/*
		for Codec Error Set for LoadDecoder.
		0x00000000000000AV		
		if A is set, Audio codec is unavailable;
		if V is set, Video codec is unavailable.
	*/
#define MV2_MEDIASTREAM_VIDEO_CODEC_FAIL			0x01
#define MV2_MEDIASTREAM_AUDIO_CODEC_FAIL			0x02

//define for http proxy
#define MV2_PROXY_FIELD_SIZE 64

typedef struct _tagMV2PROXYPARAM
{
	MLong  lPort;
	MTChar szIP[MV2_PROXY_FIELD_SIZE];
	MTChar szUser[MV2_PROXY_FIELD_SIZE];
	MTChar szPassword[MV2_PROXY_FIELD_SIZE];
	MTChar szDomain[MV2_PROXY_FIELD_SIZE];
}MV2PROXYPARAM;

//define for the netware information
typedef struct 
{	
	MDWord dwLinkID;//netware connection ID	
	//reserve for other parameter if add new feature. 
	
}MV2NETWAREINFO;

//MV2 Logger level Definitions
#define	MV2_LOG_LEVEL_NONE											0
#define MV2_LOG_LEVEL_AVSYNC_TRACE							0x01
#define MV2_LOG_LEVEL_MESSAGE										0x02
#define MV2_LOG_LEVEL_ALL												(MV2_LOG_LEVEL_AVSYNC_TRACE | MV2_LOG_LEVEL_MESSAGE)
#define MV2_LOG_LEVEL_DUMP_AUDIOIN_DATA					0x04
#define MV2_LOG_LEVEL_DUMP_VIDEOIN_DATA					0x08
#define MV2_LOG_LEVEL_DUMP_AUDIOOUT_DATA				0x10
#define MV2_LOG_LEVEL_DUMP_VIDEOOUT_DATA				0x20
#define MV2_LOG_LEVEL_DUMP_AUDIODEV_DATA				0x40

#define MV2_ASMELOG_LEVEL_NONE				0x00
#define MV2_ASMELOG_LEVEL_OFF					0x01
#define MV2_ASMELOG_LEVEL_PARTLY			0x02
#define MV2_ASMELOG_LEVEL_ALL					0x04
#define MV2_ASMELOG_LEVEL_AUDIO_BITSTREAM				0x08
#define MV2_ASMELOG_LEVEL_VIDEO_BITSTREAM				0x10
#define MV2_ASMELOG_LEVEL_AUDIO_PAYLOAD					0x20
#define MV2_ASMELOG_LEVEL_VIDEO_PAYLOAD					0x40
    
    
#define MV2_H264_PROFILE_UNKNOW                        0x0
#define MV2_H264_PROFILE_BASELINE                      0x1
#define MV2_H264_PROFILE_MAIN                          0x2
#define MV2_H264_PROFILE_HIGH                          0x3
    
#define MV2_H264_LEVEL_UNKNOW                           0
#define MV2_H264_LEVEL_30                               30
#define MV2_H264_LEVEL_31                               31
#define MV2_H264_LEVEL_40                               40
#define MV2_H264_LEVEL_41                               41
#define MV2_FPS_FOR_RTMP_STREAM                         15




typedef struct {
	//bDump is Optional 
	//Dump the compressed data from source and the successful output of RAW data after decoded
	MDWord			dwMV2LogLevel;
	MDWord			dwASMELogLevel;
	MTChar			sPath[MVLIB_MAXPATH];	//Logger and dump files's path
} MV2LOGCONFIG;

typedef struct _tagDstTimeIsSeekable 
{
	MDWord dwDstTime;
	MBool bIsSeekable;
} MV2ISSEEKABLECONFIG;	//add by fwang, use this to check if the stream can be seek at specified timestamp
						//2010.05.21
typedef struct
{
	MHandle hClip;
	MHandle hEffect;
	MDWord dwOpCode;
} MV2_REFRESH_STREAM_PARAM;

typedef enum _enum_VIDEO_FRAME_TYPE{
	MV2_VIDEO_FRAME_NONE,
	MV2_VIDEO_FRAME_I,
	MV2_VIDEO_FRAME_P,
	MV2_VIDEO_FRAME_B,
}MV2_VIDEO_FRAME_TYPE;

//used by transcoder\videoreader and videoWriter
typedef struct _tag_VideoFormat 
{
    MDWord dwWidth;
    MDWord dwHeight;
    MDWord dwVideoType;
    MDWord dwColorType;
    MDWord dwProfile;
    MDWord dwLevel;
    MFloat fFPS;				// the FPS by average of video track
    MDWord dwBitrate;			// the bitrate of video track in bit
}TRANSCODER_VIDEOFORMAT;


typedef struct _tag_ScaleVideoInof
{
	MDWord dwWidthSrc;
	MDWord dwHeightSrc;
	MDWord dwColorTypeSrc;

	MDWord dwWidthDst;
	MDWord dwHeightDst;
	MDWord dwColorTypeDst;

} ScaleVideoInof;

typedef struct
{
    MDWord dwErr;
	int movflags;
	int movmode;
	MInt64 mdat_pos;
	MUInt64 mdat_size;
	int reserved_moov_size;
	MInt64 reserved_header_pos;
	int formatflags;
	MVoid* write_header;
	MVoid* write_trailer;
	int header_written;
	int pbErr;
	MInt64 moovPos;
	MInt64 pbPos1;
	MInt64 pbPos2;
	MInt64 pbPos3;
	MInt64 pbPos4;
}PRODUCER_MUXER_CONTEXT_DATA;

typedef struct _tagVideoEffectFrame
{
	MByte *pBuffer;//buf存储effect frame
	MHandle hEffect;//effect
} MV2_VIDEO_EFFECT_FRAME;//这个结构体用来获取storyboard上的hEffect的底图

typedef struct _tagVideoEffectFrameInfo
{
	MV2FRAMEINFO* pFrameInfo;//该effect在绘制底图的时的相关信息
	MHandle hEffect;//effect
} MV2_VIDEO_EFFECT_FRAME_INFO;//这个结构体用来获取storyboard上的hEffect的底图信息

typedef struct _tagVideoClipOriFrame
{
	MByte *pBuffer;//buf存储frame
	MHandle hClip;//存储需要的clip的handle
} MV2_VIDEO_CLIP_ORI_FRAME;//这个结构体用来获取storyboard上的hClip的底图

typedef struct _tagVideoClipOriFrameInfo
{
	MV2FRAMEINFO* pFrameInfo;//clip原始底图的Frame信息
	MHandle hClip;//存储需要的clip的handle
} MV2_VIDEO_CLIP_ORI_FRAME_INFO;//Clip底图信息

typedef enum
{
    MV2_1080P_MPEG4,  // 0
	MV2_720P_MPEG4,   // 1
	MV2_FWVGA_MPEG4,  // 2
	MV2_VGA_MPEG4,    // 3
	MV2_4K_H264,      // 4
	MV2_1080P_H264,   // 5
	MV2_720P_H264,    // 6
	MV2_FWVGA_H264,   // 7
	MV2_VGA_H264,     // 8
    MV2_QVGA_MPEG4,   //9
	MV2_QVGA_H264,    //10
	MV2_4K_H264_INTERLACE, // 11
	MV2_1080P_H264_INTERLACE, // 12
	MV2_720P_H264_INTERLACE,  // 13
	MV2_FWVGA_H264_INTERLACE, // 14
	MV2_VGA_H264_INTERLACE,    // 15
	MV2_2K_H264, //16
	MV2_2K_H264_INTERLACE, //17
	MV2_4K_H265,      //18
	MV2_2K_H265,      //19
	MV2_1080P_H265,   //20
	MV2_720P_H265,    //21
	MV2_FWVGA_H265,   //22
	MV2_VGA_H265,     //23
	MV2_QVGA_H265,    //24
}MV2_HW_DEC_RESOLUTION;
#define MV2_HWDEC_RES_TYPE_NUM 25

typedef enum
{
    MV2_STANDARD_MPEG4,
	MV2_UNSTANDARD_MPEG4,
	MV2_STANDARD_H264,
	MV2_UNSTANDARD_H264,
}MV2_HW_ENC_RESOLUTION;

typedef enum
{
    MV2_VIDEO_IMPORT_ENC_NORMAL_SW,
	MV2_VIDEO_IMPORT_ENC_NORMAL_HW,
	MV2_VIDEO_IMPORT_ENC_NORMAL_PIP,
	MV2_VIDEO_IMPORT_ENC_NORMAL_REVERSE,
	MV2_VIDEO_IMPORT_ENC_HD_SW,
	MV2_VIDEO_IMPORT_ENC_HD_HW,
	MV2_VIDEO_IMPORT_ENC_HD_PIP,
	MV2_VIDEO_IMPORT_ENC_HD_REVERSE
}MV2_VIDEO_IMPOART_ENC_TYPE;



#define MV2_HWENC_RES_TYPE_NUM 4

#define MV2_HW_GPU_RENDER_LEN   32

#define MV2_VIDEO_IMPORT_ENC_TYPE_NUM  8 


typedef struct _tag_AVDataNode
{
	MByte* m_pData;
	MLong  m_lLength;
	MDWord m_dwTimeStamp;
	MDWord m_dwTimeSpan;
	MBool  m_bKeyFrame;
	MLong  m_lVideoDTS;
}MUXER_AVDATANODE;


//used by transcoder\videoreader and videoWriter
typedef MRESULT (*PFNREADVIDEOFRAMECALLBACK) (MByte * pFrameBuf, MLong lBufSize ,
                                              MLong * plReadSize,MDWord * pdwCurrentTimestamp , 
                                              MDWord * pdwTimeSpan,MBool *  pbIsSyncFrame,MVoid *pObj );

typedef enum {
    MV2RECORDER_ADJUST_TYPE_FPS = 1,
    MV2RECORDER_ADJUST_TYPE_BPS = 2,
}MV2RecorderAdjustType;
typedef MRESULT  (*PMV2RECORDER_CE_PFSADAPTER_CALLBACK) ( MDWord dwFPS,MVoid* pData, MV2RecorderAdjustType type);

typedef struct
{
    PMV2RECORDER_CE_PFSADAPTER_CALLBACK pCallback;
	MVoid* pUserData;
}MV2_RECODER_CE_FPS_ADAPTER;


// CQD.newSession
typedef MRESULT  (*PMV2RECORDER_CE_SET_TIME_STAMP_CALLBACK) ( MDWord dwFPS,MVoid* pData);
typedef MRESULT  (*PMV2RECORDER_CE_GET_TIME_STAMP_CALLBACK) ( MDWord *pdwFPS,MVoid* pData);

typedef struct
{
	PMV2RECORDER_CE_SET_TIME_STAMP_CALLBACK pSetTimeStampCallback;
	PMV2RECORDER_CE_GET_TIME_STAMP_CALLBACK pGetTimeStampCallback;
	MVoid* pUserData;
}MV2_RECODER_CE_TIME_STAMP;

typedef MVoid (*PMV2RECORDER_CE_AUDIO_SOURCE_CALLBACK) (MByte* pBuf,MDWord dwLen,MVoid* pData);


//底层用来查询player是否需要中断seek的回调
typedef MBool (*PMV2PLAYER_DISTURB_SEEK_CALLBACK) (MVoid* pUserData);

typedef struct
{
    PMV2PLAYER_DISTURB_SEEK_CALLBACK fnCallback;
	MVoid* pUserData;
}MV2_PLAYER_DISTURB_SEEK_CALLBACK_DATA;



//Resize Algorithms 
#define	MV2_DIS_RESAMPLE_NEAREST_NEIGHBOUR					0x001	//Nearest Neighbour Interpolation, high performance and low quality
#define	MV2_DIS_RESAMPLE_BILINEAR										0x002	//Bilinear Interpolation, high quality and low performance
#define	MV2_DIS_RESAMPLE_BICUBIC											0x004	//Reserved, Bicubic Interpolation

//Resample mode

#define MV2_RESAMPLE_MODE_DEFAULT                     0x00000000
#define MV2_RESAMPLE_MODE_FITIN                       0x00000001
#define MV2_RESAMPLE_MODE_FITOUT                      0x00000002
#define MV2_RESAMPLE_MODE_FILL                        0x00000003
#define MV2_RESAMPLE_MODE_ORIGINAL                    0x00000004
#define MV2_RESAMPLE_MODE_REF_WIDTH                   0x00000005
#define MV2_RESAMPLE_MODE_REF_HEIGHT                  0x00000006

#define MV2_RESAMPLE_MODE_UPSCALE_FITIN               0x00010001
#define MV2_RESAMPLE_MODE_UPSCALE_FITOUT              0x00010002

//aac codec type
#define MV2_AAC_TYPE_RAW							  0x00000001
#define MV2_AAC_TYPE_ADTS							  0x00000002
#define MV2_AAC_TYPE_ADIF							  0x00000003	

//standard sample rate
#define STANDARD_SAMPLERATE_8000	8000
#define STANDARD_SAMPLERATE_11025	11025
#define STANDARD_SAMPLERATE_12000	12000
#define STANDARD_SAMPLERATE_16000	16000
#define STANDARD_SAMPLERATE_22050	22050
#define STANDARD_SAMPLERATE_24000	24000
#define STANDARD_SAMPLERATE_32000	32000
#define STANDARD_SAMPLERATE_36000	36000
#define STANDARD_SAMPLERATE_44100	44100
#define STANDARD_SAMPLERATE_48000	48000
#define STANDARD_SAMPLERATE_96000	96000
#define STANDARD_SAMPLERATE_192000	192000

#define MV2_RENDER_API_OpenGLES20                              0x00000010


//all op definition is for player
#define MV2_OP_NONE									0
#define MV2_OP_LOCK_VIDEO_EFFECT					1		//opData is hEffect
#define MV2_OP_UNLOCK_VIDEO_EFFECT					2		//opData is hEffect
#define MV2_OP_REFRESH_AUDIO						3		//opParam is NULL
#define MV2_OP_REFRESH_AUDIO_EX						4		//opParam is NULL





#define MB_CHECK_VALID_RET(res)	\
        if (res) {              	\
            return res;        	\
        }

#define MB_CHECK_VALID_GOTO(res)	\
        if (res) {                 	\
            goto FUN_EXIT;         	\
        }

#define MB_CHECK_POINTER_GOTO(p, err)	\
        if (!p) {                  		\
            res = err;                 	\
            goto FUN_EXIT;             	\
        }

#define MB_SET_ERR_AND_GOTO(err)	\
        {                          	\
            res = (err);           	\
            goto FUN_EXIT;         	\
        }

#define MB_CHECK_POINTER_RET(p, err)	\
        {                              	\
            if (!p)                    	\
            return err;               	\
        }

#define MB_SET_RES_GOTO(err) \
    res = err;                     \
    goto FUN_EXIT;                 \
    

#ifdef __cplusplus
}
#endif //__cplusplus


#endif
 
