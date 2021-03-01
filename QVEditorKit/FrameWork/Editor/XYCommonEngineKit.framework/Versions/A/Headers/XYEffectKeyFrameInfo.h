//
//  XYEffectKeyFrameInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/19.
//

#import <Foundation/Foundation.h>
#import "XYEngineEnum.h"

@class XYKeyPosInfo, XYKeyScaleInfo, XYKeyRotationInfo, XYKeyAlphaInfo;

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectKeyFrameInfo : NSObject

/// 位置关键帧列表
@property (nonatomic, strong) NSMutableArray <XYKeyPosInfo *> *positionList;

/// 缩放关键帧列表
@property (nonatomic, strong) NSMutableArray <XYKeyScaleInfo *> *scaleList;

/// 旋转角度关键帧列表
@property (nonatomic, strong) NSMutableArray <XYKeyRotationInfo *> *rotationList;

/// 不透明度关键帧列表
@property (nonatomic, strong) NSMutableArray <XYKeyAlphaInfo *> *alphaList;

@property (nonatomic, strong) NSMutableArray <XYKeyAlphaInfo *> *anchorOffsetList;

@end

NS_ASSUME_NONNULL_END
