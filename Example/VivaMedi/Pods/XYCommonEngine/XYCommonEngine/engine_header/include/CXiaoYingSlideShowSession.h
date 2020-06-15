/*CXiaoYingSlideShowSession.h
*
*Reference:
*
*Description: Define XiaoYing SlideShow Session API.
*
*/

#define QVET_SLIDESHOW_SESSION_STATUS_NULL                   0
#define QVET_SLIDESHOW_SESSION_STATUS_DESTROY_STORYBOARD     1
#define QVET_SLIDESHOW_SESSION_STATUS_PARSE_CONFIG           2
#define QVET_SLIDESHOW_SESSION_STATUS_FACE_DETECT            3
#define QVET_SLIDESHOW_SESSION_STATUS_CREATE_DATAPROVIDER    4
#define QVET_SLIDESHOW_SESSION_STATUS_MAKE_STORYBOARD        5
#define QVET_SLIDESHOW_SESSION_STATUS_APPLY_THEME            6
#define QVET_SLIDESHOW_SESSION_STATUS_SET_MUSIC              7
#define QVET_SLIDESHOW_SESSION_STATUS_STOPPED                8
#define QVET_SLIDESHOW_SESSION_STATUS_CANCLE                 9



@interface CXiaoYingSlideShowSession : CXiaoYingSession
{
		
}
/**
 * Initializes the session.
 * 
 * @param pEngine an instance of CXiaoYingEngine.
 * @param statehandler,session state call back handler
 * 
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
 

- (SInt32) Init : (CXiaoYingEngine*)pEngine
	               SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler; 

/**
* Destroys the session.
 * 
* @return MERR_NONE if the operation is successful, other value if failed.
*/


- (SInt32) UnInit;

/**
 *Insert  source to source list
 *@param pSrcInfoNode, source info node
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) InsertSource : (CXiaoYingSourceInfoNode* _Nonnull) pSrcInfoNode;
	
/**
 *Remove  source from source list
 *@param uiSrcIndex, source info node index
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) RemoveSource : (UInt32)uiSrcIndex;

/**
 *Get source info node count in source list
 *@param puiCount,point for source count
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) GetSourceCount : (UInt32* _Nonnull)puiCount;
	

/**
 *Get source info node  in source list
 *@param uiSrcIndex,source info node index
 * @return source info node if successful,nil if failed.
 */

- (CXiaoYingSourceInfoNode* _Nullable) GetSource : (UInt32)uiSrcIndex;

/**
 *Set bgm source
 *@param pstrMusicSource, bgm source path
 *@param pRange,bgm range
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) SetMusic : (NSString* _Nonnull) pstrMusicSource
          MusicRange : (CXIAOYING_POSITION_RANGE_TYPE *)pRange;

- (NSString* _Nullable) GetMusic;

- (SInt32) GetMusicRange : (CXIAOYING_POSITION_RANGE_TYPE*)pRange;


/**
 *Set template id
 *@param llTemplateID, template id
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) SetTheme : (UInt64)llTemplateID;
	
- (SInt32) GetTheme : (UInt64*)pllTemplateID;

/**
 *Make storyboard
 *@param pSize,target size
 *@param statehandler,makestoryboard statehandler指针
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) MakeStoryboard : (CXIAOYING_SIZE*)pSize
    SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler
    ThemeOperationHandler : (id<AMVEThemeOptDelegate>) themeopthandler;

/**
 *ReMake storyboard
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) ReMakeStoryboard;

/**
 *Cancle make storyboard
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) CancleMakeStoryboard;


/**
 * GetStoryboard session
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) GetStoryboard : (CXiaoYingStoryBoardSession**)ppStoryboardSession;


/**
 * Load slide show project
 * @param pstrProjectFile,slideshow project file path
 * @param statehandler,slideshow project load state handler pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) LoadProject : (NSString*)pstrProjectFile
    SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler;

/**
 * Save slide show project
 * @param pstrProjectFile,slideshow project file path
 * @param statehandler,slideshow project save state handler pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) SaveProject : (NSString*)pstrProjectFile
    SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler;

/**
 * Set mute flag
 * @param bMute,mute flag
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) SetMute : (Boolean)bMute;


/**
 * Get mute flag
 * @return TRUE if the muted, FALSE if not muted.
 */
- (Boolean) GetMute;

- (NSString*) GetDefaultMusic;

/**
 * Detect face center
 * @param pSrcInfoNode,source info node
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) DetectFace : (CXiaoYingSourceInfoNode* _Nonnull) pSrcInfoNode;


/**
 * Get text animation info array
 * @return CXiaoYingTextAnimationInfo Array if success,else return MNull
 */
- (NSArray*) GetTextAnimationInfoArray;

/**
 * Detect face rect
 * @param pTextAnimationInfo,text animation info
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) SetTextAnimationInfo : (CXiaoYingTextAnimationInfo*) pTextAnimationInfo;


/**
 * Get virtual source info node array
 * @return CXiaoYingVirtualSourceInfoNode Array if success,else return nil
 */
- (NSArray<CXiaoYingVirtualSourceInfoNode*>* _Nullable) GetVirtualSrcInfoNodeArray;

/**
 * Update virtual source face center position,only available for image source
 * @param pVirtualSrcInfoNode,virtual source info node
 * @param siFaceCenterX,face center position x
 * @param siFaceCenterY,face center position y
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) UpdateVirtualSrcFaceCenter : (CXiaoYingVirtualSourceInfoNode* _Nonnull) pVirtualSrcInfoNode
                          FaceCenterX : (SInt32) siFaceCenterX
                          FaceCenterY : (SInt32) siFaceCenterY;



/**
 * Duplicate slideshow session's storyboard
 * @param ppStoryboardSession pointer to storyboardsession pointer
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) DuplicateStoryboard : (CXiaoYingStoryBoardSession** _Nonnull)ppStoryboardSession;


/**
 * Set virutal source node trim range,only available for video source source,
 * must deactivestream before call this interface,otherwise opengl source may be released abnormally
 * if the play to end flag is not set,the trim range lenth should not longer than scene duration,
 *otherwise the trim range can be set to source range's end position
 * @param pVirtualSrcInfoNode,virtual source info node
 * @pTrimRange,pointer of trimrange
 * @param play to video end flag
 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (SInt32) SetVirtualSrcTrimRange : (CXiaoYingVirtualSourceInfoNode* _Nonnull) pVirtualSrcInfoNode
	                    TrimRange : (CXIAOYING_POSITION_RANGE_TYPE* _Nonnull) pTrimRange
                    PlayToEndFlag : (Boolean)bPlayToEnd;


/**
 * Update virtual source node's source,use an new source,if you want to 
 * replace an image source by a video source,should call CanInsertVideoSource first
 * must deactivestream before call this interface,otherwise opengl source may be released abnormally
 * RefreshSourceList must be called after upate several virtual source node and virtual source info node
 * array need to re-get
 * @param pVirtualSrcInfoNode,virtual source info node
 * @param pSrcInfoNode,source info node
 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (SInt32) UpdateVirtualSource : (CXiaoYingVirtualSourceInfoNode* _Nonnull) pVirtualSrcInfoNode
	                SourceInfo : (CXiaoYingSourceInfoNode* _Nonnull) pSrcInfoNode;

/**
 *Judge whether this virtual source node can insert video source,because only one video
 *source is supported for each scene,so we should judge whther we can insert another video
 *source to the scene before update virtual source node
 * @param pVirtualSrcInfoNode,virtual source info node
 * @return True if the can insert video source, otherwise return False
 */

- (Boolean) CanInsertVideoSource : (CXiaoYingVirtualSourceInfoNode* _Nonnull) pVirtualSrcInfoNode;

/**
 *Refresh the source list after UpdateVirtualSource,you can invoke UpdateVirtualSource
 *for several times when edit,and call RefreshSourceList only once before active stream
* @param None
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) RefreshSourceList;



- (SInt32) SetVirtualSrcTransformPara : (CXiaoYingVirtualSourceInfoNode*) pVirtualSrcInfoNode
                        TransformPara : (CXIAOYING_TRANSFORM_PARAMETERS*) pTransformPara;


- (SInt32) SetVirtualSrcTransformFlag :(CXiaoYingVirtualSourceInfoNode* _Nonnull) pVirtualSrcInfoNode
                        TransformFlag : (Boolean)bTransformFlag;


- (SInt32) SetRect2TransParam : (CXIAOYING_RECT *)pRect
                        angle : (float) fAngle
                TransformPara : (CXIAOYING_TRANSFORM_PARAMETERS*) pTransformPara;


- (SInt32) SetTransParam2Rect : (CXIAOYING_TRANSFORM_PARAMETERS*) pTransformPara
                     ViewSize : (CXIAOYING_SIZE *) pViewSize
                         Rect : (CXIAOYING_RECT *)pRect;


/**
 * Clear original source info list
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) ClearOrgSourceInfoList;


/**
 * Get original source info count
 * @param puiCount,original source info count
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) GetOrgSourceCount : (UInt32* _Nonnull) puiCount;


/**
 *Get original source info node  in source list
 *@param uiSrcIndex,source info node index
 * @return source info node if successful,nil if failed.
 */
- (CXiaoYingSourceInfoNode* _Nullable) GetOrgSource : (UInt32) uiSrcIndex;

/**
 *Get text animation array by clip index
 *@param uiClipIndex,clip index
 * @return text animatin array of cilp
 */
- (NSArray* _Nullable) GetTextAnimationByClipIndex : (UInt32) uiClipIndex;

/**
 *Get virtual node original scale value
 *@param uiVirtualIndex,virtual node index
 * @return virtual node original scale value
 */
- (MFloat) GetVirtualNodeOrgScaleValue : (UInt32) uiVirtualIndex;

/*
 * Function :MoveVirtualSource
 *	 move srcIndex To dstIndex
 * Param:
 *	 In dwSrcIndex:Src index
 *   In dwDstIndex:Dst index
 *Return:
 *	  0 success else fail
 */ 
- (MRESULT) MoveVirtualSource : (UInt32) dwSrcIndex
						  DstPosition :(UInt32) dwDstIndex;
@end // CXiaoYingSlideShowSession

