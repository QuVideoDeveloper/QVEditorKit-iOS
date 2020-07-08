//
//  UINib+XYInit.h
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINib (XYInit)

/**
 获取一个Nib实例
 
 @param name nib的名字
 @param bundleName bundle的名字
 @return nib实例
 */
+ (UINib *)xy_nibWithNibName:(NSString *)name bundleName:(NSString * __nullable)bundleName;


/**
 从nib中获取一个UIView实例
 
 @param name nib的名字
 @param bundleNam bundle的名字
 @return UIView实例
 */
+ (id)xy_uniqueViewWithNibName:(NSString *)name bundleName:(NSString * __nullable)bundleNam;

@end

NS_ASSUME_NONNULL_END
