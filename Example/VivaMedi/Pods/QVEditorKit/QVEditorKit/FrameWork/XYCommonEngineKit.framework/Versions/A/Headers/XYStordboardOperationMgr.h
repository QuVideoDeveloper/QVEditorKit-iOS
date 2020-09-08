//
//  XYStordboardOperationMgr.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/19.
//

#import <Foundation/Foundation.h>
#import "XYOperationMgrBase.h"

@class XYStoryboardModel;
@class XYStbBackUpModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYStordboardOperationMgr : XYOperationMgrBase

@property(nonatomic, strong) XYStoryboardModel *currentStbModel;
@property(nonatomic, strong) XYStbBackUpModel *backUpModel;

- (void)runTask:(XYStoryboardModel *)storyboardModel;

- (void)runTask:(XYStoryboardModel *)storyboardModel
completionBlock:(void(^)(BOOL success, NSError *error, id obj))completionBlock;

- (BOOL)bgmIsAddedByTheme:(NSString *)bgmPath;

@end

NS_ASSUME_NONNULL_END
