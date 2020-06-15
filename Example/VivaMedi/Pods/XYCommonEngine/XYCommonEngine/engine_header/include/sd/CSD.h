

@interface CSD : NSObject

- (MRESULT)create : (CSDParameter*)param;
- (MVoid)Destroy;
- (MRESULT)start;
- (MRESULT)pause;
- (MRESULT)resume;
- (MRESULT)stop;

@end
