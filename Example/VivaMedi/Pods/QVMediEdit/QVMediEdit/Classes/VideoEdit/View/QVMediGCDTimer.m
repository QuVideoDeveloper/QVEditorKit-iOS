//
//  QVMediGCDTimer.m
//  VivaMedi
//
//  Created by chaojie zheng on 2020/4/21.
//  Copyright © 2020 QuVideo. All rights reserved.
//

#import "QVMediGCDTimer.h"

/**
 当定时器 开启后 只可以 暂停 和 关闭
 当定时器 关闭后 只可以 重新开启
 当定时器 暂停后 只可以 恢复
 当定时器 恢复后 只可以 暂停 和 关闭
 */
typedef NS_ENUM(NSInteger, QVMediTimerStatus) {
    QVMediTimerStatusIng,       //执行中
    QVMediTimerStatusSuspend,   //暂停
    QVMediTimerStatusStop,      //关闭
};

@interface QVMediGCDTimer ()

@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) dispatch_semaphore_t lock;

@property (nonatomic, assign) BOOL onFire;

@property (nonatomic, assign) QVMediTimerStatus timerStatus;

@end

@implementation QVMediGCDTimer

- (instancetype)init {
    self = [super init];
    if (self) {
        _timerStatus = QVMediTimerStatusStop;
    }
    return self;
}

- (void)startTimerWithSpace:(float)timeNum block:(void(^)(BOOL))block {
    if (_timerStatus != QVMediTimerStatusStop) {
        NSLog(@"%@-start 状态错误%ld", [self class], (long)_timerStatus);
        if (block) {
            block(NO);
        }
        return;
    }
    dispatch_time_t start = dispatch_walltime(NULL, (int64_t)(0.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(timeNum * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    });
    _timerStatus = QVMediTimerStatusSuspend;
}

- (void)resume {
    if (_timerStatus != QVMediTimerStatusSuspend) {
        NSLog(@"%@-resume 状态错误%ld",[self class],_timerStatus);
        return;
    }
    [self resumeTime];
}

- (void)resumeTime {
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    if (self.timer) {
        dispatch_resume(self.timer);
        _onFire = YES;
        _timerStatus = QVMediTimerStatusIng;
    }
    dispatch_semaphore_signal(self.lock);
}

- (void)suspend {
    if (_timerStatus != QVMediTimerStatusIng) {
        NSLog(@"%@-suspend 状态错误%ld",[self class],_timerStatus);
        return;
    }
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    if (self.timer) {
        dispatch_suspend(self.timer);
        _onFire = NO;
        _timerStatus = QVMediTimerStatusSuspend;
    }
    dispatch_semaphore_signal(self.lock);
}

- (void)stopTimer {
    if (_timerStatus != QVMediTimerStatusIng) {
        NSLog(@"%@-stop 状态错误%ld",[self class],_timerStatus);
        return;
    }
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        _timerStatus = QVMediTimerStatusStop;
        _onFire = NO;
        self.timer = NULL;
    }
    dispatch_semaphore_signal(self.lock);
}


- (void)dealloc {
    if (self.timer) {
        if (_onFire == NO) {
            dispatch_resume(self.timer);
        }
    }
    [self stopTimer];
    NSLog(@" self----- dealloc -----------");
}


#pragma mark - getter

- (dispatch_source_t)timer {
    if (_timer == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    }
    return _timer;
}

- (dispatch_semaphore_t)lock {
    if (_lock == nil) {
        //线程加锁
        _lock = dispatch_semaphore_create(1);
    }
    return _lock;
}


@end
