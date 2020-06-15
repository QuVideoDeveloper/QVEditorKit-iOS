//
//  QVMediTools.m
//  FMDB
//
//  Created by robbin on 2020/6/10.
//

#import "QVMediTools.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AdSupport/AdSupport.h>
#include <mach/mach.h>
@import UIKit;

@implementation QVMediTools

+ (CGFloat)qv_safeAreaBottom {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    } else {
        return 0;
    }
}

+ (NSString *)idfa {
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

+ (NSString *)idfv {
    if([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[[UIDevice currentDevice].identifierForVendor UUIDString] copy];
    }
    
    return @"";
}

+ (NSString *)uuid {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}

@end
