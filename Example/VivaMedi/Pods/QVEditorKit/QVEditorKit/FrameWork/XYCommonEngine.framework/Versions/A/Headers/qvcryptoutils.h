#ifndef QVCRYPTOUTILS_H
#define QVCRYPTOUTILS_H

#include "qvcryptocomdef.h"



MTChar* qvctEncStringSimple(MTChar *str);
MTChar* qvctDecStringSimple(MTChar *encStr);
MVoid qvctFreeEncData(ENC_DATA *encRes);
MTChar* qvctMergeString(MTChar* str1, MTChar* str2);




MTChar* QVET_TransData2HexFormatString(MByte *data, MLong dataLen);
MByte* QVET_TransHexFormatString2Data(MTChar* dataString, MBool check4BytesAlign);
inline MByte QVET_GetHexCharValue(MTChar ch);
inline MDWord QVET_GetHexStringValue(MTChar *str, MDWord len);


#endif //endif of QVCRYPTOUTILS_H