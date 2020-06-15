//
//  XYCommonEngineGlobalData.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/4.
//

#import <Foundation/Foundation.h>
#import "XYEngineWorkspaceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN


@interface XYCommonEngineGlobalData : NSObject

@property (nonatomic, strong) XYEngineWorkspaceConfiguration *configModel;
@property(nonatomic, assign) CGRect playbackViewFrame;//播放器的viewframe

+ (XYCommonEngineGlobalData *)data;


+ (void)clean;

@end

NS_ASSUME_NONNULL_END
