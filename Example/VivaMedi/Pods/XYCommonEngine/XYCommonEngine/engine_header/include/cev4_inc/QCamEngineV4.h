
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CoreMedia/CMSampleBuffer.h"
#import "amcomdef.h"
#import "mv2comdef.h"
#import "amdisplay.h"
#import <UIKit/UIView.h>
#import <UIKit/UIKit.h>

#import "etpipparamobject.h"
 
@protocol QCamEngineCallbackDelegate <NSObject>

- (MRESULT)onStat:(RecordStats)stat;

@end


@protocol QCamEngineModifyFrameRateDelegate <NSObject>

- (MRESULT)SetFrameRate:(MDWord)frameRate;
- (MRESULT)SetBitRate:(MDWord)bitRate;

@end

static MRESULT QCamEngineModifyFrameRate(MDWord value, MVoid *handler, MV2RecorderAdjustType type){
    if (!value || !handler)
    {
        return -1;
    }
    id <QCamEngineModifyFrameRateDelegate> _handler = (__bridge id<QCamEngineModifyFrameRateDelegate>)handler;
    
    switch(type){
        case MV2RECORDER_ADJUST_TYPE_FPS:{
            return [_handler SetFrameRate:value];
            break;
        }
        case MV2RECORDER_ADJUST_TYPE_BPS:{
            return [_handler SetBitRate:value];
            break;
        }
    }
    return 0;
}

/*!
 *  @brief it tarets on camera preview and record, with or without any effect
 *
 */
@interface QCamEngineV4 : NSObject <QCamEngineModifyFrameRateDelegate>
{

    
}
@property (readwrite, nonatomic) id<QCamEngineCallbackDelegate> delegate;


/**
 *Init camera engine
 *  @param pViewport is based on pixel
 *  @param pCropRelativeRect is based on 1/10000 
 *  @param pFrameSize is based on pixel, and it's the frame comes from camera device
 *  @param dwFDMode is defined as AMVE_FACEDT_MODE_XXX in etfacedtutils.h
 **/
- (MRESULT) InitCamEngine : (UIView*) pView
        DeviceOrientation : (UIDeviceOrientation) DO
         DisplayPixelRect : (MRECT*) pViewport
          DeviceFrameSize : (MSIZE*) pDFSize    //based on pixel, for AR mode, you can inquire the supported device frame size by API: performStaticOperation with inquiry item(QCAM_SOP_INQUIRY_AR_XXX_VIDEO_FORMATS)
                 WorkRect : (MRECT*) pWorkRect  //based on 1/10000 to Device Frame size
          DisplayRectInfo : (XYCE_PROCESS_RECT_INFO*) pDspInfo  //all the rect in XYCE_PROCESS_RECT_INFO is based on 1/10000, and it's relative to the worksize
//           ExportRectInfo : (XYCE_PROCESS_RECT_INFO*) pExpInfo  //先默认Exp时的SrcPick就对应了WorkSize，简化逻辑
          ExportFrameSize : (MSIZE*) pExpFrameSize
                   FDMode : (MDWord)dwFDMode //face detection mode
                  arParam : (QVCE_AR_INIT_PARAM*)arParam
              LicensePath : (MTChar*) szLicensePath;


- (MVoid) UnInitCamEngine;


/**
 *@param hPIP is the new PIP you want to update.
 *          It means you have already set a PIP-effect before, and you want to update it when you change the display
 *          (Enabling update PIP while updating Display-context can level-up the performance of Cam-Engine)
 *          The new hPIP is only to be used when you have set the PIP before, otherwise it will be ignored
 **/
- (MRESULT) UpdateDisplayContext : (UIDeviceOrientation) newDO
               DisplayRectInView : (MRECT*) pViewPort
                        WorkRect : (MRECT*) pWorkRect
                 DisplayRectInfo : (XYCE_PROCESS_RECT_INFO*) pDspInfo
                 ExportFrameSize : (MSIZE*) pExpFrameSize
                     PIP2Update  : (CXiaoYingPIPPO*) pip
             arDeviceOrientation : (MInt32)arDO; //QVAR_UI_DEVICE_XXX defined in libqvar.hpp, this parameter is only used in AR-Mode


					 
/**
*
*Process video data passed from camera
*@param samplebuffer,video frame sample buffer 
*@param picturePath,path of exported picture
*@param bMirror,mirror flag
*@return AMVE_ERR_NONE if the operation is successful,other value if failed
**/
- (MRESULT) ExportingVideoData : (CMSampleBufferRef) samplebuffer
						toPath : (NSString*) picturePath
                     withMirror:(BOOL) bMirror;


/**
 *Process video data passed from camera
 *@param buffer,video frame sample buffer
 *@param picturePath,path of exported picture
 *@param withOutWidth/andOutHeight,output size
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
- (MRESULT) ExportingVideoData : (CVPixelBufferRef)buffer
                        toPath : (NSString*) picPath
                    withMirror:(BOOL) bMirror
                   withOutWidth:(size_t)owidth
                   andOutHeight:(size_t)oheight;



/**
 *  In AR Mode: app should not call this API!!! the AR-Camera src is embeded in CE
*   Process video data passed from camera
    @function for AR Mode, app don't need to call this function.
*   @param samplebuffer,video frame sample buffer
*   @return AMVE_ERR_NONE if the operation is successful,other value if failed
 *
**/
- (MRESULT) ProcessingVideoData : (CMSampleBufferRef) samplebuffer;


/**
 *Process audio data passed from camera
 *@param samplebuffer,audio frame sample buffer
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
- (MRESULT) ProcessingAudioData : (CMSampleBufferRef) samplebuffer;

/**
 *Start record
 *@param strFileName,url of record file
 *@param bHasAudio,audio track flag
 *@parm dwESUCount, Ex. dwESUCount = 2 means only one frame is exported when every two frames send to CE. Now it's scale is [1, 16]
 *  @param wmCode is the the watermark code you wanna embed into the videofile. it can be nil
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
- (MRESULT) StartRecord : (const NSArray*)  pNSSFileName
          HasAudioTrack : (MBool) bHasAudio
            DubbingInfo : (QCamDubbingInfo*) dubbingInfo
     InputPCMSampleRate : (MDWord)dwPCMSampleRate
       InputPCMChannels : (MDWord)dwPCMChannels
        ExportUnitCount : (MDWord)dwEUCount
           maxFrameRate : (MDWord)dwFrameRate //Ex. 30000 = 30FPS
                 wmCode : (NSString*)wmCode;


/**
 *Stop record
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
-(MRESULT) StopRecord;


/**
 *Pause record
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
-(MRESULT) PauseRecord;

/**
 *Resume record
 *@param dwEUCount, refer to StartRecord for more info
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
-(MRESULT) ResumeRecord : (MDWord)dwEUCount;


-(MRESULT) CancelRecord;

/**
 *Resume record
 *@param rotate, 90.0, 180.0, 270.0, -90.0, -180.0......
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
-(MRESULT) SetRotate : (MFloat) rotate;


/**
 *Set jpg file path when take a picture
 *@param strFileName,jpg file path
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
-(MRESULT) CapturePhoto : (const NSString*) pNSSPhotoPath
            TextureInput: (MHandle) hTxt;


/**
 *Register capture picture callback
 *@param capturecallback,capture callback pointer
 *@param pUserData,user data
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
-(MRESULT) RegisterCaptureCallback : (CamEngine_CAPTURECALLBACK) capturecallback
                          UserData : (MVoid*)pUserData;


/**
 *Set digital zoom factor
 *@param fFactor,zoom factor,from 0 ~ 1.0
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
- (MRESULT) SetZoomFactor : (MFloat) fFactor;



/*!
 *  @param dwPropertyID It's XYCE_PROP_XXX defined in QCamDef.h
 *
 *          If dwPropertyID equals to XYCE_PROP_CAMERA_SRC_FACE_SOFTEN_VALUE, pValue is an instance of NSNumber(int).
 *          Its value range is [0, 100], and 0 means no soften processing, and 100 means maximum amount softern processing.
 *
 *          If dwPropertyID equals to XYCE_PROP_CAMERA_SRC_FACE_BRIGHTEN_VALUE, pValue is an instance of NSNumber(int).
 *          Its value range is [0, 100], and 0 means no brighten processing, and 100 means maximum amount brighten processing.
 *
 * 			The processing result of XYCE_PROP_CAMERA_SRC_FACE_SOFTEN_VALUE and XYCE_PROP_CAMERA_SRC_FACE_BRIGHTEN_VALUE
 * 			is similar to the template-effect set via [QCamEngineV4 SetEffect], but this processing is applied to the camera capture
 * 			source, which means the camera-device output pictures are already presented with the soft or bright style.
 * 			So we can say that the processing routine is different from the [QCamEngineV4 SetEffect].
 *
 * 			Of course, you can set the template-effect of dermabrasion and face-beautify after you have set the
 * 			XYCE_PROP_CAMERA_SRC_FACE_SOFTEN_VALUE and XYCE_PROP_CAMERA_SRC_FACE_BRIGHTEN_VALUE.
 * 			But we don't recommend to do this, because the result between these two kinds of way is similar.
 *
 *          BE AWARE: you'd better set XYCE_PROP_FD_INTERVAL to 1, if you want to use soften and brighten value. 
 *                    Because these two processes depend on face-detection
 *  @param pValue is the property value
 */
- (MRESULT) SetProperty : (MDWord) dwPropertyID
                  Value : (MVoid*) pValue;






/*!
 *  @brief Set the effect. This is an asynchronous API
 *
 *  @param list element is QCamEffect
 *
 *  @return 0 if success, otherwise is a non-zero value
 */
- (MRESULT) SetEffect : (NSArray*)list;



/*!
 *  @brief Update the effect parameter, info, or status....
 *  This is an asynchronous API
 *
 *  @param itemList element is QCamEffectUpdateItem
 *
 *  @return 0 if success, otherwise is a non-zero value
 */
- (MRESULT) UpdateEffect : (NSArray*)itemList;




/*!
 *  @brief Inquire the effect info, status or other parameter....
 *  This API is different to the UpdateEffect and SetEffect. It's synchronous.
 *
 *  @param itemList element is QCamEffectInquiryItem
 *
 *  @return array of QCamEffectInquiryResult
 */
- (NSArray*) InquireEffect : (NSArray*)itemList;

/*!
 *  @brief Do 3D hit test
 *  @param pTouchPoint user's touch point
 *  @param pRes,hit test result
 *  @return 0 if success, otherwise is a non-zero value
 */
- (MRESULT) Do3DHitTest : ( MPOINT* _Nonnull )pTouchPoint
                TestRes : (QVET_3D_HITTEST_RES* _Nonnull)pRes;



/*!
    @brief  perform the operation according to the opType by CE. Different opType needs different input paramList, and also will get different reesult.
            For asynchronized operation:
                app will be notified by the event of XYCE_STATUS_OPERATION_DONE and the corresponding operation type.
                Refer to the definition of "XYCEDelegate" and "XYCE_STATUS" for more info.
                Especially, if some operations return the result in the form of OC object, you can get it by XYCE_STATUS.pData
                In addition to this API's return code, app should also take the XYCE_STATUS.dwError to be considered passed by XYCEDelegate.
            For synchronized operation:
                Please pay attention to the error-code returned directly.

 
    @param  opType
                QCAM_OP_ADD_AR_3DMODEL
                    Operation way: asynchronizaton
                    paramList:  1 nodes. It's QARModelAddParam, and refer to its definition for more info 
                    @return no XYCE_STATUS.pData is needed
 

                QCAM_OP_REMOVE_AR_3DMODEL
                    Operation way: asynchronizaton
                    paramList: 1 node. It's NSNumber(int) which is the scene ID, which app has set.
                    @return: no XYCE_STATUS.pData is needed
 
                QCAM_OP_TEST_AR_3DMODEL_HIT
                    Operation way: asynchronizaton
                    paramList: contains 1 node. It's QPointFloat basing on screen coordination, and its value is normalized(0~1).
                    @return: by XYCEDelegate. XYCE_STATUS.pData is an NSArray containing the NSNumber(int), which are the scene IDs. The array's node count >= 0.
 
                QCAM_OP_SET_AR_3DMODEL_POSITION
                QCAM_OP_SET_AR_3DMODEL_SCALE
                QCAM_OP_SET_AR_3DMODEL_ROTATION
                     Operation way: asynchronizaton
                     paramList: 2 nodes.
                                One is NSNumber(int). It's scene ID.
                                The other one is QAR3DSpaceParam.
                                    For postion, it's corresponding to x/y/z basing on screen coordination, and the value is normalized(0~1).
                                    For scale/rotation, it's corresponding to relative 3D space param. Specially, the rotation bases on radian.
                     @return: no XYCE_STATUS.pData is needed.

 
                QCAM_OP_GET_AR_3DMODEL_POSITION
                QCAM_OP_GET_AR_3DMODEL_SCALE
                QCAM_OP_GET_AR_3DMODEL_ROTATION
                     Operation way: asynchronizaton
                     paramList: 1 node. It's NSNumber(int), which is scene ID.
                     @return:   by XYCEDelegate. XYCE_STATUS.pData is QAR3DSpaceParam.
                                     For postion, it's corresponding to x/y/z, and the value is normalized(0~1).
                                     For scale/rotation, it's corresponding to relative 3D space param. Specially, the rotation bases on radian.
 
                QCAM_OP_REMOVE_ALL_3DMODEL
                     Operation way: asynchronizaton
                     paramList: nil
                     @return:   no XYCE_STATUS.pData is needed.
 
                QCAM_OP_AR_3DMODEL_MOVE_BEGIN
                     Operation way: asynchronizaton
                     paramList: 1 node. It's QPointFloat basing on screen coordination, and it's value normalized(0~1).
                                it's the touch-starting point when you move. Internal module will select model(s) by hit-test for app.
                                This operation is always followed by MOVE and MOVE_END listed below.
                     @return:   no XYCE_STATUS.pData is needed.
 
                QCAM_OP_AR_3DMODEL_MOVE
                     Operation way: asynchronizaton
                     paramList: 1 node. It's QPointFloat basing on screen coordination, and it's value normalized(0~1).
                                It means moving to which point.
                     @return:   no XYCE_STATUS.pData is needed.
 
                QCAM_OP_AR_3DMODEL_MOVE_END
                     Operation way: asynchronizaton
                     paramList: nil
                     @return:   no XYCE_STATUS.pData is needed.

                QCAM_OP_PAUSE_AR
                QCAM_OP_RESUME_AR
                QCAM_OP_RESET_AR
                    Operation way: synchronization
                    paramList: nil
                    @return:   no XYCE_STATUS.pData is needed.
 
                QCAM_OP_ENABLE_AR_PLANE_DISPLAY
                    Operation way: asynchronization
                    paramList: 1 node. It's QARPlaneDisplayEnableParam
                    @return:   no XYCE_STATUS.pData is needed.
 
                QCAM_OP_SET_AR_PLANE_DETECTION_ORIENTATION
                     Operation way: asynchronization
                     paramList: 1 node. It's NSNumber(int), whose value is QVAR_PLANE_DETECT_ORIENTATION_XXX defeined in libqvar.hpp
                     @return:   no XYCE_STATUS.pData is needed.
 
                QCAM_OP_ADD_ARPEN
                    Operation way: asynchronizaton
                    paramList: 1 element. It's QARPenAddParam and refer to the definition for more info
                    @return:   no XYCE_STATUS.pData is needed.
 
                QCAM_OP_REMOVE_ARPEN
                    Operation way: asynchronizaton
                    paramList: 1 element. It's NSNumber(int), which is the AR-pen ID when you add.
                    @return:   no XYCE_STATUS.pData is needed.

                QCAM_OP_REMOVE_ALL_ARPEN
                    Operation way: asynchronizaton
                    paramList: nil.
                    @return:   no XYCE_STATUS.pData is needed.
 
                QCAM_OP_ARPEN_DRAW_BEGIN
                    Operation way: asynchronizaton
                    paramList:  2 elements.
                                1st is the NSNumber(int), which is the AR-pen ID.
                                2nd is the QPointFloat, wihch is the point you touch to the screen. The value is  normalized(0~1), and bases on screen coordination.
                    @return:   no XYCE_STATUS.pData is needed.

                QCAM_OP_ARPEN_DRAW
                    Operation way: asynchronizaton
                    paramList:  2 elements.
                                1st is the NSNumber(int), which is the AR-pen ID.
                                2nd is the QPointFloat, wihch is the point on your move path. The value is  normalized(0~1), and bases on screen coordination.
                    @return:   no XYCE_STATUS.pData is needed.
 
                QCAM_OP_ARPEN_DRAW_END
                    Operation way:  asynchronizaton
                    paramList:      1 element. It's NSNumber(int), which is the AR-pen ID.
                    @return:        no XYCE_STATUS.pData is needed.
 
                QCAM_OP_UPDATE_DISPLAY
                     Operation way:  asynchronizaton
                     paramList:      Every element should be the QCamDisplayContext*. Every QCamDisplayContext is correspond to the preview layout, and CE will perform
                                     the display update one by one, and hold preview layout according to the last QCamDisplayContext in list.
                     @return:        no XYCE_STATUS.pData is needed.

 */
- (MRESULT)performOperation : (MDWord)opType
                    opParam : (NSArray*)paramList;


/*!
    @brief  perform class operation
    @param  opType
                QCAM_SOP_INQUIRY_AR_TRACKING
                    Operation way:  synchronizaton
                    paramList:      nil
                    @return         every element of NSArray is NSNumber(int), whose value is defined as QVCE_AR_TRACKING_TYPE_XXX
                    @brief          These inquiry is related to QVCE_AR_INIT_PARAM when you call InitCamEngine
 
                QCAM_SOP_INQUIRY_AR_DOF6_VIDEO_FORMATS
                QCAM_SOP_INQUIRY_AR_DOF3_VIDEO_FORMATS
                QCAM_SOP_INQUIRY_AR_FACE_VIDEO_FORMATS
                    Operation way:  synchronizaton
                    paramList:      nil
                    @return         every element of NSArray is QARVideoFormat. Refer to the definition of QARVideoFormat for more info.
                    @brief          These inquiry is related to QVCE_AR_INIT_PARAM when you call InitCamEngine
 */
+ (NSArray*)performStaticOperation : (MDWord)opType
                           opParam : (NSArray*)paramList;

@end
