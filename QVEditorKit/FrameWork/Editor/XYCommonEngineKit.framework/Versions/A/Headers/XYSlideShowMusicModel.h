//
//  XYSlideShowMusicModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/5/8.
//

#import <Foundation/Foundation.h>

@class XYVeRangeModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYSlideShowMusicModel : NSObject

/// 音乐文件路径
@property (nonatomic, copy) NSString *musicFilePath;

/// 音乐的长度
@property (nonatomic, strong) XYVeRangeModel *destVeRange;

@end

NS_ASSUME_NONNULL_END
