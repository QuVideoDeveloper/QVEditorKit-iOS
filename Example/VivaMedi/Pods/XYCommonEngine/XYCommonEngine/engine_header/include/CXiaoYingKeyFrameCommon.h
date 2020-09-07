/*CXiaoYing3DTransformInfo
*
*Reference:
*
*Description: Define XiaoYing Effect  API.
*
*/

@interface CXiaoYingKeyFrameCommonValue : NSObject {

@public
	MDWord method;
    MFloat ts;
    MFloat value;
	MFloat fOffetValue; // 基于 value的偏移量
	//类型选择 KEYFRAME_TRANSFORM_COMMON_OFFSET_TYPE_PLUS 或者 KEYFRAME_TRANSFORM_COMMON_OFFSET_TYPE_MUL
	MDWord dwOffsetOpcodeType;//决定了 BaseValue 与 value的之前的操作关系

	MInt64 lKeylineTemplateID;
	QVET_KEYFRAME_TRANSFORM_FLOAT_EXTINFO extInfo;
	QVET_KEYFRAME_EASINGINFO easingInfo;
}
- (QVET_KEYFRAME_COMMON_VALUE)getKeyFrameCommonValue;
- (void)setKeyFrameCommonValue:(QVET_KEYFRAME_COMMON_VALUE)transform;

@end

@interface CXiaoYingKeyFrameCommonData : NSObject {

@public
	//3D transform 相关 EU_KEYFRAME_3D_TRANSFORM_TYPE 选择这个类型
	MLong lKeyValue;
//CXiaoYingKeyFrameCommonValue
}
@property(nonatomic, strong) NSArray* values;
- (QVET_KEYFRAME_COMMON_DATA)getKeyFrameCommonData;
- (void)setKeyFrameCommonData:(QVET_KEYFRAME_COMMON_DATA)transformData;

@end


