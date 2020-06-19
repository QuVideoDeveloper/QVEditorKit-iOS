/*CXiaoYingPoster.h
 *
 *Reference:
 *
 *Description: Define XiaoYing Poster API.
 *
 */


@protocol CXiaoYingPosterProtocol

- (MDWord) QVETPosterCallBack : (MDWord)dwCurStep
                   totalSteps : (MDWord)dwTotalSteps;

@end


@interface CXiaoYingPoster : NSObject{

}

//@property (readwrite, nonatomic) MHandle hPoster;


- (MRESULT) create : (CXiaoYingEngine *)engine
      withTemplate : (MTChar*)pszTemplateFile
    withLayoutMode : (MDWord)layoutMode;


- (MVoid) destory;


- (MRESULT) getOriginalBGWidth : (MDWord*)pdwWidth
                     andHeight : (MDWord*)pdwHeight;


- (MRESULT) getItemCount : (MDWord*)pdwCount
                  byType : (MDWord)itemType;


- (MRESULT) getItemAttr : (QVET_POSTER_ITEM_ATTR*)pAttr
                 byType : (MDWord)itemType
                atIndex : (MDWord)idx;


- (MRESULT) setItemData : (QVET_POSTER_ITEM_DATA*)pData
                 byType : (MDWord)itemType
                atIndex : (MDWord)idx;


- (MRESULT) compose : (CVImageBufferRef)cvImgBuf
        setProtocol : (id <CXiaoYingPosterProtocol>)protocol;



- (MRESULT) getTextItemBasicInfo : (QVET_BASIC_TEXT_INFO*)pInfo
                         atIndex : (MDWord)idx;



- (MRESULT) getTextItemString : (MTChar*)pszOutStr
               InputStrBufLen : (MDWord)dwStrBufLen
                 byLanguageID : (MDWord)dwLanguageID
                      atIndex : (MDWord)dwTextItemIdx;

/**
 * encapsulate all the parameter needed to form the QVET_POSTER_ITEM_DATA for bmp
 * BE AWARE: don't release the cvSrcImgBuf, before CXiaoYingPoster.destory(). because the bmp-data
 *           is usually too big to copy, so wo use it by the memory-share
 *
 * @param cvSrcImgBuf [in]it should constains the thumbnail bmp
 * @param pRect [in]the data rect drawn into the poster-backgound,it's based on 1/100000
 * @return a instance-pointer of QVET_POSTER_ITEM_DATA if the operation is successful, otherwise returen nil if failed.
 */
+ (QVET_POSTER_ITEM_DATA*) newPosterBmpData : (CVImageBufferRef)cvSrcImgBuf
                              giveMergeRect : (MRECT*)pRect;



/**
 * encapsulate all the parameter needed to form the QVET_POSTER_ITEM_DATA for svg
 * BE AWARE: different to the poster-bmp-Data, you can release the pSrcSvgFile after this call
 *
 * @param pSrcSvgFile [in]it's the full svg-file name
 * @param pRect [in]the data rect drawn into the poster-backgound,it's based on 1/100000
 * @return a instance-pointer of QVET_POSTER_ITEM_DATA if the operation is successful, otherwise returen nil if failed.
 */
+ (QVET_POSTER_ITEM_DATA*) newPosterSvgData : (NSString*)pSrcSvgFile
                              giveMergeRect : (MRECT*)pRect;


+ (MVoid) freePosterData : (QVET_POSTER_ITEM_DATA*)pData;

@end