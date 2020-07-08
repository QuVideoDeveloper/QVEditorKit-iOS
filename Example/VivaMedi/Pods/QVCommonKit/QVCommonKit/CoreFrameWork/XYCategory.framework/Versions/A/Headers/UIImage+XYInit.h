//
//  UIImage+XYInit.h
//  XYCategory
//
//  Created by robbin on 2019/6/20.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XYInit)

+ (UIImage *)xy_imageWithName:(NSString *)imageName bundleName:(NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END
