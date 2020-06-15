//
//  XYCommonEngineTask.m
//  AWSCore
//
//  Created by 夏澄 on 2019/10/12.
//

#import "XYCommonEngineTaskMgr.h"
#import "XYBaseEngineTask.h"
@interface XYCommonEngineTaskMgr()
@property (nonatomic, strong) dispatch_queue_t dispatchQueue;
@property (nonatomic, assign) BOOL isSuspend;//队列是否挂起
@end

@implementation XYCommonEngineTaskMgr
+ (XYCommonEngineTaskMgr *)task {
    static XYCommonEngineTaskMgr *task;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
      task = [[XYCommonEngineTaskMgr alloc] init];
    });
    return task;
}

- (instancetype)init {
    if (self = [super init]) {
        _dispatchQueue = dispatch_queue_create("com.quvideo.serial.common.engine.queue", DISPATCH_QUEUE_SERIAL);
        self.isSuspend = NO;
    }
    return self;
}

- (void)postTask:(XYBaseEngineTask *)task preprocessBlock:(void (^)(void))preprocessBlock {
    dispatch_async(self.dispatchQueue, ^{
        if (preprocessBlock) {
            preprocessBlock();
        }
        self.isExcusing = YES;
        if (task) {
            [task run];
        }
        self.isExcusing = NO;
     });
}

//两者必须成对出现
- (void)pause {
    if (!self.isSuspend) {//没有挂起
        dispatch_suspend(self.dispatchQueue);
        self.isSuspend = YES;
    }
}

- (void)resume {
    if (self.isSuspend) {//被挂起
        dispatch_resume(self.dispatchQueue);
        self.isSuspend = NO;
    }
}


- (void)postTaskHandle:(dispatch_block_t)taskHandleBlock {
    dispatch_async(self.dispatchQueue, ^{
        if (taskHandleBlock) {
           taskHandleBlock();
        }
    });
}

@end
