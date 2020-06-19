//
//  XYSourceInfoNodeHelper.h
//  XiaoYingCoreSDK
//
//  Created by 吕孟霖 on 16/5/19.
//  Copyright © 2016年 QuVideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYSlideShowEnum.h"

@interface XYSourceInfoNodeHelper : NSObject
+ (XYSlideShowMediaType)getXYSourceInfoTypeByInnerSourceType:(UInt32)innerSourceType;
+ (UInt32)getInnerSouceTypeByXYSourceInfoType:(XYSlideShowMediaType)sourceInfoType;
@end
