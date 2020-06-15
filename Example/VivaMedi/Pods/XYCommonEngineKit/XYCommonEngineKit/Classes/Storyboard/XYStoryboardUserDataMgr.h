//
//  XYStoryboardUserDataMgr.h
//  XiaoYingSDK
//
//  Created by xuxinyuan on 12/5/14.
//  Copyright (c) 2014 XiaoYing. All rights reserved.
//

#import <Foundation/Foundation.h>

#define STORYBOARD_USERDATA_KEY_PIP @"pip"
#define STORYBOARD_USERDATA_PIP_CURRENT_INDEX @"pip_current_index"
#define STORYBOARD_USERDATA_PIP_TEMPLATE_ID @"pip_template_id"
#define STORYBOARD_USERDATA_PIP_SEQUENCE @"pip_sequence"

/**
 用于保存某些自定义信息到引擎生成的工程文件中
 */
@interface XYStoryboardUserDataMgr : NSObject

+ (NSMutableDictionary *)getUserDataDict;
+ (void)saveUserDataDict:(NSDictionary *)userDataDict;

//PIP
+ (void)savePIPUserData:(SInt32)currentSourceIndex pipTemplateId:(UInt64)pipTemplateId;
+ (void)cleanPIPUserData;
+ (NSDictionary *)loadPIPUserData;
+ (SInt32)loadPIPCurrentIndex;
+ (UInt64)loadPIPTemplateId;

@end
