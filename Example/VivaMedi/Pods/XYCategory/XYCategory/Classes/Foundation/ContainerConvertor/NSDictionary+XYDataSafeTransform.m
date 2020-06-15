//
//  NSDictionary+XYContainerConvertor.m
//  XYH5SDK
//
//  Created by 林冰杰 on 2019/7/18.
//

#import "NSDictionary+XYDataSafeTransform.h"
#import "XYContainerConvertor.h"

@implementation NSDictionary (XYDataSafeTransform)

- (NSString *)xyStringForKey:(id)key {
    return [XYContainerConvertor xyStringWithDictionary:self forKey:key];
}

- (NSNumber *)xyNumberForKey:(id)key {
    return [XYContainerConvertor xyNumberWithDictionary:self forKey:key];
}

- (NSDictionary *)xyDictionaryForKey:(id)key {
    return [XYContainerConvertor xyDictWithDictionary:self forkey:key];
}

- (NSArray *)xyArrayForKey:(id)key {
    return  [XYContainerConvertor xyArrayWithDictionary:self forkey:key];
}

@end
