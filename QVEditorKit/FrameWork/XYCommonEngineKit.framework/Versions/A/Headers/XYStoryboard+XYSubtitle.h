//
//  XYStoryboard+XYSubtitle.h
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/8/2.
//

#import "XYStoryboard.h"

@interface XYStoryboard (XYSubtitle)


/**
 获取用在Storyboard上的所有文字，比如：主题上的文字，字幕等

 @return 字符串数组
 */
- (NSArray<NSString *> *)storyboardSubtitleAllTexts;

@end
