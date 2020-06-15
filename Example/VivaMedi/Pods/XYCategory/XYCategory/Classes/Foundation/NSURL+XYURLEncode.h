//
//  NSURL+XYURLEncode.h
//  XYBase
//
//  Created by robbin on 2019/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (XYURLEncode)

- (nullable NSURL *)xy_encode;

- (nullable NSURL *)xy_decode;

@end

NS_ASSUME_NONNULL_END
