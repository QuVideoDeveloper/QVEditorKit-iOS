//
//  UIDevice+XYInfo.m
//  XYBase
//
//  Created by robbin on 2019/3/25.
//

#import "UIDevice+XYInfo.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AdSupport/AdSupport.h>
#include <mach/mach.h>
#import "NSString+XYUUID.h"

@import CoreTelephony;

@implementation UIDevice (XYInfo)

- (NSString *)xy_macAddressString {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char *)malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [macString copy];
}

- (NSString *)xy_IDFAString {
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }else{
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }else{
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }else{
                if(asIM.advertisingTrackingEnabled){
                    return [[asIM.advertisingIdentifier UUIDString] copy];
                }else{
                    return [[asIM.advertisingIdentifier UUIDString] copy];
                }
            }
        }
    }
}

- (NSString *)xy_IDFVString {
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[[UIDevice currentDevice].identifierForVendor UUIDString] copy];
    }
    
    return @"";
}

- (BOOL)xy_isSimulator {
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

- (BOOL)xy_isJailbroken {
    if ([self xy_isSimulator]) return NO; // Dont't check simulator
    
    // iOS9 URL Scheme query changed ...
    // NSURL *cydiaURL = [NSURL URLWithString:@"cydia://package"];
    // if ([[UIApplication sharedApplication] canOpenURL:cydiaURL]) return YES;
    
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString xy_UUIDString]];
    if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    return NO;
}

- (NSString *)xy_machineModel {
    static dispatch_once_t one;
    static NSString *model;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        model = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return model;
}

- (NSString *)xy_machineModelName {
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        NSString *model = [self xy_machineModel];
        if (!model) return;
        NSDictionary *dic = @{
                              @"Watch1,1" : @"Apple Watch 38mm",
                              @"Watch1,2" : @"Apple Watch 42mm",
                              
                              @"Watch2,6" : @"Apple Watch Series 1 38mm",
                              @"Watch2,7" : @"Apple Watch Series 1 42mm",
                              
                              @"Watch2,3" : @"Apple Watch Series 2 38mm",
                              @"Watch2,4" : @"Apple Watch Series 2 42mm",
                              
                              @"Watch3,1" : @"Apple Watch Series 3 38mm",
                              @"Watch3,2" : @"Apple Watch Series 3 42mm",
                              @"Watch3,3" : @"Apple Watch Series 3 38mm",
                              @"Watch3,4" : @"Apple Watch Series 3 42mm",
                              
                              @"Watch4,1" : @"Apple Watch Series 4 40mm",
                              @"Watch4,2" : @"Apple Watch Series 4 44mm",
                              @"Watch4,3" : @"Apple Watch Series 4 40mm",
                              @"Watch4,4" : @"Apple Watch Series 4 44mm",
                              
                              
                              @"iPod1,1" : @"iPod touch 1",
                              @"iPod2,1" : @"iPod touch 2",
                              @"iPod3,1" : @"iPod touch 3",
                              @"iPod4,1" : @"iPod touch 4",
                              @"iPod5,1" : @"iPod touch 5",
                              @"iPod7,1" : @"iPod touch 6",
                              @"iPod9,1" : @"iPod touch 7",
                              
                              @"iPhone1,1" : @"iPhone 1G",
                              @"iPhone1,2" : @"iPhone 3G",
                              @"iPhone2,1" : @"iPhone 3GS",
                              @"iPhone3,1" : @"iPhone 4 (GSM)",
                              @"iPhone3,2" : @"iPhone 4",
                              @"iPhone3,3" : @"iPhone 4 (CDMA)",
                              @"iPhone4,1" : @"iPhone 4S",
                              @"iPhone5,1" : @"iPhone 5",
                              @"iPhone5,2" : @"iPhone 5",
                              @"iPhone5,3" : @"iPhone 5c",
                              @"iPhone5,4" : @"iPhone 5c",
                              @"iPhone6,1" : @"iPhone 5s",
                              @"iPhone6,2" : @"iPhone 5s",
                              @"iPhone7,1" : @"iPhone 6 Plus",
                              @"iPhone7,2" : @"iPhone 6",
                              @"iPhone8,1" : @"iPhone 6s",
                              @"iPhone8,2" : @"iPhone 6s Plus",
                              @"iPhone8,4" : @"iPhone SE",
                              @"iPhone9,1" : @"iPhone 7",
                              @"iPhone9,2" : @"iPhone 7 Plus",
                              @"iPhone9,3" : @"iPhone 7",
                              @"iPhone9,4" : @"iPhone 7 Plus",
                              @"iPhone10,1" : @"iPhone 8",
                              @"iPhone10,4" : @"iPhone 8",
                              @"iPhone10,2" : @"iPhone 8 Plus",
                              @"iPhone10,5" : @"iPhone 8 Plus",
                              @"iPhone10,3" : @"iPhone X"     ,
                              @"iPhone10,6" : @"iPhone X"     ,
                              @"iPhone11,8" : @"iPhone XR"    ,
                              @"iPhone11,2" : @"iPhone XS"    ,
                              @"iPhone11,6" : @"iPhone XS Max",
                              @"iPhone12,1" : @"iPhone 11",
                              @"iPhone12,3" : @"iPhone 11 Pro",
                              @"iPhone12,5" : @"iPhone 11 Pro Max",
                              
                              @"iPad1,1" : @"iPad 1",
                              @"iPad2,1" : @"iPad 2 (WiFi)",
                              @"iPad2,2" : @"iPad 2 (GSM)",
                              @"iPad2,3" : @"iPad 2 (CDMA)",
                              @"iPad2,4" : @"iPad 2",
                              @"iPad3,1" : @"iPad 3 (WiFi)",
                              @"iPad3,2" : @"iPad 3 (4G)",
                              @"iPad3,3" : @"iPad 3 (4G)",
                              @"iPad3,4" : @"iPad 4",
                              @"iPad3,5" : @"iPad 4",
                              @"iPad3,6" : @"iPad 4",
                              @"iPad6,11" : @"iPad (5th generation)",
                              @"iPad6,12" : @"iPad (5th generation)",
                              @"iPad7,5"  : @"iPad (6th generation)",
                              @"iPad7,6"  : @"iPad (6th generation)",
                              @"iPad7,11"  : @"iPad (7th generation)",
                              @"iPad7,12"  : @"iPad (7th generation)",
                              
                              @"iPad2,5" : @"iPad mini 1",
                              @"iPad2,6" : @"iPad mini 1",
                              @"iPad2,7" : @"iPad mini 1",
                              @"iPad4,4" : @"iPad mini 2",
                              @"iPad4,5" : @"iPad mini 2",
                              @"iPad4,6" : @"iPad mini 2",
                              @"iPad4,7" : @"iPad mini 3",
                              @"iPad4,8" : @"iPad mini 3",
                              @"iPad4,9" : @"iPad mini 3",
                              @"iPad5,1" : @"iPad mini 4",
                              @"iPad5,2" : @"iPad mini 4",
                              @"iPad11,1" : @"iPad mini (5th generation)",
                              @"iPad11,2" : @"iPad mini (5th generation)",
                             
                              @"iPad6,3" : @"iPad Pro (9.7 inch)",
                              @"iPad6,4" : @"iPad Pro (9.7 inch)",
                              @"iPad6,7" : @"iPad Pro (12.9 inch)",
                              @"iPad6,8" : @"iPad Pro (12.9 inch)",
                              @"iPad7,1"  : @"iPad Pro (12.9-inch) (2nd generation)"      ,
                              @"iPad7,2"  : @"iPad Pro (12.9-inch) (2nd generation)"      ,
                              @"iPad7,3"  : @"iPad Pro (10.5-inch)"                       ,
                              @"iPad7,4"  : @"iPad Pro (10.5-inch)"                       ,
                              @"iPad8,1"  : @"iPad Pro (11-inch)"                         ,
                              @"iPad8,2"  : @"iPad Pro (11-inch)"                         ,
                              @"iPad8,3"  : @"iPad Pro (11-inch)"                         ,
                              @"iPad8,4"  : @"iPad Pro (11-inch)"                         ,
                              @"iPad8,5"  : @"iPad Pro (12.9-inch) (3rd generation)"      ,
                              @"iPad8,6"  : @"iPad Pro (12.9-inch) (3rd generation)"      ,
                              @"iPad8,7"  : @"iPad Pro (12.9-inch) (3rd generation)"      ,
                              @"iPad8,8"  : @"iPad Pro (12.9-inch) (3rd generation)"      ,
                              
                              @"iPad4,1" : @"iPad Air",
                              @"iPad4,2" : @"iPad Air",
                              @"iPad4,3" : @"iPad Air",
                              @"iPad5,3" : @"iPad Air 2",
                              @"iPad5,4" : @"iPad Air 2",
                              @"iPad11,3" : @"iPad Air (3rd generation)",
                              @"iPad11,4" : @"iPad Air (3rd generation)",
                              
                              
                              @"AppleTV2,1" : @"Apple TV 2",
                              @"AppleTV3,1" : @"Apple TV 3",
                              @"AppleTV3,2" : @"Apple TV 3",
                              @"AppleTV5,3" : @"Apple TV 4",
                              
                              @"i386" : @"Simulator x86",
                              @"x86_64" : @"Simulator x64",
                              };
        name = dic[model];
        if (!name) name = model;
    });
    return name;
}

- (NSString *)xy_cellularProvicerName {
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc]init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    NSString *cellularProviderName = [carrier carrierName];
    return cellularProviderName;
}

- (BOOL)xy_is64Bit {
#if defined(__LP64__) && __LP64__
    return YES;
#else
    return NO;
#endif
}

- (int64_t)xy_diskSpace {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)xy_diskSpaceFree {
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) return -1;
    int64_t space =  [[attrs objectForKey:NSFileSystemFreeSize] longLongValue];
    if (space < 0) space = -1;
    return space;
}

- (int64_t)xy_diskSpaceUsed {
    int64_t total = self.xy_diskSpace;
    int64_t free = self.xy_diskSpaceFree;
    if (total < 0 || free < 0) return -1;
    int64_t used = total - free;
    if (used < 0) used = -1;
    return used;
}

- (int64_t)xy_memoryTotal {
    int64_t mem = [[NSProcessInfo processInfo] physicalMemory];
    if (mem < -1) mem = -1;
    return mem;
}

- (int64_t)xy_memoryUsed {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
}

- (int64_t)xy_memoryFree {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t page_size;
    vm_statistics_data_t vm_stat;
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    if (kern != KERN_SUCCESS) return -1;
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    if (kern != KERN_SUCCESS) return -1;
    return vm_stat.free_count * page_size;
}

- (int64_t)xy_weUseMemory {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        NSLog(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    return memoryUsageInByte;
}

@end
