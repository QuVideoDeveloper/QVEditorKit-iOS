//
//  XYSegmentCallBackData.h
//  AFNetworking
//
//  Created by 夏澄 on 2021/1/5.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYSegmentCallBackData : NSObject

/// 人体分割检测的状态
@property (nonatomic, assign) XYSegmentState segmentState;

/// clip的路径
@property (nonatomic, copy) NSString *clipFilePath;

/// 人体分割预检测进度 值范围[0-1]
@property (nonatomic, assign) CGFloat progress;

@end

NS_ASSUME_NONNULL_END
