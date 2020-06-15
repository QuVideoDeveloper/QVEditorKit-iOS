//
//  XYPlayerViewSourceConfig.m
//  XYPlayerView
//
//  Created by 徐新元 on 13/01/2018.
//

#import "XYPlayerViewConfiguration.h"
#import "XYCommonEngineKit.h"
#import <XYReactDataBoard/XYReactWhiteBoard.h>
#import "XYVideoPlayerInfo.h"
#import "XYEffectPostionUtilFuncs.h"

@implementation XYPlayerViewConfiguration

- (XYVideoPlayerInfo *)videoInfo {
    if(!_videoInfo) {
        _videoInfo = [[XYVideoPlayerInfo alloc] init];
    }
    return _videoInfo;
}

+ (XYPlayerViewConfiguration *)currentStoryboardSourceConfig {
    return [XYPlayerViewConfiguration storyboardSourceConfig:[XYStoryboard sharedXYStoryboard]];
}


+ (XYPlayerViewConfiguration *)storyboardSourceConfig:(XYStoryboard *)storyboard {
    XYPlayerViewConfiguration *config = [XYPlayerViewConfiguration new];
    config.sourceType = AMVE_STREAM_SOURCE_TYPE_STORYBOARD;
    config.totalDuration = [storyboard getDuration];
    XYVeRangeModel *range = [XYVeRangeModel VeRangeModelWithPosition:0 length:config.totalDuration];
    config.playbackRange = range;
    config.seekPosition = 0;
    config.bgColor = 0;
    config.hSession = [storyboard getStoryboardHSession];
    AMVE_VIDEO_INFO_TYPE videoinfo = {0};
    MRESULT res = [[storyboard getDataClip] getProperty:AMVE_PROP_CLIP_SOURCE_INFO
                                           PropertyData:(MVoid*)&videoinfo];
    
    NSAssert(res == MERR_NONE, @"XYPlayerViewSourceConfig 获取storyboard videoInfo失败 0x%x", res);
    
    config.videoInfo = [self transAmveVideoInfoStructToModel:videoinfo];
    MPOINT outPutResolution = {0,0};
    [storyboard getOutputResolution:&outPutResolution];
    CGFloat outPutResolutionY = (CGFloat)outPutResolution.y;
    config.videoRatio = outPutResolution.x / outPutResolutionY;
    return config;
}

+ (XYPlayerViewConfiguration *)clipSourceConfig:(CXiaoYingClip *)clip {
    XYPlayerViewConfiguration *config = [XYPlayerViewConfiguration new];
    config.sourceType = AMVE_STREAM_SOURCE_TYPE_CLIP;
    config.totalDuration = [XYEffectPostionUtilFuncs getRealVideoDuration:clip];
    XYVeRangeModel *range = [XYVeRangeModel VeRangeModelWithPosition:0 length:config.totalDuration];
    config.playbackRange = range;
    config.seekPosition = 0;
    config.bgColor = 0;
    config.hSession = [clip hClip];
    
    AMVE_VIDEO_INFO_TYPE videoinfo = {0};
    MRESULT res = [clip getProperty:AMVE_PROP_CLIP_SOURCE_INFO
                       PropertyData:(MVoid*)&videoinfo];
    NSAssert(res == MERR_NONE, @"XYPlayerViewSourceConfig 获取clip videoInfo失败 0x%x", res);
    config.videoInfo = [self transAmveVideoInfoStructToModel:videoinfo];
    if (videoinfo.dwFrameWidth>0 && videoinfo.dwFrameHeight>0) {
        config.videoRatio = (float)videoinfo.dwFrameWidth/(float)videoinfo.dwFrameHeight;
    }else{
        config.videoRatio = 1;
    }
    
    return config;
}

+ (XYVideoPlayerInfo *)transAmveVideoInfoStructToModel:(AMVE_VIDEO_INFO_TYPE)videoinfo {
    XYVideoPlayerInfo *infoModel = [[XYVideoPlayerInfo alloc] init];
    infoModel.dwFileFormat = videoinfo.dwFileFormat;
    infoModel.dwVideoFormat = videoinfo.dwVideoFormat;
    infoModel.dwAudioFormat = videoinfo.dwAudioFormat;
    infoModel.dwFrameWidth = videoinfo.dwFrameWidth;
    infoModel.dwFrameHeight = videoinfo.dwFrameHeight;
    infoModel.dwVideoDuration = videoinfo.dwVideoDuration;
    infoModel.dwAudioDuration = videoinfo.dwAudioDuration;
    infoModel.dwFileSize = videoinfo.dwFileSize;
    infoModel.dwBitrate = videoinfo.dwBitrate;
    infoModel.dwVideoFrameRate = videoinfo.dwVideoFrameRate;
    infoModel.dwVideoBitrate = videoinfo.dwVideoBitrate;
    infoModel.dwAudioSampleRate = videoinfo.dwAudioSampleRate;
    infoModel.dwAudioChannel = videoinfo.dwAudioChannel;
    infoModel.dwAudioBitrate = videoinfo.dwAudioBitrate;
    infoModel.dwAudioBitsPerSample = videoinfo.dwAudioBitsPerSample;
    infoModel.dwAudioBlockAlign = videoinfo.dwAudioBlockAlign;
    return infoModel;
}

- (void)setPlaybackRange:(XYVeRangeModel *)range {
    _playbackRange = range;
    if (range.dwLen > 0) {
        self.playbackEndTime = range.dwPos + range.dwLen;
    }else{
        self.playbackEndTime = self.totalDuration;
    }
}

- (XYVeRangeModel *)fullRange {
    XYVeRangeModel *range = [XYVeRangeModel VeRangeModelWithPosition:0 length:self.totalDuration];
    return range;
}

- (void)setTotalDuration:(MDWord)totalDuration {
    _totalDuration = totalDuration;
    if (_sourceType == AMVE_STREAM_SOURCE_TYPE_STORYBOARD) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[XYReactWhiteBoard shareBoard] setValue:@(totalDuration) forKey:@"XY_DATABOARD_KEY_DURATION_LIMIT"];
        });
    }
}

@end

