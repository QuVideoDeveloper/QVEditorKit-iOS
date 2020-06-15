//
//  XYAMVELoadStoryboardDataDelegateToBlock.h
//  Pods
//
//  Created by darren on 2020/3/5.
//

#import <Foundation/Foundation.h>
#import <XYCommonEngine/CXiaoYingInc.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LOAD_DATA_COMPLETE_BLOCK)(MRESULT errCode);

@interface XYAMVELoadStoryboardDataDelegateToBlock : NSObject <AMVESessionStateDelegate>

@property (nonatomic, copy) LOAD_DATA_COMPLETE_BLOCK storyboardLoadCompleteBlock;

@end

NS_ASSUME_NONNULL_END
