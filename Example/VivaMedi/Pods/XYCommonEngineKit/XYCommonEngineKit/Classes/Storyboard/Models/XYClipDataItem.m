//
//  XYClipDataItem.m
//  XiaoYingSDK
//
//  Created by xuxinyuan on 5/12/15.
//  Copyright (c) 2015 XiaoYing. All rights reserved.
//

#import "XYClipDataItem.h"

@implementation XYClipDataItem

- (instancetype)init {
	self = [super init];
	if (self) {
		self.timeScale = 1.0;
        self.clipIndex = -1;
	}
	return self;
}

@end
