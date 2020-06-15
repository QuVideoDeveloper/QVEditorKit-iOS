/*
 *
 * History:
 *		1. 2018.12.03 init version by jgong
 *		2. 2018.12.04 modified by jgong
 *			2.1 change some inline function to normal function
 *			2.2 add support to module selection
 *			2.3 add support to log-level selection
 *			refer to yifei's email at 2018.12.06 for more info.
 *      3. 2018.12.11 modified by jgong
 *          split the macro-definition to single header-file to fit the iOS OC application.
 */

#ifndef QVMONITOR_H
#define QVMONITOR_H

#include "amcomdef.h"
#include "amoperatornew.h"


#include <stdio.h>
#include <stdarg.h>
#include "amstring.h"





class QVMonitor
{
private:	
	QVMonitor();
	~QVMonitor();

public:
	static MRESULT createInstance();
	static QVMonitor* getInstance();
	static MVoid destroyInstance();


	MRESULT	 setProp(MDWord prop, MVoid* data);

	//可能要加mutex！！！
	MVoid logI(MUInt64 mduID, const MTChar *tag, const MTChar *fmt, ...);
	MVoid logD(MUInt64 mduID, const MTChar *tag, const MTChar *fmt, ...);
	MVoid logE(MUInt64 mduID, const MTChar *tag, const MTChar *fmt, ...);
	MVoid logT(MUInt64 mduID, const MTChar *tag, const MTChar *fmt, ...);

public:
	MDWord mLV; //log-level
	MUInt64 mModules;//the corresponding module bit should be set，if  “that” module wanna be monitored

private:
	//EL = exterenal logging; 
	//true: choose the external logging method by callback set. 
	//false: choose the internal logging method
	MBool mUseELMethod;
	PFN_MONITOR_LOG_CALLBACK mLogCB;
	MVoid* mUserData;
	PFN_MONITOR_LOG_CALLBACK mTraceCB;
	MVoid* mUserTraceData;

	MTChar mVACarrier[1024];
	MTChar mWorkBuf[1024];

	MDWord mRefCnt;
};


#endif //endif of QVMONITOR_H
