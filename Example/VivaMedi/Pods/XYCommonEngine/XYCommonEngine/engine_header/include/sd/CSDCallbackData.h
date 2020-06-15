/*
 status contains:
 #define AMVE_PROCESS_STATUS_RUNNING                    0X00000002
 #define AMVE_PROCESS_STATUS_PAUSED                     0X00000003
 #define AMVE_PROCESS_STATUS_STOPPED                    0X00000004
 refer amvedef.h for more info
 */

@interface CSDCallbackData : NSObject


@property(assign, nonatomic)    int total;
@property(assign, nonatomic)    int curPos;
@property(assign, nonatomic)    int status;
@property(assign, nonatomic)    int err;
@property(assign, nonatomic)    int offset;
@property(assign, nonatomic)    int resultCnt;
@property(readwrite, nonatomic) NSArray*  startList; //element is NSNumber*
@property(readwrite, nonatomic) NSArray*  endList; //element is NSNumber*

+ (CSDCallbackData*)createFrom : (QVET_SD_CBDATA*)cbData;

@end
