//
//  NSArray+XYDataSafeTransform.h
//  XYH5SDK
//
//  Created by 林冰杰 on 2019/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (QVDataSafeTransform)

- (NSString *)qvStringAtIndex:(NSInteger)index;
- (NSNumber *)qvNumberAtIndex:(NSInteger)index;
- (NSDictionary *)qvDictionaryAtIndex:(NSInteger)index;
- (NSArray *)qvArrayAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
