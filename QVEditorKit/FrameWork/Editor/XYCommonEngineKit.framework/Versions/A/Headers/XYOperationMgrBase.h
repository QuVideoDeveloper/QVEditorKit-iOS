//
//  XYOperationMgrBase.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

@class XYStoryboard;
@class XYBaseEngineModel;
@class XYBaseEngineTask;

NS_ASSUME_NONNULL_BEGIN

@protocol XYOperationTaskDelegate <NSObject>

- (void)onOperationTaskStart:(XYBaseEngineTask *_Nonnull)baseTask;
- (void)onOperationTaskFinish:(XYBaseEngineTask *_Nonnull)baseTask;

@end

@interface XYOperationMgrBase : NSObject
@property (nonatomic, weak) id<XYOperationTaskDelegate> delegate;
- (instancetype)initWithStoryboard:(XYStoryboard *)storyboard;

- (void)reloadData;//刷新内存所有的数据

- (void)addObserver:(id _Nonnull )observer observerID:(XYCommonEngineTaskID)observerID block:(void (^)(id obj))block;
- (void)removeObserver:(id _Nonnull)observer observerID:(XYCommonEngineTaskID)observerID;

- (void)addUndo:(XYBaseEngineModel *)engineModel;

- (void)cleanData;

- (id)getCopyXYMeta;

@end

NS_ASSUME_NONNULL_END
