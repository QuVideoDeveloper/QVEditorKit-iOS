//
//  XYTaskErrorModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYTaskErrorModel : NSObject

/// 错误码
@property (nonatomic, assign) NSInteger code;

/// 错误信息
@property (nonatomic, copy) NSString *message;


@end

NS_ASSUME_NONNULL_END
