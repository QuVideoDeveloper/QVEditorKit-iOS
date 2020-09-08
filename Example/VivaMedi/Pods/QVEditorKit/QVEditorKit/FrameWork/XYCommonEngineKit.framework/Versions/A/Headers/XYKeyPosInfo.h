//
//  XYKeyPosInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/19.
//

#import "XYBaseKeyFrame.h"
#import "XYVe3DDataF.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYKeyPosInfo : XYBaseKeyFrame

/// 在streamSize的坐标系中的中心位置
@property (nonatomic, strong) XYVe3DDataF *center;

@end

NS_ASSUME_NONNULL_END
