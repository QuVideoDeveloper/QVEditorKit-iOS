//
//  UIImage+XYInit.m
//  XYCategory
//
//  Created by robbin on 2019/6/20.
//

#import "NSBundle+QVMedi.h"

@implementation UIImage (QVMedi)

+ (UIImage *)qvmedi_imageWithName:(NSString *)imageName bundleName:(NSString *)bundleName {
    UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle qvmedi_bundleWithBundleName:bundleName] compatibleWithTraitCollection:nil];
    if (!image) { 
        image = [UIImage imageNamed:imageName];
    }
    return image;
}

@end
