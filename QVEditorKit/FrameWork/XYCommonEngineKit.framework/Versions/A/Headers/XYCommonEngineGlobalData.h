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
@property (nonatomic, copy) NSString *effectDefaultTransFilePath;//删除clip时需要将默认的转场设置进来 用于删除转场
@property(nonatomic, assign) NSInteger transMinTime;

+ (XYCommonEngineGlobalData *)data;


+ (void)clean;

@end

NS_ASSUME_NONNULL_END
