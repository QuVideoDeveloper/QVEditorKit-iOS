//
//  AnimatedFrameInfo.h
//  XYVivaVideoEngineKit
//
//  Created by 徐新元 on 2018/7/9.
//

#import "CXiaoYingInc.h"
#import <Foundation/Foundation.h>

@interface AnimatedFrameInfo : NSObject

@property (nonatomic, strong) NSString *title;
@property MInt64 templateID;
@property (nonatomic, strong) NSString *xytFilePath;
@property MDWord startPos;
@property MRECT rcDispRegion;
@property MDWord dwCurrentDuration;
@property MDWord dwTotalDuration;
@property MBool bHasAudio;

@end
