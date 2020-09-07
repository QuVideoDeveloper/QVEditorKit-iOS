/*CXiaoYingAudioPlayer.h
*
*Reference:
*
*Description: Define XiaoYing Audio Player  API.
*
*/



#define QVET_PROP_AUDIO_PLAYER_BASE  0
#define QVET_PROP_AUDIO_RANGE        (QVET_PROP_AUDIO_PLAYER_BASE + 1)
#define QVET_PROP_AUDIO_GAIN         (QVET_PROP_AUDIO_PLAYER_BASE + 2)
#define QVET_PROP_AUDIO_FADE_IN      (QVET_PROP_AUDIO_PLAYER_BASE + 3)
#define QVET_PROP_AUDIO_FADE_OUT     (QVET_PROP_AUDIO_PLAYER_BASE + 4)
#define QVET_PROP_AUDIO_MUTE         (QVET_PROP_AUDIO_PLAYER_BASE + 5)
#define QVET_PROP_AUDIO_PITCH		 (QVET_PROP_AUDIO_PLAYER_BASE + 6)

@interface CXiaoYingAudioPlayer : NSObject
{
		
}
/**
 * Initializes the player.
 * 
 * @param pEngine an instance of CXiaoYingEngine.
 * @param pStrAudio,audio file url
 * @param pRange,audio file source range
 * @param statehandler,session state call back handler
 * 
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
 

- (MRESULT) Init : (CXiaoYingEngine*)pEngine
                   AudioFile           : (NSString*)pStrAudio
                   SourceRange         : (CXIAOYING_POSITION_RANGE_TYPE*) pRange
	               SessionStateHandler : (id <AMVESessionStateDelegate>) statehandler; 

/**
* Destroys the player.
 * 
* @return None.
*/


- (MVoid) UnInit;




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
	 * Refreshs the stream data after set property.
	 * 
	 * @param None
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/
- (MRESULT) RefreshStream;

/**
	 * Sets property of the player.
	 * 
	 * @param dwPropertyID property id
	 * @param pValue data set to the property
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) setProperty : (MDWord) dwPropertyID
	                      Value : (MVoid*) pValue;
/**
	 * Gets property of the player.
	 * 
	 * @param dwPropertyID property id
	 * @param pValue data set to the property
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) getProperty : (MDWord) dwPropertyID
	                      Value : (MVoid*) pValue;


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
	 * Gets player state.
	 * 
	 * @param pState player state
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) getState : (AMVE_PLAYER_STATE_TYPE*)pState;



@end // CXiaoYingAuidoPlayer

