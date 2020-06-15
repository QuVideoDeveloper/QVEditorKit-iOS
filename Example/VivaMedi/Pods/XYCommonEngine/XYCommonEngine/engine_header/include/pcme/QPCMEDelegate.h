


/**
 *  PCME will use this delegate to delivery the audio data extracted and info to caller step by step
 */
@protocol QPCMEDelegate <NSObject>

-(void)onCallback : (QPCMECallbackData*) cbData;

@end
