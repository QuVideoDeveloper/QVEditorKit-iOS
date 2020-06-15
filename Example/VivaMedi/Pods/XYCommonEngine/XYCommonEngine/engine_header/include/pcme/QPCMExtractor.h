


/**
 * Before use QPCMExtractor, call create first; and remember to call destroy if you don't need any operation to it.
 */
@interface QPCMExtractor : NSObject

- (MRESULT)create : (CXiaoYingEngine*)e
        parameter : (QPCMEParam*)param;
- (MVoid) destroy;

- (MRESULT) start;
- (MRESULT) stop;
- (MRESULT) pause;
- (MRESULT) resume;

@end

