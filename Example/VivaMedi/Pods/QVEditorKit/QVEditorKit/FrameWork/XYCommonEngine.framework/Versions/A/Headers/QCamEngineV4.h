
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
          DeviceFrameSize : (MSIZE*) pDFSize    //based on pixel
                 WorkRect : (MRECT*) pWorkRect  //based on 1/10000 to Device Frame size
          DisplayRectInfo : (XYCE_PROCESS_RECT_INFO*) pDspInfo  //all the rect in XYCE_PROCESS_RECT_INFO is based on 1/10000, and it's relative to the worksize
//           ExportRectInfo : (XYCE_PROCESS_RECT_INFO*) pExpInfo  //先默认Exp时的SrcPick就对应了WorkSize，简化逻辑
          ExportFrameSize : (MSIZE*) pExpFrameSize  //ExportFrameSize: 被称为Encodeing Frame Size更科学，因为有角度的问题，所以最后用smart player放出的来尺寸可能横竖会对调一下
                   FDMode : (MDWord)dwFDMode
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
                     PIP2Update  : (CXiaoYingPIPPO*) pip;

/**
 *Process video data passed from camera
 *@param samplebuffer,video frame sample buffer
 *@param picturePath,path of exported picture
 *@return AMVE_ERR_NONE if the operation is successful,other value if failed
 **/
- (MRESULT) ExportingVideoData : (CMSampleBufferRef) samplebuffer
                        toPath : (NSString*) picturePath;



/**
*Process video data passed from camera
*@param samplebuffer,video frame sample buffer 
*@return AMVE_ERR_NONE if the operation is successful,other value if failed
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
//  ExportFrameWithEffect : (MBool)bWithEffect
//      DeviceOrientation : (UIDeviceOrientation)exportDO
         VideoSizeSecond: (CXIAOYING_SIZE)VideoSizeSecond
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
@end
