//
//  XYSlideShowEffectMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import <Foundation/Foundation.h>

@class XYSlideShowMusicModel, XYSlideShowThemeTextInfo;

NS_ASSUME_NONNULL_BEGIN

@interface XYSlideShowEffectMgr : NSObject

///应用主题
///return 判断是否应用主题成功。返回YES则主题运用成功，NO则运用失败。
/// @param themeID 主题id
- (BOOL)applyTheme:(NSInteger)themeID;

/// 获得当前主题的id
- (NSInteger)fetchCurrentThemeId;

/// 移除当前主题
- (void)removeCurrentTheme;

/// 设置音乐
/// @param musicModel music对象
- (BOOL)applyMusicWithMusicModel:(XYSlideShowMusicModel *)musicModel;

/// 获取当前音乐信息
- (XYSlideShowMusicModel *)fetchMusic;

/// 获取默认的音乐 如主题自带的音乐
- (NSString *)fetchDefaultMusic;

/// 获取主题字幕列表
- (NSArray<XYSlideShowThemeTextInfo *> *)fetchThemeTextInfos;

/// 更新主题字幕
/// @param themeTextInfo 字幕对象
- (void)updateThemeText:(XYSlideShowThemeTextInfo *)themeTextInfo;

/// 设置静音
/// return 判断是否应用成功。返回YES则用成功，NO则运用失败。
/// @param mute YES为静音，NO则不为静音
- (BOOL)applyMute:(BOOL)mute;

/// return 判断是否是静音。返回YES则主题运用成功，NO则运用失败。
- (BOOL)fetchMute;

/// 应用混音模式 值范围 0-100 中间值50为 值越小原音越明显，值越大背景音乐越明显
/// @param persent 百分比
- (NSInteger)applyMixPercent:(SInt32)persent;

/// 获取混音模式的百分比，值范围 0-100 中间值50为 值越小原音越明显，值越大背景音乐越明显
- (NSInteger)fetchMixPersent;


@end

NS_ASSUME_NONNULL_END
