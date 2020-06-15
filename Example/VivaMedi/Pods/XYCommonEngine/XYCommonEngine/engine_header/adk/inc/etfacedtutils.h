#ifndef _ET_FACEDT_UTILS_H_
#define _ET_FACEDT_UTILS_H_


#define AMVE_FACEDT_MODE_ASYNC         0  //异步检测人脸模式
#define AMVE_FACEDT_MODE_SYNC          1  //同步检测人脸模式


#define AMVE_FACEDT_PROP_BASE            0
//磨皮,提亮，在使用Arcsoft库做人脸检测时同步完成
#define AMVE_FACEDT_PROP_SOFTEN_VALUE      (AMVE_FACEDT_PROP_BASE + 1) //磨皮程度,取值范围0~100
#define AMVE_FACEDT_PROP_BRIGHTEN_VALUE    (AMVE_FACEDT_PROP_BASE + 2)  //提亮程度,取值范围0~100
#define AMVE_FACEDT_PROP_WORK_MODE         (AMVE_FACEDT_PROP_BASE + 3)  //set work mode,AMVE_FACEDT_WORK_MODE_XXX



#define AMVE_FACEDT_SOFTEN_NONE_VALUE       0     //无soft效果值
#define AMVE_FACEDT_SOFTEN_MIN_VALUE        0     //soft最小值
#define AMVE_FACEDT_SOFTEN_MAX_VALUE        100   //soft最大值

#define AMVE_FACEDT_BRIGHTEN_NONE_VALUE   0    //无brighten效果值
#define AMVE_FACEDT_BRIGHTEN_MIN_VALUE    0    //brighten最小值
#define AMVE_FACEDT_BRIGHTEN_MAX_VALUE    100  //brighten最大值


typedef enum _tag_AMVE_FACEDT_ORIENTION {
		AMVE_FACEDT_ORIENTION_ANY = 0,						// detect face in any orientation
		AMVE_FACEDT_ORIENTION_0,							// only detect face in 0 degree
		AMVE_FACEDT_ORIENTION_90,							// only detect face in 90 degree(CCW)
		AMVE_FACEDT_ORIENTION_180,							// only detect face in 180 degree(CCW)
		AMVE_FACEDT_ORIENTION_270,							// only detect face in 270 degree(CCW)
		AMVE_FACEDT_ORIENTION_FORCE_32BIT = 0x7FFFFFFF
	} AMVE_FACEDT_ORIENTION;


//不同的手机朝向定义
#define AMVE_DEV_ORITATION_NONE  					0x00000000
#define AMVE_DEV_ORITATION_PORTRAIT	  			    0x00000001  
#define AMVE_DEV_ORITATION_PORTRAIT_UPSIDE_DOWN	    0x00000002
#define AMVE_DEV_ORITATION_LANDSCAPE_LEFT  		    0x00000003
#define AMVE_DEV_ORITATION_LANDSCAPE_RIGHT	  	    0x00000004


#define AMVE_FACEDT_WORK_MODE_RAPIDITY              0   //快速模式
#define AMVE_FACEDT_WORK_MODE_ACCURACY              1   //准确模式



#ifdef __cplusplus
extern "C" {
#endif

/**
*  Function:
*    创建人脸检测实例
* @param In  hAppContext,Android app context,iOS可以为MNull,用于包名检测
* @param   In pszAlkFilePath,track_data文件路径
* @return   如果创建成功，返回人脸检测实例句柄，否则返回MNull
**/
MHandle FaceDTUtils_CreateFaceDTContext(MHandle hAppContext,MTChar* pszAlkFilePath);

/**
*  Function:
*    销毁人脸检测实例
* @param In  hContext,需要销毁的人脸检测实例句柄
*  @Return None
**/

MVoid FaceDTUtils_DestroyFaceDTContext(MHandle hContext);

/**
*    传入bitmap检测人脸
* @param hContext,face dt context
* @param   pBmp,用于检测人脸的bitmap,如果设置了磨皮参数,最后磨皮效果直接作用在上面
* @param   pCropRect,bitmap最终显示时的crop rect
* @param   dwRotation,bitmap最终显示时需要转过的角度
* @param  dwDTOriention,设备的朝向
* @param   dwDevOriention,图像采集时摄像头的朝向
* @return   QVET_ERR_NONE if success,other value if failed
**/
MRESULT FaceDTUtils_DetectFaceByBMP(MHandle hContext,MBITMAP* pBmp,
                                             MRECT* pCropRect,MDWord dwRotation,
                                             MDWord dwDTOriention,MDWord dwDevOriention);

/**
*    传入texture检测人脸 并加上磨皮效果
* @param hContext,face dt context
* @param   hTexture,用于检测人脸的texture,如果设置了磨皮参数,最后磨皮效果直接作用在上面
* @param   pCropRect,bitmap最终显示时的crop rect
* @param   dwRotation,bitmap最终显示时需要转过的角度
* @param  dwDTOriention,设备的朝向
* @param   dwDevOriention,图像采集时摄像头的朝向
* @param  bContinuous,该参数只对Android有意义,表示是否对连续图像进行检测
*               为MTrue是表示对连续的视频图像进行检测,此时为了提高纹理
*               下载性能，会采用异步模式下载纹理,当前检测的实际为上
*                一次渲染的内容,这对连续的图像是可以接受的
*               如果是对单张图片进行检测，则设置为MFalse
*
* @return   QVET_ERR_NONE if success,other value if failed
**/
MRESULT FaceDTUtils_DetectFaceByTexture(MHandle hContext,MHandle hTexture,
                                                MRECT* pCropRect,MDWord dwRotation,
                                                MDWord dwDTOriention,MDWord dwDevOriention,
                                                MBool bContinuous);

/**
*    获取人脸检测结果
* @param In hContext,face dt context
* @param   In/Out pResult,人脸检测结果
* @return   QVET_ERR_NONE if success,other value if failed
**/
MRESULT FaceDTUtils_GetDetectResult(MHandle hContext,AMVE_FACEDT_RESULT_TYPE* pResult);


/**
*    获取人脸检测原始图片信息,用于换算人脸检测结果
* @param In hContext,face dt context
* @param   In/Out pCropRect,crop信息
* @param In/Out pdwRotation,图片旋转角度
* @param In/Out pSize,图片尺寸
* @return   QVET_ERR_NONE if success,other value if failed
**/
MRESULT FaceDTUtils_GetSrcBmpInfo(MHandle hContext,MRECT* pCropRect,MDWord* pdwRotation,MSIZE* pSize);

MBool FaceDTUtils_IsFaceDTFinished(MHandle hContext);

/**
*    异步检测模式下，不是马上得到结果，所以需要调用UpdateDetectResult来刷新检测结果
*   同步检测模式下其实可以同步得到结果，但仍然保留这个机制
**/
MBool FaceDTUtils_UpdateDetectResult(MHandle hContext);

/**
*Reset只是把检测结果清零
**/
MRESULT FaceDTUtils_Reset(MHandle hContext);


/**
*    设置人脸检测模式
* @param In hContext,face dt context
* @param   In dwDTMode,人脸检测模式，AMVE_FACEDT_MODE_XXX
* @return   QVET_ERR_NONE if success,other value if failed
**/
MRESULT FaceDTUtils_SetDetectMode(MHandle hContext,MDWord dwDTMode);


/**
*    将senstime 106个特征点转为arcsoft 41个特征点
* @return   表示特征点转换对应关系的数组
**/
const MInt32* FaceDTUtils_idx_sensetime_106_2_arcsoft_41();

/**
*    将senstime 106个特征点转为arcsoft 101个特征点
* @return   表示特征点转换对应关系的数组
**/
const MInt32* FaceDTUtils_idx_sensetime_106_2_arcsoft_101();

/**
*    将arcsoft 41个特征点转为arcsoft 101个特征点
* @return   表示特征点转换对应关系的数组
**/

const MInt32* FaceDTUtils_idx_arcsoft41_2_arcsoft101();



/**
*    设置磨皮参数
* @param hContext,face dt context
* @param   dwPropID,property id
* @param   pData,property value
* @return   QVET_ERR_NONE if success,other value if failed
**/
MRESULT FaceDTUtils_SetProperty(MHandle hContext,MDWord dwPropID,MVoid* pData);


/**
*   将人脸检测结果以像素为单位的特征点转化为万分比表示的,
*   在 旋转过后的坐标系中的点
* @param hContext,face dt context
* @param   pDTPoint,以像素为单位表示的特征点
* @param   pDstPoint,以万分比为单位,在旋转后坐标系中的点
* @return   QVET_ERR_NONE if success,other value if failed
**/
MRESULT FaceDTUtils_ConvertDTPoint(MHandle hContext,MPOINT_FLOAT* pDTPoint,MPOINT_FLOAT* pDstPoint);

    
/**
 *  将特征点坐标由缩放后的size转换为缩放前的size中的像素值
 * @param hContext,face dt context
 * @param   pDTPoint,在缩放后的图像中以像素为单位表示的特征点
 * @param   pDstPoint,在缩放前的图像中以像素为单位表示的特征点
 * @return   QVET_ERR_NONE if success,other value if failed
 **/
MRESULT FaceDTUtils_ConvertDTPointToSrcSize(MHandle hContext, MPOINT_FLOAT* pDTPoint, MPOINT_FLOAT* pDstPoint);


/**
*  检查license是否有效，只需调用一次
* @param pszFilePath,license文件路径
* @return   如果有效返回QVET_ERR_NONE,无效返回错误值
**/
MRESULT FaceDTUtils_CheckLicenseFile(const MTChar* pszFilePath);


/**
*  检查license是否有效，只需调用一次
* @param pFileData,license文件内容
* @param dwDataSize,license文件内容长度
* @return   如果有效返回QVET_ERR_NONE,无效返回错误值
**/
MRESULT FaceDTUtils_CheckLicenseData(const MVoid* pFileData,MDWord dwDataSize);
    
    
/**
 *  更新源图大小，用于特征点坐标转换
 *
 **/
MRESULT FaceDTUtils_UpdateSrcSize(MHandle hContext, MSIZE* srcSize);



#ifdef __cplusplus
}
#endif


#endif

