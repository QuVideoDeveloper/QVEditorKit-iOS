/*CXiaoYingStoryBoardSession.h
*
*Reference:
*
*Description: Define XiaoYing StoryBoard Session API.
*
*/

@interface CProjectMediaInfo : NSObject {
@public

    AMVE_POSITION_RANGE_TYPE srcRange;
    AMVE_POSITION_RANGE_TYPE trimRange;
    MLong lUID;       //所属的Clip或者Effect的唯一标识
    MDWord dwFatherType; //属于clip还是Effect PROJECT_MEDIA_FATHER_TYPE_XX
	MDWord dwIndex;     //当同一个Effect绑定多个资源的时候，index用来区分
}

@property (nonatomic,copy) NSString* strFilePath;

@end

@interface CXiaoYingStoryBoardProjectData : NSObject {
@public
    
    MDWord dwProjectID;
    MInt64 themeID;

}
@property(nonatomic, strong) NSArray* templates; //NSNumber
@property(nonatomic, strong) NSArray* mediaInfos;

@end


@interface CXiaoYingStoryBoardSession : CXiaoYingSession
{

}

@property(readwrite, nonatomic) MBool isRefData;

/**
 * Initializes the session.
 * 
 * @param pEngine an instance of CXiaoYingEngine.
 * @param statehandler,session state call back handler
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
 

- (MRESULT) Init : (CXiaoYingEngine*)pEngine
 ThemeOptHandler : (id <AMVEThemeOptDelegate>) themeOpthandler;

/**
* Destroys the session.
 * 
* @return MERR_NONE if the operation is successful, other value if failed.
*/


- (MRESULT) UnInit;

/**
	 * Duplicate the storyboard.
	 *  
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

//- (MRESULT) duplicate : (CXiaoYingStoryBoardSession*) storyBoardDst;

+ (CXiaoYingStoryBoardSession*) duplicate : (CXiaoYingStoryBoardSession*) srcStb;

/**
	 * Gets duration of storyboard.
	 *  
	 * @return The duration of the storyboard.
*/

- (MDWord) getDuration;

/**
	 * Gets clip count of storyboard.
	 * 
	 * @return The clip count of the storyboard.
*/

- (MDWord) getClipCount;

/**
	 * Inserts clip into storyboard.
	 * 
	 * @param pClip	The clip which will be inserted to storyboard.
	 * @param dwIndex The index will this clip should be inserted.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/
	 

- (MRESULT) insertClip : (CXiaoYingClip*) pClip
	                     Position : (MDWord) dwIndex;

/**
	 * Removes the clip from storyboard. 
	 * 
	 * @param pClip The clip will be remove from storyboard.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) removeClip : (CXiaoYingClip*) pClip;

/**
	 * Removes all inserted clips from storyboard, and storyboard will destroy all clips.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) removeAllClip;

/**
	 * Moves clip to specified position in the storyboard. 
	 * The clip should already be inserted into storyboard. 
	 * iIndex should in the range of [0, count of clips in storyboard - 1].
	 * 
	 * @param pClip The clip to be moved.
	 * @param dwIndex The new position in storyboard.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) moveClip : (CXiaoYingClip*) pClip
	                   Position : (MDWord) dwIndex;

/**
	 * Gets the clip by index from storyboard.
	 * 
	 * @param dwIndex The index of clip to get. The iIndex should less than the count of clips in storyboard.
	 * 
	 * @return null if the operation is failed.
*/

- (CXiaoYingClip*) getClip : (MDWord) dwIndex;

/**
     * Gets the clip by index from storyboard by uuid.
     *
     * @param strUuid The uuid of clip. Get by AMVE_PROP_CLIP_UUID.
     *
     * @return null if the operation is failed.
*/

- (CXiaoYingClip*) getClipByUuid : (MTChar*) strUuid;

/**
	 * Gets the data clip of storyboard. The handle of data clip is needed when 
	 * managing the clip function for storyboard.
	 * 
	 * @return null if the operation is failed.
*/

- (CXiaoYingClip*) getDataClip;


/**
	 * Loads the storyboard from project file.
	 * 
	 * @param strProjectFile The project file from which the storyboard loads. 
	 * @param statehandler,session state callback handler
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/


- (MRESULT) loadProject : (MTChar*) strProjectFile
            SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler;
/**
	 * Saves the storyboard from project file.
	 * 
	 * @param strProjectFile The project file from which the storyboard loads. 
	 * @param statehandler,session state callback handler 
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) saveProject : (MTChar*) strProjectFile
	                      SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler;



/**
	 * Loads the storyboard from project file, using fetchProjectData to get ProjectData 
	 * 
	 * @param strProjectFile The project file from which the storyboard loads. 
	 * @param statehandler,session state callback handler
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/


- (MRESULT) loadProjectData : (MTChar*) strProjectFile
            SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler;
/**
	 * fetch ProjectData
	 * 
	 * @param data The project file from which the storyboard loads. 
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (CXiaoYingStoryBoardProjectData*) fetchProjectData;


/**
	 * Apply theme to storyboard.
	 * 
	 * @param themeTemplate The theme template name.
	 * @param statehandler,session state callback handler  
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) applyTheme : (MTChar*) themeTemplate
	                     SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler;


/**
 * Set theme operation handler
 *
 * @param themopthandler The theme operation callback handler
 *
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) setThemeOperationHandler : (id <AMVEThemeOptDelegate>) themopthandler;


/**
 * Get clip position by time
 *
 * @param dwTime timestamp in storyboard
 * @param pClipPosition,clip position in clip
 *
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) getClipPositionByTime : (MDWord) dwTime
                       ClipPositon : (QVET_CLIP_POSITION*) pClipPosition;

					   
/**
 * Get clip position array by time
 *
 * @param dwTime timestamp in storyboard
 * @param pClipPosition,clip position in clip
 * @param dwInCount, allocated pClipPosition's count
 * @param pdwOutCount, output pClipPosition's count
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) getClipPositionArrayByTime : (MDWord) dwTime
                      ClipPositon : (QVET_CLIP_POSITION*) pClipPosition
					  ClipPositonInCount:(MDWord) dwInCount
					  ClipPositonOutCount:(MDWord*) pdwOutCount;
					   

/**
 * Get clip position by index
 *
 * @param dwIndex, clip index, it include cover and back cover
 * @param pClipPosition,clip position in clip
 *
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) getClipPositionByIndex : (MDWord) dwIndex
                      ClipPositon : (QVET_CLIP_POSITION*) pClipPosition;


/**
 * Get story board timestamp by clip position
 *
 * @param pClipPosition clip position in clip
 * @param pdwTime,timestamp in storyboard
 *
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) getTimeByClipPosition : (QVET_CLIP_POSITION*) pClipPosition
                        Timestamp : (MDWord*) pdwTime;


/**
 * Get clip index in storyboard by clip position
 *
 * @param pClipPosition clip position in clip
 * @param pdwIndex,clip index
 *
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) getIndexByClipPosition : (QVET_CLIP_POSITION*) pClipPosition
                         ClipIndex : (MDWord*) pdwIndex;



/**
 * Apply the storyboard trim range
 * 
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) applyTrim;


/**
 * Get transition's time range in storyboard
 *
 * @param dwClipIndex, clip index in storyboard.
 * @param pTimerange, transition's time range in storyboard
 *
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) getTransitionTimeRange : (MDWord) dwClipIndex
                         TimeRange : (AMVE_POSITION_RANGE_TYPE*) pTimeRange;


/**
 * Get clip's time range in storyboard
 *
 * @param dwClipIndex, clip index in storyboard.
 * @param pTimerange, clip's time range in storyboard
 *
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) getClipTimeRange : (MDWord) dwClipIndex
                   TimeRange : (AMVE_POSITION_RANGE_TYPE*) pTimeRange;
				   
				   
- (MDWord) getProjectEngineVersion : (MTChar*) strProjectFile;

@end // CXiaoYingStoryBoardSession 


