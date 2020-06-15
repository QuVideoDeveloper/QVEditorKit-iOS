/*
*
* History
*    
* 2015/03/05
* - Init version.
*
*/

#ifndef _QVET_EFFECT_PROCESSOR_H_
#define _QVET_EFFECT_PROCESSOR_H_

#define QVET_EFFECT_PROCESS_END				(QVET_ERR_EFTPS_BASE)

#define QVET_EP_PROP_BASE                          0
#define QVET_EP_PROP_IS_EXPRESSION_EFFECT          (QVET_EP_PROP_BASE + 1)
#define QVET_EP_PROP_EXPRESSION_DISPLAY_STATE      (QVET_EP_PROP_BASE + 2)
#define QVET_EP_PROP_OT_HANDLE                     (QVET_EP_PROP_BASE + 3)
#define QVET_EP_PROP_IS_OT_EFFECT                  (QVET_EP_PROP_BASE + 4)
#define QVET_EP_PROP_FLITER_BLEND_ALPHA			   (QVET_EP_PROP_BASE + 5)
#define QVET_EP_PROP_VIEW_ANGLES                   (QVET_EP_PROP_BASE + 6)
#define QVET_EP_PROP_3D_TRANSLATE                  (QVET_EP_PROP_BASE + 7)
#define QVET_EP_PROP_3D_ROTATE                     (QVET_EP_PROP_BASE + 8)
#define QVET_EP_PROP_3D_SCALE                      (QVET_EP_PROP_BASE + 9)
#define QVET_EP_PROP_3D_TRANSLATE_CUR              (QVET_EP_PROP_BASE + 10)
#define QVET_EP_PROP_3D_ROTATE_CUR                 (QVET_EP_PROP_BASE + 11)
#define QVET_EP_PROP_3D_SCALE_CUR                  (QVET_EP_PROP_BASE + 12)
#define QVET_EP_PROP_3D_BOUND_BOX                  (QVET_EP_PROP_BASE + 13)
#define QVET_EP_PROP_SUB_TEMPLATE_ID               (QVET_EP_PROP_BASE + 14)
#define QVET_EP_PROP_TRAJECTORY                    (QVET_EP_PROP_BASE + 15)
#define QVET_EP_PROP_AR_INFO					   (QVET_EP_PROP_BASE + 16)
#define QVET_EP_CONFIG_EFFECT_HANDLE               (QVET_EP_PROP_BASE + 17)
#define QVET_EP_PROP_TRACK_SIZE                    (QVET_EP_PROP_BASE + 18)
#define QVET_EP_PROP_AV_MUSIC_INFO                 (QVET_EP_PROP_BASE + 19)

#define QVET_EFFECT_TYPE_NONE				0
#define QVET_EFFECT_TYPE_IE					1		//IE
#define QVET_EFFECT_TYPE_FX					2		//FX
#define QVET_EFFECT_TYPE_PIP				3		//PIP
#define QVET_EFFECT_TYPE_PASTER				4		//paster
#define QVET_EFFECT_TYPE_LYRICS				5		//lyrics
#define QVET_EFFECT_TYPE_DIVA				6		//VAVIDIVA
#define QVET_EFFECT_TYPE_COMBO_IE           7       //combo ie


#define QVET_EXPRESSION_PASTER_NONE                    -1
#define QVET_EXPRESSION_PASTER_STOPPED                 0
#define QVET_EXPRESSION_PASTER_STARTED                 1
#define QVET_EXPRESSION_PASTER_DOING                   2
#define QVET_EXPRESSION_PASTER_SWITCH                  3

#define QVET_EXPRESSION_STATE_NOWAIT        0
#define QVET_EXPRESSION_STATE_MUSTWAIT      1        //该人脸存在需要进行等待播放完毕的触发动画

class CQVETRenderEngine;

typedef struct  
{
    MTChar* pszText;  //字符串内容
	MTChar* pszFont;  //字体
	MDWord dwDuration;  //持续时间
	MRECT RCRegion;     //文字显示区域，单位为万分比
}QVET_EFFECT_TEXT_PARAM;

//存放Cam Effect的某些相关状态用于显示
typedef struct
{
    MWord nExpState;    //某个人脸当前的Exp状态
    MWord nFaceIndex;   //入参，人脸的数组ID
}QVET_EFFECTS_EXPSTATE;

typedef MRESULT (*QVET_CAM_EFFECT_GET_EXPSTATE_CALLBACK)(QVET_EFFECTS_EXPSTATE & struState/*in*/, MVoid* pUserData);

typedef struct
{
    QVET_CAM_EFFECT_GET_EXPSTATE_CALLBACK pFunGetExpState;  //表情回调函数指针
    MVoid * pUserData;  //user data
}QVET_EFFECTS_EXPSTATE_MENDER;

typedef struct  
{
	QVET_TEMPLATE_ADAPTER*	pTemplateAdapter;
	QVET_FONT_FINDER* pFontFinder;
	MDWord	dwDstWidth;
	MDWord	dwDstHeight;
	MTChar*	pszTemplateFile;
	MLong	lCfgIndex;		//确定模板里某个子配置
	AMVE_USER_DATA_TYPE tpmData; //模板应用参数，目前只有Diva模板有效
	MDWord	dwFlipState;	//frame的翻转配置
	MFloat	fRotation;		//frame的旋转角度

	MTChar* pszAVSrcAudio;
	AMVE_POSITION_RANGE_TYPE	AVSrcRange;
	MBool	bAVSrcRepeat;
	QVET_EFFECT_TEXT_PARAM TextParam;
    MInt64 subTemplateID[2]; //滤镜切换时，两个子滤镜的ID
    QVET_EFFECTS_EXPSTATE_MENDER  struExpStateMender;   //修改和获取所属Cam的某些状态信息
	MHandle ar;//create by libqvar
	MTChar* pszAVResPath;
	MBool bAVForceRebuild;
	MDWord dwAVAudioLenAll;  //包含repeat的音频长度} QVET_EFFECT_OPENPARAM;
	MTChar* psz3DFaceData; //3D人脸重建数据文件
} QVET_EFFECT_OPENPARAM;

typedef struct
{
	MTChar *pszTRCLyrics;
	MTChar *pszTemplateFile;
	MSIZE	BGSize;
    QVET_ADDITIONAL_TIME additionalTime;
    MFloat timeScale;
    AMVE_POSITION_RANGE_TYPE range;
} QVET_TRC_LYRICS_OPENPARAM;

typedef struct  
{
	MDWord dwDataCS;		//MV2_COLOR_SPACE_XXX，hData可以为MBITMAP*, hSampleBuf, hTexture
	MHandle hData;			
	MRECT rcBitmap;
	MDWord dwRotation;		//0, 90, 180, 270
	MDWord dwFlipState;		//QREND_X_FLIP_MASK, QREND_Y_FLIP_MASK
} QVET_FRAME_DATA;

typedef struct
{
    MBool  bIsVaild;
    MDWord dwLastFaceCount;//上次人脸检测个数
    MDWord dwFaceIndex;
    MDWord dwApplyFace;
    MDWord dwDetectFaceCount;
    MDWord dwOpacity[AMVE_FACEDT_MAX_FACE_COUNT];
}QVET_EP_RANDOM_FACE_PASTER;


typedef QVET_EFFECT_PROPDATA QVET_EP_PROP;

#ifdef __cplusplus
extern "C"
{
#endif

// EP = Effect Processor

/*
* 功能：
*	创建Effect Processor
* 参数：
*	pRenderEngine: render engine的实例，processor内部会用render engine做一些纹理相关的处理
*	dwEftType: Effect的类型，QVET_EFFECT_TYPE_XXX
*	pEftParam: Effect的详细参数，
*			     - QVET_EFFECT_TYPE_LYRICS: 它是QVET_TRC_LYRICS_OPENPARAM的指针
*				 - QVET_EFFECT_TYPE_PIP: 它是PIP PO的指针
*				 - QVET_EFFECT_TYPE_IE:
*				 - QVET_EFFECT_TYPE_FX:
*				 - QVET_EFFECT_TYPE_PASTER: 
*				 - QVET_EFFECT_TYPE_DIVA:
*				   它是QVET_EFFECT_OPENPARAM的指针
*	phEP: 返回的EP指针，它需要调用QVET_EP_Destroy进行释放
*/
MRESULT	QVET_EP_Create(CQVETRenderEngine* pRenderEngine, MDWord dwEftType, MVoid* pEftParam, MHandle* phEP);

/*
* 功能：
*	释放Effect Processor
* 参数：
*	hEP：QVET_EP_Create生成的Handle
*/
MVoid QVET_EP_Destroy(MHandle hEP);

/*
* 功能：
*	处理Effect
* 参数：
*	hEP: QVET_EP_Create生成的Handle
*	dwTimeStamp: 指定Effect处理的时间
*	pInData: 输入的详细数据
*	phOutTexture: 输出的纹理指针，它是由EP内部生成，调用QVET_EP_Destroy后会自动释放
*/
MRESULT QVET_EP_Process(MHandle hEP, MDWord dwTimeStamp, QVET_FRAME_DATA* pInData, MHandle* phOutTexture);


/*
* 功能：
*	拿取Effect的总时间
* 参数：
*	hEP: QVET_EP_Create生成的Handle
*	pdwDuration: effect的总时间
*/
MRESULT QVET_EP_GetDuration(MHandle hEP, MDWord* pdwDuration);

/*
* 功能：后面新增的“设置项”都放在QVET_EP_SetConfig里
*	设置Effect的可变属性
* 参数：
*	hEP: QVET_EP_Create生成的Handle
*	pProp: 属性值
*/
MRESULT QVET_EP_SetProp(MHandle hEP, QVET_EP_PROP* pProp);

/*
* 功能：后面新增的“设置项”都放在QVET_EP_SetConfig里
*	拿取Effect的可变属性
* 参数：
*	hEP: QVET_EP_Create生成的Handle
*	pProp: 属性值
*/
MRESULT QVET_EP_GetProp(MHandle hEP, QVET_EP_PROP* pProp);

/*
* 功能：
*	拿取Effect的随机参数
* 参数：
*	hEP: QVET_EP_Create生成的Handle
*	pParamData: 随机参数数据
*/
MRESULT QVET_EP_GetParamData(MHandle hEP, QVET_EP_TPM_DATA* pParamData);

/*
* 功能：
*	设置人脸检测句柄
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*	hFaceDTContext: 人脸检测handle
*/
MRESULT QVET_EP_SetFaceDTContext(MHandle hEP,MHandle hFaceDTContext);

/*
* 功能：
*	查询手指触碰的点是否在贴纸区域内
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*	pTouchPoint: 用户手指touch的位置,单位为万分比
*   返回值:
*    如果贴纸可见并且手指在贴纸区域内,返回人脸id,对于OT贴纸,返回id 0,否则返回-1
*/
MDWord QVET_EP_IsInPasterRegion(MHandle hEP,MPOINT* pTouchPoint);

/*
* 功能：
*	app聚焦到facial attachement paster上,focus成功后贴纸将不再 随 人脸运动,而是跟随手指
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    dwFaceIndex:人脸id,对于OT贴纸,传0
*   返回值:
*  focus成功,返回QVET_ERR_NONE,否则返回错误值
*/
MRESULT QVET_EP_FocusPaster(MHandle hEP,MDWord dwFaceIndex);

/*
* 功能：
*	取消paster focus,取消后,贴纸将随人脸运动而不是手指
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    dwFaceIndex:人脸id,对于OT贴纸,传0
*   返回值:
*     Unfocus成功,返回QVET_ERR_NONE,否则返回错误值
*/
MRESULT QVET_EP_UnFocusPaster(MHandle hEP,MDWord dwFaceIndex);


/*
* 功能：
* 设置○paster的旋转角度和region
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    fRotation: 贴纸绕自身中心点旋转角度
*    pRegionRect:贴纸的region,单位为万分比
*    dwFaceIndex:人脸id,对于OT贴纸,传0
*   返回值:
*     设置成功返回QVET_ERR_NONE,否则 返回错误值
*/
MRESULT QVET_EP_SetPasterRotationAndRegion(MHandle hEP,MFloat fRotation,MRECT* pRegionRect,MDWord dwFaceIndex);

/*
* 功能：
* 设置○paster的旋转角度和region
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    pfRotation: 贴纸绕自身中心点旋转角度
*    pRegionRect:贴纸的region,单位为万分比
*    dwFaceIndex:人脸id,对于OT贴纸,传0
*   返回值:
*     设置成功返回QVET_ERR_NONE,否则 返回错误值
*/
MRESULT QVET_EP_GetPasterRotationAndRegion(MHandle hEP,MFloat* pfRotation,MRECT* pRegionRect,MDWord dwFaceIndex);

/*
* 功能：后面新增的“设置项”都放在QVET_EP_SetConfig里
* 设置config 给EP
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    dwCfgID: config id
*    pValue:config value
*   返回值:
*     设置成功返回QVET_ERR_NONE,否则 返回错误值
*/
MRESULT QVET_EP_SetConfig(MHandle hEP,MDWord dwCfgID,MVoid* pValue);

/*
* 功能：后面新增的“设置项”都放在QVET_EP_SetConfig里
* 从EP获取config value
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    dwCfgID: config id
*    pValue:config value
*   返回值:
*     设置成功返回QVET_ERR_NONE,否则 返回错误值
*/

MRESULT QVET_EP_GetConfig(MHandle hEP,MDWord dwCfgID,MVoid* pValue);


/*
* 功能：
* 点中3D物体
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    pTouchPoint(In): 用户手指touch的位置,单位为万分比
*    pData(Out),包含3D物体的handle和Z坐标的结构体
*   返回值:
*     成功返回QVET_ERR_NONE,否则 返回错误值
*/
MRESULT QVET_EP_3DHitTest(MHandle hEP,MPOINT* pTouchPoint,QVET_3D_HITTEST_DATA* pData);

    
/*
* 功能：
* 设置AB脸共用的一些数据，例如随机人脸的需要保存人脸对应的贴图
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    pHandle:QVET_EP_RANDOM_FACE_PASTER 数据结构
*   返回值:
*     成功返回QVET_ERR_NONE,否则 返回错误值
*/
MRESULT QVET_EP_SetRandomFaceCache(MHandle hEp, QVET_EP_RANDOM_FACE_PASTER *pRandomFace);

    
/*
* 功能：
* 判断是否支持随机AB脸
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    pbSupport：判断是否支持
*   返回值:
*     成功返回QVET_ERR_NONE,否则 返回错误值
*/
MRESULT QVET_EP_IsSupportRandomFacePaster(MHandle hEp,MBool *pbSupport);
    
/*
* 功能：
* 获取变音数值，没有这个特性的话就是返回0
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    dwPitch：获取的变音数值
*   返回值:
*     成功返回QVET_ERR_NONE,否则 返回错误值
*/
MRESULT QVET_EP_GetPasterPitchValue(MHandle hEp,MFloat & fPitch);
    
/*
* 功能：
* 获取某个人脸的ExpState
* 参数：
*    hEP: QVET_EP_Create生成的Handle
*    nFaceIndex：人脸index
*   返回值:
*    当前的状态
*/
MWord QVET_EP_GET_LOCAL_EXPSTATE(MHandle hEp,MWord nFaceIndex);

#ifdef __cplusplus
}
#endif

#endif // _QVET_EFFECT_PROCESSOR_H_


