//
//  XYAudioExtractConfig.h
//  XYVivaEditor
//
//  Created by yitezh on 2020/8/7.
//

#import <Foundation/Foundation.h>
#import "XYClipModel.h"
#import "XYEffectModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYAudioExtractConfig : NSObject

@property (strong, nonatomic)NSString *musicPath;
@property (assign, nonatomic)NSInteger startPosition;
@property (assign, nonatomic)NSInteger lenth;
@property (assign, nonatomic)BOOL isIgnoreCache;


+ (instancetype)defaultMusicConfigWithEffectModel:(XYEffectModel *)model;

+ (instancetype)defaultClipConfigWithClipModel:(XYClipModel *)model;

@end

NS_ASSUME_NONNULL_END
