


/**
 * QPCMEParam is the OC countpart of QVET_PCME_PARAM defined in amvedef.h, refer to its definiton in amvedef.h for more info.
 */
@interface QPCMEParam : NSObject

@property(readwrite, nonatomic) NSString *audioFile;
@property(assign, nonatomic) int startPos;
@property(assign, nonatomic) int len;
@property(assign, nonatomic) bool   needLeft;
@property(assign, nonatomic) bool   needRight;
@property(assign, nonatomic) int    dataType;
@property(assign, nonatomic) id<QPCMEDelegate> delegate;
@property(readwrite, nonatomic) QPCMETurboSetting *turboSetting;
@end






