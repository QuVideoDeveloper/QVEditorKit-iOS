
#import "amcomdef.h"

@interface QPIPSrcMode : NSObject
//{
//    MDWord  dwIdx;
//    MBool   bIsSingleFrame;
//    MDWord  dwTimePos;
//
//}

@property(assign, nonatomic) MDWord  dwIdx;
@property(assign, nonatomic) MBool   bIsSingleFrame;
@property(assign, nonatomic) MDWord  dwTimePos;

@end