/*
 * CXiaoYingSourceInfoNode.h
 *
 *
 * History
 *    
 * 2016-03-30 YifeiFeng
 * - Init version
 *		
 */

@interface CXiaoYingImageSourceInfo : NSObject
{
    SInt32 _siFaceCenterX;
	SInt32 _siFaceCenterY;
	Boolean   _bFaceDetected;
    SInt32  _siFaceCount; //检测到的人脸数量
    MPOINT* _FeaturePoint; //人脸特征点信息
}

@property(readwrite, nonatomic) SInt32 siFaceCenterX;
@property(readwrite, nonatomic) SInt32 siFaceCenterY;
@property(readwrite, nonatomic) Boolean bFaceDetected;
@property(readwrite, nonatomic) SInt32 siFaceCount;
@property(readwrite, nonatomic) MPOINT* FeaturePoint;
@end

@interface CXiaoYingVideoSourceInfo : NSObject
{
    CXIAOYING_POSITION_RANGE_TYPE _srcRange;
}
@property(readwrite, nonatomic) CXIAOYING_POSITION_RANGE_TYPE srcRange;
@end

@interface CXiaoYingSourceInfoNode : NSObject
{
    UInt32 _uiSourceType;
	NSString* _pstrSourceFile;
	UInt32 _uiRotation;
	id _pSourceInfo;             // 根据source type决定,image source 对应CXiaoYingImageSourceInfo对象
	                           //video source对应CXiaoYingVideoSourceInfo对象
}

@property (readwrite, nonatomic) UInt32 uiSourceType;
@property (readwrite, nonatomic,strong) NSString* pstrSourceFile;
@property (readwrite, nonatomic) UInt32 uiRotation;
@property (readwrite, nonatomic,strong) id pSourceInfo;

@end
