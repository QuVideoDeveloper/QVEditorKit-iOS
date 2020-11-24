//
//  XYEffectDrawPenModel.h
//  AFNetworking
//
//  Created by 夏澄 on 2020/11/20.
//

#import "XYEffectVisionModel.h"

NS_ASSUME_NONNULL_BEGIN

@class XYDrawLayerPaintPenInfo;

@interface XYEffectDrawPenModel : XYEffectVisionModel

@property (nonatomic, strong) XYDrawLayerPaintPenInfo *penInfo;
@property (nonatomic, assign) NSInteger undoStackCount;
@property (nonatomic, assign) NSInteger redoStackCount;

@end

NS_ASSUME_NONNULL_END
