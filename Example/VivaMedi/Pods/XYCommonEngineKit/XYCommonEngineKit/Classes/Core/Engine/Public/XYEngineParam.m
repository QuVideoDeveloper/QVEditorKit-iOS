//
//  XYEngineParam.m
//  Pods
//
//  Created by 徐新元 on 15/06/2017.
//
//

#import "XYEngineParam.h"

@implementation XYEngineParam

- (instancetype)initWithDefaultParam {
	self = [super init];
	if (!self) {
		return nil;
	}
	self.defaultPlaybackMute = NO;
	self.outputFileFormat = AMVE_VIDEOFORMAT_H264;
	self.outputAudioFormat = AMVE_AUDIOFORMAT_AACLC;
	self.outputFileFormat = AMVE_FILEFORMAT_MP4;
	self.resampleMode = AMVE_RESAMPLE_MODE_UPSCALE_FITIN;
	if ([self is64bit]) {
		self.maxSupportResolution = CGSizeMake(4096, 4096);
	} else {
		self.maxSupportResolution = CGSizeMake(1920, 1920);
	}
	self.trimType = AMVE_TRIM_TYPE_NORMAL;
	self.defaultBgmId = 0x0700000000000057;

	NSString *ducumentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	self.tempFolderPath = [NSString stringWithFormat:@"%@/engine_temp", ducumentPath];
	return self;
}


- (BOOL)is64bit
{
#if defined(__LP64__) && __LP64__
    return YES;
#else
    return NO;
#endif
}

@end
