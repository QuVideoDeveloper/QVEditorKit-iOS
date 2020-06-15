#ifndef _QVET_POSTER_ENGINE_H_
#define _QVET_POSTER_ENGINE_H_


#ifdef __cplusplus
extern "C"
{
#endif

MRESULT QVET_PosterCreate(MHandle hSessionContext, MTChar* pszTemplateFile, MDWord dwLayoutMode, MHandle* phPoster);

MRESULT QVET_PosterDestroy(MHandle hPoster);



/*
*	QVET_PosterGetOriginalBGSize()
*	To help app get most suitable poster size them want, this API can give the original poster backgroud size. 
*	when you start the compose, you should pass the poster width/height to the compose API. And	It's strongly advised to keep 
*	the width/height ratio according to result of QVET_PosterGetOriginalBGSize().
*
*/
MRESULT QVET_PosterGetOriginalBGSize(MHandle hPoster, MDWord *pdwWidth, MDWord *pdwHeight);



//dwType: QVET_POSTER_ITEM_TYPE_XXXX
MRESULT QVET_PosterGetItemCount(MHandle hPoster, MDWord dwType, MDWord* pdwCount);

/*
*	QVET_PosterGetItemAttr()
*	MDWord dwIndex: [0, count-1]
*/
MRESULT QVET_PosterGetItemAttr(MHandle hPoster, MDWord dwType, MDWord dwIndex, QVET_POSTER_ITEM_ATTR* pAttr);


/*
*	QVET_PosterSetItemData:
*	1.	Up to now, only AMVE_MEDIA_SOURCE_TYPE_BITMAP data is supported. And the color-space of bitmap should be RGB24!!!!
*		if you set jpg-file data, or svg-file data into Poster Engine, an error will return.
*	2.	Before finishing compose, app should not free the bitmap which has set into Poster Engine!!!!!!!
*		Poster Engine share the bitmap memory with app----This can help to reduce the memory consumption
*
*/
MRESULT QVET_PosterSetItemData(MHandle hPoster, MDWord dwType, MDWord dwIndex, QVET_POSTER_ITEM_DATA* pData);

/*
*	QVET_PosterCompose()
*	This is an asynchronized function. The real Compose action will be done step by step, and the status will be informed to app by QVET_POSTER_COMPOSE_CALLBACK
*	Possible Risk:
*		When the internal Poster Compose Thread is active, app should not try to write/change the bitmap which has set to the Poster Engine
*
*	MBITMAP* pResultBmp:  	This is the bitmap which is used to contain the poster composed by API. 
*							The Caller of API should be responsible for the memory-alloc and memory free of bitmap. 
*							And the color space of ResultBmp should be RGB24!!!!!!!!!!!!!
*							
*/
MRESULT QVET_PosterCompose(MHandle hPoster, MBITMAP* pResultBmp, QVET_POSTER_COMPOSE_CALLBACK pfnCallback, MVoid* pUserData);



/*
*	QVET_PosterGetTextItemBasicInfo:
*		用以供app查询 text的基本信息
*
*/
MRESULT QVET_PosterGetTextItemBasicInfo(MHandle hPoster, MDWord dwTextItemIdx, QVET_BASIC_TEXT_INFO *pBasicTextInfo);

/*
*	QVET_PosterGetTextItemString:
*		此接口用于查询Poster模板中Text的国际化字符串，如果return值为AMVE_ERR_BUF_SIZE_TOO_SMALL，说明外部传入的string buf不够大
*/
MRESULT QVET_PosterGetTextItemString(MHandle hPoster, MDWord dwTextItemIdx, MDWord dwLanguageID, MTChar *pszOutputStr, MDWord dwStrBufLen);

/*
*	QVET_PosterGetTextItemUIRFSCount:
*		UIRFS = UI Refernece Font Size
*		UIRFS 是用调用者查询的。模板里已经根据实际测试结果保存几组父控件尺寸不同的情况下 text控件的显示大小
*/
MRESULT QVET_PosterGetTextItemUIRFSCount(MHandle hPoster, MDWord dwTextItemIdx,  MDWord *pUIRFSCount);

/*
*	QVET_PosterGetTextItemUIRFS
*		用于获取UIRFS: UIRFS = UI Refenrence Font Size
*/
MRESULT QVET_PosterGetTextItemUIRFS(MHandle hPoster, MDWord dwTextItemIdx,  MDWord dwUIRFSIdx, QVET_UIREF_FONT_SIZE *pUIRFS);

#ifdef __cplusplus
}
#endif

#endif // _QVET_POSTER_ENGINE_H_



