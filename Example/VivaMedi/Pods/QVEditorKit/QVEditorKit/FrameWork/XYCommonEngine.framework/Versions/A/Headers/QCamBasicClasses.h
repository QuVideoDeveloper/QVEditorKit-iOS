#import "QCamDubbingInfo.h"
#import "QCamEffect.h"
#import "QCamEffectUpdateItem.h"
#import "QFilterParam.h"
#import "QPIPSrc.h"
#import "QPIPSrcMode.h"
#import "QExpressionPasterStatus.h"
#import "QCamCapturePara.h"




//QTrajectoryData:
//  For example: when you draw a line, your pen moves as a trajectory. And trajectory is characterised by timestamp, position(coordinates), self-rotation——That's Trajectory-Data
//make sure all the member-list has the same of element-count !!!!!!
@interface QTrajectoryData : NSObject
@property(assign, nonatomic) int updateMode; //QVET_TRAJECTORY_UPDATE_MODE_XXX defined in amvedef.h
@property(assign, nonatomic) bool useTimePos; //for CE, always let it to be false; it's related to the member-variable "ts" below.
@property(readwrite, nonatomic) NSArray* ts; //timestamp list, the element is NSNumber(int); if useTimePos=false, ts.count can be 0, otherwise there will be error.
@property(readwrite, nonatomic) NSArray* rotation; //rotation list, the element is NSNumber(float), such as 45.0, 90.0, 100.0; rotation's count should be same to region's count
//region list, the element is QRect*, whose value bases on 1/10000. For example: left = 5000, top=5000 ----is the center of the background
//对于只有点概念的对象，只需确保region的中心与实际点一致即可，region的大小不重要
@property(readwrite, nonatomic) NSArray* region;
- (QTrajectoryData*)clone;
@end







#define QCAM_TRAJECTORY_IDX_HEAD    0
#define QCAM_TRAJECTORY_IDX_TAIL    (-1)
/*
 * QTrajectory: you can insert many trajectory to the effect.
 * For example: when you draw a line, your pen moves as a trajectory. And trajectory is characterised by timestamp, position(coordinates), self-rotation——That's Trajectory-Data
 * For example: If you wanna draw 3 line, so every line is corresponding to one trajectory. Then you need to
 *            insert 3 QTrajectories with 3-different-index to the QCamEffect by CE-API。
 *            Every trajectory consist of different QTrajectoryData
 */
@interface QTrajectory : NSObject
@property(assign, nonatomic) int idx; //trajectory indx, For app convenience: you can use QCAM_TRAJECTORY_IDX_XXX to identify the first and the last trajectory.
@property(readwrite, nonatomic) QTrajectoryData *trData;
- (QTrajectory*)clone;
@end


