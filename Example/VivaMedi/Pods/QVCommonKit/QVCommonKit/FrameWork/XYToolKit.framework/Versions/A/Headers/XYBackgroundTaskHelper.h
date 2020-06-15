//
//  XYBackgroundTaskHelper
//  XYToolKit
//
//  Created by robbin on 2019/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYBackgroundTaskHelper : NSObject

+ (UIBackgroundTaskIdentifier)beginBackgroundTask:(void(^ __nullable)(void))handler;

+ (void)endBackgroundTask:(UIBackgroundTaskIdentifier)backgroundTaskId;

@end

NS_ASSUME_NONNULL_END
