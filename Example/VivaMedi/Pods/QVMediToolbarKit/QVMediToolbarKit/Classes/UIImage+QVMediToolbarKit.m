//
//  UIImage+QVMediToolbarKit".m
//  QVMediToolbarKit"
//
//  Created by irobbin1024 on 06/10/2020.
//
#import <XYCategory/XYCategory.h>

@implementation UIImage (XYVivaGuide)

+ (UIImage *)QVMediToolbarKitImageNamed:(NSString *)imageName {
    UIImage * image = [UIImage xy_imageWithName:imageName bundleName:@"QVMediToolbarKit"];
    NSAssert(image, @"image 不能为空");
    return image;
}

@end
