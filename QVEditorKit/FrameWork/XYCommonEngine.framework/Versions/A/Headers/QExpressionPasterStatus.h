


/*! @constant QVCE_EXPRESSION_PASTER_DISPLAY_STOPPED The final frame of expression paster is displayed*/
#define QVCE_EXPRESSION_PASTER_DISPLAY_STOPPED  0
/*! @constant QVCE_EXPRESSION_PASTER_DISPLAY_STARTED The first frame of expression paster is displayed*/
#define QVCE_EXPRESSION_PASTER_DISPLAY_STARTED  1

/*!
 * @brief This class is used to notify application what's the status of expression paster.
 *        This status info is delivered with the even "XYCE_STATUS_EXPRESSION_PASTER_DISPLAY_STATUS"
 *        via XYCEDelegate at the field of XYCE_STATUS.pData.
 *        But you need to cast type via (__brige QExpressionPasterStatus*)
 */
@interface QExpressionPasterStatus : NSObject

/*!
 * @brief status is associated with the target template.
 */
@property(readwrite, nonatomic) NSString* templateFile;

/*!
 * @brief status is at the value of QVCE_EXPRESSION_PASTER_DISPLAY_STOPPED or QVCE_EXPRESSION_PASTER_DISPLAY_STARTED
 */
@property(assign, nonatomic) int status;

@end



