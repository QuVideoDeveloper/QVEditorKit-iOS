/*!
 *  @brief this class is used to describe the effect update action
 */
@interface QCamEffectUpdateItem : NSObject



/*!
 * @brief ZOrder is used to indentify the effect
 */
@property(assign, nonatomic) unsigned int ZOrder;

/*!
 *  @brief type is used to identify which kind of update you want to perform.
 *         It has the value is such as QCAM_EFFECT_UPDATE_TYPE_FILTER_PARAM, QCAM_EFFECT_UPDATE_TYPE_PIP_SRC, and etc..
 */
@property(assign, nonatomic) unsigned int type;

/*!
 *  @brief Different update type is corresponding to the different data.
 *  If type equals to QCAM_EFFECT_UPDATE_TYPE_FILTER_PARAM, it's an instance of QFilterParm.
 *  If type equals to QCAM_EFFECT_UPDATE_TYPE_PIP_SRC, it's an instance of QPIPSrc.
 *  If type equals to QCAM_EFFECT_UPDATE_TYPE_PIP_SRC_MODE, it's an instance of QPIPSrcMode.
 *  If type equals to QCAM_EFFECT_UPDATE_TYPE_TIMESTAMP, it's an instance of QTimeInfo.
 *  If type equals to QCAM_EFFECT_UPDATE_TYPE_FOCUS_PASTER, it's an instance of NSNumber(int) which means the face ID.
 *  If type equals to QCAM_EFFECT_UPDATE_TYPE_UNFOCUS_PASTER, it's an instance of NSNumber(int) which means the face id
 *  If type equals to QCAM_EFFECT_UPDATE_TYPE_PASTER_INFO, it's an instance of QCamEffectPasterInfo.
 *  If type equals to QCAM_EFFECT_UPDATE_TYPE_BLEND_ALPHA, it's an instance of NSNumber(float)
 *  If type is:
 *      QCAM_EFFECT_UPDATE_TYPE_INSERT_NEW_TRAJECTORY
 *      QCAM_EFFECT_UPDATE_TYPE_UPDATE_TRAJECOTRY
 *          It's an instance of QTrajectory. refer to QTrajectory for more info.
 *      QCAM_EFFECT_UPDATA_TYPE_REMOVE_TRAJECTORY
 *          It's an instance of QTrajectory. and only QTrajectory.idx is needed
 *  If type is:
 *      QCAM_EFFECT_UPDATE_TYPE_REMOVE_ALL_TRAJECTORY, it's nil
 */
@property(readwrite, nonatomic) NSObject *data;

@end
