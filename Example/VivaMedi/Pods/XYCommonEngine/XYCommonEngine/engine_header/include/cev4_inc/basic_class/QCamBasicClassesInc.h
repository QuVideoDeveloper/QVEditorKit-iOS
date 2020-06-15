#import "QCamDubbingInfo.h"
#import "QCamEffect.h"
#import "QCamEffectUpdateItem.h"
#import "QFilterParam.h"
#import "QPIPSrc.h"
#import "QPIPSrcMode.h"
#import "QExpressionPasterStatus.h"
#import "QCamCapturePara.h"






//@interface QCamARModel : NSObject
//@property(assign, nonatomic) int modelID; //it is used to identify the model, CE will use this id to interact with app in CE's APIs
//@property(readwrite, nonatomic) NSString *modelFile; //file of model
//@end



/*!
 QCamOpResult
 @brief After you call CE performOperation, you will get the result by QCamOpResult
 */
//@interface QCamOpResult : NSObject
//@property(assign, nonatomic)    int resCode; //result code of operaton, refer to CE's API of performOperation for more info.
//@property(readwrite, nonatomic) NSObject *resData; //result data of operaton, refer to CE's API of performOperation for more info.
//@end






/*!
 @brief  QPointFloat
 */
@interface QPointFloat : NSObject
@property(assign, nonatomic) float x;
@property(assign, nonatomic) float y;
- (id)initWith : (float)x
             y : (float)y;
@end



/*!
    QAR3DSpaceParam
        used to describe the AR3D space param.
        for space position: it's x/y/z.
        for space rotation: it's corresponding to relative 3D rotation. And the rotaton bases on radian.
        for space scale: it's corresponding to relative 3D scale.
 */
@interface QAR3DSpaceParam : NSObject
@property(assign, nonatomic) float v1;
@property(assign, nonatomic) float v2;
@property(assign, nonatomic) float v3;
- (id) initWith : (float)v1
             v2 : (float)v2
             v3 : (float)v3;
@end



@interface QARModelAddParam : NSObject
@property(assign, nonatomic) int sceneID; //it is the scene ID app set for the model. It should start from 0.
@property(readwrite, nonatomic) NSString *modelFile; //model file
//关于try2Clone
//1. model文件load可能会比较耗时，
//2. try2Clone为true时: 会先在当前存在的model列表里遍历；如果这个model已经有了，则会做clone动作而非load动作；这个model当前不存在，才做load
//3. try2Clone为false时: 只做load动作
//4. 涉及到的遍历本身也有开销，如果已加入的model数量巨大，则不适合做forceClone。视具体情况权衡。
@property(assign, nonatomic) bool try2Clone;
@property(readwrite, nonatomic) QPointFloat *pt; //describe where you hope to add in the screen. The point value is normalized(0~1).
@property(assign, nonatomic) int hitType; //refre to QVCE_AR_HIT_TYPE_XXX fore more info
@end


//QARVideoFormat: used to describe the fps and frame size you want or the supported-result inquired by CE API
@interface QARVideoFormat : NSObject
@property(assign, nonatomic) int frameRate; //frameRate=30000 means 30fps
@property(assign, nonatomic) int frameWidth;
@property(assign, nonatomic) int frameHeight;

- (id) initWith : (int)frameRate
     frameWidth : (int)w
    frameheight : (int)h;
@end




typedef struct __QAR_PEN_COLOR
{
    float data[4]; //format: RGBA -- only used by QCAM_AR_PEN_TYPE_COLOR
}QAR_PEN_COLOR;
@interface  QARPenAddParam : NSObject
@property(assign, nonatomic) int penID;
@property(assign, nonatomic) int type; //QCAM_AR_PEN_TYPE_XXXX

@property(assign, nonatomic) float width; //only used by QCAM_AR_PEN_TYPE_COLOR
@property(assign, nonatomic) QAR_PEN_COLOR clr; //format: RGBA -- only used by QCAM_AR_PEN_TYPE_COLOR

@property(readwrite, nonatomic) NSString *templateFile; //only used by QCAM_AR_PEN_TYPE_TEMPLATE
@end


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





#import <UIKit/UIKit.h>
//all the parameter defined in QCamDisplayContext has the same meaning to the API of [QCamEngineV4 InitCamEngine]
@interface QCamDisplayContext : NSObject
@property(assign, nonatomic) UIDeviceOrientation DO;
@property(assign, nonatomic) MRECT viewPort;
@property(assign, nonatomic) MRECT workRect;
@property(assign, nonatomic) XYCE_PROCESS_RECT_INFO dspInfo;
@property(assign, nonatomic) MSIZE expFrameSize;
//@property(readwrite, nonatomic) CXiaoYingPIPPO *pip

-(QCamDisplayContext*)clone;
@end


//
//typedef struct _tag_qvar_plane_property{
//    MPVoid     pPlaneID;            // 平面标识(即锚点UUID)
//    MFloat      fPosition[3];         // 平面在空间中的位置 (x, y, z)
//    MFloat      fWidth;                 // 平面的宽度
//    MFloat      fHeight;                // 平面的高度
//}QVARplaneProperty;


/*
 *  QARPlaneProperty: refer to the definition of QVARplaneProperty in libqvar.hpp for more info.
 */
@interface QARPlaneProperty : NSObject
@property(assign, nonatomic) MPVoid planeID; // 平面标识(即锚点UUID) (libqvar.hpp里这个定义很奇怪！)
@property(assign, nonatomic) MFloat posX; //平面在空间中的位置 (x, y, z)
@property(assign, nonatomic) MFloat posY;
@property(assign, nonatomic) MFloat posZ;

@property(assign, nonatomic) MFloat width;   // 平面的宽度
@property(assign, nonatomic) MFloat height; // 平面的高度
@property(assign, nonatomic) MInt32 orientation; //related to QVARplaneProperty's mOrientation defined in libqvar.hpp
@end


/*
 * QARPlaneDisplayEnableParam:
 *      refer to qvarfxEnablePlaneDisplay() defined in libqvar.hpp for more info
 */
@interface QARPlaneDisplayEnableParam : NSObject
@property(readwrite, nonatomic) NSString *pic; // pPath 为自定义的平面图片路径，默认使用白色显示检测到的平面，建议在qvarfxStart之前设置
@property(assign, nonatomic) MInt32 plnDspOrientation; // QVAR_PLANE_DISPLAY_ORIENTATION_XXX defined in libqvar.hpp
@end








