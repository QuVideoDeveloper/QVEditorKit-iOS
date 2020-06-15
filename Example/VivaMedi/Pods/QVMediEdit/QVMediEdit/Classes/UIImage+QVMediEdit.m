//
//  UIImage+QVMediEdit".m
//  QVMediEdit"
//
//  Created by irobbin1024 on 06/02/2020.
//
#import <QVMediTools/UIImage+QVMedi.h>
#import "UIImage+QVMediEdit.h"

@implementation UIImage (QVMediEdit)

+ (UIImage *)QVMediEditImageNamed:(NSString *)imageName {
    UIImage * image = [UIImage qvmedi_imageWithName:imageName bundleName:@"QVMediEdit"];
    NSAssert(image, @"image 不能为空");
    return image;
}

@end
