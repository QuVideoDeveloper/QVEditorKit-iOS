//
//  NSString+XYFileManager.m
//  XiaoYing
//
//  Created by hongru qi on 2016/12/14.
//  Copyright © 2016年 XiaoYing. All rights reserved.
//

#import "NSString+XYFileManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>

@implementation NSString (XYFileManager)

+ (NSString *)xy_getFileName:(NSString *)filePath
{
    NSString *fileName = [filePath lastPathComponent];
    return fileName;
}

+ (NSString *)xy_getFileNameWithoutExtension:(NSString *)filePath
{
    NSString *fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
    return fileName;
}

+ (NSString *)xy_getFileExtension:(NSString *)filePath
{
    NSString *ext = [filePath pathExtension];
    return ext;
}

+(NSString*)xy_md5ForFile:(NSString*)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if( handle== nil ) return @"ERROR GETTING FILE MD5"; // file didnt exist
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 1024];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}


+ (NSString *)xy_registerFont_old:(NSString*)path
{
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    if(data == nil){
        NSLog(@"Failed to load font. Data at path is null");
        return nil;
    }
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    if (provider == nil) {
        return nil;
    }
    
    //IOS-1388	【启动-白屏现象】杀掉进程启动APP时，会偶现一直显示白屏，无法正常进入小影的现象
    //IOS-1379	【字体】iOS10用户有一定几率在App启动注册字体时闪退
    //http://stackoverflow.com/questions/24900979/cgfontcreatewithdataprovider-hangs-in-airplane-mode
    [UIFont familyNames];
    
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (font == nil) {
        CFRelease(provider);
        return nil;
    }
    
    if(!CTFontManagerRegisterGraphicsFont(font, &error)){
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    NSString *fontName = (__bridge NSString *)CGFontCopyPostScriptName(font);
    
    CGFontRelease(font);
    CFRelease(provider);
    
    //if [UIFont fontWithName:size:] return a non-nil font object, we think as register succeed, no matter if CTFontManagerRegisterGraphicsFont() return true.
    if ([UIFont fontWithName:fontName size:12]) {
        NSLog(@"registed fontName: %@", fontName);
        return fontName;
    }else{
        return nil;
    }
}

+ (NSString *)xy_registerFont:(NSString*)path
{
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

@end
