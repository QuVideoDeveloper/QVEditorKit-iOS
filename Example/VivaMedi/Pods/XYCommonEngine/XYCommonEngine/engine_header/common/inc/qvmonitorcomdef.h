#ifndef QVMONITORCOMDEF_H
#define QVMONITORCOMDEF_H




//#ifdef __ANDROID__
//#include <android/log.h>
//
//#elif defined(__IPHONE__)
//#import <Foundation/Foundation.h>
//
//#elif defined(WIN32)  && defined(_DEBUG)
//#include <windows.h>
//extern "C" MVoid QVET_PrintWin32DebugLog(MTChar *format, ...);
//#ifdef SetProp
//#undef SetProp
//#endif
//
//#ifdef GetProp
//#undef GetProp
//#endif
//
//#ifdef GetCurrentTime
//#undef GetCurrentTime
//#endif
//#endif




#define MON_PROP_NONE                           0
#define MON_PROP_LOG_LEVEL                      1
#define MON_PROP_EXTERNAL_LOGGER                2
#define MON_PROP_USE_EXTERNAL_LOGGGER           3
#define MON_PROP_SET_MODULE                     4
#define MON_PROP_APPEND_MODULE                  5
#define MON_PROP_REMOVE_MODULE                  6
#define MON_PROP_TRACE_LOGGER                	7



#if defined(__ANDROID__) || defined(__IPHONE__) || defined(_LINUX_)
    #define MON_FUNC_NAME      __PRETTY_FUNCTION__
#elif defined(WIN32)
    #define MON_FUNC_NAME      __FUNCTION__
#else
    #define MON_FUNC_NAME      __FUNCTION__
#endif


#ifndef MON_LOG_TAG
#define MON_LOG_TAG "_QVMonitor_Default_Tag_"
#endif

#ifndef MON_MODULE_ID
#define MON_MODULE_ID        MON_MODULE_COMMON
#endif

#define QLOGI(fmt, ...)    if (QVMonitor::getInstance() && IS_MODULE_SET(MON_MODULE_ID) && IS_LOGI_SET())    \
                                QVMonitor::getInstance()->logI(MON_MODULE_ID, MON_LOG_TAG, fmt,   ##__VA_ARGS__)
#define QLOGD(fmt, ...)    if (QVMonitor::getInstance() && IS_MODULE_SET(MON_MODULE_ID) && IS_LOGD_SET())    \
                                QVMonitor::getInstance()->logD(MON_MODULE_ID, MON_LOG_TAG, fmt,   ##__VA_ARGS__)
#define QLOGE(fmt, ...)    if (QVMonitor::getInstance() && IS_MODULE_SET(MON_MODULE_ID) && IS_LOGE_SET())    \
                                QVMonitor::getInstance()->logE(MON_MODULE_ID, MON_LOG_TAG, fmt,   ##__VA_ARGS__)
#define QLOGB(fmt, ...)    if (QVMonitor::getInstance() && IS_MODULE_SET(MON_MODULE_ID) && IS_LOGB_SET())    \
								QVMonitor::getInstance()->logI(MON_MODULE_ID, MON_LOG_TAG, fmt,   ##__VA_ARGS__)

#define QTRACE(fmt, ...)    if (QVMonitor::getInstance() && IS_LOGT_SET())    \
                                QVMonitor::getInstance()->logT(MON_MODULE_ID, MON_LOG_TAG, fmt,   ##__VA_ARGS__)

//#include "qvlog.h"
//#define QLOGE		SHOWLOGE

#define QLOGE_ERR(res)      if (res != QVET_ERR_NONE) \
								QLOGE("this(%p) return res = 0x%x", this, res);

#define QLOGD_FUN_IN()     QLOGD("this(%p) In", this);
#define QLOGD_FUN_OUT()     QLOGD("this(%p) Out", this);



#define IS_LOGI_SET()    ((MON_LOG_LEVLE_I & QVMonitor::getInstance()->mLV) ? MTrue : MFalse)
#define IS_LOGD_SET()    ((MON_LOG_LEVLE_D & QVMonitor::getInstance()->mLV) ? MTrue : MFalse)
#define IS_LOGE_SET()    ((MON_LOG_LEVLE_E & QVMonitor::getInstance()->mLV) ? MTrue : MFalse)
#define IS_LOGB_SET()    ((MON_LOG_LEVLE_B & QVMonitor::getInstance()->mLV) ? MTrue : MFalse)
#define IS_LOGT_SET()    ((MON_LOG_LEVLE_T & QVMonitor::getInstance()->mLV) ? MTrue : MFalse)


#define IS_MODULE_SET(mdu)    ( (mdu & QVMonitor::getInstance()->mModules) ? MTrue : MFalse )

#define MON_LOG_LEVEL_NONE            0
#define MON_LOG_LEVLE_I                0x00000001
#define MON_LOG_LEVLE_D                0x00000002
#define MON_LOG_LEVLE_E                0x00000004
#define MON_LOG_LEVLE_B                0x00000008
#define MON_LOG_LEVLE_T                0x00000010
#define MON_LOG_LEVEL_ALL				(MON_LOG_LEVLE_I | MON_LOG_LEVLE_D | MON_LOG_LEVLE_E | MON_LOG_LEVLE_B | MON_LOG_LEVLE_T)


#define MON_MODULE_NONE                     0x0L
#define MON_MODULE_PLAYER                   0x0000000000000001L
#define MON_MODULE_MEDIAFILE                0x0000000000000002L
#define MON_MODULE_MEDIACODEC               0x0000000000000004L
#define MON_MODULE_RECORDER                 0x0000000000000008L
#define MON_MODULE_CAMERA                   0x0000000000000010L
#define MON_MODULE_EFFECT                   0x0000000000000020L
#define MON_MODULE_CLIP                     0x0000000000000040L
#define MON_MODULE_TRACK                    0x0000000000000080L
#define MON_MODULE_STREAM                   0x0000000000000100L
#define MON_MODULE_XML                      0x0000000000000200L
#define MON_MODULE_RENDERENGINE             0x0000000000000400L
#define MON_MODULE_SESSION                  0x0000000000000800L
#define MON_MODULE_COMPOSER                 0x0000000000001000L
#define MON_MODULE_FRAMEREADER              0x0000000000002000L
#define MON_MODULE_TOOLBOX                  0x0000000000004000L
#define MON_MODULE_TEXT						0x0000000000008000L
#define MON_MODULE_FACTORY					0x0000000000010000L
//#define MON_MODULE_                0x000000000000000?L
//#define MON_MODULE_                0x000000000000000?L
//#define MON_MODULE_                0x000000000000000?L
//#define MON_MODULE_                0x000000000000000?L
//#define MON_MODULE_                0x000000000000000?L
//#define MON_MODULE_                0x000000000000000?L
//#define MON_MODULE_                0x000000000000000?L
//#define MON_MODULE_                0x000000000000000?L
//#define MON_MODULE_                0x000000000000000?L
//#define MON_MODULE_                0x000000000000000?L
//#define MON_MODULE_                0x000000000000000?L
#define MON_MODULE_UTILS_INTERNAL             0x4000000000000000L
#define MON_MODULE_COMMON                    0x8000000000000000L//it's reserved ID for common use
#define MON_MODULE_ALL            (MON_MODULE_PLAYER | MON_MODULE_MEDIAFILE      | MON_MODULE_MEDIACODEC  | MON_MODULE_RECORDER  | \
MON_MODULE_CAMERA    | MON_MODULE_EFFECT | MON_MODULE_CLIP    | MON_MODULE_TRACK  | MON_MODULE_STREAM  |    \
MON_MODULE_XML | MON_MODULE_RENDERENGINE   |MON_MODULE_SESSION    | MON_MODULE_COMPOSER   | \
MON_MODULE_FRAMEREADER    | MON_MODULE_COMMON | MON_MODULE_UTILS_INTERNAL | MON_MODULE_TOOLBOX | MON_MODULE_TEXT)



#define MON_LOGI_HINT        "INF"
#define MON_LOGD_HINT        "DBG"
#define MON_LOGE_HINT        "ERR"
#define MON_LOGB_HINT        "BNC"
#define MON_LOGT_HINT        "TRC"


typedef MVoid (*PFN_MONITOR_LOG_CALLBACK)(MTChar *log, MVoid* userData);


typedef struct __tagMONITOR_EXTERNAL_LOGGER
{
    PFN_MONITOR_LOG_CALLBACK cb;
    MVoid* userData;
}MONITOR_EXTERNAL_LOGGER; //用于设置外部log输出外调




#define CHECK_QREPORT_RET(callfunc) \
res = callfunc;\
if(res!=0){ \
    QLOGE("%d:"#callfunc" ERROR,CODE=0x%x",__LINE__,res); \
    return res; \
}else QLOGD("%d:"#callfunc" OK",__LINE__);

#define CHECK_QREPORT_GOTO(callfunc) \
res = callfunc;\
if(res!=0){ \
    QLOGE("%d:"#callfunc" ERROR,CODE=0x%x",__LINE__,res); \
    goto FUN_EXIT; \
}else QLOGD("%d:"#callfunc" OK",__LINE__);





#define ASSERT_FAIL_GOTO(condition,ret) \
if(!(condition)){ \
    QLOGE("%d:"#condition" ASSERT FAILED",__LINE__); \
	res = ret; goto FUN_EXIT; \
}else QLOGD("%d:"#condition" ASSERT PASS",__LINE__);

#define ASSERT_FAIL_RET(condition,ret) \
if(!(condition)){ \
    QLOGE("%d:"#condition" ASSERT FAILED",__LINE__); \
	return ret;\
}else QLOGD("%d:"#condition" ASSERT PASS",__LINE__);
#endif //endif of QVMONITORCOMDEF_H



