//
//  XYBaseProjectTask.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/23.
//

#import <Foundation/Foundation.h>
#import "XYBaseEngineTask.h"
#import "XYQprojectModel.h"
#import "XYStoryboard.h"
#import "XYStoryboard+XYEffect.h"
#import "XYStoryboard+XYClip.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBaseProjectTask : XYBaseEngineTask
@property (nonatomic, strong) XYQprojectModel *projectModel;
@end

NS_ASSUME_NONNULL_END
