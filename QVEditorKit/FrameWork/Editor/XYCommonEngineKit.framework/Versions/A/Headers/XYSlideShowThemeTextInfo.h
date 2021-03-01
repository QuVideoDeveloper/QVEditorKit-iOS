//
//  XYSlideShowThemeTextInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//


#import <Foundation/Foundation.h>

@class CXiaoYingTextAnimationInfo;

@interface XYSlideShowThemeTextInfo : NSObject

@property (strong, nonatomic) CXiaoYingTextAnimationInfo *textAnimationInfo;

/// 文本
@property (nonatomic, copy) NSString *text;

/// 默认文本
@property (nonatomic, strong, readonly) NSString *defaultText;

/// 字体
@property (nonatomic, strong, readonly) NSString *fontName;

/// 是否可以编辑
@property (nonatomic, readonly) BOOL editable;

/// 在播放器stremSize的中心点
@property (nonatomic, readonly) CGPoint point;

/// 在播放器stremSize的宽高
@property (nonatomic, readonly) CGSize size;

- (instancetype)initWithTextAnimationInfo:(CXiaoYingTextAnimationInfo *)textAnimationInfo;

@end
