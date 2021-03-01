//
//  XYBaseClipTaskProperty.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/11/14.
//

#import "XYBaseClipTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBaseClipTaskProperty : XYBaseClipTask

- (void)switchEffectWithEffectType:(XYCommonEnginebackgroundType)effectType clipModel:(XYClipModel *)clipModel skipSetProperty:(BOOL)skipSetProperty;
@end

NS_ASSUME_NONNULL_END
