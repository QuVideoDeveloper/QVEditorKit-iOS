#ifndef _QVET_WATERMARK_H_
#define	_QVET_WATERMARK_H_	
	
#ifdef __cplusplus
extern "C"
{
#endif
   /*
	* Function:
	*	创建water mark实例
	* Param:
	*	In hSessionCtx,amve session context
	*     In llTemplate:,动画字幕模板ID,可以为0
	*     In prcDisplay:水印显示区域，单位万分比
	*     Out phWatermar:水印句柄
	*     In pViewSize:显示区域大小
	*Return:
	*    成功返回QVET_ERR_NONE,否则返回错误码
	*/
	MRESULT QVET_Watermark_Create(MHandle hSessionCtx, MInt64 llTemplate, MRECT* prcDisplay, MHandle* phWatermar/*out*/,MSIZE* pViewSize);

   /*
	* Function:
	*	销毁water mark实例
	* Param:
	*	In hWatermark,水印句柄
	*Return:
	*    成功返回QVET_ERR_NONE,否则返回错误码
	*/
	MRESULT QVET_Watermark_Destroy(MHandle hWatermark);

	/*
	* Function:
	*	获取水印中字幕个数
	* Param:
	*	In hWatermark:水印句柄
	*     Out pdwCount:字幕个数
	*Return:
	*    成功返回QVET_ERR_NONE,否则返回错误码
	*/
	MRESULT QVET_Watermark_GetTitleCount(MHandle hWatermark, MDWord* pdwCount/*out*/);

   /*
	* Function:
	*	获取水印字幕字符串
	* Param:
	*	In hWatermark:水印句柄
	*     In dwIndex:水印字幕序号
	*     In/Out szTitle:水印字符串,可以传空，传空用来获取字符串长度
	*     In/Out plLen:水印字符串长度
	*Return:
	*    成功返回QVET_ERR_NONE,否则返回错误码
	*/
	MRESULT QVET_Watermark_GetTitle(MHandle hWatermark, MDWord dwIndex, MTChar* szTitle, MLong* plLen/*in, out*/);

   /*
	* Function:
	*	设置水印字符串
	* Param:
	*	In hWatermark:水印句柄
	*     In dwIndex:水印字幕序号
	*     Out szTitle:水印字符串
	*Return:
	*    成功返回QVET_ERR_NONE,否则返回错误码
	*/
	MRESULT QVET_Watermark_SetTitle(MHandle hWatermark, MDWord dwIndex, MTChar* szTitle);

   /*
	* Function:
	*	设置水印外部图片
	* Param:
	*	In hWatermark:水印句柄
	*     In szImageFile:外部图片文件路径
	*Return:
	*    成功返回QVET_ERR_NONE,否则返回错误码
	*/
	MRESULT QVET_Watermark_SetImage(MHandle hWatermark, MTChar* szImageFile);

   /*
	* Function:
	*	复制水印句柄
	* Param:
	*	In hSrcWatermark:源水印句柄
	*     Out phDstWatermark:目标水印句柄
	*Return:
	*    成功返回QVET_ERR_NONE,否则返回错误码
	*/
	MRESULT QVET_Watermark_Duplicate(MHandle hSrcWatermark,MHandle* phDstWatermark);
		
#ifdef __cplusplus
}
#endif

#endif // _QVET_WATERMARK_H_
