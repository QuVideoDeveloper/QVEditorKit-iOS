//
//  NSString+SendBoxFullPath.m
//  Pods
//
//  Created by hongru qi on 2017/3/9.
//
//

#import "NSString+SendBoxFullPath.h"

@implementation NSString (SendBoxFullPath)

+ (NSString*)xy_getAppPackageString
{
    //    NSLog(@"original path:%@",originalPath);
    NSString *appPackageString = [[[NSBundle mainBundle] resourcePath] lastPathComponent];
    return appPackageString;
}

+ (BOOL)xy_isAppBundlePath:(NSString*)srcPath
{
    NSString* appPackageString = [NSString xy_getAppPackageString];
    NSRange textRange =[srcPath rangeOfString:appPackageString];
    if(textRange.location != NSNotFound){
        return  YES;
    }
    return NO;
}

+ (BOOL)xy_isDemoPicsPath:(NSString*)srcPath
{
    NSRange textRange =[srcPath rangeOfString:@"/private/demoPics"];
    if(textRange.location != NSNotFound){
        return  YES;
    }
    return NO;
}

- (NSString *)xy_toReplaceAppRootPath
{
    if(![self hasPrefix:@"/"]){
        return self;
    }
    NSString *originalPath = self;
    NSString *fullPath;
    NSRange textRange;
    NSRange templateRange2;
    NSRange templateRange3;
    
    //for replace old template path to new template path
    textRange =[originalPath rangeOfString:@"/Library/Application Support/data/"];
    templateRange2 =[originalPath rangeOfString:@"/templates/"];
    templateRange3 =[originalPath rangeOfString:@"/newtemplates/"];
    if(textRange.location != NSNotFound && templateRange2.location != NSNotFound && templateRange3.location == NSNotFound)
    {
        //Found .../Documents,replace the .../Documents filePath
        NSString *newtemplates = [NSString stringWithFormat:@"%@/data/newtemplates",[NSString stringWithFormat:@"%@/Library/Application Support", NSHomeDirectory()]];
         
        NSString *templatePath = [NSString stringWithFormat:@"%@/",newtemplates];
        NSUInteger location = templateRange2.location;
        NSUInteger length = templateRange2.length;
        templateRange2.location = 0;
        templateRange2.length = location+length;
        fullPath = [originalPath stringByReplacingCharactersInRange:templateRange2 withString:templatePath];
        return  fullPath;
    }
    
    textRange =[originalPath rangeOfString:@"/Library/Application Support"];
    if(textRange.location != NSNotFound)
    {
        //Found .../Documents,replace the .../Documents filePath
        NSString *applicationSupport = [NSString stringWithFormat:@"%@/Library/Application Support", NSHomeDirectory()];
        NSUInteger location = textRange.location;
        NSUInteger length = textRange.length;
        textRange.location = 0;
        textRange.length = location+length;
        fullPath = [originalPath stringByReplacingCharactersInRange:textRange withString:applicationSupport];
        return  fullPath;
    }
    
    NSString* appPackageString = [NSString xy_getAppPackageString];
    textRange =[originalPath rangeOfString:appPackageString];
    if(textRange.location != NSNotFound)
    {
        NSLog(@"bundle resource convert!!!");
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSLog(@"bundlePath:%@",bundlePath);
        
        NSUInteger location = textRange.location;
        NSUInteger length = textRange.length;
        textRange.location = 0;
        textRange.length = location+length;
        fullPath = [originalPath stringByReplacingCharactersInRange:textRange withString:bundlePath];
        
        return  fullPath;
    }
    
    textRange =[originalPath rangeOfString:@"/Documents/private"];
    if(textRange.location != NSNotFound)
    {
        //Found .../Documents/private,replace to to bundle path
        //NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSUInteger location = textRange.location;
        NSUInteger length = textRange.length;
        textRange.location = 0;
        textRange.length = location+length;
        NSString *bundlePath = [NSString stringWithFormat:@"%@/private",[[NSBundle mainBundle] resourcePath]];
        fullPath = [originalPath stringByReplacingCharactersInRange:textRange withString:bundlePath];
        return  fullPath;
    }
    
    textRange =[originalPath rangeOfString:@"/Documents"];
    if(textRange.location != NSNotFound)
    {
        //Found .../Documents,replace the .../Documents filePath
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSUInteger location = textRange.location;
        NSUInteger length = textRange.length;
        textRange.location = 0;
        textRange.length = location+length;
        fullPath = [originalPath stringByReplacingCharactersInRange:textRange withString:documentsPath];
        return  fullPath;
    }
    
    return self;
}

- (NSString *)xy_toDocumentFullPath
{
    if(![self hasPrefix:@"/"]){
        return self;
    }
    NSString *originalPath = self;
    NSString *fullPath;
    //    NSLog(@"original path:%@",originalPath);
    if ([NSString xy_isDemoPicsPath:originalPath]) {
        NSLog(@"toDocumentFullPath originalPath:%@",originalPath);
        if ([NSString xy_isAppBundlePath:originalPath]) {
            fullPath = [self xy_toReplaceAppRootPath];
            return fullPath;
        }
        
        NSRange textRange =[originalPath rangeOfString:@"/Documents/private/demoPics"];
        if(textRange.location != NSNotFound){
            fullPath = [self xy_toReplaceAppRootPath];
            return fullPath;
        }
        
        fullPath = [self xy_toBundleFullPath];
        return fullPath;
    }
    
    
    NSRange textRange;
    textRange =[originalPath rangeOfString:@"/Documents"];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    
    if(textRange.location != NSNotFound)
    {
        //Found .../Documents,replace the .../Documents filePath
        NSUInteger location = textRange.location;
        NSUInteger length = textRange.length;
        textRange.location = 0;
        textRange.length = location+length;
        fullPath = [originalPath stringByReplacingCharactersInRange:textRange withString:documentsPath];
    }else{
        //Not found
        fullPath = [NSString stringWithFormat:@"%@%@",documentsPath,originalPath];
    }
    //    NSLog(@"full path:%@",fullPath);
    return fullPath;
}

- (NSString *)xy_toDocumentRelativePath
{
    NSString *originalPath = self;
    NSString *relativePath;
    
    //    NSLog(@"original path:%@",originalPath);
    if ([NSString xy_isAppBundlePath:originalPath]) {
        relativePath = [self xy_toBundleRelativePath];
        return relativePath;
    }
    
    NSRange textRange;
    textRange =[originalPath rangeOfString:@"/Documents"];
    if(textRange.location != NSNotFound)
    {
        //Found .../Documents,replace the .../Documents filePath
        NSUInteger location = textRange.location;
        NSUInteger length = textRange.length;
        textRange.location = 0;
        textRange.length = location+length;
        relativePath = [originalPath stringByReplacingCharactersInRange:textRange withString:@""];
    }else{
        //Not found
        relativePath = originalPath;
    }
    //    NSLog(@"relativePath path:%@",relativePath);
    return relativePath;
}

- (NSString *)xy_toAppRelativePath
{
    //full path like "/var/mobile/Containers/Data/Application/574BA205-404A-43DE-909D-E948260CA772/Library/Caches/"
    //we need get path after "/574BA205-404A-43DE-909D-E948260CA772"
    
    NSArray<NSString *> *pathComponentArray = [self pathComponents];
    NSInteger appUIDComponentIndex = -1;
    for (NSString *component in pathComponentArray) {
        if ([component isEqualToString:@"Documents"] || [component isEqualToString:@"Library"] || [component isEqualToString:@"tmp"]) {
            //get component index of "574BA205-404A-43DE-909D-E948260CA772" (before "Documents","Library" or "tmp")
            NSInteger index = [pathComponentArray indexOfObject:component] - 1;
            if (index >= 0 && index < pathComponentArray.count) {
                appUIDComponentIndex = index;
            }
        }
    }
    if (appUIDComponentIndex == -1) {
        return self;
    }
    NSString *appUIDComponent = pathComponentArray[appUIDComponentIndex];
    NSRange appUIDComponentRange = [self rangeOfString:appUIDComponent];
    NSRange baseRange = NSMakeRange(0, appUIDComponentRange.location + appUIDComponentRange.length);
    
    NSString *relativePath = [self stringByReplacingCharactersInRange:baseRange withString:@""];
    return relativePath;
}

- (NSString *)xy_toAppFullPath
{
    BOOL isPath = [self hasPrefix:@"/"] || [self xy_containsString:@"/Documents"] || [self xy_containsString:@"/Library"] || [self xy_containsString:@"/tmp"];
    if (!isPath) {//not a path
        return self;
    }
    
    NSString *base = NSHomeDirectory();
    NSString *fullPath = [base stringByAppendingPathComponent:self];
    return fullPath;
}

- (BOOL)xy_containsString:(NSString *)string
{
    NSRange range = [self rangeOfString:string];
    BOOL contain = range.location != NSNotFound;
    return contain;
}

- (NSString *)xy_toBundleFullPath
{
    if(![self hasPrefix:@"/"]){
        return self;
    }
    
    NSString *originalPath = self;
    NSString *fullPath;
    NSString* appPackageString = [NSString xy_getAppPackageString];
    NSRange textRange;
    textRange =[originalPath rangeOfString:appPackageString];
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    
    if(textRange.location != NSNotFound){
        //Found .../Documents,replace the .../Documents filePath
        NSUInteger location = textRange.location;
        NSUInteger length = textRange.length;
        textRange.location = 0;
        textRange.length = location+length;
        fullPath = [originalPath stringByReplacingCharactersInRange:textRange withString:bundlePath];
    }else{
        //Not found
        fullPath = [NSString stringWithFormat:@"%@%@",bundlePath,originalPath];
    }
    return fullPath;
}

- (NSString *)xy_toBundleRelativePath
{
    NSString *originalPath = self;
    NSString *relativePath;
    NSString* appPackageString = [NSString xy_getAppPackageString];
    NSRange textRange;
    textRange =[originalPath rangeOfString:appPackageString];
    
    if(textRange.location != NSNotFound){
        //Found .../Documents,replace the .../Documents filePath
        NSUInteger location = textRange.location;
        NSUInteger length = textRange.length;
        textRange.location = 0;
        textRange.length = location+length;
        relativePath = [originalPath stringByReplacingCharactersInRange:textRange withString:@""];
    }else{
        //Not found
        relativePath = originalPath;
    }

    return relativePath;
}

- (NSString *)xy_toTemplateFullPath
{
    NSString *originalPath = self;
    NSString *fullPath;
    NSRange textRange;
    textRange =[originalPath rangeOfString:@"newtemplates/"];
    NSString *documentsPath = [NSString stringWithFormat:@"%@/data/newtemplates",[NSString stringWithFormat:@"%@/Library/Application Support", NSHomeDirectory()]];;
    
    if(textRange.location != NSNotFound){
        //Found .../Documents,replace the .../Documents filePath
        NSUInteger location = textRange.location;
        NSUInteger length = textRange.length;
        textRange.location = 0;
        textRange.length = location+length;
        fullPath = [originalPath stringByReplacingCharactersInRange:textRange withString:documentsPath];
    }else{
        //Not found
        fullPath = [NSString stringWithFormat:@"%@/%@",documentsPath,originalPath];
    }
  
    return fullPath;
}

- (NSString *)xy_toTemplateRelativePath
{
    NSString *originalPath = self;
    NSString *relativePath;
    NSRange textRange;
    textRange =[originalPath rangeOfString:@"newtemplates/"];
    
    if(textRange.location != NSNotFound){
        //Found .../Documents,replace the .../Documents filePath
        NSUInteger location = textRange.location;
        NSUInteger length = textRange.length;
        textRange.location = 0;
        textRange.length = location+length;
        relativePath = [originalPath stringByReplacingCharactersInRange:textRange withString:@""];
    }else{
        //Not found
        relativePath = originalPath;
    }
    
    return relativePath;
}

- (BOOL)xy_isPrivatePathTemplate
{
    NSString *originalPath = self;
    NSRange textRange;
    textRange =[originalPath rangeOfString:@"private/"];
    if(textRange.location != NSNotFound){
        return YES;
    }else{
        return NO;
    }
}

@end
