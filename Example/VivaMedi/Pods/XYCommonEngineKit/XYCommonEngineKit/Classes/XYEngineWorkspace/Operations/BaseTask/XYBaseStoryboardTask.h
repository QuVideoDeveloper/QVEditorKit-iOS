//
//  XYBaseStoryboardTask.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYBaseEngineTask.h"
#import "XYStoryboardModel.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYEffect.h"
#import "XYStoryboard+XYClip.h"


NS_ASSUME_NONNULL_BEGIN

@interface XYBaseStoryboardTask : XYBaseEngineTask

@property(nonatomic, strong) XYStoryboardModel *storyboardModel;

@end

NS_ASSUME_NONNULL_END
