//
//  NSNumber+Language.h
//  Pods
//
//  Created by hongru qi on 2017/2/25.
//
//

#import <Foundation/Foundation.h>

#define APP_LOCALIZATION_ID_DECIMAL 0x0409 //english.
#define LANG_ID_ZH_CHS 0x0004              //Chinese Simplified Language
#define LANG_ID_AR_SA 0x0401               //ar_SA

@interface NSNumber (Language)

+ (NSInteger)xy_getLanguageID:(NSString *)fullLanguage;

@end
