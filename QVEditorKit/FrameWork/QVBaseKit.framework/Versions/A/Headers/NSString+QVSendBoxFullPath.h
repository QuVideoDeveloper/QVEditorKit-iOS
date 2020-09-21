//
//  NSString+SendBoxFullPath.h
//  Pods
//
//  Created by hongru qi on 2017/3/9.
//
//

#import <Foundation/Foundation.h>

@interface NSString (QVSendBoxFullPath)

- (NSString *)qv_toDocumentFullPath;
- (NSString *)qv_toDocumentRelativePath;
- (NSString *)qv_toBundleFullPath;
- (NSString *)qv_toBundleRelativePath;
- (NSString *)qv_toTemplateFullPath;
- (NSString *)qv_toTemplateRelativePath;
- (BOOL)qv_isPrivatePathTemplate;
- (NSString *)qv_toReplaceAppRootPath;

- (NSString *)qv_toAppRelativePath;
- (NSString *)qv_toAppFullPath;

- (BOOL)qv_containsString:(NSString *)aString;

@end
