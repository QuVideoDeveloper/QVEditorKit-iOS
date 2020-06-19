//
//  XYBaseEngineModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/12.
//

#import "XYEngineEnum.h"
#import "XYCommonEngineGlobalData.h"
#import "XYBaseCopyModel.h"

typedef NS_ENUM(NSInteger, XYEngineModelType) {
    XYEngineModelTypeClip,
    XYEngineModelTypeAudio,
    XYEngineModelTypeVision,
    XYEngineModelTypeVisionText,
};

inline static bool XYIsFloatZero(float value)
{
    return fabsf(value) <= 0.00001f;
}

@class XYStoryboard, XYVeRangeModel, XYEngineUndoManagerConfig;

NS_ASSUME_NONNULL_BEGIN

@interface XYEngineConfigModel : XYBaseCopyModel
@property (nonatomic, weak) XYStoryboard *storyboard;
@property (nonatomic, assign) XYCommonEngineTrackType trackType;
@property (nonatomic, assign) XYCommonEngineGroupID groupID;
@property (nonatomic) NSInteger idx;
@property (nonatomic, assign) XYCommonEngineClipModuleType clipType;
@property (nonatomic, copy) NSString *identifier;//clip 的唯一标识符


@end

@interface XYBaseEngineModel : XYBaseCopyModel
@property (nonatomic, copy) NSDictionary *userInfo;//用户自带的信息
@property (nonatomic, strong) XYVeRangeModel *trimVeRange;
@property (nonatomic, strong) XYVeRangeModel *destVeRange;//如果加了有cover的主题，clipindex是包括cover的，例如：封面index是0，第一个clip的index就是1
@property (nonatomic, strong) XYVeRangeModel *sourceVeRange;
@property (nonatomic, assign) BOOL fatchWhenTaskisExcusing;
@property (nonatomic, copy) NSString *identifier;//唯一标识符
@property (nonatomic, assign) XYCommonEngineTaskID taskID;
@property (nonatomic, assign) XYCommonEngineGroupID groupID;
@property (nonatomic, assign) XYEngineModelType engineModelType;
@property (nonatomic, assign) XYEngineUndoActionState undoActionState;//clip runMore 只能配第一个配置一下这个
@property (nonatomic, strong) XYEngineUndoManagerConfig *undoConfigModel;//undo redo 配置model
@property (nonatomic, weak) XYStoryboard *storyboard;
@property (nonatomic, assign) BOOL isTempWorkspace;//是否是临时工作站
@property (nonatomic, strong) NSNumber *seekPositionNumber;//可选 不传默认seek到当前
@property (nonatomic, assign) BOOL isAutoplay;//是否自动播放
@property (nonatomic, assign) BOOL skipReloadTimeline;//跳过刷新timeline 业务控制

- (instancetype)init:(XYEngineConfigModel *)config;

@end

NS_ASSUME_NONNULL_END
