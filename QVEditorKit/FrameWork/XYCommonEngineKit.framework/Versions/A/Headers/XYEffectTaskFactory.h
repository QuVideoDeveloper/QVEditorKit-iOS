//
//  XYEffectTaskFactory.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class XYBaseEffectTask;

@interface XYEffectTaskFactory : NSObject

+ (XYBaseEffectTask *)factoryWithType:(XYCommonEngineTaskID)taskID;

@end

NS_ASSUME_NONNULL_END
