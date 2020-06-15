
/*!
 *  @brief this class is used to describe a point.
 */

@interface QPoint : NSObject


/*! @brief x */
@property(assign, nonatomic) int x;

/*! @brief y*/
@property(assign, nonatomic) int y;

/*!
 * @brief copy value from a c-style point
 * @param src is the source c-style point copied from
 */
- (void)copy : (MPOINT*)src;

/*!
 * @brief initializing function for your convinience
 * @param x value
 * @param y value
 * @return the instance of a QPoint.
 */
- (id)initWithValue : (int)x
                  y : (int)y;
@end




/*!
 *  @brief this class is used to describe a rectangle.
 */
@interface QRect : NSObject

/*! @brief left */
@property(assign, nonatomic) int left;
/*! @brief top */
@property(assign, nonatomic) int top;
/*! @brief right */
@property(assign, nonatomic) int right;
/*! @brief bottom */
@property(assign, nonatomic) int bottom;


/*!
 * @brief copy value from a c-style rectangle
 * @param src is the source c-style rectangle copied from
 */
- (void)copy : (MRECT*)src;

/*!
 * @brief initializing function for your convinience
 * @param left value
 * @param top  value
 * @param right value
 * @param bottom value
 * @return the instance of a QRect.
 */
- (id)initWithValue : (int)left
                top : (int)top
              right : (int)right
             bottom : (int)bottom;

@end











