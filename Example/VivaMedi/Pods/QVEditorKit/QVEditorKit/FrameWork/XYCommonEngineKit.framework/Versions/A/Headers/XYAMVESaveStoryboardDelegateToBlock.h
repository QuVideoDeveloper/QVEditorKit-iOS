//
//  XYAMVESaveStoryboardDelegateToBlock.h
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/13.
//

#import <XYCommonEngine/CXiaoYingInc.h>
#import <Foundation/Foundation.h>

typedef void (^SAVE_COMPLETE_BLOCK)(MRESULT result);

@interface XYAMVESaveStoryboardDelegateToBlock : NSObject <AMVESessionStateDelegate>

@property (nonatomic, strong) SAVE_COMPLETE_BLOCK storyboardSaveCompleteBlock;
@property (nonatomic, copy) NSString *projectFilePath;

@end
