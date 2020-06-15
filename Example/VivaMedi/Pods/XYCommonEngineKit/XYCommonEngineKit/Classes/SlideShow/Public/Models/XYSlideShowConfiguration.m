//
//  XYSlideShowConfiguration.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#import "XYSlideShowConfiguration.h"

@implementation XYSlideShowConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.videoResolution = CGSizeMake(1280, 720);
        self.fullLanguage = [self fetchFullLanguage];
    }
    return self;
}

- (NSString *)fetchFullLanguage {
    NSString *preferredLang;
     preferredLang = [[NSLocale preferredLanguages] objectAtIndex:0];
     if (!preferredLang) {
         if (@available(macOS 10.12, iOS 10.0, *)) {
             preferredLang = [NSLocale currentLocale].languageCode;
         }
     }
    if(preferredLang && [self isSameLanguageKind:@"zh-Hans" lang:preferredLang]) {
        preferredLang = @"zh";
    }
    else if(preferredLang &&  [self isSameLanguageKind:@"zh-Hant" lang:preferredLang]) {
        preferredLang = @"zh";
    }
    else if(preferredLang &&  [self isSameLanguageKind:@"zh-HK" lang:preferredLang]) {
        preferredLang = @"zh";
    }
    else if(preferredLang &&  [self isSameLanguageKind:@"zh-TW" lang:preferredLang]) {
        preferredLang = @"zh";
    }
    else if(preferredLang && [self isSameLanguageKind:@"de" lang:preferredLang]) {
        preferredLang = @"de";
    }
    else if(preferredLang && [self isSameLanguageKind:@"es" lang:preferredLang]) {
        preferredLang = @"es";
    }
    else if(preferredLang && [self isSameLanguageKind:@"fr" lang:preferredLang]) {
        preferredLang = @"fr";
    }
    else if(preferredLang && [self isSameLanguageKind:@"ja" lang:preferredLang]) {
        preferredLang = @"ja";
    }
    else if(preferredLang && [self isSameLanguageKind:@"ko" lang:preferredLang]) {
        preferredLang = @"ko";
    }
    else if(preferredLang && [self isSameLanguageKind:@"pt" lang:preferredLang]) {
        preferredLang = @"pt";
    }
    else if(preferredLang && [self isSameLanguageKind:@"ru" lang:preferredLang]) {
        preferredLang = @"ru";
    }
    else if(preferredLang && [self isSameLanguageKind:@"id" lang:preferredLang]) {
        preferredLang = @"in";
    }
    else if(preferredLang && [self isSameLanguageKind:@"ms" lang:preferredLang]) {
        preferredLang = @"ms";
    }
    else if(preferredLang && [self isSameLanguageKind:@"th" lang:preferredLang]) {
        preferredLang = @"th";
    }
    else if(preferredLang && [self isSameLanguageKind:@"vi" lang:preferredLang]) {
        preferredLang = @"vi";
    }
    else if(preferredLang && [self isSameLanguageKind:@"ar" lang:preferredLang]) {
        preferredLang = @"ar";
    }
    else if(preferredLang && [self isSameLanguageKind:@"it" lang:preferredLang]) {
        preferredLang = @"it";
    }
    else if(preferredLang && [self isSameLanguageKind:@"tr" lang:preferredLang]) {
        preferredLang = @"tr";
    }else if(preferredLang && [self isSameLanguageKind:@"fa" lang:preferredLang]) {
        preferredLang = @"fa";
    }
    else if(preferredLang && [self isSameLanguageKind:@"hi" lang:preferredLang]) {
        preferredLang = @"hi";
    }
    else{
        preferredLang = @"en";
    }
    NSString *countryCode = [self fatchCountryCode];
    if (countryCode) {
        preferredLang = [NSString stringWithFormat:@"%@_%@", preferredLang, countryCode];
    }
    return preferredLang;
}

- (NSString *)fatchCountryCode {
    NSString *countryCode;
    countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    if (!countryCode) {
        countryCode = @"US";
    }
    return countryCode;
}

- (BOOL)isSameLanguageKind:(NSString*)lang lang:(NSString*)preferredLang {
  if (preferredLang == nil || lang == nil) {
            return FALSE;
        }
        
        if ([preferredLang isEqualToString:lang]) {
            return TRUE;
        }
        
        NSString* langPrefix = [NSString stringWithFormat:@"%@-",lang];
        if ([preferredLang hasPrefix:langPrefix]) {
            return TRUE;
        }
        
        return FALSE;
}

@end
