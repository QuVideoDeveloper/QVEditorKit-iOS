//
//  NSObject+XYJSON.h
//  XYBase
//
//  Created by robbin on 2019/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (XYJSON)

- (NSString * _Nullable)xy_getJSONString;
- (id _Nullable)xy_getObjectFromJSONString;

@end

NS_ASSUME_NONNULL_END
