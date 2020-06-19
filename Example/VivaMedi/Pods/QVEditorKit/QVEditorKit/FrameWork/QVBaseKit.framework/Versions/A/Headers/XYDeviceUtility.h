//
//  XYDeviceUtils.h
//  XiaoYing
//
//  Created by xuxinyuan on 13-4-28.
//  Copyright (c) 2013年 XiaoYing Team. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XYMemoryUsageInfo : NSObject

@property (nonatomic) float usage;//已用内存(MB)
@property (nonatomic) float total;//总内存(MB)
@property (nonatomic) float ratio;//占用比率

@property (nonatomic, copy) NSString *usageString;
@property (nonatomic, copy) NSString *totalString;
@property (nonatomic, copy) NSString *ratioString;

@end

@interface XYDeviceUtility : NSObject

+ (NSString *)openUDID;
+ (NSString *)advertisingIdentifier;
+ (NSString *)localizedModel;
+ (NSString *)systemVersion;
+ (NSString *)systemName;
+ (NSString *)fullSystemName;
+ (NSString *)model;
+ (NSString *)fullModel;
+ (NSString *)umuid;
+ (NSString *)xiaoyingID;
+ (NSString *)cellularProviderName;
+ (NSString *)getReadableDeviceName;
+ (long long)freeDiskSpaceInBytes;
+ (XYMemoryUsageInfo *)memoryUsageInfo;
+ (NSString *)fullLanguage;
+ (NSString *)pushLanguage;
+ (NSString *)fullLanguageWithCountry;
+ (BOOL)is64bit;
+ (NSString *)getXiaoYingAppKey;
+ (int)getAppKeyVersionCode;
+ (BOOL)isEqualOrThan5s;
+ (BOOL)isEqualOrThan6s;
+ (BOOL)isEqualOrThan7;
+ (BOOL)isDiskSpaceEnoughForExporting:(unsigned int)fileSize;
+ (BOOL)isTestVersion;
+ (BOOL)isChinese;
+ (BOOL)isHaveEnoughDiskSpace;
+ (BOOL)isPerformanceEqualOrGreaterThan5s;
+ (NSDictionary *)deviceInfo;
@end
