//
//  XYKeyRotationInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/19.
//

#import "XYBaseKeyFrame.h"
#import "XYVe3DDataF.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYKeyRotationInfo : XYBaseKeyFrame

/// 旋转角度， 0~360
@property (nonatomic, strong) XYVe3DDataF *rotation;


@end

NS_ASSUME_NONNULL_END
