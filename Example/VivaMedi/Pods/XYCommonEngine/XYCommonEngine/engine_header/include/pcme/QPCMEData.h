

/**
 *  It's uesed to describe the float wave-form data deliveried by callback, it's an important member of QPCMECallbackData
 */
@interface QPCMEData : NSObject

@property(assign, nonatomic) int dataType; //PCME_DATA_TYPE_XXX defined in amvedef.h

@property(readwrite, nonatomic) NSData *left; //short or float, it depends on dataType, it's for left channel
@property(readwrite, nonatomic) NSData *right; //short or float, it depends on dataType, it's for right channel

@property(readwrite, nonatomic) NSNumber *maxAbsLeft;//short or float, it depends on dataType, it's the max value in this section data
@property(readwrite, nonatomic) NSNumber *maxAbsRight;//short or float, it depends on dataType, it's the max value in this section data

+ (instancetype)initWithFloatData : (float*)left
                            right : (float*)right
                           smpCnt : (int)smpCnt
                       maxAbsLeft : (float)maxAbsLeft
                      maxAbsRight : (float)maxAbsRight;

+ (instancetype)initWithShortData : (short*)left
                            right : (short*)right
                           smpCnt : (int)smpCnt
                       maxAbsLeft : (long)maxAbsLeft
                      maxAbsRight : (long)maxAbsRight;

@end
