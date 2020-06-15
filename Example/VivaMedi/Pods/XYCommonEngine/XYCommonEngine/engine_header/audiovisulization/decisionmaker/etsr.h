/**
* @author  Jonathan
*
* @version  v2.0
*
* @history	1. init version - 02.09.2018
*			2. refine definition - 02.26.2018
**/


#ifndef ETSR_H
#define ETSR_H

#include "eteffectplugincomdef.h"

class CSR
{
public:
	CSR();
	virtual ~CSR();

	CSR* duplicate();
	TO_IMPLEMENT MRESULT match(TimePositions *tp, MVoid* otherInfo);

public:
	MDWord mMinLength;
	MDWord mMaxAppearCnt;
	MDWord mMinInterval;
};




#endif //endif of ETSR_H



