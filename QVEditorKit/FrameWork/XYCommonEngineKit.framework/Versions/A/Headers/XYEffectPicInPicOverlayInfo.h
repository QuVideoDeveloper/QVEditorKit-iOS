//
//  XYEffectOverlayInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYEffectPicInPicOverlayInfo : NSObject

/// 混合模式素材路径
@property (nonatomic, copy) NSString *overlayPath;

/// 混合程度，改参数和透明度一个效果,0~100    
@property (nonatomic, assign) CGFloat level;

@end

NS_ASSUME_NONNULL_END
