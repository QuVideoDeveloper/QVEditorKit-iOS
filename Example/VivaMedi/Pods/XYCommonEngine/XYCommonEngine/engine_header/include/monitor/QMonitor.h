



@protocol QMonitorLogger <NSObject>
/**
 *  @param log is the log-string fed by engine to app
 */
 
- (void)printLog : (NSString*)log;
- (void)traceLog : (NSString*)log;

@end



/*
 *  more info about monitor system:
 *  1. log level
 *      If you don't want monitor to process log, set MON_LOG_LEVEL_NONE
 *      log level can be evaluated as:
 *          MDWord logLV_You_want = MON_LOG_LEVLE_I | MON_LOG_LEVLE_D | ......;
 *  2. modules
 *      It's used to identify which module(s) you wanna monitor
 *      modules can be evaluated as:
 *          MDWord mdus_You_want = MON_MODULE_PLAYER | MON_MODULE_CAMERA | ......;
 *
 *  3. life-cycle of monitor system:
 *      3.1 To create the monitor-instance before any other operation to engine API
 *      3.2 You can change the prop-setting when you use the engine, but it's better to set all the property you need at the begining.
 *      3.3 To destroy the monitor-instance after you don't need to do any operation to other engine API
 */
#define QMON_PROP_NONE                           0
#define QMON_PROP_LOG_LEVEL                      1  //propData is MDWord*, MON_LOG_LEVLE_XXX is defined in qvmonitorcomdef.h
#define QMON_PROP_EXTERNAL_LOGGER                2  //propData is QMonitorLogger*
#define QMON_PROP_USE_EXTERNAL_LOGGGER           3  //propData is MBool*, MTrue means the external logger will be used; MFalse means use internal logger.
#define QMON_PROP_SET_MODULE                     4  //propData is MUInt64*, MON_MODULE_XXX is defined in qvmonitorcomdef.h; the monitor module-list will clean itself, and use the value you set
#define QMON_PROP_APPEND_MODULE                  5  //propData is MUInt64*, MON_MODULE_XXX is defined in qvmonitorcomdef.h; the monitor module-list will add the module(s) you set
#define QMON_PROP_REMOVE_MODULE                  6  //propData is MUInt64*, MON_MODULE_XXX is defined in qvmonitorcomdef.h; the monitor module-list will remove the modules(s) you set



@protocol IMonitorMethod// <NSObject>
-(MRESULT)setProp : (MDWord)propID
         propData : (MVoid*)propData;
@end
@interface QMonitorFactory : NSObject
+ (MRESULT)createInstance;
+ (id<IMonitorMethod>)getInstance;
+ (void)destroyInstance;
@end
