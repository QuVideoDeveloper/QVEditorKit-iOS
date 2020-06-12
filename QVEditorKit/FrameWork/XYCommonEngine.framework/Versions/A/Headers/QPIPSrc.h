
//#import <Foundation/Foundation.h>
#import "amcomdef.h"

@interface QPIPSrc : NSObject
//{
//    MDWord dwIdx;
//    QVET_PIP_SOURCE Src;
//}

@property(assign, nonatomic) MDWord dwIdx;
@property(readwrite, nonatomic) QVET_PIP_SOURCE Src;



@end