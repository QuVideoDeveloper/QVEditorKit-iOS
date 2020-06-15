

/*!
 *  @brief this class is used to describe the paster info.
 */
@interface QCamEffectPasterInfo : NSObject



/*!
 *  @brief It's the paster rotate angle, and it's anti-clockwise.
 */
@property(assign, nonatomic) float rotation;

/*!
 *   @brief used to identify which face is related to the paster
 */
@property(assign, nonatomic) unsigned int faceID;

/*!
 *  @brief used to describe the paster size, which is based on 1/10000. It's related to the preview background.
 */
@property(readwrite, nonatomic) QRect *region;


@end