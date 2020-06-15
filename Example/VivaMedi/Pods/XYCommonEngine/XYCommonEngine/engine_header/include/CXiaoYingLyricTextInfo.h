/*CXiaoYingLyricData
*
*Reference:
*
*Description: Define XiaoYing Effect  API.
*
*/

@interface CXiaoYingLyricTextInfo : NSObject
{
    UInt32 _dwIndex;
    AMVE_POSITION_RANGE_TYPE _timeRange;
    MRECT _rcRegionRatio;
    CXiaoYingTextAnimationInfo *_pTextSource;
}
@property(readwrite, nonatomic,strong) CXiaoYingTextAnimationInfo* pTextSource;
@property(readwrite, nonatomic) AMVE_POSITION_RANGE_TYPE timeRange;
@property(readwrite, nonatomic) MRECT rcRegionRatio;
@property(readwrite, nonatomic) UInt32 dwIndex;

@end // CXiaoYingLyricData
