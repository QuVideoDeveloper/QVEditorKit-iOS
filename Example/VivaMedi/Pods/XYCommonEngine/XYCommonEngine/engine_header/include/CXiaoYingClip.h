/*CXiaoYingClip.h
*
*Reference:
*
*Description: Define XiaoYing Clip  API.
*
*/
@interface CXiaoYingClip : NSObject
{
    @protected
    MHandle _hClip;
    MHandle _hThumbnailMgr;
    MBool _bNeedDeleteClip;
}
@property(readwrite, nonatomic) MHandle hClip;
@property(readonly, nonatomic) MHandle hThumbnailMgr;
@property(readwrite,nonatomic) MBool bNeedDeleteClip;

/**
 * 
 * Initializes the clip.
 * 
 * @param pEngine a instance of CXiaoYingEngine
 * @param pMediaSource media source of clip.
 * @return MERR_NONE if the operation is successful, other value if failed.
 * 
 */
 

- (MRESULT) Init : (CXiaoYingEngine*)pEngine 
	               MediaSource : (AMVE_MEDIA_SOURCE_TYPE*)pMediaSource;

- (MRESULT) Init : (CXiaoYingEngine*)pEngine
     MediaSource : (AMVE_MEDIA_SOURCE_TYPE*)pMediaSource
        ClipType : (MDWord)dwClipType
       VideoInfo : (AMVE_VIDEO_INFO_TYPE*)pVideoInfo
         ExtInfo : (AMVE_SOURCE_EXT_INFO*)pExtInfo;


- (MRESULT) ReplaceSource :(AMVE_MEDIA_SOURCE_TYPE*)pMediaSource
                  SrcRange:(AMVE_POSITION_RANGE_TYPE) stSrcRange
                 TrimRange:(AMVE_POSITION_RANGE_TYPE) stTrimRange;
/**
 *
 * Destroys the clip;
 *  @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) UnInit;

/**
 * 
 * Duplicate the clip;
 *@param pClipDst source clip
 *@return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) duplicate : (CXiaoYingClip*) pClipSrc;


/**
 * Create thumbnail manager.
 * 
 * @param width The width of stream that is used to get the thumbnail.
 * @param height The height of stream that is used to get the thumbnail.
 * @param resampleMode The resample mode when transforming the stream data to the pBitmap.
 * @param bPrimal If this flag is true, the thumbnail will be generated without effect.
 * @return MERR_NONE if the operation is successful, other value if failed.
 */


- (MRESULT) createThumbnailManager : (MDWord) dwWidth
                            Height : (MDWord) dwHeight
                      ResampleMode : (MDWord) dwResampleMode
                         PimalFlag : (MBool) bPrimal
                   OnlyOriginalClip: (MBool) bOnlyOriginalClip;


/**
* Destroy thumbnail manager which has been created by QVET_ClipThumbnailMgrCreate.
 * 
* @return MERR_NONE if the operation is successful, other value if failed.
*/	                                 
- (MRESULT) destroyThumbnailManager;

/**
* Gets the thumbnail at specified position of video track in clip.
* 
* @param dwPosition The specified position of video track to get the thumbnail.
* @param bSkipBlackFrame The flag to control if skip black frame or not. 
*    If set to MTrue, it will skip black frame.
* @param   cvImgBuf,image buffer to restore thumbnail                     
* @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) getThumbnail : (MDWord) dwPosition
	                       SkipBlackFrameFlag : (MBool)bSkipBlackFrame
                           ImageBuffer : (CVImageBufferRef) cvImgBuf;


- (MRESULT) getOriThumbnail : (MDWord) dwPosition
      SkipBlackFrameFlag : (MBool)bSkipBlackFrame
             ImageBuffer : (CVImageBufferRef) cvImgBuf;

/**
* Gets the keyframe thumbnail at specified position of video track in clip.
* 
* @param dwPosition The specified position of video track to get the thumbnail.
* @param bSkipBlackFrame The flag to control if skip black frame or not. 
*    If set to MTrue, it will skip black frame.
* @param   cvImgBuf,image buffer to restore thumbnail                       
 * @return MERR_NONE if the operation is successful, other value if failed.
*/
	                       
- (MRESULT) getKeyframe : (MDWord) dwPosition
	                      SkipBlackFrameFlag : (MBool)bSkipBlackFrame
                          ImageBuffer : (CVImageBufferRef) cvImgBuf;

/**
	 * Gets the PCM samples from the specified position of audio track with 
	 * a specified length in video clip. These samples can be drawn as the visual 
	 * waveform chart to show a part of audio track.
	 * 
	 * @param position The position to retrieve the sample
	 * @param milliseconds The length of audio in millisecond to retrieve
	 * @param leftSampleBuf The buffer to fill with the samples of left channel
     * @param lLeftLen The left audio buffer length
	 * @param rightSampleBuf The buffer to fill with the samples of right channel
     * @param lRightLen The right audio buffer lenght
	 * @param values First element of the array is used for the sample buffer length for left channel as input and the 
	 *                    actual length as return value, in bytes,
	 *               Second element of the array is used for the sample buffer length for right channel as input and the 
	 *                     actual length as return value, in bytes,
	 *               Third element of the array is used for the wanted sample count as input and the actual 
	 *                     sample count stored in buffer as return value. 
	 *                     If iSampleCount is smaller than the actual sample number in specified 
	 *                     length(dwAudioLen), the down-sampling operation will be applied so the output 
	 *                     buffer will store the specified count of sample.
	 *                     If iSampleCount is equal or bigger than actual sample number in specified 
	 *                     length(dwAudioLen), no any re-sampling operation will be applied and actual 
	 *                     sample count will be returned.
	 *                     
	 * @return MERR_NONE if the operation is successful, other value if failed.
	 */


- (MRESULT) extractAudioSample : (MDWord) dwPosition
	                             AudioLength : (MDWord) dwMiliSecond
	                             LeftSampleBuffer : (MByte*)pLeftSampleBuf
                                 LeftBufLen : (MLong)lLeftLen
	                             RightSampleBuffer : (MByte*)pRightSampleBuf
                                 RightBufLen : (MLong)lRightLen
	                             SampleCount : (MDWord)dwSampleCount;

	                             
/**
* Adds an new effect to the clip.
* 
* @param pEffect Effect handle
* 
* @return MERR_NONE if the operation is successful, other value if failed.
*/


- (MRESULT) insertEffect : (CXiaoYingEffect*) pEffect;


/**
 * Removes the specified effect from the clip.
 * 
 * @param pEffect Effect handle.
 * 
 * @return MERR_NONE if the operation is successful, other value if failed.
 */


- (MRESULT) removeEffect : (CXiaoYingEffect*) pEffect;



/**
	 * Gets the total count of specified track type effects that have been added to the clip with specified id.
	 * 
	 * @param dwTrackType The specified track type.
	 * @param dwGroupID The group id of effect, user can set a value to it to set the sort of effect.
	 * 
	 * @return The count of effects in the clip.
*/

- (MDWord) getEffectCount : (MDWord) dwTrackType
	                        GroupID : (MDWord) dwGroupID;


/**
	 * Gets the handle of effect in the clip.
	 * 
	 * @param dwEffectTrackType The track type of the effect, please refer to QVET_EFFECT_TRACK_TYPE for more details.
	 * @param dwGroupID The group id of effect, user can set a value to it to set the sort of effect.
	 * @param dwIndex The index of effect to get. The iIndex should less than the count of specified track type effects in clip.
	 * 
	 * @return null if failed.
*/
	 

- (CXiaoYingEffect*) getEffect : (MDWord) dwEffectTrackType
	                    GroupID : (MDWord) dwGroupID
	                    EffectIndex : (MDWord) dwIndex;

/**
     * Gets the handle of effect in the clip by uuid.
     *
     * @param strUuid, the uuid of the effect, get by AMVE_PROP_EFFECT_UUID
     *
     * @return null if failed.
*/
- (CXiaoYingEffect*) getEffectByUuid : (MTChar*) strUuid;

/**
	 * Moves effect to a specified position in the clip. iIndex should in the range of [0, count of specified track type effects in clip - 1].
	 * 
	 * @param pEffect The effect to be moved.
	 * @param dwIndex The new position in clip.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/


- (MRESULT) moveEffect : (CXiaoYingEffect*) pEffect
	                     NewPosition : (MDWord) dwIndex;
/**
	 * Sets property of the clip.
	 * 
	 * @param dwPropertyID property id
	 * @param pValue data set to the property
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) setProperty : (MDWord) dwPropertyID
	                      PropertyData : (MVoid*)pValue;

/**
	 * Gets property of the clip.
	 * 
	 * @param dwPropertyID property id
	 * @param pValue data set to the property
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) getProperty : (MDWord) dwPropertyID
	                      PropertyData : (MVoid*)pValue;

/**
 * Gets scaled video duration
 *
 * @return scaled video duration
 */
- (UInt32) getRealVideoDuration;

/**
 * Get cilp camera exported effect data param array
 *
 * @return camera exported effect data param array
 */
- (NSArray <CXiaoYingCamExportEffectData*>* _Nullable ) getCamExportEffectDataArray;

/**
 * Set cilp camera exported effect data param array
 *
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (SInt32) setCamExportedEffectDataArray : (NSArray <CXiaoYingCamExportEffectData*>* _Nonnull) pExpDataArray;

/**
* Get key frame position from thumbnail manager,should be invoked after createThumbnailManager and getThumbnal or getKeyframe was called
*@param In/Out: pdwPostion:current position passed in and key frame position output
*@param In bNext:MTrue means get next key frame position,MFalse means get prev key frame position
*  if current position is key frame,bNext==MTrue will return current position,bNext==MFalse will return prev key frame position
* @return MERR_NONE if the operation is successful, other value if failed.
*/
- (SInt32) getKeyFramePositionFromThumbnailMgr : (MDWord*) pdwPostion
                                        Direct : (MBool)bNext;

@end // CXiaoYingClip

