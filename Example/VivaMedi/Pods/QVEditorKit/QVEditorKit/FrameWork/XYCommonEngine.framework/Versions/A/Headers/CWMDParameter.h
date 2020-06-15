

@interface CWMDParameter : NSObject

@property(assign, nonatomic)  int startPos;
@property(assign, nonatomic)  int length;
@property(assign, nonatomic)  int frameUnitCnt;
@property(assign, nonatomic)   id <IWMDDelegate> delegate;
@property(readwrite, nonatomic)   NSString* videoFile;

@property(assign, nonatomic) int maxDetectActionCnt;
@property(assign, nonatomic) int maxDetectResultCnt;
@property(assign, nonatomic) bool bKeyFrameDetect;

@end
