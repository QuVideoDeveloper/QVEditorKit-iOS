#if defined(__APPLE__)
#import <Foundation/Foundation.h>
#import <SceneKit/SceneKit.h>

typedef void(^QVARAddModelCompletion)(NSObject* model, BOOL isCompletion);

@interface QVAR3DSceneManager: NSObject

+ (instancetype)shareInstance;
/**
 点击命中测试

 @param pt 点击位置（归一化）
 @return 距屏幕最近的3D模型
 */
- (NSObject*)hitTest:(CGPoint)pt;

/**
 获取模型关联的音频数量

 @param pScene 选中的模型，设nil时目标模型为最近选中操作或添加的模型
 @return 音频数量
 */
- (NSInteger)audioCountIn3DScene:(NSObject *)pScene;

/**
 设置模型音频属性

 @param pScene 选中模型，设nil时目标模型为最近选中操作或添加的模型
 @param index 关联音频序号（序号范围上限 audioCountIn3DScene:(NSObject *)pScene 返回的数值大小）
 @param volume 音量大小，设0为静音
 @param isLoops 循环播放，true：循环播放；false：播放一次
 @param isPositional 空间音效，true：有空间音效；false：无空间音效
 */
-(void)setAudioVolumeIn3DScene:(NSObject*)pScene AudioIndex:(NSInteger)index Volume:(CGFloat)volume;
-(void)setAudioLoopIn3DScene:(NSObject*)pScene AudioIndex:(NSInteger)index Loops:(BOOL)isLoops;
-(void)setAudioPositionalIn3DScene:(NSObject*)pScene AudioIndex:(NSInteger)index Positional:(BOOL)isPositional;

/**
 获取模型音频属性

 @param pScene 选中模型，设nil时目标模型为最近选中操作或添加的模型
 @param index 关联模型序号（序号范围上限 audioCountIn3DScene:(NSObject *)pScene 返回的数值大小）
 @return 相应的属性值（音量，循环播放和空间音效）
 */
-(CGFloat)getAudioVolumeIn3DScene:(NSObject *)pScene AudioIndex:(NSInteger)index;
-(BOOL)isLoopAudioIn3DScene:(NSObject *)pScene AudioIndex:(NSInteger)index;
-(BOOL)isPositionalAudioIn3DScene:(NSObject *)pScene AudioIndex:(NSInteger)index;

/**
 模型拖动
 moveBegin: 移动开始阶段，根据输入屏幕坐标选中模型
 moving：移动阶段，跟随屏幕坐标对应3D空间位置进行移动
 moveEnd：移动结束阶段，释放选中模型

 @param pPoint 屏幕坐标
 */
-(void)moveBegin:(CGPoint)pPoint;
-(void)moving:(CGPoint)pPoint;
-(void)moveEnd;
/**
 设置模型属性（大小比列，空间位置，旋转角度）

 @param pScene 选中模型，设nil时目标模型为最近选中操作或添加的模型
 @param scale 属性参数
 */
-(void)set3DScene:(NSObject *)pScene Scale: (SCNVector3)scale;
-(void)set3DScene:(NSObject *)pScene Position: (SCNVector3)position;
-(void)set3DScene:(NSObject *)pScene Rotation: (SCNVector3)rotation;
/**
 获取模型属性（大小比列，空间位置，旋转角度）

 @param pScene 选中模型，设nil时目标模型为最近选中操作或添加的模型
 @return 相应属性参数
 */
-(SCNVector3)get3DSceneScale:(NSObject *)pScene;
-(SCNVector3)get3DScenePosition:(NSObject *)pScene;
-(SCNVector3)get3DSceneRotation:(NSObject *)pScene;
/**
 设置操作单个模型还是整个模版

 @param asChild 设true表示以模型为单位，独立进行移动，缩放等操作
                             设false表示以模版为单位，对所有添加的模型进行移动，缩放等操作
 */
- (void)treat3DSceneAsChild:(BOOL)asChild;


/**
 模型添加完成状态回调

 @param completion 模型句柄，添加完成状态
 */
- (void)addARModelCompletion:(QVARAddModelCompletion)completion;


/**
 添加模型至特定位置

 @param point 点击位置
 */
-(void)attach3DSceneAtPoint:(CGPoint)point;

@end
#endif
