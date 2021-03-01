//
//  XYAudioEffectModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/7.
//

/*
 iTunes 路径例子 ipod-library://item/item.mp3?id=352343695305987142
 */

#import "XYEffectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectAudioModel : XYEffectModel
/// 调整音频的声音大小 值范围 0 - 200
@property (nonatomic, assign) CGFloat volumeValue;

/// 是否开启淡入
@property (nonatomic, assign) BOOL isFadeInON;

/// 是否开启淡出
@property (nonatomic, assign) BOOL isFadeOutON;

/// fade的时长
@property (nonatomic, assign) CGFloat fadeDuration;

/// 是否开启循环
@property (nonatomic, assign) BOOL isRepeatON;

/// 是否静音  type为video时有效
@property (nonatomic, assign) BOOL isMute;

/// 歌曲字幕lyric文件路径
@property (nonatomic, copy) NSString *lyricPath;

/// 歌词模板的素材id
@property (nonatomic, assign) NSInteger lyricTtid;
///变声值
@property (nonatomic, assign) CGFloat pitchValue;


@end

NS_ASSUME_NONNULL_END
