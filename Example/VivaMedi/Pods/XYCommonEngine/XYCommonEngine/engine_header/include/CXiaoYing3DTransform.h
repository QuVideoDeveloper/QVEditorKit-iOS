/*CXiaoYingTransformInfo
*
*Reference:
*
*Description: Define XiaoYing Effect  API.
*
*/

//http://wiki.xiaoying.tv/pages/viewpage.action?pageId=18658335             相关说明
@interface CXiaoYingTransformInfo : NSObject {
@public
   MFloat fScale_X;//X 方向Scale 归一化， 1.0 表示屏幕宽度， 0.5 屏幕宽度的一半
   MFloat fScale_Y;//y 方向Scale  归一化， 1.0 表示屏幕高度， 0.5 屏幕高度的一半
   MFloat fScale_Z;//Z 方向Scale
   
   MFloat fShift_X;// X 方向相对屏幕偏移多少 默认 0.5 x方向中心点，1.0 屏幕的宽度，0 屏幕的起始点
   MFloat fShift_Y;// Y 方向相对屏幕偏移多少 默认 0.5 y方向中心点，1.0 屏幕的高度，0 屏幕的起始点
   MFloat fShift_Z;// Y 方向相对屏幕偏移多少 默认 0 z方向中心点，< 0往屏幕外， > 0 往屏幕里
   
   MFloat fAngle_X;// 绕X轴的旋转角度
   MFloat fAngle_Y;// 绕Y轴的旋转角度
   MFloat fAngle_Z;// 绕Z轴的旋转角度
   
   MFloat fAnchor_X;// X的锚点
   MFloat fAnchor_Y;// Y的锚点
   MFloat fAnchor_Z;// z的锚点
   

};

- (QVET_3D_TRANSFORM)get3DTransform;
- (void)set3DTransform:(QVET_3D_TRANSFORM)transform;
@end
