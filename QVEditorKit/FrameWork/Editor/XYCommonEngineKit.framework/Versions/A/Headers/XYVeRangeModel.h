//
//  XYVeRangeModel.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2019/10/21.
//

#import "XYBaseCopyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYVeRangeModel : XYBaseCopyModel
@property (nonatomic, assign) NSInteger  dwPos; // the start of position on the storyboard.
@property (nonatomic, assign) NSInteger  dwLen; //

+ (instancetype)VeRangeModelWithPosition:(NSInteger)dwPos length:(NSInteger)dwLen;

@end

NS_ASSUME_NONNULL_END
