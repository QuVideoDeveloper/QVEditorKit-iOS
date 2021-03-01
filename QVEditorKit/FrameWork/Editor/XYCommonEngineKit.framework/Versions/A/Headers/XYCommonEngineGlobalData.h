//
//  XYCommonEngineGlobalData.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import "XYEngineWorkspaceConfiguration.h"

@class XYAdjustItem;

NS_ASSUME_NONNULL_BEGIN


@interface XYCommonEngineGlobalData : NSObject

@property (nonatomic, strong) XYEngineWorkspaceConfiguration *configModel;
@property(nonatomic, assign) CGRect playbackViewFrame;//播放器的viewframe
@property (nonatomic, copy) NSArray <XYAdjustItem *> *adjustItems;// 参数调节等
+ (XYCommonEngineGlobalData *)data;


+ (void)clean;

@end

NS_ASSUME_NONNULL_END
