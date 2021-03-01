//
//  XYProjectOperatonMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/23.
//

#import "XYOperationMgrBase.h"
#import "XYEngineClassHeader.h"

@class XYQprojectModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYQProjectOperatonMgr : XYOperationMgrBase

@property(nonatomic, strong) XYQprojectModel *currentProjectModel;

- (void)runTask:(XYQprojectModel *)projectModel;

- (void)runTask:(XYQprojectModel *)projectModel
completionBlock:(XYTaskCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
