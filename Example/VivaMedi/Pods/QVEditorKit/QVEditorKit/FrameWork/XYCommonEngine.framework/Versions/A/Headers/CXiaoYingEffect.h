/*CXiaoYingEffec.h
*
*Reference:
*
*Description: Define XiaoYing Effect  API.
*
*/
//#include "amvedef.h"


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
@property(nonatomic, strong) NSArray* data; //CXiaoYingTrajectoryValue


@end


@interface CXiaoYingKeyFrameTransformValue : NSObject {

@public
	
    MDWord ts;
    MFloat rotation;
    MPOINT position;
	MFloat widthRatio;
	MFloat heightRatio;
}
@end

@interface CXiaoYingKeyFrameTransformData : NSObject {
}
@property(nonatomic, strong) NSArray* values; //CXiaoYingKeyFrameTransformValue

@end


@interface CXiaoYingKeyFrameFloatValue : NSObject {

@public
	
    MDWord ts;
    MFloat floatValue;
}
@end


@interface CXiaoYingKeyFrameFloatData : NSObject {
}
@property(nonatomic, strong) NSArray* values; //CXiaoYingKeyFrameFloatValue

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

- (MRESULT) getDisplayInfo : (MDWord)dwTimeStamp
		   DisplayInfoData : (QVET_EFFECT_DISPLAY_INFO*)pDisplayInfo;

- (MRESULT) GetExternalSource : (MDWord)dwIndex
	             ExternalSource : (QVET_EFFECT_EXTERNAL_SOURCE*)pExtSrc;
	             	
- (MRESULT) SetExternalSource : (MDWord)dwIndex
	             ExternalSource : (QVET_EFFECT_EXTERNAL_SOURCE*)pExtSrc;





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
- (MRESULT) setKeyFrameOpacityData:(CXiaoYingKeyFrameFloatData*) data;
- (MRESULT) setKeyFrameLevelData:(CXiaoYingKeyFrameFloatData*) data;

- (CXiaoYingKeyFrameTransformData*) getKeyFrameTransformData;
- (CXiaoYingKeyFrameFloatData*) getKeyFrameOpacityData;
- (CXiaoYingKeyFrameFloatData*) getKeyFrameLevelData;

- (CXiaoYingKeyFrameTransformValue*) getKeyFrameTransformValue:(MDWord)pts;


@end // CXiaoYingEffect 

