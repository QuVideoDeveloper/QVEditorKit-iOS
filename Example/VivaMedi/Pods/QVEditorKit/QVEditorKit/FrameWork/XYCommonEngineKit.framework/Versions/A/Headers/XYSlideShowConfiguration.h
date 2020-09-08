//
//  XYSlideShowConfiguration.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYSlideShowConfiguration : NSObject
/// 视频分辨率
@property (nonatomic) CGSize videoResolution;

/// 语言
@property (nonatomic, copy) NSString *language;

@end

NS_ASSUME_NONNULL_END
