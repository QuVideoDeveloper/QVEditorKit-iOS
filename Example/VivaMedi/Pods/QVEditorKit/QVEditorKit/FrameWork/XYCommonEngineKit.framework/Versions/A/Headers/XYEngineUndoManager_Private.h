//
//  XYEngineUndoManager_Private.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/20.
//

#ifndef XYEngineUndoManager_Private_h
#define XYEngineUndoManager_Private_h

@class XYEnginePlayerView;

@interface XYEngineUndoMgr()

@property (nonatomic, strong) NSMutableArray <XYEngineUndoManagerModule *> *undoStack;
@property (nonatomic, strong) NSMutableArray <XYEngineUndoManagerModule *> *redoStack;


@property (nonatomic, strong) XYReactBlackMapBoard *engineBlackBoard;//undo redo 更新undo redo btn
@property (nonatomic, strong) XYReactBlackMapBoard *undoDataBoard;//一一对应

@property (nonatomic, strong) XYEngineUndoManagerModule *stackCurrentUsingModel;
@property (nonatomic, strong) XYEngineUndoManagerModule *presetInsertStackModel;//预置一个 将要加入的undo 队列里



- (void)reSetEngine:(XYEngineUndoManagerModule *)doModel;

- (void)eventIsUndo:(BOOL)isUndo actionValue:(NSString *)actionValue;

@end

#endif /* XYEngineUndoManager_Private_h */
