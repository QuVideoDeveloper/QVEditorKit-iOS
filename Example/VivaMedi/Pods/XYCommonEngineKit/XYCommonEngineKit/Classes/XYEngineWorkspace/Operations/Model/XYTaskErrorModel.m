//
//  XYTaskErrorModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/4/28.
//

#import "XYTaskErrorModel.h"

@implementation XYTaskErrorModel

+ (instancetype)initWithCode:(NSInteger)code message:(NSString *)message {
    XYTaskErrorModel *model = [[XYTaskErrorModel alloc] init];
    if (model) {
        model.code = code;
        model.message = message;
    }
    return model;
}

@end
