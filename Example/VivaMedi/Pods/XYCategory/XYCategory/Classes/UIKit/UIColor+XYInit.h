//
//  UIColor+XYInit.h
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef XYColorWithHEX
#define XYColorWithHEX(_hex_)   [UIColor xy_colorWithHex:_hex_]
#endif

@interface UIColor (XYInit)

/**
 根据十六进制返回颜色值

 @param hexValue 十六进制值，0xffffff
 @param alphaValue 透明度，0-1.0
 @return 颜色值
 */
+ (UIColor *)xy_colorWithHEX:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

/**
 根据十六进制返回颜色值

 @param hexValue hexValue 十六进制值，0xffffff
 @return 颜色值
 */
+ (UIColor *)xy_colorWithHEX:(NSInteger)hexValue;


///  根据十六进制返回颜色值，Alpha值默认FF
/// @param hexValue 十六进制值，0x000000
+ (UIColor *)xy_colorWithHexRGB:(NSInteger)hexValue;

///  根据带Alpha值的十六进制返回颜色值
/// @param hexValue 十六进制值，0xFF000000
+ (UIColor *)xy_colorWithHexARGB:(NSInteger)hexValue;


/// 根据UIColor返回不带Alpha位十六进制颜色值
/// @param color 系统颜色
+ (NSInteger)xy_hexRGBWithColor:(UIColor *)color;

/// 根据UIColor返回带Alphga位的十六进制颜色值
/// @param color 系统颜色
+ (NSInteger)xy_hexARGBWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
