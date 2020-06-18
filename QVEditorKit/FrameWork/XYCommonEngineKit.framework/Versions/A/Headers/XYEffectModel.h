//
//  XYEffectModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import "XYBaseEngineModel.h"
#import "XYVeRangeModel.h"
#import "XYRectModel.h"
#import "TextInfo.h"//
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@class XYStoryboard;
@class XYEffectRelativeClipInfo;

@interface XYEffectUserDataModel : NSObject <YYModel>
@property (nonatomic, assign) CGFloat originWidth; //原始宽度
@property (nonatomic, assign) CGFloat originHeight; //原始高度
@property (nonatomic, assign) CGFloat defaultWidth;//视觉效果默认宽度
@property (nonatomic, assign) CGFloat defaultHeight;//视觉效果默认高度
@property (nonatomic, assign) NSInteger previewDuration;//视觉效果的预览时长
@property (nonatomic, copy) NSString *thumbnailUrl;//视觉效果缩略图的路径
@property (nonatomic, assign) BOOL isEmptyTextByUser;// 用户设置字幕文本为空
@property (nonatomic, assign) CGFloat defaultCenterX; // 默认位置的X坐标点
@property (nonatomic, assign) CGFloat defaultCenterY; // 默认位置的Y坐标点
@property (nonatomic, assign) BOOL isPIPVideo;//是否是视频画中画

@property (nonatomic, assign) BOOL isUserActionFromGesture;// 是否是来源用户的手势

@property (nonatomic, strong) NSDictionary *extendParams; // 扩展参数

@property (nonatomic, strong) XYEffectRelativeClipInfo *relativeClipInfo;//相对clip上的range 起始点在哪个clip就相对哪个clip

@end

@interface XYEffectModel : XYBaseEngineModel

@property (readonly, nonatomic, assign) XYCommonEngineTrackType trackType;
@property (readonly, nonatomic, assign) CGFloat layerID;//效果的层级信息，是一个浮点数，数字越大 层级越高；
@property (nonatomic, assign) NSInteger horizontalPosition;//在timeline 上第几行
@property (nonatomic, strong) NSMutableArray *everyCellMaxLayerIdList;//每行最大的laerid 根据index 递增
@property (readonly, nonatomic, assign) NSInteger indexInStoryboard;
@property (nonatomic, assign) CGFloat  voiceChangeValue;//变声值
@property (nonatomic, assign) BOOL isInvalid;//是否失效的
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) NSInteger templateID;
@property (nonatomic, copy) NSString *title;//如音乐的名称
@property (nonatomic, assign) NSInteger duplicateStartPos;//复制效果的起始点


@property (nonatomic, strong) XYEffectModel *duplicateEffectModel;

@property (nonatomic, strong) XYEffectRelativeClipInfo *relativeClipInfo;//相对clip上的range 起始点在哪个clip就相对哪个clip

@property (nonatomic, strong) CXiaoYingEffect *pEffect;//引擎对象
@property (nonatomic, strong) CXiaoYingClip *pClip;//引擎对象

@property (nonatomic, strong) XYEffectUserDataModel *userDataModel;//用于存储自定义信息
@property (nonatomic, assign) BOOL isAddedByTheme;//效果是否来自于 主题
@property (nonatomic, assign) BOOL isEqualStoryboardDuration;//跟整个视频总时长一样长


- (void)reload;
- (void)reloadLayerId;
- (NSInteger)fetchLayerIdCellIndex;//根据layerid 获取转化后的index 从0 开始
- (void)updateRelativeClipInfo;//刷新相对clip的数据 添加 手动修改mDestVeRange都需要刷新下
- (void)adjustEffect;//clip造成effct的重新计算  delete 或者 被修改mDestVeRange
- (void)updateIndexInStoryboard:(NSInteger)indexInStoryboard;

@end

NS_ASSUME_NONNULL_END
