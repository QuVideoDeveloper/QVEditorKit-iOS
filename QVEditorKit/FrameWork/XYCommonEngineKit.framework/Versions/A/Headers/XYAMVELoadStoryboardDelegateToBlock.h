//
//  XYAMVELoadStoryboardDelegateToBlock.h
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/13.
//

#import "CXiaoYingInc.h"
#import <Foundation/Foundation.h>

typedef void (^LOAD_COMPLETE_BLOCK)(MRESULT errCode);

@interface XYAMVELoadStoryboardDelegateToBlock : NSObject <AMVESessionStateDelegate>

@property (nonatomic, strong) LOAD_COMPLETE_BLOCK storyboardLoadCompleteBlock;
@property (nonatomic, copy) NSString *projectFilePath;
@property (nonatomic) BOOL isClipMissing;
@property (nonatomic) BOOL isTemplateMissing;

@end
