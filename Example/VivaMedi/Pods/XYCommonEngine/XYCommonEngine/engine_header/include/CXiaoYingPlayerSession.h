/*CXiaoYingPlayerSession.h
*
*Reference:
*
*Description: Define XiaoYing Player Session API.
*
*/

@interface CXiaoYingPlayerSession : CXiaoYingSession
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
 

- (MRESULT) Init : (CXiaoYingEngine*)pEngine
	               SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler; 

/**
* Destroys the session.
 * 
* @return MERR_NONE if the operation is successful, other value if failed.
*/


- (MRESULT) UnInit;

/**
	 *Active the source session stream of clip or storyboard to player session. This function must be called after player session is initialized. 
	 * 
	 * @param pStream The source stream 
	 * @param dwPosition Stream start position
	 * @param bSyncSeek seek flag
	 * 
	 * @return QVEError.QERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) ActiveStream : (CXiaoYingStream*) pStream
                Position : (MDWord) dwPosition
                SeekFlag : (MBool) bSyncSeek;


- (MRESULT) DeActiveStream;


/**
	 * Starts or resumes the video playback
	 * This function should be called when the current status is 
	 * STATUS_READY/STATUS_PAUSED/STATUS_STOPPED, 
	 * these status will be notified through {@link xiaoying.engine.base.IQSessionStateListener}. 
	 * And after this function is called, the status will switch to QVET_SESSION_STATUS_RUNNING 
	 * when the callback function is called.
	 * 
	 * @return  MERR_NONE if the operation is successful, other value if failed.
	 */	                    
- (MRESULT) Play;	

/**
	 * Pauses the video playback.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Pause;

/**
	 * Stops the video playback.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Stop;

/**
	 * Seeks the player to a specified position (in milliseconds).
	 * 
	 * @param dwPosition position (in milliseconds) to seek to.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) SeekTo : (MDWord) dwPosition;

/**
	 * Seeks the player to a key frame near at specified position (in milliseconds).
	 * 
	 * @param dwPosition  (in milliseconds) to seek to.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) SyncSeekTo : (MDWord) dwPosition;

/**
	 * Sets the playback mode.
	 * 
	 * @param dwMode Playback mode.
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) setMode : (MDWord) dwMode;

/**
	 * Changes the audio playback volume level to the specified value. 
	 * This function can be used to adjust volume on stylus-based devices, 
	 * i.e., when a slider is provided for the user to adjust the volume 
	 * using drag&drop and/or tap.Please note that "mute" is different than 
	 * "zero volume". When the audio is muted, the session still remembers 
	 * the current volume level. As soon as the audio is un-muted, the session 
	 * will restore the volume to this value without application making any 
	 * additional calls.
	 * 
	 * @param dwVolume  New volume, from 0 to 100.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
	 */

- (MRESULT) setVolume : (MDWord) dwVolume;

/**
	 * Disable playback of specified track in the clip.
	 * 
	 * @param dwTrackType,video or audio.
	 * @param bDisable true: Disable the track to playback
     *                false: Enable the track to playback

	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) disableTrack : (MDWord) dwTrackType
	                       DisableFlag : (MBool) bDisable;


/**
	 * Gets current displayed video frame.
	 * 
	 * @param dwWidth    Width of frame. it is the number of pixels in each row.
	 * @param dwHeight   Height of frame. it is the number of rows.
	 * @param dwColor   Color Space of frame.
	 * @param cvImgBuf Image buffer for current frame
	 * @return MERR_NONE if the operation is successful, other value if failed.
 */


- (MRESULT) getCurFrame : (MDWord) dwWidth
	                      Height : (MDWord) dwHeight
	                      ColorSpace : (MDWord) dwColor
                          ImageBuffer : (CVImageBufferRef) cvImgBuf;

/**
	 * Disable or enable display.
	 * 
	 * @param bDisalbe true: Disable display
       *                false: Enable display
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) disableDisplay : (MBool) bDisalbe;

/**
	 * Restarts audio device.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) audioRestart;

/**
	 * Refreshes the last played frame and text. When the state of session become 
	 * to STATUS_READY, user should call this function to display the first frame.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) displayRefresh;

/**
	 * Sets the display context for video frame and text.
	 * 
	 * @param pDisplayContext Display context.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) setDisplayContext : (QVET_RENDER_CONTEXT_TYPE*)pDisplayContext;

/**
	 * Gets the display context for video frame and text.
	 * 
	 * @param pDisplayContext Display context.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) getDisplayContext : (QVET_RENDER_CONTEXT_TYPE*)pDisplayContext;

- (MRESULT) getViewport:(MRECT*)prcViewport;

/**
	 * Refreshs the stream data after effect(panzoom, transition, etc.) changed.
	 * 
	 * @param hClip: The clip for effect's owner.
	 *				dwOpCode: The operation code of effect changed.
	 *				pEffect: The pointer for changed effect.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/
- (MRESULT) RefreshStream : (MHandle)hClip
								   OpCode : (MDWord)dwOpCode
								   Effect : (CXiaoYingEffect*)pEffect;
/**
 * Call glFinish when enter background
 *
 * @param  None
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) FinishOpenGL;


/**
 * After you lock the "QEffect e" , engine can perform the efficient display-refresh when you do like this:</br> 
 * When you want to modify effect property of "QEffet e" and refresh the video frame,we need to reserve 
 * the background video with  effects that layer id is smaller than "QEffet e".
 *	 1. modify the "QEffect e"'s effect property . </br>
 *	 2. call QPlayer's displayRefresh API to show the corresponding result. </br>
 *	 3. repeat the step-1 and step-2 at your will. </br>   
 *	 </br>
 * Don't forget to use unlockStuffUnderEffect to unlock when finish the operation.</br>
 * @param  e The effect you want to lock.</br>
 */ 
- (MRESULT)lockStuffUnderEffect : (CXiaoYingEffect*) e;

/**
 * call it in pair with lockStuffUnderEffect
 * @param e - The effect you locked before.
 */
- (MRESULT)unlockStuffUnderEffect : (CXiaoYingEffect*) e;


/**
 * @param opType now, only AMVE_PS_OP_REFRESH_AUDIO is available, refer to definition in amvedef.h for more info
 */
- (MRESULT)performOperation : (MDWord)opTpye
                      param : (MVoid*)opParam;


					  
/**
 * @param get cur player effect frame
 */					  
- (MRESULT) getCurFrameEffect : (CVImageBufferRef) cvImgBuf effect:(CXiaoYingEffect*)pEffect;

/**
 * @param get cur player clip ori frame
 */
- (MRESULT) getCurOriFrameClip : (CVImageBufferRef) cvImgBuf effect:(CXiaoYingClip*)pClip;

@end // CXiaoYingPlayerSession

