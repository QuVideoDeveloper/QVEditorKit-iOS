//
//  XYPlayerViewSourceConfig.h
//  XYPlayerView
//
//  Created by 徐新元 on 13/01/2018.
//

#import <Foundation/Foundation.h>
#import "XYStoryboard.h"

@class XYVeRangeModel, XYVideoPlayerInfo;

@interface XYPlayerViewConfiguration : NSObject

@property (nonatomic) XYVeRangeModel *playbackRange;
@property (nonatomic, strong) XYVideoPlayerInfo *videoInfo;
@property (nonatomic) NSInteger sourceType;
@property (nonatomic) NSInteger seekPosition;
@property (nonatomic) NSInteger totalDuration;//Storyboard总时长
@property (nonatomic) NSInteger playbackEndTime;//playbackRange结束时间点，比如总时长10000毫秒，playbackRange[1000,5000],这个时候结束点就是6000
@property (nonatomic) NSInteger bgColor;
@property (nonatomic) void* hSession;
@property (nonatomic) CGFloat videoRatio;//视频比例
@property (nonatomic) BOOL autoFit;//设置尺寸后 自适应大小 默认YES
@property (nonatomic) CGSize playStreamSize;//视频播放流的尺寸

@property (nonatomic) BOOL needRebuildStram;//是否需要rebuild stream

+ (XYPlayerViewConfiguration *)currentStoryboardSourceConfig;

+ (XYPlayerViewConfiguration *)storyboardSourceConfig:(XYStoryboard *)storyboard;

+ (XYPlayerViewConfiguration *)clipSourceConfig:(CXiaoYingClip *)clip;

- (XYVeRangeModel *)fullRange;

@end
