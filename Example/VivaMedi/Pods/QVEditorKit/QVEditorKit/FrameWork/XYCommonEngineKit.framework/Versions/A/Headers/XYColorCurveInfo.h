//
//  XYColorCurveInfo.h
//  XYCommonEngineKit
//
//  Created by 夏澄 on 2020/8/21.
//

#import <Foundation/Foundation.h>

@class XYPoint;

NS_ASSUME_NONNULL_BEGIN

@interface XYColorCurveItem : NSObject

@property (nonatomic, assign) NSInteger ts;
@property (nonatomic, strong) NSMutableArray <XYPoint *> * rgb;
@property (nonatomic, strong) NSMutableArray <XYPoint *> * red;
@property (nonatomic, strong) NSMutableArray <XYPoint *> * green;
@property (nonatomic, strong) NSMutableArray <XYPoint *> * blue;

@end

@interface XYColorCurveInfo : NSObject

@property (nonatomic, strong) NSMutableArray <XYColorCurveItem *> * mColorCurveItems;

@end

NS_ASSUME_NONNULL_END
