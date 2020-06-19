//
//  NSDictionary+XYDataSafeTransform.h
//  XYH5SDK
//
//  Created by 林冰杰 on 2019/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (XYDataSafeTransform)

- (NSString *)xyStringForKey:(id)key;
- (NSNumber *)xyNumberForKey:(id)key;
- (NSDictionary *)xyDictionaryForKey:(id)key;
- (NSArray *)xyArrayForKey:(id)key;

@end

NS_ASSUME_NONNULL_END
