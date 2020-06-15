//
//  XYDefaultParseThemeText.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/30.
//

#define TEMPLATE_TRANS_SYMBOL_LOCATION          @"%location%"
#define TEMPLATE_TRANS_SYMBOL_LOCATION_POI      @"%POI%"
#define TEMPLATE_TRANS_SYMBOL_LOCATION_CITY     @"%City%"
#define TEMPLATE_TRANS_SYMBOL_LOCATION_ENCITY   @"%EnCity%"
#define TEMPLATE_TRANS_SYMBOL_LOCATION_PROVINCE @"%Province%"
#define TEMPLATE_TRANS_SYMBOL_LOCATION_COUNTRY  @"%Country%"
#define TEMPLATE_TRANS_SYMBOL_NICKNAME          @"\@%nickname%"
#define TEMPLATE_TRANS_SYMBOL_FILMNAME          @"%filmname%"
#define TEMPLATE_TRANS_SYMBOL_WEATHER           @"%weather%"
#define TEMPLATE_TRANS_SYMBOL_SELFDEF           @"%selfdef%"
#define TEMPLATE_TRANS_SYMBOL_PERCENTAGE        @"%PS%"
#define TEMPLATE_TRANS_SYMBOL_BACK_COVER        @"%XiaoYingPresent%"
#define TEMPLATE_TRANS_SYMBOL_FILM_MAKER        @"%filmmaker%"
#define TEMPLATE_TRANS_SYMBOL_DIRECTOR          @"%director%"
#define TEMPLATE_TRANS_SYMBOL_SCREENWRITER      @"%screenwriter%"
#define TEMPLATE_TRANS_SYMBOL_ACTOR             @"%actor%"
#define TEMPLATE_TRANS_SYMBOL_EDITOR            @"%editor%"
#define TEMPLATE_TRANS_SYMBOL_PHOTOGRAPHER      @"%photographer%"

#import "XYDefaultParseThemeText.h"
#import <XYCategory/XYCategory.h>
#import "QVTextPrepareModel.h"

@implementation XYDefaultParseThemeText

+ (NSString *)parse:(NSString *)formatText delegate:(id<QVEngineDataSourceProtocol>)delegate {
    if ([NSString xy_isEmpty:formatText]) {
        return nil;
    }
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_LOCATION]){
        NSString *address = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            address = [delegate textPrepare:QVTextPrepareModeLocation].location;
        }
        if (!address) {
            address = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION withString:address];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_LOCATION_POI]){
        NSString *poiName = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            poiName = [delegate textPrepare:QVTextPrepareModeLocation].location;
        }
        if (!poiName) {
            poiName = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION_POI withString:poiName];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_LOCATION_CITY]){
        NSString *city = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            city = [delegate textPrepare:QVTextPrepareModeCity].city;
        }
        if (!city) {
            city = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION_CITY withString:city];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_LOCATION_ENCITY]){
        NSString *enCity = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            enCity = [delegate textPrepare:QVTextPrepareModeEnCity].enCity;
        }
        if (!enCity) {
            enCity = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION_ENCITY withString:enCity];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_LOCATION_PROVINCE]){
        NSString *province = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            province = [delegate textPrepare:QVTextPrepareModeProvince].province;
        }
        if (!province) {
             province = @"";
         }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION_PROVINCE withString:province];
    }
    
    if([formatText isEqualToString:TEMPLATE_TRANS_SYMBOL_LOCATION_COUNTRY]){
        NSString *country = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            country = [delegate textPrepare:QVTextPrepareModeCountry].country;
        }
        if (!country) {
             country = @"";
         }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION_COUNTRY withString:country];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_NICKNAME]){
        NSString *nickName = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            nickName = [delegate textPrepare:QVTextPrepareModeNickName].nickname;
        }
        if (!nickName) {
             nickName = @"";
         }
        formatText =[formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_NICKNAME withString:[NSString stringWithFormat:@"\@%@",nickName]];
    }
    
        
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_FILMNAME]){
        NSString *filmName = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            filmName = [delegate textPrepare:QVTextPrepareModeFilmName].filmName;
        }
        if (!filmName) {
            filmName = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_FILMNAME
                                                           withString:filmName];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_WEATHER]){
        NSString *weather = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            weather = [delegate textPrepare:QVTextPrepareModeWeather].weather;
        }
        if (!weather) {
            weather = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:@"%" withString:weather];
    }
    
    
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_BACK_COVER]){
        NSString *backCoverText = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            backCoverText = [delegate textPrepare:QVTextPrepareModeBackCoverTitle].backCoverTitle;
        }
        if (!backCoverText) {
            backCoverText = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_BACK_COVER
                                                           withString:backCoverText];
        
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_FILM_MAKER]){
        NSString *filmMaker = @"";
             if ([delegate respondsToSelector:@selector(textPrepare:)]) {
                 filmMaker = [delegate textPrepare:QVTextPrepareModeFilmMaker].filmMaker;
             }
        if (!filmMaker) {
            filmMaker = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_FILM_MAKER
                                                           withString:filmMaker];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_DIRECTOR]){
        NSString *filmDirector = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            filmDirector = [delegate textPrepare:QVTextPrepareModeFilmDirector].filmDirector;
        }
        if (!filmDirector) {
            filmDirector = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_DIRECTOR
                                                           withString:filmDirector];
        
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_SCREENWRITER]){
        NSString *filmScreenWriter = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            filmScreenWriter = [delegate textPrepare:QVTextPrepareModeFilmScreenWriter].filmScreenWriter;
        }
        if (!filmScreenWriter) {
            filmScreenWriter = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_SCREENWRITER
                                                           withString:filmScreenWriter];
        
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_ACTOR]){
        NSString *filmActor = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            filmActor = [delegate textPrepare:QVTextPrepareModeFilmActor].filmActor;
        }
        if (!filmActor) {
            filmActor = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_ACTOR
                                                           withString:filmActor];
        
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_EDITOR]){
        NSString *filmEditor = @"";
        if ([delegate respondsToSelector:@selector(textPrepare:)]) {
            filmEditor = [delegate textPrepare:QVTextPrepareModeFilmEditor].filmEditor;
        }
        if (!filmEditor) {
            filmEditor = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_EDITOR
                                                           withString:filmEditor];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_PHOTOGRAPHER]){
        NSString *filmPhotographer = @"";
               if ([delegate respondsToSelector:@selector(textPrepare:)]) {
                   filmPhotographer = [delegate textPrepare:QVTextPrepareModeFilmEditor].filmPhotographer;
               }
        if (!filmPhotographer) {
            filmPhotographer = @"";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_PHOTOGRAPHER
                                                           withString:filmPhotographer];
    }
    
    if([formatText rangeOfString:TEMPLATE_TRANS_SYMBOL_PERCENTAGE].location!= NSNotFound){
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_PERCENTAGE withString:@"％"];
    }
    
    if([formatText rangeOfString:@"%"].location!= NSNotFound){
        NSRange firstPSRange = [formatText rangeOfString:@"%"];
        NSRange lastPSRange = [formatText rangeOfString:@"%" options:NSBackwardsSearch];
        NSRange formatSubStrRange = NSMakeRange(firstPSRange.location, lastPSRange.location - firstPSRange.location + 1);
        NSString *formatSubStr = [formatText substringWithRange:formatSubStrRange];
        NSString *dateFormater = [formatSubStr stringByReplacingOccurrencesOfString:@"%" withString:@""];
        dateFormater = [self stringFromDate:dateFormater];
        if (formatSubStr && dateFormater){
            formatText = [formatText stringByReplacingOccurrencesOfString:formatSubStr withString:dateFormater];
        }
    }
    return formatText;
}

+ (NSString *)parseText:(NSString *)formatText
{
    if ([NSString xy_isEmpty:formatText]) {
        return nil;
    }
    
//    //如果之前有缓存，先取缓存的文字
//    XYProjectInfo *dproject = [[XYProjectManager sharedInstance] currentProject];
//    NSString *prekey = [NSString stringWithFormat:@"theme_txt_%@_%ld",formatText,dproject._id];
//    NSString *savedString = [XYPreferenceVivaVideo loadPreference:prekey];
//
//    if(![NSString xy_isEmptyString:savedString]){
//        return savedString;
//    }
    
    BOOL needLocationData = NO;
    NSString *address = @"杭州古荡";//TODO:需要外步传入
    NSString *city = @"杭州市";//TODO:需要外步传入
    NSString *province = @"浙江省";//TODO:需要外步传入
    NSString *country = @"中国";//TODO:需要外步传入
    NSString *backCoverText =  @"小影出品";//TODO:需要外步传入
    NSString *frontCoverText = @"我的小影微视频";//TODO:需要外步传入

    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_LOCATION]){
        if([NSString xy_isEmpty:address]){
            address = @"无位置信息";
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION withString:address];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_LOCATION_POI]){
        NSString *poiName = address;
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION_POI withString:poiName];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_LOCATION_CITY]){
        if([NSString xy_isEmpty:city]){
            city = @" ";
            needLocationData = YES;
        }
        
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION_CITY withString:city];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_LOCATION_ENCITY]){
        if([NSString xy_isEmpty:city]){
            city = @"UNKNOWN";
            needLocationData = YES;
        }else{
            NSInteger fullLength = [city length];
            if(fullLength>2){
                NSRange rangOfShi = [city rangeOfString:@"市" options:NSDiacriticInsensitiveSearch range:NSMakeRange(2, fullLength-2)];
                if(rangOfShi.location != NSNotFound){
                    NSRange toBeDeletedRange = NSMakeRange(rangOfShi.location, fullLength-rangOfShi.location);
                    city = [city stringByReplacingCharactersInRange:toBeDeletedRange withString:@""];
                }
            }
            city = [self hanziToPinYin:city];
            city = [city uppercaseString];
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION_ENCITY withString:city];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_LOCATION_PROVINCE]){
        if([NSString xy_isEmpty:province]){
            province = @" ";
            needLocationData = YES;
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION_PROVINCE withString:province];
    }
    
    if([formatText isEqualToString:TEMPLATE_TRANS_SYMBOL_LOCATION_COUNTRY]){
        if([NSString xy_isEmpty:country]){
            country = @" ";
            needLocationData = YES;
        }
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_LOCATION_COUNTRY withString:country];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_NICKNAME]){
        formatText =[formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_NICKNAME withString:[NSString stringWithFormat:@"\@%@",[self parseNickName]]];
    }
    
        
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_FILMNAME]){
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_FILMNAME
                                                           withString:frontCoverText];
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_WEATHER]){
        formatText = [formatText stringByReplacingOccurrencesOfString:@"%" withString:@""];
    }
    
    
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_BACK_COVER]){
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_BACK_COVER
                                                           withString:backCoverText];
        
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_FILM_MAKER]){
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_FILM_MAKER
                                                           withString:backCoverText];
        
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_DIRECTOR]){
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_DIRECTOR
                                                           withString:[self parseNickName]];
        
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_SCREENWRITER]){
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_SCREENWRITER
                                                           withString:[self parseNickName]];
        
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_ACTOR]){
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_ACTOR
                                                           withString:[self parseNickName]];
        
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_EDITOR]){
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_EDITOR
                                                           withString:[self parseNickName]];
        
    }
    
    if([formatText containsString:TEMPLATE_TRANS_SYMBOL_PHOTOGRAPHER]){
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_PHOTOGRAPHER
                                                           withString:[self parseNickName]];
        
    }
    
    if([formatText rangeOfString:TEMPLATE_TRANS_SYMBOL_PERCENTAGE].location!= NSNotFound){
        formatText = [formatText stringByReplacingOccurrencesOfString:TEMPLATE_TRANS_SYMBOL_PERCENTAGE withString:@"％"];
    }
    
    if([formatText rangeOfString:@"%"].location!= NSNotFound){
        NSRange firstPSRange = [formatText rangeOfString:@"%"];
        NSRange lastPSRange = [formatText rangeOfString:@"%" options:NSBackwardsSearch];
        NSRange formatSubStrRange = NSMakeRange(firstPSRange.location, lastPSRange.location - firstPSRange.location + 1);
        NSString *formatSubStr = [formatText substringWithRange:formatSubStrRange];
        NSString *dateFormater = [formatSubStr stringByReplacingOccurrencesOfString:@"%" withString:@""];
        dateFormater = [self stringFromDate:dateFormater];
        if (formatSubStr && dateFormater){
            formatText = [formatText stringByReplacingOccurrencesOfString:formatSubStr withString:dateFormater];
        }
    }
    return formatText;
}

+ (NSString *)stringFromDate:(NSString *)formatString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatString];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSString *timestamp_str = [dateFormat stringFromDate:[NSDate date]];
    return timestamp_str;
}

+ (NSString *)parseNickName {
    return @"小影";
}

+ (NSString *)hanziToPinYin:(NSString *)hanziText {
    if ([hanziText length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        }
        return ms;
    }else{
        return hanziText;
    }
}

@end
