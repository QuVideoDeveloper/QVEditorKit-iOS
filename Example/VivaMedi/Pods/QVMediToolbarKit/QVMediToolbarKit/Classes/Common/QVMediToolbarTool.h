//
//  XYToolbarTool.h
//  XYToolbarKit
//
//  Created by 夏澄 on 2020/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QVMediToolbarTool : NSObject

+ (NSDictionary *)getTemplateDic;

+ (unsigned long long)qvmedi_getLongLongFromString:(NSString *)strLongLong;

+ (NSString*)qvmedi_getHexStringFromLongLong:(unsigned long long) longValue;
@end

NS_ASSUME_NONNULL_END
