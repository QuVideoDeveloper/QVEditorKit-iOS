/**
 * @author  Jonathan
 *
 * @version  v1.0
 *
 * @history	1. init version - 02.24.2018
 *			2. refine definition - 02.26.2018
 **/



#ifndef ETOR_H
#define ETOR_H

#include "eteffectplugincomdef.h"

class CMusicFeatureDescriptor;
class COR		//OR = objective requirement
{
public:
	COR(){mType[0] = 0;}
	virtual ~COR(){}

	virtual COR* duplicate() = 0;
	virtual MRESULT match(CMusicFeatureDescriptor *mfd, MVoid* otherInfo, TimePositions &tp/*in, out*/) = 0;

public:
	MTChar mType[MAX_TYPE_CHAR_COUNT];
};




#endif //endif of ETOR_H




