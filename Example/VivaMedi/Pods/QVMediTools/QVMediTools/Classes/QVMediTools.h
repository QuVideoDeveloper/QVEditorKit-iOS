//
//  QVMediTools.h
//  FMDB
//
//  Created by robbin on 2020/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QVMediTools : NSObject

+ (CGFloat)qv_safeAreaBottom;
+ (NSString *)idfa;
+ (NSString *)idfv;
+ (NSString *)uuid;

@end

NS_ASSUME_NONNULL_END
