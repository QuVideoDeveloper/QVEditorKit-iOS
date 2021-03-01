//
//  NSObject+XYJSON.h
//  XYBase
//
//  Created by robbin on 2019/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (QVJSON)

- (NSString * _Nullable)qv_getJSONString;
- (id _Nullable)qv_getObjectFromJSONString;

@end

NS_ASSUME_NONNULL_END
