//
//  XYClipTaskFactory.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

@class XYBaseClipTask;

NS_ASSUME_NONNULL_BEGIN

@interface XYClipTaskFactory : NSObject

+ (XYBaseClipTask *)factoryWithType:(XYCommonEngineTaskID)taskID;

@end

NS_ASSUME_NONNULL_END
