//
//  XYEffectRelativeClipInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/12/7.
//

#import <Foundation/Foundation.h>

@class XYVeRangeModel;

typedef NS_ENUM(NSInteger, XYEffectAdjustState) {
    XYEffectAdjustStateNone = 0,
    XYEffectAdjustStateDeleteSelf,
    XYEffectAdjustStateeUpdateDestRange,
};


NS_ASSUME_NONNULL_BEGIN

@interface XYEffectRelativeClipInfo : NSObject
@property (nonatomic, copy) NSString *clipIdentifier;//clip 的唯一标识符
@property (nonatomic, assign) BOOL isFullDuration;//修改前是全长的
@property (nonatomic, assign) NSInteger videoDuration;//修改前视频的总时长
@property (nonatomic, assign) XYEffectAdjustState adjustState;//cilp相关操作 引起effect需要做的操作
@property (nonatomic, assign) NSInteger relativeStart;//相对clip上的起始点 起始点在哪个clip就相对哪个clip
@property (nonatomic, assign) NSInteger relativeSourceStart;//相对clip源上的起始点 起始点在哪个clip就相对哪个clip
@property (nonatomic, strong) XYVeRangeModel *destVeRange;//修改前的destVeRange
@end

NS_ASSUME_NONNULL_END
