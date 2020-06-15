//
//  XYVeRangeModel.m
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYVeRangeModel.h"

@implementation XYVeRangeModel

+ (instancetype)VeRangeModelWithPosition:(NSInteger)dwPos length:(NSInteger)dwLen
{
    XYVeRangeModel *model = [[XYVeRangeModel alloc] init];
    model.dwLen = dwLen;
    model.dwPos = dwPos;
    
    return model;
}



@end
