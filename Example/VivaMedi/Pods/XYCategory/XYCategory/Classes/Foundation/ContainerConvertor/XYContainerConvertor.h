//
//  XYContainerConvertor.h
//  AliyunOSSiOS
//
//  Created by 林冰杰 on 2019/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYContainerConvertor : NSObject

// 从字典中获取数据
+ (NSString *)xyStringWithDictionary:(NSDictionary *)dict forKey:(id)key;
+ (NSString *)xyNonnullStringWithDictionary:(NSDictionary *)dict forKey:(id)key;
+ (NSNumber *)xyNumberWithDictionary:(NSDictionary *)dict forKey:(id)key;
+ (NSDictionary *)xyDictWithDictionary:(NSDictionary *)dict forkey:(id)key;
+ (NSArray *)xyArrayWithDictionary:(NSDictionary *)dict forkey:(id)key;

// 从数组中获取数据
+ (NSString *)xyStringWithArray:(NSArray *)array atIndex:(NSInteger)index;
+ (NSNumber *)xyNumberWithArray:(NSArray *)array atIndex:(NSInteger)index;
+ (NSDictionary *)xyDictWithArray:(NSArray *)array atIndex:(NSInteger)index;
+ (NSArray *)xyArrayWithArray:(NSArray *)array atIndex:(NSInteger)index;

// 判断是否是array，dictionary
+ (NSArray *)xyArrayWithObject:(id)array;
+ (NSDictionary *)xyDictWithObject:(id)dict;

@end

NS_ASSUME_NONNULL_END
