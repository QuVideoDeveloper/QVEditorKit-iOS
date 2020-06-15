//
//  UIImage+QVMediCamera".m
//  QVMediCamera"
//
//  Created by irobbin1024 on 06/10/2020.
//
#import <XYCategory/XYCategory.h>

@implementation UIImage (XYVivaGuide)

+ (UIImage *)QVMediCameraImageNamed:(NSString *)imageName {
    UIImage * image = [UIImage xy_imageWithName:imageName bundleName:@"QVMediCamera"];
    NSAssert(image, @"image 不能为空");
    return image;
}

@end
