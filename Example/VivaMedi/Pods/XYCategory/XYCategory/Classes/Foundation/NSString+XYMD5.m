//
//  NSString+XYMD5.m
//  XYCategory
//
//  Created by robbin on 2019/6/24.
//

#import "NSString+XYMD5.h"
#import "NSData+XYMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (XYMD5)

- (NSString *)xy_MD5String {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] xy_MD5String];
}

+ (NSString*)xy_MD5ForFile:(NSString*)filePath {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (handle== nil) return nil; // file didnt exist
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done) {
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

@end
