//
//  XYCrabEditPlayerEngineObserver.h
//  XYVivaEditor
//
//  Created by 徐新元 on 2019/10/24.
//

#import <Foundation/Foundation.h>

@class XYPlayerView;

NS_ASSUME_NONNULL_BEGIN

@interface XYPlayerViewEngineObserver : NSObject

@property (nonatomic, weak) XYPlayerView *editorPlayerView;

/// 开始监听引擎操作
/// @param playerView 工具播放器
- (void)startObserverWithPlayerView:(XYPlayerView *)playerView;


/// 去除监听
- (void)removeObserver;

@end

NS_ASSUME_NONNULL_END
