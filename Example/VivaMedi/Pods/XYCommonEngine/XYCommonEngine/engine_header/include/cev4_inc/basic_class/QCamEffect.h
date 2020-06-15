


/*
 * please refer to QCamDef.h for more info of the type
 *
 *  for QCAM_EFFECT_TYPE_FILTER/QCAM_EFFECT_TYPE_FX/QCAM_EFFECT_TYPE_PASTER/QCAM_EFFECT_TYPE_DIVA
 *      src type is NSString* which is the template path
 *  for QCAM_EFFECT_TYPE_PIP
 *      src type is CXiaoYingPIPPO*
 *
 *  @description 
 *      TP Data = template parameter data, you can get the template data by another API [CXiaoYingUtils GetTemplateParamData]
 *      It's actually the same to AMVE_USER_DATA_TYPE struct
 *      Some template has several configurations, and engine will select one of them randomly if you don't give the
 *      setting you want. But if you give the setting (in the form of template-parameter data), engine will use the it
 *      without random selection.
 *  @param TPDataLen The data length of template parameter
 *  @param TPData The template parameter data. Actually you don't need to know what it the exact contains, just pass it
 *                to engine. This buffer will be deallocate automatically in ARC
 *  @param isControlledByApp it's used to identify if the effect-playback is controlled by caller.
 *  Background info: There are many kinds of effect, such as ie, sticker, diva, pip....
 * 					In the old days, when you set the ie, the ie effect is played forward by camera engine.
 * 					And startRecord/pauseRecord/resumeRecord/stopRecord will not affect the ie's pause/resume.
 * 					Now, you can tell camera engine, you want control the effect playback by this flat.
 *
 *  false means camera engine will control the effect-playback code-routine, just like in the old days.
 *  true means application will control the pause/resume of effect-playback code-routine via startRecord/pauseRecord/resumeRecord/stopRecord.
 *
 *
 *
 *  @description
 *      AV = Audio Visualization
 *  @param AVSrcAudio it's audio which is used to perform the audio-analysis
 *  @param AVSrcPosition it's the start postion of audio you pick
 *  @param AVSrcLength  it's the length of audio you pick
 *  @param isAVSrcRepeat it's used to identity if you wanna repeat the audio you pick
 *
 *
 *
 */




@interface QCamEffect : NSObject



@property(assign, nonatomic) unsigned int type;
@property(readwrite, nonatomic)  NSObject *src;
@property(assign, nonatomic) BOOL  isExported2Video;
@property(assign, nonatomic) BOOL  isCyclicMode;
@property(assign, nonatomic) unsigned int configIdx;
@property(assign, nonatomic) unsigned int ZOrder;
@property(assign, nonatomic) BOOL  isNeedFD;
@property(assign, nonatomic) BOOL  isNeedAR;
@property(assign, nonatomic) float timeScale;   //to control the effect presenting speed
@property(assign, nonatomic) unsigned int TPDataLen;
@property(assign, nonatomic) Byte* TPData;
@property(assign, nonatomic) BOOL isControlledByApp;

@property(readwrite, nonatomic)  NSString *AVSrcAudio;
@property(assign, nonatomic)  int   AVSrcPosition;
@property(assign, nonatomic)  int   AVSrcLength;
@property(assign, nonatomic)  BOOL  isAVSrcRepeat;

@property(readwrite, nonatomic) NSObject* lrcFilePath;
@property(assign, nonatomic) unsigned int additionalStartLen;
@property(assign, nonatomic) unsigned int additionalEndLen;
@property(assign, nonatomic) unsigned int rangePos;
@property(assign, nonatomic) unsigned int rangeLen;
@property(retain, nonatomic) NSArray* subTemplateArray;

/**
 *  duplicate
 *  @return a new QCamEffect instance
 */
- (QCamEffect*) duplicate;

/**
 *  cloneTPData
 *  @param pInput The template parameter data you want to clone. 
 *                You can use the method to set template parameter data
 */
- (void)cloneTPData : (AMVE_USER_DATA_TYPE*)pInput;
@end
