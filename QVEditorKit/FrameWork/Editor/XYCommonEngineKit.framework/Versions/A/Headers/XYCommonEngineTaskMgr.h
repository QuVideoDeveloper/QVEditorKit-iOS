//
//  XYCommonEngineTask.h
//  AWSCore
//
//  Created by 夏澄 on 2019/10/12.
//

#import <Foundation/Foundation.h>
@class XYBaseEngineTask;
NS_ASSUME_NONNULL_BEGIN

@interface XYCommonEngineTaskMgr : NSObject

@property (nonatomic, assign) BOOL isExcusing;

+ (XYCommonEngineTaskMgr *)task;

- (void)postTask:(XYBaseEngineTask *)task preprocessBlock:(void (^)(void))preprocessBlock;

- (void)pause;

- (void)resume;

- (void)postTaskHandle:(dispatch_block_t)taskHandleBlock;

- (void)postSaveTask:(void (^)(void))preprocessBlock;

@end

NS_ASSUME_NONNULL_END
