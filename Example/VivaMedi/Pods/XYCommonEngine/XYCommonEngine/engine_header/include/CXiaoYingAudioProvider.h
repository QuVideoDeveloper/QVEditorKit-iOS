/*CXiaoYingAudioProvider.h
*
*Reference:
*
*Description: Define XiaoYing audio provider API.
*
*/

@protocol AudioObserverDelegate <NSObject>
- (MDWord) onSourcePacket : (MByte*) pData
                   BufLen : (MDWord) dwLength
                StartTime : (MDWord)dwTime;
@end


@interface CXiaoYingAudioProvider : CXiaoYingSession
{
    id<AudioObserverDelegate> _mAudioObserver;
}

@property(readonly, nonatomic) id<AudioObserverDelegate> mAudioObserver;

/**
 * Initializes the session.
 * 
 * @param pEngine an instance of CXiaoYingEngine.
 * @param statehandler session state callback funciton handler.
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
 *Sets the source stream of clip or storyboard to producer session. This function must be called after producer session is initialized. 
 * 
 * @param pStream The source stream
 * 
 * @return MERR_NONE if the operation is successful, other value if failed.
 */


- (MRESULT) ActiveStream : (CXiaoYingStream*) pStream;




- (MRESULT) DeActiveStream;

/**
	 *Starts the produce process for the session. This function can be called immediately after set 
	 *the PROP_PARAM property because the status of producer is guaranteed 
	 *to be "ready" after set the PROP_PARAM property returns.
	 *
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Start;

/**
	 * Pauses the produce process for the session. 
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Pause;

/**
	 * Resumes the produce process for the session. 
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Resume;

/**
	 * Stops the produce process for the session. 
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Stop;


/**
	 * Cancels the produce process for the session and delete the file.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Cancle;



/**
* Setsaudio observer.
*
* @param AudioObserver audio observer
*
* @return MERR_NONE if the operation is successful, other value if failed.
*/
- (MRESULT) setAudioObserver : (id<AudioObserverDelegate>) AudioObserver;


@end // CXiaoYingProducerSession

