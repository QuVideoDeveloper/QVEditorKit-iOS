//
//  XYAudioEffectModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/7.
//

#import "XYEffectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectAudioModel : XYEffectModel
@property (nonatomic, assign) CGFloat volumeValue;//调整音频的声音大小
@property (nonatomic, assign) BOOL isFadeInON;//是否开启淡入
@property (nonatomic, assign) BOOL isFadeOutON;//是否开启淡出
@property (nonatomic, assign) CGFloat fadeDuration;//fade的时长
@property (nonatomic, assign) BOOL isRepeatON;//是否开启循环
@property (nonatomic, assign) BOOL isMute;//是否静音  type为video时有效
@property (nonatomic, copy) NSString *lyricPath;//歌曲字幕lyric文件路径
@property (nonatomic, assign) NSInteger lyricTtid;//歌词模板的素材id


@end

NS_ASSUME_NONNULL_END
