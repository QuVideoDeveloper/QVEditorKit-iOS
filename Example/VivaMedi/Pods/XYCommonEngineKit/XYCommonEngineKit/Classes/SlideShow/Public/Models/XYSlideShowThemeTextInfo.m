//
//  XYSlideShowThemeTextInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import "XYSlideShowThemeTextInfo.h"
#import "CXiaoYingTextAnimationInfo.h"

@implementation XYSlideShowThemeTextInfo

- (UInt32)position
{
    return _textAnimationInfo.muiPosition;
}

- (NSString *)text
{
    return _textAnimationInfo.mpStrText;
}

- (void)setText:(NSString *)text
{
    _textAnimationInfo.mpStrText = text;
}

- (NSString *)defaultText
{
    return _textAnimationInfo.mpStrDefText;
}

- (NSString *)fontName
{
    return _textAnimationInfo.mpStrFontPath;
}

- (BOOL)editable
{
    return _textAnimationInfo.muiTextEditable;
}

- (instancetype)initWithTextAnimationInfo:(CXiaoYingTextAnimationInfo *)textAnimationInfo
{
    self = [super init];
    if (self) {
        _textAnimationInfo = textAnimationInfo;
    }
    return self;
}

@end
