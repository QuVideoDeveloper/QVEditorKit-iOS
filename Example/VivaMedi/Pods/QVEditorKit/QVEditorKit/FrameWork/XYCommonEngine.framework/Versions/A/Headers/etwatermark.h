#ifndef _QVET_WATERMARK_H_
#define	_QVET_WATERMARK_H_	
	
#ifdef __cplusplus
extern "C"
{
#endif
	MRESULT QVET_Watermark_Create(MHandle hSessionCtx, MInt64 llTemplate, MRECT* prcDisplay, MHandle* phWatermar/*out*/,MSIZE* pViewSize);
	
	MRESULT QVET_Watermark_Destroy(MHandle hWatermark);
	
	MRESULT QVET_Watermark_GetTitleCount(MHandle hWatermark, MDWord* pdwCount/*out*/);
	
	MRESULT QVET_Watermark_GetTitle(MHandle hWatermark, MDWord dwIndex, MTChar* szTitle, MLong* plLen/*in, out*/);
	
	MRESULT QVET_Watermark_SetTitle(MHandle hWatermark, MDWord dwIndex, MTChar* szTitle);
	
	MRESULT QVET_Watermark_SetImage(MHandle hWatermark, MTChar* szImageFile);

	MRESULT QVET_Watermark_Duplicate(MHandle hSrcWatermark,MHandle* phDstWatermark);
		
#ifdef __cplusplus
}
#endif

#endif // _QVET_WATERMARK_H_
