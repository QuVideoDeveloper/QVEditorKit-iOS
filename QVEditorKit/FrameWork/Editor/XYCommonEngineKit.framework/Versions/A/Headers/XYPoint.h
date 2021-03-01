//
//  XYPoint.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYPoint : NSObject

/*! @brief x */
@property(assign, nonatomic) NSInteger x;

/*! @brief y*/
@property(assign, nonatomic) NSInteger y;

+ (XYPoint *)make:(NSInteger)x y:(NSInteger)y;

@end

NS_ASSUME_NONNULL_END
