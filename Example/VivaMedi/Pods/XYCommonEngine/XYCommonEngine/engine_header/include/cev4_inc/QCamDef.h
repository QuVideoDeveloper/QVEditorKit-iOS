#ifndef QCAMDEF_H
#define QCAMDEF_H

#import <GLKit/GLKit.h>


#define XYCE_PROP_NONE                  0x00000000
//#define XYCE_PROP_RECORDING_EFFECT      0x00000001  //means the effect is involved in the exported video
#define XYCE_PROP_INPUTFRAME_CROPSIZE   0x00000002
#define XYCE_PROP_DELEGATE              0x00000003
#define XYCE_PROP_TEMPLATE_ADAPTER      0x00000004
#define XYCE_PROP_FONT_ADAPTER          0x00000005
//FD = Face Detector, supplied by arcsoft
#define XYCE_PROP_FD_INTERVAL           0x00000006  //face detection interval, how many frams for one-detection
#define XYCE_PROP_FD_DATA_FILE          0x00000007
/*! @constant  XYCE_PROP_CAMERA_SRC_FACE_SOFTEN_VALUE refer to [QCamEngineV4 SetProperty] for more info */
#define XYCE_PROP_CAMERA_SRC_FACE_SOFTEN_VALUE      0x00000008  //feature supplied by arcsoft's FD lib
/*! @constant  XYCE_PROP_CAMERA_SRC_FACE_BRIGHTEN_VALUE refer to [QCamEngineV4 SetProperty] for more info */
#define XYCE_PROP_CAMERA_SRC_FACE_BRIGHTEN_VALUE    0x00000009  //feature supplied by arcsoft's FD lib

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
#define XYCE_PROP_PAUSE_EFFECT_TIMER                0x0000001f
#define XYCE_PROP_SET_BACKGROUND_COLOR              0x00000020
#define XYCE_PROP_3D_FACE_DATA                      0x00000021 //3D人脸重建数据





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
#define XYCE_STATUS_RENDER_TO_FILE             0x00200000
#define XYCE_STATUS_RENDER_TO_FILE_NOT_READY   0x00400000
#define XYCE_STATUS_OPERATION_DONE      0x00800000
#define XYCE_STATUS_AR_SESSION_READY    0x00800001   // Session正常工作状态或中断结束，
#define XYCE_STATUS_AR_SESSION_FAILURED  0x00800002   // AR Session由于发生某种错误而停止运行，建议重启AR CE
// AR Session被临时打断(比如系统相机被临时占用，或程序临时切换至后台，或来不及处理)
// 此时AR系统已不再处理音视频帧和跟踪相机空间位置。中断结束后状态会切换成QVAR_STATE_SESSION_NORMAL
// 一般可用于调整录制时间戳，比如在记录中断总时长，并用于调整中断结束后的视频帧时间，保证时间连续性。
#define XYCE_STATUS_AR_SESSION_INTERRUPTED   0x00800003
#define XYCE_STATUS_AR_TRACKING_NORMAL   0x00800004 // 相机跟踪状态有效，此时可有效提供3D空间位置，该状态之后添加模型或物体能够展示更佳AR效果
#define XYCE_STATUS_AR_TRACKING_LIMITED  0x00800005 // 相机跟踪状态依旧有效，但此时相机位置可能已经存在较大偏差，空间相对位置已不够准确，画面中物体可能存在较大抖动或漂移
#define XYCE_STATUS_AR_TRACKING_UNAVAILABLE  0x00800006 // 相机跟踪状态无效，已无法有效提供相机和物体的空间3D位置，AR效果丢失(当跟踪状态从有效变成无效后内部会有tracking-reset行为发生）
#define XYCE_STATUS_AR_PLANE_INFO_UPDATED    0x00800007 // the pData of XYCE_STATUS is NSArray* and its element is QARPlaneProperty


#define XYCE_EXPRESSION_PASTER_NONE                    -1
#define XYCE_EXPRESSION_PASTER_STOPPED                 0
#define XYCE_EXPRESSION_PASTER_STARTED                 1
#define XYCE_EXPRESSION_PASTER_DOING                   2
#define XYCE_EXPRESSION_PASTER_SWITCH                  3


//typedef enum _tag_hit_type {
//    QVAR_HIT_TYPE_PLANEPOINTHIT = 0,
//    QVAR_HIT_TYPE_SPACEPOINTHIT ,
//    QVAR_HIT_TYPE_FROCE_32BIT = 0x7FFFFFFF
//} QVARhitType;
#define QVCE_AR_HIT_TYPE_PLANEPOINTHIT  0x00000000 //same to the definition of internal AR module's QVARhitType
#define QVCE_AR_HIT_TYPE_SPACEPOINTHIT  0x00000001 //same to the definition of internal AR module's QVARhitType


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
    MDWord  dwStatus;   //XYCE_STATUS_XXX, such as XYCE_STATUS_RECORDING, XYCE_STATUS_OPERATION_DONE
    MDWord  dwOpType; //such as QCAM_OP_LOAD_AR3D_MODEL, it's an additional tag
    MDWord  dwLastRecordedFrameTS; //TS = TimeStamp, it's based on milliseconds
    MDWord  dwError;
    MVoid*  pData; //different status has different pData(or OC object), it may also be NULL(or nil).
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
#define QCAM_EFFECT_TYPE_COMBO_FILTER (QCAM_EFFECT_TYPE_NONE + 7)


/*
 *  type definition of QCamEffectUpdateItem.type
 *
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
#define QCAM_EFFECT_UPDATE_TYPE_SUB_TEMPLATE_ID     (QCAM_EFFECT_UPDATE_TYPE_NONE + 10) //item is QVET_SUB_TEMPLATE_ID
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





//typedef enum _tag_qvar_tracking_type {
//    QVAR_TRACKING_TYPE_NONE = 0,
//    QVAR_TRACKING_TYPE_DOF6,        // 6 degree of freedom of tracking. (rotation and position -- world tracking)
//    QVAR_TRACKING_TYPE_DOF3,        // 3 degree of freedom of tracking. (rotation only -- orientation tracking)
//    QVAR_TRACKING_TYPE_FACE,        // unsupported yet (face tracking)
//    QVAR_TRACKING_TYPE_FORCE_32BIT = 0x7FFFFFFF
//} QVARtrackingType;
#define QCAM_AR_TRACKING_TYPE_NONE      0
#define QCAM_AR_TRACKING_TYPE_DOF6      1        // 6 degree of freedom of tracking. (rotation and position)
#define QCAM_AR_TRACKING_TYPE_DOF3      2        // 3 degree of freedom of tracking. (rotation only)
#define QCAM_AR_TRACKING_TYPE_FACE      3        // unsupported yet


//QCAM_OP_XXX is not limited in AR operation, it can be expanded by other CE Operation. refer to CE's API "performOperation" for more info.
#define QCAM_OP_NONE                        0x00000000
#define QCAM_OP_BASE                        0x00000100
#define QCAM_OP_UPDATE_DISPLAY              (QCAM_OP_BASE+1)

#define QCAM_OP_AR_BASE                    (0x00000200)
#define QCAM_OP_ADD_AR_3DMODEL             (QCAM_OP_AR_BASE+1)
#define QCAM_OP_REMOVE_AR_3DMODEL          (QCAM_OP_AR_BASE+2)
#define QCAM_OP_TEST_AR_3DMODEL_HIT        (QCAM_OP_AR_BASE+3)
#define QCAM_OP_SET_AR_3DMODEL_POSITION    (QCAM_OP_AR_BASE+4)
#define QCAM_OP_SET_AR_3DMODEL_SCALE       (QCAM_OP_AR_BASE+5)
#define QCAM_OP_SET_AR_3DMODEL_ROTATION    (QCAM_OP_AR_BASE+6)
#define QCAM_OP_GET_AR_3DMODEL_POSITION    (QCAM_OP_AR_BASE+7)
#define QCAM_OP_GET_AR_3DMODEL_SCALE       (QCAM_OP_AR_BASE+8)
#define QCAM_OP_GET_AR_3DMODEL_ROTATION    (QCAM_OP_AR_BASE+9)
#define QCAM_OP_REMOVE_ALL_3DMODEL         (QCAM_OP_AR_BASE+10)
#define QCAM_OP_AR_3DMODEL_MOVE_BEGIN       (QCAM_OP_AR_BASE+11)
#define QCAM_OP_AR_3DMODEL_MOVE             (QCAM_OP_AR_BASE+12)
#define QCAM_OP_AR_3DMODEL_MOVE_END         (QCAM_OP_AR_BASE+13)
#define QCAM_OP_PAUSE_AR                    (QCAM_OP_AR_BASE+14)
#define QCAM_OP_RESUME_AR                   (QCAM_OP_AR_BASE+15)
#define QCAM_OP_RESET_AR                    (QCAM_OP_AR_BASE+16)
#define QCAM_OP_ENABLE_AR_PLANE_DISPLAY     (QCAM_OP_AR_BASE+17)
#define QCAM_OP_SET_AR_PLANE_DETECTION_ORIENTATION  (QCAM_OP_AR_BASE+18)



//pen相关的单独操作废弃: 改用effect 模板的套路走。全部调整完后，删除！
//其他相关清理项:
//    QARPenAddParam
//    QARPen
//    CE的函数
//    一些工具函数
#define QCAM_OP_ADD_ARPEN                   (QCAM_OP_AR_BASE+57)
#define QCAM_OP_REMOVE_ARPEN                (QCAM_OP_AR_BASE+58)
#define QCAM_OP_REMOVE_ALL_ARPEN            (QCAM_OP_AR_BASE+59)
#define QCAM_OP_ARPEN_DRAW_BEGIN            (QCAM_OP_AR_BASE+60)
#define QCAM_OP_ARPEN_DRAW                  (QCAM_OP_AR_BASE+61)
#define QCAM_OP_ARPEN_DRAW_END              (QCAM_OP_AR_BASE+62)






#define QCAM_SOP_AR_BASE                        (0x00000300)
#define QCAM_SOP_INQUIRY_AR_TRACKING            (QCAM_SOP_AR_BASE+1) //SOP = static operaiton, inquiry supported track type
#define QCAM_SOP_INQUIRY_AR_DOF6_VIDEO_FORMATS  (QCAM_SOP_AR_BASE+2) //SOP = static operaiton, to inquire the supported video format by DOF6-Tracking, refer to definiton of QARVideoFormat and QCAM_AR_TRACKING_TYPE_XXX for more info
#define QCAM_SOP_INQUIRY_AR_DOF3_VIDEO_FORMATS  (QCAM_SOP_AR_BASE+3) //related to DOF3-Tracking
#define QCAM_SOP_INQUIRY_AR_FACE_VIDEO_FORMATS  (QCAM_SOP_AR_BASE+4) //related to FACE-Tracking


#define QCAM_AR_PEN_TYPE_NONE           (0)
#define QCAM_AR_PEN_TYPE_COLOR          (QCAM_AR_PEN_TYPE_NONE+1) //color and width can be set
#define QCAM_AR_PEN_TYPE_TEMPLATE       (QCAM_AR_PEN_TYPE_NONE+2) //the pen-template is related

typedef struct __tag_XYCE_AR_INIT_PARAM
{
    MBool  enableAR;
    MDWord trackingType; //QCAM_AR_TRACKING_TYPE_XXX
    MDWord frameRate; //Ex. 30000 = 30 fps. For AR camera, the camera device is controlled by internal AR module. And this frameRate is related to the trackingType. you should inquire it first by API:performStaticOpertion with inquire item of QCAM_SOP_INQUIRY_AR_XXX_VIDEO_FORMATS
    
    
    //for enable plane display: refer to qvarfxEnablePlaneDisplay() defined in libqvar.hpp for more info
    MInt32 dvcOrientation; //dvc = device; QVAR_UI_DEVICE_XXX deffined in libqvar.hpp
    MInt32 plnDtcOrientation; //plnDtc = plane detection; QVAR_PLANE_DETECT_ORIENTATION_XXX defined in libqvar.hpp
    MInt32 plnDspOrientation; //plnDsp = plane display; QVAR_PLANE_DISPLAY_ORIENTATION_XXX defined in libqvar.hpp
    MPCChar pic; // pPath 为自定义的平面图片路径，默认使用白色显示检测到的平面，建议在qvarfxStart之前设置
    
}QVCE_AR_INIT_PARAM;


#endif //QCAMDEF_H
