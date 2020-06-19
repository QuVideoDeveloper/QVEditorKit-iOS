//
//  QVMediCameraFaceBeatyModel.h
//  QVMediMediCamera
//
//  Created by 徐新元 on 2020/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QVMediCameraFaceBeatyModel : NSObject

@property (nonatomic, copy) NSString *templateFillePath;

@property (nonatomic, assign) NSInteger templatedID;

@property (nonatomic, assign) NSInteger minValue;

@property (nonatomic, assign) NSInteger maxValue;

@property (nonatomic, assign) NSInteger currentValue;

@property (nonatomic, assign) NSInteger defaultValue;

@end

NS_ASSUME_NONNULL_END
