//
//  XYPlayerView.h
//  XYPlayerView
//
//  Created by 徐新元 on 09/01/2018.
//

#import <UIKit/UIKit.h>


@class XYVeRangeModel, XYPlayerViewConfiguration, XYPlayerCallBackData;

//播放器Delegate
@protocol XYPlayerViewDelegate <NSObject>

@optional

/// 播放器回调
/// @param playbackData 播放放回的值
- (void)playbackStateCallBack:(XYPlayerCallBackData *)playbackData;


@end

@interface XYPlayerView : UIView
@property (nonatomic, assign) CGSize streamSize;//播放器中引擎内容真正渲染的区域，引擎的坐标都相对于这个区域来计算，这个区域的位置是相对于XYPlayerView的位置居中的，如计算区域手势可通过这里转换得到
@property (nonatomic, assign, getter=isDisablePlayAndSeek) BOOL disablePlayAndSeek;//禁止手动播放和Seek操作
@property (strong, nonatomic) XYPlayerViewConfiguration *playerConfig;//当前播放器的播放源Config

/// 注册Delegate
/// @param delegate observer
- (void)addPlayDelegate:(id <XYPlayerViewDelegate>)delegate;


/// 删除Delegate
/// @param delegate observer
- (void)removePlayDelegate:(id<XYPlayerViewDelegate>)delegate;

/// 根据config里的参数初始化播放器源
/// @param block 可以在block里初始化PlayerView当前的config参数
- (void)refreshWithConfig:(XYPlayerViewConfiguration *(^)(XYPlayerViewConfiguration * config))block;


/// 销毁播放源
- (void)destroySource;

/// 是否在播放中
- (BOOL)isPlaying;

///  播放

- (void)play;

///  暂停
- (void)pause;

/// 同步强制暂停，force参数为YES的话，无论当前是否播放中都会同步执行一下pause操作
/// 且在pause前会等待当前播放器线程之前所有操作完成
/// @param force 是否强制暂停, ⚠️当需要严格控制播放器与引擎线程之间的时序关系时才用YES
- (void)pause:(BOOL)force;


/// 播放
/// @param async 是否异步播放
- (void)playAsync:(BOOL)async;

///  播放，但更改layer的显示隐藏状态
- (void)playWithOutShowLayer;

/// Seek接口
/// @param seekPosition seek时间点，单位毫秒
/// @param async YES异步执行seek操作，NO同步执行该seek操作
- (void)seekToPosition:(NSInteger)seekPosition async:(BOOL)async;

/// 设置Playback Range
/// @param range 播放的range
- (void)setPlaybackRange:(XYVeRangeModel *)range;

/// 获取播放时间区域
- (XYVeRangeModel *)getPlaybackRange;

/// 设置播放时间区域 Range
/// @param range 播放的range
/// @param async  YES异步执行该操作，NO同步执行该操作
- (void)setPlaybackRange:(XYVeRangeModel *)range async:(BOOL)async;

/// 播放器displayRefresh
/// @param async YES异步执行操作，NO同步执行该操作
- (void)displayRefreshAsync:(BOOL)async;

///开始调整effect前先锁定该effect下的图层
- (NSInteger)lockStuffUnderEffect:(CXiaoYingEffect *)effect async:(BOOL)async;

///调整完effect后解锁该effect下的图层
- (NSInteger)unlockStuffUnderEffect:(CXiaoYingEffect *)effect async:(BOOL)async;

/// 播放器刷新镜头
/// @param clip clip
/// @param opCode code
/// @param effect 对应的effect
/// @param async YES异步执行操作，NO同步执行该操作
- (void)refreshEffect:(CXiaoYingClip *)clip
               OpCode:(MDWord)opCode
               effect:(CXiaoYingEffect *)effect
                async:(BOOL)async;

/// 刷新音频
- (void)refreshAudio;

/// 设置播放器音量
/// @param volume 音量值
- (void)setVolume:(MDWord)volume;

- (void)updateDisplayContextConfig;

@end
