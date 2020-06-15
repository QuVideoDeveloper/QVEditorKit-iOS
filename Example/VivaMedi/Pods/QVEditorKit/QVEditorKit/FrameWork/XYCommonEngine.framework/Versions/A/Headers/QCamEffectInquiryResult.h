

/*!
 * @brief engine use QCamEffectInquiryResult to give the inquiry result
 */


@interface QCamEffectInquiryResult : NSObject


/*!
 * @brief type is used identify which inquiry action you want to perform.
 *        It's value is such as QCAM_EFFECT_INQUIRY_TYPE_IS_IN_PASTER_REGION, QCAM_EFFECT_INQUIRY_TYPE_PASTER_INFO, and etc..
 */
@property(assign, nonatomic) unsigned int type;
/*!
 * @brief Different inquiry type is corresponding to the different data.
 *        If type equals to QCAM_EFFECT_INQUIRY_TYPE_IS_IN_PASTER_REGION, the data is an instance of NSNuber(int) which
 *        is the facd ID. When you make this inquiry, you send engine a QPoint and engine tell you that point locates on which
 *        face. If the face ID is QCAM_INVALID_FACE_ID, it means no face includes that point.
 *        If type equals to QCAM_EFFECT_INQUIRY_TYPE_PASTER_INFO, the data is an instance of QCamEffectPasterInfo.
 *        It tells you the face-paster rotation angle, size, and which face is using the face-paster
 * @see   QCamEffectPasterInfo
 */
@property(readwrite, nonatomic) NSObject *data;

/*!
 * @brief ZOrder is used to indentify the effect
 */
@property(assign, nonatomic) unsigned int ZOrder;

@end