#ifndef _QVET_PIP_PARAM_OBJECT_H_
#define	_QVET_PIP_PARAM_OBJECT_H_	
	
#define QVET_PIP_SOURCE_TYPE_IMAGE		0
#define QVET_PIP_SOURCE_TYPE_VIDEO		1
#define QVET_PIP_SOURCE_TYPE_CAMERA		2
#define QVET_PIP_SOURCE_TYPE_STORYBOARD	3
#define QVET_PIP_SOURCE_TYPE_CLIP		4
#define QVET_PIP_SOURCE_TYPE_DATAINDEX	5

typedef struct  
{
	MDWord dwSrcType;	//QVET_PIP_SOURCE_TYPE_XXX			
	//MTChar szFileSource[AMVE_MAXPATH]; //MVoid*
	MVoid *pSrc;	//Src = MTChar* or pStoryboardDataClip

	//joStbGlobalRef此变量只用于android, 因为GetElementSource的时候，要get一个java QStoryboardSession,而非简单的*pStoryboardDataClip
	//为简化代码，这里暂时记录一下，以便后面get
	MHandle joStbGlobalRef;
	AMVE_POSITION_RANGE_TYPE trimRange;
	MRECT rcCrop;
	MDWord dwRotation;
	MDWord dwShadeOpacity;	//[0, 100]
} QVET_PIP_SOURCE;

#ifdef __cplusplus
extern "C"
{
#endif
	//PO means parameter object.

	/*
	 * Function:
	 *	 创建PIP PO
	 * Param:
	 *	   In pTemplateAdapter:获取模板路径的回调函数指针
	 *	   In llTemplateID:画中画模板ID
	 *	   In dwRotation:相机旋转角度
	 *	   In pResolution:显示区域size
	 *       In/Out phPO:PO句柄
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */ 
	MRESULT QVET_PIP_PO_Create(QVET_TEMPLATE_ADAPTER* pTemplateAdapter, MInt64 llTemplateID, 
										MDWord dwRotation, MSIZE* pResolution, MHandle* phPO);

	/*
	 * Function:
	 *	 销毁PIP PO
	 * Param:
	 *	   In hPO:PIP PO 句柄
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */ 
	MRESULT QVET_PIP_PO_Destroy(MHandle hPO);

	/*
	 * Function:
	 *	 获取PIP源的个数
	 * Param:
	 *	   In hPO:PIP PO
	 *	   In/Out pdwCount:PIP 源的个数
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */ 
	MRESULT QVET_PIP_PO_GetElementCount(MHandle hPO, MDWord* pdwCount);

	/*
	 * Function:
	 *	 获取PIP源的区域
	 * Param:
	 *	   In hPO:PIP PO
	 *       In dwIndex:
	 *	   In/Out pRegion:PIP 源的区域，单位万分比
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */ 
	MRESULT QVET_PIP_PO_GetElementRegion(MHandle hPO, MDWord dwIndex, MRECT* pRegion);

    /*
	 * Function:
	 *	 获取PIP模板ID
	 * Param:
	 *	   In hPO:PIP PO
	 *	   In/Out pllTemplateID:PIP 模板ID
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */ 
	MRESULT QVET_PIP_PO_GetTemplateID(MHandle hPO, MInt64* pllTemplateID);


    /*
	 * Function:
	 *	 设置PIP模板ID
	 * Param:
	 *	   In hPO:PIP PO
	 *	   In llTemplateID:PIP 模板ID
	 *       In pResolution:目标区域尺寸
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */ 
	MRESULT QVET_PIP_PO_SetTemplateID(MHandle hPO, MInt64 llTemplateID, MSIZE* pResolution);


    /*
	 * Function:
	 *	 获取PIP Source
	 * Param:
	 *	   In hPO:PIP PO
	 *	   In dwIndex:PIP 源序号
	 *       In/Out pSource:PIP Source
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */
	MRESULT QVET_PIP_PO_GetElementSource(MHandle hPO, MDWord dwIndex, QVET_PIP_SOURCE* pSource);

	/*
	 * Function:
	 *	 设置PIP Source
	 * Param:
	 *	   In hPO:PIP PO
	 *	   In dwIndex:PIP 源序号
	 *       In pSource:PIP Source
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */
	MRESULT QVET_PIP_PO_SetElementSource(MHandle hPO, MDWord dwIndex, QVET_PIP_SOURCE* pSource);


    /*
	 * Function:
	 *	 获取坐标点对应的PIP源的序号
	 * Param:
	 *	   In hPO:PIP PO
	 *	   In pPoint:坐标点，单位万分比
	 *       Out pdwIndex:PIP Source序号
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */
	MRESULT QVET_PIP_PO_GetElementIndexByPoint(MHandle hPO, MPOINT* pPoint, MDWord* pdwIndex);

    /*
	 * Function:
	 *	 设置RenderEngine
	 * Param:
	 *	   In hPO:PIP PO
	 *	   In phRE:RenderEngine句柄
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */
	MRESULT QVET_PIP_PO_SetRenderEngine(MHandle hPO, MHandle* phRE);

    /*
	 * Function:
	 *	 获取PIP Source的tips location
	 * Param:
	 *	   In hPO:PIP PO
	 *	   In dwIndex:PIP Source序号
	 *       Out pPoint:配置在info.xml里面的tips location,单位万分比
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */
	MRESULT QVET_PIP_PO_GetElementTipsLocation(MHandle hPO, MDWord dwIndex, MPOINT* pPoint);

    /*
	 * Function:
	 *	 获取PIP Source的alignment
	 * Param:
	 *	   In hPO:PIP PO
	 *	   In dwIndex:PIP Source序号
	 *       Out pdwAlignment:配置在info.xml里面的alignment
	 *Return:
	 *	  成功返回QVET_ERR_NONE,否则返回错误码
	 */
	MRESULT QVET_PIP_PO_GetElementSourceAlignment(MHandle hPO, MDWord dwIndex, MDWord* pdwAlignment);

#ifdef __cplusplus
}
#endif

#endif // _QVET_PIP_PARAM_OBJECT_H_
