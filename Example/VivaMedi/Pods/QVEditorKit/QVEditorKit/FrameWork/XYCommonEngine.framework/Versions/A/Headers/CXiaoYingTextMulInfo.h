/*CXiaoYingTextMulInfo
*
*Reference:
*
*Description: Define XiaoYing Effect  API.
*
*/

@interface CXiaoYingTextMulInfo : NSObject
{
    AMVE_MUL_BUBBLETEXT_INFO mulBTInfo;
}

@property(readwrite, nonatomic) AMVE_MUL_BUBBLETEXT_INFO mulBTInfo;

- (AMVE_MUL_BUBBLETEXT_INFO *)getMulInfo;

- (MVoid)setMulInfo:(AMVE_MUL_BUBBLETEXT_INFO *)pMulInfo;
@end // CXiaoYingLyricData
