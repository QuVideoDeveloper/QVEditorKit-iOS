//
//  NSString+SendBoxFullPath.h
//  Pods
//
//  Created by hongru qi on 2017/3/9.
//
//

#import <Foundation/Foundation.h>

@interface NSString (SendBoxFullPath)

- (NSString *)xy_toDocumentFullPath;
- (NSString *)xy_toDocumentRelativePath;
- (NSString *)xy_toBundleFullPath;
- (NSString *)xy_toBundleRelativePath;
- (NSString *)xy_toTemplateFullPath;
- (NSString *)xy_toTemplateRelativePath;
- (BOOL)xy_isPrivatePathTemplate;
- (NSString *)xy_toReplaceAppRootPath;

- (NSString *)xy_toAppRelativePath;
- (NSString *)xy_toAppFullPath;

- (BOOL)xy_containsString:(NSString *)aString;

@end
