//
//  XYStoryboardTaskFactory.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class XYBaseStoryboardTask;

@interface XYStoryboardTaskFactory : NSObject

+ (XYBaseStoryboardTask *)factoryWithType:(XYCommonEngineTaskID)taskID;

@end

NS_ASSUME_NONNULL_END
