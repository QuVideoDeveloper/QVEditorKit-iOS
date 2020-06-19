//
//  XYKeyScaleInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/19.
//

#import "XYBaseKeyFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYKeyScaleInfo : XYBaseKeyFrame

/// 宽相对于原始的宽的放大倍数
@property (nonatomic, assign) CGFloat widthScale;

/// 宽相对于原始的高的放大倍数
@property (nonatomic, assign) CGFloat heightScale;

@end

NS_ASSUME_NONNULL_END
