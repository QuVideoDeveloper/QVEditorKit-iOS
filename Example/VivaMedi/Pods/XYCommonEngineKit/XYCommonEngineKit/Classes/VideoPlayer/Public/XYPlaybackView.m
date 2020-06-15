//
//  XYPlaybackView.m
//  XiaoYing
//
//  Created by xuxinyuan on 13-5-8.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//

#import "XYPlaybackView.h"
#import <QuartzCore/CAEAGLLayer.h>
#import "XYEngine.h"

@interface XYPlaybackView ()

@end

@implementation XYPlaybackView

+ (Class)layerClass {
#if !TARGET_IPHONE_SIMULATOR//真机才支持Metal,模拟器不支持Metal
    if ([[XYEngine sharedXYEngine] getMetalEnable]) {
        return [CAMetalLayer class];
    } else {
        return [CAEAGLLayer class];
    }
#else
    return [CAEAGLLayer class];
#endif
    
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self inits];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)coder {
	if (!(self = [super initWithCoder:coder])) {
		return nil;
	}

	if (self) {
		[self inits];
	}

	return self;
}

- (void)inits {
	// Initialization code
	// Use 2x scale factor on Retina displays.
	self.contentScaleFactor = [[UIScreen mainScreen] scale];

#if !TARGET_IPHONE_SIMULATOR//真机才支持Metal,模拟器不支持Metal
	if ([self.layer isKindOfClass:[CAMetalLayer class]]) {
		//Initialize Metal
		CAMetalLayer *eaglLayer = (CAMetalLayer *)self.layer;
		eaglLayer.opaque = YES;
	} else {
		// Initialize OpenGL ES 2
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
		                                                 [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
		                                                 kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
		                                                 nil];
	}
#else
	// Initialize OpenGL ES 2
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	eaglLayer.opaque = YES;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
	                                                 [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
	                                                 kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
	                                                 nil];
#endif
}


@end
