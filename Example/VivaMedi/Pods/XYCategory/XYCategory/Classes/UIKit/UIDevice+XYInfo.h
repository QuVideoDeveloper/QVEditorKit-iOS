//
//  UIDevice+XYInfo.h
//  XYBase
//
//  Created by robbin on 2019/3/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (XYInfo)

@property (readonly, nonatomic) NSString * xy_macAddressString;
@property (readonly, nonatomic) NSString * xy_IDFAString;
@property (readonly, nonatomic) NSString * xy_IDFVString;

@property (readonly, nonatomic) BOOL xy_isJailbroken;
@property (readonly, nonatomic, nullable) NSString * xy_machineModel; // iPhone6,2
@property (readonly, nonatomic, nullable) NSString * xy_machineModelName; // iPhone 5s
@property (readonly, nonatomic) NSString * xy_cellularProvicerName;
@property (readonly, nonatomic) BOOL xy_is64Bit;

//=============================== Disk Space ===========================================

/**
 Total disk space in byte. (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t xy_diskSpace;

/**
 Free disk space in byte. (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t xy_diskSpaceFree;

/**
 Used disk space in byte. (-1 when error occurs)
 */
@property (nonatomic, readonly) int64_t xy_diskSpaceUsed;

//=============================== Memory Information ===========================================

/// Total physical memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xy_memoryTotal;

/// Used (active + inactive + wired) memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xy_memoryUsed;

/// Free memory in byte. (-1 when error occurs)
@property (nonatomic, readonly) int64_t xy_memoryFree;

@property (nonatomic, readonly) int64_t xy_weUseMemory;

@end

NS_ASSUME_NONNULL_END
