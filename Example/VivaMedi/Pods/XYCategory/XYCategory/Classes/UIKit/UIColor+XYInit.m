//
//  UIColor+XYInit.m
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import "UIColor+XYInit.h"

@implementation UIColor (XYInit)

+ (UIColor *)xy_colorWithHEX:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:alphaValue];
}

+ (UIColor *)xy_colorWithHEX:(NSInteger)hexValue {
    return [UIColor xy_colorWithHEX:hexValue alpha:1.0];
}



+ (UIColor *)xy_colorWithHexRGB:(NSInteger)hexValue {
    hexValue = hexValue | 0xFF000000;
    return [UIColor xy_colorWithHexARGB:hexValue];
}

+ (UIColor *)xy_colorWithHexARGB:(NSInteger)hexValue {
    CGFloat alpha = ((float)((hexValue & 0xFF000000) >> 24))/255.0;
    CGFloat red = ((float)((hexValue & 0xFF0000) >> 16))/255.0;
    CGFloat green = ((float)((hexValue & 0xFF00) >> 8))/255.0;
    CGFloat blue = ((float)(hexValue & 0xFF))/255.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+ (NSInteger)xy_hexRGBWithColor:(UIColor *)color {
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    NSString *hexString = [NSString stringWithFormat:@"0xFF%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255)];
    NSInteger result = strtoul([hexString UTF8String], 0, 16);
    return result;
}

+ (NSInteger)xy_hexARGBWithColor:(UIColor *)color {
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    NSString *hexString = [NSString stringWithFormat:@"0x%02lX%02lX%02lX%02lX", lroundf(alpha * 255), lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255)];
    NSInteger result = strtoul([hexString UTF8String], 0, 16);
    return result;
}

@end
