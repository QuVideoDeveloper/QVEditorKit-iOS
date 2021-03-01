//
//  XYSlideShowMusicModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/5/8.
//


#import <Foundation/Foundation.h>

@class XYSlideShowThemeTextInfo;

@interface XYSlideShowThemeTextScene : NSObject

@property(nonatomic) NSUInteger position;

@property(nonatomic, strong) NSMutableArray<XYSlideShowThemeTextInfo *> *themeTextInfoArray;

- (instancetype)initWithPosition:(NSUInteger)position;

@end
