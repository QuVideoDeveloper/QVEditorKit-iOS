//
//  NSNumber+Language.m
//  Pods
//
//  Created by hongru qi on 2017/2/25.
//
//

#import "NSNumber+Language.h"

@implementation NSNumber (Language)


+ (NSInteger)xy_getLanguageID:(NSString *)fullLanguage {
    fullLanguage = [fullLanguage lowercaseString];
	if ([fullLanguage hasPrefix:@"zh"]) {
		return LANG_ID_ZH_CHS;
	} else if ([fullLanguage hasPrefix:@"ar"]) {
		return LANG_ID_AR_SA;
	} else {
		return APP_LOCALIZATION_ID_DECIMAL;
	}
}

@end
