

/*
 *  Param
 *      uniformTimePos: it's based on the time speed of 1x
 *      timeScale: it's the speed of time elapse. Ex. 2.0 means the elapse speed is twice of our real world time
 */
@interface QTimeInfo : NSObject

@property(assign, nonatomic) unsigned int uniformTimePos;
@property(assign, nonatomic) float timeScale;

@end