/*CXiaoYingLyricData
*
*Reference:
*
*Description: Define XiaoYing Effect  API.
*
*/

@interface CXiaoYingLyricData : NSObject
{
    UInt32 _startTime;
    UInt32 _endTime;
    long _offsetTime;
    NSString *_lyricContent;
}
@property(readwrite, nonatomic,strong) NSString* lyricContent;
@property(readwrite, nonatomic) UInt32 startTime;
@property(readwrite, nonatomic) UInt32 endTime;
@property(readwrite, nonatomic) long offsetTime;

- (void)setStartTime:(UInt32)startTime
        setEndTime:(UInt32)endTime
        setOffsetTime:(long)offsetTime;
@end // CXiaoYingLyricData
