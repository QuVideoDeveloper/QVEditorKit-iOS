//
//  XYAudioPCMDataManager.h
//  XYVivaEditor
//
//  Created by yitezh on 2020/7/31.
//

#import <Foundation/Foundation.h>
#import "XYAudioExtractorModel.h"
#import "XYAudioExtractConfig.h"
@interface XYAudioPCMDataManager : NSObject

- (void)getVoicePCMData:(XYAudioExtractConfig *)config idengtify:(NSString *)identify completeBlock:(ExtraCompleteBlock)block;

+ (instancetype)sharedManager;

- (void)destoryManager;

@end


