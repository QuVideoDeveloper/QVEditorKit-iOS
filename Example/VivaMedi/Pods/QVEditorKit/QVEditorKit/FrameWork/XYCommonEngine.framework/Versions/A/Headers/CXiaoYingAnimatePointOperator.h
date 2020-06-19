/*CXiaoYingAnimatePointOperator.h
*
*Reference:
*
*Description: Define XiaoYing AnimatePointOperator  API.
*
*/

@interface CXiaoYingAnimatePointOperator : NSObject
{
    
}

/**
 *
 * Initializes the animatepint operator from effect handle.
 *
 * @param hEffect effect handle
 *         pViewSize viewport size
 * @return MERR_NONE if the operation is successful, other value if failed.
 *
 */
- (MRESULT) Init : (MHandle) hEffect
        ViewSize : (MSIZE*) pViewSize;


/**
 *
 * Apply ainmate point operation
 *
 * @param pAnimatePointOpt animate point operation
 * @return MERR_NONE if the operation is successful, other value if failed.
 *
 */
- (MRESULT) ApplyAnimatePointOpt : (QVET_AINIMATE_POINT_OPERATION_DATA*) pAnimatePointOpt;



/**
 *
 * Get current animate point data
 * @param ppAnimatePointData ainmate point data array,need to free by user
 *        pdwPointCount point data count
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
- (MRESULT) GetAimatePointData : (QVET_ANIMATE_POINT_DATA**) ppAnimatePointData
                    PointCount : (MDWord*) pdwPointCount;


@end // CXiaoYingAnimatePointOperator

