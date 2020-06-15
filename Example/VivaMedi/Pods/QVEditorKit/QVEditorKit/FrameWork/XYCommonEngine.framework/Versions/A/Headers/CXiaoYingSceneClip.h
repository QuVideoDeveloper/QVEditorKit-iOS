/*CXiaoYingSceneClip.h
*
*Reference:
*
*Description: Define XiaoYing SceneClip  API.
*
*/
@interface CXiaoYingSceneClip : CXiaoYingClip
{
		
}

/**
 *
 * Initialize
 *
 * @param pEngine a instance of CXiaoYingEngine
 * @param llTemplateID the id of scene template
 * @param pResolution MSIZE pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 *
 */

- (MRESULT) Init : (CXiaoYingEngine*)pEngine
	  TemplateID : (MInt64)llTemplateID
	  Resolution : (MSIZE*)pResolution;

/**
 * 
 * Get SceneClip element count
 * 
 * @param pdwCount SceneClip count pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 * 
 */
 

- (MRESULT) GetElementCount : (MDWord*) pdwCount;

/**
 * 
 * Get SceneClip element region;
 * @param dwIndex element index
 * @param prcRegion MRECT pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) GetElementRegion : (MDWord)dwIndex
                      Region : (MRECT*)prcRegion;


/**
 *
 * Get SceneClip focus image id
 * @param dwIndex focus image index
 * @param pImageID MDWord pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) GetElementFocusImageID : (MDWord)dwIndex
						   ImageID : (MDWord*)pImageID;


/**
 *
 * Get SceneClip template id
 * @param pllTemplateID ID of scene template
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetTemplate : (MInt64*)pllTemplateID;


/**
 *
 * Set SceneClip template id
 * @param llTemplateID ID of scene template
 * @param pResolution MSIZE pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) SetTemplate : (MInt64)llTemplateID
             Resolution : (MSIZE*)pResolution;



/**
 *
 * Get SceneClip element source;
 * @param dwIndex element index
 * @param pStoryboardSource Storyboard pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetElementSource : (MDWord)dwIndex
            StoryboardSource : (CXiaoYingStoryBoardSession*)pStoryboardSource;


/**
 *
 * Set SceneClip element source;
 * @param dwIndex element index
 * @param pStoryboardSource Storyboard pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) SetElementSource : (MDWord)dwIndex
            StoryboardSource : (CXiaoYingStoryBoardSession*)pStoryboardSource;


/**
 *
 * Swap SceneClip element source;
 * @param dwIndex1 first element index
 * @param dwIndex2 other element index
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) SwapElementSource : (MDWord)dwIndex1
					   Index2 : (MDWord)dwIndex2;


/**
 *
 * Get SceneClip element index;
 * @param pPoint the location
 * @param pdwIndex the element index
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetElementIndexByPoint : (MPOINT*)pPoint
            				 Index : (MDWord*)pdwIndex;
            								 	
 /**
 *
 * Get SceneClip element source alignment;
 * @param dwIndex the location
 * @param pdwAlignment the mode of alignment
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetElementTipsLocation : (MDWord)dwIndex
            			  Location : (MPOINT*)pPoint;

/**
 *
 * Get SceneClip element source alignment;
 * @param pPoint the location
 * @param pdwIndex the element index
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetElementSourceAlignment : (MDWord)dwIndex
            								Alignment : (MDWord*)pdwAlignment;
											
- (MRESULT) GetExternalSource : (MDWord)dwIndex
               ExternalSource : (QVET_EFFECT_EXTERNAL_SOURCE*)pExtSrc;

- (MRESULT) SetExternalSource : (MDWord)dwIndex
               ExternalSource : (QVET_EFFECT_EXTERNAL_SOURCE*)pExtSrc;

- (MRESULT) setProperty : (MDWord) dwPropertyID
           PropertyData : (MVoid*)pValue;			

- (MRESULT) getProperty : (MDWord) dwPropertyID
           PropertyData : (MVoid*)pValue;		   
            								 	
@end // CXiaoYingSceneClip

