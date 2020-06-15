#ifndef __QVET_JSON_COMMON_H__
#define __QVET_JSON_COMMON_H__

#include "cJSON.h"
#include "amcomdef.h"

MBool GetDoubleInJson(cJSON * pFather, const char * szName, double & dValue);

MBool GetIntInJson(cJSON * pFather, const char * szName, int & nValue);

MBool GetMDwInJson(cJSON * pFather, const char * szName, MDWord & nValue);

const char * GetStrInJson(cJSON * pFather, const char * szName);

#endif // !__QVET_JSON_COMMON_H__