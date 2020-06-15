

/**
 *  This is the class used to describ the callback data from PCME, you can get extracted audio data and other info by this class. It is deliveried by QPCMEDelegate.
 */
@interface  QPCMECallbackData : NSObject

@property(assign, nonatomic) int status; //AMVE_PROCESS_STATUS_XXX defined in amvedef.h
//@property(assign, nonatomic) int dataType; //in OC, we use QPCMEData to describe the wave-data, and datatype is includec in that struct----it's different from C/C++ API
@property(assign, nonatomic) int processedLen; //bases on time
@property(assign, nonatomic) int totalDuration;//bases on time
@property(assign, nonatomic) int errCode;
@property(readwrite, nonatomic) QPCMEData *data;//it's the wave data from extractor, and app can have the ownership of it.


+ (instancetype)createFrom : (QVET_PCME_CALLBACK_DATA*)cbData;



@end
