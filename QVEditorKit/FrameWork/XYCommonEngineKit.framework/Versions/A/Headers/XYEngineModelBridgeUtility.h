//
//  XYModelBridgeUtility.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/22.
//

#import <Foundation/Foundation.h>
@class XYClipModel;
@class XYClipDataItem;
@class XYRectModel;

NS_ASSUME_NONNULL_BEGIN

@interface XYEngineModelBridgeUtility : NSObject

+ (XYClipDataItem *)bridge:(XYRectModel *)clipModel;

+ (MRECT)modelToMRect:(XYRectModel *)rectMode;

+ (XYRectModel *)mRectToModel:(MRECT)mRect;
@end

NS_ASSUME_NONNULL_END
