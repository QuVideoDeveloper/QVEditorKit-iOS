//
//  QVMediGCDTimer.h
//  VivaMedi
//
//  Created by chaojie zheng on 2020/4/21.
//  Copyright © 2020 QuVideo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QVMediGCDTimer : NSObject

/// 初始化
/// @param timeNum 循环时间
/// @param block 循环方法
- (void)startTimerWithSpace:(float)timeNum block:(void(^)(BOOL))block;

/// 恢复
- (void)resume;

/// 暂停
- (void)suspend;

/// 关闭
- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
