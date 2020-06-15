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

@property (nonatomic, readonly) NSInteger position;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong, readonly) NSString *defaultText;
@property (nonatomic, strong, readonly) NSString *fontName;
@property (nonatomic, readonly) BOOL editable;

- (instancetype)initWithTextAnimationInfo:(CXiaoYingTextAnimationInfo *)textAnimationInfo;

@end
