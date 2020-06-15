//
//  XYSlideShowMusicModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/5/8.
//


#import "XYThemeTextScene.h"
#import "XYSlideShowThemeTextInfo.h"

@implementation XYThemeTextScene

- (instancetype)initWithPosition:(NSUInteger)position
{
    self = [super init];
    if (self) {
        _position = position;
        _themeTextInfoArray = [NSMutableArray<XYSlideShowThemeTextInfo *> array];
    }
    return self;
}

@end
