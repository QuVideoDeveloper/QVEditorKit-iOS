//
//  XYBaseEffectTask.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYBaseEngineTask.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYEffect.h"
#import "XYStoryboard+XYClip.h"
#import "XYEngineEnum.h"
#import "XYEffectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBaseEffectTask : XYBaseEngineTask
@property (nonatomic, assign) BOOL isReloadAllEffect;
@property (nonatomic, assign) BOOL isReload;//根据 trackType groupId 刷新对应的memory的数据
@property (nonatomic, strong) XYEffectModel *effectModel;
@property (nonatomic, copy) NSArray <XYEffectModel *> *effectModels;
@property (nonatomic, assign) XYCommonEngineTrackType trackType;
@property (nonatomic, assign) XYCommonEngineGroupID groupID;
@property (nonatomic, assign) CGFloat layerID;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) NSInteger indexInStoryboard;
@property (nonatomic, assign) NSInteger trimPos;
@property (nonatomic, assign) NSInteger trimLen;
@property (nonatomic, assign) NSInteger destPos;
@property (nonatomic, assign) NSInteger destLen;
@property (nonatomic, assign) NSInteger repeatMode;
@property (nonatomic, assign) NSInteger duplicateStartPos;//复制效果的起始点
@property (nonatomic, copy) NSString *title;//如音乐的名称

@end

NS_ASSUME_NONNULL_END
