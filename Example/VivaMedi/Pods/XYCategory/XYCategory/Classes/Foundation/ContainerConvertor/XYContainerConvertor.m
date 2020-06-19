//
//  XYContainerConvertor.M
//  AliyunOSSiOS
//
//  Created by 林冰杰 on 2019/7/18.
//

#import "XYContainerConvertor.h"
#include <execinfo.h>

static NSInteger const kXYBackTraceNum = 10; // 获取若干个堆栈信息

/// 获取当前调用堆栈
static inline NSString *XYFetchCurrentBackTrace() {
    void *callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSString *message = [NSString string];
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0;i < kXYBackTraceNum;i++){
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
        message = [message stringByAppendingFormat:@"\n %@", [NSString stringWithCString:strs[i] encoding:NSUTF8StringEncoding]];
    }
    free(strs);
    return message;
}

static inline void XYBackTrackAlert(NSString *message) {
    if (message.length <= 0) {
        return;
    }
    NSLog(@"【❌】发生容器数据类型错误 【❌】\n %@",message);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"容器数据类型错误"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"点击崩溃，前往修改"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         exit(0);
                                                     }];
    [alertController addAction:OKAction];
    
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.rootViewController = [[UIViewController alloc] init];
    alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [alertWindow makeKeyAndVisible];
    [alertWindow.rootViewController presentViewController:alertController
                                                 animated:YES
                                               completion:nil];
}

static inline id XYContainerConvertorCheckType(id INSTANCE, Class classType) {
    if (!INSTANCE) {
        return nil;
    }
    if(![INSTANCE isKindOfClass:classType]) {
        #if DEBUG
        XYBackTrackAlert(XYFetchCurrentBackTrace());
        #endif
        return nil;
    }
    return INSTANCE;
}

@implementation XYContainerConvertor

#pragma mark - Dictionary
+ (NSString *)xyStringWithDictionary:(NSDictionary *)dict forKey:(id)key {
    NSString *string = XYContainerConvertorCheckType(dict[key], NSString.class);
    if (string) return string;
    NSNumber *number = XYContainerConvertorCheckType(dict[key], NSNumber.class);
    if (number) return [NSString stringWithFormat:@"%@", number];
    return nil;
}

+ (NSString *)xyNonnullStringWithDictionary:(NSDictionary *)dict forKey:(id)key {
    NSString *string = [self xyStringWithDictionary:dict forKey:key];
    return string? string:@"";
}

+ (NSNumber *)xyNumberWithDictionary:(NSDictionary *)dict forKey:(id)key {
    NSNumber *number = XYContainerConvertorCheckType(dict[key], NSNumber.class);
    if (number) return number;
    NSString *string = XYContainerConvertorCheckType(dict[key], NSString.class);
    if (string) return @([string intValue]);
    return nil;
}

+ (NSDictionary *)xyDictWithDictionary:(NSDictionary *)dict forkey:(id)key {
    return XYContainerConvertorCheckType(dict[key], NSDictionary.class);
}

+ (NSArray *)xyArrayWithDictionary:(NSDictionary *)dict forkey:(id)key {
    return XYContainerConvertorCheckType(dict[key], NSArray.class);
}

#pragma mark - Array
+ (NSString *)xyStringWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    
    NSString *string = XYContainerConvertorCheckType(array[index], NSString.class);
    if (string) return string;
    NSNumber *number = XYContainerConvertorCheckType(array[index], NSNumber.class);
    if (number) return [NSString stringWithFormat:@"%@", number];
    return nil;
}

+ (NSNumber *)xyNumberWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    
    NSNumber *number = XYContainerConvertorCheckType(array[index], NSNumber.class);
    if (number) return number;
    NSString *string = XYContainerConvertorCheckType(array[index], NSString.class);
    if (string) return @([string intValue]);
    return nil;
}

+ (NSDictionary *)xyDictWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    return XYContainerConvertorCheckType(array[index], NSDictionary.class);
}

+ (NSArray *)xyArrayWithArray:(NSArray *)array atIndex:(NSInteger)index {
    if (index >= [array count]) {
        return nil;
    }
    return XYContainerConvertorCheckType(array[index], NSArray.class);
}

#pragma mark - judge self type
+ (NSArray *)xyArrayWithObject:(id)array {
    return XYContainerConvertorCheckType(array, NSArray.class);
}

+ (NSDictionary *)xyDictWithObject:(id)dict {
    return XYContainerConvertorCheckType(dict, NSDictionary.class);
}

@end
