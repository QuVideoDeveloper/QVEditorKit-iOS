//
//  UIApplication+XYAppInfo.h
//  XYBase
//
//  Created by robbin on 2019/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (XYAppInfo)

@property (readonly, copy) NSString * xy_appName;
@property (readonly, copy) NSString * xy_appVersion;
@property (readonly, copy) NSString * xy_appBuildVersion;

@end

NS_ASSUME_NONNULL_END
