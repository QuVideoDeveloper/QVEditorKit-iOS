//
//  XYProjectTaskFactory.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/23.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

@class XYBaseProjectTask;

NS_ASSUME_NONNULL_BEGIN

@interface XYQProjectTaskFactory : NSObject

+ (XYBaseProjectTask *)factoryWithType:(XYCommonEngineTaskID)taskID;

@end

NS_ASSUME_NONNULL_END
