#ifndef QCAMDEF_H
#define QCAMDEF_H


#define XYCE_PROP_NONE                  0x00000000
//#define XYCE_PROP_RECORDING_EFFECT      0x00000001  //means the effect is involved in the exported video
#define XYCE_PROP_INPUTFRAME_CROPSIZE   0x00000002
#define XYCE_PROP_DELEGATE              0x00000003
#define XYCE_PROP_TEMPLATE_ADAPTER      0x00000004
#define XYCE_PROP_FONT_ADAPTER          0x00000005
#define XYCE_PROP_FD_INTERVAL           0x00000006  //face detection interval, how many frams for one-detection
#define XYCE_PROP_FD_DATA_FILE          0x00000007
/*! @constant  XYCE_PROP_CAMERA_SRC_FACE_SOFTEN_VALUE refer to [QCamEffectUpdateItem SetProperty] for more info */
#define XYCE_PROP_CAMERA_SRC_FACE_SOFTEN_VALUE      0x00000008
/*! @constant  XYCE_PROP_CAMERA_SRC_FACE_BRIGHTEN_VALUE refer to [QCamEffectUpdateItem SetProperty] for more info */
#define XYCE_PROP_CAMERA_SRC_FACE_BRIGHTEN_VALUE    0x00000009

#define XYCE_PROP_CAMERA_SRC_FACE_DT_ORIENTION      0x0000000a

#define XYCE_PROP_CAMERA_AUDIO_MUTE                 0x0000000b

#define XYCE_PROP_CAMERA_FLIP_MODE                  0x0000000c

#define XYCE_PROP_CAMERA_OT_RECT                    0x0000000d
#define XYCE_PROP_CAMERA_UNINIT_OT_HANDLE           0x0000000e
#define XYCE_PROP_VIDEO_BITERATE                    0x0000000f

#define XYCE_PROP_MAX_AUDIO_SEND_CACHE              0x00000010

#define XYCE_PROP_ENABLE_RTMP_BITRATE_ADAPTION      0x00000011
#define XYCE_PROP_ENABLE_CAPTURE                    0x00000012
#define XYCE_PROP_3D_TRANSLATE                      0x00000013
#define XYCE_PROP_3D_ROTATE                         0x00000014
#define XYCE_PROP_3D_SCALE                          0x00000015
#define XYCE_PROP_3D_TRANSLATE_CUR                  0x00000016
#define XYCE_PROP_3D_ROTATE_CUR                     0x00000017
#define XYCE_PROP_3D_SCALE_CUR                      0x00000018
#define XYCE_PROP_BITRATE                           0x00000019
#define XYCE_PROP_PROFILE                           0x0000001a
#define XYCE_PROP_3D_BOUND_BOX                      0x0000001b
#define XYCE_PROP_WM_HIDER_DATA                     0x0000001c
#define XYCE_PROP_FD_ENABLE                         0x0000001d
#define XYCE_PROP_RENDER_API                        0x0000001e


#define XYCE_ROTATION_UPSIDE_UP         90.0
#define XYCE_ROTATION_UPSIDE_DOWN       270.0
#define XYCE_ROTATION_RIGHTSIDE_UP      0
#define XYCE_ROTATION_LEFTSIDE_UP       180

#define XYCE_STATUS_NONE                0x00000000
#define XYCE_STATUS_NOT_IN_RECORDING    0x00000001
#define XYCE_STATUS_RECORDING           0x00000002
#define XYCE_STATUS_FX_STOPPED          0x00000004
#define XYCE_STATUS_DIVA_SET          0x00000008
#define XYCE_STATUS_DIVA_CLEAN         0x00000010
#define XYCE_STATUS_PASTER_STOPPED         0x00000020
#define XYCE_STATUS_FILTER_STOPPED           0x00000040
#define XYCE_STATUS_DO_PIP_DISPLAY      0x00000080
#define XYCE_STATUS_PIPSRC_END          0x00000100
#define XYCE_STATUS_FB_PARSING          0x00000200
#define XYCE_STATUS_DO_FB_DISPLAY       0x00000400
#define XYCE_STATUS_DIVA_STOPPED            0x00000800
#define XYCE_STATUS_RECORD_CANCEL       0x00001000
#define XYCE_STATUS_UNINITED            0x00002000
#define XYCE_STATUS_DIVA_PARSING_RESULT XYCE_STATUS_DIVA_SET
#define XYCE_STATUS_NO_FACE_DETECTED    0x00004000
#define XYCE_STATUS_FACE_DETECTED       0x00008000
#define XYCE_STATUS_EXPRESSION_PASTER_DISPLAY_STATUS    0x00010000
//#define XYCE_STATUS_EXPRESSION_PASTER_SWITCH            0x00010001
#define XYCE_STATUS_CAPTURE_PHOTO       0x00100000


#define XYCE_EXPRESSION_PASTER_NONE                    -1
#define XYCE_EXPRESSION_PASTER_STOPPED                 0
#define XYCE_EXPRESSION_PASTER_STARTED                 1
#define XYCE_EXPRESSION_PASTER_DOING                   2
#define XYCE_EXPRESSION_PASTER_SWITCH                  3



enum RTMPERRType{
    QVCE_RTMP_ERR_BASE = (QVERR_OCCE_BASE + 0x00000500),
    QVCE_RTMP_ERR_CONNECT = (QVCE_RTMP_ERR_BASE + 1),
    QVCE_RTMP_ERR_SEND = (QVCE_RTMP_ERR_BASE + 2),
    QVCE_RTMP_ERR_NET_WORSE_START = (QVCE_RTMP_ERR_BASE + 3),
    QVCE_RTMP_ERR_NET_WORSE_END = (QVCE_RTMP_ERR_BASE + 4),
};


//XYCE_STATUS has been changed to CALLBack Data
typedef struct __XYCE_STATUS
{
    MDWord  dwStatus;
    MDWord  dwLastRecordedFrameTS; //TS = TimeStamp, it's based on milliseconds
    MDWord  dwError;
    MVoid*  pData;
}XYCE_STATUS;


typedef struct __XYCE_PIPSRC_MODE
{
    MDWord  dwIdx;
    MBool   bIsSingleFrame;
    MDWord  dwTimePos;
}XYCE_PIPSRC_MODE;


typedef struct __XYCE_FB_PARAM
{
    MDWord dwID;
    MDWord dwValue;
}XYCE_FB_PARAM;


typedef struct __tagXYCE_PROCESS_RECT_INFO
{
    MRECT rtSrcPick;    //指在src上取某个区域，是相对workFrameSize的，并不是相对deviceFrameSize??? workFrameSize <= deviceFrameSize
    MRECT rtDstRender;  //指render到dst上某个区域是相对workFrameSize的，并不是相对deviceFrameSize??? workFrameSize <= deviceFrameSize
}XYCE_PROCESS_RECT_INFO;

@protocol XYCEDelegate <NSObject>
- (MRESULT) XYCEStatusDelegate :  (XYCE_STATUS*)status;
@end


typedef MDWord  (*CamEngine_CAPTURECALLBACK)(MDWord dwStatus,MVoid* pUserData);







/*
 * type definition for QCamEffect.type
 */
#define QCAM_EFFECT_TYPE_NONE         (0x00000000)
#define QCAM_EFFECT_TYPE_FILTER       (QCAM_EFFECT_TYPE_NONE + 1)   //param is NSString*
#define QCAM_EFFECT_TYPE_FX           (QCAM_EFFECT_TYPE_NONE + 2)   //param is NSString*
#define QCAM_EFFECT_TYPE_PIP          (QCAM_EFFECT_TYPE_NONE + 3)   //param is CXiaoYingPIPPO*
#define QCAM_EFFECT_TYPE_PASTER       (QCAM_EFFECT_TYPE_NONE + 4)   //param is NSString*
#define QCAM_EFFECT_TYPE_DIVA         (QCAM_EFFECT_TYPE_NONE + 5)   //param is NSString*
#define QCAM_EFFECT_TYPE_LYRIC        (QCAM_EFFECT_TYPE_NONE + 6)   //param is NSString*


/*
 *  type definition of QCamEffectUpdateItem.type
 */
#define QCAM_EFFECT_UPDATE_TYPE_NONE                (0x00000000)

/*! @constant  QCAM_EFFECT_UPDATE_TYPE_FILTER_PARAM refer to QCamEffectUpdateItem.data for more info */
#define QCAM_EFFECT_UPDATE_TYPE_FILTER_PARAM        (QCAM_EFFECT_UPDATE_TYPE_NONE + 1)  //item is QFilterParm*
/*! @constant  QCAM_EFFECT_UPDATE_TYPE_PIP_SRC refer to QCamEffectUpdateItem.data for more info */
#define QCAM_EFFECT_UPDATE_TYPE_PIP_SRC             (QCAM_EFFECT_UPDATE_TYPE_NONE + 2)  //item is QPIPSrc*
/*! @constant  QCAM_EFFECT_UPDATE_TYPE_PIP_SRC_MODE refer to QCamEffectUpdateItem.data for more info*/
#define QCAM_EFFECT_UPDATE_TYPE_PIP_SRC_MODE        (QCAM_EFFECT_UPDATE_TYPE_NONE + 3)  //item is QPIPSrcMode*
/*! @constant  QCAM_EFFECT_UPDATE_TYPE_TIMESTAMP refer to QCamEffectUpdateItem.data for more info*/
#define QCAM_EFFECT_UPDATE_TYPE_TIMESTAMP           (QCAM_EFFECT_UPDATE_TYPE_NONE + 4)  //item is QTimeInfo*
/*! @constant  QCAM_EFFECT_UPDATE_TYPE_FOCUS_PASTER refer to QCamEffectUpdateItem.data for more info*/
#define QCAM_EFFECT_UPDATE_TYPE_FOCUS_PASTER        (QCAM_EFFECT_UPDATE_TYPE_NONE + 5)  //item is NSNumber* (int) means face id
/*! @constant  QCAM_EFFECT_UPDATE_TYPE_UNFOCUS_PASTER refer to QCamEffectUpdateItem.data for more info*/
#define QCAM_EFFECT_UPDATE_TYPE_UNFOCUS_PASTER      (QCAM_EFFECT_UPDATE_TYPE_NONE + 6)  //item is NSNumber* (int) means face id
/*! @constant  QCAM_EFFECT_UPDATE_TYPE_PASTER_INFO refer to QCamEffectUpdateItem.data for more info*/
#define QCAM_EFFECT_UPDATE_TYPE_PASTER_INFO         (QCAM_EFFECT_UPDATE_TYPE_NONE + 7)  //item is QCamEffectPasterInfo*

#define QCAM_EFFECT_UPDATE_TYPE_BLEND_ALPHA         (QCAM_EFFECT_UPDATE_TYPE_NONE + 8)  //item is MFloat*

#define QCAM_EFFECT_UPDATE_TYPE_VIEW_ANGLES         (QCAM_EFFECT_UPDATE_TYPE_NONE + 9)  //item is

#define QCAM_EFFECT_UPDATE_TYPE_INSERT_NEW_TRAJECTORY         (QCAM_EFFECT_UPDATE_TYPE_NONE + 11) //refer to QCamEffectUpdateItem for more info
#define QCAM_EFFECT_UPDATE_TYPE_UPDATE_TRAJECOTRY   (QCAM_EFFECT_UPDATE_TYPE_NONE + 12)  //refer to QCamEffectUpdateItem for more info
#define QCAM_EFFECT_UPDATA_TYPE_REMOVE_TRAJECTORY   (QCAM_EFFECT_UPDATE_TYPE_NONE + 13)  //refer to QCamEffectUpdateItem for more info
#define QCAM_EFFECT_UPDATE_TYPE_REMOVE_ALL_TRAJECTORY   (QCAM_EFFECT_UPDATE_TYPE_NONE + 14)  //refer to QCamEffectUpdateItem for more info



/*! @constant  QCAM_INVALID_FACE_ID */
#define QCAM_INVALID_FACE_ID        (-1)


#define QCAM_EFFECT_INQUIRY_TYPE_NONE                   (0x00000000)
/*! @constant  QCAM_EFFECT_INQUIRY_TYPE_IS_IN_PASTER_REGION refer to QCamEffectInquiryResult.data and QCamEffectInquiryItem.auxiliaryData for more info*/
#define QCAM_EFFECT_INQUIRY_TYPE_IS_IN_PASTER_REGION    (QCAM_EFFECT_INQUIRY_TYPE_NONE + 1)
/*! @constant  QCAM_EFFECT_INQUIRY_TYPE_PASTER_INFO refer to QCamEffectInquiryResult.data and QCamEffectInquiryItem.auxiliaryData for more info*/
#define QCAM_EFFECT_INQUIRY_TYPE_PASTER_INFO            (QCAM_EFFECT_INQUIRY_TYPE_NONE + 2)
#define QCAM_EFFECT_INQUIRY_TRAJECTORY_COUNT            (QCAM_EFFECT_INQUIRY_TYPE_NONE + 3)


#define QCAM_FACE_DT_ORIENTION_ANY                       0

#define QCAM_FACE_DT_ORIENTION_0                         1

#define QCAM_FACE_DT_ORIENTION_90                        2

#define QCAM_FACE_DT_ORIENTION_180                       3

#define QCAM_FACE_DT_ORIENTION_270                       4

#define QCAM_FORWARD_MIRRORED                             0  //前置摄像头镜
#define QCAM_FORWARD_NOT_MIRRORED                         1  //前置摄像头不镜像
#define QCAM_BACKWARD_NOT_MIRRORED                        2  //后置摄像头不镜像

#endif //QCAMDEF_H
