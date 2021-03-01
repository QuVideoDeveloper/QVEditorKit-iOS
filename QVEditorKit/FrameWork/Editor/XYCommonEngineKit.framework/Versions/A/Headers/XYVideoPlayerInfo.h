//
//  XYVideoPlayerInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYVideoPlayerInfo : NSObject

@property(nonatomic) NSInteger dwFileFormat;
@property(nonatomic) NSInteger dwVideoFormat;
@property(nonatomic) NSInteger dwAudioFormat;
@property(nonatomic) NSInteger dwFrameWidth;
@property(nonatomic) NSInteger dwFrameHeight;
@property(nonatomic) NSInteger dwVideoDuration;
@property(nonatomic) NSInteger dwAudioDuration;
@property(nonatomic) NSInteger dwFileSize;
@property(nonatomic) NSInteger dwBitrate;
@property(nonatomic) NSInteger dwVideoFrameRate;
@property(nonatomic) NSInteger dwVideoBitrate;
@property(nonatomic) NSInteger dwAudioSampleRate;
@property(nonatomic) NSInteger dwAudioChannel;
@property(nonatomic) NSInteger dwAudioBitrate;
@property(nonatomic) NSInteger dwAudioBitsPerSample;
@property(nonatomic) NSInteger dwAudioBlockAlign;

@end

NS_ASSUME_NONNULL_END
