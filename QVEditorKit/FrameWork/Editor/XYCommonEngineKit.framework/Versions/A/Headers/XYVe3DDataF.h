//
//  CGAnchorPoint.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/7/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYVe3DDataF : NSObject

/// x轴
@property (nonatomic, assign) CGFloat x;

/// y轴
@property (nonatomic, assign) CGFloat y;

/// z轴
@property (nonatomic, assign) CGFloat z;

+ (XYVe3DDataF *)make:(CGFloat)x y:(CGFloat)y z:(CGFloat)z;

@end

NS_ASSUME_NONNULL_END
