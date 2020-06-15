//
//  XYStoryboardUserDataMgr.m
//  XiaoYingSDK
//
//  Created by xuxinyuan on 12/5/14.
//  Copyright (c) 2014 XiaoYing. All rights reserved.
//

#import "XYStoryboardUserDataMgr.h"
#import "XYStoryboard.h"
#import <XYCategory/XYCategory.h>

@implementation XYStoryboardUserDataMgr

+ (NSMutableDictionary *)getUserDataDict {
	NSString *strUserdata = [[XYStoryboard sharedXYStoryboard] getUserData];
	if ([NSString xy_isEmpty:strUserdata]) {
		return nil;
	}
	NSData *jsonUserData = [strUserdata dataUsingEncoding:NSUTF8StringEncoding];
	if (!jsonUserData) {
		return nil;
	}
	NSDictionary *originalUserDataDict = [NSJSONSerialization JSONObjectWithData:jsonUserData options:0 error:nil];
	NSMutableDictionary *userData = [NSMutableDictionary dictionaryWithDictionary:originalUserDataDict];
	return userData;
}

+ (void)saveUserDataDict:(NSDictionary *)userDataDict {
	if (!userDataDict) {
		return;
	}
	NSData *userData = [NSJSONSerialization dataWithJSONObject:userDataDict options:0 error:nil];
	if (!userData) {
		return;
	}
	NSString *strUserData = [[NSString alloc] initWithData:userData
	                                              encoding:NSUTF8StringEncoding];
	[[XYStoryboard sharedXYStoryboard] setUserData:strUserData];
}

//PIP
+ (void)savePIPUserData:(MDWord)currentSourceIndex pipTemplateId:(MInt64)pipTemplateId {
	NSMutableDictionary *userDataDict = [XYStoryboardUserDataMgr getUserDataDict];
	if (!userDataDict) {
		userDataDict = [[NSMutableDictionary alloc] init];
	}

	NSDictionary *pipUserDataDict = @{
		STORYBOARD_USERDATA_PIP_CURRENT_INDEX : @(currentSourceIndex),
		STORYBOARD_USERDATA_PIP_TEMPLATE_ID : @(pipTemplateId),
	};
    [userDataDict setValue:pipUserDataDict forKey:STORYBOARD_USERDATA_KEY_PIP];
	[XYStoryboardUserDataMgr saveUserDataDict:userDataDict];
}

+ (void)cleanPIPUserData {
	NSMutableDictionary *userDataDict = [XYStoryboardUserDataMgr getUserDataDict];
	if (!userDataDict) {
		userDataDict = [[NSMutableDictionary alloc] init];
	}

	[userDataDict removeObjectForKey:STORYBOARD_USERDATA_KEY_PIP];
	[XYStoryboardUserDataMgr saveUserDataDict:userDataDict];
}

+ (NSDictionary *)loadPIPUserData {
	NSMutableDictionary *userData = [XYStoryboardUserDataMgr getUserDataDict];
	NSDictionary *pipUserDataDict = [userData objectForKey:STORYBOARD_USERDATA_KEY_PIP];
	return pipUserDataDict;
}

+ (MDWord)loadPIPCurrentIndex {
	NSDictionary *pipUserDataDict = [XYStoryboardUserDataMgr loadPIPUserData];
	MDWord pipCurrentIndex = [[pipUserDataDict objectForKey:STORYBOARD_USERDATA_PIP_CURRENT_INDEX] intValue];
	return pipCurrentIndex;
}

+ (MInt64)loadPIPTemplateId {
	NSDictionary *pipUserDataDict = [XYStoryboardUserDataMgr loadPIPUserData];
	MInt64 pipTemplateId = [[pipUserDataDict objectForKey:STORYBOARD_USERDATA_PIP_TEMPLATE_ID] longLongValue];
	return pipTemplateId;
}

@end
