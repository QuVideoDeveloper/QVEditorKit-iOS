//
//  NSURL+XYURLEncode.h
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (QVURLEncode)

- (nullable NSURL *)qv_encode;

- (nullable NSURL *)qv_decode;

@end

NS_ASSUME_NONNULL_END
