//
//  UIImage+XYInit.m
//  XYCategory
//
//  Created by robbin on 2019/6/20.
//

#import "UIImage+XYInit.h"
#import "NSBundle+XYInit.h"

@implementation UIImage (XYInit)

+ (UIImage *)xy_imageWithName:(NSString *)imageName bundleName:(NSString *)bundleName {
    UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle xy_bundleWithBundleName:bundleName] compatibleWithTraitCollection:nil];
    if (!image) { // podBundle中无图片 去mainBundle中获取一份
        image = [UIImage imageNamed:imageName];
    }
    return image;
}

@end
