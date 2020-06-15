//
//  XYClipOperationMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import <Foundation/Foundation.h>
#import "XYOperationMgrBase.h"

@class XYClipModel;
@class XYBaseEngineTask;
@class XYEffectModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYClipOperationMgr : XYOperationMgrBase

@property (nonatomic, assign) NSInteger clipsTotalDuration;

@property (nonatomic, copy) NSArray <XYClipModel *> *clipModels;//获取所有clip信息
- (XYClipModel *)fetchClipModelWithIdentifier:(NSString *)identifier;//从clip的identifier 来获取clipmodel
- (void)removeClipModelWithIdentifier:(NSString *)identifier;
- (XYClipModel *)fetchClipModelObjectAtIndex:(NSUInteger)idx;
- (void)runTask:(XYClipModel *)clipModel;
- (void)runTaskToMore:(NSArray <XYClipModel *> *)clipModels;//应用多个或者全部

@end

NS_ASSUME_NONNULL_END
