/*CXiaoYingCover.h
*
*Reference:
*
*Description: Define XiaoYing Cover  API.
*
*/

#define QVET_COVER_TITLE_GROUP_ID	(-1)

@interface CXiaoYingCover : CXiaoYingClip
{
		
}

/**
 *
 * Initialize
 *
 * @param hCover cover handle
 * @return MERR_NONE if the operation is successful, other value if failed.
 *
 */

- (MRESULT) Init : (MHandle) hCover;

/**
 *
 * UnInitialize
 *
 * @return MERR_NONE if the operation is successful, other value if failed.
 *
 */
- (MRESULT) UnInit;


/**
 *
 * Get title count
 * @param pdwTitleCount title count pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetTitleCount : (MDWord*) pdwTitleCount;



/**
 *
 * Get title info
 * @param dwIndex title id
 * @param dwLanguageID language id
 * @param pTitleInfo title info pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetTitleDefaultInfo : (MDWord) dwIndex
                     LanguageID : (MDWord) dwLanguageID
                      TitleInfo : (QVET_COVER_TITLE_INFO*) pTitleInfo;


/**
 *
 * Get title
 * @param dwIndex title id
 * @param pBubbleSource bubble text source pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetTitle : (MDWord) dwIndex
           BubbleText: (AMVE_BUBBLETEXT_SOURCE_TYPE*) pBubbleSource;




/**
 *
 * Get title
 * @param dwIndex title id
 * @param pBubbleSource bubble text source pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) SetTitle : (MDWord) dwIndex
          BubbleText : (AMVE_BUBBLETEXT_SOURCE_TYPE*) pBubbleSource;


/**
 *
 * Get title user data
 * @param dwIndex title index
 * @param pUserData title user data pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetTitleUserData : (MDWord) dwIndex
                     UserData: (AMVE_USER_DATA_TYPE*) pUserData;


/**
 *
 * Set title user data
 * @param dwIndex title index
 * @param pUserData title user data pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) SetTitleUserData : (MDWord) dwIndex
                    UserData : (AMVE_USER_DATA_TYPE*) pUserData;

/**
 *
 * Get static position
 * @param pfLayerID layerID pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetTitleLayerID : (MDWord) dwIndex
                 LayerIDPtr : (MFloat*) pfLyaerID;

- (CXiaoYingEffect*) getTitleEffect : (MDWord) dwIndex;

@end // CXiaoYingClip

