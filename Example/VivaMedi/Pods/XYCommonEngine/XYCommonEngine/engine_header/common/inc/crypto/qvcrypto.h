#ifndef QVCRYPTO_H
#define QVCRYPTO_H



#include "amcomdef.h"
#include "qvcryptocomdef.h"







ENC_DATA  qvctEncString(MTChar *str, MTChar* key);
MTChar*	 qvctDecData(MByte* data, MLong dataLen, MTChar* key);





#endif


