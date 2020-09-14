//
//  XYAudioExtractorModel.h
//  XYVivaEditor
//
//  Created by yitezh on 2020/8/3.
//

#import <Foundation/Foundation.h>
#import <XYCommonEngine/CXiaoYingInc.h>
#import <XYCommonEngine/CXiaoYingEngine.h>
#import "XYEngine.h"

typedef void(^ExtraCompleteBlock)(NSMutableArray *dataArray,NSString *taskId);

@interface XYAudioExtractorModel : NSObject

@property(strong, nonatomic) NSString *identify;

@property(strong, nonatomic) ExtraCompleteBlock completeBlock;

@property(strong, nonatomic) ExtraCompleteBlock callBackBlock;

@property(strong, nonatomic) QPCMExtractor *pcmExtractor;

@property(strong, nonatomic) NSMutableArray *dataArray;

@end

