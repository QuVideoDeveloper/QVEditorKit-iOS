//
//  UIFont+XYLoad.m
//  XYBase
//
//  Created by robbin on 2019/3/21.
//

#import "UIFont+XYLoad.h"
#import <CoreText/CoreText.h>

@implementation UIFont (XYLoad)

+ (NSString *)xy_loadFontFromPath:(NSString *)path {
    @autoreleasepool
    {
        if (path.length <= 0) return nil;
        NSURL *fontUrl = [NSURL fileURLWithPath:path];
        if (!fontUrl) return nil;
        CGDataProviderRef provider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
        if (provider == nil) {
            return nil;
        }
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (font == nil) {
            CFRelease(provider);
            return nil;
        }
        CFErrorRef error;
        if (!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontUrl,kCTFontManagerScopeProcess,&error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        
        NSString *fontName = (__bridge NSString *)CGFontCopyPostScriptName(font);
        CGFontRelease(font);
        CFRelease(provider);
        if ([UIFont fontWithName:fontName size:12]) {
            NSLog(@"registed fontName: %@", fontName);
            return fontName;
        } else {
            return nil;
        }
    }
}

+ (void)xy_unloadFontFromPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    CTFontManagerUnregisterFontsForURL((__bridge CFTypeRef)url, kCTFontManagerScopeNone, NULL);
}


@end
