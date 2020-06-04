//
//  MultiTextInfo.h
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/9.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface MultiTextInfo : NSObject

@property (nonatomic, assign) NSUInteger textCount; //文字行数
@property (nonatomic, assign) CGRect textRegion;    //文字区域
@property (nonatomic, strong) NSArray *paramIds;    //每行文字对应的id

@end
