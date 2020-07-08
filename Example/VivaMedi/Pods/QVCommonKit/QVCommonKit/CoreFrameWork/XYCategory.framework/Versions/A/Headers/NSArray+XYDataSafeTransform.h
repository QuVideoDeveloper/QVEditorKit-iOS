//
//  NSArray+XYDataSafeTransform.h
//  XYH5SDK
//
//  Created by 林冰杰 on 2019/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (XYDataSafeTransform)

- (NSString *)xyStringAtIndex:(NSInteger)index;
- (NSNumber *)xyNumberAtIndex:(NSInteger)index;
- (NSDictionary *)xyDictionaryAtIndex:(NSInteger)index;
- (NSArray *)xyArrayAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
