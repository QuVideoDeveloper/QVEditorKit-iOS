/*
 * CXiaoYingVirtualSourceInfoNode.h
 *
 *
 * History
 *    
 * 2016-03-30 YifeiFeng
 * - Init version
 *		
 */
//虚拟结点的image信息
 @interface CXiaoYingVirtualImageSourceInfo : NSObject
 {
     SInt32 _siFaceCenterX;
	 SInt32 _siFaceCenterY;
	 Boolean   _bFaceDetected;
 }
 @property(readwrite,nonatomic) SInt32 siFaceCenterX;
 @property(readwrite,nonatomic) SInt32 siFaceCenterY;
 @property(readwrite,nonatomic) Boolean bFaceDetected;
 @end

@interface CXiaoYingVirtualVideoSourceInfo : NSObject
{
    SInt32 _siPicCenterX;
    SInt32 _siPicCenterY;
    CXIAOYING_POSITION_RANGE_TYPE _trimRange;
	Boolean _bPlaytoEnd;
}
@property(readwrite,nonatomic) SInt32 siPicCenterX;
@property(readwrite,nonatomic) SInt32 siPicCenterY;
@property(readwrite,nonatomic) CXIAOYING_POSITION_RANGE_TYPE trimRange;
@property(readwrite,nonatomic) Boolean bPlaytoEnd;

@end
 
 @interface CXiaoYingVirtualSourceInfoNode : NSObject
 {
	 UInt32 _uiVirtualSrcIndex;
	 UInt32 _uiRealSrcIndex;
	 UInt32 _uiSourceType;
	 NSString* _pSourceFile;
	 UInt32 _uiPreviewPos;
     UInt32 _uiSceneDuration; //场景duration
     UInt32 _uiSceneIndex;
     Float32 _fAspectRatio;
     MBool  _bTransformFlag;
     CXIAOYING_TRANSFORM_PARAMETERS _TransformPara;
     CXIAOYING_RECT _Region;
	 MBool  _bApplyPanzoom;//场景虚拟节点对应是否应用panzoom的状态， true 应用，false 不应用
     MBool  _bFaceAlign;//人脸对齐标志
     MBool _bFitMethod;// false: fit-in, true: fit-out
	 id _pVirtualSourceInfo;
	 AMVE_POSITION_RANGE_TYPE _effectRange;
 }
 
 @property(readwrite,nonatomic) UInt32 uiVirtualSrcIndex;	// cqd.question.14 synthesize 与 property 各什么作用?
 @property(readwrite,nonatomic) UInt32 uiRealSrcIndex;
 @property(readwrite,nonatomic) UInt32 uiSourceType;
 @property(readwrite,nonatomic,strong) NSString* pSourceFile;
 @property(readwrite,nonatomic) UInt32 uiPreviewPos;
 @property(readwrite,nonatomic) UInt32 uiSceneDuration;
 @property(readwrite,nonatomic) UInt32 uiSceneIndex;
 @property(readwrite,nonatomic) MBool bTransformFlag;
 @property(readwrite,nonatomic) Float32 fAspectRatio;

 @property(readwrite,nonatomic) CXIAOYING_TRANSFORM_PARAMETERS TransformPara;
 @property(readwrite,nonatomic) CXIAOYING_RECT Region;
 @property(readwrite,nonatomic) MBool bApplyPanzoom;
 @property(readwrite,nonatomic) MBool bFitMethod;
 @property(readwrite,nonatomic) MBool bFaceAlign;
 @property(readwrite,nonatomic,strong) id pVirtualSourceInfo;
 @property(readwrite,nonatomic) AMVE_POSITION_RANGE_TYPE effectRange;
 @end

