//
//  XYKeyPosInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/19.
//

#import "XYBaseKeyFrame.h"


NS_ASSUME_NONNULL_BEGIN

@interface XYKeyPosInfo : XYBaseKeyFrame

/// 在streamSize的坐标系中的中心位置
@property (nonatomic, assign) CGPoint centerPoint;

@end

NS_ASSUME_NONNULL_END
