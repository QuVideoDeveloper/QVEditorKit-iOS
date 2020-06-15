//
//  XYStoryboardModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import "XYBaseEngineModel.h"

@class XYStoryboard;
@class XYClipModel;
@class TextInfo;
NS_ASSUME_NONNULL_BEGIN

@interface XYStoryboardModel : XYBaseEngineModel

@property (nonatomic, copy) NSArray <TextInfo *> *themeTextList;//主题字幕list
@property (nonatomic, copy) NSString *themePath;//主题素材路径
@property (nonatomic, copy) NSArray *themeMusicPathList;//主题音乐路径
@property(nonatomic, assign, readonly) NSInteger themeID;//主题id
@property(nonatomic, assign) CGFloat ratioValue;
@property(nonatomic, assign) BOOL isPhotoMV;
@property(nonatomic, assign) CGSize outPutResolution;//分辨率
@property(nonatomic, assign) BOOL isPropRatioSelected;//是否设置了比例 如原比例为NO 非原比例 YES
@property(nonatomic, assign) NSInteger videoDuration;//视频总时长

- (void)reload;
- (void)reloadThemeID;
@end

NS_ASSUME_NONNULL_END
