//
//  XYKeyScaleInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/19.
//

#import "XYBaseKeyFrame.h"
#import "XYVe3DDataF.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYKeyScaleInfo : XYBaseKeyFrame

/// 相对于当前的尺寸的放大倍数 默认值为(1,1,1)
@property (nonatomic, strong) XYVe3DDataF *scale;

@end

NS_ASSUME_NONNULL_END
