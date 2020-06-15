



/*
    status contains:
    #define AMVE_PROCESS_STATUS_RUNNING                    0X00000002
    #define AMVE_PROCESS_STATUS_PAUSED                     0X00000003
    #define AMVE_PROCESS_STATUS_STOPPED                    0X00000004
    refer amvedef.h for more info
 */

@interface CWMDCallbackData : NSObject


@property(assign, nonatomic)    int status;
@property(assign, nonatomic)    int startTimePos;
@property(assign, nonatomic)    int curTimePos;
@property(assign, nonatomic)    int timeLength;
@property(assign, nonatomic)    int detectActionCnt;
@property(assign, nonatomic)    int dbgRunErr;
@property(assign, nonatomic)    int dbgWMErr;
@property(readwrite, nonatomic)    NSString*  wmCode;

+ (CWMDCallbackData*)createFrom : (QVET_WM_DETECT_CALLBACK_DATA*)cbData;

@end
