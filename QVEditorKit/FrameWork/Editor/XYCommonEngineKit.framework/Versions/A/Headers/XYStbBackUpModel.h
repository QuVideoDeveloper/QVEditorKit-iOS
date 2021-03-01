//
//  XYStbBackUpModel.h
//  Pods
//
//  Created by 夏澄 on 2020/2/5.
//

#import <Foundation/Foundation.h>

@class XYStoryboardModel;
@class XYClipModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYStbBackUpModel : NSObject

@property (nonatomic, strong) CXiaoYingStoryBoardSession *backUpXiaoYingStoryBoardSession;
@property(nonatomic, assign) BOOL preBackUpIsModified;//备份之前的storyboard.isModified 的修改状态
@property(nonatomic, assign) CGFloat preBackUpRatio;//备份之前的storyboard的比例
@property(nonatomic, copy) NSString *preBackUpSelectedClipIdentifier;//备份之前的id
@property(nonatomic, copy) NSString *preBackUpSelectedEffectIdentifier;//备份之前的id
@property(nonatomic, assign) BOOL afterBackUpIsModified;//备份之后是否有修改storyboard
@property(nonatomic, assign) NSInteger backUpWhenUndoStackCount;//备份的时候UndoStack Count
@property(nonatomic, assign) BOOL needCheckWorkspaceIsModefy;//是否需要检测工程被修改过
@property (nonatomic, strong) XYStoryboardModel *preBackUpStbModel;//备份之前的storyboard
@property (nonatomic, copy) NSArray <XYClipModel *> *preBackUpClipList;
@property (nonatomic, copy) NSDictionary *preBackUpEffectMapData;

//当前reload 出来的数据
@property (nonatomic, strong) XYStoryboardModel *currentStbModel;//备份之前的storyboard
@property (nonatomic, copy) NSArray <XYClipModel *> *currentClipList;
@property (nonatomic, copy) NSDictionary *currentEffectMapData;
@end

NS_ASSUME_NONNULL_END
