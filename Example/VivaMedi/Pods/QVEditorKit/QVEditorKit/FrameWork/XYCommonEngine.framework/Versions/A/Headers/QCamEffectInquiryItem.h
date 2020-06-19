

/*!
 *  @brief this class is used to describe the inquiry action.
 */
@interface QCamEffectInquiryItem : NSObject


/*!
 *  @brief type is used to identify which inquiry you want to perform
 */
@property(assign, nonatomic) unsigned int type;

/*!
 *  @brief auxiliaryData is used to give more info about the inquiry. The different inquiry type is corresponding to different auxiliaryData
 *         If type equals to QCAM_EFFECT_INQUIRY_TYPE_IS_IN_PASTER_REGION, the auxiliaryData is an instance of QPoint. It means if
 *         this point is in the face-paster region. And after inquiry, you will get the face ID.
 *
 *         If type equals to QCAM_EFFECT_INQUIRY_TYPE_PASTER_INFO, the auxiliaryData is an instance of NSNumber(int) which is the face ID.
 *         You tell engine the face ID, then engine tells you the paster info applied in that face.
 *  @see QCamEffectInquiryResult
 */
@property(readwrite, nonatomic) NSObject *auxiliaryData;

/*!
 * @brief ZOrder is used to indentify the effect
 */
@property(assign, nonatomic) unsigned int ZOrder;

@end