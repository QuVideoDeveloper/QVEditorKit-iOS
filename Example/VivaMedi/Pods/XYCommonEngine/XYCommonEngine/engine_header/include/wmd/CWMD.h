
@interface CWMD : NSObject

- (MRESULT)create : (CWMDParameter*)param
             with : (CXiaoYingEngine*)engine;
- (MVoid)Destroy;
- (MRESULT)start;
- (MRESULT)pause;
- (MRESULT)resume;
- (MRESULT)stop;

@end
