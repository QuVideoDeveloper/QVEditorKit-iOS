#ifndef  QCAM_DUBBING_INFO_H
#define  QCAM_DUBBING_INFO_H


@interface QCamDubbingInfo : NSObject
//{
//    NSString *audioFile;
//    unsigned int startPos; //millisecond
//    unsigned int length; //millisecond
//}

@property(readwrite, nonatomic)  NSString *audioFile;
@property(assign, nonatomic)  unsigned int startPos;
@property(assign, nonatomic)  unsigned int length;

- (QCamDubbingInfo*)duplicate;

@end


#endif