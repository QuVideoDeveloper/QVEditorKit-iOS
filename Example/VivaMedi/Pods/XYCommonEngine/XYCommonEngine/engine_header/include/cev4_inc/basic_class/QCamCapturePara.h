//#import <Foundation/Foundation.h>
#import "amcomdef.h"

@interface QCamCapturePara : NSObject


@property(assign, nonatomic)    MBool    bCaptureFlag;//true表示执行capture动作，false内部会忽略
@property(readwrite, nonatomic) NSString* stringFilePath;//要保存的图片的完整路径，以后缀名".jpg"结束
@property(readwrite, nonatomic) MBool    bCaptureAllEffect;//capture的是原始的图像，还是加了所有effect后的图像



@end
