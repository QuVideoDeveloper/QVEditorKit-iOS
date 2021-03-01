//
//  EffectDataModel.h
//  XiaoYing
//
//  Created by xuxinyuan on 1/13/14.
//  Copyright (c) 2014 XiaoYing Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYEffectPositionDataModel : NSObject

@property AMVE_POSITION_RANGE_TYPE mSrcRange;
@property AMVE_POSITION_RANGE_TYPE mDestRange;
@property int mEffectIndex;
@property (nonatomic, strong) NSString *mStyle;
// record the position relative to clip.
@property QVET_CLIP_POSITION mClipPosition;

@end
