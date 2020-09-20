//
//  NSDictionary+XYDataSafeTransform.h
//  XYH5SDK
//
//  Created by 林冰杰 on 2019/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (QVDataSafeTransform)

- (NSString *)qvStringForKey:(id)key;
- (NSNumber *)qvNumberForKey:(id)key;
- (NSDictionary *)qvDictionaryForKey:(id)key;
- (NSArray *)qvArrayForKey:(id)key;

@end

NS_ASSUME_NONNULL_END
