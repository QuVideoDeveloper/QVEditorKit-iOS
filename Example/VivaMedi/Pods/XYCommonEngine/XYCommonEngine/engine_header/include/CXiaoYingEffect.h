/*CXiaoYingEffec.h
*
*Reference:
*
*Description: Define XiaoYing Effect  API.
*
*/
@interface CXiaoYingPipStoryboardInfo : NSObject {
@public
    NSString *pProjectPath; //CXiaoYingKeyFrameTransformValue
}


@end


@interface CXiaoYingTrajectoryValue : NSObject {

@public
	//QVET_TRAJECTORY_VALUE value;
    MDWord ts;
    MFloat rotation;
    MRECT region;
}
@end



@interface CXiaoYingTrajectoryData : NSObject {

@public
	BOOL useTimePos;
}
//@property(nonatomic) BOOL useTimePos;
@property(nonatomic, strong) NSArray* data; //CXiaoYingTrajectoryDataValue


@end




@interface CXiaoYingKeyFrameTransformValue : NSObject {

@public
	MDWord method;
    MDWord ts;
    MFloat rotation;
    MPOINT position;
	MFloat widthRatio;
	MFloat heightRatio;
	QVET_KEYFRAME_TRANSFORM_EXTINFO extInfo;
}
@end

@interface CXiaoYingKeyFrameTransformData : NSObject {
}
@property(nonatomic, strong) NSArray* values; //CXiaoYingKeyFrameTransformValue

@end



@interface CXiaoYingKeyFrameTransformPosValue : NSObject {

@public
	MDWord method;
    MDWord ts;
    MPOINT position;
	QVET_KEYFRAME_TRANSFORM_EXTINFO extInfo;
	QVET_KEYFRAME_EASINGINFO easingInfo;

}
@end

@interface CXiaoYingKeyFrameTransformPosData : NSObject {
}
@property(nonatomic, strong) NSArray* values; //CXiaoYingKeyFrameTransformPosValue
@property(nonatomic) MPOINT basePos;
@end


@interface CXiaoYingKeyFrameTransformRotationValue : NSObject {

@public
	MDWord method;
    MDWord ts;
    MFloat rotation;
    QVET_KEYFRAME_EASINGINFO easingInfo;
}
@end

@interface CXiaoYingKeyFrameTransformRotationData : NSObject {
}
@property(nonatomic, strong) NSArray* values; //CXiaoYingKeyFrameTransformRotationValue
@property(nonatomic) MFloat baseRotation;
@end



@interface CXiaoYingKeyFrameTransformScaleValue : NSObject {

@public
	MDWord method;
    MDWord ts;
	MFloat widthRatio;
	MFloat heightRatio;
	QVET_KEYFRAME_EASINGINFO easingInfo;
}
@end

@interface CXiaoYingKeyFrameTransformScaleData : NSObject {
}
@property(nonatomic, strong) NSArray* values; //CXiaoYingKeyFrameTransformScaleValue
@property(nonatomic) MFloat baseWidthRatio;
@property(nonatomic) MFloat baseHeightRatio;


@end



@interface CXiaoYingKeyFrameFloatValue : NSObject {

@public
	MDWord method;
    MDWord ts;
    MFloat floatValue;
	QVET_KEYFRAME_EASINGINFO easingInfo;
}
@end


@interface CXiaoYingKeyFrameFloatData : NSObject {
}
@property(nonatomic, strong) NSArray* values; //CXiaoYingKeyFrameFloatValue
@property(nonatomic) MFloat baseValue;

@end


@interface CXiaoYingKeyFrameUniformValue : NSObject {

@public
//#define METHOD_KEYFRAME_TYPE_LINEAR_INTER 1  //普通线性插值
//#define METHOD_KEYFRAME_TYPE_KEY_LINEAR	2  //在线条上进行线性插值，需要模板
//#define METHOD_KEYFRAME_TYPE_BEZIER_INTER	3  //bezier curve interpolation
	MDWord method;
    MDWord ts;
    MInt64 llKeyLineId;// method == 2 此值必须要设置
    MFloat floatValue;// 值
    MFloat fOffsetValue;//整体关键帧的偏移
    QVET_KEYFRAME_TRANSFORM_FLOAT_EXTINFO extInfo;//method==3 时，这个值是引擎用来储存贝塞尔曲线的信息的
    QVET_KEYFRAME_EASINGINFO easingInfo;//缓动曲线配置
}
@end


@interface CXiaoYingKeyFrameUniformData : NSObject {
}
@property(nonatomic, strong) NSArray* values; //CXiaoYingKeyFrameUniformValue
@property(nonatomic, copy) NSString* name; //uniform name
@end




@interface CXiaoYingKeyFrameMaskValue : NSObject {

@public
	MDWord method;
	MDWord ts;
	MDWord reversed;
	MPOINT center;
	MDWord radiusX;
	MDWord radiusY;
	MFloat rotation; 
	MDWord softness;
}
@end





@interface CXiaoYingKeyFrameMaskData : NSObject {
}
@property(nonatomic, strong) NSArray* values; //CXiaoYingKeyFrameMaskValue

@end


@interface CXiaoYingPoint : NSObject {
@public
	MDWord x;
	MDWord y;
}
@end

@interface CXiaoYingKeyFrameColorCurveValue : NSObject {

@public
	
	MDWord ts;
	NSArray<CXiaoYingPoint*>* rgbPoints;
	NSArray<CXiaoYingPoint*>* redPoints;
	NSArray<CXiaoYingPoint*>* greenPoints;
	NSArray<CXiaoYingPoint*>* bluePoints;

}

@end



@interface CXiaoYingKeyFrameColorCurveData : NSObject {
}
@property(nonatomic, strong) NSArray* values; //CXiaoYingKeyFrameColorCurveValue
@end


@interface CXiaoYingKeyFrameColorCurveOutValue : NSObject {

@public
	
	NSArray<NSNumber*>* redValues;
	NSArray<NSNumber*>* greenValues;
	NSArray<NSNumber*>* blueValues;

}

@end





@interface CXiaoYingEffect : NSObject
{
		
}
@property (readwrite, nonatomic) MHandle hEffect;
@property (readwrite, nonatomic) MBool bEffectNeedDestroy;
/**
	 * Creates a effect.
	 * 
	 * @param pEngine A instance of CXiaoYingEngine
	 * @param dwType Type of the effect.
	 * @param dwTrackType Track type of the effect.
	 * @param dwGroupID Group id of effect.
	 * @param fLayerID Layer id of effect.
	 * @return MERR_NONE if the operation is successful, other value if failed.
*/

- (MRESULT) Create : (CXiaoYingEngine*) pEngine
	                  EffectType : (MDWord) dwType
	                  TrackType : (MDWord) dwTrackType
	                  GroupID : (MDWord) dwGroupID
	                  LayerID : (MFloat) fLayerID;

/**
 * Destroys the effect.
 * 
 * @return MERR_NONE if the operation is successful, other value if failed.
 */
 

- (MRESULT) Destory;

/**
	 * Sets property of effect.
	 * 
	 * @param dwPropertyID property id.
	 * @param pValue data of the property.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) setProperty : (MDWord) dwPropertyID
	                       PropertyData : (MVoid*)pValue;
/**
	 * Gets property of effect.
	 * 
	 * @param dwPropertyID property id.
	 * @param pValue data of the property.
	 * 
	 * @return MERR_NONE if the operation is successful, other value if failed.
 */

- (MRESULT) getProperty : (MDWord) dwPropertyID
						   PropertyData : (MVoid*)pValue;

- (CXiaoYingEffect*) duplicate;

- (MRESULT) getDisplayInfo : (MDWord)dwTimeStamp
		   DisplayInfoData : (QVET_EFFECT_DISPLAY_INFO*)pDisplayInfo;

- (MRESULT) GetExternalSource : (MDWord)dwIndex
	             ExternalSource : (QVET_EFFECT_EXTERNAL_SOURCE*)pExtSrc;
	             	
- (MRESULT) SetExternalSource : (MDWord)dwIndex
	             ExternalSource : (QVET_EFFECT_EXTERNAL_SOURCE*)pExtSrc;


- (NSMutableArray *) GetLyricContent;

- (MRESULT) SetLyricContent:(NSMutableArray *) nsLyricContent;

- (NSMutableArray *) GetLyricTextInfo;

- (MRESULT) SetLyricTextInfo:(NSMutableArray *) nsLyricTextInfoArray;



/*
 * For multi-trajectory of effect
 *
 * Trajectory: you can insert many trajectories to the effect.
 * For example: when you draw a line, your pen moves as a trajectory. And trajectory is characterised by timestamp, position(coordinates), self-rotation——That's Trajectory-Data
 * For example: If you wanna draw 3 line, so every line is corresponding to one trajectory. Then you need to
 *              insert 3 new Trajectories with corresponding trajecgtory-data to CXiaoYingEffect
 *              and you can modify(update) the trajectory with the trajectory-data you want, or remove it.
 * For app convenience: you can use AMVE_EFFECT_TRAJECTORY_IDX_HEAD/AMVE_EFFECT_TRAJECTORY_IDX_TAIL defined in headfile to identify the first and the last trajectory.
 */
- (MDWord) getTrajectoryCount;
- (CXiaoYingTrajectoryData*) getTrajectory : (MDWord) trIdx;

- (MRESULT) insertNewTrajectory : (MDWord) trIdx
                         trData : (QVET_TRAJECTORY_DATA*)trData;
- (MRESULT)updateTrajectory : (MDWord) trIdx
                     trData : (QVET_TRAJECTORY_DATA*)trData;
- (MRESULT)removeTrajectory : (MDWord)trIdx;
- (MRESULT)removeAllTrajectory;



/*
 *
 *
 * KeyFrame-effect interfaces
 *
 *
 */


- (MRESULT) setKeyFrameTransformData:(CXiaoYingKeyFrameTransformData*) data;
- (MRESULT) setKeyFrameTransformPosData:(CXiaoYingKeyFrameTransformPosData*) data;
- (MRESULT) setKeyFrameTransformRotationData:(CXiaoYingKeyFrameTransformRotationData*) data;
- (MRESULT) setKeyFrameTransformScaleData:(CXiaoYingKeyFrameTransformScaleData*) data;



- (MRESULT) setKeyFrameOpacityData:(CXiaoYingKeyFrameFloatData*) data;
- (MRESULT) setKeyFrameLevelData:(CXiaoYingKeyFrameFloatData*) data;
- (MRESULT) setKeyFrameMaskData:(CXiaoYingKeyFrameMaskData*) data;
- (MRESULT) setKeyFrameUniformData:(CXiaoYingKeyFrameUniformData*) data;
- (MRESULT) setKeyFrameColorCurveData:(CXiaoYingKeyFrameColorCurveData*) data;



- (CXiaoYingKeyFrameTransformData*) getKeyFrameTransformData;
- (CXiaoYingKeyFrameTransformPosData*) getKeyFrameTransformPosData;
- (CXiaoYingKeyFrameTransformRotationData*) getKeyFrameTransformRotationData;
- (CXiaoYingKeyFrameTransformScaleData*) getKeyFrameTransformScaleData;

- (CXiaoYingKeyFrameFloatData*) getKeyFrameOpacityData;
- (CXiaoYingKeyFrameFloatData*) getKeyFrameLevelData;
- (CXiaoYingKeyFrameMaskData*) getKeyFrameMaskData;
- (CXiaoYingKeyFrameUniformData*) getKeyFrameUniformData:(NSString *)pName;
- (CXiaoYingKeyFrameColorCurveData*) getKeyFrameColorCurveData;



- (CXiaoYingKeyFrameTransformValue*) getKeyFrameTransformValue:(MDWord)pts;
- (CXiaoYingKeyFrameMaskValue*) getKeyFrameMaskValue:(MDWord)pts;
- (CXiaoYingKeyFrameUniformValue*) getKeyFrameUniformValue:(MDWord)pts withUniform:(NSString*)name;
- (CXiaoYingKeyFrameColorCurveOutValue*) getKeyFrameColorCurveValue:(MDWord)pts;
- (CXiaoYingKeyFrameFloatValue*) getKeyFrameLevelValue:(MDWord)pts;
+ (CXiaoYingKeyFrameTransformPosValue *)getCurrentValueForKeyframeTransformPos:(CXiaoYingKeyFrameTransformPosData*)data timestamp:(MLong)ts;


- (MRESULT) setSubItemSource:(CXiaoYingEffectSubItemSource *)pSubSource;


- (CXiaoYingEffectSubItemSource *) getSubItemSource:(UInt32)dwEffctSubType;

- (CXiaoYingEffect *) getSubItemSourceEffect:(UInt32)dwEffctSubType;

- (MRESULT ) destorySubItemSourceEffect:(UInt32)dwEffctSubType;

- (NSMutableArray *) getSubItemSourceList;

- (NSMutableArray *) getSubItemSourceList:(UInt32)dwEffctSubTypeMin Max:(UInt32)dwEffctSubTypeMax;

- (MRESULT)setEffectHandle:(MHandle)hEffect;

- (MHandle)getEffectHandle;

- (void)DestorySubItemSourceList;

- (CXiaoYingPipStoryboardInfo *) getPipStoryboardInfo;

- (MRESULT) setPipStoryboardInfo:(CXiaoYingPipStoryboardInfo *)poStoryboardInfo;

//设置 3D transform信息
- (MRESULT) setTransform3dInfo:(CXiaoYingTransformInfo *)pTransformInfo;
// 获取3D transform 信息
- (CXiaoYingTransformInfo *) getTransform3dInfo;
//获取含有关键帧对应的时间的3D transform
- (CXiaoYingTransformInfo *) getKeyFrameTransform3DValue:(MLong)lTimeStamp;
//更新key 对应的base value
- (MRESULT)updateKeyFrameCommonBaseValue:(MLong)lKey withOffsetValue:(MFloat)fOffsetValue;
//插入或者替换value，具体根据ts时间，关键帧如果没有ts对应value，插入，否则替换
- (MRESULT)insertOrReplaceKeyFrameCommonValue:(MLong)lKey withValue:(CXiaoYingKeyFrameCommonValue *)pValue;
//删除关键帧
- (MRESULT)removeKeyFrameCommonValue:(MLong)lKey timeStamp:(MLong)lTimeStamp;
//获取data下边的关键帧的数据
+ (CXiaoYingKeyFrameCommonValue *)getCurrentValueForKeyFrameCommonValue:(CXiaoYingKeyFrameCommonData*)pData timeStamp:(MLong)lTimeStamp;
//获取common data 关键帧数据
- (MRESULT) setKeyFrameCommonData:(CXiaoYingKeyFrameCommonData *)pData;
//获取data的key 关键帧数据
- (CXiaoYingKeyFrameCommonData *) getKeyFrameCommonData:(MLong)lKey;
//获取key frame datalist数据
- (NSArray *) getKeyFrameCommonDataList;
- (QVET_KEYFRAME_TRANSFORM_POS_DATA ) ocKeyframePosToCFramePos:(CXiaoYingKeyFrameTransformPosData*) src;

- (QVET_KEYFRAME_TRANSFORM_ROTATION_DATA ) ocKeyframeRotationToCFrameRotation:(CXiaoYingKeyFrameTransformRotationData*) src;
- (QVET_KEYFRAME_TRANSFORM_SCALE_DATA ) ocKeyframeScaleToCFrameScale:(CXiaoYingKeyFrameTransformScaleData*) src;

@end // CXiaoYingEffect 

