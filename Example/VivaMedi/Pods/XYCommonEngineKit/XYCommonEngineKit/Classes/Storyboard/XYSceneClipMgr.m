//
//  XYSceneClipMgr.m
//  XiaoYingSDK
//
//  Created by xuxinyuan on 11/13/14.
//  Copyright (c) 2014 XiaoYing. All rights reserved.
//

#import "XYSceneClipMgr.h"
#import "XYEngine.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYClip.h"

@interface XYSceneClipMgr () {
	CXiaoYingSceneClip *currentSceneClip;
	MInt64 currentPIPTemplateID;
}

@end

@implementation XYSceneClipMgr

- (MRECT)getElementRegion:(MInt64)llTemplateID templateLayout:(UInt64)templateLayout dwSourceIndex:(MDWord)dwSourceIndex {
	MRESULT res = 0;
	//    XYMSIZE streamSize = [XYSceneClipMgr getStreamSize:llTemplateID isHD:HIDDEN_SWITCH_HD_MODE];
	CGSize streamSize = [XYSceneClipMgr getStreamSizeWithLayoutFlag:templateLayout isHD:NO];
	MSIZE tmpMSize = {(MLong)streamSize.width, (MLong)streamSize.height};
	if (!currentSceneClip) {
		currentSceneClip = [[CXiaoYingSceneClip alloc] init];
		res = [currentSceneClip Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] TemplateID:llTemplateID Resolution:&tmpMSize];
	} else {
		res = [currentSceneClip SetTemplate:llTemplateID Resolution:&tmpMSize];
	}
	MRECT rect = {0};
	[currentSceneClip GetElementRegion:dwSourceIndex Region:&rect];
	return rect;
}

- (void)setCurrentSceneClip:(CXiaoYingSceneClip *)sceneClip {
	currentSceneClip = sceneClip;
}

+ (CXiaoYingStoryBoardSession *)createCXiaoYingStoryBoardSession {
	CXiaoYingStoryBoardSession *cXiaoYingStoryboardSession = [[CXiaoYingStoryBoardSession alloc] init];
	MRESULT res = [cXiaoYingStoryboardSession Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] ThemeOptHandler:nil];
	if (res) {
		NSLog(@"createCXiaoYingStoryBoardSession error=0x%lx", res);
	}
	return cXiaoYingStoryboardSession;
}

+ (CXiaoYingSceneClip *)createSceneClip:(MInt64)llTemplateID
                             resolution:(CGSize)resolution
                          dwSourceIndex:(MDWord)dwSourceIndex
                          subStoryboard:(CXiaoYingStoryBoardSession *)subStoryboard {
	CXiaoYingSceneClip *sceneClip = [[CXiaoYingSceneClip alloc] init];
	MSIZE tmpMSize = {(MLong)resolution.width, (MLong)resolution.height};
	MRESULT res = [sceneClip Init:[[XYEngine sharedXYEngine] getCXiaoYingEngine] TemplateID:llTemplateID Resolution:&tmpMSize];
	resolution.width = tmpMSize.cx;
	resolution.height = tmpMSize.cy;
	res = [sceneClip SetElementSource:dwSourceIndex StoryboardSource:subStoryboard];
	return sceneClip;
}

- (void)createSceneClip:(MInt64)llTemplateID
         templateLayout:(UInt64)templateLayout
          dwSourceIndex:(MDWord)dwSourceIndex
          subStoryboard:(CXiaoYingStoryBoardSession *)subStoryboard {
	CGSize streamSize = [XYSceneClipMgr getStreamSizeWithLayoutFlag:templateLayout isHD:NO];
	if (!currentSceneClip) {
		currentSceneClip = [XYSceneClipMgr createSceneClip:llTemplateID resolution:streamSize dwSourceIndex:dwSourceIndex subStoryboard:subStoryboard];
	} else {
		if (currentPIPTemplateID != llTemplateID) {
			MSIZE tmpMSize = {(MLong)streamSize.width, (MLong)streamSize.height};
			[currentSceneClip SetTemplate:llTemplateID Resolution:&tmpMSize];
		}
		[currentSceneClip SetElementSource:dwSourceIndex StoryboardSource:subStoryboard];
	}

	[XYSceneClipMgr updateSceneClipSourceRegion:currentSceneClip streamSize:streamSize bUseSourceAlignment:YES];

	currentPIPTemplateID = llTemplateID;
}

- (void)saveToMainStoryboard {
	MRESULT res = 0;
	MDWord count = 0;
	MDWord minDuration = [self getMinDuration];
	[currentSceneClip GetElementCount:&count];
	BOOL isAllSubEmpty = YES;
	for (int i = 0; i < count; i++) {
		CXiaoYingStoryBoardSession *storyboardSession = [XYSceneClipMgr createCXiaoYingStoryBoardSession];
		res = [currentSceneClip GetElementSource:i StoryboardSource:storyboardSession];
		if (res || [storyboardSession getDuration] == 0) {
			storyboardSession = [self createEmptyStoryboard:minDuration];
			res = [currentSceneClip SetElementSource:i StoryboardSource:storyboardSession];
			if (res) {
				NSLog(@"[ENGINE]XYSceneClipMgr saveToMainStoryboard SetElementSource err=0x%lx", res);
			}
		} else {
			isAllSubEmpty = NO;
		}
	}
	MDWord clipCount = [[XYStoryboard sharedXYStoryboard] getClipCount];
	CXiaoYingClip *lastClip = [[XYStoryboard sharedXYStoryboard] getClipByIndex:clipCount - 1];
	if (!isAllSubEmpty && lastClip.hClip != currentSceneClip.hClip) {
		[[XYStoryboard sharedXYStoryboard] insertClip:currentSceneClip Position:clipCount];
	}
	currentSceneClip = nil;
}

- (CXiaoYingStoryBoardSession *)createEmptyStoryboard:(MDWord)duration {
	XYStoryboard *storyboard = [[XYStoryboard alloc] init];
	[storyboard initAll];
	[storyboard initXYStoryBoard];
	[storyboard insertEmptyClip:0 duration:duration];
	return [storyboard getStoryboardSession];
}

+ (CGSize)getStreamSizeWithLayoutFlag:(UInt64)templateLayoutFlag isHD:(BOOL)isHD {
	CGSize streamSize = CGSizeMake(640, 360);
	if ((templateLayoutFlag & QVTP_LAYOUT_MODE_W16_H9) == QVTP_LAYOUT_MODE_W16_H9) {
		if (isHD) {
			streamSize = CGSizeMake(1280, 720);
		} else {
			streamSize = CGSizeMake(640, 360);
		}
	} else {
		if (isHD) {
			streamSize = CGSizeMake(720, 720);
		} else {
			streamSize = CGSizeMake(480, 480);
		}
	}
	return streamSize;
}

+ (BOOL)updateSceneClipSourceRegion:(CXiaoYingSceneClip *)sceneclip streamSize:(CGSize)streamSize bUseSourceAlignment:(BOOL)bUseSourceAlignment {
	if (sceneclip) {
		MDWord count = 0;
		MRESULT res = [sceneclip GetElementCount:&count];
		if (res) {
			NSLog(@"[ENGINE] sceneclip GetElementCount");
		}
		for (int i = 0; i < count; i++) {
			CXiaoYingStoryBoardSession *readSource = [XYSceneClipMgr createCXiaoYingStoryBoardSession];
			res = [sceneclip GetElementSource:i StoryboardSource:readSource];
			if (res != 0)
				continue;

			CXiaoYingClip *dataClip = [readSource getDataClip];
			AMVE_VIDEO_INFO_TYPE videoInfo = {0};
			res = [dataClip getProperty:AMVE_PROP_CLIP_SOURCE_INFO PropertyData:&videoInfo];

			CGSize videoSize = CGSizeMake(videoInfo.dwFrameWidth, videoInfo.dwFrameHeight);

			MRECT oldRegion = {0};
			[dataClip getProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&oldRegion];

			CGSize previewSize = CGSizeMake(0, 0);
			MRECT region = {0};
			[sceneclip GetElementRegion:i Region:&region];
			if ((region.bottom - region.top > 0) && (region.right - region.left > 0)) {
				int width = region.right - region.left;
				int height = region.bottom - region.top;

				int realWidth = streamSize.width * width / 10000;
				int realHeight = streamSize.height * height / 10000;

				previewSize = CGSizeMake(realWidth, realHeight); //TODO 4 align
			}

			CGSize fitOutSize = [XYSceneClipMgr getFitOutSize:videoSize destSize:previewSize];

			if (fitOutSize.width <= 0 || fitOutSize.height <= 0)
				continue;

			int relativeW = previewSize.width * 10000 / fitOutSize.width;
			int relativeH = previewSize.height * 10000 / fitOutSize.height;

			MRECT destRegion = {0};
			if (bUseSourceAlignment) {
				MDWord elementAlignment;
				res = [sceneclip GetElementSourceAlignment:i Alignment:&elementAlignment];
				if (elementAlignment != (PIP_ALIGNMENT_HOR_CENTER | PIP_ALIGNMENT_VER_CENTER)) {
					if ((elementAlignment & PIP_ALIGNMENT_LEFT) == PIP_ALIGNMENT_LEFT) {
						destRegion.left = 0;
						destRegion.right = relativeW;
						destRegion.top = (10000 - relativeH) / 2;
						destRegion.bottom = destRegion.top + relativeH;
					} else if ((elementAlignment & PIP_ALIGNMENT_RIGHT) == PIP_ALIGNMENT_RIGHT) {
						destRegion.left = 10000 - relativeW;
						destRegion.right = 10000;
						destRegion.top = (10000 - relativeH) / 2;
						destRegion.bottom = destRegion.top + relativeH;
					} else if ((elementAlignment & PIP_ALIGNMENT_TOP) == PIP_ALIGNMENT_TOP) {
						destRegion.left = 0;
						destRegion.right = 10000;
						destRegion.top = 0;
						destRegion.bottom = relativeH;
					} else if ((elementAlignment & PIP_ALIGNMENT_BOTTOM) == PIP_ALIGNMENT_BOTTOM) {
						destRegion.left = 0;
						destRegion.right = 10000;
						destRegion.top = 10000 - relativeH;
						destRegion.bottom = 10000;
					}
				} else {
					destRegion.left = (10000 - relativeW) / 2;
					destRegion.right = destRegion.left + relativeW;
					destRegion.top = (10000 - relativeH) / 2;
					destRegion.bottom = destRegion.top + relativeH;
				}
			} else {
				// start from (0,0) point.
				destRegion.left = (10000 - relativeW) / 2;
				destRegion.right = destRegion.left + relativeW;
				destRegion.top = (10000 - relativeH) / 2;
				destRegion.bottom = destRegion.top + relativeH;
			}

			MRECT rcCrop = {0};
			MRESULT res = [dataClip getProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&rcCrop];
			if (res || (rcCrop.left == 0 && rcCrop.right == 0 && rcCrop.top == 0 && rcCrop.bottom == 0) || (rcCrop.left == 0 && rcCrop.right == 10000 && rcCrop.top == 0 && rcCrop.bottom == 10000)) {
				res = [dataClip setProperty:AMVE_PROP_CLIP_CROP_REGION PropertyData:&destRegion];
			}
		}
		return YES;
	}
	return NO;
}

+ (CGSize)getFitOutSize:(CGSize)srcSize destSize:(CGSize)destSize {
	if (srcSize.width > 0 && srcSize.height > 0 && destSize.width > 0 && destSize.height > 0) {
		int fitOutWidth = 0;
		int fitOutHeight = 0;

		float widthRatio = srcSize.width / destSize.width;
		float heightRatio = srcSize.height / destSize.height;
		if (widthRatio > heightRatio) {
			fitOutHeight = destSize.height;
			fitOutWidth = (int)(srcSize.width / heightRatio);
		} else {
			fitOutWidth = destSize.width;
			fitOutHeight = (int)(srcSize.height / widthRatio);
		}
		//TODO 4 align
		//        fitOutWidth = calcAlignValue(fitOutWidth, 4);
		//        fitOutHeight = calcAlignValue(fitOutHeight, 4);
		return CGSizeMake(fitOutWidth, fitOutHeight);
	}

	return CGSizeZero;
}

- (MDWord)getNormalClipCount {
	MDWord clipCount = 0;
	MDWord sourceCount = 0;
	MRESULT res = [currentSceneClip GetElementCount:&sourceCount];
	if (res) {
		NSLog(@"[ENGINE] getNormalClipCount GetElementCount err = 0x%x", res);
	}
	for (int i = 0; i < sourceCount; i++) {
		CXiaoYingStoryBoardSession *storyboardSession = [XYSceneClipMgr createCXiaoYingStoryBoardSession];
		res = [currentSceneClip GetElementSource:i StoryboardSource:storyboardSession];
		if (res && res != 0x83702d) {
			NSLog(@"[ENGINE] getNormalClipCount GetElementSource err = 0x%x", res);
		} else {
			clipCount += [storyboardSession getClipCount];
		}
	}
	return clipCount;
}

- (MDWord)getMinDuration {
	MDWord dwSourceCount = 0;
	MDWord dwMinDuration = 0xFFFFFFFF;
	MRESULT res = 0;
	res = [currentSceneClip GetElementCount:&dwSourceCount];
	if (res) {
		return 0;
	}

	for (int i = 0; i < dwSourceCount; i++) {
		CXiaoYingStoryBoardSession *cXiaoYingStoryboardSession = [XYSceneClipMgr createCXiaoYingStoryBoardSession];
		res = [currentSceneClip GetElementSource:i StoryboardSource:cXiaoYingStoryboardSession];
		if (res) {
			continue;
		} else {
			MDWord duration = [cXiaoYingStoryboardSession getDuration];
			if (duration > 0) {
				dwMinDuration = MIN(duration, dwMinDuration);
			}
		}
	}
	if (dwMinDuration == 0xFFFFFFFF) {
		dwMinDuration = 0;
	}
	return dwMinDuration;
}

- (void)calculateMinDuration {
	MRESULT res = 0;
	MDWord dwSourceCount = 0;
	MDWord dwMinDuration = [self getMinDuration];
	if (dwMinDuration == 0) {
		return;
	}
	res = [currentSceneClip GetElementCount:&dwSourceCount];
	if (res) {
		NSLog(@"[ENGINE]XYSceneClipMgr calculateMinDuration GetElementCount err=0x%x", res);
		return;
	}
	for (int i = 0; i < dwSourceCount; i++) {
		CXiaoYingStoryBoardSession *cXiaoYingStoryboardSession = [XYSceneClipMgr createCXiaoYingStoryBoardSession];
		res = [currentSceneClip GetElementSource:i StoryboardSource:cXiaoYingStoryboardSession];
		if (res) {
			return;
		} else {
			CXiaoYingClip *cXiaoYingClip = [cXiaoYingStoryboardSession getDataClip];
			AMVE_POSITION_RANGE_TYPE clipRange = {0};
			clipRange.dwPos = 0;
			clipRange.dwLen = dwMinDuration;
            [[XYStoryboard sharedXYStoryboard] setClipTrimRange:cXiaoYingClip trimRange:clipRange];
    
			if (res) {
				NSLog(@"[ENGINE]XYSceneClipMgr calculateMinDuration setProperty AMVE_PROP_CLIP_TRIM_RANGE startPos=0 endPos=%ld, err=0x%x", dwMinDuration, res);
			} else {
				[currentSceneClip SetElementSource:i StoryboardSource:cXiaoYingStoryboardSession];
			}
		}
	}
}

- (void)setSubStoryboardsTrimRangeSameAsDuration {
	MRESULT res = 0;
	MDWord dwSourceCount = 0;
	res = [currentSceneClip GetElementCount:&dwSourceCount];
	if (res) {
		NSLog(@"[ENGINE]XYSceneClipMgr calculateMinDuration GetElementCount err=0x%x", res);
		return;
	}
	for (int i = 0; i < dwSourceCount; i++) {
		CXiaoYingStoryBoardSession *cXiaoYingStoryboardSession = [XYSceneClipMgr createCXiaoYingStoryBoardSession];
		res = [currentSceneClip GetElementSource:i StoryboardSource:cXiaoYingStoryboardSession];
		if (res) {
			continue;
		} else {
			MDWord duration = [cXiaoYingStoryboardSession getDuration];
			CXiaoYingClip *cXiaoYingClip = [cXiaoYingStoryboardSession getDataClip];
			AMVE_POSITION_RANGE_TYPE clipRange = {0};
			clipRange.dwPos = 0;
			clipRange.dwLen = duration;
			if (duration > 0) {
                [[XYStoryboard sharedXYStoryboard] setClipTrimRange:cXiaoYingClip trimRange:clipRange];
			}
			if (res) {
				NSLog(@"[ENGINE]XYSceneClipMgr calculateMinDuration setProperty AMVE_PROP_CLIP_TRIM_RANGE startPos=0 endPos=%ld, err=0x%x", duration, res);
			} else {
				[currentSceneClip SetElementSource:i StoryboardSource:cXiaoYingStoryboardSession];
			}
		}
	}
}

@end
