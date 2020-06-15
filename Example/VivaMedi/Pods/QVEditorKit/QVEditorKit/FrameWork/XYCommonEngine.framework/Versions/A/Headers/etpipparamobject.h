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
	MRESULT QVET_PIP_PO_Create(QVET_TEMPLATE_ADAPTER* pTemplateAdapter, MInt64 llTemplateID, 
										MDWord dwRotation, MSIZE* pResolution, MHandle* phPO);
	
	MRESULT QVET_PIP_PO_Destroy(MHandle hPO);
	
	MRESULT QVET_PIP_PO_GetElementCount(MHandle hPO, MDWord* pdwCount);
	
	MRESULT QVET_PIP_PO_GetElementRegion(MHandle hPO, MDWord dwIndex, MRECT* pRegion);
	
	MRESULT QVET_PIP_PO_GetTemplateID(MHandle hPO, MInt64* pllTemplateID);
	
	MRESULT QVET_PIP_PO_SetTemplateID(MHandle hPO, MInt64 llTemplateID, MSIZE* pResolution);
	
	MRESULT QVET_PIP_PO_GetElementSource(MHandle hPO, MDWord dwIndex, QVET_PIP_SOURCE* pSource);
	
	MRESULT QVET_PIP_PO_SetElementSource(MHandle hPO, MDWord dwIndex, QVET_PIP_SOURCE* pSource);
		
	MRESULT QVET_PIP_PO_GetElementIndexByPoint(MHandle hPO, MPOINT* pPoint, MDWord* pdwIndex);

	MRESULT QVET_PIP_PO_SetRenderEngine(MHandle hPO, MHandle* phRE);

	MRESULT QVET_PIP_PO_GetElementTipsLocation(MHandle hPO, MDWord dwIndex, MPOINT* pPoint);

	MRESULT QVET_PIP_PO_GetElementSourceAlignment(MHandle hPO, MDWord dwIndex, MDWord* pdwAlignment);

#ifdef __cplusplus
}
#endif

#endif // _QVET_PIP_PARAM_OBJECT_H_
